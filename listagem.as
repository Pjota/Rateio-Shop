// ====================================================
// LISTAGEM - Init
// ====================================================
function listagem(sessao){
	root["listagem_atual"] = "categorias";
	root["categoria_cache"] = [];
	pages_history.push("listagem");
	root[blast.list[app].pages.menu_superior.template+"_alpha"](true,"branca");
	listagem_init();
};
// ====================================================
// LISTAGEM - Constroi Página
// ====================================================
function listagem_init(){
	// -----------------------------
	// Conteúdo + Clipe com Rolagem:
	root["listagem_conteudo"] = new Vazio();
	root["listagem_conteudo"].y = 80;
	tela.addChild(root["listagem_conteudo"]);
	root["listagem_listagem"] = new Vazio();
	// -----------------------------
	// Botão: Voltar (Listagens)
	criaIcon("listagem_voltar",tela,blast.list[app].paths.icon_master_path+"/direction.png",20,85,43,"bullet",["0x"+cortitulos,"0xffffff"],["alpha","easeOutExpo",1]);
	root["listagem_voltar"].visible=false;
	root["listagem_voltar"].buttonMode = true;
	root["listagem_voltar"].addEventListener(MouseEvent.MOUSE_DOWN,listagem_retornar);
	// -----------------------------
	// Botão: Ordenação e Busca:
	root["config_ordem"] = "atividades";
	root["config_palavrachave"] = "";
	root["config_query"] = ",order_column=ordem,order_direct=ASC";
	/*
	criaIcon("listagem_config",tela,blast.list[app].paths.server+"/com/icones/magnifying-glass.png",305,85,43,"bullet",["0x"+cortitulos,"0xffffff"],["alpha","easeOutExpo",1]);
	root["listagem_config"].buttonMode = true;
	root["listagem_config"].addEventListener(MouseEvent.MOUSE_DOWN,listagem_configuracoes);
	function listagem_configuracoes(e:MouseEvent):void {
		// Variáveis Iniciais:
		var offsetValue;
		var ordenacoes;
		var ordenacoes_regras;
		var offset;
		var divisao;
		var i;
		// Carrega Modal:
		modal_abrir("listagem_config_modal",["texto","Pesquisar","Faça sua busca ordenando através das opções abaixo ou digitando uma palavra chave:"],"","",true,listagem_configuracoes_ordem_close,"BS-M");
		// Ordenação: Publicação {A>Z} / Preço {L/H} 
		root["listagem_config_ordem_titulo"] = new bullet_titulo();
		root["listagem_config_ordem_titulo"].x = 0;
		root["listagem_config_ordem_titulo"].y = 170;
		root["listagem_config_ordem_titulo"]['bullet'].texto.text="1";
		Tweener.addTween(root["listagem_config_ordem_titulo"]['bullet'].fundo, {_color:"0x"+corbt1, time: 0,transition: "linear",delay: 0});
		root["listagem_config_ordem_titulo"].texto.autoSize = TextFieldAutoSize.LEFT;
		root["listagem_config_ordem_titulo"].texto.htmlText = "<font color='#"+cortexto+"'>Ordem:</font>";
		offsetValue = ((365/2))-(root["listagem_config_ordem_titulo"].width/2)-8;
		root["listagem_config_ordem_titulo"].x = offsetValue;
		root["listagem_config_modal"].addChild(root["listagem_config_ordem_titulo"]);
		ordenacoes = ["atividades","alphabet","dinheiro"];
		ordenacoes_regras = [",order_column=ordem,order_direct=ASC",",order_column=titulo,order_direct=ASC",",order_column=valor,order_direct=ASC"]
		divisao = (260/ordenacoes.length);
		offsetValue = divisao/2;
		for(i=0; i<ordenacoes.length; i++){
			criaIcon("listagem_config_ordem"+(i+1),root["listagem_config_modal"],blast.list[app].paths.server+"/com/icones/"+ordenacoes[i]+".png",20+(divisao*(i+1))-offsetValue,210,70,"bullet",["0x"+corbtnormalmenuiicone,"0x"+corbtnormalmenuibg],["alpha","easeOutExpo",1]);
			root["listagem_config_ordem"+(i+1)].tipo = ordenacoes[i];
			root["listagem_config_ordem"+(i+1)].posy = root["listagem_config_ordem"+(i+1)].y;
			root["listagem_config_ordem"+(i+1)].addEventListener(MouseEvent.MOUSE_DOWN,listagem_configuracoes_ordem_change);
		};
		function listagem_configuracoes_ordem_change(e:MouseEvent):void {
			var alvo = e.currentTarget;
			listagem_configuracoes_ordem_change_action(alvo.tipo);
		};
		function listagem_configuracoes_ordem_change_action(tipo){
			root["config_ordem"] = tipo;
			for(i=0; i<ordenacoes.length; i++){
				if(tipo == ordenacoes[i]){
					root["config_query"] = ordenacoes_regras[i];
					root["listagem_config_ordem"+(i+1)].y += 10;
					Tweener.addTween(root["listagem_config_ordem"+(i+1)], {y:root["listagem_config_ordem"+(i+1)].posy, time: .5,transition: "easeOutElastic",delay: 0});
					Tweener.addTween(root["listagem_config_ordem"+(i+1)+"_fundo"], {_color:"0x"+corbtovermenuibg, time: 1.5,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["listagem_config_ordem"+(i+1)+"_iconeImg"], {_color:"0x"+corbtovermenuiicone, time: 1.5,transition: "easeOutExpo",delay: 0});
				}else{
					Tweener.addTween(root["listagem_config_ordem"+(i+1)+"_fundo"], {_color:"0x"+corbtnormalmenuibg, time: .5,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["listagem_config_ordem"+(i+1)+"_iconeImg"], {_color:"0x"+corbtnormalmenuiicone, time: .5,transition: "easeOutExpo",delay: 0});
				};
			};
		}
		listagem_configuracoes_ordem_change_action(root["config_ordem"]);
		
		// Palavra Chave: Box de Texto
		root["listagem_config_search_titulo"] = new bullet_titulo();
		root["listagem_config_search_titulo"].x = 0;
		root["listagem_config_search_titulo"].y = 300;
		root["listagem_config_search_titulo"]['bullet'].texto.text="2";
		Tweener.addTween(root["listagem_config_search_titulo"]['bullet'].fundo, {_color:"0x"+corbt1, time: 0,transition: "linear",delay: 0});
		root["listagem_config_search_titulo"].texto.autoSize = TextFieldAutoSize.LEFT;
		root["listagem_config_search_titulo"].texto.htmlText = "<font color='#"+cortexto+"'>Palavra Chave:</font>";
		offsetValue = ((365/2))-(root["listagem_config_search_titulo"].width/2)-8;
		root["listagem_config_search_titulo"].x = offsetValue;
		root["listagem_config_modal"].addChild(root["listagem_config_search_titulo"]);
		criaInput("listagem_config_search", "Digite Aqui", root["listagem_config_modal"], 70, 340, .95, "0xFFFFFF", "0x"+cortexto, 50, false,"M");
		if(root["config_palavrachave"]!=""){
			root["listagem_config_search"].texto.text = root["config_palavrachave"];
			root["listagem_config_search"].show();
		};
		
		// Fechar Modal:
		function listagem_configuracoes_ordem_close(dados){
			trace(">> "+root["listagem_config_search"].texto.text);
			if(root["listagem_config_search"].texto.text!="Digite Aqui"){
				root["config_palavrachave"] = root["listagem_config_search"].texto.text;
			}else{
				root["config_palavrachave"] = "";
			};
			setTimeout(reload,500);
			function reload(){
				if(root["config_palavrachave"]==""){
					listagem_load(root["llc"][0],root["llc"][1],root["llc"][2],root["llc"][3],root["llc"][4],root["llc"][5],root["llc"][6],root["llc"][7])
				}else{
					var link = servidor+"api/list/sh_itens/id_responsavel="+clienteID+",level=2,(LIKE)titulo="+root["config_palavrachave"]+root["config_query"];
					listagem_load(root["llc"][0],"Pesquisa:","Abaixo segue o resultado de sua pesquisa.",link,160,"item",1,cortexto)
				}
			};
		};
	};
	*/
	// -------------------------
	// Carrega Conteúdo Inicial:
	if(root["listagem_alvo"]!=null && root["listagem_alvo"] && root["listagem_alvo"].length==2){
		// # Variáveis Iniciais:
		var capa_alvo = capa;
		root["categoria_cache"] = [];
		// ---------------
		// # 1) Categorias
		if(root["listagem_alvo"][0]=="categoria"){
			connectServer(false,"screen",servidor+"api/list/"+blast.list.table['produtos_categorias']+"/p_id="+clienteID+",level=1,id="+root["listagem_alvo"][1],[
			],getCategoriaCapa);
			function getCategoriaCapa(dados){
				if(dados.list[0].imagem_de_fundo!=""){capa_alvo = dados.list[0].imagem_de_fundo; };
				root["categoria_cache"] = ["",dados.list[0].titulo,dados.list[0]['id'],blast.list[app].paths.upload_path+"/"+capa_alvo,dados.list[0].descricao];
				root["listagem_atual"] = "subcategorias";
				listagem_load(blast.list[app].paths.upload_path+"/"+capa_alvo,dados.list[0].titulo,dados.list[0].descricao,servidor+"api/list/"+blast.list.table['produtos_subcategorias']+"/id_"+blast.list.table['produtos_categorias']+"="+root["listagem_alvo"][1]+",p_id="+clienteID+",level=2",160,"subcategoria",1,"ffffff");
				trace("Lista de uma Categoria")
				root["listagem_alvo"]=null;
			};
		};
		// ------------------
		// # 2) SubCategorias
		if(root["listagem_alvo"][0]=="subcategoria"){
			connectServer(false,"screen",servidor+"api/list/"+blast.list.table['produtos_subcategorias']+"/p_id="+clienteID+",level=1,id="+root["listagem_alvo"][1],[
			],getCategoriaID);
			function getCategoriaID(dados){
				var subcategoria_infos = dados;
				connectServer(false,"screen",servidor+"api/list/"+blast.list.table['produtos_categorias']+"/p_id="+clienteID+",level=1,id="+dados.list[0]['id_'+blast.list.table['produtos_categorias']],[
				],getSubcategoriaCapa);
				function getSubcategoriaCapa(dados){
					if(dados.list[0].imagem_de_fundo!=""){capa_alvo = dados.list[0].imagem_de_fundo; };
					root["categoria_cache"] = ["",dados.list[0].titulo,dados.list[0]['id'],blast.list[app].paths.upload_path+"/"+capa_alvo,dados.list[0].descricao];
					root["listagem_atual"] = "itens";
					trace("Lista de uma SubCategoria")
					listagem_load(blast.list[app].paths.upload_path+"/"+capa_alvo,dados.list[0].titulo,dados.list[0].descricao,servidor+"api/list/"+blast.list.table['produtos']+"/id_"+blast.list.table['produtos_subcategorias']+"="+subcategoria_infos.list[0]['id']+",p_id="+clienteID+",level=2",60,"item",.2,"ffffff");
					root["listagem_alvo"]=null;
				};
			};
		};
	}else{
		trace("Lista as Categorias")
		listagem_load(blast.list[app].paths.upload_path+"/"+capa,"Categorias","",servidor+"api/list/"+blast.list.table['produtos_categorias']+"/p_id="+clienteID+",level=2",160,"categoria",1,"ffffff");
	};
};
function listagem_retornar(e:MouseEvent):void {
	var listagem_alvo;
	root[blast.list[app].pages.menu_superior.template+"_alpha"](true,"branca");
	
	if(root["listagem_atual"]=="itens"){
		listagem_alvo = "subcategorias";
		listagem_load(root["categoria_cache"][3],root["categoria_cache"][1],root["categoria_cache"][4],servidor+"api/list/"+blast.list.table['produtos_subcategorias']+"/id_"+blast.list.table['produtos_categorias']+"="+root["categoria_cache"][2]+",p_id="+clienteID+",level=2",160,"subcategoria",1,cortexto);
	};
	if(root["listagem_atual"]=="subcategorias"){
		listagem_alvo = "categorias";
		root["categoria_cache"] = [];
		listagem_load(blast.list[app].paths.upload_path+"/"+capa,"Categorias","",servidor+"api/list/"+blast.list.table['produtos_categorias']+"/p_id="+clienteID+",level=2",160,"categoria",1,"ffffff");
	};
	root["listagem_atual"] = listagem_alvo;
}
// ====================================================
// LISTAGEM - Carrega Itens
// ====================================================
function listagem_load(imgFundo,titulo,subtitulo,link,margem,tipo,imgAlpha,corsubtitulo){
	
	// Grava CACHE de último load:
	if(titulo!="Pesquisa:"){
		root["llc"] = [imgFundo,titulo,subtitulo,link,margem,tipo,imgAlpha,corsubtitulo];
	}
	
	// Remove Imagem + Conteúdo;
	destroir(bgPanel,false);
	destroir(root["listagem_listagem"],false);
	destroir(root["listagem_conteudo"],false);
	
	// Espaçamento:
	root["listagem_spacer"] = new spacer();
	root["listagem_listagem"].addChild(root["listagem_spacer"]);
	
	// Imagem de Fundo:
	img_load("login_logo",imgFundo,bgPanel,["width",ScreenSizeW2],null,[0,0,"left"],[],0,login_logo_ok)
	function login_logo_ok(){
		Tweener.addTween(bgPanel, {alpha:imgAlpha, time:1,transition: "easeOutExpo",delay: 0});
	};
	
	// (<) Botão de VOLTAR:
	if(tipo!="categoria"){
		root["listagem_voltar"].visible=true;
		root["listagem_voltar"].alpha=0;
		root["listagem_voltar"].y = 90;
		Tweener.addTween(root["listagem_voltar"], {alpha:1, time:1, transition: "easeOutExpo",delay: 0});
		Tweener.addTween(root["listagem_voltar"], {y:85, time:1, transition: "easeOutElastic",delay: 0});
	}else{
		Tweener.addTween(root["listagem_voltar"], {alpha:0, time:1, transition: "easeOutExpo",delay: 0});
		function listagem_voltar_some(){root["listagem_voltar"].visible=false;}
	};
	
	// Título e Descrição:
	root["listagem_titulo"] = new Titulo();
	root["listagem_titulo"].y = margem;
	root["listagem_titulo"].titulo.htmlText="<font color='#"+cortitulos+"'>"+titulo+"</font>";
	root["listagem_titulo"].texto.htmlText="<font color='#"+corsubtitulo+"'>"+subtitulo+"</font>";
	if(subtitulo==""){
		root["listagem_titulo"].titulo.y += 35;
	}
	
	root["listagem_titulo"].texto.autoSize =  TextFieldAutoSize.CENTER ;
	root["listagem_listagem"].addChild(root["listagem_titulo"]);
	
	// Carrega Conteúdo: Listagem de projetos:
	var linkExt;
	if(tipo!="item" && root["config_ordem"]=="dinheiro"){
		linkExt = link;
	}else{
		linkExt = link+root["config_query"];
	}
	connectServer(false,"screen",linkExt,[
	],getItens);
	function getItens(dados){
		root["lista_itens"] = dados;
		listItens();
	};
	function listItens(){
		// Variáveis iniciais:
		var a; 
		var qpl = 2; 
		var count = 0;
		var link = "";
		// Posicionamento:
		var posx = 20;
		var posy = root["listagem_titulo"].y+root["listagem_titulo"].height+20;
		//----------------------------------------------------
		// Listagem do que corresponde ao nível selecionado:
		//----------------------------------------------------
		root["itens_totais"] = root["lista_itens"].list.length;
		for(var i=0; i<root["itens_totais"]; i++){
			// # Cria Thumb:
			count++;
			root["item_"+(i+1)] = new Thumb_Design();
			a = root["item_"+(i+1)];
			a.tipo = tipo;
			a.nome = root["lista_itens"].list[i].nome;
			a.descricao = root["lista_itens"].list[i].descricao;
			a.n = root["lista_itens"].list[i]['id'];
			a.infos = root["lista_itens"].list[i];
			Tweener.addTween(a.linha, {_color:"0x"+root["lista_itens"].list[i].cor_detalhe, time: 0,transition: "easeOutExpo",delay: 0});
			Tweener.addTween(a.thumb.fundo, {_color:"0x"+root["lista_itens"].list[i].cor_fundo, time: 0,transition: "easeOutExpo",delay: 0});
			a.titulo.htmlText="<font color='#"+root["lista_itens"].list[i].cor_titulo+"'>"+root["lista_itens"].list[i].nome+"</font>";
			try {
			a.cat = root["lista_itens"].list[i]["id_"+blast.list.table['produtos_categorias']]['id'];
			}catch(error:Error){}
			if(tipo=="item"){
				if(root["lista_itens"].list[i].data_visivel=="1"){
					a.postagem.visible=true;
					a.postagem.datadiames.htmlText="<font color='#ffffff'>"+convertDataDiaMes(root["lista_itens"].list[i].data_dia)+"</font>";
					Tweener.addTween(a.postagem.fundo, {_color:"0x"+root["lista_itens"].list[i].cor_detalhe, time: 0,transition: "easeOutExpo",delay: 0});
				}else{
					a.postagem.visible=false;
				};
				try {
				img_load("item_"+(i+1)+"_imagem",blast.list[app].paths.upload_path+"/"+root["lista_itens"].list[i].imagem1,a.thumb.localimagem,["width",154],null,[0,0,"left"],[],0,null)
				}catch(error:Error){}
			}else{
				a.postagem.visible=false;
				if(root["lista_itens"].list[i].imagem!=""){
					try {
					img_load("item_"+(i+1)+"_imagem",blast.list[app].paths.upload_path+"/"+root["lista_itens"].list[i].imagem,a.thumb.localimagem,["width",154],null,[0,0,"left"],[],0,null)
					criaIcon("item_"+(i+1)+"_icone",a.thumb.localimagem,blast.list[app].paths.icon_master_path+"/folder.png",5,5,40,"bullet",["0xffffff","0x"+root["lista_itens"].list[i].cor_fundo],["alpha","easeOutExpo",1]);
					}catch(error:Error){}
				}else{
					try {
					criaIcon("item_"+(i+1)+"_icone",a.thumb.localimagem,blast.list[app].paths.icon_master_path+"blast/"+root["lista_itens"].list[i].id_bl_icones.imagem,35,35,85,"normal",["0x"+root["lista_itens"].list[i].cor_icone,null],["alpha","easeOutExpo",1]);
					}catch(error:Error){}
				};
			};
			// -----------------
			// # Posicionamento:
			if(i==0){ 
				a.y = posy; 
				a.x = posx;
			}else{
				if(count>qpl){
					count=1;
					a.y = root["item_"+(i)].y+root["item_"+(i)].height+15;
					a.x = posx;
				}else{
					a.y = root["item_"+(i)].y;
					a.x = root["item_"+(i)].x+root["item_"+(i)].width+15;
				}			
			};
			// -----------------
			// # Interação:
			a.addEventListener(MouseEvent.MOUSE_DOWN,item_clique_start);
			a.addEventListener(MouseEvent.MOUSE_UP,item_clique_stop);
			a.buttonMode = true;
			// -----------------
			// # Aplicação:
			root["listagem_listagem"].addChild(a);
		};
		//--------------------------------------------------
		// Listagem do que corresponde ao nível selecionado:
		//--------------------------------------------------
		if(tipo!="item"){
			if(tipo=="categoria"){ 
				link = servidor+"api/list/"+blast.list.table['produtos']+"/id_"+blast.list.table['produtos_categorias']+"=0,p_id="+clienteID+",level=2";
				if(root["config_ordem"]!="dinheiro"){ link = link+root["config_query"];}
			}
			if(tipo=="subcategoria"){ 
				link = servidor+"api/list/"+blast.list.table['produtos']+"/id_"+blast.list.table['produtos_categorias']+"="+root["categoria_cache"][2]+",id_"+blast.list.table['produtos_subcategorias']+"=0,p_id="+clienteID+",level=2"; 
				if(root["config_ordem"]!="dinheiro"){ link = link+root["config_query"];}
			}
			connectServer(false,"screen",link,[
			],getItensNaoAssociados);
			function getItensNaoAssociados(dados){
				root["itens_totais_naoassociados"] = dados.list.length;
				for(var i=0; i<root["itens_totais_naoassociados"]; i++){
					// # Cria Thumb:
					count++;
					root["item_"+(i+1+root["itens_totais"])] = new Thumb_Design();
					a = root["item_"+(i+1+root["itens_totais"])];
					a.tipo = "item";
					a.nome = dados.list[i].titulo;
					a.n = dados.list[i]['id'];
					a.infos = dados.list[i];
					Tweener.addTween(a.linha, {_color:"0x"+dados.list[i].cor_detalhe, time: 0,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(a.thumb.fundo, {_color:"0x"+dados.list[i].cor_fundo, time: 0,transition: "easeOutExpo",delay: 0});
					a.titulo.htmlText="<font color='#"+dados.list[i].cor_titulo+"'>"+dados.list[i].nome+"</font>";
					try {
					a.cat = dados.list[i]["id_"+blast.list.table['produtos_categorias']]['id'];
					}catch(error:Error){}
					// # A Tag de Data está ligada?
					if(dados.list[i].data_visivel=="1"){
						a.postagem.visible=true;
						a.postagem.datadiames.htmlText="<font color='#ffffff'>"+convertDataDiaMes(dados.list[i].data_dia)+"</font>";
						Tweener.addTween(a.postagem.fundo, {_color:"0x"+dados.list[i].cor_detalhe, time: 0,transition: "easeOutExpo",delay: 0});
					}else{
						a.postagem.visible=false;
					}
					try {
					
					img_load("item_"+(i+1+root["itens_totais"])+"_imagem",blast.list[app].paths.upload_path+"/"+dados.list[i].imagem1,a.thumb.localimagem,["width",154],null,[0,0,"left"],[],0,null)
					}catch(error:Error){}
					
					
					if(root["itens_totais"]+i==0){ 
						a.y = posy; 
						a.x = posx;
					}else{
						if(count>qpl){
							count=1;
							a.y = root["item_"+(i+root["itens_totais"])].y+root["item_"+(i+root["itens_totais"])].height+15;
							a.x = posx;
						}else{
							a.y = root["item_"+(i+root["itens_totais"])].y;
							a.x = root["item_"+(i+root["itens_totais"])].x+root["item_"+(i+root["itens_totais"])].width+15;
						}			
					};
			
					a.addEventListener(MouseEvent.MOUSE_DOWN,item_clique_start);
					a.addEventListener(MouseEvent.MOUSE_UP,item_clique_stop);
					a.buttonMode = true;
					root["listagem_listagem"].addChild(a);
				}
				// # Constroi o Scroller:
				setScroller("listagem_scroller",root["listagem_listagem"],root["listagem_conteudo"],365,510,0,0,0,0,false,"VERTICAL");
			};
		}else{
			// # Constroi o Scroller:
			setScroller("listagem_scroller",root["listagem_listagem"],root["listagem_conteudo"],365,510,0,0,0,0,false,"VERTICAL");
		};
	};
};
// ============================================================
// LISTAGEM - INTERAÇÕES C/ Categorias + Subcategorias + Itens
// ============================================================
function item_clique_start(e:MouseEvent):void {
	posY = this.mouseY;
}
function item_clique_stop(e:MouseEvent):void {
	var resultado = this.mouseY-posY;
	if(resultado<5 && resultado>-5){
		item_clique(e.currentTarget);
	}
}
function item_clique(alvo){
	trace("Alvo tipo: "+alvo.tipo)
	// ------------
	// # Variáveis iniciais:
	root["item_cache"] = alvo;
	var imagem_de_fundo = blast.list[app].paths.upload_path+"/"+capa;
	// ------------
	// # Categoria:
	if(alvo.tipo=="categoria"){
		root["listagem_atual"] = "subcategorias";
		if(alvo.infos.imagem_de_fundo!=""){
			imagem_de_fundo = blast.list[app].paths.upload_path+"/"+alvo.infos.imagem_de_fundo;
		}
		root["categoria_cache"] = ["",alvo.nome,alvo.n,imagem_de_fundo,alvo.descricao];
		listagem_load(imagem_de_fundo,alvo.nome,alvo.descricao,servidor+"api/list/"+blast.list.table['produtos_subcategorias']+"/id_"+blast.list.table['produtos_categorias']+"="+alvo.n+",p_id="+clienteID+",level=2",160,"subcategoria",1,cortexto);
	};
	// ---------------
	// # Subcategoria:
	if(alvo.tipo=="subcategoria"){
		root[blast.list[app].pages.menu_superior.template+"_alpha"](true,"normal");
		root["listagem_atual"] = "itens";
		if(alvo.infos["id"+blast.list.table['produtos_categorias']].imagem_de_fundo!=""){
			imagem_de_fundo = blast.list[app].paths.upload_path+"/"+alvo.infos["id_"+blast.list.table['produtos_categorias']].imagem_de_fundo;
		}
		listagem_load(imagem_de_fundo,alvo.nome,alvo.descricao,servidor+"api/list/"+blast.list.table['produtos']+"/id_"+blast.list.table['produtos_categorias']+"="+alvo.cat+",id_"+blast.list.table['produtos_subcategorias']+"="+alvo.n+",p_id="+clienteID+",level=2",60,"item",.2,cortexto);
	};
	// -------
	// # Item:
	if(alvo.tipo=="item"){
		listagem_item_modal(alvo);
	}
}
// ====================================================
// ITEM - LIKE: Construção do Componente de Like
// ====================================================
function item_like(alvo,posx,posy){
	
	connectServer(false,"screen",servidor+"api/list/"+blast.list.table['curtidas']+"/p_id="+clienteID+",id_"+blast.list.table['produtos']+"="+alvo.infos['id']+",level=1",[
	],getLikes);
	function getLikes(dados){
		if(dados.list.length==0){
			criaIcon("item_like_bt",root["modal_item"],blast.list[app].paths.icon_master_path+"/006-thumbs-up.png",posx,posy,50,"bullet",["0x"+alvo.infos.cor1,"0xffffff"],["alpha","easeOutExpo",1]);
			root["item_like_bt"].n = alvo.infos['id'];
			root["item_like_bt"].num = alvo;
			root["item_like_bt"].total = 0;
			root["item_like_bt"]['likeStatus'] = "liberado";
		}else{
			root["item_like_bt"] = new label_de_contagem_vertical();
			root["item_like_bt"].n = root["modal_item"].infos['id'];
			root["item_like_bt"].num = alvo;
			root["item_like_bt"].total = dados.list.length;
			root["item_like_bt"]['likeStatus'] = "liberado";
			root["item_like_bt"].x = posx-9;
			root["item_like_bt"].y = posy-4;
			root["item_like_bt"].texto.htmlText="<font color='#"+cortexto+"'>"+dados.list.length+" Like</font>";
			root["modal_item"].addChild(root["item_like_bt"]);
			Tweener.addTween(root["item_like_bt"].fundo, {_color:"0xE8E8E8",time: 0,transition: "easeOutExpo",delay: 0});
			criaIcon("item_like_icone",root["item_like_bt"],blast.list[app].paths.icon_master_path+"/006-thumbs-up.png",25,8,20,"normal",["0xAAAAAA",null],["alpha","easeOutExpo",1]);
			// Existe Like Meu?
			connectServer(false,"screen",servidor+"api/list/"+blast.list.table['curtidas']+"/r_id="+root['User']['id']+",p_id="+clienteID+",id_"+blast.list.table['produtos']+"="+root["modal_item"].infos['id']+",level=1",[
			],getMyLike);
			function getMyLike(dados2){
				if(dados2.list.length>0){
					root["item_like_bt"]['likeStatus'] = "curtido";
					root["item_like_bt"].num = alvo;
					root["item_like_bt"]['id'] = dados2.list[0]['id'];
					root["item_like_bt"]['likeStatus'] = root["item_like_bt"]['likeStatus'];
					root["item_like_bt"].texto.htmlText="<font color='#ffffff'>"+dados.list.length+" Like</font>";
					Tweener.addTween(root["item_like_bt"].fundo, {_color:"0x"+corbt1,time: 1,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["item_like_icone"], {_color:"0xffffff",time: 1,transition: "easeOutExpo",delay: 0});
				};
			};
			
		};
		root["item_like_bt"].addEventListener(MouseEvent.MOUSE_DOWN,item_curtir_down);
		root["item_like_bt"].addEventListener(MouseEvent.MOUSE_UP,item_curtir_up);
	};
};
function item_curtir_down(e:MouseEvent):void {
	posY = this.mouseY;
};
function item_curtir_up(e:MouseEvent):void {
	var array = [];
	var resultado = this.mouseY-posY;
	var alvo = e.currentTarget.num
	if(resultado<5 && resultado>-5){
		// Marcar {Like}:
		if(e.currentTarget['likeStatus']=="liberado"){
			array.push(["p_id",clienteID]);
			array.push(["id_"+blast.list.table['produtos'],e.currentTarget.n]);
			connectServer(false,"screen",servidor+"api/add/"+blast.list.table['curtidas'],[
			["json",json(array),"texto"],
			["id",root["User"]['id'],"texto"]
			],like);
			function like(dados){
				if(dados.list.retorno=="ok"){
					if(root["item_like_bt"].total==0){
						root["modal_item"].removeChild(root["item_like_bt"]);
						root["item_like_bt"] = new label_de_contagem_vertical();
						root["item_like_bt"].n = root["modal_item"].infos['id'];
						root["item_like_bt"].num = alvo;
						root["item_like_bt"].total = 0;
						root["item_like_bt"].x = alvo.x+25;
						root["item_like_bt"].y = alvo.y-25;
						root["modal_item"].addChild(root["item_like_bt"]);
						criaIcon("item_like_icone",root["item_like_bt"],blast.list[app].paths.icon_master_path+"/006-thumbs-up.png",25,8,20,"normal",["0xAAAAAA",null],["alpha","easeOutExpo",1]);
						root["item_like_bt"].addEventListener(MouseEvent.MOUSE_DOWN,item_curtir_down);
						root["item_like_bt"].addEventListener(MouseEvent.MOUSE_UP,item_curtir_up);
					};
					root["item_like_bt"].posy = root["item_like_bt"].y;
					root["item_like_bt"].y-=5;
					root["item_like_bt"]['likeStatus'] = "curtido";
					root["item_like_bt"]['id'] = dados.list['id'];
					root["item_like_bt"].total++;
					root["item_like_bt"].texto.htmlText="<font color='#ffffff'>"+(root["item_like_bt"].total)+" Like</font>";
					Tweener.addTween(root["item_like_bt"].fundo, {_color:"0x"+corbt1,time: 1,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["item_like_icone"], {_color:"0xffffff",time: 1,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["item_like_bt"], {y:root["item_like_bt"].posy,time: .5,transition: "easeOutElastic",delay: 0});
				}else{
					newbalaoInfo(root["modal_item"],"Erro!",(root["item_like_bt"].x+(root["item_like_bt"].width/2)),(root["item_like_bt"].y+30),"BalaoPeq","0x"+corcancel);
				}
			};
		};
		// Desmarcar {Like}:
		if(e.currentTarget['likeStatus']=="curtido"){
			array.push(["ativo","0"]);
			connectServer(false,"screen",servidor+"api/edit/"+blast.list.table['curtidas']+"/id="+e.currentTarget['id'],[
			["json",json(array),"texto"],
			["id",e.currentTarget['id'],"texto"]
			],dislike);
			function dislike(dados){
				if(dados.list.retorno=="ok"){
					root["item_like_bt"]['likeStatus'] = "liberado";
					root["item_like_bt"]['id'] = "";
					root["item_like_bt"].total--;
					root["item_like_bt"].texto.htmlText="<font color='#"+cortexto+"'>"+(root["item_like_bt"].total)+" Like</font>";
					Tweener.addTween(root["item_like_bt"].fundo, {_color:"0xE8E8E8",time: 1,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["item_like_icone"], {_color:"0xAAAAAA",time: 1,transition: "easeOutExpo",delay: 0});
				}else{
					newbalaoInfo(root["modal_item"],"Erro!",(root["item_like_bt"].x+(root["item_like_bt"].width/2)),(root["item_like_bt"].y+30),"BalaoPeq","0x"+corcancel);
				}
			};
		};
	};
};
