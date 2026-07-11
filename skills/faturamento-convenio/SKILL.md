---
name: faturamento-convenio
description: O faturamento de convênio (TISS) no Fluxo Ideal — faturar guias/lotes, importar o retorno da operadora, tratar glosas e recorrer. Use para entender o ciclo de cobrança de convênio e acompanhar lotes/glosas. É o "financeiro de convênio", distinto do financeiro-caixa.
audience: [ia, humano]
depends_on: [faturamento-convenio, tiss, glosa]
version: 0.1.0
updated: 2026-07-11
---

# Faturamento de convênio (TISS)

Conduzir e acompanhar o **faturamento de convênio** — transformar atendimentos em cobrança à
operadora pelo padrão TISS, importar o retorno e tratar o que foi **glosado** (negado). É o
"financeiro de convênio", um domínio especializado, distinto do financeiro-caixa.

## Quando usar
- Faturar guias/lotes de convênio, ver o status de um lote, acompanhar glosas pendentes / valor glosado.
- Entender o ciclo TISS (faturar → retorno → glosa → recurso).

## Quando NÃO usar
- Caixa/pagamento/recebimento **particular** → skill `financeiro`.
- Preço/tabela/cobertura de convênio no orçamento → `precificador`.
- Autorização de convênio no **agendamento** → `secretaria`.

## Modelo mental
O ciclo é **multi-etapa**:

```
configurar convênio → FATURAR um LOTE (guias TISS: consulta / SP-SADT) → enviar à operadora
   → importar o DEMONSTRATIVO (o retorno) → o não pago vira GLOSA → tratar / RECORRER → conciliar
```

Boa parte é **ato perante a operadora** (faturar, recorrer). Por isso a **escrita pede humano**; a IA
começa **lendo** (status de lote, glosas, prazos).

## Glossário
- **TISS / TUSS**: o padrão da ANS de troca com a operadora / a tabela de códigos de procedimento.
- **Guia**: o documento de cobrança de um atendimento (consulta ou SP-SADT).
- **Lote**: o conjunto de guias enviado à operadora de uma vez.
- **Demonstrativo**: o retorno da operadora — o que pagou, o que glosou e por quê.
- **Glosa**: valor negado (total/parcial) pela operadora. Tem uma **máquina de estados**.
- **Recurso**: a contestação de uma glosa.
- **Autorização prévia**: aval da operadora antes de executar (pré-requisito, não cobrança).

## Ferramentas (tarefa → ferramenta)
> Começa **read-only**; a escrita (faturar/importar/tratar/recorrer) é ato perante a operadora → humano.
> As ferramentas deste perfil ainda estão sendo desenhadas — ver o backlog de cobertura.

- **Leitura (o alvo inicial):** status de um lote, glosas pendentes e valor glosado, prazos de
  contestação vencendo.
- **Escrita (sob humano):** faturar um lote, importar demonstrativo, tratar/recorrer glosa.

## Regras e invariantes
- **Faturar/recorrer é ato perante a operadora** — humano no loop.
- **Glosa tem máquina de estados** — não se "pula" para um estado; segue o fluxo.
- **Autorização ≠ cobrança** — é pré-requisito operacional.

## Limites
- Não cobre caixa/pagamento particular (`financeiro`), preço (`precificador`) nem autorização no
  agendamento (`secretaria`).
- Capacidade especializada e (hoje) **gated/dormente** no backend — ativada por convênio.
