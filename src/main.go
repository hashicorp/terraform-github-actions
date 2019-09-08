package main

import (
	"archive/zip"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

func main() {
	tfVersion := os.Getenv("INPUT_TERRAFORM_VERSION")
	if tfVersion == "" {
		log.Fatalln("Input terraform_version cannot be empty")
	}

	tfSubcommand := os.Getenv("INPUT_TERRAFORM_SUBCOMMAND")
	if tfSubcommand == "" {
		log.Fatalln("Input terraform_subcommand cannot be empty")
	}

	log.Printf("Installing Terraform v%s", tfVersion)
	err := installTerraform(tfVersion, "/usr/local/bin")
	if err != nil {
		log.Fatalln(err)
	}
}

func installTerraform(version string, path string) error {
	url := fmt.Sprintf("https://releases.hashicorp.com/terraform/%s/terraform_%s_linux_amd64.zip", version, version)
	filename := path + "/terraform_" + version

	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	tmpfile, err := ioutil.TempFile("", "terraform")
	if err != nil {
		return err
	}
	defer os.Remove(tmpfile.Name())

	_, err = io.Copy(tmpfile, resp.Body)
	if err != nil {
		return err
	}

	r, err := zip.OpenReader(tmpfile.Name())
	if err != nil {
		return err
	}
	defer r.Close()

	for _, f := range r.File {
		if f.Name == "terraform" {
			rc, err := f.Open()
			if err != nil {
				return err
			}
			defer rc.Close()

			content, err := ioutil.ReadAll(rc)
			if err != nil {
				return err
			}

			err = ioutil.WriteFile(filename, content, 0755)
			if err != nil {
				return err
			}
		}
	}
	return nil
}
