# Auto Delete App

## Overview
The **Auto Delete App** is designed to help users register tasks for automatic deletion of files or folders at a future time. This tool is particularly useful for automating cleanup tasks and managing data retention policies.

## Features
- [x] Register tasks for future file or folder deletion (Supported delete file or folder direcly after trigger time is passed).
- [ ] Unregister tasks.

## Project Structure
```
├──main\        # Root project directory
├──├──gui\      # GUI application scripts
├──├──logic\    # Logical script
├──utils\       # Utilities code for supporting project
├──execute.bat  # Execute application
```

## Usage
### Registering a Task:
1. Open the application by running execute.bat.
2. Select a file or folder to be deleted.
3. Set the desired date and time for deletion.
4. Click Register Task to schedule the deletion.

### Unregistering a Task (Coming Soon):
- This feature will allow users to remove scheduled deletion tasks.

## Notes
- This application is under development and is intended for internal workflow automation purposes.
- Make sure you provide a valid file or folder path when registering a task.

## Repo Owner
* Bastian Armananta