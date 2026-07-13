---
name: faturamento-convenio
description: O faturamento de convênio (TISS) no Fluxo Ideal — faturar guias/lotes, importar o retorno da operadora, tratar glosas e recorrer. Use para entender o ciclo de cobrança de convênio e acompanhar lotes/glosas. É o "financeiro de convênio", distinto do financeiro-caixa.
audience: [ia, humano]
depends_on: [faturamento-convenio, tiss, glosa]
version: 0.2.1
updated: 2026-07-13
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

Há **duas naturezas de escrita**, e a fronteira entre elas é a lente-mestra:

- **CONFIGURAR** o convênio — o "contrato TISS" (registro ANS, versões de componente, prazos,
  homologação) e o **código TUSS** do procedimento — é **cadastro**: reversível, interno, não move
  dinheiro nem fala com a operadora → **IA com confirmação**. É onde a IA mais ajuda: *descobrir o que
  colocar* (ex.: as versões vigentes da ANS).
- **FATURAR / recorrer / transmitir** é **ato perante a operadora** (uma rejeição baixa a qualidade do
  prestador) → **humano**. Aqui a IA **lê**: status de lote, glosas, prazos, demonstrativo.

## Glossário
- **TISS / TUSS**: o padrão da ANS de troca com a operadora / a tabela de códigos de procedimento.
- **Guia**: o documento de cobrança de um atendimento (consulta ou SP-SADT).
- **Lote**: o conjunto de guias enviado à operadora de uma vez.
- **Demonstrativo**: o retorno da operadora — o que pagou, o que glosou e por quê.
- **Glosa**: valor negado (total/parcial) pela operadora. Tem uma **máquina de estados**.
- **Recurso**: a contestação de uma glosa.
- **Autorização prévia**: aval da operadora antes de executar (pré-requisito, não cobrança).

## Ferramentas (tarefa → ferramenta)
> A execução depende de **autorização** — o MCP aplica a permissão; a skill ensina a intenção e o *quando*.
> As leituras trazem uma **projeção enxuta**: dados do beneficiário (nome/carteirinha) **nunca trafegam**
> e os textos livres (motivo de glosa, justificativa) são **higienizados**.

**Ler o convênio (agora por ferramenta):**
- **Glosas** — os **prazos/SLA** de contestação vencendo, os **indicadores** (quanto glosado e por quê) e
  a **busca** de glosas por filtro.
- **Lotes** — buscar e ver o **status** de um lote.
- **Recursos** — acompanhar os **recursos** (as contestações de glosa).
- **Board de autorização prévia** — a fila de autorizações do convênio (leitura).
- **Demonstrativos** — a **listagem do retorno** da operadora (o que ela pagou / glosou).
- **Dinheiro do convênio (visão gerencial)** — os **recebíveis de convênio** e a **reconciliação de
  convênio** (apresentado × pago × glosado) → pela quebra (**drill-down**) do painel de gestão (skill
  `indicadores`), disponível também a este papel.

**Configurar o convênio (por ferramenta, com prévia + confirmação — é cadastro, não movimento):**
- **Contrato TISS** — criar/editar a configuração TISS do convênio: **registro ANS**, as **versões de
  componente** da ANS, **prazos** e o **status de homologação**. A IA ajuda a *descobrir o que colocar*.
  *Ligar a transmissão automática (webservice) ou marcar "produção" arma envio real → confirmação
  reforçada; o segredo do webservice (credencial/certificado) fica com o humano.*
- **Código TUSS do procedimento** — mapear o código que vai na guia, pela ferramenta de **catálogo de
  procedimentos** (compartilhada com o `precificador`); **procurar** o código válido pela ferramenta de
  **lookup TUSS**; e **importar** o catálogo TUSS da ANS (gated).

**Faturar / tratar (sob humano — ato perante a operadora):**
- Faturar um lote, gerar as guias/o XML, **importar/parsear** um demonstrativo, **tratar/recorrer** uma
  glosa, transmitir à operadora. É o "enviar" — fica **humano**.

## Regras e invariantes
- **Configurar ≠ faturar.** Cadastrar/editar o contrato TISS e o mapeamento TUSS é **config** (IA com
  confirmação); **faturar/recorrer/transmitir** é ato perante a operadora (**humano**).
- **Faturar/recorrer é ato perante a operadora** — humano no loop.
- **Glosa tem máquina de estados** — não se "pula" para um estado; segue o fluxo.
- **Autorização ≠ cobrança** — é pré-requisito operacional.
- **Contrato TISS ≠ tabela de preço.** A configuração TISS (registro ANS, versões, prazos) é deste perfil;
  os **preços** negociados do convênio são do `precificador`.

## Limites
- Não cobre caixa/pagamento particular (`financeiro`), preço/tabela do convênio (`precificador`) nem
  autorização no agendamento (`secretaria`).
- O faturamento no backend é **ativado por convênio** (liga quando o convênio precisa); as ferramentas
  existem, mas dependem dessa ativação **e** da autorização do papel.
