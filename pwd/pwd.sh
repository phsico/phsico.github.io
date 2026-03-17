#!/bin/bash

echo "EFF Dice-Generated Passphrases"

# Define wordlist files and their URLs
declare -A wordlists=(
    ["eff_large_wordlist.txt"]="https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt"
    ["eff_short_wordlist_1.txt"]="https://www.eff.org/files/2016/09/08/eff_short_wordlist_1.txt"
    ["eff_short_wordlist_2.txt"]="https://www.eff.org/files/2016/09/08/eff_short_wordlist_2_0.txt"
)

# Function to check and download wordlists
check_and_download_wordlists() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local missing_files=()

    for wordlist in "${!wordlists[@]}"; do
        if [ ! -f "$script_dir/$wordlist" ]; then
            missing_files+=("$wordlist")
        fi
    done

    if [ ${#missing_files[@]} -gt 0 ]; then
        echo "Missing wordlist files: ${missing_files[*]}"

        if ! command -v wget &> /dev/null; then
            echo "Error: wget is not installed"
            echo ""
            echo "Please install wget or manually download the following files to $script_dir:"
            echo ""

            for wordlist in "${missing_files[@]}"; do
                echo "File: $wordlist"
                echo "URL: ${wordlists[$wordlist]}"
                echo "wget command: wget -O $script_dir/$wordlist ${wordlists[$wordlist]}"
                echo ""
            done

            echo "Or download all at once with this command:"
            echo "cd $script_dir && wget -O eff_large_wordlist.txt https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt && wget -O eff_short_wordlist_1.txt https://www.eff.org/files/2016/09/08/eff_short_wordlist_1.txt && wget -O eff_short_wordlist_2.txt https://www.eff.org/files/2016/09/08/eff_short_wordlist_2_0.txt"
            echo ""
            exit 1
        fi

        # Ask user for confirmation
        while true; do
            read -p "Download missing wordlists? (yes/y or no/n): " user_choice
            case "$user_choice" in
                yes|y|YES|Y)
                    echo "Downloading missing wordlists..."
                    for wordlist in "${missing_files[@]}"; do
                        echo "Downloading $wordlist..."
                        wget -O "$script_dir/$wordlist" "${wordlists[$wordlist]}"
                        if [ $? -ne 0 ]; then
                            echo "Error: Failed to download $wordlist"
                            exit 1
                        fi
                    done
                    echo "Wordlists downloaded successfully"
                    break
                    ;;
                no|n|NO|N)
                    echo ""
                    echo "Error: Wordlists are required to run this script"
                    echo ""
                    echo "Please manually download the following files to $script_dir:"
                    echo ""

                    for wordlist in "${missing_files[@]}"; do
                        echo "File: $wordlist"
                        echo "URL: ${wordlists[$wordlist]}"
                        echo "wget command: wget -O $script_dir/$wordlist ${wordlists[$wordlist]}"
                        echo ""
                    done

                    echo "Or download all at once with this command:"
                    echo "cd $script_dir && wget -O eff_large_wordlist.txt https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt && wget -O eff_short_wordlist_1.txt https://www.eff.org/files/2016/09/08/eff_short_wordlist_1.txt && wget -O eff_short_wordlist_2.txt https://www.eff.org/files/2016/09/08/eff_short_wordlist_2_0.txt"
                    echo ""

                    # Ask for confirmation before exiting
                    while true; do
                        read -p "Are you sure you don't want to download the files? (yes/y or no/n): " confirm_choice
                        case "$confirm_choice" in
                            yes|y|YES|Y)
                                echo "Exiting..."
                                exit 1
                                ;;
                            no|n|NO|N)
                                echo ""
                                break
                                ;;
                            *)
                                echo "Invalid input. Please enter yes/y or no/n"
                                ;;
                        esac
                    done
                    ;;
                *)
                    echo "Invalid input. Please enter yes/y or no/n"
                    ;;
            esac
        done
    fi
}

# Check and download wordlists at startup
check_and_download_wordlists

