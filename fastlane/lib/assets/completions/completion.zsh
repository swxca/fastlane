_fastlane_complete() {
  local word completions
  word="$1"

  # look for Fastfile either in this directory or fastlane/ then grab the lane names
  if [[ -e "Fastfile" ]] then
    completions=`cat Fastfile | grep "lane \:" | awk -F ':' '{print $2}' | awk -F ' ' '{print $1}'`
  elif [[ -e "fastlane/Fastfile" ]] then
    completions=`cat fastlane/Fastfile | grep "lane \:" | awk -F ':' '{print $2}' | awk -F ' ' '{print $1}'`
  fi

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _fastlane_complete fastlane
