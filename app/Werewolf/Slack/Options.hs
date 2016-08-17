{-|
Module      : Werewolf.Slack.Options
Description : Optparse utilities.

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com

Optparse utilities.
-}

{-# LANGUAGE CPP #-}

module Werewolf.Slack.Options (
    -- * Options
    Options(..),

    -- * Optparse
    werewolfSlackPrefs, werewolfSlackInfo, werewolfSlack,
) where

#if MIN_VERSION_optparse_applicative(0,13,0)
import Data.Monoid
#endif
import Data.Version (showVersion)

import Network.Wai.Handler.Warp

import Options.Applicative

import qualified Werewolf.Slack.Version as This

data Options = Options
    { optDebug      :: Bool
    , optPort       :: Port
    , optToken      :: String
    , optWebhookUrl :: String
    } deriving (Eq, Show)

-- | The default preferences.
--   Limits the help output to 100 columns.
werewolfSlackPrefs :: ParserPrefs
#if MIN_VERSION_optparse_applicative(0,13,0)
werewolfSlackPrefs = prefs $ columns 100 <> showHelpOnEmpty
#else
werewolfSlackPrefs = prefs $ columns 100
#endif

-- | An optparse parser of a werewolf-slack command.
werewolfSlackInfo :: ParserInfo Options
werewolfSlackInfo = info (infoOptions <*> werewolfSlack) (fullDesc <> progDesc')
    where
        infoOptions = helper <*> version
        version     = infoOption ("Version " ++ showVersion This.version) $ mconcat
            [ long "version", short 'V', hidden
            , help "Show this binary's version"
            ]

        progDesc' = progDesc "Runs a simple web server that links the werewolf game engine and Slack integrations"

-- | An options parser.
werewolfSlack :: Parser Options
werewolfSlack = Options
    <$> switch (mconcat
        [ long "debug", short 'd'
        , help "Enable debug mode"
        ])
    <*> portOption (mconcat
        [ long "port", short 'p', metavar "NAT"
        , value 80, showDefault
        , help "Specify the port for the server to listen on"
        ])
    <*> strOption (mconcat
        [ long "token", short 't', metavar "TOKEN"
        , help "Specify the Slash Command token"
        ])
    <*> strOption (mconcat
        [ long "webhook-url", short 'u', metavar "URL"
        , help "Specify the Incoming Webhook URL"
        ])
    where
        portOption = option auto
