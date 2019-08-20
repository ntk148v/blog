#!/bin/bash
git pull --recurse-submodules origin master
cd public/
git pull
cd -
