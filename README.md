# Tur-Rules

A script to display rules in an IRC channel.  
Made by request from ApocT. Thanks for the idea! =)

## Setup

1. Copy `tur-rules.sh` to `/glftpd/bin/`
2. Set permissions: `chmod 755 /glftpd/bin/tur-rules.sh`
3. Copy `tur-rules.tcl` to your bot's config folder
4. Load it in the bot's config file and rehash the bot

## Settings

### `rules`
Path to your rules file.

### `sections`
Defines the sections you can display, with what each section starts with.

**Example rules file structure:**
```
General rules:
0.1 : No dual downloading..
DIVX rules:
1.0 : No uploading bla bla.
1.1 : Limited not allowed..
DOCS rules:
2.0 : Limited allowed.
2.1 : Only 5.0+ on iMDB.
etc..
```

**Corresponding setup would be:**
```tcl
sections="
DIVX:1.
DOCS:2.
GENERAL:0.
"
```

**Advanced options:**
- You can trigger multiple rules for one section using `|`  
  Example: `DOCS:2.|0.1`
- Add as many `|` separators as needed
- The display order follows the rules file order, not your configuration order
- Only the first "word" in the rules list can be used as a trigger
- Use `ALL:.` to display all rules

### `compress`
A single character to compress repeated characters in the rules display.

**Example:**
If your rule looks like:  
`1.0 : No stv...............[ 3x nuke ]`

Setting `compress="."` will display:  
`1.0 : No stv.[ 3x nuke ]`

- Use `""` to show lines exactly as they appear in the file
- Basically performs a `tr -s` operation on matching characters

## Usage

- `!rules DOCS` - Displays DOCS rules
- `!rules DOCS limited` - Only shows DOCS rules containing "limited"
- `!rules` - Lists available sections

You can test the script from shell by executing `tur-rules.sh` directly.

## Contact

- **Turranius** on EFnet/LinkNet (usually in #glftpd)
- Websites:  
  [http://www.grandis.nu](http://www.grandis.nu)  
  [http://grandis.mine.nu](http://grandis.mine.nu)
