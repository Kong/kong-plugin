#!/usr/bin/env bash
#
# The script checks that all lua files have the COPYRIGHT's sha in the header.
# If not, it adds the copyright.
# It also removes the Apache LICENSE from the root directory.
#

LOCAL_PATH=$(dirname $(realpath $0))

function add_copyright {
  echo "Adding copyright headers"

  local ret=0
  local count=0
  local header="$LOCAL_PATH/COPYRIGHT-HEADER"
  local sha=$(shasum $header | cut -f1 -d' ')
  local eol="-- [ END OF LICENSE $sha ]"
  for f in $(find "." -type f -name "*.lua"); do
    grep -Fq "$sha" $f || {
      ret=1
      cat "$header" <(echo "$eol") <(echo) $f >${f}.new
      mv $f.new $f
      ((count++))
    }
  done

  [[ $ret -ne 0 ]] &&
    echo "Added headers to $count files."
}

function replace_license {
  echo "Removing Apache license"

  rm "$LOCAL_PATH/../LICENSE" || return 1
}

main() {

  add_copyright
  replace_license
  RET=$?

  return $RET

}

main
