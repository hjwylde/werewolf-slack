{-|
Module      : Werewolf.Slack.Options
Description : Optparse utilities.

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com

Optparse utilities.
-}

module Werewolf.Slack.Options (
    -- * Options
    Options(..),

    -- * Optparse
    werewolfSlackPrefs, werewolfSlackInfo, werewolfSlack,
) where

import Data.Version (showVersion)

import Network.Wai.Handler.Warp

import Options.Applicative

import qualified Werewolf.Slack.Version as This

data Options = Options
    { optAccessToken :: String
    , optChannelName :: String
    , optPort        :: Port
    } deriving (Eq, Show)

-- | The default preferences.
--   Limits the help output to 100 columns.
werewolfSlackPrefs :: ParserPrefs
werewolfSlackPrefs = prefs $ columns 100

-- | An optparse parser of a werewolf-slack command.
werewolfSlackInfo :: ParserInfo Options
werewolfSlackInfo = info (infoOptions <*> werewolfSlack) (fullDesc <> header' <> progDesc')
    where
        infoOptions = helper <*> version
        version     = infoOption ("Version " ++ showVersion This.version) $ mconcat
            [ long "version", short 'V', hidden
            , help "Show this binary's version"
            ]

        header'     = header "A Slack chat client for playing werewolf."
        progDesc'   = progDesc $ unwords
            [ "The game engine is based off of the party game Mafia, also known as Werewolf."
            , "See https://github.com/hjwylde/werewolf-slack for help on running the chat client."
            ]

-- | An options parser.
werewolfSlack :: Parser Options
werewolfSlack = Options
    <$> strOption (mconcat
        [ long "access-token", short 't', metavar "TOKEN"
        , help "Specify the Slack access token"
        ])
    <*> strOption (mconcat
        [ long "channel-name", short 'c', metavar "CHANNEL"
        , value "werewolf", showDefault
        , help "Specify the channel name"
        ])
    <*> portOption (mconcat
        [ long "port", short 'p', metavar "NAT"
        , value 8080, showDefault
        , help "Specify the port for the server to listen on"
        ])
    where
        portOption = option auto
