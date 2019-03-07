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
        address payable host;
        address payable opponent;
        mapping(uint => mapping(uint => uint)) board;  // (Row, Column) format
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
        require(games[gameNumber].board[row][column] != 0, "Cell is already used");
        _;
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
    function getHostGamesIds() public view returns (uint[] memory idgames){
        //TODO Retourner un array avec les numéro de jeux auquel le compte EOA appelant la fonction est inscrit.
        idgames = new uint[](getGamesNumber());
        uint y = 0;
        for (uint i=0;i<getGamesNumber();i++) {
            if (games[i].host == msg.sender || games[i].opponent == msg.sender) {
                idgames[y] = i;
                y++;
            }
        }
        return idgames;
    }

    /*
        The host can initiate the game for his address. He bet an initial amount of Ether.
    */
    function initGame(address payable opponent) public payable {
        //TODO Créer un jeu et l'ajouter à la liste des jeux. Ce jeu doit enregistrer la mise du joueur le créant, ainsi que son addresse et l'addresse de l'adversaire qui sera passée en parametre.
        Game memory g = Game({
            turn:0,
            host:msg.sender,
            opponent:opponent,
            hostBalance:msg.value,
            opponentBalance:0
        });

        games.push(g);
    }

    /*
        The opponent join the game.
    */
    function joinGame(uint gameNumber) public isOpponent(gameNumber,msg.sender) payable {
        //TODO L'adversaire (un compte EOA) rejoint une partie qu'il choisit et sur laquelle il est déjà enregistré comme adversaire. Il doit mettre une mise initiale correspondant à celle mise par le Host.
        Game storage g = games[gameNumber];
        g.opponentBalance = msg.value;
    }

    /*
        Play on a given cell
    */
    function play(uint gameNumber, uint row, uint column) public payable {
        //TODO Un joueur place un pion sur un jeu auquel il s'est enregistré. Les mises des deux joueurs doivent être identiques pour jouer. Il faut également valider que la case n'a jamais été jouée.
        Game storage g = games[gameNumber];

        //Assign an int to identify players, host -> 1, opponent-> 0
        uint8 player = 0;
        if(msg.sender == g.host)
            player = 1;

        // Performs some checks to verify the correctness of the move:
        // 1 - There must be a bet value stored by the contract (balance)
        // 2 - There must be an opponent to play
        // 3 - You must play a move inside the board  0>=row>=2 and 0>=column>=2
        // 4 - There should be no other moves played on the same place
        // 5 - You must play in time w.r.t. TimeLimit
        // 6 - There must be your turn
        if(g.hostBalance > 0 && row >= 0 && row < 3 && column >= 0 && column < 3 && g.board[row][column] == 0 && g.turn%2 != player)
        {
            // Put the move in the board
            g.board[row][column] = player;

            // If the board is full resend halved balance to each player
            if(is_board_full(gameNumber)) {
                g.host.transfer(g.hostBalance);
                g.opponent.transfer(g.opponentBalance);
                g.hostBalance = 0;
                g.opponentBalance = 0;
                restart(gameNumber);
                return;
            }

            // If the last move decreed a winner send thw whole balance to him
            // and restart the game
            if(is_winner(gameNumber, player))
            {
                if(player == 1)
                    g.host.transfer(g.opponentBalance);
                else
                    g.opponent.transfer(g.hostBalance);
                g.hostBalance = 0;
                g.opponentBalance = 0;
                restart(gameNumber);
                return;
            }

            // Set player's turn
            g.turn = player;


        }
    }


    // Vérification si le Plateau de Jeu est Full.
    function is_board_full(uint gameNumber) private view returns (bool retVal)
    {
        Game storage g = games[gameNumber];
        uint count = 0;
        for(uint r = 0; r < 3; r++) {
            for(uint c = 0; c < 3; c++) {
                if(g.board[r][c] > 0) {
                    count++;
                }
                if(count >= 9) {
                    return true;
                }
            }
        }          
    }

    // Function used to restart the game, it's possible only if there's not
    // appended balance.
    function restart(uint gameNumber) private
    {
        Game storage g = games[gameNumber];
        if(g.hostBalance == 0 && g.opponentBalance == 0)
        {
            g.turn = 1;

            for(uint r = 0; r < 3; r++) {
                for(uint c = 0; c < 3; c++) {
                    g.board[r][c] = 0;
                }
            }               
        }
    }

    // Boolean function that verify wheter the board is in a winning condition or not
    function is_winner(uint gameNumber, uint player) private view returns (bool winner)
    {
        // Verify if there's a winning streak on diagonals
        if(check(gameNumber, player, 0, 1, 2, 0, 1, 2) || check(gameNumber, player, 0, 1, 2, 2, 1, 0))
            return true;

        // Verify if there's a winning streak on rows and columns
        for(uint r = 0; r < 3; r++) {
            if(check(gameNumber, player, r, r, r, 0, 1, 2) || check(gameNumber, player, 0, 1, 2, r, r, r)) {
                return true;
            }
        }            
    }


    function check(uint gameNumber, uint player, uint r1, uint r2, uint r3,uint c1, uint c2, uint c3) private view returns (bool retVal)
    {
        Game storage g = games[gameNumber];
        if(g.board[r1][c1] == player && g.board[r2][c2] == player && g.board[r3][c3] == player)
            return true;
    }

    //récupération des valeurs misées par l'Hote
    function getHostBalances(uint gameNumber) public view returns (uint Hostbalance) {
         return games[gameNumber].hostBalance;
    }

    //récupération des valeurs misées par l'adversaire
    function getOppBalances(uint gameNumber) public view returns (uint Oppbalance) {
         return games[gameNumber].opponentBalance;
    }


}