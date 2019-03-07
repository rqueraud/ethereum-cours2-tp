App = {
  web3Provider: null,
  contracts: {},

  init: async function () {
    return await App.initWeb3();
  },

  initWeb3: async function () {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function () {
    $.getJSON('TicTacToe.json', function (data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var TicTacToeArtifact = data;
      App.contracts.TicTacToe = TruffleContract(TicTacToeArtifact);

      // Set the provider for our contract
      App.contracts.TicTacToe.setProvider(App.web3Provider);

      // Initialize the refresh loop
      App.initRefreshLoop()
    });
  },

  initRefreshLoop: function () {
    setInterval(function () {
      App.contracts.TicTacToe.deployed().then(function (instance) {
  
        // Retrieve the game Ids and populate the board list
        instance.getHostGamesIds().then(function(result){
          ids = result[0];
          var boardsDiv = document.getElementById("boards");
          boardsDiv.innerHTML = ""; 

          for(let k=0 ; k<result[0].length ; k++){

            instance.getGame(result[0][k]).then((game) => {
              let id = result[0][k];
              let bet = game[0];
              let turn = game[1];

              

              function cellFormat(cell){
                switch(`${cell}`) {
                  case '1':
                    return 'X';
                    break;
                  case '2':
                    return 'O';
                    break;
                  default:
                    return ' ';
                    break;
                }
              }
                var boardDiv = document.createElement("div");
                var h1 = document.createElement("h1");
                h1.innerHTML = `Board ${id}, turn ${turn}`;
                var h3 = document.createElement("h3");
                h3.innerHTML = `Bet amount : ${bet / 1000000000000000000} ETH`;
                var table = document.createElement("table");

                let cell = 0;    
                for(i=0 ; i<3 ; i++){
                  var tr = document.createElement("tr");
                  tr.setAttribute("id", `row-${i}`);
                  for(j=0 ; j<3 ; j++){
                    var td = document.createElement("td");
                    td.setAttribute("id", `col-${j}`);
                    td.setAttribute("onClick",`App.play(${result[0][k]},${i},${j});`);
                    td.innerHTML = cellFormat(game[2][cell]); 
                    cell++;
                    tr.appendChild(td);
                  }
                  table.appendChild(tr);
                }
    
                boardDiv.appendChild(h1);
                boardDiv.appendChild(h3);
                boardDiv.appendChild(table);
                boardsDiv.appendChild(boardDiv);

            }); 
          }
        });

      });

    }, 2000);
  },

  handleInitGame: function () {

    var initGameValue = parseInt(document.getElementById("initGameValue").value)*1000000000000000000;
    var opponentAddress = document.getElementById("initGameOpponent").value

    App.contracts.TicTacToe.deployed().then(function (instance) {
      instance.initGame(opponentAddress, { value: initGameValue }).then(function () {});
    });
  },

  handleJoinGame: function () {
    var joinGameValue = parseInt(document.getElementById("joinGameValue").value)*1000000000000000000;
    var joinGameNumber = parseInt(document.getElementById("joinGameNumber").value);

    App.contracts.TicTacToe.deployed().then(function (instance) {
      instance.joinGame(joinGameNumber, { value: joinGameValue }).then(function () {});
    });

  },

  play: function (gameNumber, row, col) {    
    App.contracts.TicTacToe.deployed().then(function (instance) {
      instance.play(gameNumber, row, col).then(function () {
        function isWinner(board){
          for(let p of [1,2]){
            if(`${board[0]}` == p && `${board[1]}` == p && `${board[2]}` == p ||
              `${board[0]}` == p && `${board[4]}` == p && `${board[8]}` == p ||
              `${board[0]}` == p && `${board[3]}` == p && `${board[6]}` == p ||
              `${board[1]}` == p && `${board[4]}` == p && `${board[7]}` == p ||
              `${board[2]}` == p && `${board[4]}` == p && `${board[6]}` == p ||
              `${board[2]}` == p && `${board[5]}` == p && `${board[8]}` == p ||
              `${board[3]}` == p && `${board[4]}` == p && `${board[5]}` == p ||
              `${board[6]}` == p && `${board[7]}` == p && `${board[8]}` == p) {
                return p;
              }
          }
          if (`${board[0]}` != 0 && `${board[1]}` != 0 && `${board[2]}` != 0 && 
          `${board[3]}` != 0 && `${board[4]}` != 0 && `${board[5]}` != 0 && 
          `${board[6]}` != 0 && `${board[7]}` != 0 && `${board[8]}` != 0) {
            return 3;
          }
          return 0;
        }
          let winner = isWinner(game[2]);
          if(winner !== 0){
            instance.endGame(id, winner).then(()=>{});
          }
      });
    });

  }

};

$(function () {
  $(window).load(function () {
    App.init();
  });
});