Elm application showing an overview of times for multiple trello boards.

# Description

Calculates the done and remaining times for a trello board depending on times added to each card. The time for a card is added in the card name, for example "My card (5)" for a card taking 5 time units. The application will pull selected boards from the trello api and calculate the number of done time units (detected from list name "`Done.*`") and remaining time units (detected from list name "`Version.*`" or configured regex).


# Getting started (development)

1. Install `node` and `yarn`
2. Run `yarn` to install elm
3. Run `yarn elm-package install` to install all elm dependencies
4. Run `yarn elm-reactor` to run local development server
5. Run tests with `yarn elm-test -- --watch`


# TODO

 - [ ] Remove authorization through trello.js, use elm code instead
 - [ ] Minimize the number of api-calls, get all lists and cards at the same time
 - [ ] Add documentation inside the application
 - [ ] Add github link in the application
