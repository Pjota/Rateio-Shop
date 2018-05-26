// ====================================================
// LISTAGEM DE ATIVIDADES: Inicial
// ====================================================
function atividades(sessao){
	pages_history.push("atividades");
	root[blast.list[app].pages.menu_superior.template+"_alpha"](false,"normal");
	atividades_load();
};
// ====================================================
// LISTAGEM DE ATIVIDADES: Constroi Página
// ====================================================
function atividades_load(){
	
	// Variáveis Iniciais:
	var ultima_compra = 0;
	
	// Conteúdo + Clipe com Rolagem:
	root["atividades_conteudo"] = new Vazio();
	root["atividades_conteudo"].y = 80;
	tela.addChild(root["atividades_conteudo"]);
	root["atividades_listagem"] = new Vazio();
	
	// Espaçamento:
	root["atividades_spacer"] = new spacer();
	root["atividades_listagem"].addChild(root["atividades_spacer"]);
	
	// Título e Descrição:
	root["atividades_titulo"] = new Titulo();
	root["atividades_titulo"].y = 25;
	root["atividades_titulo"].titulo.htmlText="<font color='#"+corbt1+"'>Minhas Atividades</font>";
	root["atividades_titulo"].texto.htmlText="<font color='#"+cortexto+"'>Confira aqui todos os itens já acessados/pagos:</font>";
	root["atividades_titulo"].texto.autoSize =  TextFieldAutoSize.CENTER ;
	root["atividades_listagem"].addChild(root["atividades_titulo"]);
	
	// Listagem de todos os itens:
	connectServer(false,"screen",servidor+"api/list/sh_vendas/tabela=sh_usuarios,id_responsavel="+root["User"]['id']+",level=3,order_column=cadastro,order_direct=DESC",[
	],getAtividades);
	function getAtividades(dados){
		var a;
		for(var i=0; i<dados.list.length; i++){
			
			// # Criação do Elemento de Feed:
			root["atividades_"+(i+1)] = new Atividade_Design();
			a = root["atividades_"+(i+1)];
			a.infos = dados.list[i];
			
			// # Informações:
			if(dados.list[i]['status']=="Aguardando"){
				a.calendario.htmlText = "<font color='#30BDD5'>"+convertDataDiaMesHora(dados.list[i].cadastro)+" (Aguard. Pagamento)</font>";
			};
			if(dados.list[i]['status']=="Aprovado"){
				a.calendario.htmlText = "<font color='#3CD27F'>"+convertDataDiaMesHora(dados.list[i].cadastro)+" (Pagamento Aprovado)</font>";
			};
			if(dados.list[i].forma_de_pagamento=="F"){
				a.calendario.htmlText = "<font color='#3CD27F'>"+convertDataDiaMesHora(dados.list[i].cadastro)+"</font>";
			};
			// # Nome do Produto + Tipo de Produto:
			var titulo = dados.list[i]['label'];
			if(titulo.length>25){ titulo = titulo.substr(0,25)+"..."; }
			a.titulo.htmlText = "<font color='#"+cortexto+"'>"+titulo+"</font><br><font color='#"+corbt1+"'>Tipo:</font> <font color='#"+cortexto+"'>"+dados.list[i].id_sh_itens_tipos.nome+"</font>";
			
			// ------------------
			// Modalidade: "Free"
			if(dados.list[i].forma_de_pagamento=="F"){
				a.valores.x-=30;
				a.valores.htmlText = "<font color='#"+cortexto+"'>Disponibilizado Gratuitamente</font>";
			};
			// ---------------------
			// Modalidade: "Crédito"
			if(dados.list[i].forma_de_pagamento=="C"){
				root["atividades_icone"+(i+1)] = new icone_credito();
				a.valores.htmlText = "<font color='#"+cortexto+"'>Valor: "+convertValor(dados.list[i].valor)+" em "+dados.list[i].parcelas+"x no Crédito</font>";
				root["atividades_icone"+(i+1)].y = 70;
				root["atividades_icone"+(i+1)].x = 86;
				a.addChild(root["atividades_icone"+(i+1)]);
			};
			// --------------------
			// Modalidade: "Débito"
			if(dados.list[i].forma_de_pagamento=="D"){
				root["atividades_icone"+(i+1)] = new icone_boleto();
				a.valores.htmlText = "<font color='#"+cortexto+"'>Valor: "+convertValor(dados.list[i].valor)+" no Boleto Bancário</font>";
				root["atividades_icone"+(i+1)].y = 70;
				root["atividades_icone"+(i+1)].x = 86;
				a.addChild(root["atividades_icone"+(i+1)]);
			};
			// --------------------
			// Ajusta Layout:
			a.x=20;
			if(i==0){a.y=100;}else{a.y = root["atividades_"+(i)].y+root["atividades_"+(i)].height+10;}
			
			// Aplica foto do Item:
			img_load("atividades_img"+(i+1),blast.list[app].paths.upload_path+"/"+dados.list[i].imagem,a.foto.localimagem,["width",60],null,[0,0,"left"],[],0,null)
			
			// Aplicação dos ícones de funções:
			if(dados.list[i]['status']=="Aguardando"){
				criaIcon("atividades_action_"+(i+1),a,blast.list[app].paths.icon_master_path+"/"+dados.list[i].id_sh_itens_tipos.id_blast_icones.imagem,270,20,50,"bullet",["0xffffff","0xc3c3c3"],["alpha","easeOutExpo",1]);
			}
			if(dados.list[i]['status']=="Aprovado"){
				criaIcon("atividades_action_"+(i+1),a,blast.list[app].paths.icon_master_path+"/"+dados.list[i].id_sh_itens_tipos.id_blast_icones.imagem,270,20,50,"bullet",["0xffffff","0x43BFE9"],["alpha","easeOutExpo",1]);
			}
			// --------------------
			// # Abertura do Comporvante:
			a.addEventListener(MouseEvent.MOUSE_DOWN,atividades_clique_start);
			a.addEventListener(MouseEvent.MOUSE_UP,atividades_clique_stop);
			a.buttonMode = true;
			// --------------------
			// # Aplica Elemento:
			root["atividades_listagem"].addChild(a);
			// --------------------
			// # É a última compra?
			if(root["ultima_compra_id"]>0){
				if(dados.list[i]['id'] == root["ultima_compra_id"]){
					ultima_compra = i+1;
					trace("Última Compra: "+root["ultima_compra_id"])
					trace("ID Relacional: "+ultima_compra);
					atividades_visualizaItem(root["atividades_"+(ultima_compra)]);
				}
			};
		};
	};
	
	// Aplica a Rolagem:
	setScroller("atividades_scroller",root["atividades_listagem"],root["atividades_conteudo"],365,510,0,0,0,0,false,"VERTICAL");
	
};

