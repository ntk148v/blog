#!/bin/bash
git submodule update --init --recursive
git pull --recurse-submodules origin master
mkdir public
cd public/
git pull
cd -
