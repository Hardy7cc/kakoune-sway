# kakoune-sway

[kakoune](https://kakoune.org) plugin to create predictable clients with the [Sway Wayland compositor (WM)](https://swaywm.org/).

This is a fork of [kakoune-i3](https://https://github.com/Delapouite/kakoune-i3/) with improvements specific to Sway. For compatibility, the `i3-`commands will be available to the extent possible.

## Install

Add `sway.kak` to your autoload dir: `~/.config/kak/autoload/`.
It depends on `x11.kak` and `x11-repl` for `send-text`-functionality.

Or via [plug.kak](https://github.com/andreyorst/plug.kak):

```
plug 'mreppen/kakoune-sway' %{
  # Suggested mapping
  map global user 3 ': enter-user-mode sway<ret>' -docstring 'Sway mode'
}
```

As it depends on the `x11` module, add this line to your kakrc:

```
set-option global windowing_modules 'x11'
```

## Usage

### Window creation

5 window commands available:

- `sway-new` new window in the current container
- `sway-new-left` ← new window on the left
- `sway-new-right` → new window on the right
- `sway-new-up` ↑ new window above
- `sway-new-down` ↓ new window below

New windows display a _cloned view_: same buffer, same line.

A `sway` user-mode is also declared. With the mapping in the Install section above:

`,3k` will open a new window above the current one.

### `send-text`

If the module [`x11-repl`](https://github.com/mawww/kakoune/blob/master/rc/windowing/repl/x11.kak) is loaded, a `sway-send-text` command is defined to provide the functionality of `x11-send-text`, and the alias `send-text` is set to `sway-send-text`. This requires the packages `jq`, `wl-clipboard`, and `wtype`.

The method for sending text mirrors that of `x11-repl`, which means copying to the primary clipboard and pasting (`wl-clipboard`) with emulated `shift+insert` (`wtype`). `jq` is used for parsing Sway data. Any suggestions for improving this are welcome.

Note: just like `x11-repl`, this finds the correct window by the window name. Some applications, like `fish` will rename the window by default, and thus break this. Therefore, run the repl with `:repl <repl-executable>` to avoid this.

| Switch      | Description                                  |
| ----------- | -------------------------------------------- |
| -send-enter | Send a keystroke of \<enter> after the text. NOTE: Could be replaced if a similar feature is adopted in default plugins. |

## Screenshots

![kakoune-sway](https://raw.githubusercontent.com/mreppen/kakoune-sway/master/screenshot.png)

## See also

- [rc/filetype/i3.kak](https://github.com/mawww/kakoune/blob/master/rc/filetype/i3.kak) - config highlighters

## Licence

MIT
