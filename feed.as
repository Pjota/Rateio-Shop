// ====================================================
// FEED - Init
// ====================================================
function feed(sessao){
	pages_history.push("feed");
	root[blast.list[app].pages.menu_superior.template+"_alpha"](false,"normal");
	// {NOW}
	connectServer(false,"screen",servidor+"api/list/"+blast.list.table['noticias']+"/id=0",[
	],gethorario);
	function gethorario(dados){
		// -------------------------------------
		// Feed: Busca as Últimas 15 notícias:
		connectServer(false,"screen",servidor+"api/list/"+blast.list.table['noticias']+"/p_id="+clienteID+",publicacao<="+dados.head['print']+",order_column=publicacao,order_direct=DESC",[
		],getClienteContatos);
		function getClienteContatos(dados){
			root["feed_noticias"] = dados;
			feed_load();
		};
	};
};
// ====================================================
// FEED - Constroi Página
// ====================================================
var m;
function feed_load(){
	
	// Conteúdo + Clipe com Rolagem:
	root["feed_conteudo"] = new Vazio();
	root["feed_conteudo"].y = 80;
	tela.addChild(root["feed_conteudo"]);
	root["feed_listagem"] = new Vazio();
	
	// Espaçamento:
	root["feed_spacer"] = new spacer();
	root["feed_listagem"].addChild(root["feed_spacer"]);
	
	// Título e Descrição:
	root["feed_titulo"] = new Titulo();
	root["feed_titulo"].y = 25;
	root["feed_titulo"].titulo.htmlText="<font color='#"+cortitulos+"'>Novidades para você!</font>";
	root["feed_titulo"].texto.htmlText="<font color='#"+cortexto+"'>Confira as últimas notícias sobre "+nome+"</font>";
	root["feed_titulo"].texto.autoSize = TextFieldAutoSize.CENTER ;
	root["feed_listagem"].addChild(root["feed_titulo"]);
	
	// Aplica Conteúdo
	var a;
	m = root["feed_noticias"].list;
	for(var i=0; i<m.length; i++){
		// ------------------------------
		// # Criação do Elemento de Feed:
		root["feed_"+(i+1)] = new Feed_Box();
		a = root["feed_"+(i+1)];
		a.infos = m[i];
		// -------
		// Titulo:
		a.titulo.texto.autoSize =  TextFieldAutoSize.CENTER;
		if(m[i].destaque==1){
			a.titulo.texto.htmlText="<font size='14' color='#"+corcancel+"'><b>DESTAQUE:</b></font><br><font color='#"+corbt1+"'>"+m[i].titulo+"</font>";
		}else{
			a.titulo.texto.htmlText="<font color='#"+corbt1+"'>"+m[i].titulo+"</font>";
		};
		a.titulo.infos = m[i];
		a.titulo.addEventListener(MouseEvent.MOUSE_DOWN,feed_clique_start);
		a.titulo.addEventListener(MouseEvent.MOUSE_UP,feed_clique_stop);
		a.titulo.buttonMode = true;
		// -----------------------------------------
		// Quando for uma Postagem somente de Texto:
		if(!m[i].imagem){
			a.imagem.visible=false;
			a.imagem.height = 0;
			a.postagem.y=10;
			a.postagem.x = 365/2;
			a.titulo.y = a.postagem.y+a.postagem.height+5;
			a.descricao.y = a.titulo.y+a.titulo.height+15;
		}else{
			a.imagem.y = a.titulo.y+a.titulo.height+10+(a.imagem.height/2);
			a.postagem.y = a.imagem.y-(a.imagem.height/2)+30;
			a.descricao.y = a.imagem.y+(a.imagem.height/2)+20;
			a.descricao.addEventListener(MouseEvent.MOUSE_DOWN,feed_clique_start);
			a.descricao.addEventListener(MouseEvent.MOUSE_UP,feed_clique_stop);
			img_load("feed_img"+(i+1),m[i].imagem,a.imagem.localimagem,["width",365,"resize","auto",300],null,[0,0,"center"],[],0,null);
			root["feed_img"+(i+1)].imagem = m[i].imagem;
			root["feed_img"+(i+1)].infos = m[i];
			root["feed_img"+(i+1)].addEventListener(MouseEvent.MOUSE_DOWN,feed_clique_start);
			root["feed_img"+(i+1)].addEventListener(MouseEvent.MOUSE_UP,feed_clique_stop);
			root["feed_img"+(i+1)].buttonMode = true;
		};
		Tweener.addTween(a.postagem.fundo, {_color:"0x"+corbt1, time: 0,transition: "linear",delay:0});
		a.postagem.datadiames.htmlText="<font color='#ffffff'>"+convertDataDiaMes(m[i].publicacao)+"</font>";
		// ----------
		// Descrição:
		a.descricao.infos = m[i];
		a.descricao.autoSize =  TextFieldAutoSize.CENTER;
		a.descricao.texto.htmlText="<font color='#"+cortexto+"'>"+m[i].subtitulo+"</font>";
		a.descricao.addEventListener(MouseEvent.MOUSE_DOWN,feed_clique_start);
		a.descricao.addEventListener(MouseEvent.MOUSE_UP,feed_clique_stop);
		a.descricao.buttonMode = true;
		a.vermais.y = a.descricao.y+a.descricao.height+15+(a.vermais.height/2);
		a.vermais.infos = m[i];
		a.vermais.acao = "vermais";
		a.vermais.addEventListener(MouseEvent.MOUSE_DOWN,feed_clique_start);
		a.vermais.addEventListener(MouseEvent.MOUSE_UP,feed_clique_stop);
		a.vermais.buttonMode = true;
		a.divisao.y = a.vermais.y+a.vermais.height+20;
		// -----
		// Flag:
		a.imagem.flag.visible=false;
		if(m[i].destaque==1){
			a.imagem.flag.visible=true;
			a.imagem.flag.alpha=0;
			Tweener.addTween(a.imagem.flag, {alpha:1, time: 1,transition: "easeOutExpo",delay:0});
			Tweener.addTween(a.imagem.flag.cor, {_color:"0x"+corcancel, time: 0,transition: "linear",delay:0});
			Tweener.addTween(a.imagem.flag.fundo.cor, {_color:"0x"+corcancel, time: 0,transition: "linear",delay:0});
		};
		// -----------------------------
		// # LIKE +  SHARE: Componentes:
		feed_like(i+1);
		feed_share(i+1);
		// --------------
		// Ajusta Layout:
		if(i==0){a.y=100;}else{a.y = root["feed_"+(i)].y+root["feed_"+(i)].height+25;}
		// ------------------
		// # Aplica Elemento:
		root["feed_listagem"].addChild(a);
	};
	// -----------------
	// Aplica a Rolagem:
	setScroller("feed_scroller",root["feed_listagem"],root["feed_conteudo"],365,510,0,0,0,0,false,"VERTICAL")
};

