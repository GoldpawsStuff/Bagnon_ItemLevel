# Bagnon_ItemLevel Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.0.20-Release] 2019-01-15
### Changed
- Updated TOC & links. 

## [1.0.19] 2018-12-15
### Changed
- Updated TOC version to patch 8.1.0.

## [1.0.18] 2018-09-09
### Removed
- Removed redundant checks for Crucible additions to Legion artifacts. We neither need them nor use them anymore, as item levels are all retrieved from a hidden scanner tooltip. 

## [1.0.17] 2018-08-14
### Changed
- Code optimization. 

### Removed
- Removed deprecated backwards compatibility. Use older versions for that if needed.

## [1.0.16] 2018-08-06
### Changed
- Updated TOC version to 8.0.1. 

## [1.0.15] 2018-06-05
### Changed
- Updated readme with new BitBucket links. We're leaving GitHub. 

## [1.0.14] 2018-02-19
### Added
- Bags no longer have their rather useless item level displayed, but will instead show their number of slots!

## [1.0.13] 2018-02-12
### Fixed
- Fixed a typo that sometimes would cause unpredictable results on items like offhand mud snappers and other obscure "weapons". 

## [1.0.12] 2018-02-08
### Changed
- Changed to pure tooltip scanning for all item levels, to avoid problems with heirlooms being identified as having a higher item level than their maximum level would allow. 

## [1.0.11] 2018-01-29
### Added
- Now also shows the level of caged Battle Pets in your bags.

## [1.0.10] 2018-01-20
### Changed
- The item level of Common (white) quality items like starter zone vendor gear and beginner Fishing Poles are now also displayed.

## [1.0.9] 2017-12-21
### Fixed
- Changed how artifacts and relics are scanned in WoW patch 7.3.0. Finally shows the upgraded crucible item levels! 

## [1.0.8] 2017-09-14
### Changed
- Slight code optimization, even less existence checks.

## [1.0.7] 2017-09-07
### Changed
- Optimized the code, reduced number of existence checks.

## [1.0.6] 2017-09-05
### Changed
- Moved the upgrade arrow used by Pawn yet again, to make it compatible with both this and the Bagnon_BoE addon.
- Changed the item level fontstring to use a common frame for all my bagnon plugins as a parent, to reduce number of extra frames.

## [1.0.5] 2017-09-04
### Changed
- Moved the upgrade arrow used by Pawn farther down so it wouldn't collide with the item level display.

## [1.0.4] 2017-09-03
### Changed
- Now does an extra check to get the effective item level for upgraded items.

## [1.0.3] 2017-08-29
### Changed
- Bumped the toc version to patch 7.3.0.

## [1.0.2] 2017-08-16
### Fixed
- Fixed the nil bug that prevented the addon from working. Thanks for fixing my "too little sleep" bugs, Kkhtnx! :) 

## [1.0.1] 2017-08-16
- Initial commit.
