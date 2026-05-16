import sys
import json
import os
from pathlib import Path
from collections import defaultdict

HISTORY_FILE = Path.home() / ".zsh_history"
CACHE_FILE = Path.home() / ".zsh-next" / "cache.json"

def load_history():
    commands = []
    with open(HISTORY_FILE, "r", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if ";" in line and line.startswith(":"):
                cmd = line.split(";", 1)[1].strip()
            else:
                cmd = line
            commands.append(cmd)
    return commands

def build_bigram_table(commands):
    table = defaultdict(lambda: defaultdict(int))
    for i in range(len(commands) - 1):
        current = commands[i]
        next_cmd = commands[i + 1]
        table[current][next_cmd] += 1
    return table

def load_cache():
    # check if cache exists and is newer than history file
    if CACHE_FILE.exists():
        cache_mtime = CACHE_FILE.stat().st_mtime
        history_mtime = HISTORY_FILE.stat().st_mtime
        if cache_mtime > history_mtime:
            with open(CACHE_FILE, "r") as f:
                return json.load(f)
    return None

def save_cache(table):
    # convert defaultdict to regular dict for JSON serialization
    serializable = {k: dict(v) for k, v in table.items()}
    with open(CACHE_FILE, "w") as f:
        json.dump(serializable, f)

def predict(current_cmd, table):
    if not current_cmd.strip():
        return None

    matches = [cmd for cmd in table if cmd.startswith(current_cmd)]
    
    if not matches:
        return None
    
    combined = defaultdict(int)
    for cmd in matches:
        for next_cmd, count in table[cmd].items():
            combined[next_cmd] += count
    
    return max(combined, key=combined.get)

if __name__ == "__main__":
    current_cmd = sys.argv[1].strip()
    
    # try cache first
    cached = load_cache()
    if cached:
        table = cached
    else:
        # rebuild and save cache
        commands = load_history()
        table = build_bigram_table(commands)
        save_cache(table)
    
    prediction = predict(current_cmd, table)
    
    if prediction:
        print(prediction)