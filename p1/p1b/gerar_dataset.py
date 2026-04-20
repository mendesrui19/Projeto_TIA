# -*- coding: utf-8 -*-
# P1B — Gerador de dataset sintetico de triagem SNS24.
# Produz 125 exemplos por classe (625 total) com cenarios clinicamente
# coerentes e diversidade suficiente para a arvore de decisao ir fundo.
# Executar: python3 gerar_dataset.py
# Output:   dataset_triagem.csv (mesmo diretorio)

import csv
import os

OUT = os.path.join(os.path.dirname(__file__), "dataset_triagem.csv")

COLS = [
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


def enforce(row):
    """Propaga implicacoes hierarquicas entre features."""
    if row.get("febre_alta_40"):       row["febre"] = 1
    if row.get("febre_persistente"):   row["febre"] = 1
    if row.get("convulsao_febril"):    row["febre"] = 1
    if row.get("falta_ar_repouso"):    row["falta_ar"] = 1
    if row.get("falta_ar_leve"):       row["falta_ar"] = 1
    if row.get("pieira_ou_tiragem"):   row["falta_ar"] = 1
    if row.get("tosse_persistente"):   row["tosse"] = 1
    if row.get("tosse_produtiva"):     row["tosse"] = 1
    if row.get("tosse_agravada"):      row["tosse"] = 1
    if row.get("tosse_com_sangue"):    row["tosse"] = 1
    if row.get("dor_abdominal_forte"): row["dor_abdominal"] = 1
    if row.get("vomitos_intensos"):    row["vomitos"] = 1
    if row.get("diarreia_grave"):      row["diarreia"] = 1
    if row.get("dor_cabeca_forte"):    row["dor_cabeca"] = 1
    if row.get("alteracao_consciencia"): row["confusao"] = 1
    if row.get("sonolencia_anormal"):  row["confusao"] = 1
    if row.get("sintomas_pos_trauma"): row["trauma_recente"] = 1
    return row


def gen(templates, backgrounds, label):
    """
    Para cada template gera 5 variantes:
      v0 — sem background
      v1 — + backgrounds[0]
      v2 — + backgrounds[1]
      v3 — + backgrounds[2]
      v4 — + backgrounds[0] + backgrounds[1]
    """
    rows = []
    for tpl in templates:
        for vi in range(5):
            row = {c: 0 for c in COLS}
            for k, v in tpl.items():
                row[k] = v
            if vi == 1 and len(backgrounds) >= 1:
                row[backgrounds[0]] = 1
            elif vi == 2 and len(backgrounds) >= 2:
                row[backgrounds[1]] = 1
            elif vi == 3 and len(backgrounds) >= 3:
                row[backgrounds[2]] = 1
            elif vi == 4 and len(backgrounds) >= 2:
                row[backgrounds[0]] = 1
                row[backgrounds[1]] = 1
            enforce(row)
            row["alvo"] = label
            rows.append(row)
    return rows


# ===========================================================================
# encaminhar_112_imediato — INEM / 112
# Criterios: sintomas de emergencia imediata
# ===========================================================================
INEM = [
    {"compromisso_via_aerea": 1},
    {"pieira_ou_tiragem": 1},
    {"alteracao_consciencia": 1},
    {"convulsoes": 1},
    {"fraqueza_lado_corpo": 1},
    {"tosse_com_sangue": 1},
    {"sangramento_abundante": 1},
    {"confusao": 1},
    {"sonolencia_anormal": 1},
    {"dor_toracica": 1, "falta_ar": 1},
    {"dor_toracica": 1, "falta_ar_repouso": 1},
    {"dor_cabeca_forte": 1, "rigidez_pescoco": 1, "febre": 1},
    {"dor_cabeca_forte": 1, "sensibilidade_luz": 1, "febre": 1},
    {"dor_cabeca_forte": 1, "manchas_pele": 1, "febre": 1},
    {"trauma_recente": 1, "alteracao_consciencia": 1},
    {"trauma_recente": 1, "sangramento_abundante": 1},
    {"compromisso_via_aerea": 1, "febre": 1},
    {"alteracao_consciencia": 1, "febre_alta_40": 1},
    {"convulsoes": 1, "febre_alta_40": 1},
    {"fraqueza_lado_corpo": 1, "dor_cabeca_forte": 1},
    {"pieira_ou_tiragem": 1, "febre": 1},
    {"confusao": 1, "febre_alta_40": 1},
    {"sonolencia_anormal": 1, "febre_alta_40": 1},
    {"dor_toracica": 1, "falta_ar": 1, "febre": 1},
    {"fraqueza_lado_corpo": 1, "alteracao_consciencia": 1},
]
INEM_BG = ["fadiga_mialgias", "nausea", "dor_cabeca"]

# ===========================================================================
# contactar_sns24_urgente — ADR-SU / Urgencia
# Criterios: grave mas nao emergencia imediata
# ===========================================================================
URGENTE = [
    {"febre_alta_40": 1, "imunodeprimido": 1},
    {"febre_alta_40": 1, "doenca_cronica": 1},
    {"febre_alta_40": 1, "idade_risco": 1},
    {"febre_alta_40": 1, "gravidez": 1},
    {"febre_alta_40": 1, "tratamento_oncologico": 1},
    {"convulsao_febril": 1},
    {"convulsao_febril": 1, "febre_alta_40": 1},
    {"febre": 1, "manchas_pele": 1},
    {"febre_alta_40": 1, "manchas_pele": 1},
    {"dor_abdominal_forte": 1},
    {"dor_abdominal_forte": 1, "febre": 1},
    {"dor_abdominal_forte": 1, "nausea": 1},
    {"vomitos_intensos": 1},
    {"vomitos_intensos": 1, "febre": 1},
    {"vomitos_intensos": 1, "desidratacao": 1},
    {"desidratacao": 1, "febre": 1},
    {"diarreia_grave": 1, "desidratacao": 1},
    {"diarreia_grave": 1, "febre": 1, "desidratacao": 1},
    {"falta_ar": 1, "febre": 1},
    {"falta_ar": 1, "febre_alta_40": 1},
    {"agravamento_48h": 1, "doenca_cronica": 1},
    {"agravamento_48h": 1, "imunodeprimido": 1},
    {"agravamento_48h": 1, "idade_risco": 1},
    {"trauma_recente": 1, "sintomas_pos_trauma": 1},
    {"trauma_recente": 1, "sintomas_pos_trauma": 1, "febre": 1},
]
URGENTE_BG = ["fadiga_mialgias", "agravamento", "dor_cabeca"]

# ===========================================================================
# linha_sns24_orientacao — Linha SNS24 / CSP
# Criterios: necessita orientacao medica, sem urgencia imediata
# ===========================================================================
ORIENTACAO = [
    {"febre_alta_40": 1},
    {"febre_alta_40": 1, "nao_melhora_antipiretico": 1},
    {"febre_persistente": 1, "nao_melhora_antipiretico": 1},
    {"febre_persistente": 1},
    {"disuria": 1},
    {"disuria": 1, "febre": 1},
    {"dor_abdominal": 1, "febre": 1},
    {"dor_abdominal": 1, "disuria": 1},
    {"febre": 1, "tosse": 1, "nao_melhora_antipiretico": 1},
    {"febre": 1, "dor_cabeca_forte": 1},
    {"febre_persistente": 1, "tosse_persistente": 1},
    {"febre_alta_40": 1, "fadiga_mialgias": 1},
    {"febre_persistente": 1, "nausea": 1, "nao_melhora_antipiretico": 1},
    {"febre": 1, "vomitos": 1, "nao_melhora_antipiretico": 1},
    {"febre": 1, "falta_ar_leve": 1},
    {"disuria": 1, "nao_melhora_antipiretico": 1},
    {"dor_abdominal": 1, "febre_alta_40": 1},
    {"febre_persistente": 1, "dor_cabeca": 1},
    {"tosse_persistente": 1, "febre": 1, "nao_melhora_antipiretico": 1},
    {"febre_alta_40": 1, "dor_garganta": 1},
    {"febre_persistente": 1, "dor_garganta": 1, "nao_melhora_antipiretico": 1},
    {"febre": 1, "nausea": 1, "dor_abdominal": 1},
    {"febre_alta_40": 1, "congestao_nasal": 1},
    {"disuria": 1, "dor_abdominal": 1},
    {"febre_persistente": 1, "fadiga_mialgias": 1, "nao_melhora_antipiretico": 1},
]
ORIENTACAO_BG = ["fadiga_mialgias", "dor_cabeca", "agravamento"]

# ===========================================================================
# autocuidado_e_observacao — Autocuidado com vigilancia domiciliaria
# Criterios: sintomas leves com apoio em casa
# ===========================================================================
AUTOCUIDADO = [
    {"tosse": 1, "febre": 1, "contacto_recente": 1, "apoio_domicilio": 1},
    {"tosse": 1, "febre": 1, "apoio_domicilio": 1},
    {"tosse": 1, "tosse_produtiva": 1, "apoio_domicilio": 1},
    {"tosse": 1, "tosse_persistente": 1, "apoio_domicilio": 1},
    {"tosse": 1, "tosse_agravada": 1, "apoio_domicilio": 1},
    {"dor_garganta": 1, "apoio_domicilio": 1},
    {"dor_garganta": 1, "tosse": 1, "apoio_domicilio": 1},
    {"espirros": 1, "congestao_nasal": 1},
    {"espirros": 1, "congestao_nasal": 1, "apoio_domicilio": 1},
    {"alteracao_olfato": 1, "apoio_domicilio": 1},
    {"alteracao_paladar": 1, "apoio_domicilio": 1},
    {"alteracao_olfato": 1, "alteracao_paladar": 1, "apoio_domicilio": 1},
    {"febre": 1, "fadiga_mialgias": 1, "apoio_domicilio": 1},
    {"febre": 1, "apoio_domicilio": 1},
    {"febre": 1, "contacto_recente": 1, "apoio_domicilio": 1},
    {"tosse": 1, "congestao_nasal": 1, "apoio_domicilio": 1},
    {"tosse": 1, "dor_garganta": 1, "apoio_domicilio": 1},
    {"falta_ar_leve": 1, "apoio_domicilio": 1},
    {"febre": 1, "nausea": 1, "apoio_domicilio": 1},
    {"tosse": 1, "tosse_produtiva": 1, "contacto_recente": 1, "apoio_domicilio": 1},
    {"tosse": 1, "fadiga_mialgias": 1, "apoio_domicilio": 1},
    {"febre": 1, "dor_garganta": 1, "apoio_domicilio": 1},
    {"congestao_nasal": 1, "dor_garganta": 1, "apoio_domicilio": 1},
    {"tosse": 1, "tosse_agravada": 1, "contacto_recente": 1, "apoio_domicilio": 1},
    {"febre": 1, "fadiga_mialgias": 1, "contacto_recente": 1, "apoio_domicilio": 1},
]
AUTOCUIDADO_BG = ["dor_cabeca", "nausea", "fadiga_mialgias"]

# ===========================================================================
# informacao_geral_prevencao — Informacao / prevencao
# Criterios: sintomas leves isolados, sem apoio em casa necessario
# ===========================================================================
INFO = [
    {"febre": 1},
    {"tosse": 1},
    {"dor_garganta": 1},
    {"congestao_nasal": 1},
    {"espirros": 1},
    {"nausea": 1},
    {"vomitos": 1},
    {"diarreia": 1},
    {"dor_abdominal": 1},
    {"fadiga_mialgias": 1},
    {"dor_cabeca": 1},
    {"falta_ar": 1},
    {"febre": 1, "dor_cabeca": 1},
    {"tosse": 1, "congestao_nasal": 1},
    {"dor_garganta": 1, "congestao_nasal": 1},
    {"nausea": 1, "fadiga_mialgias": 1},
    {"vomitos": 1, "nausea": 1},
    {"diarreia": 1, "nausea": 1},
    {"febre": 1, "fadiga_mialgias": 1},
    {"tosse": 1, "fadiga_mialgias": 1},
    {"dor_abdominal": 1, "nausea": 1},
    {"febre": 1, "tosse": 1},
    {"congestao_nasal": 1, "espirros": 1},
    {"dor_cabeca": 1, "fadiga_mialgias": 1},
    {"tosse": 1, "dor_garganta": 1},
]
INFO_BG = []  # sem background: casos leves sem complicacoes


def main():
    all_rows = []
    for templates, bg, label in [
        (INEM,       INEM_BG,       "encaminhar_112_imediato"),
        (URGENTE,    URGENTE_BG,    "contactar_sns24_urgente"),
        (ORIENTACAO, ORIENTACAO_BG, "linha_sns24_orientacao"),
        (AUTOCUIDADO, AUTOCUIDADO_BG, "autocuidado_e_observacao"),
        (INFO,       INFO_BG,       "informacao_geral_prevencao"),
    ]:
        rows = gen(templates, bg, label)
        all_rows.extend(rows)

    with open(OUT, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=COLS + ["alvo"])
        writer.writeheader()
        writer.writerows(all_rows)

    from collections import Counter
    dist = Counter(r["alvo"] for r in all_rows)
    print(f"Total: {len(all_rows)} linhas")
    for cls, n in sorted(dist.items()):
        print(f"  {cls}: {n}")
    print(f"Escrito em: {OUT}")


if __name__ == "__main__":
    main()
