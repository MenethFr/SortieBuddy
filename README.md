# SortieBuddy

**SortieBuddy** is a lightweight Windower4 addon for _Final Fantasy XI_ designed to track and report the locations of **Diaphanous Bitzers** within the Sortie instance. It automatically calculates map coordinates and translates them into human-readable objective names (e.g., "NW Boss", "Flans") for the party.

_Adapted from NyzulBuddy by Uwu/Darkdoom._

## Features

- **Server Sync**: Forces a packet update (`0x016`) to ensure NPC positions are accurate before reporting.
- **Smart Translation**: Converts raw X/Y coordinates into standard FFXI map grid coordinates (e.g., D6, L11).
- **Human-Readable Labels**: Includes a built-in dictionary for Sortie Sectors E, F, G, and H to identify boss and mob rooms instantly.
- **Anti-Spam Reporting**: Uses a staggered reporting system with configurable delays to avoid chat filters when sending info to `/party`.
- **Debug Mode**: If a Bitzer is found outside the known grid, the addon reports raw X/Y data to help with further calibration.

## Installation

1. Download the script.
2. Create a folder named `SortieBuddy` in your Windower `addons` directory.
3. Save the script as `SortieBuddy.lua` inside that folder.
4. Load it in-game using `//lua load SortieBuddy`.

## Commands

| Command           | Alias             | Description                                                               |
| :---------------- | :---------------- | :------------------------------------------------------------------------ |
| `//sortie send`   | `//sortie report` | Synchronizes with the server and reports all nearby Bitzers to the party. |
| `//sortie silent` | -                 | Synchronizes with the server and reports all nearby Bitzers to self.      |
| `//sortie help`   | -                 | Displays the command help message.                                        |

## How it Works

When the `send` or `silent` command is triggered, the addon:

1.  **Requests Data**: Injects an outgoing packet to the server to get the latest position of Bitzers E, F, G, and H.
2.  **Wait for Sync**: Pauses for 3 seconds to allow the server to respond.
3.  **Processes Coordinates**: Iterates through the Bitzers and calculates their position using a calibrated grid formula:
    - `Column = 2 + floor((x - 40) / 80)`
    - `Row = 7 - floor((y - 40) / 80)`
4.  **Reports**: Sends a message to `/p` or locally (for silent mode) for each detected Bitzer with a 2-second delay between each message to prevent disconnects.

## Calibration Note

The coordinate formula is calibrated based on a **80x80 yalm** grid with an offset of **40**, specifically tested for the Outer Ra'Kaznar / Sortie map layout.

## Author

- **Author**: Meneth
- **Version**: 1.1
- **Language**: English
