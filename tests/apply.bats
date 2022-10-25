#!/usr/bin/env bash
set -o errexit -o errtrace -o nounset -o pipefail

setup() {
    load "../vendor/bats-support/load"
    load "../vendor/bats-assert/load"
    load "../vendor/bats-mock/load"

    TEST_FIXTURES_DIR="$(dirname "$BATS_TEST_FILENAME")/fixtures"
}

@test "apply: makes api calls for each file in the config directory" {
    gh="$(mock_create)"
    mock_set_output "${gh}" "someuser/somerepo" 1

    _GH="${gh}" run ./gh-repo-config apply --config "${TEST_FIXTURES_DIR}"

    assert_success
    assert_line "[someuser/somerepo]: Configuring repo"
    assert_line "[someuser/somerepo]: Configuring repo topics"

    call1=$(mock_get_call_args "${gh}" 1)
    assert_regex \
        "${call1}" \
        "repo view"

    call2=$(mock_get_call_args "${gh}" 2)
    assert_regex \
        "${call2}" \
        "api -X PATCH /repos/:owner/:repo --input=${TEST_FIXTURES_DIR}/repo.json"

    call3=$(mock_get_call_args "${gh}" 3)
    assert_regex \
        "${call3}" \
        "api -X PUT /repos/:owner/:repo/topics --input=${TEST_FIXTURES_DIR}/topics.json"

    call4=$(mock_get_call_args "${gh}" 4)
    assert_regex \
        "${call4}" \
        "api -X PUT /repos/:owner/:repo/branches/main/protection --input=${TEST_FIXTURES_DIR}/branch-protection/main.json"

    call5=$(mock_get_call_args "${gh}" 5)
    assert_regex \
        "${call5}" \
        "api -X PUT /repos/:owner/:repo/branches/prod/protection --input=${TEST_FIXTURES_DIR}/branch-protection/prod.json"
}
