// P1B — Script Groovy para Execute Script do RapidMiner / Altair AI Studio.
// Gera regras_aprendidas.pl em formato Prolog a partir do modelo Decision Tree.
//
// Estrategia: usa a POSICAO do filho na lista (1o = valor menor = ausente,
// 2o = valor maior = presente) em vez de parsear a string da condicao,
// pois o formato muda entre versoes do RapidMiner / Altair AI Studio.
// Tambem escreve metadados de debug no topo do .pl (como comentarios Prolog)
// para facilitar diagnostico sem precisar do painel Log.

import com.rapidminer.operator.learner.tree.*

def tm = input[0]
def out = new File('/Users/ruimendes/Documents/GitHub/Projeto_TIA/p1/p1a/regras_aprendidas.pl')

def MAP = [
    'encaminhar_112_imediato':    'inem',
    'contactar_sns24_urgente':    'adr_su',
    'linha_sns24_orientacao':     'transferir_triagem',
    'autocuidado_e_observacao':   'autocuidado',
    'informacao_geral_prevencao': 'transferir_triagem'
]

def regras = []
def debug = []
def primeiraCond = null
def primeiroVal  = null
def childCounts  = [:].withDefault { 0 }

// CF da folha = proporcao da classe maioritaria.
def leafCF = { node ->
    try {
        def counts = node.getCounterMap()
        def total = 0; def maxC = 0
        counts.values().each { v -> total += v; if (v > maxC) maxC = v }
        if (total > 0) return (maxC as double) / total
    } catch (Exception ex) {}
    try {
        def total = node.getSubtreeFrequencySum()
        def maxC  = node.getCounter(node.getLabel())
        if (total > 0) return (maxC as double) / total
    } catch (Exception ex) {}
    return 0.9
}

def go
go = { node, path ->
    if (node.isLeaf()) {
        def cl = node.getLabel()
        def cf = leafCF(node)
        if (cf > 0.9)  cf = 0.9
        if (cf < 0.09) cf = 0.09
        cf = Math.round(cf * 1000) / 1000.0
        if (MAP.containsKey(cl) && !path.isEmpty()) {
            regras << ('if ' + path.unique().join(' and ') + ' then ' + MAP[cl] + ' with ' + cf + '.')
        }
        return
    }
    def it = node.childIterator()
    def idx = 0
    def nKids = 0
    while (it.hasNext()) {
        def e  = it.next()
        def cd = e.getCondition()
        def an = cd.getAttributeName()
        if (primeiraCond == null) {
            primeiraCond = cd.toString()
            try { primeiroVal = cd.getValueString() } catch (Exception ex) { primeiroVal = '?' }
        }
        // No Altair AI Studio o 1o filho corresponde a "> threshold" (presente),
        // o 2o filho a "<= threshold" (ausente). Confirmado via debug:
        // primeiraCond = "apoio_domicilio > 0.500".
        if (idx == 0) {
            go(e.getChild(), path + [an])               // presente
        } else {
            go(e.getChild(), new ArrayList(path))       // ausente
        }
        idx++
        nKids++
    }
    childCounts[nKids] = childCounts[nKids] + 1
}

go(tm.getRoot(), new ArrayList())

debug << '% DEBUG primeiraCond = ' + primeiraCond
debug << '% DEBUG primeiroVal  = ' + primeiroVal
debug << '% DEBUG distribuicao de #filhos por no interno: ' + childCounts.toString()
debug << '% DEBUG total de regras = ' + regras.size()

def hdr = '% P1B - regras aprendidas pelo RapidMiner (Altair AI Studio)\n' +
          '% CF = confianca empirica (proporcao da classe maioritaria na folha).\n' +
          debug.join('\n') + '\n\n' +
          ':- op( 800, fx, if).\n' +
          ':- op( 700, xfx, then).\n' +
          ':- op( 600, xfx, with).\n' +
          ':- op( 300, xfy, or).\n' +
          ':- op( 200, xfy, and).\n' +
          ':- multifile( (if)/1 ).\n\n'

out.text = hdr + regras.sort().join('\n') + '\n'
println('=== P1B Groovy ===')
debug.each { println(it) }
return []
