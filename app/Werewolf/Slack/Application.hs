{-|
Module      : Werewolf.Slack.Application

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com
-}

{-# LANGUAGE OverloadedStrings #-}

module Werewolf.Slack.Application (
    -- * Application
    runApplication,
) where

import Control.Concurrent
import Control.Monad.Extra

import qualified Data.ByteString.Char8      as BSC
import qualified Data.ByteString.Lazy.Char8 as BSLC
import           Data.Maybe

import Network.HTTP.Types       (status202, status400)
import Network.Wai              hiding (Response, requestBody, responseStatus)
import Network.Wai.Handler.Warp

import Werewolf.Slack.Werewolf

runApplication :: [String] -> IO ()
runApplication args = run port (application args)
    where
        port = 8080

application :: [String] -> Application
application args request respond = maybe failure (\action -> forkIO action >> success) mAction
    where
        failure = respond $ responseLBS status400 [] "bad request"
        success = respond $ responseLBS status202 [] (BSLC.pack $ fromJust mUserCommand)

        param name      = join . lookup name $ queryString request
        accessToken     = head args
        mUser           = BSC.unpack <$> param "user_name"
        mUserCommand    = BSC.unpack <$> param "text"
        mAction         = executeUserCommand accessToken <$> mUser <*> mUserCommand
