# TP Blockchain Ethereum - TicTacToe

Ce repository vous propose, par le biais d'un code à trou, de créer une première version d'un jeu de TicTacToe.

Ce code donne la structure de base pour coder en Solidity. Il met à votre disposition un SmartContract (TicTacToe.sol) ainsi qu'une première version de l'interface web communiquant avec le smart-contract deployé.  
Au niveau fonctionnalités :
  - Nous définissons la structure de base d'un jeu (structure "Game")
  - Nous permettons de créer une nouvelle partie (fonction "initGame") et y placer une mise de départ.
  - Quelques fonctions sont présentes pour valider que chaque joueur à mis la même mise, pour vérifier le tour de jeu, pour placer un pion...

Dans un premier temps, il s'agit de remplir le code du contrat en Solidity et de l'interface graphique en Javascript. Le reste du déroulement du jeu est à votre charge et est libre d'implémentation. Vous pouvez vous inspirer des autres fonctions ecrites, des documentations, et de toute ressource que vous jugez nécessaire.

Tout ce qu'il y a dans ce TP constitue un exemple d'implémentation, vous n'êtes pas obligé de le suivre.  

## 0. Étapes préliminaires

Vous devez avoir suivi le tutoriel https://truffleframework.com/tutorials/pet-shop afin d'avoir un environnement de développement fonctionnel. Celui-ci comprend :
  - Installation de npm : https://nodejs.org/en/download/
  - Installation de truffle : https://truffleframework.com/docs/truffle/getting-started/installation
  - Installation de ganache : https://truffleframework.com/docs/ganache/quickstart
  - Installation de Metamask : https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn

Vous pourrez également avoir besoin des outils de base de développement : 
  - Un éditeur de code : https://code.visualstudio.com/
  - Un terminal : Utilisez celui intégré dans Visual Studio Code
  - Un client Git : https://git-scm.com/downloads

## 1. Logique de base du jeu

La logique du jeu est contenue dans le fichier `contracts/TicTacToe.sol`. Vous allez devoir compléter ce fichier qui contient le code du smart contract.

Les fonctions que vous devez implémenter ont un contenu "//TODO". Vous allez devoir modifier le corps et la signature de la fonction.  
Vous disposez de modifiers que vous pouvez utiliser pour faire des **check** sur vos fonctions. Libre à vous d'en implémenter de nouveaux si besoin.

Ces fonctions sont :
  - Le modifier isHost, qui valide que le joueur est bien le Host.
  - Le modifier isCellFree, qui valide qu'une case n'a jamais été jouée.
  - getHostGamesIds, qui doit retourner la liste des jeux auquel participe le compte EOA (l'adresse donc).
  - initGame, qui doit créer un nouveau jeu avec la somme en Ether que mise le compte EOA.
  - joinGame, qui a pour but d'être executée par l'opponent et valider qu'il met en jeu une mise similaire au host.
  - play, qui permet d'enregistrer un coup sur le board.

Pour valider le code, une batterie de tests unitaires est envisageable, mais nous allons plutôt nous concentrer sur l'implementation.  
Dans un premier temps, nous validerons que le code compile bien, puis nous y reviendrons une fois que notre interface utilisateur sera prête et nous debuggerons les deux en même temps.

Pour valider dans un premier temps que le code compile :

```bash
truffle compile
truffle migrate  # Quand ça compile bien
```

## 2. Interface utilisateur

Le code du dossier **src** contient l'interface utilisateur qui est une interface classique en html/js (je vous laisse le soin de mettre du css pour le style si cela vous fait plaisir ;).

Pour visualiser l'interface, plusieurs étapes sont nécessaires :

```bash
npm install  # Installe les paquets node necessaires au projet
npm run dev  # Lance un serveur web local
```

De la même manière que pour le code solidity, vous allez avoir modifier la logique pour récupérer les informations du smart contract deployé.  
Ce code se trouve dans le fichier `src/js/App.js`.

Les fonctions à modifier sont :
  - handleJoinGame, qui récupère les valeurs des champs et appelle joinGame sur le contrat. De manière similaire à initGame.
  - Implémenter une manière de voir les valeurs misées par le joueur connecté et son adversaire.
  - Implémenter une façon de jouer en faisant appel à la fonction **play** du contrat.

## 3. Axes d'amélioration

Une fois le TP terminé, plusieurs axes d'amélioration sont possibles :
  - Terminer le jeu et le rendre complètement fonctionnel pour deux joueurs sur la même machine.
  - Ne pas faire une actualisation active de l'interface mais plutôt souscrire à un evenement sur le changement d'un de nos boards.
  - Déployer le smart contract sur la blockchain publique Ropsten, permettant ainsi à deux joueurs de jouer sur des machines distinctes.
  - Héberger l'application sur Swarm.
  - Mettre en place Whisper pour que les deux joueurs discutent en amont de la mise initiale à joueur
  - Mettre en place Raiden pour avoir des micro-paiements et ainsi pouvoir enchainer les parties de manière légère.