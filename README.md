Elm application showing an overview of times for multiple trello boards.

# Description

Calculates the done and remaining times for a trello board depending on times added to each card. The time for a card is added in the card name, for example "My card (5)" for a card taking 5 time units. The application will pull selected boards from the trello api and calculate the number of done time units (detected from list name "`Done.*`") and remaining time units (detected from list name "`Version.*`" or configured regex).


# Getting started (development)

1. Install `asdf` and `asdf-nodejs`
2. Run `asdf install` to install the correct elm version
3. Run `npm run package -- install` to install all elm dependencies
4. Run `npm run reactor` to run local development server
5. Run tests with `npm run test` or `npm run test-watch`


# TODO

 - [ ] Remove authorization through trello.js, use elm code instead
