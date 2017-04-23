# Trello Overview Documentation

Trello Overview provides a simple dashboard showing statistics for Trello projects.
The overview is shown as a remaining percentage of time-units.

## Setting up a Trello Board 

Trello Overview requires a specific format for how the Trello Boards are setup.

### Setting up the cards

Each card needs to have a specified name in the format "Some Name (X)" where X is the number of time-units estimated for the particular card.
Time-units can be used for any type of estimation, for example estimated real days or story points.

### Setting up the lists

We'll us three types of lists in our Trello Boards

1. Not planned lists - containing cards that have not been planned
2. Planned lists - containing cards that have been planned to work on 
3. Done lists - lists containing cards that are completed

Planned lists can start with any type of prefix (a regular expression can be used to find the lists), with an unique perfix for each board.
Per default this category includes all lists starting with "Version".

Done lists are the lists that starts with "Done", currently this is non-configurable.
