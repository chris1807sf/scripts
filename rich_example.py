#!/usr/bin/python3

#https://github.com/Textualize/rich

import time

from rich import print
print("Hello, [bold magenta]World[/bold magenta]!", ":vampire:", locals())


from rich.console import Console

console = Console()


console.print("Hello, [bold magenta]World[/bold magenta]!", ":vampire:", style="bold red")


from rich.progress import track

def do_step(step):
    l=step

for step in track(range(20)):
    time.sleep(0.5)
    do_step(step)

import os
import sys

from rich import print
from rich.columns import Columns

#show files of dir in columns
directory = os.listdir(sys.argv[1])
print(Columns(directory))