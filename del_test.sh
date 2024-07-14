#!/bin/bash

# Test directory and files
TEST_DIR="/tmp/del_test"
TEST_FILE1="${TEST_DIR}/testfile1.txt"
TEST_FILE2="${TEST_DIR}/testfile2.txt"
TRASH_DIR="${HOME}/.local/share/Trash/files"

# Setup function to create test environment
setup() {
    mkdir -p "$TEST_DIR"
    echo "This is a test file." > "$TEST_FILE1"
    echo "This is another test file." > "$TEST_FILE2"
    rm -rf "$TRASH_DIR"/*  # Clean trash directory before each test
    echo "Setup complete."
}

# Teardown function to clean up after tests
teardown() {
    rm -rf "$TEST_DIR"
    rm -rf "$TRASH_DIR"/*
    echo "Teardown complete."
}

# Test moving file to trash
test_move_to_trash() {
    setup
    ./del.sh "$TEST_FILE1"
    if [[ -f "${TRASH_DIR}/$(basename "$TEST_FILE1")" ]]; then
        echo "test_move_to_trash passed."
    else
        echo "test_move_to_trash failed."
    fi
    teardown
}

# Test metadata creation
test_metadata_creation() {
    setup
    ./del.sh "$TEST_FILE1"
    local metadata_file="${TRASH_DIR}/$(basename "$TEST_FILE1").delInfo"
    if [[ -f "$metadata_file" ]]; then
        echo "test_metadata_creation passed."
    else
        echo "test_metadata_creation failed."
    fi
    teardown
}

# Test config editing
test_config_editing() {
    setup
    ./del.sh --config
    if [[ -f "$CONFIG_FILE" ]]; then
        echo "test_config_editing passed."
    else
        echo "test_config_editing failed."
    fi
    teardown
}

# Test periodic cleanup
test_periodic_cleanup() {
    setup
    echo "AUTO_PURGE_DAYS=0" > "$CONFIG_FILE"
    ./del.sh "$TEST_FILE1"
    ./del.sh --cleanup
    if [[ ! -f "${TRASH_DIR}/$(basename "$TEST_FILE1")" ]]; then
        echo "test_periodic_cleanup passed."
    else
        echo "test_periodic_cleanup failed."
    fi
    teardown
}

# Test cron job creation
test_cron_job_creation() {
    setup
    crontab -r  # Clear all cron jobs before the test
    ./del.sh "$TEST_FILE1"
    if crontab -l | grep -q "del_cleanup"; then
        echo "test_cron_job_creation passed."
    else
        echo "test_cron_job_creation failed."
    fi
    teardown
}

# Test verbose mode
test_verbose_mode() {
    setup
    output=$(./del.sh --verbose "$TEST_FILE1" 2>&1)
    if echo "$output" | grep -q "Moving"; then
        echo "test_verbose_mode passed."
    else
        echo "test_verbose_mode failed."
    fi
    teardown
}

# Run all tests
run_tests() {
    test_move_to_trash
    test_metadata_creation
    test_config_editing
    test_periodic_cleanup
    test_cron_job_creation
    test_verbose_mode
}

run_tests

