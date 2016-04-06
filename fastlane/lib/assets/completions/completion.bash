_fastlane_complete() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"
  local completions=""

  # look for Fastfile either in this directory or fastlane/ then grab the lane names
  if [[ -e "Fastfile" ]]; then
    completions=`cat Fastfile | grep "lane \:" | awk -F ':' '{print $2}' | awk -F ' ' '{print $1}'`
  elif [[ -e "fastlane/Fastfile" ]]; then
    completions=`cat fastlane/Fastfile | grep "lane \:" | awk -F ':' '{print $2}' | awk -F ' ' '{print $1}'`
  fi

  COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}

complete -F _fastlane_complete fastlane
