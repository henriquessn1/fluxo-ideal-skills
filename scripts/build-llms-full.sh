#!/usr/bin/env bash
# Gera o llms-full.txt: o indice (llms.txt) seguido do conteudo COMPLETO de cada
# SKILL.md — para agentes que preferem um unico fetch em vez de seguir 15 links.
#
# NAO editar o llms-full.txt a mao: e um artefato DERIVADO, regenerado
# automaticamente pelo CI a cada mudanca nas skills
# (ver .github/workflows/build-llms-full.yml). Rode local com:  bash scripts/build-llms-full.sh
set -euo pipefail
cd "$(dirname "$0")/.."

out="llms-full.txt"
{
  cat llms.txt
  for f in $(ls skills/*/SKILL.md | grep -v '/_template/' | sort); do
    name="$(basename "$(dirname "$f")")"
    printf '\n\n'
    printf '# ============================================================\n'
    printf '# SKILL: %s  —  https://fluxoideal.com/%s\n' "$name" "$f"
    printf '# ============================================================\n\n'
    cat "$f"
  done
} > "$out"

echo "gerado $out ($(wc -l < "$out") linhas, $(ls skills/*/SKILL.md | grep -vc '/_template/') skills)"
