#!/bin/sh
test "$(xdg-mime query default "$mime_type")" = "$handler"
