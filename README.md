# Claude Code Enhanced Statusline

A custom statusline script for Claude Code that displays model information, context window usage, directory, git branch, and date.

## Features

- Model name display
- Context window usage with visual progress bar
- Token percentage indicator
- Shortened directory path (last two segments)
- Git branch information
- Current date in MM-DD-YYYY format
- Color-coded output for better readability

## Visual Output

The statusline displays information in the following format:

```
Sonnet 4.5 | ⏳ [████████░░] | 💭 80% | /GitHub/project |  main | 01-09-2026
```

**Color Scheme:**

- **Model Name** (Bright Blue): The Claude model being used
- **Progress Bar** (Cyan): Visual representation of context window usage
  - Filled blocks (█) show used context
  - Empty blocks (░) show remaining context
- **Percentage** (Yellow): Numeric percentage of context window used
- **Directory Path** (Bright Green): Last two segments of current working directory
- **Git Branch** (Bright Yellow): Current branch or commit hash with git icon ()
- **Date** (Bright Cyan): Current date in MM-DD-YYYY format
- **Separators** (Dark Gray): Pipe characters between sections

## Prerequisites

- Linux environment
- Bash shell
- jq (JSON processor)
- Git (optional, for branch display)
- Claude Code CLI installed

## Installation

### 1. Install jq

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y jq
```

**Fedora/RHEL/CentOS:**
```bash
sudo dnf install -y jq
```

**Arch Linux:**
```bash
sudo pacman -S jq
```

**Alpine Linux:**
```bash
apk add jq
```

### 2. Clone Repository

```bash
git clone https://github.com/yourusername/cc-statusline.git
cd cc-statusline
```

### 3. Make Script Executable

```bash
chmod +x statusline-enhanced.sh
```

### 4. Configure Claude Code

Add the statusline to your Claude Code configuration file located at `~/.claude/config.json`:

```json
{
  "statusline": {
    "enabled": true,
    "command": "/absolute/path/to/statusline-enhanced.sh"
  }
}
```

Replace `/absolute/path/to/` with the full path where you cloned the repository.

**Example:**
```json
{
  "statusline": {
    "enabled": true,
    "command": "/home/username/cc-statusline/statusline-enhanced.sh"
  }
}
```

### 5. Verify Installation

Restart Claude Code. The statusline should now appear at the bottom of your terminal showing:

```
Model | [Progress Bar] | Percentage% | /directory/path | branch | date
```

## Troubleshooting

**Statusline not appearing:**
- Verify jq is installed: `jq --version`
- Check script permissions: `ls -l statusline-enhanced.sh`
- Ensure full absolute path is used in config.json
- Restart Claude Code completely

**No git branch showing:**
- Ensure you are in a git repository
- Verify git is installed: `git --version`

**Script errors:**
- Check script syntax: `bash -n statusline-enhanced.sh`
- Test script manually: `echo '{"model":{"display_name":"test"},"workspace":{"current_dir":"'$(pwd)'"}}' | ./statusline-enhanced.sh`

## Customization

Edit `statusline-enhanced.sh` to modify:
- Progress bar width (line 26: `bar_width`)
- Date format (line 68: date format string)
- Color codes (lines with `\033[XXm`)
- Directory path depth (line 55: path segments)

## License

This is free and unencumbered software released into the public domain.
