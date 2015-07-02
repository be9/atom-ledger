# ledger package

This is a [ledger](http://ledger-cli.org) syntax and autocompletion package,
based on [original TextMate bundle](https://github.com/lifepillar/Ledger.tmbundle).

## Autocompletion

Autocompletion is based on [autocomplete-plus](https://github.com/atom/autocomplete-plus)
package which is included with Atom distribution since 1.0.0. It allows to autocomplete
account names.

First, it scans current file and determines account names used in it.
Second, it loads an `accounts.txt` file from the same directory as your ledger file
and considers accounts names from it as well. This option is useful if you have a bunch of
ledger files, but want to autocomplete from all of them.
(You can use `ledger accounts > accounts.txt` command to obtain this file).
