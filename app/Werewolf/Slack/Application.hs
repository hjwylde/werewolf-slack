{-|
Module      : Werewolf.Slack.Application

Copyright   : (c) Henry J. Wylde, 2016
License     : BSD3
Maintainer  : public@hjwylde.com
-}

{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}

module Werewolf.Slack.Application (
    -- * Application
    runApplication,
) where

import Control.Concurrent
import Control.Monad.Extra
import Control.Monad.Reader

import qualified Data.ByteString.Char8      as BSC
import qualified Data.ByteString.Lazy.Char8 as BSLC
import           Data.Maybe

import Network.HTTP.Types       (status202, status400)
import Network.Wai              hiding (Response, requestBody, responseStatus)
import Network.Wai.Handler.Warp

import Werewolf.Slack.Options
import Werewolf.Slack.Werewolf

runApplication :: (MonadIO m, MonadReader Options m) => m ()
runApplication = do
    options <- ask

    liftIO $ run (optPort options) (application options)

application :: Options -> Application
application options request respond = maybe failure (\action -> forkIO (runReaderT action options) >> success) mAction
    where
        failure = respond $ responseLBS status400 [] "bad request"
        success = respond $ responseLBS status202 [] (BSLC.pack $ unwords [":wolf:", fromJust mUserCommand, ":moon:"])

        param name      = join . lookup name $ queryString request
        mUser           = BSC.unpack <$> param "user_name"
        mUserCommand    = BSC.unpack <$> param "text"
        mAction         = execute <$> mUser <*> mUserCommand
