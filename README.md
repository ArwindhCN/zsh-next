# zsh-next 

> Smart next-command prediction for your terminal — because your shell should know what you're about to type.

Unlike `zsh-autosuggestions` which only replays history, `zsh-next` learns your **workflow sequences** and predicts what comes next.

---

## Demo
![zsh-next demo](demo.gif)

---

## Install

```bash
git clone https://github.com/ArwindhCN/zsh-next.git
cd zsh-next
bash install.sh
```

Restart your terminal — done.

---

## How it works
- Reads your `~/.zsh_history`
- Builds a bigram frequency table of command sequences
- Predicts the most likely next command as ghost text
- Press `→` to accept. Keep typing to ignore.

---

## Roadmap
- [ ] Trigram model (3-command sequences)
- [ ] Crowd-sourced community model (opt-in)
- [ ] brew install support

---

## License
MIT