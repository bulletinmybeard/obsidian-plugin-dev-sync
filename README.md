# Obsidian Plugin Development Sync
A Bash script to seamlessly synchronize Obsidian plugin projects with Obsidian vaults. It leverages `rsync` and `fswatch` for real-time development across different devices.

> Works on Linux and macOS (including iCloud vaults for mobile testing).

This script syncs all necessary Obsidian plugin files, including the essential `main.js` and `manifest.json`, for plugin functionality in both desktop and mobile versions of Obsidian.

## Prerequisites
- Install `rsync` and `fswatch` on your system.
- Make the script executable with `chmod +x sync_plugin.sh`.
- Adjust the `watch_items` array in the script to specify files and directories for synchronization.

## Usage
Execute the script, specifying the target plugin base directory, e.g., `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/<your_vault_name>/.obsidian/plugins/`.
This will create a plugin directory at this path, named after the directory from which you execute the script.

Initial synchronization covers everything in `watch_items`, with continuous monitoring and syncing of changes.

```bash
watch_items=(
    "$source_dir/main.js",
    "$source_dir/styles.css",
    "$source_dir/manifest.json",
    "$source_dir/data.json",
    "$source_dir/assets",
    "$source_dir/cache"
)
