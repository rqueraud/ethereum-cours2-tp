pragma solidity ^0.5.4;


/*
    This contract shows an example of the TicTacToe game written in Solidity.
    Be careful while using it as it may be vulnerable to attacks.
*/
contract TicTacToe {

    Game[] public games;

    struct Game {
        uint turn;
        uint hostBalance;
        uint opponentBalance;
        address host;
        address opponent;
        mapping(uint => mapping(uint => address)) board;  // (Row, Column) format
    }

    constructor() public {
    }

    /*
        Check if the player is registered in the game as the opponent.
    */
    modifier isOpponent(uint gameNumber, address player){
        require(games[gameNumber].opponent == player, "Given player should be the opponent.");
        _;
    }

    /*
        Check if the two players have credited the same amount
    */
    modifier isGameBalanceEqual(uint gameNumber) {
        Game memory game = games[gameNumber];
        require(game.hostBalance == game.opponentBalance, "Balance of players for the game are not equal.");
        _;
    }

    /*
        Check if the bet of the opponent is equal of the host's bet
    */
    modifier isBetEqual(uint gameNumber, uint amount) {
        Game memory game = games[gameNumber];
        require(game.hostBalance == amount, "Balance of players for the game are not equal.");
        _;
    }

    /*
        Check if the player is registered in the game as the host.
    */
    modifier isHost(uint gameNumber, address player) {
         //TODO De la même manière que isOpponent, valider que le joueur est bien le host de la partie
        require(games[gameNumber].host == player, "Given player should be the host.");
        _;
    }

    /*
        Check if the player is registered in the game either as the host or the opponent.
    */
    modifier isPlayer(uint gameNumber, address player) {
        require(games[gameNumber].host == player || games[gameNumber].opponent == player, "Given player is not part of the game.");
        _;
    }

    /*
        Host plays on even turns, opponent plays on odd turns. Check that the given player can play on the actual turn.
    */
    modifier isPlayerTurn(uint gameNumber, address player){
        if(games[gameNumber].turn%2 == 0 && player == games[gameNumber].host){
            _;
        }
        else if(games[gameNumber].turn%2 == 1 && player == games[gameNumber].opponent){
            _;
        }
    }

    /*
        Check if the cell is playable
    */
    modifier isCellFree(uint gameNumber, uint row, uint column){
        //TODO Valider que la case n'a jamais été jouée
        if (games[gameNumber].board[row][column] != games[gameNumber].opponent &&
                games[gameNumber].board[row][column] != games[gameNumber].host){
            _;
        }
    }

    modifier isValueProvided(uint value) {
        if(value > 0){
            _;
        }
    }

    function getGamesNumber() public view returns (uint) {
        return games.length;
    }

    function isRegistered(uint gameNumber, address player) private view returns (bool)  {
        return games[gameNumber].host == player || games[gameNumber].opponent == player;
    }

    function getBoard(uint index) public view returns (uint[] memory) {
        uint[] memory board = new uint[](9);
        uint k = 0;
        for(uint i=0; i<3; i++){
            for(uint j=0; j<3; j++){
                if(games[index].board[i][j] == games[index].host){
                    board[k] = 1;
                } else if (games[index].board[i][j] == games[index].opponent) {
                    board[k] = 2;
                } else {
                    board[k] = 0;
                }
                k++;
            }
        }
        return board;
    }

    function getGame(uint index) public view returns(uint, uint, uint[] memory) {
        uint[] memory board = getBoard(index);
        return (games[index].hostBalance, games[index].turn, board);
    }

    /*
        Returns the game numbers of the connected account
    */
    function getHostGamesIds() public view returns (uint[] memory, uint[] memory) {
           //TODO Retourner un array avec les numéro de jeux auquel le compte EOA appelant la fonction est inscrit.
        uint len = 0;
        for (uint i=0; i<getGamesNumber(); i++) {
            if(isRegistered(i, msg.sender)){
                len += 1;
            }
        }
        
        uint[] memory gamesArr = new uint[](len);
        uint[] memory betArr = new uint[](len);
        len = 0;
        for (uint i=0; i<getGamesNumber(); i++) {
            if(isRegistered(i, msg.sender)){
                gamesArr[len] = i;
                betArr[len] = games[i].hostBalance;
                len +=1;
            }
        }
        return(gamesArr, betArr);
    }

    /*
        The host can initiate the game for his address. He bet an initial amount of Ether.
    */
    function initGame(address opponent) public payable {
           //TODO Créer un jeu et l'ajouter à la liste des jeux. Ce jeu doit enregistrer la mise du joueur le créant, ainsi que son addresse et l'addresse de l'adversaire qui sera passée en parametre.
        Game memory newGame = Game({
            opponent:opponent, 
            host:msg.sender,
            turn:0,
            hostBalance:msg.value,
            opponentBalance:0
        });

        games.push(newGame);
    }

    /*
        The opponent join the game.
    */
    function joinGame(uint gameNumber) 
    //TODO L'adversaire (un compte EOA) rejoint une partie qu'il choisit et sur laquelle il est déjà enregistré comme adversaire. Il doit mettre une mise initiale correspondant à celle mise par le Host.
        isOpponent(gameNumber, msg.sender) 
        isBetEqual(gameNumber, msg.value) public payable {

        games[gameNumber].opponentBalance = msg.value;                
    }

    /*
        Play on a given cell
    */
    function play(uint gameNumber, uint row, uint column) 
    //TODO Un joueur place un pion sur un jeu auquel il s'est enregistré. Les mises des deux joueurs doivent être identiques pour jouer. Il faut également valider que la case n'a jamais été jouée.
        isPlayer(gameNumber, msg.sender) 
        isGameBalanceEqual(gameNumber) 
        isPlayerTurn(gameNumber, msg.sender)
        isCellFree(gameNumber, row, column) public payable {

        games[gameNumber].board[row][column] = msg.sender;
        games[gameNumber].turn += 1;
    }

    function endGame(uint gameNumber, uint winner) public payable {
        address host = games[gameNumber].host;
        address opponent = games[gameNumber].opponent;
        delete games[gameNumber];
    }
}