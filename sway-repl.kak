# Sway REPL support

hook global ModuleLoaded sway %{
  require-module sway-repl
}

provide-module sway-repl %{

declare-option -docstring "window id of the REPL window" str sway_repl_id

define-command -docstring %{
      sway-repl [<arguments>]: create a new window for repl interaction
          All optional parameters are forwarded to the new window
} \
  -params .. \
  -shell-completion \
  sway-repl %{ wayland-terminal sh -c %{
    winid=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | .id')
    printf "evaluate-commands -try-client $1 \
      'set-option current sway_repl_id ${winid}'" | kak -p "$2"
    shift 2;
    [ "$1" ] && "$@" || "$SHELL"
  } -- %val{client} %val{session} %arg{@}
}

define-command -params .. \
  -docstring %{sway-send-text [text]: Send text to the REPL window.
  [text]: text to send instead of selection.
  Switches:
	-send-enter Send an <enter> keystroke after the text.} \
  sway-send-text %{
    nop %sh{
      paste_keystroke="-M shift -k insert -m shift"

	    if [ $# -ge 1 ]; then
	    	case "$1" in
	    		-send-enter) shift; paste_keystroke="$paste_keystroke -k return";
    		esac
    	fi
    	
      if [ $# -eq 0 ]; then
        text="$kak_selection"
      else
        text="$*"
      fi

      cur_id=$(swaymsg -t get_tree | jq -r "recurse(.nodes[]?) | select(.focused == true).id")
      swaymsg "[con_id=${kak_opt_sway_repl_id}] focus" &&
      echo -n "$text" | wl-copy --type text/plain --paste-once --primary &&
      wtype $paste_keystroke -s 100 >/dev/null 2>&1 &&
      swaymsg "[con_id=$cur_id] focus"
    }
  }



evaluate-commands %sh{
    if ! { command -v wtype && command -v jq && command -v wl-copy && command -v wl-paste; } >/dev/null
    then echo define-command sway-send-text %{ fail "wtype, jq, or wl-clipboard missing" }
    else
      echo "alias global repl sway-repl"
      echo "alias global send-text sway-send-text"
    fi
  }
}
