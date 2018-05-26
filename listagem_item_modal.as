// ====================================================
// LISTAGEM - Init
// ====================================================
function listagem_item_modal(alvo){
	
	// -------------------
	// Variaveis Iniciais:
	var posy = 250;
	
	// ---------------------------------------------------
	// Definição de tamanho de Imagem no Modal de Produto:
	trace(alvo.infos.id_produtos_templates['id'])
	if(alvo.infos["id_"+blast.list.table['produtos_templates']]['id']=="3"){ 
		posy = 310;
	};
	
	// -------------------------------
	// Cria Modal "NATIVO" de Eventos:
	modal_abrir("modal_item",["eventos",alvo.infos,"imagem2","imagem1",posy,alvo.infos.cor_titulo,alvo.infos.cor_fundo,alvo.infos["id_"+blast.list.table['produtos_templates']]['id']],alvo.infos.nome_completo,alvo.infos.descricao,true,null,"G");
	root["modal_item"].infos = alvo.infos;
	
	// --------------
	// Ajusta Textos:
	if(alvo.infos.nome.length>19 || alvo.infos["id_"+blast.list.table['produtos_templates']]['id']==3){
		root["modal_desc_titulo"].texto.htmlText = "<font color='#"+cortexto+"'>"+alvo.infos.descricao.substr(0,100)+"...</font>";
	};
	
	// -------------------------------
	// Inclui LIKE + Compartilhamento:
	item_like(alvo,54,posy-35);
	
	// ------------------------------------
	// Inclui Quadro de Pagamento
	root["botao_pagamento"] = new box_de_pagamento();
	root["botao_pagamento"].x=46;
	root["botao_pagamento"].y=415;
	
	// -----------------
	// # 1) Informações:
	root["botao_pagamento"].informacoes.titulo.text= alvo.infos.chamada_de_pagamento;
	
	// -------------------------
	// # 2) Regras de Pagamento: (Texto)
	if(alvo.infos.gratuito=="1" || alvo.infos.gratuito==1){
		root["botao_pagamento"].informacoes.valor.htmlText= '<font color="#3CD27F">"GRATUITO"</font>';
		root["botao_pagamento"].informacoes.forma_de_pagamento.autoSize = TextFieldAutoSize.CENTER
		root["botao_pagamento"].informacoes.forma_de_pagamento.width=237;
		root["botao_pagamento"].informacoes.forma_de_pagamento.htmlText = "<font color='#"+cortexto+"'>(Nenhum valor será cobrado de você)</font>";
	}else{
		if(alvo.infos.valor_em_aberto==1){
			root["botao_pagamento"].informacoes.valor.htmlText= '"Você define o Valor"';
		}else{
			if(alvo.infos.parcelas_max_no_credito<=1){
				root["botao_pagamento"].informacoes.valor.htmlText= ""+convertValor(alvo.infos.valor)+" <font size='14'>(A vista)</font>";
			}else{
				root["botao_pagamento"].informacoes.valor.htmlText= ""+convertValor(alvo.infos.valor)+" <font size='14'>ou em até ("+alvo.infos.parcelas_max_no_credito+"x de "+convertValor(alvo.infos.valor/alvo.infos.parcelas_max_no_credito)+")</font>";
			};
		};
	};
	
	// -------------------------
	// # 3) Regras de Pagamento: (Formas)
	if(alvo.infos.gratuito=="1" || alvo.infos.gratuito==1){
		root["botao_pagamento"].informacoes.credito.visible=false;
		root["botao_pagamento"].informacoes.boleto.visible=false;
	}else{
		if(alvo.infos.forma_credito==0){ root["botao_pagamento"].informacoes.credito.alpha=.2; };
		if(alvo.infos.forma_boleto==0){ root["botao_pagamento"].informacoes.boleto.alpha=.2; };
	};
	
	// ----------------------------
	// # 4) Informações Adicionais:
	if(alvo.infos.informacoes_adicionais!="" && alvo.infos.informacoes_adicionais!="null" && alvo.infos.informacoes_adicionais!=null){
		root["botao_pagamento"].infos_adicionais.addEventListener(MouseEvent.CLICK, botao_pagamento_infosadd_click);
		function botao_pagamento_infosadd_click(){
			modal_abrir("botao_pagamento_infosadd",["texto","Informações Adicionais",alvo.infos.informacoes_adicionais],"","",true,null,"G")
		};
	}else{
		root["botao_pagamento"].infos_adicionais.visible=false;
		root["botao_pagamento"].informacoes.y += 35;
		root["botao_pagamento"].fundo.y += 35;
	};
	
	// -----------------------------------------
	// # 5) Inclui botão de Método de pagamento:
	root["botao_pagamento"].pagar.texto.text= alvo.infos.botao_chamada;
	root["botao_pagamento"].pagar.buttonMode = true;
	root["botao_pagamento"].pagar['id'] = alvo.infos['id'];
	root["botao_pagamento"].pagar['gratuito'] = alvo.infos['gratuito'];
	root["botao_pagamento"].pagar['tabela'] = "produtos";
	root["botao_pagamento"].pagar.addEventListener(MouseEvent.CLICK, adquirir_item);
	function adquirir_item(e:MouseEvent):void {
		destroir(modal,true);
		var alvo = e.currentTarget;
		processar_pagamento(alvo['id'],alvo.tabela);
	};
	
	// --------------------------
	// Adiciona Box de Pagamento:
	root["modal_item"].addChild(root["botao_pagamento"]);
}