#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<USG
auto-commit.sh - Wrapper para pf-lists con commit y push automáticos

Uso:
  auto-commit.sh add <whitelist|blacklist> <ipv4|ipv6> <ip_or_cidr> <label> [--ttl TTL] [--comment "texto"]
  auto-commit.sh remove <whitelist|blacklist> <ipv4|ipv6> <ip_or_cidr>
  auto-commit.sh help

Ejemplos:
  ./scripts/auto-commit.sh add blacklist ipv4 198.51.100.23 bruteforce --ttl 7d --comment "botnet"
  ./scripts/auto-commit.sh remove whitelist ipv4 203.0.113.10
USG
}

iso_now() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }

cmd="${1:-help}"

case "$cmd" in
  add)
    [[ $# -ge 5 ]] || { usage; exit 1; }
    kind="$2"; fam="$3"; ipcidr="$4"; label="$5"
    shift 5
    ./scripts/pf-lists add "$kind" "$fam" "$ipcidr" "$label" "$@"
    file="lists/${kind}/${fam}/list.csv"
    ts="$(iso_now)"
    msg="list(${kind}/${fam}): add ${ipcidr} label=${label} via pf-lists at ${ts}"
    ;;

  remove)
    [[ $# -eq 4 ]] || { usage; exit 1; }
    kind="$2"; fam="$3"; ipcidr="$4"
    shift 4
    ./scripts/pf-lists remove "$kind" "$fam" "$ipcidr"
    file="lists/${kind}/${fam}/list.csv"
    ts="$(iso_now)"
    msg="list(${kind}/${fam}): remove ${ipcidr} via pf-lists at ${ts}"
    ;;

  help|--help|-h)
    usage
    exit 0
    ;;

  *)
    usage
    exit 1
    ;;
esac

git add "$file"
git commit -m "$msg" || { echo "Nada para commitear (posible duplicado o sin cambios)"; exit 0; }
git push
echo "Commit y push realizados: $msg"
