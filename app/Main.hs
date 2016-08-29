{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.Process (readProcessWithExitCode)
import System.Exit (exitWith, ExitCode(ExitFailure), ExitCode(ExitSuccess))
import Options.Applicative
import Data.Maybe (fromMaybe)
import Data.String (IsString)

data Command = Command {
                         file     :: Maybe String
                       , exclude  :: Maybe [String]
                       , options  :: Maybe String
                       , append   :: Bool
                       , filepath :: String
                       }
    deriving (Show)

args :: Parser Command
args = Command
  <$> optional (option str (long "file" <> short 'f' <> help "File to write to" <> metavar "F"))
  <*> optional (some (option str (long "exclude" <> help "Files to exclude" <> metavar "E")))
  <*> optional (option str (long "options" <> help "Files to exclude" <> metavar "O"))
  <*> switch (long "append" <> help "append to existing CTAGS and/or ETAGS file(s).")
  <*> argument str (metavar "FILEPATH")

main :: IO ()
main = do
  args' <- execParser optionswithInfo
  (code,stdo,stde) <- readProcessWithExitCode "hasktags" (buildArgList args') ""
  case code of
    ExitFailure c -> do
      putStr stde
      exitWith $ ExitFailure c
    ExitSuccess -> putStr stdo
  return ()
  where
    optionswithInfo =
      info
        (helper <*> args)
        (fullDesc <> progDesc "Wrapper around hasktags to swallow extra args" <>
         header "Hasktags wrapper")
    buildArgList :: Command -> [String]
    buildArgList cmd = filter (not .null) ["-c", "-f", fromMaybe "tags" (file cmd), shouldAppend cmd, filepath cmd]

    shouldAppend :: IsString a => Command -> a
    shouldAppend cmd = if append cmd then "--append" else ""
