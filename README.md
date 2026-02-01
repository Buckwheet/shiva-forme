# Shiva (Private Fork)

A comprehensive Lich script for automated hunting in Gemstone IV, designed for high-level play.

## Overview
Shiva manages the entire hunting lifecycle:
- **Bounties**: Automatically fetches and completes taskmaster bounties.
- **Combat**: Intelligently manages stances, attacks (including UAC/Edged), and ambushes.
- **Support**: Handles healing, loot management, and resting.

## Installation

1.  Place the `shiva` folder in your `Lich/scripts` directory (or wherever your `Lich` loads classes from).
2.  Ensure you have the following dependencies in your scripts folder:
    - `eloot.lic` (Looting)
    - `eherbs.lic` (Healing)
    - `go2.lic` (Travel)
    - `reaction.lic` (Environment reaction stub)

## Configuration

Set the following Lich variables before running:

```bash
;vars set lootsack="your loot container"
;vars set herbsack="your herb container"
;vars set harness="your weapon/tool container"
;vars set gemsack="your gem container"
;vars set skinsack="your skin container"
```

**Optional:**
```bash
;vars set skinning_weapon="dagger name"
;vars set ranged_weapon="bow name"
```

## Usage

To run Shiva in fully automated daemon mode (continuous looping):

```bash
;shiva --auto --daemon
```

## Recent Fixes (Jan 2026)
- **Daemon Mode**: Fixed immediate exit issues.
- **Logger**: Fixed recursive stack overflow in logging module.
- **Dependencies**: Patched optional `Spellup` dependency.
- **Combat**: Added `Katar` support to `Edged` tactics for proper `Kill/Ambush` execution.