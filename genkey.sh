#!/bin/bash

openssl rand -hex 32 | tr -d '\n' > key.txt

echo Generated key saved in key.txt

printf "key: \""
cat key.txt
echo \"
