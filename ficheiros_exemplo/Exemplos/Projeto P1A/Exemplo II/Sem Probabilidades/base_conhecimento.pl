% Grupo 33: Carlos, João, José, Rui 
% faixa etaria
if 'idade_0_17' then 'idade_adolescente'.
if 'idade_18_29' then 'idade_jovemAdulto'.
if 'idade_30_40' or 'idade_>40' then 'idade_adulto'.

if 'preco_0_7' then 'preco_baixo'.
if 'preco_>7_12' then 'preco_medio'.
if 'preco_>12' then 'preco_alto'.

if 'classificacao_<=45' then 'classificacao_boa'.
if 'classificacao_46_47' then 'classificacao_muito_boa'.
if 'classificacao_>47' then 'classificacao_excelente'.

if 'bebida_incluida' then 'com_bebida'.
if 'bebida_nao_incluida' then 'sem_bebida'.

if 'indiferente' then 'tempo_pouco'.
if 'indiferente' then 'tempo_medio'.
if 'indiferente' then 'tempo_alto'.
if 'paciente' then 'tempo_alto'.
if 'paciente' then 'tempo_medio'.
if 'apressado' and ('idade_adulto' or 'idade_jovemAdulto') then 'tempo_pouco'.
if 'apressado' and ('idade_adulto' or 'idade_jovemAdulto') then 'tempo_medio'.
if 'apressado' and 'idade_adolescente' then 'tempo_pouco'.
if 'alegre' and 'idade_adolescente' then 'tempo_alto'.
if 'alegre' and 'idade_adolescente' then 'tempo_medio'.
if 'alegre' and 'idade_adolescente' then 'tempo_baixo'.
if 'alegre' and ('idade_jovemAdulto' or 'idade_adulto') then 'tempo_medio'.
if 'alegre' and ('idade_jovemAdulto' or 'idade_adulto') then 'tempo_alto'.