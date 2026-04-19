# -*- coding: utf-8 -*-
# P1B: le todo o dataset_triagem.csv e gera uma regra Prolog por folha da arvore.
#
# - Nao ha limite fixo ao numero de regras: quantas mais folhas a arvore tiver
#   sobre os teus dados, mais linhas em regras_aprendidas.pl (ate a arvore
#   conseguir separar as classes).
# - Sintaxe alinhada ao sns24v2_incert.pl (aulas): if Cond then Conclusao with CF.
# - O CF vem dos dados: proporcao da classe majoritaria na folha (confianca
#   empirica da folha), nao um valor constante.

import os

import pandas as pd
from sklearn.tree import DecisionTreeClassifier

ROOT = os.path.dirname(__file__)
CSV = os.path.join(ROOT, "dataset_triagem.csv")
OUT = os.path.join(ROOT, "..", "prolog", "regras_aprendidas.pl")

COLUNAS_TRIAGEM = [
    "tosse", "tosse_agravada", "tosse_persistente", "tosse_produtiva", "tosse_com_sangue",
    "falta_ar", "falta_ar_repouso", "falta_ar_leve", "pieira_ou_tiragem",
    "dor_garganta", "congestao_nasal", "espirros",
    "febre", "febre_alta_40", "febre_persistente", "nao_melhora_antipiretico", "convulsao_febril",
    "dor_cabeca", "dor_cabeca_forte", "rigidez_pescoco", "sensibilidade_luz", "manchas_pele",
    "sonolencia_anormal", "confusao", "alteracao_consciencia", "convulsoes", "fraqueza_lado_corpo",
    "compromisso_via_aerea", "dor_toracica", "sangramento_abundante",
    "alteracao_olfato", "olfato_quimio", "olfato_trauma",
    "alteracao_paladar", "paladar_quimio", "paladar_trauma",
    "nausea", "vomitos", "vomitos_intensos", "diarreia", "diarreia_grave",
    "dor_abdominal", "dor_abdominal_forte", "disuria", "desidratacao",
    "fadiga_mialgias", "agravamento", "agravamento_48h",
    "imunodeprimido", "tratamento_oncologico", "gravidez", "doenca_cronica", "idade_risco",
    "apoio_domicilio", "contacto_recente", "trauma_recente", "sintomas_pos_trauma",
]

COLUNAS = list(COLUNAS_TRIAGEM)

DISPOSICAO_PL = {
    "encaminhar_112_imediato": "inem",
    "contactar_sns24_urgente": "adr_su",
    "linha_sns24_orientacao": "transferir_triagem",
    "autocuidado_e_observacao": "autocuidado",
    "informacao_geral_prevencao": "transferir_triagem",
}

# P1B complementa a base manual (P1A): emergencias 112 ficam exclusivamente
# nas regras manuais para evitar sobreposicao do aprendido sobre casos criticos.
DISPOSICOES_BLOQUEADAS_APRENDIDAS = {"inem"}

# Regras aprendidas ficam com confianca limitada para nao competir em excesso
# com pesos clinicos definidos manualmente na base principal.
CF_MAX_REGRAS_APRENDIDAS = 0.75


def percorrer(clf, no, positivos, caminhos):
    """Percorre a arvore: ramo direito = sintoma presente (1 no CSV), como antes."""
    t = clf.tree_
    if t.children_left[no] == t.children_right[no]:
        counts = t.value[no][0].astype(float)
        total = float(counts.sum())
        if total <= 0:
            return
        idx = int(counts.argmax())
        classe = str(clf.classes_[idx])
        cf = float(counts[idx] / total)
        caminhos.append((list(positivos), classe, cf))
        return
    f = int(t.feature[no])
    percorrer(clf, int(t.children_left[no]), positivos, caminhos)
    percorrer(clf, int(t.children_right[no]), positivos + [COLUNAS[f]], caminhos)


def main():
    df = pd.read_csv(CSV)
    for c in COLUNAS:
        if c not in df.columns:
            raise SystemExit("Falta coluna no CSV: {}".format(c))
    if "alvo" not in df.columns:
        raise SystemExit("CSV sem coluna alvo")

    # Arvore sem poda artificial: cada amostra pode ser folha => maximiza regras
    # a partir dos dados (como exercicio de extrair regras da arvore nas aulas).
    clf = DecisionTreeClassifier(
        criterion="gini",
        min_samples_leaf=1,
        random_state=42,
    )
    clf.fit(df[COLUNAS].values, df["alvo"].astype(str))

    caminhos = []
    percorrer(clf, 0, [], caminhos)

    # Mantem uma regra por folha util para nao ficar demasiado comprimido.
    regras_folhas = []
    for positivos, classe, cf in caminhos:
        if classe not in DISPOSICAO_PL:
            continue
        termos = tuple(dict.fromkeys(positivos))
        if not termos:
            continue
        alvo_pl = DISPOSICAO_PL[classe]
        if alvo_pl in DISPOSICOES_BLOQUEADAS_APRENDIDAS:
            continue
        regras_folhas.append((termos, alvo_pl, cf))

    linhas = []
    for termos, alvo_pl, cf in sorted(regras_folhas, key=lambda x: (x[1], x[0])):
        cf_pl = min(1.0, max(0.0, float(cf)))
        cf_pl = min(cf_pl, CF_MAX_REGRAS_APRENDIDAS)
        # Prolog legivel; corte no triagem.pl e 0.08 — evitar with 0.0 inutil
        if cf_pl < 0.09:
            cf_pl = 0.09
        cond = " and ".join(termos)
        linhas.append(
            "if {} then {} with {}.".format(cond, alvo_pl, round(cf_pl, 3))
        )

    cabecalho = (
        "% P1B — regras aprendidas a partir de dataset_triagem.csv (sem limite artificial\n"
        "% ao numero de regras: uma por folha da arvore de decisao sobre os dados).\n"
        "% CF = proporcao da classe majoritaria na folha (como suporte empirico).\n\n"
        ":- op( 800, fx, if).\n"
        ":- op( 700, xfx, then).\n"
        ":- op( 600, xfx, with).\n"
        ":- op( 300, xfy, or).\n"
        ":- op( 200, xfy, and).\n"
        ":- multifile( (if)/1 ).\n\n"
    )
    with open(OUT, "w", encoding="utf-8") as f:
        f.write(cabecalho + "\n".join(linhas) + "\n")
    print("Folhas com alvo mapeavel: {} | Regras escritas: {} -> {}".format(
        len(caminhos), len(linhas), OUT
    ))


if __name__ == "__main__":
    main()
