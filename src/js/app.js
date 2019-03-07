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
        instance.getHostGamesIds().then(async function (ids) {
          console.log(`ids : ${ids}`);

          var boardsDiv = document.getElementById("boards");
          boardsDiv.innerHTML = "";

          for (let id of ids) {
            var boardDiv = document.createElement("div");
            var h1 = document.createElement("h1");
            h1.innerHTML = `Board ${id}`;

            var h2 = document.createElement("h2");
            h2.innerHTML = `Mise : ${await instance.getGamePrice(id)}`;

            var h3 = document.createElement("h2");
            h3.innerHTML = `Opponent : ${await instance.getOppenentAddress(id)}`;

            var table = document.createElement("table");

            for (i = 0; i < 3; i++) {
              var tr = document.createElement("tr");
              for (j = 0; j < 3; j++) {
                var button = document.createElement("button");
                button.setAttribute("id", `table${id}-row${i}-col${j}`);
                button.setAttribute('onClick', `App.handlePlayGame(${id}, ${i}, ${j})`);
                button.innerHTML = "___";
                
                tr.appendChild(button);
              }
              table.appendChild(tr);
            }

            boardDiv.appendChild(h1);
            boardDiv.appendChild(h2);
            boardDiv.appendChild(h3);
            boardDiv.appendChild(table);
            boardsDiv.appendChild(boardDiv);
          }
        });

      });
    }, 1000);
  },

  handleInitGame: function () {
    let initGameValue = parseInt(document.getElementById("initGameValue").value);
    let opponentAddress = document.getElementById("initGameOpponent").value

    App.contracts.TicTacToe.deployed().then(
      (instance) => {
        instance.initGame(opponentAddress, initGameValue).then(function () { });
      });
  },

  handleJoinGame: function () {
    let joinGameValue = parseInt(document.getElementById("joinGameValue").value);
    let joinGameNumber = document.getElementById("joinGameNumber").value

    App.contracts.TicTacToe.deployed().then(
      (instance) => {
        instance.joinGame(joinGameNumber, joinGameValue).then(function () { });
      });
  },

  handlePlayGame: function (gameNumber, row, column) {
    App.contracts.TicTacToe.deployed().then(
      (instance) => {
        instance.play(gameNumber, row, column).then(function () { });
      });
  },

  showPrice: function () {
    let joinGameNumber = document.getElementById("joinGameNumber").value

    App.contracts.TicTacToe.deployed().then(
      (instance) => {
        instance.joinGame(joinGameNumber, joinGameValue).then(function () { });
      });
  }


};

$(function () {
  $(window).load(function () {
    App.init();
  });
});
