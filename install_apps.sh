#!/usr/bin/env bash

source .private_script_helpers/colors.sh
source .private_script_helpers/require.sh

# ---------------
# Brew
# ---------------
bot "Installing Homebrew"
# TODO: Check failure
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit 2
fi
brew update
brew upgrade
brew cask upgrade
RUBY_CONFIGURE_OPTS="--with-openssl-dir=`brew --prefix openssl` --with-readline-dir=`brew --prefix readline` --with-libyaml-dir=`brew --prefix libyaml`"
require_brew ruby

# ---------------
# Dependencies
# ---------------
bot "Installing dependencies"
require_brew git
require_brew mas
require_brew fontconfig

# ---------------
# Communication
# ---------------
bot "Installing communication tools"
require_cask slack
require_cask telegram
require_cask skype-for-business
require_cask caprine

# ---------------
# Mail
# ---------------
bot "Installing communication tools"
require_mas "Spark" "1176895641"

# ---------------
# Media
# ---------------
bot "Installing Media"
require_cask spotify

# ---------------
# TextEditor
# ---------------
bot "Installing Text Editors"
require_mas "Xcode" "497799835"
require_brew neovim
require_cask visual-studio-code
require_cask atom

# ---------------
# Desktop Utility
# ---------------
bot "Installing Desktop Utilities"
require_mas "Keynote" "409183694"
require_mas "Numbers" "409203825"
require_mas "Pages" "409201541"

# ---------------
# Utility
# ---------------
bot "Installing Utilities"
require_brew git-flow
require_brew fish
require_cask iterm2
require_cask google-chrome
require_cask dashlane
require_cask boom-3d
require_cask daisydisk

# ---------------
# Virtualization
# ---------------
bot "Installing Virtualization tools"
require_cask docker

# ---------------
# Configuration
# ---------------
bot "Configuring installation"

# Set Fish as default shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/fish" ]]; then
  bot "Setting newer homebrew fish (/usr/local/bin/fish) as your shell (password required)"
  # sudo bash -c 'echo "/usr/local/bin/fish" >> /etc/shells'
  # chsh -s /usr/local/bin/fish
  sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/fish > /dev/null 2>&1
  ok
fi

bot "Installing fonts"
./fonts/install.sh
brew tap caskroom/fonts
require_cask font-fontawesome
require_cask font-awesome-terminal-fonts
require_cask font-hack
require_cask font-inconsolata-dz-for-powerline
require_cask font-inconsolata-g-for-powerline
require_cask font-inconsolata-for-powerline
require_cask font-roboto-mono
require_cask font-roboto-mono-for-powerline
require_cask font-source-code-pro
ok

if [[ -d "/Library/Ruby/Gems/2.0.0" ]]; then
  running "Fixing Ruby Gems Directory Permissions\n"
  sudo chown -R $(whoami) /Library/Ruby/Gems/2.0.0
  ok
fi

# Configure shell
bot "Configuring shell fish"
running "Installing omf\n"
curl -L https://get.oh-my.fish | fish
running "Installing bobthefish theme\n"
fish -c "omf install bobthefish"
running "Installing Fish custom configuration\n"
cp ./fish/config.fish $HOME/.config/fish/config.fish
rsync -a ./fish/functions/ $HOME/.config/fish/functions/

# Configure git
# TODO

# Configure Caprine
./caprine/install.sh

# Configure Spark
# TODO

# Configure Neovim
# TODO (Keep it installed on mac ?)

# Configure VSCode
# TODO

# Configure Atom
# TODO

# Configure iTerm2
# TODO

# Configure Google-Chrome
# TODO

# Configure Dashlane
# TODO

# Configure Boom3D
# TODO

# Configure DaisyDisk
# TODO

# ---------------
# Cleanup
# ---------------

running "Cleaning-up homebrew\n"
brew cleanup > /dev/null 2>&1
ok