#!/bin/bash

DESKTOP_DIR="$HOME/.local/share/applications"
TOOL_TAG="generated-by-launchgen"

function count_launchers() {
    grep -rl "$TOOL_TAG" "$DESKTOP_DIR" | wc -l
}

function create_launcher() {
    read -p "Enter App Name: " APP_NAME
    [ -z "$APP_NAME" ] && echo "❌ App name is required!" && return

    read -e -p "Enter Full Project Folder Path: " PROJECT_DIR
    [ -z "$PROJECT_DIR" ] && echo "❌ Project folder path is required!" && return

    read -p "Enter Run Command (e.g., python3 manage.py runserver): " RUN_COMMAND
    [ -z "$RUN_COMMAND" ] && echo "❌ Run command is required!" && return

    read -p "Enter IP (optional): " IP
    read -p "Enter Port (optional): " PORT

    read -e -p "Enter Virtual Environment Path (optional): " VENV_PATH
    read -e -p "Enter Icon Path (optional): " ICON_PATH

    [[ ! -f "$ICON_PATH" ]] && ICON_PATH="/usr/share/pixmaps/tux.png"

    EXEC_CMD="cd \"$PROJECT_DIR\" && "
    [ -n "$VENV_PATH" ] && EXEC_CMD+="source \"$VENV_PATH/bin/activate\" && "
    EXEC_CMD+="$RUN_COMMAND"
    [ -n "$IP" ] && EXEC_CMD+=" $IP"
    [ -n "$PORT" ] && EXEC_CMD+=" $PORT"

    FILE_NAME="${APP_NAME// /_}.desktop"
    DESKTOP_FILE="$DESKTOP_DIR/$FILE_NAME"

    cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=bash -c '$EXEC_CMD'
Icon=$ICON_PATH
Type=Application
Terminal=true
Categories=Development;
X-Launcher-Tool=$TOOL_TAG
EOF

    chmod +x "$DESKTOP_FILE"
    echo "✅ Created: $DESKTOP_FILE"
}

function list_launchers() {
    grep -rl "$TOOL_TAG" "$DESKTOP_DIR"
}

function delete_launcher() {
    echo "Select a launcher to delete:"
    select file in $(list_launchers); do
        [ -z "$file" ] && echo "Invalid choice!" && return
        rm "$file"
        echo "🗑️ Deleted: $file"
        break
    done
}

function edit_launcher() {
    echo "Select a launcher to edit:"
    select file in $(list_launchers); do
        [ -z "$file" ] && echo "Invalid choice!" && return
        ${EDITOR:-nano} "$file"
        echo "✏️ Edited: $file"
        break
    done
}

while true; do
    echo -e "\n--- Launcher Tool ---"
    echo "1. Create New Launcher"
    echo "2. Edit Existing Launcher"
    echo "3. Delete Launcher"
    echo "4. Count Launchers"
    echo "5. Exit"
    read -p "Choose an option [1-5]: " choice

    case $choice in
        1) create_launcher ;;
        2) edit_launcher ;;
        3) delete_launcher ;;
        4) echo "📦 Total launchers created: $(count_launchers)" ;;
        5) exit 0 ;;
        *) echo "❌ Invalid option!" ;;
    esac
done
