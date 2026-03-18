# Diceware Passphrase Generator

A bash script that generates secure passphrases using the diceware method with EFF wordlists.

## Overview

This script automates the diceware passphrase generation process, which involves rolling dice and using the results to look up random words from curated wordlists. The diceware method is a well-established technique for creating memorable yet cryptographically secure passphrases.

## Features

*   Multiple wordlist options: Choose between the EFF Large Wordlist (5 dice) or two EFF Short Wordlists (4 dice each)
*   Flexible input: Specify parameters via command-line arguments or interactive prompts
*   Clipboard integration: Automatically copy your generated passphrase to clipboard using xclip, xsel, or macOS pbcopy
*   Validation: Input validation ensures dice rolls stay within the 1-25 range
*   Clear output: Displays each dice roll sequence and the corresponding word, plus the final passphrase

## Prerequisites

*   Bash shell
*   EFF wordlist files in the same directory:
    *   `eff_large_wordlist.txt` (for 5-dice rolls)
    *   `eff_short_wordlist_1.txt` (for 4-dice rolls)
    *   `eff_short_wordlist_2.txt` (for 4-dice rolls)

Download these files from the [EFF website](https://www.eff.org/dice) or with the script.

**Optional**: For clipboard functionality, install one of:
*   `xclip` (Linux)
*   `xsel` (Linux)
*   `pbcopy` (macOS, built-in)

## Usage

### Basic usage (interactive)
```bash
./pwd.sh <num\_rolls> [wordlist\_choice] [clipboard\_choice]

| Parameter | Values | Description |
|-----------|--------|-------------|
| `num_rolls` | 1–25 | Number of words to generate |
| `wordlist_choice` | 0, 1, 2 | **0** = EFF Large (5 dice, default), **1** = EFF Short #1 (4 dice), **2** = EFF Short #2 (4 dice) |
| `clipboard_choice` | 0, 1, 2, 3 | **0** = No clipboard (default), **1** = xclip, **2** = xsel, **3** = macOS pbcopy |

```
```bash
❯ ./pwd.sh
EFF Dice-Generated Passphrases
Enter number of dice rolls (1-25): 3

Choose wordlist:
0 - eff_large_wordlist.txt (5 dice rolls, default)
1 - eff_short_wordlist_1.txt (4 dice rolls)
2 - eff_short_wordlist_2.txt (4 dice rolls)
Enter wordlist choice (0, 1, or 2):  
Using wordlist: eff_large_wordlist.txt (5 dice rolls)

34362   idiom
41342   mop
56122   stack
Result:  idiom mop stack
```
```bash
❯ ./pwd.sh 3 1
EFF Dice-Generated Passphrases
Using wordlist: eff_short_wordlist_1.txt (4 dice rolls)

5666    stock
6314    tile
3666    lip
Result:  stock tile lip
```
