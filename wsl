#############
# Install WSL
#############

# Install Debian
wsl --install Debian

####################
# MANUAL INPUT START
####################

# Create usernname
# Create password
# Confirm password

##################
# MANUAL INPUT END
##################

# Navigate to user root
cd

# Inital update and upgrade
sudo apt update
sudo apt upgrade -y

####################
# MANUAL INPUT START
####################

# Enter sudo password

##################
# MANUAL INPUT END
##################

# Install initial dependencies
sudo apt install software-properties-common apt-transport-https wget curl gpg -y

# Adjust package sources
sudo sed -i '/^deb cdrom:/s/^/# /' /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bookworm main" | sudo tee -a /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security bookworm-security main" | sudo tee -a /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bookworm-updates main" | sudo tee -a /etc/apt/sources.list

#############
# Install git
#############

sudo apt install git -y
# Configure git user
git config --global user.name MarvinWeitz
git config --global user.email dev@marvinweitz.com
# Configure pull behavior
git config --global pull.rebase true
git config --global rerere.enabled true
# Configure push behavior
git config --global push.default upstream
git config --global branch.autoSetupMerge simple
# Output config
git config --global column.ui auto
git config --global branch.sort -committerdate
# Configure alias
git config --global alias.staash 'stash --all'
git config --global alias.bblame 'blame -w -C -C -C'
git config --global alias.lol 'log --oneline --decorate'
git config --global alias.graph 'log --oneline --graph'
git config --global alias.publish '!git push --set-upstream origin $(git branch --show-current)'
git config --global alias.cleanup-branches '!f() {
  protected=$(git config --get cleanup.protectedBranches | tr "," " ");
  current_branch=$(git symbolic-ref --short HEAD);
  deleted_any=false;

  for branch in $(git branch --format="%(refname:short)"); do
    skip=false;
    [ "$branch" = "$current_branch" ] && skip=true;
    for p in $protected; do
      [ "$branch" = "$p" ] && skip=true && break;
    done;
    if [ "$skip" = true ]; then
      continue;
    fi

    upstream=$(git for-each-ref --format="%(upstream:short)" refs/heads/"$branch")
    if [ -z "$upstream" ]; then
      echo "  Skipping $branch - No upstream tracking branch"
      continue;
    fi

    if git branch -d "$branch" >/dev/null 2>&1; then
      if [ "$deleted_any" = false ]; then
        echo "Deleting branches:";
        deleted_any=true;
      fi
      echo "  $branch - Remote: $upstream"
    else
      echo "Not deleting $branch - Remote: $upstream (not merged or has unpushed commits)"
    fi
  done

  if [ "$deleted_any" = false ]; then
    echo "No branches to delete."
  fi
}; f'



#############
# Install zsh
#############

# Install zsh
sudo apt install zsh -y

# Configure auto navigation when starting from Windows user directory
# MULTILINE COMMAND START
cat >> ~/.zshrc << 'EOF'

# Auto-navigate to home directory when starting from Windows user directory
if [[ "$PWD" == /mnt/c/Users/* ]]; then
    cd ~
fi
EOF
# MULTILINE COMMAND END

# Set zsh as default shell
chsh -s $(which zsh)

#######################
# Install Powerlevel10k
#######################

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --no-completion --no-key-bindings --no-update-rc



##############
# Install node
##############

# Add NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
# Install node
sudo apt install nodejs -y


###########################
# Install dev node packages
###########################

# Upgrade to latest npm version
sudo npm install -g npm@latest

# Packages for CAP
sudo npm i -g @sap/cds-dk mbt typescript ts-node

# Packages for UI5 and Fiori
sudo npm i -g yo @sap/generator-fiori generator-easy-ui5 


###########################
# Enable YubiKey Usage
###########################

# Create necessary directories
mkdir -p ~/.ssh
# Install socat
sudo apt install socat scdaemon -y
# Install wsl2-ssh-pagent
wget https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/download/v1.4.0/wsl2-ssh-pageant.exe -O ~/.ssh/wsl2-ssh-pageant.exe
chmod +x ~/.ssh/wsl2-ssh-pageant.exe

##########################
# Install CloudFoundry CLI
##########################

# Add CF public key
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo gpg --dearmor -o /usr/share/keyrings/cli.cloudfoundry.org.gpg
# Add CF repository
echo "deb [signed-by=/usr/share/keyrings/cli.cloudfoundry.org.gpg] https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
# Update local package
sudo apt-get update
# Install cf CLI v8
sudo apt-get install cf8-cli

###################
# Install Miniconda
###################

# Note: Keep at the end of scirpt to prevent re-entering sudo password

# Make temp dir
mkdir -p ~/miniconda3
# Download installation script
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
# Run installation script in silent mode
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
# Remove installation script
rm ~/miniconda3/miniconda.sh

# Refresh terminal
source ~/miniconda3/bin/activate

# Initialze conda
conda init --all


##################################
# Install VC Code Server for Linux
##################################

# Trigger install
code -v
