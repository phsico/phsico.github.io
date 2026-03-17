Diceware Passphrase Generator Script
A bash script that generates secure passphrases using the diceware method with EFF wordlists.

Overview
This script automates the diceware passphrase generation process, which involves rolling dice and using the results to look up random words from curated wordlists. The diceware method is a well-established technique for creating memorable yet cryptographically secure passphrases.

Features
Multiple wordlist options: Choose between the EFF Large Wordlist (5 dice) or two EFF Short Wordlists (4 dice each)
Flexible input: Specify parameters via command-line arguments or interactive prompts
Clipboard integration: Automatically copy your generated passphrase to clipboard using xclip, xsel, or macOS pbcopy
Validation: Input validation ensures dice rolls stay within the 1-25 range
Clear output: Displays each dice roll sequence and the corresponding word, plus the final passphrase
Prerequisites
Bash shell
EFF wordlist files in the same directory:
eff_large_wordlist.txt (for 5-dice rolls)
eff_short_wordlist_1.txt (for 4-dice rolls)
eff_short_wordlist_2.txt (for 4-dice rolls)
Download these files from the EFF website.

Optional: For clipboard functionality, install one of:

xclip (Linux)
xsel (Linux)
pbcopy (macOS, built-in)
Usage
Basic usage (interactive)
bash


./script.sh
With parameters
bash


./script.sh <num_rolls> [wordlist_choice] [clipboard_choice]
Parameters
Parameter	Values	Description
num_rolls	1-25	Number of words to generate
wordlist_choice	0, 1, 2	0 = EFF Large (5 dice, default), 1 = EFF Short #1 (4 dice), 2 = EFF Short #2 (4 dice)
clipboard_choice	0, 1, 2, 3	0 = No clipboard (default), 1 = xclip, 2 = xsel, 3 = macOS pbcopy
Examples
Generate 6 words using the default EFF Large Wordlist:

bash


./script.sh 6
Generate 10 words using EFF Short Wordlist #1 and copy to clipboard with xclip:

bash


./script.sh 10 1 1
Generate 8 words using EFF Short Wordlist #2 without clipboard:

bash


./script.sh 8 2 0
How It Works
Dice rolls: For each word, the script rolls a virtual die (1-6) the appropriate number of times (4 or 5 depending on wordlist)
Lookup: The dice sequence is used to look up the corresponding word in the chosen wordlist
Output: Each roll and word is displayed, followed by the complete passphrase
Clipboard: Optionally copies the final passphrase to your system clipboard
Security Notes
The diceware method creates passphrases with high entropy suitable for passwords and security keys
Using the EFF Large Wordlist (5 dice per word) provides ~13 bits of entropy per word
Using an EFF Short Wordlist (4 dice per word) provides ~12.9 bits of entropy per word
A 6-word passphrase from the large list has approximately 77 bits of entropy
About the Wordlists
The wordlists are sourced from the Electronic Frontier Foundation (EFF) and are specifically designed for the diceware passphrase system. Learn more at eff.org/dice.