# Get the script directory for file operations
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if parameters are provided
if [ $# -eq 1 ]; then
    num_rolls=$1
    wordlist_choice=""
    clipboard_choice=0
elif [ $# -eq 2 ]; then
    num_rolls=$1
    wordlist_choice=$2
    clipboard_choice=0
elif [ $# -eq 3 ]; then
    num_rolls=$1
    wordlist_choice=$2
    clipboard_choice=$3
else
    read -p "Enter number of dice rolls (1-25): " num_rolls

    # Ask user to choose wordlist
    echo ""
    echo "Choose wordlist:"
    echo "0 - eff_large_wordlist.txt (5 dice rolls, default)"
    echo "1 - eff_short_wordlist_1.txt (4 dice rolls)"
    echo "2 - eff_short_wordlist_2.txt (4 dice rolls)"
    read -p "Enter wordlist choice (0, 1, or 2): " wordlist_choice

    clipboard_choice=0
fi

# Validate input
if ! [[ "$num_rolls" =~ ^[0-9]+$ ]] || [ "$num_rolls" -lt 1 ] || [ "$num_rolls" -gt 25 ]; then
    echo "Error: Please enter a number between 1 and 25"
    echo ""
    exit 1
fi

# Determine which wordlist to use and set dice count
case $wordlist_choice in
    0|"")
        wordlist_file="$script_dir/eff_large_wordlist.txt"
        dice_count=5
        echo "Using wordlist: eff_large_wordlist.txt (5 dice rolls)"
        ;;
    1)
        wordlist_file="$script_dir/eff_short_wordlist_1.txt"
        dice_count=4
        echo "Using wordlist: eff_short_wordlist_1.txt (4 dice rolls)"
        ;;
    2)
        wordlist_file="$script_dir/eff_short_wordlist_2.txt"
        dice_count=4
        echo "Using wordlist: eff_short_wordlist_2.txt (4 dice rolls)"
        ;;
    *)
        echo "Error: Wordlist choice must be 0, 1, or 2"
        exit 1
        ;;
esac

echo ""

# Check if wordlist file exists (redundant check, but kept for safety)
if [ ! -f "$wordlist_file" ]; then
    echo "Error: $wordlist_file not found"
    exit 1
fi

# Variable to store all words
all_words=""

# Perform the dice rolls
for ((i = 1; i <= num_rolls; i++)); do
    roll_output="$i. "
    dice_sequence=""

    # Roll a dice based on dice_count
    for ((j = 0; j < dice_count; j++)); do
        dice=$((RANDOM % 6 + 1))
        roll_output+="${dice}"
        dice_sequence+="${dice}"
    done

    # Look up the word in the wordlist
    word=$(grep "^${dice_sequence}" "$wordlist_file" | cut -d' ' -f2)

    if [ -z "$word" ]; then
        echo "$roll_output = [word not found]"
    else
        echo "$word"
        all_words+="$word"
    fi
done

# Trim trailing space and remove numbers
all_words=$(echo "$all_words" | xargs | tr -d '0-9')
echo "Result: $all_words"

# Handle clipboard based on parameter
case $clipboard_choice in
    0|"")
        # No clipboard copy
        ;;
    1)
        # xclip
        if command -v xclip &> /dev/null; then
            echo "$all_words" | xclip -selection clipboard
            echo "✓ Copied to clipboard (xclip)"
        else
            echo "⚠ xclip not found"
        fi
        ;;
    2)
        # xsel
        if command -v xsel &> /dev/null; then
            echo "$all_words" | xsel --clipboard --input
            echo "✓ Copied to clipboard (xsel)"
        else
            echo "⚠ xsel not found"
        fi
        ;;
    3)
        # macOS pbcopy
        if command -v pbcopy &> /dev/null; then
            echo "$all_words" | pbcopy
            echo "✓ Copied to clipboard (pbcopy)"
        else
            echo "⚠ pbcopy not found (macOS only)"
        fi
        ;;
    *)
        echo "Error: Clipboard choice must be 0, 1, 2, or 3"
        exit 1
        ;;
esac
