console.log("loading app.js");

var wsScheme = window.location.protocol == "https:" ? "wss" : "ws";
var wsPath = wsScheme + "://" + window.location.host + "/ws/";

const terminal = document.getElementById('terminal');
const statusIndicator = document.getElementById('connectionStatus');

function updateConnectionStatus(isConnected) {
  console.log("updateConnectionStatus");
  statusIndicator.style.background = isConnected ? 'rgba(0, 255, 0, 0.3)' : 'rgba(255, 0, 0, 0.4)';
}

function connectWebSocket() {
  statusIndicator.style.background = 'blue';
  console.log("Connecting to " + wsPath);
  var socket = new WebSocket(wsPath);

  socket.onopen = function(event) {
    console.log("WebSocket is open now.");
    updateConnectionStatus(true);
    terminal.textContent = "";
  };

  socket.onmessage = function(event) {
    terminal.textContent += event.data;
    // Auto-scroll to the bottom
    terminal.scrollTop = terminal.scrollHeight;
  };

  socket.onclose = function(event) {
    console.log("WebSocket is closed now.");
    updateConnectionStatus(false);
    setTimeout(connectWebSocket, 1000);
  };

  socket.onerror = function(error) {
    statusIndicator.style.background = 'orange';
    console.error("WebSocket error observed:", error);
  };

};

connectWebSocket();
/* 
document.addEventListener("DOMContentLoaded", function() {
  connectWebSocket();
});
*/
