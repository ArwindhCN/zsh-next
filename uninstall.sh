#!/bin/bash
# zsh-next uninstaller

echo "Uninstalling zsh-next..."

# Step 1 — remove plugin folder
if [ -d "$HOME/.zsh-next" ]; then
    rm -rf "$HOME/.zsh-next"
    echo " Removed ~/.zsh-next"
else
    echo "  ~/.zsh-next not found — already uninstalled?"
fi

# Step 2 — remove lines from ~/.zshrc
ZSHRC="$HOME/.zshrc"
sed -i '' '/# zsh-next — smart terminal suggestions/d' "$ZSHRC"
sed -i '' '/source ~\/.zsh-next\/zsh-next.plugin.zsh/d' "$ZSHRC"
echo "Removed from ~/.zshrc"

# Step 3 — tell user to restart
echo ""
echo " zsh-next uninstalled."
echo "   Restart your terminal to fully remove ZLE hooks."