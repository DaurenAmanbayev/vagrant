#!/bin/bash
# FINAL DEVOPS PROVISION FOR ALMALINUX 9

# 1. Base Tools
sudo dnf update -y
sudo dnf install -y dnf-plugins-core git curl wget unzip fzf zoxide

# 2. Docker & kubectl
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
sudo usermod -aG docker vagrant

ARCH=$(uname -m); [ "$ARCH" = "x86_64" ] && K8S_ARCH="amd64" || K8S_ARCH="arm64"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${K8S_ARCH}/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl

# 3. Aliases & History
cat << 'EOF' >> /home/vagrant/.bashrc
# Навигация
eval "$(zoxide init bash)"
alias cd='z'
source /usr/share/fzf/shell/key-bindings.bash
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# DevOps tools via Cyclenerd
alias devops='docker run -it --rm -v $(pwd):/data -v ~/.ssh:/root/.ssh:ro -v ~/.aws:/root/.aws -v ~/.config/gcloud:/root/.config/gcloud cyclenerd/cloud-tools-container'
alias terraform='devops terraform'
alias ansible='devops ansible'
alias aws='devops aws'
alias gcloud='devops gcloud'
EOF

sudo docker pull cyclenerd/cloud-tools-container:latest
