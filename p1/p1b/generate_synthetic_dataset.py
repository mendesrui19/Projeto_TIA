import csv
import os
import random

random.seed(42)

OUT = os.path.join(os.path.dirname(__file__), "data", "triagem_sintetica.csv")

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
AGE = ["crianca", "adulto", "idoso"]


def row(**kwargs):
    base = {s: 0 for s in SYM}
    base.update({"imunodeprimido": 0, "idade": "adulto", "alvo": "linha_sns24_orientacao"})
    base.update(kwargs)
    return base


def synthetic_rows():
    r = []

    for _ in range(5):
        r.append(row(compromisso_via_aerea=1, falta_ar=1, assintomatico=0, alvo="encaminhar_112_imediato"))
    for _ in range(5):
        r.append(row(sinais_graves_resp=1, febre=1, assintomatico=0, alvo="encaminhar_112_imediato"))
    for _ in range(8):
        r.append(row(dor_toracica=1, falta_ar=1, assintomatico=0, alvo="encaminhar_112_imediato"))
    for _ in range(6):
        r.append(row(confusao=1, febre=1, assintomatico=0, alvo="encaminhar_112_imediato"))
    for _ in range(5):
        r.append(row(lipotimia=1, falta_ar=1, assintomatico=0, alvo="encaminhar_112_imediato"))
    for _ in range(7):
        r.append(row(febre_alta=1, febre=1, idade="idoso", assintomatico=0, alvo="contactar_sns24_urgente"))
    for _ in range(6):
        r.append(row(febre_alta=1, febre=1, imunodeprimido=1, assintomatico=0, alvo="contactar_sns24_urgente"))
    for _ in range(6):
        r.append(
            row(
                vomitos_persistentes=1,
                desidratacao=1,
                febre=1,
                idade="crianca",
                assintomatico=0,
                alvo="contactar_sns24_urgente",
            )
        )
    for _ in range(8):
        r.append(
            row(
                contacto_infeccao_recente=1,
                febre=1,
                tosse=1,
                idade="adulto",
                assintomatico=0,
                alvo="linha_sns24_orientacao",
            )
        )
    for _ in range(10):
        r.append(row(febre=1, febre_alta=0, idade="adulto", assintomatico=0, alvo="linha_sns24_orientacao"))
    for _ in range(8):
        r.append(
            row(
                tosse=1,
                congestao_nasal=1,
                falta_ar=0,
                dor_toracica=0,
                assintomatico=0,
                alvo="linha_sns24_orientacao",
            )
        )
    for _ in range(6):
        r.append(
            row(
                fadiga_mialgias=1,
                febre=1,
                falta_ar=0,
                assintomatico=0,
                alvo="linha_sns24_orientacao",
            )
        )
    for _ in range(5):
        r.append(
            row(
                alteracao_olfato=1,
                alteracao_paladar=0,
                falta_ar=0,
                febre_alta=0,
                sinais_graves_resp=0,
                assintomatico=0,
                alvo="autocuidado_e_observacao",
            )
        )
    for _ in range(5):
        r.append(
            row(
                dor_abdominal=1,
                confusao=0,
                falta_ar=0,
                assintomatico=0,
                alvo="linha_sns24_orientacao",
            )
        )
    for _ in range(5):
        r.append(row(disuria=1, falta_ar=0, assintomatico=0, alvo="linha_sns24_orientacao"))
    for _ in range(8):
        r.append(row(cefaleia=1, confusao=0, dor_toracica=0, assintomatico=0, alvo="autocuidado_e_observacao"))
    for _ in range(6):
        r.append(row(assintomatico=1, alvo="informacao_geral_prevencao"))

    for _ in range(24):
        age = random.choice(AGE)
        bits = {s: random.randint(0, 1) for s in SYM}
        bits["assintomatico"] = 0
        imu = random.randint(0, 1)
        alvo = "linha_sns24_orientacao"
        if bits["compromisso_via_aerea"] or bits["sinais_graves_resp"]:
            alvo = "encaminhar_112_imediato"
        elif bits["dor_toracica"] and bits["falta_ar"]:
            alvo = "encaminhar_112_imediato"
        elif bits["confusao"] or bits["lipotimia"]:
            alvo = "encaminhar_112_imediato"
        elif bits["febre_alta"] and bits["febre"] and (age == "idoso" or imu):
            alvo = "contactar_sns24_urgente"
        elif bits["febre"] and age == "adulto" and not bits["febre_alta"]:
            alvo = "linha_sns24_orientacao"
        elif bits["cefaleia"] and not bits["confusao"]:
            alvo = "autocuidado_e_observacao"
        elif bits["assintomatico"]:
            alvo = "informacao_geral_prevencao"
        r.append({**bits, "idade": age, "imunodeprimido": imu, "alvo": alvo})

    return r


def main():
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    rows = synthetic_rows()
    fieldnames = SYM + ["idade", "imunodeprimido", "alvo"]
    with open(OUT, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        w.writerows(rows)
    print(f"Escrito {len(rows)} linhas em {OUT}")


if __name__ == "__main__":
    main()
