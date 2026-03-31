
//jQuery time
var current_fs, next_fs, previous_fs; //fieldsets
var left, opacity, scale; //fieldset properties which we will animate
var animating; //flag to prevent quick multi-click glitches

//Next and Previous B1
$(".next").click(function () {
	var btn = $(this)[0].id;

	if (btn == "solutionMethod") METODO = getMETODO();
	if (METODO == null) return;


	if (animating) return false;
	animating = true;

	current_fs = $(this).parent();
	next_fs = $(this).parent().next();

	//activate next step on progressbar using the index of next_fs
	$("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

	//show the next fieldset
	next_fs.show();
	//hide the current fieldset with style
	current_fs.animate({ opacity: 0 }, {
		step: function (now, mx) {
			//as the opacity of current_fs reduces to 0 - stored in "now"
			//1. scale current_fs down to 80%
			scale = 1 - (1 - now) * 0.2;
			//2. bring next_fs from the right(50%)
			left = (now * 50) + "%";
			//3. increase opacity of next_fs to 1 as it moves in
			opacity = 1 - now;
			current_fs.css({
				'transform': 'scale(' + scale + ')',
				'position': 'absolute'
			});
			next_fs.css({ 'left': left, 'opacity': opacity });
		},
		duration: 800,
		complete: function () {
			current_fs.hide();
			animating = false;
		},
		//this comes from the custom easing plugin
		easing: 'easeInOutBack'
	});
});


$(".previous").click(function () {
	if (animating) return false;
	animating = true;

	current_fs = $(this).parent();
	previous_fs = $(this).parent().prev();

	//de-activate current step on progressbar
	$("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

	//show the previous fieldset
	previous_fs.show();
	//hide the current fieldset with style
	current_fs.animate({ opacity: 0 }, {
		step: function (now, mx) {
			//as the opacity of current_fs reduces to 0 - stored in "now"
			//1. scale previous_fs from 80% to 100%
			scale = 0.8 + (1 - now) * 0.2;
			//2. take current_fs to the right(50%) - from 0%
			left = ((1 - now) * 50) + "%";
			//3. increase opacity of previous_fs to 1 as it moves in
			opacity = 1 - now;
			current_fs.css({ 'left': left });
			previous_fs.css({ 'transform': 'scale(' + scale + ')', 'opacity': opacity });
		},
		duration: 800,
		complete: function () {
			current_fs.hide();
			animating = false;
		},
		//this comes from the custom easing plugin
		easing: 'easeInOutBack'
	});
});


//Next and Previous B2
$(".next2").click(function () {
	var btn = $(this)[0].id;

	if (btn == "solutionObjective") OBJETIVO = getOBJETIVO();
	if (OBJETIVO == null) return;

	loadJSON_B2();

	if (animating) return false;
	animating = true;

	current_fs = $(this).parent();
	next_fs = $(this).parent().next();

	//activate next step on progressbar using the index of next_fs
	$("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

	//show the next fieldset
	next_fs.show();
	//hide the current fieldset with style
	current_fs.animate({ opacity: 0 }, {
		step: function (now, mx) {
			//as the opacity of current_fs reduces to 0 - stored in "now"
			//1. scale current_fs down to 80%
			scale = 1 - (1 - now) * 0.2;
			//2. bring next_fs from the right(50%)
			left = (now * 50) + "%";
			//3. increase opacity of next_fs to 1 as it moves in
			opacity = 1 - now;
			current_fs.css({
				'transform': 'scale(' + scale + ')',
				'position': 'absolute'
			});
			next_fs.css({ 'left': left, 'opacity': opacity });
		},
		duration: 800,
		complete: function () {
			current_fs.hide();
			animating = false;
		},
		//this comes from the custom easing plugin
		easing: 'easeInOutBack'
	});
});


$(".previous2").click(function () {
	if (animating) return false;
	animating = true;

	current_fs = $(this).parent();
	previous_fs = $(this).parent().prev();

	//de-activate current step on progressbar
	$("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

	//show the previous fieldset
	previous_fs.show();
	//hide the current fieldset with style
	current_fs.animate({ opacity: 0 }, {
		step: function (now, mx) {
			//as the opacity of current_fs reduces to 0 - stored in "now"
			//1. scale previous_fs from 80% to 100%
			scale = 0.8 + (1 - now) * 0.2;
			//2. take current_fs to the right(50%) - from 0%
			left = ((1 - now) * 50) + "%";
			//3. increase opacity of previous_fs to 1 as it moves in
			opacity = 1 - now;
			current_fs.css({ 'left': left });
			previous_fs.css({ 'transform': 'scale(' + scale + ')', 'opacity': opacity });
		},
		duration: 800,
		complete: function () {
			current_fs.hide();
			animating = false;
		},
		//this comes from the custom easing plugin
		easing: 'easeInOutBack'
	});
});

//******************************************************************************************************************************************** */

//Variables
let opcoesB1 = {}
let opcoesB2 = {}
let numberDest = "";
let numberDest2 = "";
let METODO = "";
let DEST = "";
let FETCH = "";
let OBJETIVO = "";

//Fetch Headers
const myHeaders = new Headers();
myHeaders.append("Content-Type", "application/json");

//Fetch requestOptions
const requestOptions = {
	mode: 'cors',
	method: 'GET',
	redirect: 'follow'
};

//Load json 
function loadJSON_B1() {
	opcoesB1.metodo = METODO;
	opcoesB1.cliente = DEST;
}
function loadJSON_B2() {
	opcoesB2.objetivo = OBJETIVO;
	opcoesB2.cliente = DEST;
}

//Display none of the options area and show the questions area
const solutionOption = document.getElementById("solutionOption");
solutionOption.addEventListener("click", () => {
	OPCAO = getOPCAO();
	if (OPCAO == null) return;

	if (OPCAO == "TransicaoEstados") {
		document.getElementById("optionSection").style.display = 'none';
		document.getElementById("questionsSection_B1").style.display = 'block';
	} else {
		document.getElementById("optionSection").style.display = 'none';
		document.getElementById("questionsSection_B2").style.display = 'block';
	}
})


//Select option 
$(document).on('click', '.optionArea', function () {
	var element = $(this)[0].children[0];
	if ($(".optionAreaSelected")[0]) {
		if (element.classList.contains('optionAreaSelected')) {
			element.classList.remove('optionAreaSelected')
		} else {
			$(".optionAreaSelected")[0].classList.remove("optionAreaSelected");
			element.classList.add('optionAreaSelected');
		}
	} else {
		element.classList.add('optionAreaSelected');
	}
});


//Get option selected
function getOPCAO() {
	const type = document.getElementsByClassName("optionAreaSelected");
	if (type[0] == undefined) {
		document.getElementById("optionError").hidden = false;
		setTimeout(function () {
			document.getElementById("optionError").hidden = true;
		}, 2000);
		return
	}
	return type[0].id;
}


//Display none of the questions area and show the options area
$(".solutionOptionPrevious").click(function () {
	document.getElementById("questionsSection_B1").style.display = 'none';
	document.getElementById("questionsSection_B2").style.display = 'none';
	document.getElementById("optionSection").style.display = 'flex';
});


//Get method selected
function getMETODO() {
	var checkRadio = document.querySelector('input[name="method"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("methodError").hidden = false;
	setTimeout(function () {
		document.getElementById("methodError").hidden = true;
	}, 2000);
}

//Get objective selected
function getOBJETIVO() {
	var checkRadio = document.querySelector('input[name="objective"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("objectiveError").hidden = false;
	setTimeout(function () {
		document.getElementById("objectiveError").hidden = true;
	}, 2000);
}


//Get the number os clientes B1
function getNumberDest() {
	var checkRadio = document.querySelector('input[name="numberDest"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("numberDestError").hidden = false;
	setTimeout(function () {
		document.getElementById("numberDestError").hidden = true;
	}, 2000);
}

//Get the number os clientes B2
function getNumberDest2() {
	var checkRadio = document.querySelector('input[name="numberDest2"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("numberDestError2").hidden = false;
	setTimeout(function () {
		document.getElementById("numberDestError2").hidden = true;
	}, 2000);
}



//Show clients options for selection B1
$(document).ready(function () {
	$('#numberDestArea input[type=radio]').click(function () {
		var checkRadio = document.querySelector('input[name="numberDest"]:checked');
		if (checkRadio.value == 1) {
			document.getElementById("DestAreaObj2").style.display = "none";
			document.getElementById("DestAreaObj1").style.display = "grid";
			$('#DestAreaObj2 input:checkbox').each(function () {
				if (this.checked) {
					this.checked = false;
				}
			})
		} else {
			document.getElementById("DestAreaObj1").style.display = "none";
			document.getElementById("DestAreaObj2").style.display = "grid";
			$('#DestAreaObj1 input:radio').each(function () {
				if (this.checked) {
					this.checked = false;
				}
			})
		}
		document.getElementById("imgAndClient").hidden = false;
	});
});


//Show clients options for selection B2
$(document).ready(function () {
	$('#numberDestArea2 input[type=radio]').click(function () {
		var checkRadio = document.querySelector('input[name="numberDest2"]:checked');
		if (checkRadio.value == 1) {
			document.getElementById("DestAreaObj22").style.display = "none";
			document.getElementById("DestAreaObj12").style.display = "grid";
			$('#DestAreaObj22 input:checkbox').each(function () {
				if (this.checked) {
					this.checked = false;
				}
			})
		} else {
			document.getElementById("DestAreaObj12").style.display = "none";
			document.getElementById("DestAreaObj22").style.display = "grid";
			$('#DestAreaObj12 input:radio').each(function () {
				if (this.checked) {
					this.checked = false;
				}
			})
		}
		document.getElementById("imgAndClient2").hidden = false;
	});
});


//Get clients for deliver objective 1 B1
function getDESTOBJ1() {
	var checkRadio = document.querySelector('input[name="destObj1"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("destObj1Error").hidden = false;
	setTimeout(function () {
		document.getElementById("destObj1Error").hidden = true;
	}, 2000);
}


//Get clients for deliver objective 2 B1
function getDESTOBJ2() {
	let array = [];
	$("input:checkbox[name=destObj2]:checked").each(function () {
		array.push($(this).val());
	});
	var checkedBoxes = document.querySelectorAll('input[name=destObj2]:checked');

	if (checkedBoxes.length != 0) return array;
	document.getElementById("destObj2Error").hidden = false;
	setTimeout(function () {
		document.getElementById("destObj2Error").hidden = true;
	}, 2000);
}


//Only two can be selected B1
let arrayTeste = [];
$('input[name=destObj2]').click(function () {
	var checkedBoxes = document.querySelectorAll('input[name=destObj2]:checked');
	if (checkedBoxes.length >= 3) {
		var retirar = arrayTeste.shift();
		checkedBoxes.forEach(item => {
			if (item.value == retirar) {
				item.checked = false;
				return
			}
		})
		var checkedBoxes2 = document.querySelectorAll('input[name=destObj2]:checked');
		checkedBoxes2.forEach(item => {
			if (!arrayTeste.includes(item.value)) {
				arrayTeste.push(item.value)
			}
		})
	} else {
		arrayTeste = [];
		checkedBoxes.forEach(item => {
			if (!arrayTeste.includes(item.value)) {
				arrayTeste.push(item.value)
			}
		})
	}
});


//Get clients for deliver objective 1 B2
function getDESTOBJ12() {
	var checkRadio = document.querySelector('input[name="destObj12"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("destObj12Error").hidden = false;
	setTimeout(function () {
		document.getElementById("destObj12Error").hidden = true;
	}, 2000);
}


//Get clients for deliver objective 2 B2
function getDESTOBJ22() {
	let array = [];
	$("input:checkbox[name=destObj22]:checked").each(function () {
		array.push($(this).val());
	});
	var checkedBoxes = document.querySelectorAll('input[name=destObj22]:checked');

	if (checkedBoxes.length != 0) return array;
	document.getElementById("destObj22Error").hidden = false;
	setTimeout(function () {
		document.getElementById("destObj22Error").hidden = true;
	}, 2000);
}

//Only two can be selected B2
let arrayTeste2 = [];
$('input[name=destObj22]').click(function () {
	var checkedBoxes = document.querySelectorAll('input[name=destObj22]:checked');
	if (checkedBoxes.length >= 3) {
		var retirar = arrayTeste2.shift();
		checkedBoxes.forEach(item => {
			if (item.value == retirar) {
				item.checked = false;
				return
			}
		})
		var checkedBoxes2 = document.querySelectorAll('input[name=destObj22]:checked');
		checkedBoxes2.forEach(item => {
			if (!arrayTeste2.includes(item.value)) {
				arrayTeste2.push(item.value)
			}
		})
	} else {
		arrayTeste2 = [];
		checkedBoxes.forEach(item => {
			if (!arrayTeste2.includes(item.value)) {
				arrayTeste2.push(item.value)
			}
		})
	}
});


//Submit B1
$("#solutionDestB1").click(function () {
	var btn = $(this)[0].id;

	if (btn == "solutionDestB1") numberDest = getNumberDest();
	if (numberDest == null) return;

	if (numberDest == 1 && btn == "solutionDestB1") DEST = getDESTOBJ1();
	if (numberDest == 2 && btn == "solutionDestB1") DEST = getDESTOBJ2();
	if (DEST == null) return;

	loadJSON_B1();
	TransicaoEstados(opcoesB1);
})

//Submit B2
$("#solutionDestB2").click(function () {
	var btn = $(this)[0].id;

	if (btn == "solutionDestB2") numberDest2 = getNumberDest2();
	if (numberDest2 == null) return;

	if (numberDest2 == 1 && btn == "solutionDestB2") DEST = getDESTOBJ12();
	if (numberDest2 == 2 && btn == "solutionDestB2") DEST = getDESTOBJ22();
	if (DEST == null) return;

	loadJSON_B2();
	HillClimbing(opcoesB2);
})

//back
$(".backBtn").click(function (evt) {
	evt.preventDefault();
	location.reload();
})

//Back to questionnaire
$("#backBtn2").click(function (evt) {
	evt.preventDefault();
	if (OPCAO == "TransicaoEstados") {
		document.getElementById("NoAnswersSection").style.display = 'none';
		document.getElementById("questionsSection_B1").style.display = "block";
	} else {
		document.getElementById("NoAnswersSection").style.display = 'none';
		document.getElementById("questionsSection_B2").style.display = "block";
		document.getElementById("showLucro").hidden = false;
		document.getElementById("showTempo").hidden = false;
	}
})

//Transição de Estados
async function TransicaoEstados(pedido) {
	console.log(pedido);
	document.getElementById("questionsSection_B1").style.display = "none";
	document.getElementById("processingSection").style.display = 'flex';

	if (numberDest == 1) FETCH = `http://127.0.0.1:8080/api/tarefa-b1-obj2/query?clienteA=${pedido.cliente}&clienteB=${pedido.cliente}&metodo=${pedido.metodo}`;
	if (numberDest == 2) {
		if (pedido.cliente.length < 2) {
			FETCH = `http://127.0.0.1:8080/api/tarefa-b1-obj2/query?clienteA=${pedido.cliente[0]}&clienteB=${pedido.cliente[0]}&metodo=${pedido.metodo}`;
		} else {
			FETCH = `http://127.0.0.1:8080/api/tarefa-b1-obj2/query?clienteA=${pedido.cliente[0]}&clienteB=${pedido.cliente[1]}&metodo=${pedido.metodo}`;
		}
	}

	//Fetch
	fetch(FETCH, requestOptions)
		.then(response => response.json())
		.then(result => {
			console.log(result);
			preencherImagem(result.caminho);
			document.getElementById("caminhoS").innerHTML = result.caminho.join(' -> ');
			document.getElementById("metodoS").innerHTML = result.metodo;
			document.getElementById("lucroS").innerHTML = result.lucro;
			document.getElementById("tempoS").innerHTML = result.tempo;
			document.getElementById("passosS").innerHTML = result.passos;

			document.getElementById("processingSection").style.display = 'none';
			document.getElementById("answersSection_B1").style.display = "flex";

		}).catch(error => {
			document.getElementById("processingSection").style.display = 'none';
			document.getElementById("NoAnswersSection").style.display = "flex";
			console.log('error', error);
		});
}


//HillClimbing
async function HillClimbing(pedido) {

	document.getElementById("questionsSection_B2").style.display = "none";
	document.getElementById("processingSection").style.display = 'flex';
	console.log(pedido);


	if (numberDest2 == 1) FETCH = `http://127.0.0.1:8080/api/tarefa-b2-obj2/query?clienteA=${pedido.cliente}&clienteB=${pedido.cliente}&metodo=${pedido.objetivo}`;
	if (numberDest2 == 2) {
		if (pedido.cliente.length < 2) {
			FETCH = `http://127.0.0.1:8080/api/tarefa-b2-obj2/query?clienteA=${pedido.cliente[0]}&clienteB=${pedido.cliente[0]}&metodo=${pedido.objetivo}`;
		} else {
			FETCH = `http://127.0.0.1:8080/api/tarefa-b2-obj2/query?clienteA=${pedido.cliente[0]}&clienteB=${pedido.cliente[1]}&metodo=${pedido.objetivo}`;
		}
	}

	//Fetch
	fetch(FETCH, requestOptions)
		.then(response => response.json())
		.then(result => {
			console.log(result);
			preencherImagem(result.caminho);
			document.getElementById("caminhoS2").innerHTML = result.caminho.join(' -> ');
			document.getElementById("objetivoS").innerHTML = OBJETIVO;

			switch (OBJETIVO) {
				case 'lucro':
					document.getElementById("showLucro").hidden = false;
					document.getElementById("lucroS2").innerHTML = result.totaleval + " €";
					break;
				case 'tempo':
					document.getElementById("showTempo").hidden = false;
					document.getElementById("tempoS2").innerHTML = result.totaleval + " minutos";
					break;
				case 'ambos':
					document.getElementById("showValor").hidden = false;
					document.getElementById("valorS2").innerHTML = result.totaleval;
					break;
			}
			document.getElementById("processingSection").style.display = 'none';
			document.getElementById("answersSection_B2").style.display = "flex";

		}).catch(error => {
			document.getElementById("processingSection").style.display = 'none';
			document.getElementById("NoAnswersSection").style.display = "flex";
			console.log('error', error);
		});
}


function preencherImagem(caminho) {
	const arr = caminho;
	for (let i = 0; i < arr.length; i++) {
		if (i + 1 >= arr.length) return;
		if ((arr[i] == "restaurante" && arr[i + 1] == "cliente1") || (arr[i + 1] == "restaurante" && arr[i] == "cliente1")) {
			// mostrar imagem 1
			document.getElementsByClassName("Moleza1")[0].hidden = false;
			document.getElementsByClassName("Moleza1")[1].hidden = false;
			console.log("1");
		}
		if ((arr[i] == "restaurante" && arr[i + 1] == "cliente4") || (arr[i + 1] == "restaurante" && arr[i] == "cliente4")) {
			// mostrar imagem 3
			document.getElementsByClassName("Moleza3")[0].hidden = false;
			document.getElementsByClassName("Moleza3")[1].hidden = false;
			console.log("3");
		}
		if ((arr[i] == "cliente1" && arr[i + 1] == "cliente2") || arr[i + 1] == "cliente1" && arr[i] == "cliente2") {
			// mostrar imagem 5
			document.getElementsByClassName("Moleza5")[0].hidden = false;
			document.getElementsByClassName("Moleza5")[1].hidden = false;
			console.log("5");
		}
		if ((arr[i] == "cliente1" && arr[i + 1] == "cliente4") || (arr[i + 1] == "cliente1" && arr[i] == "cliente4")) {
			// mostrar imagem 2
			document.getElementsByClassName("Moleza2")[0].hidden = false;
			document.getElementsByClassName("Moleza2")[1].hidden = false;
			console.log("2");
		}
		if ((arr[i] == "cliente1" && arr[i + 1] == "cliente5") || (arr[i + 1] == "cliente1" && arr[i] == "cliente5")) {
			// mostrar imagem 4
			document.getElementsByClassName("Moleza4")[0].hidden = false;
			document.getElementsByClassName("Moleza4")[1].hidden = false;
			console.log("4");
		}
		if ((arr[i] == "cliente2" && arr[i + 1] == "cliente4") || (arr[i + 1] == "cliente2" && arr[i] == "cliente4")) {
			// mostrar imagem 6
			document.getElementsByClassName("Moleza6")[0].hidden = false;
			document.getElementsByClassName("Moleza6")[1].hidden = false;
			console.log("6");
		}
		if ((arr[i] == "cliente2" && arr[i + 1] == "cliente5") || (arr[i + 1] == "cliente2" && arr[i] == "cliente5")) {
			// mostrar imagem 8
			document.getElementsByClassName("Moleza8")[0].hidden = false;
			document.getElementsByClassName("Moleza8")[1].hidden = false;
			console.log("8");
		}
		if ((arr[i] == "cliente2" && arr[i + 1] == "cliente3") || (arr[i + 1] == "cliente2" && arr[i] == "cliente3")) {
			// mostrar imagem 9
			document.getElementsByClassName("Moleza9")[0].hidden = false;
			document.getElementsByClassName("Moleza9")[1].hidden = false;
			console.log("9");
		}
		if ((arr[i] == "cliente3" && arr[i + 1] == "cliente4") || (arr[i + 1] == "cliente3" && arr[i] == "cliente4")) {
			// mostrar imagem 10
			document.getElementsByClassName("Moleza10")[0].hidden = false;
			document.getElementsByClassName("Moleza10")[1].hidden = false;
			console.log("10");
		}
		if ((arr[i] == "cliente3" && arr[i + 1] == "cliente5") || (arr[i + 1] == "cliente3" && arr[i] == "cliente5")) {
			// mostrar imagem 7
			document.getElementsByClassName("Moleza7")[0].hidden = false;
			document.getElementsByClassName("Moleza7")[1].hidden = false;
			console.log("7");
		}
	}
}