window.onload = function () {
  // Start TrelloOverview app
  while (document.body.firstChild) {
    document.body.removeChild(document.body.firstChild)
  }

  var app
  if (typeof runElmProgram !== "undefined") {
    app = runElmProgram()
  } else {
    app = Elm.Main.fullscreen()
  }

  // Connect trello client js to elm application
  app.ports.trelloCheckAuthorized.subscribe(function() {
    var isAuthorized = Trello.authorized()
    if (isAuthorized) {
      app.ports.trelloIsAuthorized.send(true)
    } else {
      app.ports.trelloIsNotAuthorized.send(true)
    }
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
        app.ports.trelloIsAuthorized.send(true)
      },
      error: function() {
        console.log("Error")
      }
    })
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
}
