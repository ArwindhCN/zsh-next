#!/bin/bash
# zsh-next installer

echo "Installing zsh-next..."

# Step 1 — check Python3 is installed
if ! command -v python3 &>/dev/null; then
    echo " Python3 not found. Please install it first."
    echo "   brew install python3"
    exit 1
fi

echo "Python3 found"
# Step 2 — check zsh is the active shell
if [ "$SHELL" != "/bin/zsh" ]; then
    echo " Your shell is not zsh. zsh-next is built for zsh."
    echo "   Run: chsh -s /bin/zsh"
    exit 1
fi

echo "zsh found"

# Step 3 — copy plugin to home directory
ZSH_NEXT_HOME="$HOME/.zsh-next"

if [ -d "$ZSH_NEXT_HOME" ]; then
    echo " ~/.zsh-next already exists — reinstalling..."
    rm -rf "$ZSH_NEXT_HOME"
fi

mkdir -p "$ZSH_NEXT_HOME"
cp zsh-next.plugin.zsh "$ZSH_NEXT_HOME/"
cp zsh_next.py "$ZSH_NEXT_HOME/"

echo " Plugin files copied to ~/.zsh-next"

# Step 4 — add source line to ~/.zshrc if not already there
ZSHRC="$HOME/.zshrc"
SOURCE_LINE="source ~/.zsh-next/zsh-next.plugin.zsh"

if grep -qF "$SOURCE_LINE" "$ZSHRC" 2>/dev/null; then
    echo " ~/.zshrc already configured"
else
    echo "" >> "$ZSHRC"
    echo "# zsh-next — smart terminal suggestions" >> "$ZSHRC"
    echo "$SOURCE_LINE" >> "$ZSHRC"
    echo " Added to ~/.zshrc"
fi

echo ""
echo "🎉 zsh-next installed. Restart your terminal or run: source ~/.zshrc"