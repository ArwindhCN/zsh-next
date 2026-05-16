# Changelog

## [1.0.0] — 2026-05-16

### Added
- Bigram-based next command prediction from shell history
- Ghost text suggestions via ZLE POSTDISPLAY
- Right arrow key to accept suggestion
- install.sh and uninstall.sh for one-command setup

## [1.1.0] — 2026-05-16

### Added
- Prefix matching — typing partial commands now triggers predictions
- Combined frequency scoring across all matching command sequences

## [1.2.0] — 2026-05-16

### Added
- Bigram table cache — reads from cache.json, only rebuilds when ~/.zsh_history changes
- Dramatically faster suggestions on large history files