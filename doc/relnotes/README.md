# Official SilentDragon Release Notes

SilentDragon release notes were done on Github until 1.0.0
and now are officially part of our Gitea repo at https://git.hush.is/hush/silentdragon

## Downloading Releases

Hush releases are on our own Gitea at <a href="https://git.hush.is/">git.hush.is</a>
and no longer on Github, since they banned Duke Leto and
also because they censor many people around the world and work with
evil organizations.

# SilentDragon 1.3.0 "Berserk Bonnacon"

```
 60 files changed, 4328 insertions(+), 1568 deletions(-)
```

    * This release of SD is only compatible with hushd 3.9.0 or later, which is a mandatory update
        * Older Hush full nodes will not be compatible with the Hush network going forward
    * New shinier startup animation
    * SD now looks for Hush full node data in `~/.hush/HUSH3` but still supports the legacy location
    * New Polish translation (@onryo)
    * When right-clicking on a zaddr, there are now two new menu options
        * Shield all mining funds to this zaddr (z_shieldcoinbase)
            * Use this if you are a solo miner who mined full blocks to a taddr
            * Only 50 blocks will be shielded at a time. If you have more, run this multiple times.
        * Shield all non-mining taddr funds to this zaddr (z_mergetoaddress)
            * Use this if you have an old wallet with funds in taddrs
            * Only 50 utxos (transactions) will be shielded at a time. If you  have more, run this multiple times.
    * The About screen now reports the version of QT5 being used
    * In the case of an exception, the default currency will be set to BTC instead of USD
