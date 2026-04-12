# Projectos TIA + SIAD 2025/2026 — Triagem SNS24

## Grupo e registo

1. Formar grupo (máx. **4** alunos, **mesmo turno** de PL).
2. Eleger **representante** (email oficial do grupo).
3. **Registar o grupo presencialmente** nas aulas práticas com **todos** os elementos — grupos não registados não são considerados.
4. Preencher [grupo/CONTRATO_GRUPO.md](grupo/CONTRATO_GRUPO.md) (Anexo B dos relatórios).

## Estrutura do repositório

| Pasta | Conteúdo |
|-------|----------|
| `p1/prolog/` | Triagem: regras manuais + inferência + CF (`avaliar_com_certeza/5`) + `regras_auto.pl` |
| `p1/p1b/` | CSV sintético + `mine_rules.py` (sklearn → cláusulas Prolog) |
| `p2/` | Chatbot com RAG + API Ollama |
| `p2/protocolos/` | Textos de apoio ao RAG (resumos educativos) |
| `relatorios/` | Rascunhos em Markdown (exportar a PDF ≤20 páginas corpo) |
| `apresentacao/` | Slides em Markdown (Marp / ou copiar para PowerPoint) |

## Projeto 1 — Como executar (SWI-Prolog)

```bash
cd p1/prolog
swipl -q triagem.pl
```

No interpretador: `?- executar.` (respostas **s** / **n**). No fim é mostrado o **factor de certeza (%)** da regra aplicada; **1** no menu volta a mostrar certeza e explicação.

## Dataset e regras aprendidas (p1b)

```bash
cd p1/p1b
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python generate_synthetic_dataset.py
python mine_rules.py
```

Isto gera `data/triagem_sintetica.csv` e atualiza `regras_auto.pl` (carregado por `triagem.pl`).

## Projeto 2 — Chatbot (Ollama)

1. Instalar [Ollama](https://ollama.com) e puxar um modelo, ex.: `ollama pull llama3.2`.
2. Executar:

```bash
cd p2
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
export OLLAMA_MODEL=llama3.2
python chatbot_rag.py
```

## Empacotamento para Blackboard

```bash
./scripts/make_submission_zip.sh
```

Gera `submissao_tia_siad.zip` na raiz (adicione os PDFs dos relatórios e a apresentação final antes ou edite o script).

## Avaliação

Pesos e requisitos oficiais: ver **enunciado / Blackboard** da unidade curricular.

## Datas (confirmar no Blackboard)

- P1: semana ~27 abr 2026  
- P2: semana ~18 mai 2026  
- Oral: semana ~25 mai 2026 (10–15 min por grupo)
