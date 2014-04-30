#!/bin/bash

for i in ./model/*.sh; do source "$i" 2>/dev/null; done
for i in ./control/*.sh; do source "$i" 2>/dev/null; done
for i in ./view/*.sh; do source "$i" 2>/dev/null; done

