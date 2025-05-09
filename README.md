


## Docker commands

```bash
docker logs --tail 50 --follow --timestamps nginx-flask-mysql-backend-1
docker compose down # Stop and remove containers, networks
docker system prune --volumes --force # Remove unused data; Prune anonymous volumes
docker compose up --build # Create and start containers; Build images before starting containers
docker compose up --build --force-recreate # Create and start containers; Build images before starting containers; Recreate containers even if their configuration and image haven't changed
docker image list --format json | jq -r '.ID' | xargs -I {} docker image rm {} --force # rm all images
```

## Other setup steps

Docker autocompletion was extremely slow
Fixed by appending below lines to /etc/wsl.conf
src: https://github.com/microsoft/WSL/issues/4234

```conf
[interop]
appendWindowsPath = false
```

## Installed apps

```bash
# https://github.com/ajeetdsouza/zoxide
# https://github.com/dvorka/hstr
# https://cloud.google.com/sdk/docs/install#deb

sudo apt install -y jq python3.12-venv

# tenv
# src: https://github.com/tofuutils/tenv
LATEST_VERSION=$(curl --silent https://api.github.com/repos/tofuutils/tenv/releases/latest | jq -r .tag_name)
curl -O -L "https://github.com/tofuutils/tenv/releases/latest/download/tenv_${LATEST_VERSION}_amd64.deb"
sudo dpkg -i "tenv_${LATEST_VERSION}_amd64.deb"



# glcoud
# When installing gcloud src:https://cloud.google.com/sdk/docs/install#deb
# Also install kubectl and gke-gcloud-auth-plugin
sudo apt-get install -y google-cloud-cli kubectl google-cloud-cli-gke-gcloud-auth-plugin

```

## Installing Rancher Desktop & Docker

Rancher Desktop on Windows requires installing Docker on given Linux distribution
Used commands like below (not an exact instruction):

```bash
# src: https://www.geeksforgeeks.org/install-and-use-docker-on-ubuntu-2204/
# src: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
# src: https://docs.docker.com/engine/install/linux-postinstall/
sudo apt-get install wget ca-certificates
sudo apt autoremove
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker ps
sudo systemctl status docker
echo ${USER}
sudo usermod -aG docker ${USER}
su - ${USER}
exit
docker ps
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

### Error

```
pw@GFT-5JF71F3:~/repos/docker-curriculum/flask-app$ docker build -t flask .
[+] Building 0.5s (2/2) FINISHED                                                                       docker:default
 => [internal] load build definition from Dockerfile                                                             0.0s
 => => transferring dockerfile: 336B                                                                             0.0s
 => ERROR [internal] load metadata for docker.io/library/python:latest                                           0.5s
------
 > [internal] load metadata for docker.io/library/python:latest:
------
Dockerfile:1
--------------------
   1 | >>> FROM python
   2 |     
   3 |     # set a directory for the app
--------------------
ERROR: failed to solve: python: failed to resolve source metadata for docker.io/library/python:latest: error getting credentials - err: exit status 1, out: `GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name org.freedesktop.secrets was not provided by any .service files`
```

### Solution


```bash
sudo apt install -y gnome- # src: https://github.com/moby/buildkit/issues/1078#issuecomment-577450070
```



### Error

Failure during terragrunt call : fork/exec /usr/bin/tenv: inappropriate ioctl for device

### Solution

```bash
export TENV_DETACHED_PROXY="false" # used to fix problems "emeraldwalk.runonsave" vscode extension autoformatting .hcl files on save. src: https://github.com/tofuutils/tenv/issues/305
```