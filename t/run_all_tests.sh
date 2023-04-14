#!/bin/sh

PREV_LUA_PATH=""
if [ -n "${LUA_PATH}" ]; then
  PREV_LUA_PATH=$LUA_PATH
fi

eval "$(luarocks path)"
export LUA_PATH="${LUA_PATH};./lib/?.lua"

echo "running tests for rep.lua"
for t in ./*.lua; do
  echo "$t"
  lua "$t"
done

echo "done"

export LUA_PATH=$PREV_LUA_PATH
