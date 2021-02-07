{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_hs (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/dincio/config/utils/hs/stack-proj/.stack-work/install/x86_64-linux-tinfo6/cb066928cea1024cb044773791943b6a3618a7e376b702bc10b7ea20e1d88bf9/8.8.4/bin"
libdir     = "/home/dincio/config/utils/hs/stack-proj/.stack-work/install/x86_64-linux-tinfo6/cb066928cea1024cb044773791943b6a3618a7e376b702bc10b7ea20e1d88bf9/8.8.4/lib/x86_64-linux-ghc-8.8.4/hs-0.1.0.0-5Ju2JDDYM5RGpDbOpglq8K-hs-exe"
dynlibdir  = "/home/dincio/config/utils/hs/stack-proj/.stack-work/install/x86_64-linux-tinfo6/cb066928cea1024cb044773791943b6a3618a7e376b702bc10b7ea20e1d88bf9/8.8.4/lib/x86_64-linux-ghc-8.8.4"
datadir    = "/home/dincio/config/utils/hs/stack-proj/.stack-work/install/x86_64-linux-tinfo6/cb066928cea1024cb044773791943b6a3618a7e376b702bc10b7ea20e1d88bf9/8.8.4/share/x86_64-linux-ghc-8.8.4/hs-0.1.0.0"
libexecdir = "/home/dincio/config/utils/hs/stack-proj/.stack-work/install/x86_64-linux-tinfo6/cb066928cea1024cb044773791943b6a3618a7e376b702bc10b7ea20e1d88bf9/8.8.4/libexec/x86_64-linux-ghc-8.8.4/hs-0.1.0.0"
sysconfdir = "/home/dincio/config/utils/hs/stack-proj/.stack-work/install/x86_64-linux-tinfo6/cb066928cea1024cb044773791943b6a3618a7e376b702bc10b7ea20e1d88bf9/8.8.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "hs_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "hs_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "hs_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "hs_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "hs_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "hs_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
