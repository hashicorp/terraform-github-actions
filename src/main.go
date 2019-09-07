package main

import (
	"archive/zip"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
)

func main() {
	if os.Getenv("INPUT_TERRAFORM_VERSION") == "" {
		log.Fatalln("Input terraform_version cannot be empty")
	}
	fmt.Printf("INPUT_TERRAFORM_VERSION: %s\n", os.Getenv("INPUT_TERRAFORM_VERSION"))
	fmt.Printf("INPUT_TERRAFORM_VERSION (type): %T\n", os.Getenv("INPUT_TERRAFORM_VERSION"))
	if os.Getenv("INPUT_TERRAFORM_SUBCOMMAND") == "" {
		log.Fatalln("Input terraform_subcommand cannot be empty")
	}
	fmt.Printf("INPUT_TERRAFORM_SUBCOMMAND: %s\n", os.Getenv("INPUT_TERRAFORM_SUBCOMMAND"))
	err := downloadTerraform(os.Getenv("INPUT_TERRAFORM_VERSION"))
	if err != nil {
		log.Fatalln("ERROR")
	}
	out, err := exec.Command("ls", "-la", "/usr/local/bin").Output()
	if err != nil {
		log.Fatalln("ERROR")
	}
	fmt.Printf("%s", out)
}

func downloadTerraform(version string) error {
	url := fmt.Sprintf("https://releases.hashicorp.com/terraform/%s/terraform_%s_linux_amd64.zip", version, version)
	filename := fmt.Sprintf("terraform_%s_linux_amd64.zip", version)

	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	out, err := os.Create("/tmp" + filename)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, resp.Body)
	if err != nil {
		return err
	}

	cmd, err := os.Create(fmt.Sprintf("/usr/local/bin/terraform_%s", version))
	if err != nil {
		return err
	}
	err = cmd.Chmod(0755)
	if err != nil {
		return err
	}
	defer cmd.Close()

	r, err := zip.OpenReader("/tmp" + filename)
	if err != nil {
		return err
	}
	defer r.Close()

	for _, f := range r.File {
		if f.Name == "terraform" {
			tf, err := f.Open()
			if err != nil {
				return err
			}
			defer tf.Close()
			_, err = io.Copy(cmd, tf)
			if err != nil {
				return err
			}
		}
	}
	return nil
}
