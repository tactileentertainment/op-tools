#!/bin/bash
set -euo pipefail

_OP_SCRIPT_NAME="op-item-delete"
_OP_SUPPRESS_STDERR="false"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_op-tactile-common.sh
source "${SCRIPT_DIR}/../libexec/_op-tactile-common.sh"

_op_tactile_require_op

show_help() {
  cat >&2 <<'HELP'
op-item-delete — 1Password item deleter with Connect server failover

USAGE:
  op-item-delete --vault <vault> <item_id_or_title>
  op-item-delete [any op item delete flags...]
  op-item-delete --help

HOW IT WORKS:
  Wraps `op item delete` with the same Connect-first, service-account-fallback
  strategy as op-read. All flags are passed through to `op item delete`.

ENVIRONMENT VARIABLES:
  OP_CONNECT_HOST           Connect server URL
  OP_CONNECT_TOKEN          Connect server access token
  OP_SERVICE_ACCOUNT_TOKEN  Service account token (fallback)
  OP_CONNECT_TIMEOUT        Connect timeout in seconds (default: 3)

EXAMPLES:
  op-item-delete --vault "my-vault" "my-item-title"
  op-item-delete --vault "my-vault" "abc123def456"
HELP
  exit 0
}

if [ $# -eq 0 ]; then
  echo "Usage: op-item-delete --vault <vault> <item_id_or_title>" >&2
  echo "       op-item-delete --help" >&2
  exit 1
fi

[ "$1" = "--help" ] || [ "$1" = "-h" ] && show_help

_op_exec_with_failover op item delete "$@"
