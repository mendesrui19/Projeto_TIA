import os

import pandas as pd
from sklearn.tree import DecisionTreeClassifier, export_text

ROOT = os.path.dirname(__file__)
CSV = os.path.join(ROOT, "data", "triagem_sintetica.csv")
OUT_PROLOG = os.path.join(ROOT, "..", "prolog", "regras_auto.pl")

SYM = [
    "contacto_infeccao_recente",
    "febre",
    "febre_alta",
    "tosse",
    "congestao_nasal",
    "fadiga_mialgias",
    "alteracao_olfato",
    "alteracao_paladar",
    "falta_ar",
    "sinais_graves_resp",
    "compromisso_via_aerea",
    "dor_toracica",
    "cefaleia",
    "confusao",
    "dor_abdominal",
    "disuria",
    "vomitos_persistentes",
    "desidratacao",
    "lipotimia",
    "assintomatico",
]


def _folha_maioria(tree, node):
    valores = tree.value[node][0]
    return max(range(len(valores)), key=lambda i: valores[i])


def percorrer_arvore(clf, names, node, conds, saida):
    tree = clf.tree_
    if tree.children_left[node] == tree.children_right[node]:
        idx = _folha_maioria(tree, node)
        saida.append((conds, str(clf.classes_[idx])))
        return
    f = int(tree.feature[node])
    nome = names[f]
    esq = int(tree.children_left[node])
    dir_ = int(tree.children_right[node])
    if nome == "imunodeprimido":
        percorrer_arvore(clf, names, esq, conds + ["Imuno = nao"], saida)
        percorrer_arvore(clf, names, dir_, conds + ["Imuno = sim"], saida)
    else:
        percorrer_arvore(clf, names, esq, conds + [f"\\+ membro({nome}, S)"], saida)
        percorrer_arvore(clf, names, dir_, conds + [f"membro({nome}, S)"], saida)


def arvore_para_prolog(i, conds, alvo):
    prio = 8 + i
    imuno = "Imuno" if any("Imuno =" in c for c in conds) else "_Imuno"
    if not conds:
        return (
            f"candidato_aprendido({prio}, {alvo}, S, _Idade, {imuno}, 0.65) :- true."
        )
    corpo = ",\n    ".join(conds)
    return (
        f"candidato_aprendido({prio}, {alvo}, S, _Idade, {imuno}, 0.65) :-\n"
        f"    {corpo}."
    )


def main():
    df = pd.read_csv(CSV)
    y = df["alvo"].astype(str)
    x_cols = SYM + ["imunodeprimido"]
    X = df[x_cols]
    nomes = list(X.columns)
    clf = DecisionTreeClassifier(max_depth=7, min_samples_leaf=2, random_state=42)
    clf.fit(X.values, y)
    print(export_text(clf, feature_names=nomes))
    caminhos = []
    percorrer_arvore(clf, nomes, 0, [], caminhos)
    blocos = [arvore_para_prolog(i, c, a) for i, (c, a) in enumerate(caminhos, start=1)]
    with open(OUT_PROLOG, "w", encoding="utf-8") as f:
        f.write(
            "% Base de conhecimento — regras aprendidas (gerado por mine_rules.py).\n\n"
            + "\n".join(blocos)
            + "\n"
        )
    print(f"Actualizado {OUT_PROLOG} ({len(blocos)} regras).")


if __name__ == "__main__":
    main()
