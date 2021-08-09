# SilentDragon

<p align="left">
    <a href="https://twitter.com/MyHushTeam">
        <img src="https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fmyhushteam"
            alt="MyHushTeam's Twitter"></a>
    <a href="https://twitter.com/intent/follow?screen_name=MyHushTeam">
        <img src="https://img.shields.io/twitter/follow/MyHushTeam?style=social&logo=twitter"
            alt="follow on Twitter"></a>
    <a href="https://fosstodon.org/@myhushteam">
        <img src="https://img.shields.io/badge/Mastodon-MyHushTeam-blue"
            alt="follow on Mastodon"></a>
    <a href="https://www.reddit.com/r/Myhush/">
        <img src="https://img.shields.io/reddit/subreddit-subscribers/Myhush?style=social"
            alt="MyHushTeam's Reddit"></a>
</p>

SilentDragon desktop wallet for HUSH runs on Linux, Windows and macOS.
This is experimental software under active development!

![Screenshots](images/sd-receive-tab.png?raw=true)

The following are screenshots for each SilentDragon tab:
* [Main Window](images/sd-main-window.png)
* [Send Tab](images/sd-send-tab.png)
* [Transactions Tab](images/sd-transactions-tab.png)
* [Peers Tab](images/sd-peers-tab.png)
* [Market Tab](images/sd-market-tab.png)
* [Hushd Tab](images/sd-hushd-tab.png)

## PRIVACY NOTICE

SilentDragon contacts a few different external websites to get various
bits of data.

    * coingecko.com for price data API
    * explorer.hush.is for explorer links
    * dexstats.info for address utilities
    * wormhole.hush.is for Wormhole services

This means your IP address is known to these servers. Enable Tor setting
in SilentDragon to prevent this, or better yet, use TAILS: https://tails.boum.org/

# Installation

Go to the [releases page](https://git.hush.is/hush/SilentDragon/releases) and grab the latest installers or binary.
For Arch Linux users, this is available from the AUR.

## hushd

SilentDragon needs a Hush full node running [hushd](https://git.hush.is/hush/hush3/). If you already have a hushd node running, SilentDragon will connect to it.

If you don't have one, SilentDragon will start its embedded hushd node.

Additionally, if this is the first time you're running SilentDragon or a hushd daemon, SilentDragon will find Sapling params (~50 MB) and configure `HUSH3.conf` for you. 

Pass `--no-embedded` to disable the embedded hushd and force SilentDragon to connect to an external node.

## Compiling from source

SilentDragon is written in C++ 14, and can be compiled with g++/clang++/visual
c++. It also depends on Qt5, which you can get from [here](https://www.qt.io/download)
or within your operating system package manager. Note that if you are compiling
from source, you won't get the embedded hushd by default. You can either run an external
hushd, or compile hushd as well.

### Building on Linux

#### Linux Troubleshooting
If you run into an error with OpenGL, you may need to install extra deps. More details [here](https://gist.github.com/shamiul94/a632f7ab94cf389e08efd7174335df1c)

**Error**
```
/usr/bin/ld: cannot find -lGL
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```
**Solution**
```
sudo apt-get -y install libglu1-mesa-dev freeglut3-dev mesa-common-dev
```

#### Ubuntu 18.04 and 20.04

You can install the pre-reqs and build on Ubuntu 18.04 & 20.04 with:

```shell script
sudo apt-get -y install qt5-default qt5-qmake libqt5websockets5-dev qtcreator
git clone https://git.hush.is/hush/SilentDragon
cd SilentDragon
./build.sh linguist # compile translations
./build.sh
./silentdragon
```

#### Arch Linux

You can install the pre-reqs and build on Arch Linux with:

```shell script
sudo pacman -S qt5-base qt5-tools qtcreator qt5-websockets rust
git clone https://git.hush.is/hush/SilentDragon
cd SilentDragon
./build.sh linguist # compile translations
./build.sh release
./silentdragon
```

### Building on Windows
You need Visual Studio 2017 (The free C++ Community Edition works just fine).

From the VS Tools command prompt
```shell script
git clone  https://git.hush.is/hush/SilentDragon
cd SilentDragon
c:\Qt5\bin\qmake.exe silentdragon.pro -spec win32-msvc CONFIG+=debug
nmake

debug\SilentDragon.exe
```

To create the Visual Studio project files so you can compile and run from Visual Studio:
```shell script
c:\Qt5\bin\qmake.exe silentdragon.pro -tp vc CONFIG+=debug
```

### Building on macOS

You need to install the Xcode app or the Xcode command line tools first, and then install Qt. 

TODO: Suggestions on installing qt5 deps on a Mac

```shell script
git clone https://git.hush.is/hush/SilentDragon
cd SilentDragon
# These commands require qmake to be installed
./build.sh linguist
./build.sh
make

./SilentDragon.app/Contents/MacOS/SilentDragon
```

### Emulating the embedded node

In binary releases, SilentDragon will use node binaries in the current directory to sync a node from scratch.
It does not attempt to download them, it bundles them. To simulate this from a developer setup, you can symlink
these four files in your Git repo:

```shell script
ln -s ../hush3/src/hushd
ln -s ../hush3/src/komodod
ln -s ../hush3/src/komodo-cli
```

The above assumes silentdragon and hush3 git repos are in the same directory. File names on Windows will need to be tweaked.

### Support

For support or other questions, join us on [Telegram](https://hush.is/telegram), or tweet at [@MyHushTeam](https://twitter.com/MyHushTeam), or toot at our [Mastodon](https://fosstodon.org/@myhushteam) or join [Telegram Support](https://hush.is/telegram_support) or [file an issue](https://git.hush.is/hush/SilentDragon/issues).

