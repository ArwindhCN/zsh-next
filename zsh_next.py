import sys
from pathlib import Path
from collections import defaultdict

def load_history():
    history_file = Path.home() / ".zsh_history"
    
    commands = []
    
    with open(history_file, "r", errors="ignore") as f:
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

def predict(current_cmd, table):
    if current_cmd not in table or not table[current_cmd]:
        return None 
        
    possibilities = table[current_cmd]
    
    best_prediction = max(possibilities, key=possibilities.get)
    return best_prediction

if __name__ == "__main__":
    # sys.argv[1] is the command zsh passes in
    current_cmd = sys.argv[1].strip()
    
    commands = load_history()
    table = build_bigram_table(commands)
    
    prediction = predict(current_cmd, table)
    
    if prediction:
        # print to stdout — zsh reads this
        print(prediction)