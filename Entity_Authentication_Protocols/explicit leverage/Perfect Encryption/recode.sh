#!/bin/bash

for file in *.spthy
do

    if [[ -f "$file" ]]; then
        echo "Running tamarin-prover on $file..." >> output.log
        
        temp_output=$(mktemp)
        
        { time tamarin-prover --prove "$file"; } >> "$temp_output" 2>&1
        
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
