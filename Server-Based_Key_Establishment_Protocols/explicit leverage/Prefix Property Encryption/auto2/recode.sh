#!/bin/bash

for file in *.spthy
do

    if [[ -f "$file" ]]; then
        echo "Running tamarin-prover on $file..." >> output.log
        
        temp_output=$(mktemp)
        
        # Run tamarin-prover with a timeout of 60 seconds
        { time timeout 500 tamarin-prover --prove "$file"; } >> "$temp_output" 2>&1
        exit_code=$?

        # Check if the command was killed due to state explosion or if the timeout occurred
        if [[ $exit_code -eq 124 ]]; then
            echo "Timeout occurred for $file. Re-running with --auto-source..." >> output.log
            { time tamarin-prover --prove --auto-source "$file"; } >> "$temp_output" 2>&1
        elif grep -q "Killed" "$temp_output"; then
            echo "State explosion detected for $file. Re-running with --bound=20..." >> output.log
            { time tamarin-prover --prove --bound=20 "$file"; } >> "$temp_output" 2>&1
        fi
        
        cat "$temp_output" >> output.log
        echo "Finished processing $file" >> output.log
        
        tail -n 13 "$temp_output" >> time.log
        
        rm "$temp_output"
        
        echo "------------------------------------------------------------" >> output.log
        echo "============================== END ==========================" >> output.log
        echo "------------------------------------------------------------" >> output.log
        echo "" >> output.log  
    fi
done
