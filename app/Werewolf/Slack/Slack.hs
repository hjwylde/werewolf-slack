{-|
Module      : Werewolf.Slack.Slack

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com
-}

{-# LANGUAGE OverloadedStrings #-}

module Werewolf.Slack.Slack (
    -- * Slack
    notify,
) where

import Control.Monad

import           Data.Aeson
import qualified Data.Text  as T

import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Method

url :: String -> String
url accessToken = "https://hooks.slack.com/services/" ++ accessToken

notify :: String -> String -> String -> IO ()
notify accessToken to message = do
    manager <- newManager tlsManagerSettings

    initialRequest  <- parseUrl $ url accessToken
    let request     = initialRequest { method = methodPost, requestBody = body }

    void $ httpLbs request manager
    where
        body    = RequestBodyLBS $ encode payload
        payload = object
            [ "channel" .= to
            , "text" .= message
            , "icon_emoji" .= T.unpack ":wolf:"
            ]
