#!/usr/bin/env bash
set -o errexit -o errtrace -o nounset -o pipefail

setup() {
    load '../vendor/bats-support/load'
    load '../vendor/bats-assert/load'
}

@test "help: accessable via a command" {
    run ./gh-repo-config help
    assert_success
    assert_output --partial "Usage:"
}

@test "help: accessable via a long flag" {
    run ./gh-repo-config --help
    assert_success
    assert_output --partial "Usage:"
}