// ====================================================
// LISTAGEM DE ATIVIDADES: Visualização de Atividade
// ====================================================
function atividades_clique_start(e:MouseEvent):void {
	posY = this.mouseY;
}
function atividades_clique_stop(e:MouseEvent):void {
	var resultado = this.mouseY-posY;
	if(resultado<5 && resultado>-5){
		atividades_visualizaItem(e.currentTarget);
	}
}
function atividades_visualizaItem(alvo){

	// # Variáveis Iniciais:
	var dados = alvo.infos;
	var itemStatusCor = "";
	var itemStatusTxt = "";
	var itemStatusMail = "";
	var metodoNome = "";
	var data_de_entrega;
	var codigo_de_rastreio;
	
	// # Posicionamento Inicial:
	var posy;
	
	// # Modal - Abertura:
	var tamanhoModal = "";
	var offsetImg = 0;
	if(dados.forma_de_pagamento=="F"){ 
		tamanhoModal="MG"; 
		offsetImg=30;
		posy = 220;
	}else{ 
		tamanhoModal="G"; 
		offsetImg=0;
		posy = 120;
	}
	modal_abrir("atividades_item_modal",["texto","",""],"","",true,null,tamanhoModal);
	
	// # Imagem de Fundo:
	root["atividades_item_modal"].conteudo_fundo.y+=offsetImg;
	img_load("atividades_item_modal_bg",blast.list[app].paths.upload_path+"/"+dados.imagem,root["atividades_item_modal"].conteudo_fundo,["width",310,"resize"],null,[31,33],[],0,bgAlpha);
	function bgAlpha(){
		Tweener.removeTweens(root["atividades_item_modal_bg"]);
		root["atividades_item_modal_bg"].alpha=0;
		Tweener.addTween(root["atividades_item_modal_bg"], {alpha:.2, time:4,transition: "easeOutExpo",delay: 0});
		root["atividades_item_modal_bgDegrade"] = new Degrade();
		root["atividades_item_modal_bgDegrade"].x = 31;
		root["atividades_item_modal_bgDegrade"].y = 33+root["atividades_item_modal_bg"].height;
		root["atividades_item_modal_bgDegrade"].width = root["atividades_item_modal_bg"].width;
		root["atividades_item_modal_bgDegrade"].height = 300;
		root["atividades_item_modal"].conteudo_fundo.addChild(root["atividades_item_modal_bgDegrade"])
		Tweener.addTween(root["atividades_item_modal_bgDegrade"], {_color:"0xfcfcfc", time: 0,transition: "easeOutExpo",delay: 0});
	};
	
	// # Título + Descrição:
	if(dados["status"]=="Aprovado"){ 
		itemStatusCor="3CD27F"; 
		itemStatusTxt="Pagamento Aprovado";
		itemStatusMail = "O comprovante foi enviado para o seu email.";
	};
	if(dados["status"]=="Aprovado" && dados.forma_de_pagamento=="F"){ 
		itemStatusCor="3CD27F"; 
		dados["status"]="Liberado Grátis"; 
		itemStatusTxt="Liberado Grátis";
		itemStatusMail = "O comprovante foi enviado para o seu email.";
	};
	if(dados["status"]=="Pendente"){ 
		itemStatusCor="30BDD5"; 
		itemStatusTxt="Aguardando Pagamento";
		itemStatusMail = "Estamos aguardando a comprovação do seu pagamento.";
	};
	if(dados["status"]=="Reprovado"){ 
		itemStatusCor="DC2F4C"; 
		itemStatusTxt="Pagamento Reprovado";
		itemStatusMail = "Seu pagamento foi reprovado. Tente novamente.";
	};
	if(dados["status"]=="Cancelado"){ 
		itemStatusCor="DC2F4C"; 
		itemStatusTxt="Pagamento Cancelado";
		itemStatusMail = "Esta venda foi cancelada.";
	};
	root["modal_texto"].y=posy;
	root["modal_texto"].titulo.htmlText = "<font color='#3CD27F'>"+itemStatusTxt+"</font><br><font color='#"+cortexto+"' size='14'>"+dados.id_sh_itens_tipos.nome+":</font><br><font color='#"+corbt1+"'>"+alvo.infos['label']+"</font>";
	if(alvo.infos['label'].length>19){
		posy += 95;
	}else{
		posy += 77;
	};
	
	// # Data + Status:
	criaLabel("atividades_item_modal_data","Solicitação:",convertData(dados.cadastro),root["atividades_item_modal"].conteudo,53,posy,1,"ececec",cortexto,"M");
	criaLabel("atividades_item_modal_status","Status:",dados["status"],root["atividades_item_modal"].conteudo,193,posy,1,itemStatusCor,"ffffff","M");
	
	// Método + Infos:
	if(dados.forma_de_pagamento!="F"){
		posy+=65;
		if(dados.forma_de_pagamento=="C"){ metodoNome="Cartão de Crédito"; }
		if(dados.forma_de_pagamento=="B"){ metodoNome="Boleto Bancário"; }
		criaLabel("atividades_item_modal_Metodo","Método:",metodoNome,root["atividades_item_modal"].conteudo,53,posy,1,"ececec",cortexto,"M");
		if(dados.forma_de_pagamento=="C"){
			criaLabel("atividades_item_modal_MetodoInfos","Cartão:","************"+dados.card_lastdigits,root["atividades_item_modal"].conteudo,193,posy,1,"ececec",cortexto,"M");
		};
		if(dados.forma_de_pagamento=="B"){
		};
		// Valor e Condição:
		posy+=65;
		criaLabel("atividades_item_modal_Valor","Valor:",convertValor(dados.valor),root["atividades_item_modal"].conteudo,53,posy,1,"ececec",cortexto,"M");
		criaLabel("atividades_item_modal_Forma","Condição de Pag:",dados.parcelas+"x de "+convertValor(dados.valor/dados.parcelas),root["atividades_item_modal"].conteudo,193,posy,1,"ececec",cortexto,"M");
	};
		
	// --------------------------------------------------------------------------
	// [PRODUTO FÍSICO]
	// --------------------------------------------------------------------------
	if(dados.id_sh_itens_tipos['id']==1){
		// Data de Entrega + Código de Rastreio:
		posy+=65;
		data_de_entrega = dados.data_de_entrega;
		if(data_de_entrega==null || codigo_de_rastreio==""){ data_de_entrega = "Aguardando"; }else{ data_de_entrega = convertData(data_de_entrega)  }
		criaLabel("atividades_item_modal_Entrega","Data de Entrega:",data_de_entrega,root["atividades_item_modal"].conteudo,53,posy,1,corbt1,"ffffff","M");
		codigo_de_rastreio = dados.codigo_de_rastreio;
		if(codigo_de_rastreio==""){ codigo_de_rastreio = "Aguardando"; };
		criaLabel("atividades_item_modal_Codigo","Cód de Rastreio:",codigo_de_rastreio,root["atividades_item_modal"].conteudo,193,posy,1,corbt1,"ffffff","M");
	};
	// --------------------------------------------------------------------------
	// [PRODUTO DIGITAL]
	// --------------------------------------------------------------------------
	if(dados.id_sh_itens_tipos['id']==2){
		// Data de Entrega + Código de Rastreio:
		posy+=75;
		criaBt("atividades_item_modal_Download","Iniciar Download",root["atividades_item_modal"].conteudo,70,posy,.75,"0x"+corbt1,"G");
		Tweener.addTween(root["atividades_item_modal_Download"].texto, {_color:"0xffffff", time:0,transition: "easeOutExpo",delay: 0});
		root["atividades_item_modal_Download"].addEventListener(MouseEvent.CLICK, function(){atividades_item_modal_Download_Click()});
		root["atividades_item_modal_Download"].buttonMode = true;
		function atividades_item_modal_Download_Click(){
			navigateToURL(new URLRequest(dados.item_link), "_blank");
		};
	};
	// --------------------------------------------------------------------------
	// [ÁUDIO - MP3]
	// --------------------------------------------------------------------------
	if(dados.id_sh_itens_tipos['id']==9){
		play_mp3(root["atividades_item_modal"].conteudo,dados.item_arquivo,134,80);
	};
	
	// --------------------------------------------------------------------------
	// [VIDEO - MP4]
	// --------------------------------------------------------------------------
	if(dados.id_sh_itens_tipos['id']==3){
		setTimeout(ativa_video,200);
		function ativa_video(){
			play_mp4(root["atividades_item_modal"].conteudo,dados.item_arquivo,134,80,"play");
		};
	};
	// Informação sobre Chegar no Email:
	posy+=70;
	root["modal_comprovante_txt"] = new Texto();
	root["modal_comprovante_txt"].y = posy;
	root["modal_comprovante_txt"].texto.width = 365;
	root["modal_comprovante_txt"].texto.htmlText = "<font color='#"+cortexto+"'>"+itemStatusMail+"</font>";
	root["atividades_item_modal"].conteudo.addChild(root["modal_comprovante_txt"]);
	
	
	// # Código de Barra:
	posy+=90;
	//qrcode_view(root["atividades_item_modal"].conteudo,convertDataOnlyNumbers(dados.cadastro)+"_"+dados.id_responsavel+"_"+dados['id']+"_"+dados.gateway_token,(365/2),posy);
	
};
