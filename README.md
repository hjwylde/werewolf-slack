# werewolf-slack

[![Project Status: Wip - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.org/hjwylde/werewolf-slack.svg?branch=master)](https://travis-ci.org/hjwylde/werewolf-slack)
[![Release](https://img.shields.io/github/release/hjwylde/werewolf-slack.svg)](https://github.com/hjwylde/werewolf-slack/releases/latest)

A chat interface for playing [werewolf](https://github.com/hjwylde/werewolf) in
    [Slack](https://slack.com/).
The game engine is based off of the party game Mafia, also known as Werewolf.
See the [Wikipedia article](https://en.wikipedia.org/wiki/Mafia_(party_game)) for a rundown on it's
    gameplay and history.

### Game description

Long has the woods been home to wild creatures, both kind and cruel.
Most have faces and are known to the inhabitants of Fougères in Brittany, France; but no-one from
    the village has yet to lay eyes on the merciless Werewolf.

Each night Werewolves attack the village and devour the innocent.
For centuries no one knew how to fight this scourge, however recently a theory has taken ahold
    that
    maphaps the Werewolves walk among the Villagers themselves...

Objective of the Game:  
For the Loners: complete their own objective.  
For the Villagers: lynch all of the Werewolves.  
For the Werewolves: devour all of the Villagers.

### Setup

#### Preparing Slack

Set up an Incoming WebHook [here](https://my.slack.com/services/new/incoming-webhook/).
Make note of the *access token*, we'll be using that soon.

Set up a Slash Command (`/werewolf` or similar)
    [here](https://my.slack.com/services/new/slash-commands/).
The Slash Command should perform a GET request to the server werewolf-slack is going to be hosted
    on.
Make note of the *validation token* here too.

#### Installing

Installing werewolf-slack is easiest done using either
    [Docker](https://www.docker.com/) (recommended),
    [stack](https://github.com/commercialhaskell/stack) or
    [Cabal](https://github.com/haskell/cabal).

**Using Docker:**

```bash
docker pull hjwylde/werewolf-slack
```

**Using stack:**

```bash
stack install werewolf-slack werewolf
export PATH=$PATH:~/.local/bin
```

**Using Cabal:**

```bash
cabal-install werewolf-slack werewolf
export PATH=$PATH:~/.cabal/bin
```

#### Running

werewolf-slack is a simple web server that listens for events from the Slack Slash Command.
After receiving an event werewolf-slack forwards it on to the werewolf game engine and uses the
    Incoming WebHook to send back the response.

Running werewolf-slack is easiest done using either
    [Docker](https://www.docker.com/) (recommended) or
    the binary itself.
Make sure to add rules to your firewall for werewolf-slack's port.

**With Docker:**

```bash
docker run -d -p 80:8080 hjwylde/werewolf-slack -t ACCESS_TOKEN -v VALIDATION_TOKEN
```

**With werewolf-slack**

```bash
werewolf-slack -p 80 -t ACCESS_TOKEN -v VALIDATION_TOKEN &
```

#### Configuration

It is possible to also configure the channel to play werewolf in and the port that werewolf-slack
    listens on.
This is done via the `--channel-name` (`-c`) and `--port` (`-p`) options respectively.

By default the channel name is *werewolf* and port *8080*.

### Usage

Type `/werewolf help` in your Slack channel to get going!
