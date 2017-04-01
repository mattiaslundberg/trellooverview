// Start TrelloOverview app
while (document.body.firstChild) {
    document.body.removeChild(document.body.firstChild)
}
var app = runElmProgram()

// Connect trello client js to elm application
app.ports.trelloAuthorized.subscribe(function() {
    var isAuthorized = Trello.authorized()
    app.ports.trelloAuthorizedResponse.send(isAuthorized)
})

app.ports.trelloAuthorize.subscribe(function() {
  Trello.authorize({
    type: 'redirect',
    name: 'Trello Overview',
    scope: {
      read: 'true',
      write: 'false'
    },
    expiration: 'never',
    success: function() {
      console.log("Success")
      app.ports.trelloAuthorizedResponse.send(true)
    },
    error: function() {
      console.log("Error")
    }
  })
})

app.ports.trelloListBoards.subscribe(function() {
    Trello.get(
        "/members/me/boards",
        {fields: "name, id"},
        function(boards) {
          app.ports.trelloBoards.send(JSON.stringify(boards))
        },
        function(error) {
          console.log(error)
        }
    )
})
