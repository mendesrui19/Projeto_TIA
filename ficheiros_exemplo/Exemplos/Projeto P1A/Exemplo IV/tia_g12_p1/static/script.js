document.addEventListener('DOMContentLoaded', function() {
    const colorTranslations = {
        'red': 'Vermelho',
        'orange': 'Laranja',
        'yellow': 'Amarelo',
        'green': 'Verde',
        'blue': 'Azul'
    };

    function loadCaseTypes() {
        fetch('/api/case-types')
            .then(response => response.json())
            .then(caseTypes => {
                const container = document.getElementById('case-type-questions');
                container.innerHTML = '';
                
                const regularTypes = caseTypes.filter(type => type.id !== 'Nenhuma das anteriores');
                
                regularTypes.forEach((caseType) => {
                    const div = document.createElement('div');
                    div.className = 'case-type-item';
                    
                    const label = document.createElement('label');
                    label.className = 'question-text';
                    
                    const radio = document.createElement('input');
                    radio.type = 'radio';
                    radio.name = 'case-type';
                    radio.value = caseType.id;
                    
                    label.appendChild(radio);
                    label.appendChild(document.createTextNode(' ' + caseType.question));
                    
                    div.appendChild(label);
                    container.appendChild(div);
                });
            });
    }

    // Initial load of case types when page loads
    loadCaseTypes();

    // Handle case identification
    document.getElementById('identify-btn').addEventListener('click', function() {
        const selectedCase = document.querySelector('input[name="case-type"]:checked');
        const identifyBtn = document.getElementById('identify-btn');
        
        if (!selectedCase) {
            const container = document.getElementById('case-type-questions');
            container.innerHTML = '<h3>Caso não identificado!</h3>';
            identifyBtn.style.display = 'none';
            
            const restartBtn = document.createElement('button');
            restartBtn.id = 'restart-unidentified';
            restartBtn.textContent = 'Voltar ao Início';
            restartBtn.onclick = function() {
                identifyBtn.style.display = 'block';
                document.getElementById('case-selection').style.display = 'none';
                document.getElementById('approach-selection').style.display = 'block';
                document.getElementById('case-type-questions').innerHTML = '';
                this.remove();
            };
            container.appendChild(restartBtn);
            return;
        }

        const container = document.getElementById('case-type-questions');
        const caseHeader = document.createElement('h3');
        const boldPart = document.createElement('strong');
        boldPart.textContent = 'Caso Identificado:';
        caseHeader.appendChild(boldPart);
        caseHeader.appendChild(document.createTextNode(' ' + selectedCase.value));
        container.innerHTML = '';
        container.appendChild(caseHeader);
        identifyBtn.style.display = 'none';
        
        // Continue with symptoms
        fetch('/api/symptoms', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ caseType: selectedCase.value })
        })
        .then(response => response.json())
        .then(symptoms => {
            const symptomsDiv = document.getElementById('symptoms-list');
            symptomsDiv.innerHTML = '';
            
            // Create two columns
            const leftColumn = document.createElement('div');
            leftColumn.className = 'symptoms-column';
            const rightColumn = document.createElement('div');
            rightColumn.className = 'symptoms-column';
            
            // Calculate middle index
            const midIndex = Math.ceil(symptoms.length / 2);
            
            // Split symptoms between columns
            symptoms.forEach((symptom, index) => {
                const div = document.createElement('div');
                div.className = 'symptom-item';
                
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.id = symptom.id;
                checkbox.value = symptom.id;
                
                const label = document.createElement('label');
                label.htmlFor = symptom.id;
                label.textContent = symptom.question;
                
                div.appendChild(checkbox);
                div.appendChild(label);
                
                // Add to appropriate column
                if (index < midIndex) {
                    leftColumn.appendChild(div);
                } else {
                    rightColumn.appendChild(div);
                }
            });
            
            symptomsDiv.appendChild(leftColumn);
            symptomsDiv.appendChild(rightColumn);
            
            document.getElementById('symptoms-selection').style.display = 'block';
        });
    });

    // Handle evaluation
    document.getElementById('evaluate-btn').addEventListener('click', function() {
        const caseTitle = document.querySelector('#case-type-questions h3').textContent;
        const caseType = caseTitle.replace('Caso Identificado: ', '');
        const selectedSymptoms = Array.from(document.querySelectorAll('#symptoms-list input:checked')).map(checkbox => checkbox.value);

        fetch('/api/evaluate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                caseType: caseType,
                symptoms: selectedSymptoms
            })
        })
        .then(response => response.json())
        .then(result => {
            document.getElementById('case-selection').style.display = 'none';
            document.getElementById('symptoms-selection').style.display = 'none';
            
            const explanationDiv = document.querySelector('.explanation');
            explanationDiv.innerHTML = `
                <h3>${result.explanation[0]}</h3>
                <ul>
                    ${result.explanation.slice(1).map(point => `<li>${point}</li>`).join('')}
                </ul>
            `;
            
            const resultColor = document.getElementById('result-color');
            const translatedColor = colorTranslations[result.color.toLowerCase()] || result.color;
            resultColor.textContent = `${translatedColor} (Certeza: ${(result.certainty * 100).toFixed(1)}%)`;
            resultColor.style.color = result.color.toLowerCase();
            
            document.getElementById('result-case').textContent = result.caseType;
            
            const symptomsList = document.getElementById('result-symptoms');
            symptomsList.innerHTML = '';
            result.symptoms.forEach(symptom => {
                const li = document.createElement('li');
                li.textContent = symptom;
                symptomsList.appendChild(li);
            });
            
            document.getElementById('result').style.display = 'block';
        });
    });

    // Handle restart
    document.getElementById('restart-btn').addEventListener('click', function() {
        document.getElementById('result').style.display = 'none';
        document.getElementById('case-selection').style.display = 'none';
        document.getElementById('symptoms-selection').style.display = 'none';
        document.getElementById('inductive-questions').style.display = 'none';
        document.getElementById('approach-selection').style.display = 'block';
        document.getElementById('symptoms-list').innerHTML = '';
        document.getElementById('case-type-questions').innerHTML = '';
        document.getElementById('identify-btn').style.display = 'block';
    });

    // Handle approach selection
    document.getElementById('deductive-btn').addEventListener('click', function() {
        document.getElementById('approach-selection').style.display = 'none';
        document.getElementById('case-selection').style.display = 'block';
        document.getElementById('identify-btn').style.display = 'block';
        loadCaseTypes();
    });

    document.getElementById('inductive-btn').addEventListener('click', function() {
        document.getElementById('approach-selection').style.display = 'none';
        document.getElementById('inductive-questions').style.display = 'block';
        loadInductiveSymptoms();
    });

    function loadInductiveSymptoms() {
        fetch('/api/inductive-symptoms')
            .then(response => response.json())
            .then(questions => {
                const container = document.getElementById('symptom-questions');
                container.innerHTML = '';

                questions.forEach(q => {
                    const div = document.createElement('div');
                    div.className = 'symptom-item';
                    
                    const label = document.createElement('label');
                    const checkbox = document.createElement('input');
                    checkbox.type = 'checkbox';
                    checkbox.id = q.id;
                    checkbox.value = q.id;
                    
                    const cleanQuestion = q.question.replace(/\s*\(\s*$/, '');
                    
                    label.appendChild(checkbox);
                    label.appendChild(document.createTextNode(' ' + cleanQuestion));
                    
                    div.appendChild(label);
                    container.appendChild(div);
                });
            });
    }

    document.getElementById('evaluate-inductive-btn').addEventListener('click', function() {
        const selectedSymptoms = Array.from(document.querySelectorAll('#symptom-questions input:checked')).map(cb => cb.value);
        
        fetch('/api/evaluate-inductive', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ symptoms: selectedSymptoms })
        })
        .then(response => response.json())
        .then(result => {
            document.getElementById('inductive-questions').style.display = 'none';
            
            const explanationDiv = document.querySelector('.explanation');
            explanationDiv.innerHTML = `
                <h3>${result.explanation[0]}</h3>
                <ul>
                    ${result.explanation.slice(1).map(point => `<li>${point}</li>`).join('')}
                </ul>
            `;
            
            const resultColor = document.getElementById('result-color');
            const translatedColor = colorTranslations[result.color.toLowerCase()] || result.color;
            resultColor.textContent = `${translatedColor} (Certeza: ${(result.certainty * 100).toFixed(1)}%)`;
            resultColor.style.color = result.color.toLowerCase();
            
            document.getElementById('result-case').textContent = 'Avaliação Indutiva';
            
            const symptomsList = document.getElementById('result-symptoms');
            symptomsList.innerHTML = '';
            result.symptoms.forEach(symptom => {
                const li = document.createElement('li');
                li.textContent = symptom;
                symptomsList.appendChild(li);
            });
            
            document.getElementById('result').style.display = 'block';
        });
    });
});