function feed_clique_start(e:MouseEvent):void {
	posY = this.mouseY;
};
function feed_clique_stop(e:MouseEvent):void {
	var resultado = this.mouseY-posY;
	if(resultado<5 && resultado>-5){
		feed_detalhes(e.currentTarget.infos); 
	};
};
function feed_img_fotoZoom(alvo) {
	lightbox_open("feed_lightbox",["0x"+cortexto,.95],alvo.imagem)
};
function feed_detalhes(alvo) {
	var posY;
	// Abre Modal para carregamento do Conteúdo:
	modal_abrir("feed_detalhe_modal",['texto',alvo.titulo,alvo.texto],"","",true,null,"G");
	// Ela possui Relacionamento com alguma Categoria, Subcategoria, Item ou LINK:
	var relType = "";
	var relValue = "";
	if(alvo['link']!=""){ 							relType="link"; 			relValue=alvo['link']; 						}
	if(alvo['id_produtos_categorias']!="0"){ 		relType="categoria"; 		relValue=alvo['id_produtos_categorias']; 			}
	if(alvo['id_produtos_subcategorias']!="0"){ 	relType="subcategoria"; 	relValue=alvo['id_produtos_subcategorias']; 		}
	if(alvo['id_produtos']!="0"){ 					relType="item"; 			relValue=alvo['id_produtos']; 				}
	// Carrega Conteúdo que Desliza:
	root["feed_detalhe_modal"].conteudo.y=0;
	root["feed_detalhe_modal"].conteudo_rolagem.y=34;
	var espaco = 0;
	if(relType!=""){espaco=80;}
	setScroller("modal_rolagem",root["feed_detalhe_modal"].conteudo,root["feed_detalhe_modal"].conteudo_rolagem,365,580-espaco,0,0,0,0,null,"VERTICAL");	

	// Existe Imagem nesta Notícias?
	if(alvo.imagem!=""){
		img_load("feed_detalhe_modal_img",alvo.imagem,root["feed_detalhe_modal"].conteudo,["width",365,"resize"],null,[0,0,"left"],[],0,modal_rolagem_ajustaPosY);
		root["feed_detalhe_modal_img"].img = alvo.imagem;
		root["feed_detalhe_modal_img"].addEventListener(MouseEvent.MOUSE_DOWN,feed_img_clique_start);
		root["feed_detalhe_modal_img"].addEventListener(MouseEvent.MOUSE_UP,feed_img_clique_stop);
		function feed_img_clique_start(e:MouseEvent):void {
			posY = mouseY;
		};
		function feed_img_clique_stop(e:MouseEvent):void {
			var resultado = mouseY-posY;
			var alvo = e.currentTarget;
			if(resultado<5 && resultado>-5){
				lightbox_open("feed_lightbox",["0x"+cortexto,.95],alvo.img)
			};
		};
	}
	
	function modal_rolagem_ajustaPosY(){ 
		root["modal_texto"].y = root["feed_detalhe_modal_img"].y + root["feed_detalhe_modal_img"].height+20;
		root["modal_texto"].alpha=0;
		Tweener.addTween(root["modal_texto"], {alpha:1,time:1,transition: "easeOutExpo",delay: 0});	
	};
	// Botão de Relacionamento:
	if(relType!=""){
		var texto_do_botao = "Acessar";
		if(alvo.texto_do_botao!=""){ texto_do_botao = alvo.texto_do_botao;}
		criaBt("bt_relacao",texto_do_botao,root["feed_detalhe_modal"],50,550,.85,"0x"+corbt1,"G");
		Tweener.addTween(root["bt_relacao"].texto, {_color:"0xffffff",time: 0,transition: "easeOutExpo",delay: 0});	
		root["bt_relacao"].addEventListener(MouseEvent.CLICK, bt_relacao_click);
		root["bt_relacao"].buttonMode = true;
		function bt_relacao_click(e:MouseEvent):void {
			if(relType=="link"){
				navigateToURL(new URLRequest(relValue),"_blank");
			}
			if(relType=="categoria" || relType=="subcategoria"){
				modal_fechar(modalHistory[modalHistory.length-1]);
				root["listagem_alvo"] = [relType,relValue];
				pages_new("listagem","listagem");
			}
			if(relType=="item"){
				try{modal_fechar(modalHistory[modalHistory.length-1]);}catch(error:Error){}
				abreModalItem(relValue)
			}
		}
	};
	function abreModalItem(id){
		var alvo = [];
		connectServer(false,"screen",servidor+"api/list/"+blast.list.table['produtos']+"/p_id="+clienteID+",id="+id+",level=2",[
		],getItem);
		function getItem(dados){
			alvo['infos'] = dados.list[0];
			listagem_item_modal(alvo)
		}
	}
};

