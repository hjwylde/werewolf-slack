# werewolf-slack

[![Project Status: Wip - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.org/hjwylde/werewolf-slack.svg?branch=master)](https://travis-ci.org/hjwylde/werewolf-slack)
[![Release](https://img.shields.io/github/release/hjwylde/werewolf-slack.svg)](https://github.com/hjwylde/werewolf-slack/releases/latest)

A Slack chat client for playing [werewolf](https://github.com/hjwylde/werewolf).
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

### Installing

Installing werewolf-slack is easiest done using either
    [stack](https://github.com/commercialhaskell/stack) (recommended) or
    [Cabal](https://github.com/haskell/cabal).

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

### Usage

#### Commands

See `/werewolf help`.
