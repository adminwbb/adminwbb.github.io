#!/bin/bash
# Quick Create Post for My Blog.

set -e

read -p "Input post name: " name

hugo new post/$name.md