// ====================================================
// FEED - LIKE: Construção do Componente de Like
// ====================================================
function feed_like(alvo){
	connectServer(false,"screen",servidor+"api/list/"+blast.list.table['curtidas']+"/p_id="+clienteID+",id_"+blast.list.table['noticias']+"="+m[alvo-1]['id']+",level=1",[
	],getLikes);
	function getLikes(dados){
		if(dados.list.length==0){
			criaIcon("feed_curtir_"+(alvo),root["feed_"+(alvo)],blast.list[app].paths.icon_master_path+"/006-thumbs-up.png",20,(root["feed_"+(alvo)].vermais.y-(root["feed_"+(alvo)].vermais.height/2)-5),45,"bullet",["0xAAAAAA","0xE8E8E8"],["alpha","easeOutExpo",1]);
			root["feed_curtir_"+(alvo)].n = root["feed_"+(alvo)].infos['id'];
			root["feed_curtir_"+(alvo)].num = alvo;
			root["feed_curtir_"+(alvo)].total = 0;
			root["feed_curtir_"+(alvo)]['likeStatus'] = "liberado";
		}else{
			root["feed_curtir_"+(alvo)] = new label_de_contagem();
			root["feed_curtir_"+(alvo)].n = root["feed_"+(alvo)].infos['id'];
			root["feed_curtir_"+(alvo)].num = alvo;
			root["feed_curtir_"+(alvo)].total = dados.list.length;
			root["feed_curtir_"+(alvo)]['likeStatus'] = "liberado";
			root["feed_curtir_"+(alvo)].x = 20;
			root["feed_curtir_"+(alvo)].y = (root["feed_"+(alvo)].vermais.y-(root["feed_"+(alvo)].vermais.height/2))-5;
			root["feed_curtir_"+(alvo)].texto.htmlText="<font color='#"+cortexto+"'>"+dados.list.length+" Like</font>";
			root["feed_"+(alvo)].addChild(root["feed_curtir_"+(alvo)]);
			Tweener.addTween(root["feed_curtir_"+(alvo)].fundo, {_color:"0xE8E8E8",time: 0,transition: "easeOutExpo",delay: 0});
			criaIcon("feed_curtir_icone"+(alvo),root["feed_curtir_"+(alvo)],blast.list[app].paths.icon_master_path+"/006-thumbs-up.png",8,8,20,"normal",["0xAAAAAA",null],["alpha","easeOutExpo",1]);
			// Existe Like Meu?
			connectServer(false,"screen",servidor+"api/list/"+blast.list.table['curtidas']+"/r_id="+root['User']['id']+",p_id="+clienteID+",id_"+blast.list.table['noticias']+"="+m[alvo-1]['id']+",level=1",[
			],getMyLike);
			function getMyLike(dados2){
				if(dados2.list.length>0){
					root["feed_"+(alvo)]['likeStatus'] = "curtido";
					root["feed_curtir_"+(alvo)].num = alvo;
					root["feed_curtir_"+(alvo)]['id'] = dados2.list[0]['id'];
					root["feed_curtir_"+(alvo)]['likeStatus'] = root["feed_"+(alvo)]['likeStatus'];
					root["feed_curtir_"+(alvo)].texto.htmlText="<font color='#ffffff'>"+dados.list.length+" Like</font>";
					Tweener.addTween(root["feed_curtir_"+(alvo)].fundo, {_color:"0x"+corbt1,time: 1,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["feed_curtir_icone"+(alvo)], {_color:"0xffffff",time: 1,transition: "easeOutExpo",delay: 0});
				};
			};
			
		};
		root["feed_curtir_"+(alvo)].addEventListener(MouseEvent.MOUSE_DOWN,feed_curtir_down);
		root["feed_curtir_"+(alvo)].addEventListener(MouseEvent.MOUSE_UP,feed_curtir_up);
	};
};
function feed_curtir_down(e:MouseEvent):void {
	posY = this.mouseY;
};
function feed_curtir_up(e:MouseEvent):void {
	var array = [];
	var resultado = this.mouseY-posY;
	var alvo = e.currentTarget.num
	if(resultado<5 && resultado>-5){
		// Marcar {Like}:
		if(e.currentTarget['likeStatus']=="liberado"){
			array.push(["p_id",clienteID]);
			array.push(["id_"+blast.list.table['noticias'],e.currentTarget.n]);
			connectServer(false,"screen",servidor+"api/add/"+blast.list.table['curtidas'],[
			["json",json(array),"texto"],
			["id",root["User"]['id'],"texto"]
			],like);
			function like(dados){
				if(dados.list.retorno=="ok"){
					if(root["feed_curtir_"+(alvo)].total==0){
						root["feed_"+(alvo)].removeChild(root["feed_curtir_"+(alvo)]);
						root["feed_curtir_"+(alvo)] = new label_de_contagem();
						root["feed_curtir_"+(alvo)].n = root["feed_"+(alvo)].infos['id'];
						root["feed_curtir_"+(alvo)].num = alvo;
						root["feed_curtir_"+(alvo)].total = 0;
						root["feed_curtir_"+(alvo)].x = 20;
						root["feed_curtir_"+(alvo)].y = (root["feed_"+(alvo)].vermais.y-(root["feed_"+(alvo)].vermais.height/2))-5;
						root["feed_"+(alvo)].addChild(root["feed_curtir_"+(alvo)]);
						criaIcon("feed_curtir_icone"+(alvo),root["feed_curtir_"+(alvo)],blast.list[app].paths.icon_master_path+"/006-thumbs-up.png",8,8,20,"normal",["0xAAAAAA",null],["alpha","easeOutExpo",1]);
						root["feed_curtir_"+(alvo)].addEventListener(MouseEvent.MOUSE_DOWN,feed_curtir_down);
						root["feed_curtir_"+(alvo)].addEventListener(MouseEvent.MOUSE_UP,feed_curtir_up);
					};
					root["feed_curtir_"+(alvo)].posy = root["feed_curtir_"+(alvo)].y;
					root["feed_curtir_"+(alvo)].y-=5;
					root["feed_curtir_"+(alvo)]['likeStatus'] = "curtido";
					root["feed_curtir_"+(alvo)]['id'] = dados.list['id'];
					root["feed_curtir_"+(alvo)].total++;
					root["feed_curtir_"+(alvo)].texto.htmlText="<font color='#ffffff'>"+(root["feed_curtir_"+(alvo)].total)+" Like</font>";
					Tweener.addTween(root["feed_curtir_"+(alvo)].fundo, {_color:"0x"+corbt1,time: 1,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["feed_curtir_icone"+(alvo)], {_color:"0xffffff",time: 1,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["feed_curtir_"+(alvo)], {y:root["feed_curtir_"+(alvo)].posy,time: .5,transition: "easeOutElastic",delay: 0});
				}else{
					newbalaoInfo(root["feed_"+(alvo)],"Erro!",(root["feed_curtir_"+(alvo)].x+(root["feed_curtir_"+(alvo)].width/2)),(root["feed_curtir_"+(alvo)].y+30),"BalaoPeq","0x"+corcancel);
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
					root["feed_curtir_"+(alvo)]['likeStatus'] = "liberado";
					root["feed_curtir_"+(alvo)]['id'] = "";
					root["feed_curtir_"+(alvo)].total--;
					root["feed_curtir_"+(alvo)].texto.htmlText="<font color='#"+cortexto+"'>"+(root["feed_curtir_"+(alvo)].total)+" Like</font>";
					Tweener.addTween(root["feed_curtir_"+(alvo)].fundo, {_color:"0xE8E8E8",time: 1,transition: "easeOutExpo",delay: 0});
					Tweener.addTween(root["feed_curtir_icone"+(alvo)], {_color:"0xAAAAAA",time: 1,transition: "easeOutExpo",delay: 0});
				}else{
					newbalaoInfo(root["feed_"+(alvo)],"Erro!",(root["feed_curtir_"+(alvo)].x+(root["feed_curtir_"+(alvo)].width/2)),(root["feed_curtir_"+(alvo)].y+30),"BalaoPeq","0x"+corcancel);
				}
			};
		};
	};
};

// ====================================================
// FEED - SHARE: Construção do Componente de SHARE
// ====================================================
function feed_share(alvo){
	criaIcon("feed_share_"+(alvo),root["feed_"+(alvo)],blast.list[app].paths.icon_master_path+"/share-symbol.png",300,(root["feed_"+(alvo)].vermais.y-(root["feed_"+(alvo)].vermais.height/2))-5,45,"bullet",["0xAAAAAA","0xE8E8E8"],["alpha","easeOutExpo",1]);
	root["feed_share_"+(alvo)].num = alvo;
	root["feed_share_"+(alvo)].addEventListener(MouseEvent.MOUSE_DOWN,feed_share_down);
	root["feed_share_"+(alvo)].addEventListener(MouseEvent.MOUSE_UP,feed_share_up);
};
function feed_share_down(e:MouseEvent):void {
	posY = this.mouseY;
};
function feed_share_up(e:MouseEvent):void {
	var array = [];
	var resultado = this.mouseY-posY;
	var alvo = e.currentTarget.num
	if(resultado<5 && resultado>-5){
		
		// Tratamento de Mensagem:
		var substituir:RegExp = /<br \/>/g;
		var texto = root["feed_noticias"].list[alvo-1].texto.replace(substituir,"\n");
		var id = root["feed_noticias"].list[alvo-1]['id'];
		
		// Abertura do Modal de COmpartilhamento:
		modal_abrir("feed_share_open",["texto","",""],"","",true,null,"PM");
		var extra = ""
		if(root["feed_noticias"].list[alvo-1].titulo.length>50){extra="..."}
		root["modal_texto"].titulo.y-=10;
		root["modal_texto"].titulo.htmlText = "<font size='14' color='#"+cortexto+"'>Compartilhe:</font><br><font size='20' color='#"+corbt1+"'>"+root["feed_noticias"].list[alvo-1].titulo.substr(0,50)+extra+"</font>";
		criaIcon("feed_share_whatsapp",root["modal_texto"],blast.list[app].paths.icon_master_path+"/whatsapp.png",115,80,60,"bullet",["0xffffff","0x46C655"],["alpha","easeOutExpo",1]);
		root["feed_share_whatsapp"].addEventListener(MouseEvent.MOUSE_DOWN,feed_share_whatsapp_click);
		function feed_share_whatsapp_click(e:MouseEvent):void {
			var texto = "whatsapp://send?text=*"+root["feed_noticias"].list[alvo-1].titulo+"*\n\nLink: http://"+root["User"]["id_sh_clientes"]['id_token']+".rateiodigital.com.br/loja/feed/"+id+"\n\n"+texto+"\n\nQuer receber mais conteúdos? Baixe o nosso app:\n\*Iphone:* http://rateiodigital.com.br\n*Android:* http://rateiodigital.com.br"
			trace(texto)
			navigateToURL(new URLRequest(texto),"_blank");
		};
		criaIcon("feed_share_facebook",root["modal_texto"],blast.list[app].paths.icon_master_path+"/facebook-logo.png",185,80,60,"bullet",["0xffffff","0x3B579D"],["alpha","easeOutExpo",1]);
		root["feed_share_facebook"].addEventListener(MouseEvent.MOUSE_DOWN,feed_share_facebook_click);
		function feed_share_facebook_click(e:MouseEvent):void {
			navigateToURL(new URLRequest("https://www.facebook.com/share.php?u=http://"+root["User"]["id_sh_clientes"]['id_token']+".rateiodigital.com.br/loja/feed/"+id),"_blank");
		};
	};
}