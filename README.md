# Shiva (Private Fork)

A comprehensive, modular Lich script for automated hunting in Gemstone IV.

## Overview
Shiva manages the entire hunting lifecycle:
- **Bounties**: Automatically fetches and completes taskmaster bounties.
- **Combat**: Intelligent stance dancing (Armor-aware), attacks, and ambushes.
- **Support**: Native spell maintenance, healing, and loot management.
- **Stockpiling**: Efficiently moves gems/skins to locker bots.

## Installation

### 1. Clone the Repository
Clone this repo into a permanent location (e.g., your Development folder).

```bash
git clone https://github.com/Buckwheet/shiva-forme.git
```

### 2. Symlink or Copy to Lich
Lich needs to "see" the script. You have two options:

**Option A: Symbolic Link (Recommended for Developers)**
Open PowerShell as Administrator:
```powershell
# Link the main script
New-Item -ItemType SymbolicLink -Path "C:\Lich5\scripts\shiva.lic" -Target "C:\Path\To\shiva-forme\shiva.rb"

# Link the Olib dependency (Included in this repo)
New-Item -ItemType SymbolicLink -Path "C:\Lich5\scripts\Olib" -Target "C:\Path\To\shiva-forme\Olib"
```

**Option B: Copy (Simple)**
1.  Copy `shiva.rb` to `C:\Lich5\scripts\shiva.lic`.
2.  Copy the `shiva` folder to `C:\Lich5\scripts\shiva` (if the script expects local imports).
    *   *Note*: Shiva's codebase expects to find its modules relative to itself. Ensure the directory structure is preserved.
3.  Copy the `Olib` folder to `C:\Lich5\scripts\Olib`.

### 3. Dependencies
This repository includes a copy of **Olib**. Ensure the `Olib` folder is present in your Lich scripts directory.
Standard Lich scripts required:
- `eloot` (Looting)
- `go2` (Travel)

## Configuration

Shiva uses **TOML** files for configuration, located in:
`shiva/config/<CharacterName>.toml`

### Critical Settings (`dirtbag.toml` example)

#### Armor (Stance Logic)
To prevent stamina drain, Shiva needs to know your specific armor.

```toml
[combat]
# EXACT noun or name of your worn armor.
# If this matches a Scale-group armor (Scale, Brig, Studded, etc), Shiva will enable stance swapping.
# If it matches Chain/Plate, Shiva will stay in Offensive to save stamina.
armor = "dull black vultite hauberk"
```

#### Weapons
```toml
[combat.weapons]
main = "lance"
offhand = ""
shield = ""
```

#### Stockpile (Gem Mules)
```toml
[stockpile]
bots = ["Makerol"]
gems = ["diamond", "emerald", "ruby"]
```

## Setup & Running
1.  **Start Config**: Run `;shiva` once to generate a default config file if none exists.
2.  **Edit Config**: Modify `shiva/config/<Name>.toml` with your specific items.
3.  **Run**:
    ```bash
    ;shiva
    ```