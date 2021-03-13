# symbol count
This is a simple Ruby script that opens all files of a given type in a folder path, then tallies up all symbols.

This can be used to inform how top arrange a programmable keyboard. Specifically, I have used to update [QMK](https://docs.qmk.fm/) firmware.

## Installation
This program requires the [Ruby](https://www.ruby-lang.org) programming language and is the only dependency. The code uses Ruby's functional composition syntax - be sure to install Ruby 2.6 or later.

## Usage
Run the count file in the Ruby interpreter and pass in both the path as well as the file type as arguments.
```bash
ruby count.rb /home/choltz/src/webapp/app rb
```

## Output
The 20 most used symbols in the given folder will be displayed. For example:

```
> ruby count.rb /home/choltz/src/webapp/app rb

"_" - 28674
"#" - 15682
"'" - 12192
"," - 11226
"(" - 9972
")" - 9971
"=" - 8467
"-" - 6811
""" - 5668
"[" - 5324
"]" - 5323
"|" - 5188
"{" - 4192
"}" - 4188
"/" - 3652
"?" - 3183
">" - 2564
"<" - 1775
"@" - 1566
"&" - 1103
```
