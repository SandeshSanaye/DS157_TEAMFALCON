rm -rf ~/.nvm
apt-get -y install build-essential libssl-dev
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"
[ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"
a
nvm install v10.20.1
nvm use v10.20.1

source ~/.profile
