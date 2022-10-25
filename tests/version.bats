#!/usr/bin/env bash
set -o errexit -o errtrace -o nounset -o pipefail

setup() {
    load '../vendor/bats-support/load'
    load '../vendor/bats-assert/load'
}

@test "version: accessable via a command" {
    run ./gh-repo-config version
    assert_success
    assert_output "gh-repo-config version 1.0.0"
}

@test "version: accessable via a long flag" {
    run ./gh-repo-config --version
    assert_success
    assert_output "gh-repo-config version 1.0.0"
}
