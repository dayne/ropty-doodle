document.addEventListener("DOMContentLoaded", function() {
    const terminal = document.getElementById('terminal');
    
    var wsScheme = window.location.protocol == "https:" ? "wss" : "ws";
    var wsPath = wsScheme + "://" + window.location.host + "/ws/";
    console.log("Connecting to " + wsPath);
    var socket = new WebSocket(wsPath);

    socket.onopen = function(event) {
        console.log("WebSocket is open now.");
        terminal.textContent = "";
    }

    socket.onmessage = function(event) {
        terminal.textContent += event.data;
        // Auto-scroll to the bottom
        terminal.scrollTop = terminal.scrollHeight;
    };

    socket.onopen = function(event) {
        console.log("WebSocket is open now.");
    };

    socket.onclose = function(event) {
        console.log("WebSocket is closed now.");
    };

    socket.onerror = function(error) {
        console.error("WebSocket error observed:", error);
    };
});
