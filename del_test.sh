#!/bin/bash

# Path to the del.sh script
DEL_SCRIPT_PATH="./del.sh"  # Update with the actual path

# Create temporary test files
TEST_FILE1="testfile1.txt"
TEST_FILE2="testfile2.txt"
TEST_FILE3="testfile3.txt"
TRASH_DIR="$HOME/.trash_directory"

# Setup test environment
echo "Setting up test files..."
echo "Test content" > "$TEST_FILE1"
echo "Test content" > "$TEST_FILE2"
echo "Test content" > "$TEST_FILE3"

# Run the del script
echo "Running del script..."
bash "$DEL_SCRIPT_PATH" -v "$TEST_FILE1" "$TEST_FILE2" "$TEST_FILE3"

# Check if files were moved to the trash directory
if ls "$TRASH_DIR/$(basename "$TEST_FILE1")"_* >/dev/null 2>&1 && \
   ls "$TRASH_DIR/$(basename "$TEST_FILE2")"_* >/dev/null 2>&1 && \
   ls "$TRASH_DIR/$(basename "$TEST_FILE3")"_* >/dev/null 2>&1; then
  echo "Test passed: Files were moved to the trash directory successfully."
else
  echo "Test failed: Not all files were moved to the trash directory."
fi

# Clean up
echo "Cleaning up test files..."
rm -f $TRASH_DIR/testfile*.txt_*

# # Optionally, list contents of the trash directory for verification
echo "test files in the trash directory:"
ls "$TRASH_DIR" | grep $TRASH_DIR/testfile*.txt_*  | wc -l
