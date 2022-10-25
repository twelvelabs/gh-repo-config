#!/usr/bin/env bash
set -o errexit -o errtrace -o nounset -o pipefail

setup() {
    load "../vendor/bats-support/load"
    load "../vendor/bats-assert/load"
    load "../vendor/bats-file/load"

    TEST_TEMP_DIR="$(temp_make)"
    # Transform tempdir paths in the test output to make it easier to read
    # See: https://github.com/ztombol/bats-file#transforming-displayed-paths
    export BATSLIB_FILE_PATH_REM="#${TEST_TEMP_DIR}"
    export BATSLIB_FILE_PATH_ADD="<temp>"

    TEST_FIXTURES_DIR="$(dirname "$BATS_TEST_FILENAME")/fixtures"
}

teardown() {
    temp_del "$TEST_TEMP_DIR"
}

@test "init: should create intermediate dirs if needed" {
    mkdir "${TEST_TEMP_DIR}/foo"
    run ./gh-repo-config init --config "${TEST_TEMP_DIR}/foo/bar/baz"
    assert_success
    assert_dir_exists "${TEST_TEMP_DIR}/foo/bar/baz"
}

@test "init: should generate the expected files" {
    run ./gh-repo-config init --config "${TEST_TEMP_DIR}"
    assert_success

    assert_file_exist "${TEST_TEMP_DIR}/repo.json"
    assert_files_equal \
        "${TEST_TEMP_DIR}/repo.json" \
        "${TEST_FIXTURES_DIR}/repo.json"

    assert_file_exist "${TEST_TEMP_DIR}/topics.json"
    assert_files_equal \
        "${TEST_TEMP_DIR}/topics.json" \
        "${TEST_FIXTURES_DIR}/topics.json"

    assert_file_exist "${TEST_TEMP_DIR}/branch-protection/main.json"
    assert_files_equal \
        "${TEST_TEMP_DIR}/branch-protection/main.json" \
        "${TEST_FIXTURES_DIR}/branch-protection/main.json"
}

@test "init: should prompt if repo.json already exists" {
    echo "EXISTING" >"${TEST_TEMP_DIR}/repo.json"

    run ./gh-repo-config init --config "${TEST_TEMP_DIR}" <<<"N"

    # for some reason bats can't see the "Overwrite?" prompt
    # and it doesn't feel worth it to me to try to figure out why :shrug:
    assert_line "[    warn]: ${TEST_TEMP_DIR}/repo.json already exists!"
    assert_line "[    keep]: ${TEST_TEMP_DIR}/repo.json"
    assert_file_contains "${TEST_TEMP_DIR}/repo.json" "EXISTING"
}

@test "init: should prompt if topics.json already exists" {
    echo "EXISTING" >"${TEST_TEMP_DIR}/topics.json"

    run ./gh-repo-config init --config "${TEST_TEMP_DIR}" <<<"N"

    assert_line "[    warn]: ${TEST_TEMP_DIR}/topics.json already exists!"
    assert_line "[    keep]: ${TEST_TEMP_DIR}/topics.json"
    assert_file_contains "${TEST_TEMP_DIR}/topics.json" "EXISTING"
}

@test "init: should prompt if branch-protection/main.json already exists" {
    mkdir -p "${TEST_TEMP_DIR}/branch-protection"
    echo "EXISTING" >"${TEST_TEMP_DIR}/branch-protection/main.json"

    run ./gh-repo-config init --config "${TEST_TEMP_DIR}" <<<"N"

    assert_line "[    warn]: ${TEST_TEMP_DIR}/branch-protection/main.json already exists!"
    assert_line "[    keep]: ${TEST_TEMP_DIR}/branch-protection/main.json"
    assert_file_contains "${TEST_TEMP_DIR}/branch-protection/main.json" "EXISTING"
}
