# Bagnon_ItemLevel Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [2.0.100-Release] 2025-06-18
- Updated for Retail client patch 11.1.7.
- Updated for Classic Era client patch 1.15.7.

## [2.0.99-Release] 2025-04-02
### Fixed
- I might have missed a line in the previous update, and nobody told me. 

## [2.0.98-Release] 2025-03-08
- Updated for WoW Classic Era Client Patch 1.15.6.
- Updated for WoW Retail Client Patch 11.1.0.

## [2.0.97-Release] 2024-09-02
### Fixed
- Fixed a bug related to using the deprecated library LibItemCache-2.0.

## [2.0.96-Release] 2024-08-18
- Updated for WoW Retail Client Patch 11.0.2.

## [2.0.95-Release] 2024-07-10
- Updated for WoW Classic Client Patch 1.15.3.

## [2.0.94-Release] 2024-06-22
- Updated for WoW Retail Client Patch 10.2.7.

## [2.0.93-Release] 2024-04-25
### Fixed
- Fixed a non-breaking typo in the code that compared a non-existing global instead of a local value to a string.

## [2.0.92-Release] 2024-04-17
### Changed
- Only item levels above 1 will now be shown, removing a lot of low level and vanity item spam. To adjust this value, install Bagnon Itemlevel Plus instead.

## [2.0.91-Release] 2024-04-03
- Updated for WoW Client Patch 1.15.2.

## [2.0.90-Release] 2024-03-26
### Changed
- Uncommon rarity coloring should be a bit brighter and easier to spot now.

### Fixed
- The issue in retail where all items would get their itemlevel displayed has been fixed. We're bag to mostly showing equipable gear, battle pets and container slots again.

## [2.0.89-Release] 2024-03-22
- Updated for WoW Client Patch 10.2.6.
- Updated for WoW Client Patch 4.4.0.

## [2.0.88-Release] 2024-02-07
- Updated for WoW Client Patch 1.15.1.

## [2.0.87-Release] 2024-01-17
- Updated for WoW Client Patch 10.2.5.

## [2.0.86-Release] 2024-01-13
### Fixed
- Fixed an issue that caused a bunch of bugs on logon, especially in Wrath and Classic.

## [2.0.85-Release] 2023-11-17
- Updated for WoW Client Patch 1.15.0.

## [2.0.84-Release] 2023-11-07
- Updated for WoW Client Patch 10.2.0.

## [2.0.83-Release] 2023-11-01
### Changed
- Some minor performance tweaks. Everything matters!

## [2.0.82-Release] 2023-10-22
### Fixed
- Fixed faulty embeds that may or may not have caused a startup error.

## [2.0.81-Release] 2023-10-11
- Updated for WoW Client Patch 3.4.3.

## [2.0.80-Release] 2023-09-19
- Added TaintLess.xml.

## [2.0.79-Release] 2023-09-06
- Updated for Retail client patch 10.1.7.

## [2.0.78-Release] 2023-08-24
- Updated for Classic client patch 1.14.4.

## [2.0.77-Release] 2023-07-25
### Fixed
- Fixed issues occurring with item caches resulting in missing item levels with Bagnon 10.1.3 and higher.

## [2.0.76-Release] 2023-07-22
### Changed
- Updated addon listing icon and text format.

## [2.0.75-Release] 2023-07-12
- Bumped to Retail Client Patch 10.1.5.

## [2.0.74-Release] 2023-06-21
- Bumped to Wrath Classic Client Patch 3.4.2.

## [2.0.73-Release] 2023-06-07
### Removed
- Removed the annoying startup message when loaded alongside Bagnon ItemInfo.

## [2.0.72-Release] 2023-05-21
- Cosmetic stuff. Piggybacking.

## [2.0.71-Release] 2023-05-10
- Updated for Bagnon's API for WoW 10.1.0.

## [2.0.70-Release] 2023-05-03
- Updated for WoW 10.1.0.

## [2.0.69-Release] 2023-03-25
- Updated for WoW 10.0.7.

## [2.0.68-Release] 2023-02-28
### Changed
- Added fallback colors.

## [2.0.67-Release] 2023-01-26
- Updated for WoW 10.0.5.

## [2.0.66-Release] 2023-01-18
- Updated for WoW 3.4.1.

## [2.0.65-Release] 2022-12-11
### Fixed
- Changed how bagID is queried to be more consistent across Bagnon updates and versions. A lot of C_Tooltip API errors and general Bagnon lag should be fixed by this.

## [2.0.64-Release] 2022-12-08
### Fixed
- Fixed an issue in retail with items that had less tooltipData than expected.

## [2.0.63-Release] 2022-11-25
### Changed
- Now only uses the old tooltip scanning in the classic versions of WoW.
- Now utilizes the C_TooltipInfo and TooltipUtil APIs in retail. Which will rock when Bagnon is updated for 10.0.2!

## [2.0.62-Release] 2022-11-16
- Bump to retail client patch 10.0.2.

## [2.0.61-Release] 2022-10-25
- Bumped retail version to the 10.0.0 patch.

## [2.0.60-Release] 2022-10-13
### Fixed
- Fixed an issue where the wrong bag slot would be queried, resulting in wrong information on the items.

## [2.0.59-Release] 2022-10-12
### Fixed
- Itemlevels are now once more only shown for actual gear.

## [2.0.58-RC] 2022-10-12
- Full performance rewrite to take much better advantage of Bagnon and Wildpant's APIs.

## [1.0.56-Release] 2022-08-17
- Bump to client patch 9.2.7.

## [1.0.55-Release] 2022-07-21
- Add support for Wrath Classic.

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
