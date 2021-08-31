# https://swaywm.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# see also: tmux.kak

hook global ModuleLoaded wayland %{
  try %{
    eval %sh{ [ -z "$SWAYSOCK" ] && echo fail " " }
    require-module sway
  }
}


provide-module sway %{

## Temporarily override the default client creation command
define-command -hidden -params 1.. sway-new-impl %{
  evaluate-commands %sh{
    if [ -z "$kak_opt_termcmd" ]; then
      echo "fail 'termcmd option is not set'"
      exit
    fi
    sway_split="$1"
    shift
    # clone (same buffer, same line)
    cursor="$kak_cursor_line.$kak_cursor_column"
    kakoune_args="-e 'execute-keys $@ :buffer <space> $kak_buffile <ret> :select <space> $cursor,$cursor <ret>'"
    {
      # https://github.com/sway/issues/1767
      [ -n "$sway_split" ] && swaymsg "split $sway_split" < /dev/null > /dev/null 2>&1 &
      echo terminal "kak -c $kak_session $kakoune_args"
    }
  }
}

define-command sway-new-down -docstring "Create a new window below" %{
  sway-new-impl v 
}

define-command sway-new-up -docstring "Create a new window below" %{
  sway-new-impl v :nop <space> '%sh{ swaymsg move up }' <ret>
}

define-command sway-new-right -docstring "Create a new window on the right" %{
  sway-new-impl h
}

define-command sway-new-left -docstring "Create a new window on the left" %{
  sway-new-impl h :nop <space> '%sh{ swaymsg move left }' <ret>
}

define-command sway-new -docstring "Create a new window in the current container" %{
  sway-new-impl ""
}

# Suggested aliases

alias global new sway-new

declare-user-mode sway
map global sway n :sway-new<ret> -docstring "new window in the current container"
map global sway h :sway-new-left<ret> -docstring '← new window on the left'
map global sway l :sway-new-right<ret> -docstring '→ new window on the right'
map global sway k :sway-new-up<ret> -docstring '↑ new window above'
map global sway j :sway-new-down<ret> -docstring '↓ new window below'

# Suggested mapping

#map global user 3 ': enter-user-mode sway<ret>' -docstring 'sway…'

}
