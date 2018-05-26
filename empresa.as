// ====================================================
// EMPRESA - Init
// ====================================================
function empresa(sessao){
	pages_history.push("empresa");
	root[blast.list[app].pages.menu_superior.template+"_alpha"](false,"normal");
	// -------------------------------------
	// Empresa: Busca Imagens
	connectServer(false,"screen",servidor+"api/list/"+blast.list.table['usuarios_infos']+"/id_"+blast.list.table['usuarios_infos_categorias']+"=1,p_id="+clienteID+",level=2,order_column=ordem,order_direct=ASC",[
	],getClienteImagens);
	function getClienteImagens(dados){
		root["empresa_dados_img"] = dados;
		// -------------------------------------
		// Empresa: Busca Textos
		connectServer(false,"screen",servidor+"api/list/"+blast.list.table['usuarios_infos']+"/id_"+blast.list.table['usuarios_infos_categorias']+"=2,p_id="+clienteID+",level=2,order_column=ordem,order_direct=ASC",[
		],getClienteInfos);
		function getClienteInfos(dados){
			root["empresa_dados_txt"] = dados;
			// -------------------------------------
			// Empresa: Busca Contatos
			connectServer(false,"screen",servidor+"api/list/"+blast.list.table['usuarios_infos']+"/id_"+blast.list.table['usuarios_infos_categorias']+"=3,p_id="+clienteID+",level=2,order_column=ordem,order_direct=ASC",[
			],getClienteContatos);
			function getClienteContatos(dados){
				root["empresa_dados_contatos"] = dados;
				empresa_load();
			};
		};
	};
};
// ====================================================
// EMPRESA - Constroi Página
// ====================================================
function empresa_load(){
	
	// ------------------------------------------------------------------
	// Conteúdo + Clipe com Rolagem:
	root["empresa_conteudo"] = new Vazio();
	root["empresa_conteudo"].y = 80;
	tela.addChild(root["empresa_conteudo"]);
	root["empresa_listagem"] = new Vazio();
	// Espaçamento:
	root["empresa_spacer"] = new spacer();
	root["empresa_listagem"].addChild(root["empresa_spacer"]);
	
	// ------------------------------------------------------------------
	// Imagem da Empresa (Carrosel de imagens)
	root["empresa_imagens"] = new Carrosel_Imagem();
	root["empresa_imagens"].y = 0;
	root["empresa_listagem"].addChild(root["empresa_imagens"]);
	img_load("empresa_imagem",root["empresa_dados_img"].list[0].imagem,root["empresa_imagens"].localimagem,["width",365,"resize"],null,[0,0,"left"],[],0,null);
	
	// -------------------------------------------------------------------
	// Textos sobre a Empresa:
	var posy = root["empresa_imagens"].y+root["empresa_imagens"].height+25;
	var espacamento = 20;
	var a = root["empresa_dados_txt"].list;
	for(var i=0; i<a.length; i++){
		root["empresa_textos_"+(i+1)] = new Titulo();
		if(i==0){
			root["empresa_textos_"+(i+1)].y = posy;
		}else{
			root["empresa_textos_"+(i+1)].y = root["empresa_textos_"+(i)].y+root["empresa_textos_"+(i)].height+espacamento;
		};
		root["empresa_textos_"+(i+1)].titulo.autoSize =  TextFieldAutoSize.CENTER;
		root["empresa_textos_"+(i+1)].titulo.htmlText="<font color='#"+cortitulos+"'>"+a[i].nome+"</font>";
		root["empresa_textos_"+(i+1)].texto.y = root["empresa_textos_"+(i+1)].titulo.y+root["empresa_textos_"+(i+1)].titulo.height+10;
		root["empresa_textos_"+(i+1)].texto.htmlText="<font color='#"+cortexto+"'>"+a[i]['info']+"</font>";
		root["empresa_textos_"+(i+1)].texto.autoSize =  TextFieldAutoSize.CENTER;
		root["empresa_listagem"].addChild(root["empresa_textos_"+(i+1)]);
		posy+= root["empresa_textos_"+(i+1)].height+espacamento;
	};
	
	// ------------------------------------------------------------------
	// Informações Link:
	a = root["empresa_dados_contatos"].list;
	root["empresa_informacoes_divisor"] = new Linha_Divisoria();
	root["empresa_informacoes_divisor"].y = posy;
	root["empresa_informacoes_divisor"].x = (365/2);
	root["empresa_listagem"].addChild(root["empresa_informacoes_divisor"]);
	root["empresa_informacoes"] = new Titulo();
	root["empresa_informacoes"].y = posy+20;
	root["empresa_informacoes"].titulo.htmlText="<font color='#"+cortitulos+"'>Informações:</font>";
	root["empresa_informacoes"].texto.htmlText="<font color='#"+cortexto+"'></font>";
	root["empresa_informacoes"].texto.autoSize =  TextFieldAutoSize.CENTER;
	root["empresa_listagem"].addChild(root["empresa_informacoes"]);
	posy += root["empresa_informacoes"].height+40;
	for(i=0; i<a.length; i++){
		criaIcon("empresa_infos_icone"+(i+1),root["empresa_listagem"],blast.list[app].paths.icon_master_path+"/blast/"+a[i].id_bl_icones.imagem,40,posy+(40*i),30,"bullet",["0xAAAAAA","0xE8E8E8"],["alpha","easeOutExpo",1]);
		root["empresa_infos_txt"+(i+1)] = new label_ttitulo_simples();
		root["empresa_infos_txt"+(i+1)].y = root["empresa_infos_icone"+(i+1)].y+5;
		root["empresa_infos_txt"+(i+1)].x = root["empresa_infos_icone"+(i+1)].x+40;
		root["empresa_infos_txt"+(i+1)].texto.autoSize =  TextFieldAutoSize.LEFT;
		root["empresa_infos_txt"+(i+1)].texto.width = 250;
		root["empresa_infos_txt"+(i+1)].texto.htmlText = "<font color='#"+cortexto+"' size='16'>"+a[i]['info']+"</font>";
		root["empresa_infos_txt"+(i+1)].linktoclick = a[i]['link'];
		root["empresa_infos_txt"+(i+1)].buttonMode = true;
		root["empresa_infos_txt"+(i+1)].addEventListener(MouseEvent.CLICK, empresa_clickInfos);
		root["empresa_listagem"].addChild(root["empresa_infos_txt"+(i+1)]);
	};
	function empresa_clickInfos(e:MouseEvent):void {
		navigateToURL(new URLRequest(e.currentTarget.linktoclick));
	};
	// ------------------------------------------------------------------
	// Aplica a Rolagem:
	setScroller("empresa_scroller",root["empresa_listagem"],root["empresa_conteudo"],365,510,0,0,0,0,false,"VERTICAL")
	
};