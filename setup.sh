# this script should download everything necessary to setup the environment
# make sure ubuntu is v24.04 or greater 

# make sure everthing is up to date first
sudo apt upgrade

echo "Checking for neovim..."
if ! snap list nvim &> /dev/null; then
    echo "nvim was not found. Installing nvim..."
    sudo snap install neovim
else
    echo "nvim was already installed"
fi


apt_pkgs=(
    "npm"
    "ripgrep"
)
for name in "${apt_pkgs[@]}"; do
    echo "Checking for $name..."
    if ! dpkg -s "$name" &> /dev/null; then
        echo "$name was not found. Installing $name..."
        sudo apt install "$name"
    else 
        echo "$name was already installed"
    fi
done


lines="
# SETUP ADDITIONS
# Aliases
alias rm=\"rm -iv\"

# NVIM
alias vim=nvim
alias vi=nvim
export MANPAGER='nvim +Man!'

# TMUX
export TMUX_CONF=\$HOME/.config/tmux/tmux.conf
tmux source-file \$TMUX_CONF
"

# grep is not good with multiline inputs so just check for the first
if ! grep -qF "# SETUP ADDITIONS" "$HOME/.bashrc"; then
    echo "$lines" >> "$HOME/.bashrc"
    echo "Lines added to .bashrc"
    source "$HOME/.bashrc"
else
    echo "Lines already in .bashrc"
fi
