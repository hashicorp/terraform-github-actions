FROM mcr.microsoft.com/dotnet/core/runtime:3.1

RUN apt update
RUN apt upgrade
RUN apt install bash -y 
RUN apt install ca-certificates -y 
RUN apt install curl -y 
RUN apt install git -y 
RUN apt install jq -y 
RUN apt install openssh-server -y 
RUN apt install openssl -y 
RUN apt install zip -y 

COPY ["src", "/src/"]

ENTRYPOINT ["/src/main.sh"]
