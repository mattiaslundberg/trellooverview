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

app.ports.trelloListLists.subscribe(function(id) {
  console.log("list lists for board", id)
  Trello.get(
    "/boards/" + id + "/lists",
    {},
    function(lists) {
      app.ports.trelloList.send(JSON.stringify(lists))
    },
    function(error) {
      console.log(error)
    }
  )
})

app.ports.trelloListCards.subscribe(function(id) {
  console.log("list cards for list", id)
  Trello.get(
    "/lists/" + id + "/cards",
    {},
    function(cards) {
      app.ports.trelloCards.send(JSON.stringify(cards))
    },
    function(error) {
      console.log(error)
    }
  )
})


// Connect localStorage to application
app.ports.localStorageSet.subscribe(function(ls) {
  localStorage.setItem(ls.key, ls.value)
})

app.ports.localStorageGet.subscribe(function(key) {
  console.log("get for key", key)
  var value = localStorage.getItem(key)
  if (value) {
    app.ports.localStorageGot.send({key: key, value: value})
  }
})
