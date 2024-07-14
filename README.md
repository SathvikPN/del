# `del` - Safe File Deletion Utility for Linux

`del` is a production-ready command-line utility for safely deleting files and directories in Linux. It moves files to a trash can instead of permanently deleting them, allowing you to recover accidentally deleted files. `del` also includes metadata about deleted files and has an automatic cleanup feature to manage your trash can efficiently.

## Features

- **Safe Deletion**: Moves files and directories to a trash can (`~/.local/share/Trash/files`) instead of permanently deleting them.
- **Metadata Storage**: Stores metadata (`deletedFrom` path and `deletedOn` date) alongside deleted files for easy recovery.
- **Automatic Cleanup**: Automatically deletes files from the trash can after a specified number of days.
- **Configurable**: Easily view and update configuration settings using `del --config`.
- **Versioning**: Provides version information and standard command help.
- **Verbose Mode**: outputs action done.
- **Periodic Cleanup**: Manages a cron job to periodically clean up old files from the trash can.
- **Easy Installation**: Simple installation script for quick setup.

## Installation

You can install `del` using the provided installation script. Ensure you have `curl` installed.

```sh
curl -fsSL https://raw.githubusercontent.com/SathvikPN/del/main/del_install.sh | sudo bash
```


### Example Usage

- **Move files to trash**:
  ```bash
  del file1 file2
  ```

- **Edit the configuration**:
  ```bash
  del --config
  ```

- **Show help**:
  ```bash
  del --help
  ```

- **Show version**:
  ```bash
  del --version
  ```

- **Verbose mode**:
  ```bash
  del --verbose file1 file2
  ```

- **Periodic cleanup (to be run via cron)**:
  ```bash
  del --cleanup
  ```

### Installation via `curl`

Users can install the script with:

```sh
curl -fsSL https://raw.githubusercontent.com/SathvikPN/del/main/del_install.sh | sudo bash
```