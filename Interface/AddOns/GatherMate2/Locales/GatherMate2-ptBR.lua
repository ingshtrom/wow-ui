-- GatherMate Locale
-- Please use the Localization App on WoWAce to Update this
-- http://www.wowace.com/projects/gathermate2/localization

local L = LibStub("AceLocale-3.0"):NewLocale("GatherMate2", "ptBR")
if not L then return end

L["Add this location to Cartographer_Waypoints"] = "Adicionar este nodo ao Cartographer_Waypoints"
L["Add this location to TomTom waypoints"] = "Adicionar este nodo aos pontos de passagem do TomTom"
L["Always show"] = "Mostrar Sempre"
L["Archaeology"] = "Arqueologia"
L["Archaeology filter"] = "Filtro de Arqueologia"
L["Are you sure you want to delete all nodes from this database?"] = "Tem a certeza que quer apagar todos nodos deste banco de dados?"
L["Are you sure you want to delete all of the selected node from the selected zone?"] = "Tem a certeza que quer apagar todos os nodos do tipo selecionado da zona selecionada?"
L["Auto Import"] = "Importação Automática"
L["Auto import complete for addon "] = "Importação Automática concluida para o addon "
L["Automatically import when ever you update your data module, your current import choice will be used."] = "Importar automaticamente quando actualizar o módulo de dados, serão usadas as opções de importação actuais."
L["Cataclysm"] = "Cataclismo"
L["Cleanup Complete."] = "Limpeza Terminada."
L["Cleanup Database"] = "Limpar o Banco de Dados"
L["Cleanup_Desc"] = "Com o passar do tempo, o banco de dados poderá ficar lotada. Limpar o banco de dados implica procurar por nodos da mesma profissão que estão próximos uns dos outros e determinar se poderão agrupar em um único nodo."
L["Cleanup Failed."] = "Limpeza falhou"
L["Cleanup in progress."] = "Limpeza em progresso"
L["Cleanup radius"] = "Raio de Limpeza"
L["CLEANUP_RADIUS_DESC"] = "O raio em jardas que serão removidos os duplicados. O valor padrão para a Extração de Gás é |cffffd20050|r jardas e |cffffd20015|r jardas para o restante. Esta definições serão usadas também quando se adiciona locais."
L["Cleanup Started."] = "Limpeza iniciada"
L["Cleanup your database by removing duplicates. This takes a few moments, be patient."] = "Limpe o seu banco de dados removendo duplicados. Isto irá demorar alguns segundos, seja paciente."
L["Clear database selections"] = "Limpar seleção de banco de dados"
L["Clear node selections"] = "Limpar seleção de nodos"
L["Clear zone selections"] = "Limpar seleção de zona"
L["Click to toggle minimap icons."] = "Clique para alternar a exibição dos ícones no minimapa" -- Needs review
L["Color of the tracking circle."] = "Cor do circulo de rasteio"
L["Control various aspects of node icons on both the World Map and Minimap."] = "Controlo dos ícone dos nodos no Mapa Mundo e no Mini-mapa"
L["Conversion_Desc"] = "Converte os dados existentes do GatherMate para o formato do GatherMate2"
L["Convert Databses"] = "Converter Banco de dados"
L["Database locking"] = "Bloqueio do Banco de dados"
L["Database Locking"] = "Bloqueio do Banco de dados"
L["DATABASE_LOCKING_DESC"] = "A opção de bloqueio do banco de dados permite congelar o estado do banco de dados. Quando bloqueado o banco de dados não poderá adicionar, eliminar ou modificar nodos do banco de dados. Não poderá ainda efetuar a limpeza ao banco de dados nem importar novos nodos."
L["Database Maintenance"] = "Manutenção do Banco de dados"
L["Databases to Import"] = "Bancos de dados a importar"
L["Databases you wish to import"] = "Bancos de dados que deseja importar"
L["Delete"] = "Apagar"
L["Delete Entire Database"] = "Apagar Banco de Dados"
L["DELETE_ENTIRE_DESC"] = "Isto irá ignorar o Bloqueio da Base de dados e irá remover todos os locais de todas as zonas da base de dados selecionada."
L["Delete selected node from selected zone"] = "Apagar o nodo selecionado da zona selecionada"
L["DELETE_SPECIFIC_DESC"] = "Remover todos os nodos do tipo selecionado da zona selecionada. Você deverá desativar o Bloqueio do Banco de dados par isto funcionar."
L["Delete Specific Nodes"] = "Apagar Nodo Específico"
L["Disabled"] = "Desabilitado" -- Needs review
L["Display Settings"] = "Opções de Exibição"
L["Enabled"] = "Habilitado" -- Needs review
L["Engineering"] = "Engenharia"
L["Expansion"] = "Expansão"
L["Expansion Data Only"] = "Apenas Dados da Expansão"
L["Failed to load GatherMateData due to "] = "Falhou o carregamento do GatherMateData devido a"
L["FAQ"] = "Dúvidas"
L["FAQ_TEXT"] = [=[|cffffd200
Eu apenas instalei o GatherMate, mas não vejo nenhum nodo no mapa. O que eu estou fazendo de errado?
|r
GatherMate não vem com todos os dados por si só. Quando você apanhar ervas, minérios, recolhe gás ou pesca, então o GatherMate adiciona e atualiza o seu mapa de acordo. Além disso, verifique as configurações de exibição.

|cffffd200
Eu estou vendo nodos no Mapa-Mundí mas não no Mini-Mapa!  O que eu estou fazendo de errado?
|r
|cffffff78 Botão da Mochila do Mini-Mapa|r (e possivelmente outros addons similares) gostam de 'comer' todos os botões que colocamos no Mini-Mapa. Desative-os.

|cffffd200
Como ou onde eu posso obter os dados existentes?
|r
Você pode importar os dados existentes no GatherMate das seguintes maneiras:

1. |cffffff78GatherMate_Data|r - Este addon LoD contém uma cópia dos dados do Wowhead de todos os nodos e é atualizado semanalmente. Há opções de atualização automática

2. |cffffff78GatherMate_CartImport|r - Este addon permite importar seus bancos de dados existentes no |cffffff78Cartographer_<Profissão>|r módulos para GatherMate. Para que isso funcione,ambos os módulos do |cffffff78Cartographer_<Profissão>|r e GatherMate_CartImport devem estar carregados e ativos.
Nota-se que a importação de dados no GatherMate não é um processo automático. Você deve ir para a seção Importar Dados e clique no botão "Importar".

Isso difere de |cffffff78Cartographer_Data|r em que o utilizador tem a escolha de como e quando você quer que seus dados sejam modificados, |cffffff78Cartographer_Data|r quando carregado simplesmente substitui os seus bancos de dados existentes, sem aviso prévio e apaga todos os nodos nós que você tenha encontrado.

|cffffd200
Você poderia adicionar suporte para mostrar a localização de coisas como caixas de correio e Mestres de Vôo?
|r
A resposta é não. No entanto, outro autor poderia criar um addon addon ou módulo para este fim, o núcleo do addon GatherMate não vai fazer isso.

|cffffd200
Eu achei um bug! Onde eu reporto isso?
|r
Você pode reportar bugs ou dar sugestões em |cffffff78http://www.wowace.com/forums/index.php?topic=10990.0|r

Alternativamente, você também pode nos encontrar em |cffffff78irc://irc.freenode.org/wowace|r

Quando reportar um bug, certifique-se de incluir os |cffffff78passos de como reproduzir o bug|r, fornecer qualquer |cffffff78mensagem de erro|r com rastreamentos, se possível, dar o |cffffff78número da revisão|r do GatherMate que o problema ocorreu e diga se você está usando um |cffffff78Cliente em inglês ou outro|r.

|cffffd200
Quem escreveu esse addon legal?
|r
Kagaro, Xinhuan, Nevcairiel and Ammo
Opções]=]
L["Filter_Desc"] = "Selecione os tipos de nodos que ver no Mapa Mundo e no Mini-mapa. Os tipos de nodos não selecionados também serão gravados no banco de dados. "
L["Filters"] = "Filtros"
L["Fishes"] = "Peixes"
L["Fish filter"] = "Filtro de Pesca"
L["Fishing"] = "Pesca"
L["Frequently Asked Questions"] = "Perguntas Frequentes"
L["Gas Clouds"] = "Nuvens de Gás"
L["Gas filter"] = "Filtro de Nuvens de Gás"
L["GatherMate2Data has been imported."] = "Os dados do GatherMate2Data foram importados"
L["GatherMate Conversion"] = "Conversão GatherMate"
L["GatherMate data has been imported."] = "Dados do GatherMate foram importados."
L["GatherMateData has been imported."] = "Os dados do GatherMateData foram importados."
L["GatherMate Pin Options"] = "Opções de Pinos do GatherMate"
L["General"] = "Geral"
L["Herbalism"] = "Herborismo"
L["Herb Bushes"] = "Ervas"
L["Herb filter"] = "Filtro de herborismo"
L["Icon Alpha"] = "Opacidade dos ícones"
L["Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."] = "Valor de opacidade dos ícones, isto permite mudar a transparência dos ícones. Isto aplica-se somente ao Mapa Mundo."
L["Icons"] = "Ícones"
L["Icon Scale"] = "Dimensão dos ícones"
L["Icon scaling, this lets you enlarge or shrink your icons on both the World Map and Minimap."] = "Dimencionamento dos ícones, isto permite ampliar ou encolher os ícones no Mapa Mundo e no Mini-mapa."
L["Icon scaling, this lets you enlarge or shrink your icons on the Minimap."] = "Escalamento de Ícones, permite que você aumente ou diminua os ícones no Mini-mapa"
L["Icon scaling, this lets you enlarge or shrink your icons on the World Map."] = "Escalamento de Ícones, permite que você aumente ou diminua os ícones no Mapa-múndi"
L["Import Data"] = "Importar Dados"
L["Import GatherMate2Data"] = "Importar GatherMate2Data"
L["Import GatherMateData"] = "Importar GatherMateData"
L["Importing_Desc"] = "A importação permite ao GatherMate obter nodos de outras fontes, para além das de que você encontra ao jogar. Após uma importação, poderá ser necessário proceder a uma limpeza do banco de dados."
L["Import Options"] = "Opções de Importação"
L["Import Style"] = "Importar Estilo"
L["Keybind to toggle Minimap Icons"] = "Atalho para Habilitar/Desabilitar Ícones do Mini-mapa"
L["Keybind to toggle Worldmap Icons"] = [=[Tecla de atalho para exibição dos ícones no Mapa-Mundi
]=]
L["Legion"] = "Legião"
L["Load GatherMate2Data and import the data to your database."] = "Carregar GatherMate2Data e importar para o banco de dados."
L["Load GatherMateData and import the data to your database."] = "Carregar o GatherMateData e importar os dados para o banco de dados."
L["Merge"] = "Juntar"
L["Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"] = "Juntar irá adicionar os dados do GatherMate2Data ao banco de dados. Sobrescrever irá substituir o seu banco de dados pelos dados do GatherMate2Data."
L["Merge will add GatherMateData to your database. Overwrite will replace your database with the data in GatherMateData"] = "Juntar irá adicionar os dados do GatherMateData ao banco de dados. Sobrescrever irá substituir o seu banco de dados pelos dados do GatherMateData."
L["Mine filter"] = "Filtro de mineração."
L["Mineral Veins"] = "Veios de Minério"
L["Minimap Icons"] = "Ícones do minimapa" -- Needs review
L["Minimap Icon Scale"] = "Escala de Ícones do Mini-mapa"
L["Minimap Icon Tooltips"] = "Ícones de dicas de ferramentas do Mini-Mapa"
L["Mining"] = "Mineração."
L["Mists of Pandaria"] = "Mists of Pandaria"
L["Never show"] = "Nunca Mostrar"
L["Only import selected expansion data from WoWDB"] = "Importar apenas dados da expansão selecionada do WoWDB"
L["Only import selected expansion data from WoWhead"] = "Importar apenas dados da expanção selecionada do WoWhead"
L["Only while tracking"] = "Apenas quando rastreando"
L["Only with digsite"] = "Apenas com escavações"
L["Only with profession"] = "Apenas com a profissão"
L["Overwrite"] = "Sobrescrever"
L["Processing "] = "Processando"
L["Right-click for options."] = "Clique com o botão direito para opções" -- Needs review
L["Select All"] = "Selecionar Tudo"
L["Select all databases"] = "Escolher todos os Bancos de Dados"
L["Select all nodes"] = "Selecionar Todos os Nodos"
L["Select all zones"] = "Selecionar todas as zonas"
L["Select Database"] = "Selecionar Banco de Dados"
L["Select Databases"] = "Escolher Banco de Dados"
L["Selected databases are shown on both the World Map and Minimap."] = "Selecionar os bancos de dados que são mostrados no Mapa Mundo e no Mini-mapa."
L["Select Node"] = "Selecionar Nodo"
L["Select None"] = "Selecionar Nenhum"
L["Select the archaeology nodes you wish to display."] = "Seleccione os nodos de arqueologia que deseja mostrar."
L["Select the fish nodes you wish to display."] = "Selecione os nodos de pesca que deseja mostrar."
L["Select the gas clouds you wish to display."] = "Selecione as nuvens de gás que deseja mostrar."
L["Select the herb nodes you wish to display."] = "Selecione as ervas que deseja exibir."
L["Select the mining nodes you wish to display."] = "Selecione os nodos de mineiração que deseja mostrar."
L["Select the treasure you wish to display."] = "Selecione os tesouros que deseja exibir."
L["Select Zone"] = "Selecionar Zona"
L["Select Zones"] = "Selecione Zonas."
L["Shift-click to toggle world map icons."] = "Shift + clique para alternar entre os ícones no mapa-mundi" -- Needs review
L["Show Archaeology Nodes"] = "Mostrar Nodos de Arqueologia"
L["Show Databases"] = "Mostrar Banco de Dados"
L["Show Fishing Nodes"] = "Mostrar Nodos de Pesca"
L["Show Gas Clouds"] = "Mostrar Nuvens de Gás"
L["Show Herbalism Nodes"] = "Mostrar Nodos de Herborismo"
L["Show Minimap Icons"] = "Mostrar Ícones no Mini-mapa"
L["Show Mining Nodes"] = "Mostrar Nodos de Mineração"
L["Show Nodes on Minimap Border"] = "Mostrar Nodos na Beira do Mini-mapa"
L["Shows more Nodes that are currently out of range on the minimap's border."] = "Mostrar mais nodos que estão atualmente fora do alcance da borda do Mini-Mapa."
L["Show Timber Nodes"] = "Mostrar Nodes de Lenho"
L["Show Tracking Circle"] = "Mostrar Círculo de Rastreamento"
L["Show Treasure Nodes"] = "Mostrar Nodos de Tesouro"
L["Show World Map Icons"] = "Mostrar Ícones no Mapa Mundo"
L["The Burning Crusades"] = "A Crusada Incendiaria"
L["The distance in yards to a node before it turns into a tracking circle"] = "Distância em jardas para um nodo se tornar num círculo de rastreamento"
L["The Frozen Sea"] = "Mar Congelado"
L["The North Sea"] = "Mar do Norte"
L["Toggle showing archaeology nodes."] = "Habilitar/Desabilitar exibição de nodos de arqueologia"
L["Toggle showing fishing nodes."] = "Habilitar/Desabilitar exibição de nodos de pesca"
L["Toggle showing gas clouds."] = "Habilitar/Desabilitar exibição de nuvens de gás."
L["Toggle showing herbalism nodes."] = "Habilitar/Desabilitar exibição de nodos de herborismo."
L["Toggle showing Minimap icons."] = "Habilitar/Desabilitar exibição de ícones no Mini-mapa"
L["Toggle showing Minimap icon tooltips."] = "Alternar a exibição de ícones de dicas de ferramentas do Mini-Mapa"
L["Toggle showing mining nodes."] = "Habilitar/Desabilitar exibição de nodos de mineração"
L["Toggle showing the tracking circle."] = "Habilitar/Desabilitar exibição de círculo de rastreamento"
-- L["Toggle showing timber nodes."] = "Toggle showing timber nodes."
L["Toggle showing treasure nodes."] = "Habilitar/Desabilitar exibição de nodos de tesouro"
L["Toggle showing World Map icons."] = "Habilitar/Desabilitar exibição de ícones no Mapa Mundo"
L["Tracking Circle Color"] = "Cor do Círculo de Rastreamento"
L["Tracking Distance"] = "Distância de Rastreamento"
L["Treasure"] = "Tesouro"
L["Treasure filter"] = "Filtro de Tesouros"
L["Warlords of Draenor"] = "Warlords of Draenor" -- Needs review
L["World Map Icons"] = "Ícones do mapa-mundi" -- Needs review
L["World Map Icon Scale"] = "Escala de Ícones do Mapa-múndi"
L["Wrath of the Lich King"] = "Furia do Lich Rei"


