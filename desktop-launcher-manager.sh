#!/bin/bash

DESKTOP_DIR="$HOME/.local/share/applications"

function select_existing_launcher() {
  SELECTED_FILE=$(ls "$DESKTOP_DIR"/*.desktop 2>/dev/null | xargs -n1 basename | zenity --list --title="Select a launcher to edit" --column="Launchers")
  echo "$DESKTOP_DIR/$SELECTED_FILE"
}

function edit_launcher() {
  FILE_TO_EDIT=$(select_existing_launcher)
  [ -z "$FILE_TO_EDIT" ] && zenity --error --text="No launcher selected!" && exit 1
  xdg-open "$FILE_TO_EDIT"
}

function count_launchers() {
  COUNT=$(ls "$DESKTOP_DIR"/*.desktop 2>/dev/null | wc -l)
  zenity --info --text="📦 You have created $COUNT launcher(s)."
}

function create_launcher() {
  # Ask for App Name
  APP_NAME=$(zenity --entry --title="App Name" --text="Enter the Application Name:")
  [ -z "$APP_NAME" ] && zenity --error --text="Application Name is required!" && exit 1

  # Ask for Project Folder
  PROJECT_DIR=$(zenity --file-selection --directory --title="Select Your Project Folder")
  [ -z "$PROJECT_DIR" ] && zenity --error --text="Project folder is required!" && exit 1

  # Ask for Run Command (e.g., python3 manage.py runserver or npm start)
  RUN_COMMAND=$(zenity --entry --title="Run Command" --text="Enter the base run command (e.g., python3 manage.py runserver):")
  [ -z "$RUN_COMMAND" ] && zenity --error --text="Run command is required!" && exit 1

  # Optional IP
  IP_ADDRESS=$(zenity --entry --title="IP Address (Optional)" --text="Enter IP to bind (e.g., 0.0.0.0 or 127.0.0.1):")
  
  # Optional Port
  PORT_NUMBER=$(zenity --entry --title="Port Number (Optional)" --text="Enter port number (e.g., 8000 or 3000):")

  # Add IP and PORT to command if given
  if [[ -n "$IP_ADDRESS" || -n "$PORT_NUMBER" ]]; then
    RUN_COMMAND="$RUN_COMMAND"
    [ -n "$IP_ADDRESS" ] && RUN_COMMAND="$RUN_COMMAND $IP_ADDRESS"
    [ -n "$PORT_NUMBER" ] && RUN_COMMAND="$RUN_COMMAND:$PORT_NUMBER"
  fi

  # Ask for virtual environment directory (optional)
  VENV_PATH=$(zenity --file-selection --directory --title="Select Virtual Environment Folder (optional)" 2>/dev/null)

  # Ask for Icon (optional)
  ICON_PATH=$(zenity --file-selection --title="Select Icon (optional)" --file-filter='Images | *.png *.svg' 2>/dev/null)
  if [ -z "$ICON_PATH" ]; then
    if [ -f "/usr/share/pixmaps/tux.png" ]; then
      ICON_PATH="/usr/share/pixmaps/tux.png"
    else
      ICON_PATH=""
    fi
  fi

  # Prepare Exec Command
  if [ -n "$VENV_PATH" ]; then
    EXEC_CMD="bash -c 'cd \"$PROJECT_DIR\" && source \"$VENV_PATH/bin/activate\" && $RUN_COMMAND'"
  else
    EXEC_CMD="bash -c 'cd \"$PROJECT_DIR\" && $RUN_COMMAND'"
  fi

  # Create desktop file
  DESKTOP_FILE="$DESKTOP_DIR/${APP_NAME// /_}.desktop"

  cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=$EXEC_CMD
Icon=$ICON_PATH
Type=Application
Terminal=true
Categories=Development;
EOF

  chmod +x "$DESKTOP_FILE"

  zenity --info --text="✅ Launcher created successfully!\n\n$DESKTOP_FILE"
}

# Main Menu
ACTION=$(zenity --list --radiolist \
  --title="Desktop App Manager" \
  --text="Choose an action:" \
  --column="Select" --column="Action" \
  TRUE "Create New Launcher" \
  FALSE "Edit Existing Launcher" \
  FALSE "Count Created Launchers")

case "$ACTION" in
  "Create New Launcher")
    create_launcher
    ;;
  "Edit Existing Launcher")
    edit_launcher
    ;;
  "Count Created Launchers")
    count_launchers
    ;;
  *)
    zenity --error --text="No valid option selected. Exiting."
    exit 1
    ;;
esac
