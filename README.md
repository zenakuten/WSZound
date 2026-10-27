# WSZound

un-source stripped version of Zound 5.5 with some enhancements

- muted triggers stored client side
- unlimited muted triggers
- mute Zounds longer than X seconds


## Release notes

V5
- exponentially better performance
- fix an issue with the chat filter that would hang the server if there were empty entries
  - The last word of the filter list no longer requires a trailing comma
- fix partial match issue on faves/mutes
- fix admin color-coded trigger list

V4
- fix mutes not working
- move player mutes client side

V3
- fix how client settings file is created so it doesn't have package version

V2 
- fix bug clobbering custom end key bind
- disable max Zound slider based on checkbox
- store client config under a package independent ini section so settings survive version bumps

