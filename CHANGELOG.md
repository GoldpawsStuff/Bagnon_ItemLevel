# Bagnon_ItemLevel Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.0.55-Release] 2022-07-21
- Add support for WotLK Classic beta.

## [1.0.54-Release] 2022-07-09
- Bump for Classic Era client patch 1.14.3.

## [1.0.53-Release] 2022-06-14
### Changed
- Remove unused upvalues.

## [1.0.52-Release] 2022-05-31
- Bump toc to WoW client patch 9.2.5.

## [1.0.51-Release] 2022-05-30
### Fixed
- Fixed wrong upvalue for coloring.

## [1.0.50-Release] 2022-05-30
### Changed
- More code tweaks and performance upgrades.

## [1.0.49-Release] 2022-05-11
### Changed
- Minor code tweaks.

## [1.0.48-Release] 2022-04-07
- Bump for BCC client patch 2.5.4.

## [1.0.47-Release] 2022-02-23
- ToC bump.

## [1.0.46-Release] 2022-02-16
- ToC bumps and license update.

## [1.0.45-Release] 2021-12-12
### Added
- Added commands to toggle between rarity colored text, and a much clearer white.

### Changed
- Added a message when the presence of the addon Bagnon ItemInfo causes this one to be auto-disabled.

## [1.0.44-Release] 2021-11-17
- Bump Classic Era toc to client patch 1.14.1.

## [1.0.43-Release] 2021-11-03
- Bump Retail toc to client patch 9.1.5.

## [1.0.42-Release] 2021-10-18
- Bump Classic Era toc to client patch 1.14.

## [1.0.41-Release] 2021-09-28
### Changed
- Update auto-disable logic.

## [1.0.40-Release] 2021-09-01
- Bump TOC for BCC 2.5.2.

## [1.0.39-Release] 2021-07-11
### Changed
- Reverting scanning order for item level to use the retrieved tooltip value first, as the API return value sometimes will be wrong for lower level items from leveling characters.

## [1.0.38-Release] 2021-06-29
- Bump toc for 9.1.0.

## [1.0.37-Release] 2021-06-10
### Changed
- Updated to work for the BC and Classic versions of Bagnon!

## [1.0.36-Release] 2021-04-29
### Changed
- Optimized code and efficiency.
- Removed some unused function calls.

## [1.0.35-Release] 2021-04-05
- Spring cleaning.

## [1.0.34-Release] 2021-03-10
- Bump to WoW client patch 9.0.5.

## [1.0.33-Release] 2020-11-18
- Bump to WoW Client patch 9.0.1.

## [1.0.32-Release] 2020-10-16
- Bump to WoW Client patch 9.0.1.

## [1.0.31-Release] 2020-09-25
- Cache fixes and Bagnon 9.x compatibility.

## [1.0.30-Release] 2020-08-07
### Changed
- ToC updates.

### Fixed
- Properly disable when Bagnon_ItemInfo is loaded.

## [1.0.29-Release] 2020-01-09
### Fixed
- Fixed for Bagnon 8.2.27, December 26th 2019.

## [1.0.28-Release] 2019-10-08
- ToC updates.

## [1.0.27-Release] 2019-10-08
- Fix toc links.

## [1.0.26-Release] 2019-10-08
- Bump to WoW Client patch 8.2.5.

## [1.0.25-Release] 2019-07-02
### Changed
- Updated for 8.2.0.

## [1.0.24-Release] 2019-04-29
### Fixed
- Changed how bag slot count is captured to be compatible with deDE.

## [1.0.23-Release] 2019-03-29
### Changed
- Updated addon detection to avoid messing with the addon loading order.
- Updated toc display name to be in line with the main bagnon addon.
- Updated description links and team name.

## [1.0.22-Release] 2019-02-27
### Fixed
- Item background scanning should once more update properly when you swap items in a bag slot, and not show the item level of the item that was previously there.

## [1.0.21-Release] 2019-02-27
### Changed
- Update TOC metadata.
- Update README description and links.
- Major code overhaul and optimization.
- Added auto-disable if Bagnon ItemInfo is loaded.

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
