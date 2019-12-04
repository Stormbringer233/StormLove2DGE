-- Fichier de définition de thème pour la construction d'un GUI
-- Le fichier est générique et permet de modifier un thème facilement
-- Les objets graphiques (widgets) sont construit par assemblages de blocs

-- M. Le Thiec
-- 06/06/18

-- Table des données du theme graphique de la GUI
THEME = {}

THEME.widgetSheet = "buttons" -- nom de la feuille de widgets suivant le theme

-- Ici se déclarent toutes les coordonnées de Quads {x0, y0, x1, y1} du bloc
-- x0, y0 +----------
--        |         |
--        ----------+ x1, y1
-- le theme est une définition de texture atlas
-- Chaque élément graphique doit être définit avec les noms ci dessous. C'est un modèle statique

-- ATTENTION : respecter les denominations ci-dessous impérativement !
-- pour les fenêtres, seuls les états normal et focus sont gérés
THEME["windows"] = {}
THEME["windows"]["option"] = {}
THEME["windows"]["option"].name = "optionWin" -- nom de la fenètre option dans le répertoire
THEME["windows"]["option"].bound = {0, 0, 401, 62} -- bounding box de la barre de titre
THEME["windows"]["option"].normal = {0,0,401,351} -- ou une table de quad dans la sheet
THEME["windows"]["option"].focus =  {0,0,401,351} --{401, 0, 801, 351}

-- Gestion des panels. Les panels sont des types de fenêtres non déplacables
THEME["panels"] = {}
THEME["panels"]["ingame"] = {}
THEME["panels"]["ingame"].name = "inGameMenu" -- nom de l'image de fond du panel
THEME["panels"]["ingame"].bound = {0,0,1024,200}
THEME["panels"]["ingame"].normal = {0,0,1024,200}
THEME["panels"]["ingame"].focus = {0,0,1024,200}

-- Les différents états des boutons s'adaptent aux besoins en fonction du bouton.
-- TOUS les états doivent être renseignés dans ce fichier et dans le cas ou graphiquement, 2 états sont
-- identiques, il est indispensable de créer une ligne pour chaque état avec les mêmes coordonnées de quads
-- ATTENTION : les noms des états ne sont pas modifiables
THEME["button"] = {}
THEME["button"]["default"] = {}
THEME["button"]["default"].normal = {0,0,128,32} -- dessin d'un bouton fixe par defaut
THEME["button"]["default"].deactvate = {0,0,128,32} -- dessin d'un bouton fixe par defaut
THEME["button"]["default"].focus = {0,0,128,32}
THEME["button"]["default"].activate = {0,0,0,0}
THEME["button"]["default"].clicked = {0,0,0,0}
THEME["button"]["default"].freeze = {0,0,0,0}

THEME["button"]["look"] = {}
THEME["button"]["look"].normal = {1,1,210,50}
THEME["button"]["look"].focus = {214,1,423,50}
THEME["button"]["look"].activate = {1,1,210,50}
THEME["button"]["look"].clicked = {1,1,210,50}
THEME["button"]["look"].freeze = {1,1,210,50}

THEME["button"]["take"] = {}
THEME["button"]["take"].normal = {1,59,185,106}
THEME["button"]["take"].focus = {214,59,398,106}
THEME["button"]["take"].activate ={1,59,185,106}
THEME["button"]["take"].clicked = {1,59,185,106}
THEME["button"]["take"].freeze = {1,59,185,106}

THEME["button"]["put"] = {}
THEME["button"]["put"].normal = {1,117, 134,156}
THEME["button"]["put"].focus = {214,117,347,156}
THEME["button"]["put"].activate ={1,117, 134,156}
THEME["button"]["put"].clicked = {1,117, 134,156}
THEME["button"]["put"].freeze = {1,117, 134,156}

THEME["button"]["combine"] = {}
THEME["button"]["combine"].normal = {1,171, 210,211}
THEME["button"]["combine"].focus = {214,171,422, 211}
THEME["button"]["combine"].activate ={1,171, 210,211}
THEME["button"]["combine"].clicked = {1,171, 210,211}
THEME["button"]["combine"].freeze = {1,171, 210,211}

THEME["button"]["use"] = {}
THEME["button"]["use"].normal = {1,232, 183, 268}
THEME["button"]["use"].focus = {214,232,396, 268}
THEME["button"]["use"].activate ={1,232, 183, 268}
THEME["button"]["use"].clicked = {1,232, 183, 268}
THEME["button"]["use"].freeze = {1,232, 183, 268}

THEME["button"]["north"] = {}
THEME["button"]["north"].normal = {452, 6, 518, 48}
THEME["button"]["north"].focus = {524, 6, 590, 48}
THEME["button"]["north"].activate = {596,6, 662,48}
THEME["button"]["north"].clicked = {596,6, 662,48}
THEME["button"]["north"].freeze = {452, 6, 518, 48}

THEME["button"]["south"] = {}
THEME["button"]["south"].normal = {452, 56, 518, 98}
THEME["button"]["south"].focus = {524, 56, 590, 98}
THEME["button"]["south"].activate = {596,66, 662,98}
THEME["button"]["south"].clicked = {596,66, 662,98}
THEME["button"]["south"].freeze = {452, 56, 518, 98}

THEME["button"]["est"] = {}
THEME["button"]["est"].normal = {608,111, 650,177}
THEME["button"]["est"].focus = {659,111, 701,177}
THEME["button"]["est"].activate = {708,111, 750,177}
THEME["button"]["est"].clicked = {708,111, 750,177}
THEME["button"]["est"].freeze = {608,111, 650,177}

THEME["button"]["west"] = {}
THEME["button"]["west"].normal = {452,111, 494,177}
THEME["button"]["west"].focus = {502,111, 543,177}
THEME["button"]["west"].activate = {551,111, 591,177}
THEME["button"]["west"].clicked = {551,111, 591,177}
THEME["button"]["west"].freeze = {452,111, 494,177}
