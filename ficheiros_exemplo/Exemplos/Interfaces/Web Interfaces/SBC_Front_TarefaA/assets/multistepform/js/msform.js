//jQuery time
var current_fs, next_fs, previous_fs; //fieldsets
var left, opacity, scale; //fieldset properties which we will animate
var animating; //flag to prevent quick multi-click glitches

//Next btn for A1
$(".next").click(function () {
	var btn = $(this)[0].id;
	console.log("ola1")

	if (btn == "orderType") TIPO = getTIPO();
	if (TIPO == null) return;

	if (btn == "orderAge") IDADE = getIDADE();
	if (IDADE == null) return;

	if (btn == "orderPrice") PRECO = getPRECO();
	if (PRECO == undefined) return;

	if (btn == "orderSpirit") ESPIRITO = getESPIRITO();
	if (ESPIRITO == undefined) return;

	if (btn == "orderClassification") CLASSIFICACAO = getCLASSIFICACAO();
	if (CLASSIFICACAO == undefined) return;

	if (btn == "orderCategory") CATEGORIA = getCATEGORIA();
	if (CATEGORIA == undefined) return;


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

//Previous btn for A1
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


//Next btn for A2
$(".next2").click(function () {
	var btn = $(this)[0].id;
	console.log("ola2")

	if (btn == "orderCategory2") CATEGORIA2 = getCATEGORIA2();
	if (CATEGORIA2 == undefined) return;

	if (btn == "orderGender") GENERO = getGENERO();
	if (GENERO == undefined) return;

	if (btn == "orderAge2") IDADE2 = getIDADE2();
	if (IDADE2 == null) return;

	if (btn == "orderDiet") DIETA = getDIETA();
	if (DIETA == null) return;

	if (btn == "orderPrice2") PRECO2 = getPRECO2();
	if (PRECO2 == undefined) return;

	if (btn == "orderClassification2") CLASSIFICACAO2 = getCLASSIFICACAO2();
	if (CLASSIFICACAO2 == undefined) return;


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


//Previous btn for A2
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
//Select between A1 and A2
const recomendationOption = document.getElementById("recomendationOption");
recomendationOption.addEventListener("click", () => {
	OPCAO = getOPCAO();
	if (OPCAO == null) return;
	if (OPCAO == 'conhecimento_manual') {
		document.getElementById("optionSection").style.display = 'none';
		document.getElementById("questionsSection_A1").style.display = 'block';
	} else {
		document.getElementById("optionSection").style.display = 'none';
		document.getElementById("questionsSection_A2").style.display = 'block';
	}
})

//Back to select between A1 and A2 - A1
const recomendationOptionPrevious = document.getElementById("recomendationOptionPrevious");
recomendationOptionPrevious.addEventListener("click", () => {
	document.getElementById("questionsSection_A1").style.display = 'none';
	document.getElementById("optionSection").style.display = 'flex';
})
//Back to select between A1 and A2 - A2
const recomendationOptionPrevious2 = document.getElementById("recomendationOptionPrevious2");
recomendationOptionPrevious2.addEventListener("click", () => {
	document.getElementById("questionsSection_A2").style.display = 'none';
	document.getElementById("optionSection").style.display = 'flex';
})

//Select option of order  (imagens)
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


//Select type of order  (imagens)
$(document).on('click', '.typeArea', function () {
	var element = $(this)[0].children[0];
	if ($(".typeAreaSelected")[0]) {
		if (element.classList.contains('typeAreaSelected')) {
			element.classList.remove('typeAreaSelected')
		} else {
			$(".typeAreaSelected")[0].classList.remove("typeAreaSelected");;
			element.classList.add('typeAreaSelected');
		}
	} else {
		element.classList.add('typeAreaSelected');
	}
});


//Select drink of order  (imagens)
$(document).on('click', '.drinkArea', function () {
	var element = $(this)[0].children[0];
	if ($(".drinkAreaSelected")[0]) {
		if (element.classList.contains('drinkAreaSelected')) {
			element.classList.remove('drinkAreaSelected')
		} else {
			$(".drinkAreaSelected")[0].classList.remove("drinkAreaSelected");
			element.classList.add('drinkAreaSelected');
		}
	} else {
		element.classList.add('drinkAreaSelected');
	}
});


//Select category of order A1 (imagens)
$(document).on('click', '.categoryArea', function () {
	var element = $(this)[0].children[0];
	if ($(".categoryAreaSelected")[0]) {
		if (element.classList.contains('categoryAreaSelected')) {
			element.classList.remove('categoryAreaSelected')
		} else {
			$(".categoryAreaSelected")[0].classList.remove("categoryAreaSelected");
			element.classList.add('categoryAreaSelected');
		}
	} else {
		element.classList.add('categoryAreaSelected');
	}
});


//Select category of order A2 (imagens)
$(document).on('click', '.categoryArea2', function () {
	var element = $(this)[0].children[0];
	if ($(".categoryAreaSelected2")[0]) {
		if (element.classList.contains('categoryAreaSelected2')) {
			element.classList.remove('categoryAreaSelected2')
		} else {
			$(".categoryAreaSelected2")[0].classList.remove("categoryAreaSelected2");
			element.classList.add('categoryAreaSelected2');
		}
	} else {
		element.classList.add('categoryAreaSelected2');
	}
});


//Select gender of client (imagens)
$(document).on('click', '.genderArea', function () {
	var element = $(this)[0].children[0];
	if ($(".genderAreaSelected")[0]) {
		if (element.classList.contains('genderAreaSelected')) {
			element.classList.remove('genderAreaSelected')
		} else {
			$(".genderAreaSelected")[0].classList.remove("genderAreaSelected");
			element.classList.add('genderAreaSelected');
		}
	} else {
		element.classList.add('genderAreaSelected');
	}
});

//Variables
let OPCAO = "";
let pedido = {}
let pedido2 = {}
let TIPO = "";
let PRECO = "";
let PRECO2 = "";
let IDADE = "";
let IDADE2 = "";
let CLASSIFICACAO = "";
let CLASSIFICACAO2 = "";
let CATEGORIA = "";
let CATEGORIA2 = "";
let ESPIRITO = "";
let BEBIDA = "";
let GENERO = "";
let DIETA = "";
let DURACAO = "";

//Fetch Headers
const myHeaders = new Headers();
myHeaders.append("Content-Type", "application/json");

//Fetch requestOptions
const requestOptions = {
	mode: 'cors',
	method: 'GET',
	redirect: 'follow'
};

//Load JSON A1
function loadJSON_A1() {
	pedido.tipo = TIPO;
	pedido.preco = PRECO;
	pedido.idade = IDADE;
	pedido.classificacao = CLASSIFICACAO;
	pedido.categoria = CATEGORIA;
	pedido.espirito = ESPIRITO;
	pedido.bebida = BEBIDA;
}

//Load JSON A2
function loadJSON_A2() {
	pedido2.categorias = CATEGORIA2;
	pedido2.sexo = GENERO;
	pedido2.idade = IDADE2;
	pedido2.dieta = DIETA;
	pedido2.preco = PRECO2;
	pedido2.classificacao = CLASSIFICACAO2;
	pedido2.duracao = DURACAO;
}


//Get option
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

//Get type of order
function getTIPO() {
	const type = document.getElementsByClassName("typeAreaSelected");
	if (type[0] == undefined) {
		document.getElementById("typeError").hidden = false;
		setTimeout(function () {
			document.getElementById("typeError").hidden = true;
		}, 2000);
		return
	}
	return type[0].id;
}

//Get order price
function getIDADE() {
	var checkRadio = document.querySelector('input[name="age"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("ageError").hidden = false;
	setTimeout(function () {
		document.getElementById("ageError").hidden = true;
	}, 2000);
}
//Get order price
function getIDADE2() {
	var checkRadio = document.querySelector('input[name="age2"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("ageError2").hidden = false;
	setTimeout(function () {
		document.getElementById("ageError2").hidden = true;
	}, 2000);
}

//Get order price
function getPRECO() {
	var checkRadio = document.querySelector('input[name="price"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("priceError").hidden = false;
	setTimeout(function () {
		document.getElementById("priceError").hidden = true;
	}, 2000);
}
//Get order price
function getPRECO2() {
	var checkRadio = document.querySelector('input[name="price2"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("priceError2").hidden = false;
	setTimeout(function () {
		document.getElementById("priceError2").hidden = true;
	}, 2000);
}

//Get client spirit
function getESPIRITO() {
	var checkRadio = document.querySelector('input[name="spirit"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("spiritError").hidden = false;
	setTimeout(function () {
		document.getElementById("spiritError").hidden = true;
	}, 2000);
}

//Get classification
function getCLASSIFICACAO() {
	var checkRadio = document.querySelector('input[name="classification"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("classificationError").hidden = false;
	setTimeout(function () {
		document.getElementById("classificationError").hidden = true;
	}, 2000);
}
//Get classification
function getCLASSIFICACAO2() {
	var checkRadio = document.querySelector('input[name="classification2"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("classificationError2").hidden = false;
	setTimeout(function () {
		document.getElementById("classificationError2").hidden = true;
	}, 2000);
}

//Get Category
function getCATEGORIA() {
	const type = document.getElementsByClassName("categoryAreaSelected");
	if (type[0] == undefined) {
		document.getElementById("categoryError").hidden = false;
		setTimeout(function () {
			document.getElementById("categoryError").hidden = true;
		}, 2000);
		return
	}
	return type[0].id;
}
//Get Category
function getCATEGORIA2() {
	const type = document.getElementsByClassName("categoryAreaSelected2");
	if (type[0] == undefined) {
		document.getElementById("categoryError2").hidden = false;
		setTimeout(function () {
			document.getElementById("categoryError2").hidden = true;
		}, 2000);
		return
	}
	return type[0].id;
}

//Get dink
function getBEBIDA() {
	const type = document.getElementsByClassName("drinkAreaSelected");
	if (type[0] == undefined) {
		document.getElementById("drinkError").hidden = false;
		setTimeout(function () {
			document.getElementById("drinkError").hidden = true;
		}, 2000);
		return
	}
	return type[0].id;
}

//Get Gender
function getGENERO() {
	const type = document.getElementsByClassName("genderAreaSelected");
	if (type[0] == undefined) {
		document.getElementById("genderError").hidden = false;
		setTimeout(function () {
			document.getElementById("genderError").hidden = true;
		}, 2000);
		return
	}
	return type[0].id;
}

//Get client diet
function getDIETA() {
	console.log("p")
	var checkRadio = document.querySelector('input[name="diet"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("dietError").hidden = false;
	setTimeout(function () {
		document.getElementById("dietError").hidden = true;
	}, 2000);
}

//Get order duration
function getDURACAO() {
	var checkRadio = document.querySelector('input[name="duration"]:checked');
	if (checkRadio != null) return checkRadio.value;
	document.getElementById("durationError").hidden = false;
	setTimeout(function () {
		document.getElementById("durationError").hidden = true;
	}, 2000);
}


//Submit A1
$("#orderDrink").click(function () {
	var btn = $(this)[0].id;
	if (btn == "orderDrink") BEBIDA = getBEBIDA();
	if (BEBIDA == undefined) return

	if (OPCAO == 'conhecimento_manual') {
		loadJSON_A1();
		submeterPedidoManual();
	}
	if (OPCAO == 'conhecimento_automatico') {
		loadJSON_A2();
		submeterPedidoAuto();
	}
})

//Submit A2 
$("#orderDuration").click(function () {
	var btn = $(this)[0].id;
	if (btn == "orderDuration") DURACAO = getDURACAO();
	if (DURACAO == undefined) return

	if (OPCAO == 'conhecimento_manual') {
		loadJSON_A1();
		submeterPedidoManual();
	}
	if (OPCAO == 'conhecimento_automatico') {
		loadJSON_A2();
		submeterPedidoAuto();
	}
})


//Back to star
$(".backBtn").click(function (evt) {
	evt.preventDefault();
	location.reload();
})

//Back to questionnaire
$("#backBtn2").click(function (evt) {
	evt.preventDefault();
	document.getElementById("NoAnswersSection").style.display = 'none';
	if (OPCAO == 'conhecimento_manual') {
		document.getElementById("questionsSection_A1").style.display = "block";
	} else {
		document.getElementById("questionsSection_A2").style.display = "block";
	}
})

//Conhecimento Manual
async function submeterPedidoManual() {
	let conteudo = "";
	console.log(pedido);

	document.getElementById("questionsSection_A1").style.display = "none";
	document.getElementById("processingSection").style.display = 'flex';

	//Fetch
	//fetch('http://127.0.0.1:8080/api/tarefa-a1/query?tipo=entregar&preco=preco_0_7&idade=idade_18_29&estado_espirito=apressado&classificacao=classificacao_46_47&categoria=carnes&bebida=bebida_nao_incluida', requestOptions)
	fetch("http://127.0.0.1:8080/api/tarefa-a1/query?tipo=" + pedido.tipo + "&preco=" + pedido.preco + "&idade=" + pedido.idade + "&estado_espirito=" + pedido.espirito + "&classificacao=" + pedido.classificacao + "&categoria=" + pedido.categoria + "&bebida=" + pedido.bebida, requestOptions)
		.then(response => response.json())
		.then(result => {
			console.log(result);
			result.sort((a, b) => parseFloat(b.probabilidade) - parseFloat(a.probabilidade));
			console.log(result);

			for (const recomendacao of result) {
				conteudo += `<tr><td>${recomendacao.probabilidade}</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>`;
				conteudo += "<tr><td><img class='imgResult' src='" + recomendacao.imagem + "'></td>";
				conteudo += "<td>" + recomendacao.nome + "</td>";
				conteudo += "<td>" + recomendacao.categoria + "</td>";
				conteudo += "<td>" + recomendacao.restaurante + "</td>";
				conteudo += "<td>" + recomendacao.duracaoMin + " a " + recomendacao.duracaoMax + "</td>";
				conteudo += "<td>" + recomendacao.preco + " €</td>";
				conteudo += "<td>" + recomendacao.localizacao + "</td></tr>";
			}
			document.getElementById("showResult").innerHTML = conteudo;
			document.getElementById("processingSection").style.display = 'none';
			document.getElementById("answersSection_A1").style.display = "flex";

		}).catch(error => {
			document.getElementById("processingSection").style.display = 'none';
			document.getElementById("NoAnswersSection").style.display = "flex";
			console.log('error', error)
		});
}

//Conhecimento Automático
async function submeterPedidoAuto() {
	console.log(pedido2);

	document.getElementById("questionsSection_A2").style.display = "none";
	document.getElementById("processingSection").style.display = 'flex';

	//Fetch
	//fetch('http://127.0.0.1:8080/api/tarefa-a2/query?sexo=masculino&categoria=hamburguer&tempo=tempo_medio&idade=0-17&preco=preco_baixo&classificacao=classificacao_boa&dieta=nao_saudavel', requestOptions)
	fetch("http://127.0.0.1:8080/api/tarefa-a2/query?sexo=" + pedido2.sexo + "&categoria=" + pedido2.categorias + "&tempo=" + pedido2.duracao + "&idade=" + pedido2.idade + "&preco=" + pedido2.preco + "&classificacao=" + pedido2.classificacao + "&dieta=" + pedido2.dieta, requestOptions)
		.then(response => response.text())
		.then(result => {
			let resposta = "";
			switch (result) {
				case 'yes':
					resposta = `Boa escolha, a categoria que escolheste "${pedido2.categorias}" parece ser uma boa opção!`;
					document.getElementById("resultImg").src = `img/${pedido2.categorias}.png`;
					document.getElementById("resultCategory").hidden = false;
					document.getElementById("resultCategory").innerHTML = pedido2.categorias;
					break;
				case 'no':
					resposta = `"${pedido2.categorias}"? Não te aconcelhamos a essa categoria, secalhar é melhor escolher outra!`;
					document.getElementById("resultImg").src = `img/${pedido2.categorias}.png`;
					document.getElementById("resultCategory").hidden = false;
					document.getElementById("resultCategory").innerHTML = pedido2.categorias;
					break;
				default: resposta = `Não te conseguimos dar uma resposta concreta!`;
					document.getElementById("resultImg").src = "img/tenor.gif";
					break;
			}
			document.getElementById("showResult2").innerHTML = resposta;
			document.getElementById("processingSection").style.display = 'none';
			document.getElementById("answersSection_A2").style.display = "flex";

		}).catch(error => {
			document.getElementById("processingSection").style.display = 'none';
			document.getElementById("NoAnswersSection").style.display = "flex";
			console.log('error', error)
		});
}