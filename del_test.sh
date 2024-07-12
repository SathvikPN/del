#!/bin/bash

# Path to the del.sh script
DEL_SCRIPT_PATH="./del.sh"  # Update with the actual path

# Create temporary test files
TRASH_DIR="$HOME/.trash_directory"

echo "creating up test files..."
for i in {1..3}; do 
    touch "testfile$i.txt"
    echo -n "testfile$i.txt     "
done
echo 

# Run the del script
echo "Running del..."
set -o posix
bash "$DEL_SCRIPT_PATH" -v testfile1.txt testfile2.txt testfile3.txt
set +o posix

# Check if files were moved to the trash directory
if ls $TRASH_DIR/testfile1* >/dev/null 2>&1 && \
   ls $TRASH_DIR/testfile2* >/dev/null 2>&1 && \
   ls $TRASH_DIR/testfile3* >/dev/null 2>&1; then
  echo "Test passed: Files were moved to the trash directory successfully."
else
  echo "Test failed: Not all files were moved to the trash directory."
  ls "$TRASH_DIR" | grep $TRASH_DIR/testfile*.txt_*  
fi

# Clean up

rm -f $TRASH_DIR/testfile*.txt_*
echo "Cleaned test files"
echo "del test finished"
