# path to the Python brain — same folder as this plugin file
ZSH_NEXT_DIR="${0:A:h}"

# the function that runs on every keystroke
_zsh_next_suggest() {
    # read what the user has typed so far
    local current_cmd="${BUFFER}"
    
    # ask Python for a prediction — pass current command as argument
    local suggestion
    suggestion=$(python3 "$ZSH_NEXT_DIR/zsh_next.py" "$current_cmd" 2>/dev/null)
    
    # if Python returned something, show it as ghost text
    if [[ -n "$suggestion" ]]; then
        # POSTDISPLAY is zsh's ghost text area — appears after cursor, greyed out
        POSTDISPLAY=" $suggestion"
    else
        POSTDISPLAY=""
    fi
}
# register our function as a ZLE widget
zle -N _zsh_next_suggest

# hook — runs every time user types a keystroke
_zsh_next_keypress() {
    # let zsh process the keystroke normally first
    zle self-insert
    # then run our predictor
    _zsh_next_suggest
}
zle -N _zsh_next_keypress

# bind every printable character to our keypress handler
bindkey -s '' ''
for key in {a..z} {A..Z} {0..9} ' ' '/' '-' '_' '.'; do
    bindkey "$key" _zsh_next_keypress
done

# accept suggestion when user presses → (right arrow)
_zsh_next_accept() {
    # move POSTDISPLAY into the actual buffer
    BUFFER="$BUFFER$POSTDISPLAY"
    POSTDISPLAY=""
    # move cursor to end
    zle end-of-line
}
zle -N _zsh_next_accept
bindkey "^[[C" _zsh_next_accept

# clear ghost text when user presses Enter
_zsh_next_clear() {
    POSTDISPLAY=""
    zle accept-line
}
zle -N _zsh_next_clear
bindkey "^M" _zsh_next_clear