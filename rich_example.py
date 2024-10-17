#!/usr/bin/python3

from rich import print
#https://github.com/Textualize/rich

print("Hello, [bold magenta]World[/bold magenta]!", ":vampire:", locals())


from rich.progress import track

for step in track(range(100)):
    do_step(step)