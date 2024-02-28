# Resolve absolute path from relative path.
resolve_absolute_path() {
    echo "$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
}

# Check if file exists.
check_file_exists() {
    if [ ! -e "$1" ]; then
        echo "Error: $1 not found."
        exit 1
    fi
}

# Check if the target path is provided.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target_plugin_base_directory>"
    exit 1
fi

# Assign argument to variable, resolving absolute path.
target_plugin_base_dir=$(resolve_absolute_path "$1")

# Synchronize files and folders.
sync_files() {
    rsync -av --delete "$1" "$2"
}

# Perform initial synchronization.
source_dir="$(pwd)"
folder_name="$(basename "$source_dir")"
target_dir="${target_plugin_base_dir%/}/$folder_name"

# Check if source directory exists.
if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory $source_dir not found."
    exit 1
fi

# Check if target directory exists, if not, create it.
mkdir -p "$target_dir"

# Check for mandatory files.
check_file_exists "$source_dir/manifest.json"
check_file_exists "$source_dir/main.js"

# Array of files and directories to watch.
watch_items=(
    "$source_dir/main.js"
    "$source_dir/styles.css"
    "$source_dir/manifest.json"
    "$source_dir/data.json"
    "$source_dir/assets"
    "$source_dir/cache"
)

# Perform checks and synchronization for optional files and directories.
for item in "${watch_items[@]}"; do
    if [ -e "$item" ]; then
        sync_files "$item" "$target_dir/"
        echo "$(basename "$item") synchronized successfully."
    else
        echo "Warning: $(basename "$item") not found."
    fi
done

echo "Initial files synchronized successfully."

# Watch for changes.
fswatch -0 "${watch_items[@]}" | while IFS= read -r -d "" path; do
    # Resolve the absolute path of the changed item.
    source_path="$(resolve_absolute_path "$path")"

    if [ ! -e "$source_path" ]; then
        echo "Handling deletion for $path"
        # Determine if the deleted path was a directory that is directly watched.

        if echo "${watch_items[@]}" | grep -wq "$path"; then
            # Handle its deletion.
            relative_path="$(echo "$path" | sed "s|^$source_dir||")"
            target_subdir="${target_plugin_base_dir%/}/$folder_name$relative_path"
            # Remove the corresponding directory in the target.
            rm -rf "$target_subdir"
            echo "Directory $path deleted and changes reflected in the target."
        else
            # Handle deletion of files or non-directly watched directories.
            relative_path="$(echo "$path" | sed "s|^$source_dir||")"
            target_subdir="${target_plugin_base_dir%/}/$folder_name$(dirname "$relative_path")"
            # Synchronize the parent directory of the deleted item with deletion reflected.
            rsync -av --delete "${source_dir}$(dirname "$relative_path")/" "${target_subdir}/"
            echo "Deletion processed for $path"
        fi
    else
        # Handling for additions and modifications.
        if [ -d "$source_path" ] || [ -f "$source_path" ]; then
            # Sync the changed item directly.
            relative_path="$(echo "$path" | sed "s|^$source_dir||")"
            target_subdir="${target_plugin_base_dir%/}/$folder_name$(dirname "$relative_path")"
            rsync -av --delete "$source_path" "$target_subdir/"
            echo "Updated $path"
        fi
    fi
done
