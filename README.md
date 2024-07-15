# del
A recycle bin utility for your Linux bash terminal.

- `del` moves files to a trash can instead of permanently deleting them, allowing you to recover accidentally deleted files from bash terminal. 
- `del` also includes metadata about deleted files, when, where and by whom it was deleted. 
- `del` has an automatic cleanup feature to manage your trash can efficiently.
- `del` is configurable to set number of days to keep deleted files and schedule day in a month to run this automatically.

> del is an wrapper around `mv` `rm` and `crontab`


# Installation
Download & Install del from source repo
```bash
curl -fsSL https://raw.githubusercontent.com/SathvikPN/del/main/del_install.sh | sudo bash
```
