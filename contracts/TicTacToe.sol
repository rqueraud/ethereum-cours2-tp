pragma  solidity ^0.5.4;

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
        Check if the player is registered in the game as the host.
    */
    modifier isHost(uint gameNumber, address player){
        //TODO De la même manière que isOpponent, valider que le joueur est bien le host de la partie
    }

    /*
        Check if the player is registered in the game either as the host or the opponent.
    */
    modifier isPlayer(uint gameNumber, address player) {
        require(games[gameNumber].host == player || games[gameNumber].opponent == player, "Given player is not part of the game.");
        _;
    }

    /*
        Host plays on even turns, opponent plays on odd turns.
        Check that the given player can play on the actual turn.
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
    }

    modifier isValueProvided(uint value) {
        if(value > 0){
            _;
        }
    }

    function getGamesNumber() public view returns (uint) {
        return games.length;
    }

    /*
        Returns the game numbers of the connected account
    */
    function getHostGamesIds() {
        //TODO Retourner un array avec les numéro de jeux auquel le compte EOA appelant la fonction est inscrit.
    }

    /*
        The host can initiate the game for his address. He bet an initial amount of Ether.
    */
    function initGame(address opponent) {
        //TODO Créer un jeu et l'ajouter à la liste des jeux. Ce jeu doit enregistrer la mise du joueur le créant, ainsi que son addresse et l'addresse de l'adversaire qui sera passée en parametre.
    }

    /*
        The opponent join the game.
    */
    function joinGame(uint gameNumber) {
        //TODO L'adversaire (un compte EOA) rejoint une partie qu'il choisit et sur laquelle il est déjà enregistré comme adversaire. Il doit mettre une mise initiale correspondant à celle mise par le Host.
    }

    /*
        Play on a given cell
    */
    function play(uint gameNumber, uint row, uint column) {
        //TODO Un joueur place un pion sur un jeu auquel il s'est enregistré. Les mises des deux joueurs doivent être identiques pour jouer. Il faut également valider que la case n'a jamais été jouée.
    }

}