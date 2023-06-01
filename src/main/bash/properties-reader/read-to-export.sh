#!/bin/bash

# ---
# Script reads all key=value lines in a *.properties file

process_file() {
  local file="$1"

  while IFS='=' read -r key value
  do
    [[ $key =~ ^#.* ]] && continue
    key=$(echo "$key" | tr '.' '_')
    echo "export ${key}='${value}'"
    eval "export ${key}='${value}'"
  done < "$file"
}

if [ $# -gt 0 ]; then
    paths=("$@")
else
    echo "Inform file(s) or directory path:"
    echo "./read-to-export.sh /somepath/myfile.properties or /somedirectory to scan"
    exit 1
fi

for path in "${paths[@]}"
do
  if [ -f "$path" ]; then
    # If it's a file, process it
    echo "Reading from $path file..."
    process_file "$path"

  elif [ -d "$path" ]; then
    # If it's a directory, process all property files in it
    echo "Reading property files in $path directory..."

    for file in "$path"/*.properties
    do
      echo "Reading $file file..."
      process_file "$file"
    done

  else
    echo "Invalid path: $path"
  fi
done
