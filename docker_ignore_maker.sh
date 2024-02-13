#!/bin/bash

# Save the current .dockerignore file if it exists
if [ -f ".dockerignore" ]; then
    cp .dockerignore .dockerignore.backup
fi

# Start fresh for .dockerignore
echo "# Automatically generated .dockerignore" > .dockerignore

# Add everything from .gitignore into .dockerignore
if [ -f ".gitignore" ]; then
    echo "# Files from .gitignore" >> .dockerignore
    cat .gitignore >> .dockerignore
fi

# List all files not tracked or committed in Git and append them to .dockerignore
echo "# Untracked or changed files" >> .dockerignore
{ git status --short | awk '{print $2}'; git ls-files --others --exclude-standard; } | sort | uniq >> .dockerignore

# Append the original .dockerignore content if it was backed up
if [ -f ".dockerignore.backup" ]; then
    echo "# Original .dockerignore content" >> .dockerignore
    cat .dockerignore.backup >> .dockerignore
    rm .dockerignore.backup
fi
