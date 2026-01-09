#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# 1. Extract model display name
model_name=$(echo "$input" | jq -r '.model.display_name')

# 2. Calculate context window usage with tokens display and progress bar
usage=$(echo "$input" | jq '.context_window.current_usage')
if [ "$usage" != "null" ]; then
    # Sum all token types for current context
    input_tokens=$(echo "$usage" | jq '.input_tokens // 0')
    cache_creation=$(echo "$usage" | jq '.cache_creation_input_tokens // 0')
    cache_read=$(echo "$usage" | jq '.cache_read_input_tokens // 0')
    current_tokens=$((input_tokens + cache_creation + cache_read))

    # Get context window size
    window_size=$(echo "$input" | jq '.context_window.context_window_size')

    # Calculate percentage
    if [ "$window_size" -gt 0 ]; then
        pct=$((current_tokens * 100 / window_size))

        # Create progress bar (10 characters wide) with square brackets
        bar_width=10
        filled=$((pct * bar_width / 100))

        # Build progress bar
        bar="["
        for ((i=0; i<bar_width; i++)); do
            if [ $i -lt $filled ]; then
                bar+="█"
            else
                bar+="░"
            fi
        done
        bar+="]"

        # Format: ⏳ [progress bar] | 💭 percentage%
        context_tokens=$(printf '\u23f3 \033[36m%s\033[0m' "$bar")
        progress_info=$(printf '\U1f4ad \033[33m%d%%\033[0m' "$pct")
    else
        context_tokens=""
        progress_info=""
    fi
else
    context_tokens=""
    progress_info=""
fi

# 3. Get shortened directory (last two path segments with leading slash)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
# Extract last two directory segments with leading slash
shortened_dir=$(echo "$current_dir" | awk -F'/' '{if (NF>=2) print "/"$(NF-1)"/"$NF; else print "/"$NF}')

# 4. Get git branch (skip optional locks for performance)
if git -C "$current_dir" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git -C "$current_dir" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -z "$git_branch" ]; then
        git_branch=$(git -C "$current_dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    fi
else
    git_branch=""
fi

# 5. Get current date (without time) - MM-DD-YYYY format
date_only=$(date '+%m-%d-%Y')

# Build status line with format:
# Model | Context (current/total tokens) | [Progress bar] percentage% | shortened-directory | branch | date

# Output model name
printf "\033[94m%s\033[0m" "$model_name"

# Add context tokens if available
if [ -n "$context_tokens" ]; then
    printf " \033[90m|\033[0m %s" "$context_tokens"
fi

# Add progress info if available
if [ -n "$progress_info" ]; then
    printf " \033[90m|\033[0m %s" "$progress_info"
fi

# Add shortened directory
printf " \033[90m|\033[0m \033[92m%s\033[0m" "$shortened_dir"

# Add git branch if available (using color code 93 for bright yellow, distinct from percentage)
if [ -n "$git_branch" ]; then
    printf " \033[90m|\033[0m \ue0a0 \033[93m%s\033[0m" "$git_branch"
fi

# Add date
printf " \033[90m|\033[0m \033[96m%s\033[0m\n" "$date_only"
