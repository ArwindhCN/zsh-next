ZSH_NEXT_DIR="${0:A:h}"

_zsh_next_suggest() {
    local suggestion
    suggestion=$(python3 "$ZSH_NEXT_DIR/zsh_next.py" "${BUFFER}" 2>/dev/null)
    
    if [[ -n "$suggestion" ]]; then
        POSTDISPLAY=" ${suggestion}"
        local buf_len=${#BUFFER}
        local total_len=$(( buf_len + ${#POSTDISPLAY} ))
        region_highlight=("${buf_len} ${total_len} fg=240")
    else
        POSTDISPLAY=""
        region_highlight=()
    fi
}
zle -N _zsh_next_suggest

_zsh_next_keypress() {
    zle self-insert
    _zsh_next_suggest
}
zle -N _zsh_next_keypress

if [[ -o zle ]]; then
    for key in {a..z} {A..Z} {0..9}; do
        bindkey "$key" _zsh_next_keypress
    done
    bindkey ' ' _zsh_next_keypress
    bindkey '/' _zsh_next_keypress
    bindkey '_' _zsh_next_keypress
    bindkey '.' _zsh_next_keypress
    bindkey "^[[C" _zsh_next_accept
    bindkey "^M" _zsh_next_clear
fi

_zsh_next_accept() {
    BUFFER="${BUFFER} && ${POSTDISPLAY}"
    POSTDISPLAY=""
    region_highlight=()
    zle end-of-line
}
zle -N _zsh_next_accept
bindkey "^[[C" _zsh_next_accept

_zsh_next_clear() {
    POSTDISPLAY=""
    region_highlight=()
    zle accept-line
}
zle -N _zsh_next_clear
bindkey "^M" _zsh_next_clear