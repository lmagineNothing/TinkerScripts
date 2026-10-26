<picture>
<p align="center">
  <img src="docs/assets/TinkerScriptsBadge.png" alt="Logo" width="300"/>
</p> 
</picture>
<p align="center">
  A collection of all my Lua scripts for <a href="https://github.com/YimMenu/YimMenuV2">YimMenuV2</a> bundled together in a working submenu.
</p>

#

> [!IMPORTANT]
> TinkerScripts is officially available only in [this repository](https://github.com/lmagineNothing/TinkerScripts) and the following sites:
>
> - [UnknownCheats](https://www.unknowncheats.me/forum/grand-theft-auto-v/772902-tinkerscripts-yimmenuv2.html)
> - [Codeberg](https://codeberg.org/ImagineNothing/TinkerScripts)
>
> Downloading from other sources may result in getting an outdated version of this script or even malware. <br>
> Always check that the file extension is **.lua** (see TinkerScripts structure below).
>
> Also, if you have been using the standalone versions of **Biz-Teroids** and **Safe Cracker**, make sure to remove them from your scripts folder or TinkerScripts won't load!

> [!CAUTION]
> If you paid for this, you got scammed.

<picture>
<p align="center">
  <img src="docs/assets/TinkerscriptsCover.png" alt="Logo" width="500"/>
</p> 
</picture>

<div align="center">

  <H3>TinkerScripts is only compatible with Enhanced<H3>
  
  <picture>
   <img src="https://img.shields.io/badge/Online_Version_|_Game_Build-1.73_|_1158.16-black?style=for-the-badge&labelColor=darkgreen&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAAxCAYAAACGYsqsAAAACXBIWXMAAAsTAAALEwEAmpwYAAADnklEQVRogeWaOWgWQRTHfzlMSDREIioeWEnQLjYiCirxakRFLCwFCYpRSOF9YKIoHlgEj0LEIBaCGBC0kqgRLGPAxgstLAQhRkNi7sRnMeb7Pjffzs7uvt0U+cFCdufN/837ZrMz82YKRITpROFUNyBtinP+/gZUTEEb6oH7OfeXgAPKPvqARfB/wAuVnbji/ZGr8jxT85H7SvcrO3Fl2HM/kICPTGy5Ac9MwJELlZ77eQn4yMSW+0rvA2YAC4ANwKoEHE/wCGgD/gCvPWW3gBeAAKuBncDsCD4eA+3AGDCaeSoiftdW0adXRLZYfOa75ohIWwgfHSKy0k8vyNnGONHl4UaAP9v13UG/PUgnaBxuA45FeJ386IpRtzWgvBNYHyTiMvG4ArxxsHNhboy68wPKN7uIFIjb1LIa+OhiGMBPYDEwGLJeITCE+ajm4xRw0VXIhU/APUdbG1XAkQj19uAfbD+OwYJ7D4OZrfS6GlsYBmZhhgtXvgJLfMqOAlddhcIsHvqA5hD2fpQCJ0LY1+If7BhwPYzzMD0MUAL0AGVhKuVhBCgHxh1sXwFrfcqagYYwjsMuD0cwq5m4lABNDnbV+AcLcDm05wgTgCIR6Yk89cgyKiKlAb5aLPUfRmh7pATAOHAyQj0vxZjhxI8KzNfZj9ORvEb5lf5d3Qq9PCQiZT76jZZ6T6O2O07AOxQCFhFpyqNdJCIDljo1UdsdJ2BE5LNCwCMy+X+5zmLfEafNcZN4dTHrg5lBHfc8s43T5+I4CzsO56MTWBFTY4BsVqIWeO5j9wVYGseRRpq2XkGjnGym8qzF7kJcRxo9DPAM2BRT4z0m6Jc+5V0o5Lu0Al4OvNMQsnAYuBZXRCtggAfAbi0xD78xS8vRIMMgNLdaDilqebmJQrCgG/AP4Lai3gSCSTOpoPlKg1k29gFFipp3gb1aYtq7h4NEWbLZOa8ppt3DAAWYj0y5gtYTYJuCToYk9ocFaFTS0tLJkEQPT9CNGUqi8hao0WlKliRPAMQdpho0GuElyR4Ge3rVxgfM7E2dpM947I9Y74xqK3JIuofBLAqWhbBXWST4kcYpnrC97JK+jUwaPQxml3+Ng10vk49AqJLWOS3XJIHGVo6VtHoYzJmL7ZZywaR5wm6lhiLNk3gHA8rvkHCwkG4PA7Tgv5tQBfxKugFpB1yJ2X300grsSqMBaQcMJuc88RErwGQy1mFmZYkzFQFPKdPu+PBftpl6d/4iAOgAAAAASUVORK5CYII="/>
  </picture>
  <br> <!-- &emsp; -->
  <a href="https://github.com/lmagineNothing/TinkerScripts/releases/latest">
    <img src="https://img.shields.io/badge/TinkerScripts Version-1.0.2-black?style=for-the-badge&labelColor=01498e&logo=data:image/png;base64,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"/>
  </a>

</div>
<br>


<details>
  <summary><B>How To Use</B></summary>

> Starting from v1.0.1, TinkerScripts.lua is inside TinkerScripts (folder). If you have been using the previous version, please remove it completely from your scripts folder.<br>
> Make sure you're using the latest version of YimMenuV2! 

<div align="center"><details>
  <summary><B>Structure</B></summary>

<pre><code><div align="left">📦 TinkerScripts/                       
├─ 📄 TinkerScripts.lua                 <-- This is the main script.
└─ 📂 include/                          
   ├─ 📄 Blips.lua                      
   ├─ 📂 HumanCanvas/                   
   │  ├─ 📄 Exported_TattooCombo.txt    <-- Using "Export/Import Tattoos" will save to/load from this file.
   │  └─ 📄 FMCharTats.lua              
   ├─ 📂 Settings/
   │  └─ TS_Settings.lua                <-- Saved settings.        
   └─ 📂 TS_RecoveryPlus/               
      ├─ 📄 Tunables.lua                
      └─ 📄 Unlocks.lua                 </div></code></pre>
Tree generated with File Tree Extractor.
</details></div>

## Loading The Script
  1) Download TinkerScripts.zip from [Releases](https://github.com/lmagineNothing/TinkerScripts/releases/latest) and extract it.
  2) Place TinkerScripts (folder) into: `%AppData%/YimMenuV2/scripts`
  3) Open YimMenuV2, go to Settings → Lua Scripts and click TinkerScripts.lua.
</details>

<details>
  <summary><B>Categories & Features</B></summary>

#### Main
- General
    - Fast Respawn.
    - Fast Reload.
    - Infinite Combat Roll. (+ No Recoil/Spread)
    - Ragdoll on demand.
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
    - Blackout.
    - Hidden Locations: Teleport to Hidden/Random Locations.
    - Request Services.
    - Rain Of Chaos.

#### Biz-Teroids
- Business on steroids! Resupply and Restock your businesses with a single click! (or choose your own options).
    - Instant Sell/Buy/Steal.
    - Trigger, Alien Egg Resupply Mission (Bunker), Excess Weapon Parts & Bar Earnings.
    - Source Special Items (CEO Warehouses).
    - Teleport to Businesses.

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
- A category with useful/convenient stats and _some_ **UNLOCKS**.
If you want to unlock **EVERYTHING**, check out this other script: [UnlockEverything](https://www.unknowncheats.me/forum/4743916-post792.html)

- **Mission Master**:
  - Heists: Heist Finale Options. <sub>*Only those that are NOT available in the menu, except the Kortz Center Heist.</sub>
    - Cluckin' Bell Farm Raid:
      - Crack Safe.
      - Teleport to Office Keys.
      - Open All Doors.
    - Cayo Perico Heist:
      - Solo Mantrap.
      - Take Secondary Target.
      - Teleport to Key Card.
      - Teleport to Gate Keys.
    - Kortz Center Heist:
      - Skip Data Crack, Fingerprint Hacking, Vault Door Hacking.
      - Take Primary/Secondary Target.
      - Auto-Enter PC Access Code.
      - Disable Lasers + Easy/Hard Mode, No damage (Harmless) Lasers.
      - Cut Glass.
      - Disable All Cameras (Exterior & Interior).
      - Teleport to Exit Keys.
      - Instant Finish.
  - Mission Setups & Skips:
      - Auto Shop Contract.
      - Dr. Dre Contract.
      - Cluckin' Bell Farm Raid.
      - LSA Operations.
      - Salvage Yard.
      - Bounty Targets.
      - FIB Files.
      - Oscar Guzman Flies Again.
      - KnoWay Out.
      - The Kortz Center Heist.
  - Misc:
    - Loot Auto-Grab.
    - Min. Mission Payout.
    - Survivals:
      - No Idle Kick.
      - Start Wave.
      - Skip to Wave.
      - Instant Finish.
      - Enable Endless Waves.
    - Enable Heists Weekly Boost.
    - Criminal Mastermind Bonus. ($12M Bonus)
    - Casino Heist: P.O.I & Extras (Secure Keypad & Vault Door) Reset.
    - Crack Stash House Safe. <sub>Removed at some point but added it back since built-in one doesn't automatically open the safe</sub>
- **Unlocks**:
    - Content Unlocks: All Bunker, Collectibles, Tattoos, LSC Unlocks, etc.
    - Character Stats: Rank & KD Editor Fast Run, Frozen Rank, Max out stats, Bad Sport.
    - Awards.
    - Career Progress.
    - Achievements.
    - Rockstar Dev Shirts.
- **Money**:
    - Good Behaviour Bonus, Casino Membership Bonus.
    - Sindy Looper: MC Clubhouse Bag-Loop. <sub>THESE FEATURES SHOULD NOT BE CONSIDERED "SAFE". I haven't tested the limits.</sub>
- **Tunables**:
  - Enable Independence Day.
  - Halloween.
  - Christmas. <sub>(probably won't add more)</sub>
- **Human Canvas**:
    - Stack, Import and Export Tattoos.
    - Stack Face Paints/Makeup.
    - Face Paint/Makeup Opacity & Colors.
    - Hair Colors: Regular and Hidden Hair/Highlight Colors.

#### Settings +
- Save/Load submenu settings. <sub>See [complete list of options that can be saved](docs/Readme.md#settings-)</sub>

</details>

<details>
  <summary><B>Screenshots</B></summary>
  
<p align="center"><table>
    <tr>
      <td align="center"><img src="docs/assets/categories/Main-General.png" width="200"/><br><sub>Main (General)</sub></td>
      <td align="center"><img src="docs/assets/categories/Main-Misc.png" width="200"/><br><sub>Main (Misc)</sub></td>
      <td align="center"><img src="docs/assets/categories/Biz-Teroids.png" width="200"/><br><sub>Biz-Teroids</sub></td>
      <td align="center"><img src="docs/assets/categories/PhoneMaster.png" width="200"/><br><sub>Phone Master</sub></td>
    </tr>
    <tr>
      <td align="center"><img src="docs/assets/categories/GunVanHalen.png" width="200"/><br><sub>Gun Van Halen</sub></td>
      <td align="center"><img src="docs/assets/categories/RainbowVehicles.png" width="200"/><br><sub>Rainbow Vehicles</sub></td>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-MissionMaster.png" width="200"/><br><sub>Recovery + (Mission Master)</sub></td>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-Unlocks.png" width="200"/><br><sub>Recovery + (Unlocks)</sub></td>
    </tr>
    <tr>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-Tunables.png" width="200"/><br><sub>Recovery + (Tunables)</sub></td>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-Money.png" width="200"/><br><sub>Recovery + (Money)</sub></td>
      <td align="center"><img src="docs/assets/categories/RecoveryPlus-HumanCanvas.png" width="200"/><br><sub>Recovery + (HumanCanvas)</sub></td>
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

Even if this submenu has features that are also available in other submenus, this submenu is **NOT** a paste.

TinkerScripts has some unique features such as Bail Bond Targets Selection, Human Canvas, Skip Survival Waves and a bit more.

So, please, if you find any of these features useful [don't forget to give credit](#respect-the-code) and (if you feel generous) star this repo 👉👈.

</details>

### Known Issues
I've tested every single feature in this submenu, but you may still find the following issues (not necessarily because of the script, but because of how the game works):

<sub>
- Game will freeze for a brief moment when TinkerScripts is selected after submenu loads for the first time in session (game session, not freemode) because of the Outfit Renamer.<br>
- Phone Animations might break the email app. Celltowa phone model breaks some services, e.g. Clothing Stores or the Gun Van; can be fixed by joining a new session. If phone gets stuck completely you'll have to restart the game (It has happened to me only once).<br>
- Stacked Face Paints are not persistent and will disappear after restarting the game.<br>
- Open All Doors in Cayo Perico Heist won't enable loot in Compound. Use Solo Mantrap to be able to grab the loot.<br>
- Character wheel won't appear if selected phone theme is other than default. Can be "fixed" by changing to default theme; alternatively use "Quit to Store Mode" in pause menu.<br>
- Instant Sell in MC Business missions doesn't always actually add the payout to player's balance.<br>
- Teleport to "X" teleports player to "Blips", so you may end up under the map or similar. Also, retire from CEO or become a MC President to be able to teleport to MC Businesses.<br>
- You won't get any payout if you Skip Waves or use Instant Finish in "New Survivals" (Probably related to kills).<br>
- Don't set the spawn amount too high for <b>Rain of Chaos</b> or your game will crash.<br>
</sub>
<br>

# FAQ

- Is this safe to use?

  There are only 2 things you can do with this submenu that can get you banned:
  1. Selling businesses goods **multiple times too quickly**.
  2. Generating too much money with **Sindy Looper** or the **bonuses** in **Recovery +**.

  But that's only if you **abuse** these features.
  Other than that, TinkerScripts is completely safe to use.

  _<sub>I'd also include earning too much money with min. mission payout set to max, but I've never seen anyone getting banned for this.</sub>_

- Do I need FSL?

  No. You can use it if you want, but it's not required.

- TinkerScripts is not loading, what do I do?

  If you followed the steps mentioned above **correctly**, TinkerScripts is probably outdated because:
  
  1. Game has been updated.
  2. YimMenuV2 Lua API has been updated.

  Go touch some grass until I update the submenu.
  
- I found an issue, what do I...?

  STOP! Read [**Known Issues**](#known-issues) first.
  
  If you are sure you have found an issue, be precise, don't just say "This doesn't work!".

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
      <img src="https://img.shields.io/badge/UnknownCheats_-ImagineNothing-black.svg?&style=square&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADgAAABBCAYAAACEq2cXAAAACXBIWXMAAAsTAAALEwEAmpwYAAADF0lEQVRoge2asXXbMBCG/8tL4SKFRlA2YDaQJojUpTM9QeINlAnsTCCnchllAnkDaQOpTCd2Kf8UABPGFogDCIqkH7/3UEjCgfhMEjgeLSTxmnnT9QTaZhQcOqPg4CF5tjn6TkmuSa4jjpOT3JHMUs1R01SCFbEqKkkrdqjEnUgueiHoEFNJnhF7Tt6pIMm7mslV2ZKcVCYz9YgFS7YlGMKulCS5Coz1SrYlmMdI2rZLKdmKoB34kpKLNgRr90EReQBw47uEKmQAMhEpAMwB7ANjk+Pd6CMky7gC4ZLJUWUyCSSfQmNToU7VmkiKSGdnMigXtZKxFA1io3n1yfYoOHRGwaHztusJnIPkDMDMfiwAbAAcY8bqk+AVyRWAzwAmz367A3AP4CtCt5u6ZNvR38fMEbf1xP1WjL2jSeTTJNsX5krRJwOwxcsz7KRPgloyBEgOURAwkqqiV98EN9CvlgsoJPsm+A3ABxhRDTk8km0IXjeIfWcfr5YAHpQxOYAvrh/bEMx5vl46UcQ+ltuMiNxA/6DsHruFfbBkbfvPGF6AWtlYX/HqQFMYi6uqOQRPAROtm5yPLd0VugM9YmwgmDFMsgknmitgYqXUYmUTl4yI1EoiMKNoiACYIiLhjlpkRGQPUy0rAsKOAL5HHO6hEh9M9CoaIFkAuBWR9wib5AbA3K6m8biu3YD4untyzf/fPK0U992a5FQzR01rLOiQ3PLMm1yF4CfH+NEtyUZfuVyfACxFZG6/C+VXivlUcT7Rh55FmMr1PDK2yXFr6VuynZxRsOfM4HmvOGTBHCab2qJOsskSHNCmrP93lJKFcrz8WdzJHkO/DyZsmUKsSh4oR9aUE/soSNoM6MxYC77MmpxyZM3TRGIyhD99FDCJ9k/7+RrmvquyhycfvpQgYOR+4N87h6YUMAWqY12nS66iBcxf+z7hWEdfxy62iVsAS8S/s9/DnLm9pnNX++AGZpJPEXGqM/eXC6yimj3t4FlVD9TvkZ2sohoWAD7C1F5KjjCr6CZ20D4JtsKQc1EVo+DQGQWHzig4dP4AxG3fnntmC7gAAAAASUVORK5CYII="/>
</a><sup><a href="https://www.unknowncheats.me/forum/private.php?do=newpm&u=3627117">Direct Link to PM</a></sup>

`No, I don't use Discord.`

# Credits
- [Mystro69](https://github.com/Mystro69) | [Outfit Renamer](https://github.com/Mystro69/Outfit-Renamer-1.66)
- [ShinyWasabi](https://github.com/ShinyWasabi) | [scrDbg](https://github.com/ShinyWasabi/scrDbg)
- [xesdoog](https://github.com/xesdoog) | [YimRageUI](https://github.com/xesdoog/YimRageUI) - Helped me better understand how to interact with an UI/submenu.
- MrLiteX | R* Dev Shirts Transaction Method
- Stack Overflow | Code Snippets & Information <!-- A LOT -->