// Start TrelloOverview app
while (document.body.firstChild) {
    document.body.removeChild(document.body.firstChild);
}
var app = runElmProgram();

// Connect trello client js to elm application
app.ports.trelloAuthorized.subscribe(function(word) {
    var isAuthorized = Trello.authorized();
    app.ports.trelloAuthorizedResponse.send(isAuthorized);
});