local NL = LibStub("AceLocale-3.0"):NewLocale("GatherMate2Nodes", "ptBR")
if not NL then return end

NL["Abundant Bloodsail Wreckage"] = "Destroços Abundante dos Vela Sangrenta"
NL["Abundant Firefin Snapper School"] = "Cardume Abundante de Pargo Pinafogo"
NL["Abundant Oily Blackmouth School"] = "Cardume Abundante de Bocanera Oleoso"
NL["Abyssal Gulper School"] = "Cardume de Boca-grandes Abissais" -- Needs review
NL["Adamantite Bound Chest"] = "Cofre Reforçado com Adamantita"
NL["Adamantite Deposit"] = "Depósito de Adamantita"
NL["Adder's Tongue"] = "Língua de Áspide"
NL["Aethril"] = "Aethril"
NL["Albino Cavefish School"] = "Cardume de Bagres-cegos Albinos"
NL["Algaefin Rockfish School"] = "Cardume de Peixe-pedra Barbatalga"
NL["Ancient Lichen"] = "Líquen-antigo"
NL["Ancient Mana Chunk"] = "Lasca de Mana Ancestral"
NL["Ancient Mana Crystal"] = "Cristal de Mana Ancestral"
NL["Ancient Mana Shard"] = "Estilhaço de Mana Ancestral"
NL["Arakkoa Archaeology Find"] = "Achado de Arqueologia Arakkoa" -- Needs review
NL["Arcane Vortex"] = "Vórtice Arcano"
NL["Arctic Cloud"] = "Nuvem Ártica"
NL["Arthas' Tears"] = "Lágrimas de Arthas"
NL["Azshara's Veil"] = "Véu-de-azshara"
NL["Battered Chest"] = "Baú Desgastado"
NL["Battered Footlocker"] = "Maleta Surrada"
NL["Black Barracuda School"] = "Cardume de Barracuda Negra"
NL["Blackbelly Mudfish School"] = "Cardume de Muçuns-de-barriga-preta"
NL["Black Lotus"] = "Lótus Preto"
NL["Blackrock Deposit"] = "Depósito de Rocha Negra" -- Needs review
NL["Black Trillium Deposit"] = "Depósito de Trílio Negro"
NL["Blackwater Whiptail School"] = "Cardume de Azorragues Aguanegra" -- Needs review
NL["Blind Lake Sturgeon School"] = "Cardume de Esturjões Cegos do Lago" -- Needs review
NL["Blindweed"] = "Ervacega"
NL["Blood of Heroes"] = "Sangue dos Heróis"
NL["Bloodpetal Sprout"] = "Broto de Pétala Sangrenta"
NL["Bloodsail Wreckage"] = "Destroços dos Vela Sangrenta"
NL["Bloodsail Wreckage Pool"] = "Destroços dos Vela Sangrenta"
NL["Bloodthistle"] = "Cardossangue"
NL["Bloodvine"] = "Bloodvine"
NL["Bluefish School"] = "Cardume de Azulinhos"
NL["Borean Man O' War School"] = "Cardume de Caravelas Boreanas"
NL["Bound Adamantite Chest"] = "Baú de Adamantio vinculado"
NL["Bound Fel Iron Chest"] = "Baú de Ferrovil vinculado" -- Needs review
NL["Brackish Mixed School"] = "Cardume Misto Salobre"
NL["Briarthorn"] = "Cravespinho"
NL["Brightly Colored Egg"] = "Ovo Colorido Brilhante"
NL["Bruiseweed"] = "Ervamossa"
NL["Buccaneer's Strongbox"] = "Caixa-forte dos Bucaneiros"
NL["Burial Chest"] = "Baú de Enterro"
NL["Cinderbloom"] = "Cinzanilha"
NL["Cinder Cloud"] = "Nuvem de Cinzas"
NL["Cobalt Deposit"] = "Depósito de Cobalto"
NL["Copper Vein"] = "Veio de Cobre"
NL["Cursed Queenfish School"] = "Cardume de Peixe-rainha Amaldiçoado"
NL["Dark Iron Deposit"] = "Depósito de Ferro Negro"
NL["Dark Iron Treasure Chest"] = "Baú do Tesouro de Ferro Negro"
NL["Dark Soil"] = "Solo Negro"
NL["Dart's Nest"] = "Ninho da Saltadora"
NL["Deep Sea Monsterbelly School"] = "Cardume de Pançudos do Mar Profundo"
NL["Deepsea Sagefish School"] = "Cardume de Sabichões Abissais"
-- NL["Demonic Archaeology Find"] = "Demonic Archaeology Find"
NL["Dented Footlocker"] = "Maleta Amassada"
NL["Draenei Archaeology Find"] = "Descoberta Arqueológica Draeneica"
NL["Draenor Clans Archaeology Find"] = [=[Achado de Arqueologia dos Clães de Draenor
]=] -- Needs review
NL["Dragonfin Angelfish School"] = "Cardume de Acarás-bandeira Pinadragos"
NL["Dragon's Teeth"] = "Dentes-de-dragão"
NL["Dreamfoil"] = "Folha-de-sonho"
NL["Dreaming Glory"] = "Glória-sonhadora"
NL["Dreamleaf"] = "Folha-de-sonho"
NL["Dwarf Archaeology Find"] = "Descoberta Arqueológica Enânica"
NL["Earthroot"] = "Raiz-telúrica"
NL["Elementium Vein"] = "Veio de Elemêntio"
NL["Emperor Salmon School"] = "Cardume de Salmões Imperiais"
NL["Everfrost Chip"] = "Lasca de Gelo Eterno"
NL["Fadeleaf"] = "Some-folha"
NL["Fangtooth Herring School"] = "Cardume de Arenques Presadentes"
NL["Fathom Eel Swarm"] = "Grande Cardume de Enguias de Profundeza"
NL["Fat Sleeper School"] = "Cardume de Pestanas Gordos" -- Needs review
NL["Fel Iron Chest"] = "Baú de Ferrovil"
NL["Fel Iron Deposit"] = "Depósito de Ferrovil"
NL["Felmist"] = "Vilnévoa"
NL["Felmouth Frenzy School"] = "Cardume de Farnesim Bocavil" -- Needs review
NL["Felslate Deposit"] = "Depósito de Vilardósia"
NL["Felslate Seam"] = "Estrato de Vilardósia"
NL["Felsteel Chest"] = "Baú de Açovil"
NL["Feltail School"] = "REMOVIDO NA PATCH 2.4"
NL["Felweed"] = "Vilerva"
NL["Felwort"] = "Maltevil"
NL["Fever of Stormrays"] = "Febre de Trovarraias"
NL["Fire Ammonite School"] = "Cardume de Amonitas de Fogo" -- Needs review
NL["Firebloom"] = "Ignídea"
NL["Firefin Snapper School"] = "Cardume de Pargos Pinafogos"
NL["Firethorn"] = "Espinho de Fogo"
NL["Fireweed"] = "Ervígnea" -- Needs review
NL["Fjarnskaggl"] = "Fjarnskaggl"
NL["Flame Cap"] = "Chapéu-de-fogo"
NL["Floating Debris"] = "Destroços Flutuantes"
NL["Floating Debris Pool"] = "Destroços Flutuantes"
NL["Floating Shipwreck Debris"] = "Destroços do Naufrágio"
NL["Floating Wreckage"] = "Destroços Flutuantes"
NL["Floating Wreckage Pool"] = "Destroços Flutuantes"
NL["Fool's Cap"] = "Chapéu dos Tolos"
NL["Fossil Archaeology Find"] = "Descoberta Arqueológica de Fóssil"
NL["Foxflower"] = "Flor-de-raposa"
NL["Frost Lotus"] = "Lótus Gélido"
NL["Frostweed"] = "Erválgida" -- Needs review
NL["Frozen Herb"] = "Planta Congelada"
NL["Ghost Iron Deposit"] = "Depósito de Ferro Fantasma"
NL["Ghost Mushroom"] = "Cogumelo-fantasma"
NL["Giant Clam"] = "Marisco Gigante"
NL["Giant Mantis Shrimp Swarm"] = "Enxame de Camarões-grilo Gigantes"
NL["Glacial Salmon School"] = "Cardume de Salmões Glaciais"
NL["Glassfin Minnow School"] = "Cardume de Manjubinhas Galhavítreas"
NL["Gleaming Draenic Chest"] = "Baú Draneico Reluzente"
NL["Glowcap"] = "Chapéu-opalino"
NL["Glowing Tome"] = "Tomo Chamejante"
NL["Goldclover"] = "Trevo Dourado"
NL["Golden Carp School"] = "Cardume de Carpas Douradas"
NL["Golden Lotus"] = "Lótus Dourado"
NL["Golden Sansam"] = "Sonsona-dourada"
NL["Goldthorn"] = "Espinheira-dourada"
NL["Gold Vein"] = "Veio de Ouro"
NL["Gorgrond Flytrap"] = "Papa-mosca de Gorgrond" -- Needs review
NL["Grave Moss"] = "Musgo-de-tumba"
NL["Greater Sagefish School"] = "Grande Cardume de Sabichões"
NL["Green Tea Leaf"] = "Folha de Chá Verde"
NL["Gromsblood"] = "Sangue-de-grom"
NL["Heartblossom"] = "Coronália"
NL["Heavy Fel Iron Chest"] = "Baú Pesado de Ferrovil"
-- NL["Highborne Archaeology Find"] = "Highborne Archaeology Find"
NL["Highland Guppy School"] = "Cardume de Lebiste das Terras Altas"
NL["Highland Mixed School"] = "Cardume Misto das Terras Altas"
NL["Highmaul Reliquary"] = "Relicário do Malho Imponente" -- Needs review
NL["Highmountain Salmon School"] = "Cardume de Salmão Altamontês"
-- NL["Highmountain Tauren Archaeology Find"] = "Highmountain Tauren Archaeology Find"
NL["Huge Obsidian Slab"] = "Grande Pilha de Obsidios"
NL["Icecap"] = "Chapéu-de-gelo"
NL["Icethorn"] = "Espinho de Gelo"
NL["Imperial Manta Ray School"] = "Cardume de Arraias-jamanta Imperiais"
NL["Incendicite Mineral Vein"] = "Veio de Incendicita"
NL["Indurium Mineral Vein"] = "Mineral Indurio"
NL["Iron Deposit"] = "Depósito de Ferro"
NL["Jade Lungfish School"] = "Cardume de Piramboias de Jade"
NL["Jawless Skulker School"] = "Cardume de Sorrateiros Sem-queixo" -- Needs review
NL["Jewel Danio School"] = "Cardume de Peixes-zebra"
NL["Khadgar's Whisker"] = "Bigode-de-hadgar"
NL["Khorium Vein"] = "Veio de Kório"
NL["Kingsblood"] = "Sangue-real"
NL["Krasarang Paddlefish School"] = "Cardume de Peixes-espátula de Krasarang"
NL["Kyparite Deposit"] = "Depósito de Kyparita"
NL["Lagoon Pool"] = "Cardume da Lagoa" -- Needs review
NL["Large Battered Chest"] = "Baú Desgastado Grande"
NL["Large Darkwood Chest"] = "Baú de Lenhanegra Grande"
NL["Large Iron Bound Chest"] = "Baú Grande Reforçado com Ferro"
NL["Large Mithril Bound Chest"] = "Baú Grande Reforçado com Mithril"
NL["Large Obsidian Chunk"] = "Grande Estilhaço de Obisidiana"
NL["Large Solid Chest"] = "Baú Grande Sólido"
NL["Large Timber"] = "Lenho Grande" -- Needs review
NL["Lesser Bloodstone Deposit"] = "Depósito de Menor Plasma"
NL["Lesser Firefin Snapper School"] = "Lesser Firefin Snapper School"
NL["Lesser Floating Debris"] = "Lesser Floating Debris"
NL["Lesser Oily Blackmouth School"] = "Lesser Oily Blackmouth School"
NL["Lesser Sagefish School"] = "Lesser Sagefish School"
NL["Leypetal Blossom"] = "Flor de Pétala do Meridiano"
NL["Leypetal Powder"] = "Pó de Pétala do Meridiano"
NL["Leystone Deposit"] = "Depósito de Espinho do Meridiano"
NL["Leystone Seam"] = "Estrato de Pedra de Meridiano"
NL["Lichbloom"] = "Flor-de-lich"
NL["Liferoot"] = "Raiz-da-vida"
NL["Lumber Mill"] = "Serraria" -- Needs review
NL["Mageroyal"] = "Magi-real"
NL["Mana-Infused Gem"] = "Gema Imbuídas de Mana"
NL["Mana Thistle"] = "Manacardo"
NL["Mantid Archaeology Find"] = "Descoberta Arqueológica Mantídea"
NL["Maplewood Treasure Chest"] = "Baú do Tesouro de Bordo"
NL["Mithril Deposit"] = "Depósito de Mithril"
NL["Mixed Ocean School"] = "Cardume Misto do Mar"
NL["Mogu Archaeology Find"] = "Descoberta Arqueológica Mogu"
NL["Moonglow Cuttlefish School"] = "Cardume de Lulas Brilho-da-lua"
NL["Mossgill Perch School"] = "Cardume de Perca Pinalimo"
NL["Mossy Footlocker"] = "Maleta Mofada"
NL["Mountain Silversage"] = "Sávia-prata-da-montanha"
NL["Mountain Trout School"] = "Cardume de Truta da Montanha"
NL["Muddy Churning Water"] = "Muddy Churning Water"
NL["Mudfish School"] = "Cardume de Muçuns"
NL["Musselback Sculpin School"] = "Cardume de Mangangás Berbidorsos"
NL["Mysterious Camel Figurine"] = "Estatueta de Camelo Misteriosa"
NL["Nagrand Arrowbloom"] = "Ponta-de-seta de Nagrand" -- Needs review
NL["Nerubian Archaeology Find"] = "Descoberta Arqueológica Nerubiana"
NL["Netherbloom"] = "Floretérea"
NL["Nethercite Deposit"] = "Depósito de Etercita"
NL["Netherdust Bush"] = "Arbusto de Poeira Etérea"
NL["Netherwing Egg"] = "Ovo da Asa Etérea"
NL["Nettlefish School"] = "Cardume de Peixes-urtiga"
NL["Night Elf Archaeology Find"] = "Descoberta Arqueológica Noctiélfica"
NL["Nightmare Vine"] = "Vinha-do-pesadelo"
NL["Obsidian Chunk"] = "Estilhaço de Obisidiana"
NL["Obsidium Deposit"] = "Depósito de Obsídio"
NL["Ogre Archaeology Find"] = "Achado de Arqueologia Ôgrica" -- Needs review
NL["Oil Spill"] = "REMOVIDO NO CATACLISMO"
NL["Oily Abyssal Gulper School"] = "Cardume de Boca-grandes Abissais Oleosos" -- Needs review
NL["Oily Blackmouth School"] = "Cardume de Bocaneras Oleosos"
NL["Oily Sea Scorpion School"] = "Cardume de Escorpiões do Mar Oleosos" -- Needs review
NL["Onyx Egg"] = "Ovo Ônix"
NL["Ooze Covered Gold Vein"] = "Veio de Ouro Coberto de Gosma"
NL["Ooze Covered Mithril Deposit"] = "Depósito de Mithril Coberto de Gosma"
NL["Ooze Covered Rich Thorium Vein"] = "Veio de Tório Abundante Coberto de Gosma"
NL["Ooze Covered Silver Vein"] = "Veio de Prata Coberto de Gosma"
NL["Ooze Covered Thorium Vein"] = "Veio de Tório Coberto de Gosma"
NL["Ooze Covered Truesilver Deposit"] = "Depósito de Veraprata Coberto de Gosma"
NL["Orc Archaeology Find"] = "Descoberta Arqueológica Órquica"
NL["Other Archaeology Find"] = "Outras Descobertas Arqueológicas"
NL["Pandaren Archaeology Find"] = "Descoberta Arqueológica Pandaren"
NL["Patch of Elemental Water"] = "Patch of Elemental Water"
NL["Peacebloom"] = "Botão-da-paz"
NL["Plaguebloom"] = "Plaguebloom"
NL["Pool of Fire"] = "Lago de Fogo"
NL["Practice Lockbox"] = "Práticar Arrombamento"
NL["Primitive Chest"] = "Baú Primitivo"
NL["Pure Saronite Deposit"] = "Depósito de Saronita Pura"
NL["Pure Water"] = "Água Pura"
NL["Purple Lotus"] = "Lótus Roxo"
NL["Pyrite Deposit"] = "Depósito de Pirita"
NL["Radiating Apexis Shard"] = "Estilhaço Apexis Radiante"
NL["Ragveil"] = "Trapovéu"
NL["Rain Poppy"] = "Papoula-da-chuva"
NL["Ravasaur Matriarch's Nest"] = "Ninho da Matriarca Ravassauro"
NL["Razormaw Matriarch's Nest"] = "Ninho da Matriarca Rasgaqueixo"
NL["Redbelly Mandarin School"] = "Cardume de Mandarins Vermelhos"
NL["Reef Octopus Swarm"] = "Agrupamento de Polvos dos Recifes"
NL["Rich Adamantite Deposit"] = "Depósito de Adamantita Abundante"
NL["Rich Blackrock Deposit"] = "Depósito Rico de Rocha Negra" -- Needs review
NL["Rich Cobalt Deposit"] = "Depósito de Cobalto Abundante "
NL["Rich Elementium Vein"] = "Veio de Elemêntio Abundante"
NL["Rich Felslate Deposit"] = "Depósito Rico de Vilardósia"
NL["Rich Ghost Iron Deposit"] = "Depósito Repleto de Ferro Fantasma"
NL["Rich Kyparite Deposit"] = "Depósito Rico em Kyparita"
NL["Rich Leystone Deposit"] = "Depósito Rico de Pedra de Meridiano"
NL["Rich Obsidium Deposit"] = "Depósito de Obsídio Abundante"
NL["Rich Pyrite Deposit"] = "Depósito de Pirita Abundante"
NL["Rich Saronite Deposit"] = "Depósito de Saronita Abundante"
NL["Rich Thorium Vein"] = "Veio de Tório Abundante"
NL["Rich Trillium Vein"] = "Veio Repleto de Tríllio"
NL["Rich True Iron Deposit"] = "Depósito Rico de Ferro Verdadeiro" -- Needs review
NL["Runescale Koi School"] = "Cardume de Carpa Escama Rúnica"
NL["Runestone Treasure Chest"] = "Baú do Tesouro de Pedra Rúnica"
NL["Sagefish School"] = "Cardume de Sabichões"
NL["Saronite Deposit"] = "Depósito de Saronita"
NL["Savage Piranha Pool"] = "Cardume de Piranha Selvagem" -- Needs review
NL["Scarlet Footlocker"] = "Maleta Escarlate"
NL["School of Darter"] = "Cardume de Platis"
NL["School of Deviate Fish"] = "Cardume de Peixes Anormais"
NL["School of Tastyfish"] = "Cardume de Papa-Fina-Pintado"
NL["Schooner Wreckage"] = "Schooner Antiga"
NL["Schooner Wreckage Pool"] = "Destroços da Escuna"
NL["Sea Scorpion School"] = "Cardume de Escorpiões do Mar" -- Needs review
NL["Sha-Touched Herb"] = "Planta Tocada pelo Sha"
NL["Shipwreck Debris"] = "Restos de Naufrágio"
NL["Silken Treasure Chest"] = "Baú do Tesouro de Seda"
NL["Silkweed"] = "Flor-de-seda"
NL["Silverbound Treasure Chest"] = "Baú do Tesouro Reforçado com Prata"
NL["Silverleaf"] = "Folha-prata"
NL["Silver Vein"] = "Veio de Prata"
NL["Small Obsidian Chunk"] = "Pequeno Estilhaço de Obisidiana"
NL["Small Thorium Vein"] = "Veio de Tório Pequeno"
NL["Small Timber"] = "Lenho Pequeno" -- Needs review
NL["Snow Lily"] = "Lírio-das-neves"
NL["Solid Chest"] = "Baú do Tesouro Resistente"
NL["Solid Fel Iron Chest"] = "Baú Sólido de Ferrovil"
NL["Sorrowmoss"] = "Limágoa"
NL["Sparkling Pool"] = "Poça Brilhante" -- Needs review
NL["Sparse Firefin Snapper School"] = "Sparse Firefin Snapper School"
NL["Sparse Oily Blackmouth School"] = "Sparse Oily Blackmouth School"
NL["Sparse Schooner Wreckage"] = "Sparse Schooner Wreckage"
NL["Spinefish School"] = "Cardume de Peixes-espinho"
NL["Sporefish School"] = "Cardume de Esporosos"
NL["Starflower"] = "Florestrela" -- Needs review
NL["Starlight Rose"] = "Rosa-da-luz-estelar"
NL["Steam Cloud"] = "Nuvem de Vapor"
NL["Steam Pump Flotsam"] = "Destroços da Bomba de Vapor"
NL["Stonescale Eel Swarm"] = "Grande Cardume de Enguias Petrescamas"
NL["Stormvine"] = "Tempesvina"
NL["Strange Pool"] = "Piscina Estranha"
NL["Stranglekelp"] = "Estrangulalga"
NL["Sturdy Treasure Chest"] = "Baú do Tesouro Resistente"
NL["Sungrass"] = "Ervassol"
NL["Suspiciously Glowing Chest"] = "Baú com Brilho Suspeito"
NL["Swamp Gas"] = "Gás do Pântano"
NL["Takk's Nest"] = "Ninho de Takk"
NL["Talador Orchid"] = "Orquídea de Talador" -- Needs review
NL["Talandra's Rose"] = "Rosa de Talandra"
NL["Tattered Chest"] = "Baú Gasto"
NL["Teeming Firefin Snapper School"] = "Teeming Firefin Snapper School"
NL["Teeming Floating Wreckage"] = "Teeming Floating Wreckage"
NL["Teeming Oily Blackmouth School"] = "Teeming Oily Blackmouth School"
NL["Terocone"] = "Teropinha"
NL["Tiger Gourami School"] = "Cardume de Gouramis-tigre"
NL["Tiger Lily"] = "Lírio Tigre"
NL["Timber"] = "Lenho" -- Needs review
NL["Tin Vein"] = "Veio de Estanho"
NL["Titanium Vein"] = "Veio de Titânico"
NL["Tol'vir Archaeology Find"] = "Descoberta Arqueológica Tol'vírica"
NL["Trillium Vein"] = "Veio de Tríllio"
NL["Troll Archaeology Find"] = "Descoberta Arqueológica Trólica"
NL["Trove of the Thunder King"] = "Tesouro do Rei Trovão" -- Needs review
NL["True Iron Deposit"] = "Depósito de Ferro Verdadeiro" -- Needs review
NL["Truesilver Deposit"] = "Depósito de Veraprata"
NL["Twice-Fortified Arcwine"] = "Vinho Arcano Duplamente Fortificado"
NL["Twilight Jasmine"] = "Jasmim-do-crepúsculo"
NL["Un'Goro Dirt Pile"] = "Un'Goro Dirt Pile"
NL["Vrykul Archaeology Find"] = "Descoberta Arqueológica Vraikálica"
NL["Waterlogged Footlocker"] = "Maleta Encharcada"
NL["Waterlogged Wreckage"] = "Destroços Encharcados"
NL["Waterlogged Wreckage Pool"] = "Destroços Encharcados"
NL["Whiptail"] = "Azorrangue"
NL["White Trillium Deposit"] = "Depósito de Trílio Branco"
NL["Wicker Chest"] = "Baú de Vime"
NL["Wild Steelbloom"] = "Ácera-agreste"
NL["Windy Cloud"] = "Nuvem de Vento"
NL["Wintersbite"] = "Wintersbite"
NL["Withered Herb"] = "Planta Murcha" -- Needs review

