<p align="center">
  <img src="docs/assets/TinkerScriptsBadge.png" alt="Logo" width="300"/>
</p> 
<p align="center">
  A collection of all my Lua scripts for <a href="https://github.com/YimMenu/YimMenuV2">YimMenuV2</a> bundled together in a working submenu.
</p>

#

> [!IMPORTANT]
> TinkerScripts is officially available only in [this repository](https://github.com/lmagineNothing/TinkerScripts) and the following sites:
>
> - [Unknowncheats](https://www.unknowncheats.me/forum/grand-theft-auto-v/772902-tinkerscripts-yimmenuv2.html)
> - [Codeberg](https://codeberg.org/ImagineNothing/TinkerScripts)
>
> Downloading from other sources may result in getting an outdated version of this script or even malware. <br>
> (Always check that the file extension is **.lua** | see TinkerScripts structure below).

<div align="center">
  <H3>TinkerScripts is only compatible with Enhanced<H3>
  <img src="https://img.shields.io/badge/Online_Version_|_Game_Build-1.73_|_1158.16-black?style=for-the-badge&labelColor=darkgreen&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAAxCAYAAACGYsqsAAAACXBIWXMAAAsTAAALEwEAmpwYAAADnklEQVRogeWaOWgWQRTHfzlMSDREIioeWEnQLjYiCirxakRFLCwFCYpRSOF9YKIoHlgEj0LEIBaCGBC0kqgRLGPAxgstLAQhRkNi7sRnMeb7Pjffzs7uvt0U+cFCdufN/837ZrMz82YKRITpROFUNyBtinP+/gZUTEEb6oH7OfeXgAPKPvqARfB/wAuVnbji/ZGr8jxT85H7SvcrO3Fl2HM/kICPTGy5Ac9MwJELlZ77eQn4yMSW+0rvA2YAC4ANwKoEHE/wCGgD/gCvPWW3gBeAAKuBncDsCD4eA+3AGDCaeSoiftdW0adXRLZYfOa75ohIWwgfHSKy0k8vyNnGONHl4UaAP9v13UG/PUgnaBxuA45FeJ386IpRtzWgvBNYHyTiMvG4ArxxsHNhboy68wPKN7uIFIjb1LIa+OhiGMBPYDEwGLJeITCE+ajm4xRw0VXIhU/APUdbG1XAkQj19uAfbD+OwYJ7D4OZrfS6GlsYBmZhhgtXvgJLfMqOAlddhcIsHvqA5hD2fpQCJ0LY1+If7BhwPYzzMD0MUAL0AGVhKuVhBCgHxh1sXwFrfcqagYYwjsMuD0cwq5m4lABNDnbV+AcLcDm05wgTgCIR6Yk89cgyKiKlAb5aLPUfRmh7pATAOHAyQj0vxZjhxI8KzNfZj9ORvEb5lf5d3Qq9PCQiZT76jZZ6T6O2O07AOxQCFhFpyqNdJCIDljo1UdsdJ2BE5LNCwCMy+X+5zmLfEafNcZN4dTHrg5lBHfc8s43T5+I4CzsO56MTWBFTY4BsVqIWeO5j9wVYGseRRpq2XkGjnGym8qzF7kJcRxo9DPAM2BRT4z0m6Jc+5V0o5Lu0Al4OvNMQsnAYuBZXRCtggAfAbi0xD78xS8vRIMMgNLdaDilqebmJQrCgG/AP4Lai3gSCSTOpoPlKg1k29gFFipp3gb1aYtq7h4NEWbLZOa8ppt3DAAWYj0y5gtYTYJuCToYk9ocFaFTS0tLJkEQPT9CNGUqi8hao0WlKliRPAMQdpho0GuElyR4Ge3rVxgfM7E2dpM947I9Y74xqK3JIuofBLAqWhbBXWST4kcYpnrC97JK+jUwaPQxml3+Ng10vk49AqJLWOS3XJIHGVo6VtHoYzJmL7ZZywaR5wm6lhiLNk3gHA8rvkHCwkG4PA7Tgv5tQBfxKugFpB1yJ2X300grsSqMBaQcMJuc88RErwGQy1mFmZYkzFQFPKdPu+PBftpl6d/4iAOgAAAAASUVORK5CYII="/>
</div>
<br>


<details>
  <summary><B>How To Use</B></summary>
  
<div align="center"><details>
  <summary><B>Structure</B></summary>
<pre><code><div align="left">TinkerScripts.lua ← This is the main script.
📦 TinkerScripts/ ← This is the folder that contains the necessary files for the main script to work.
├─ 📄 Blips.lua
├─ 📂 HumanCanvas/
│  ├─ 📄 Exported_TattooCombo.txt ← Using "Export/Import Tattoos" will save to/load from this file.
│  └─ 📄 FMCharTats.lua
├─ 📂 Settings/
│  ├─ 📂 BlockCloudSaves/
│  │  ├─ 📄 BlockCloudSaves.bat ← See BlockCloudSaves
│  │  └─ 📄 NoSave.txt
│  └─ 📄 TS_Settings.lua
└─ 📂 TS_RecoveryPlus/
   ├─ 📄 Tunables.lua
   └─ 📄 Unlocks.lua</div></code></pre>
Tree generated with File Tree Extractor.
</details></div>

## Loading The Script
  1) Download TinkerScripts.zip from [Releases](https://github.com/lmagineNothing/TinkerScripts/releases/latest) and extract it.
  2) Place both TinkerScripts.lua and TinkerScripts (folder) into: `%AppData%/YimMenuV2/scripts`
  3) Open YimMenuV2, go to Settings → Lua Scripts and click TinkerScripts.lua.
  

## [Block Cloud Saves](docs/BlockCloudSaves.md)

</details>

<details>
  <summary><B>Categories & Features</B></summary>

#### Main
- General
    - Fast Respawn.
    - Fast Reload.
    - Infinite Combat Roll. (+ No Recoil/Spread)
    - Ragdoll on command.
    - Character abilities boost.
    - Force Cloud Save.
    - Teleport into Personal Vehicle.
    - Teleport into Closest Vehicle.
- Auto-Drive
    - Driving Style.
    - Auto-Drive to Waypoint.
    - Auto-Wander.

- Re-Name Editor
    - Rename your **Outfit** and **Businesses** with symbols and colors.

- Misc
    - Rapid Oxidation: Embrace **The Spirit Of Vengeance** and **The Phoenix**.
    - TinyPlayer: Become **Ant-Man**. <sub>(I guess?)</sub>
    - No Clip Animations and State On-Screen.
    - Hidden Locations: Teleport to Hidden/Random Locations.

#### Biz-Teroids
- Business on steroids! Resupply and Restock your businesses with a single click! (or choose your own options).
    - Instant Sell/Buy/Steal.
    - Trigger Excess Weapon Parts & Bar Earnings.

#### Phone Master
- Phone Animations.
- Remote Snapmatic.
- Contact Override: ONLY STRIPPERS AVAILABLE (Overrides Lester).
- SP Themes & Sound sets.
- Background & Color scheme.
- Celltowa Model.
- Phone Orientation & Position.

#### Gun Van Halen
- An actual Gun Van editor. (no more typing weapon ids).

#### Rainbow Vehicles
- Like the pony, but on wheels.

#### Recovery +
- A category with useful/convenient stats and _some_ **UNLOCKS** .
If you want to unlock **EVERYTHING**, check out this other script: [UnlockEverything](https://www.unknowncheats.me/forum/4743916-post792.html)

    - Safe Cracker: Heist Finale Options. <sub>*Only those that are NOT available in the menu, except the Kortz Center Heist (See screenshot below, I can't explain this part properly)</sub>
    - Extras:
        - Mission Skips. <sub>*Only those that can't be replayed through the Pause Menu</sub>
        - Misc:
            - Enable Heists Weekly Boost.
            - Criminal Mastermind Bonus. ($12M Bonus)
            - Casino Heist: P.O.I & Extras (Secure Keypad & Vault Door) Reset.
            - Crack Stash House Safe. <sub>Removed at some point but added it back since built-in one doesn't automatically open the safe</sub>
    - Loot Auto-Grab
    - Unlocks:
        - Content Unlocks: All Bunker, Collectibles, Tattoos, LSC Unlocks. <sub>(probably won't add more)</sub>
        - Character Stats: Fast Run, Frozen Rank, Max out stats.
    - Money:
        - Good Behaviour Bonus, Casino Membership Bonus.
        - Sindy Looper: MC Clubhouse Bag-Loop. <sub>THESE FEATURES SHOULD NOT BE CONSIDERED "SAFE". I haven't tested the limits.</sub>
    - Tunables: Enable Independence Day and Christmas content. <sub>(probably won't add more)</sub>
    - Human Canvas:
        - Stack, Import and Export Tattoos.
        - Stack Face Paints.
        - Hair Colors: Regular and Hidden Hair/Highlight Colors.

#### Settings +
- Save/Load submenu settings.
- Block Cloud Saves.

</details>

<details>
  <summary><B>Screenshots</B></summary>
  
<p align="center"><table>
    <tr>
      <td align="center"><img src="docs/assets/categories/Main.png" width="200"/><br><sub>Main</sub></td>
      <td align="center"><img src="docs/assets/categories/Biz-teroids.png" width="200"/><br><sub>Biz-teroids</sub></td>
      <td align="center"><img src="docs/assets/categories/PhoneMaster.png" width="200"/><br><sub>Phone Master</sub></td>
      <td align="center"><img src="docs/assets/categories/GunVanHalen.png" width="200"/><br><sub>Gun Van Halen</sub></td>
      <td align="center"><img src="docs/assets/categories/RainbowVehicles.png" width="200"/><br><sub>Rainbow Vehicles</sub></td>
    </tr>
    <tr>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-HumanCanvas.png" width="200"/><br><sub>Recovery + (HumanCanvas)</sub></td>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-SafeCracker.png" width="200"/><br><sub>Recovery + (Safe Cracker)</sub></td>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-Tunables.png" width="200"/><br><sub>Recovery + (Tunables)</sub></td>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-Money.png" width="200"/><br><sub>Recovery + (Money)</sub></td>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-Unlocks.png" width="200"/><br><sub>Recovery + (Unlocks)</sub></td>
    </tr>
    <tr>
      <td align="center"><img src="docs/assets/categories/SettingsPlus.png" width="200"/><br><sub>Settings +</sub></td>
    </tr>
  </table>
</p>

</details>

<details>
  <summary><B>Note</B></summary>
  
_<div align="center">This submenu shouldn't be considered an example of how things should be done.</div>_ <!-- No way this works lol -->

- The next update will probably be just organizing stuff. I feel more confident now, so it shouldn't be _THAT_ hard.
- Money tab and various unlocks weren't planned from the beginning; added them just because, but I don't consider them an essential part of this submenu.
- Added a few more features after taking the screenshots above.

Also, I've tested every single feature mentioned above, but you still may find the following issues (not necessarily because of the script, but because of how the game works):

- Game will freeze for a brief moment when TinkerScripts is selected after submenu loads for the first time in session (game session, not freemode) because of the Outfit Renamer.
- Phone Master: Works well but it breaks a bit when using the email app. Enabling Celltowa phone model breaks some services, e.g. Clothing Stores or the Gun Van; can be fixed by joining a new session. If phone gets stuck completely you'll have to restart the game (It has happened to me only once, and was just after latest patch 1158.16)
- Human Canvas: Stacked Face Paints are not persistent and will disappear after restarting the game.
- Open All Doors in Cayo Perico Heist won't enable loot in Compound. Use Solo Mantrap to be able to grab the loot.

</details>

## RESPECT THE CODE

I'm not a programmer. I even struggle with the basics, but I'm proud of what I've done so far.

<details>
  <summary><B>However</B></summary>

  I've felt discouraged since some skids have beem stealing my scripts. This has made me consider not releasing this submenu (good or bad) at all, but there is no turning back now that I've made this repo public...
  
  So, (for those "I'vE bEeN pRoGrAmMiNg fOr A dEcAdE" skids) I'll just say that moving things around, and adding your name to someone else's work to make people think you are the author is called plagiarism.
  
  Is it that hard to give proper credit and provide the source?

<div align="center"><sub><sub>You're not obfuscating anything by doing a simple operation on large numbers btw.</sub></sub></div>

</details>

If you have made changes to the original code or you are using it in your own menu (or YimMenuV2 fork) and you really want to **SHARE**, **don't discriminate**; keep it **open source** for **EVERYONE**.

Also, **stop feeding my mess to AI** .-.

# Contact
<a href="https://www.unknowncheats.me/forum/members/3627117.html">
      <img src="https://img.shields.io/badge/UnknownCheats_-ImagineNothing-black.svg?&style=flat-square&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADgAAABBCAYAAACEq2cXAAAACXBIWXMAAAsTAAALEwEAmpwYAAADF0lEQVRoge2asXXbMBCG/8tL4SKFRlA2YDaQJojUpTM9QeINlAnsTCCnchllAnkDaQOpTCd2Kf8UABPGFogDCIqkH7/3UEjCgfhMEjgeLSTxmnnT9QTaZhQcOqPg4CF5tjn6TkmuSa4jjpOT3JHMUs1R01SCFbEqKkkrdqjEnUgueiHoEFNJnhF7Tt6pIMm7mslV2ZKcVCYz9YgFS7YlGMKulCS5Coz1SrYlmMdI2rZLKdmKoB34kpKLNgRr90EReQBw47uEKmQAMhEpAMwB7ANjk+Pd6CMky7gC4ZLJUWUyCSSfQmNToU7VmkiKSGdnMigXtZKxFA1io3n1yfYoOHRGwaHztusJnIPkDMDMfiwAbAAcY8bqk+AVyRWAzwAmz367A3AP4CtCt5u6ZNvR38fMEbf1xP1WjL2jSeTTJNsX5krRJwOwxcsz7KRPgloyBEgOURAwkqqiV98EN9CvlgsoJPsm+A3ABxhRDTk8km0IXjeIfWcfr5YAHpQxOYAvrh/bEMx5vl46UcQ+ltuMiNxA/6DsHruFfbBkbfvPGF6AWtlYX/HqQFMYi6uqOQRPAROtm5yPLd0VugM9YmwgmDFMsgknmitgYqXUYmUTl4yI1EoiMKNoiACYIiLhjlpkRGQPUy0rAsKOAL5HHO6hEh9M9CoaIFkAuBWR9wib5AbA3K6m8biu3YD4untyzf/fPK0U992a5FQzR01rLOiQ3PLMm1yF4CfH+NEtyUZfuVyfACxFZG6/C+VXivlUcT7Rh55FmMr1PDK2yXFr6VuynZxRsOfM4HmvOGTBHCab2qJOsskSHNCmrP93lJKFcrz8WdzJHkO/DyZsmUKsSh4oR9aUE/soSNoM6MxYC77MmpxyZM3TRGIyhD99FDCJ9k/7+RrmvquyhycfvpQgYOR+4N87h6YUMAWqY12nS66iBcxf+z7hWEdfxy62iVsAS8S/s9/DnLm9pnNX++AGZpJPEXGqM/eXC6yimj3t4FlVD9TvkZ2sohoWAD7C1F5KjjCr6CZ20D4JtsKQc1EVo+DQGQWHzig4dP4AxG3fnntmC7gAAAAASUVORK5CYII="/>
</a><sup><a href="https://www.unknowncheats.me/forum/private.php?do=newpm&u=3627117">Direct Link to PM</a></sup>

`No, I don't use Discord.`

# Credits
- [Mystro69](https://github.com/Mystro69) | [Outfit Renamer](https://github.com/Mystro69/Outfit-Renamer-1.66)
- [ShinyWasabi](https://github.com/ShinyWasabi) | [scrDbg](https://github.com/ShinyWasabi/scrDbg)
- [xesdoog](https://github.com/xesdoog) | [YimRageUI](https://github.com/xesdoog/YimRageUI) - Helped me better understand how to interact with an UI/submenu.
- Stack Overflow | Code Snippets & Information <!-- A LOT -->