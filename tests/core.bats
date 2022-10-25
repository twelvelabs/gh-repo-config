#!/usr/bin/env bash
set -o errexit -o errtrace -o nounset -o pipefail

setup() {
    load '../vendor/bats-support/load'
    load '../vendor/bats-assert/load'
}

@test "core: unknown arguments are handled correctly" {
    run ./gh-repo-config wat
    assert_failure
    assert_output "Unknown argument 'wat'"
}
