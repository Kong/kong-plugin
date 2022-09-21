#!/usr/bin/env bash
#
# * check that all lua files have the COPYRIGHT's sha in the header
#   * if not, add the content of ./COPYRIGHT-HEADER to each file
#
# * replace the LICENSE file from the root directory (if it exists)
#   with the content of ./EE-LICENSE (otherwise create it).
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
  echo "Replacing license"

  cat "$LOCAL_PATH/EE-LICENSE" > "$LOCAL_PATH/../LICENSE" || return 1
}

main() {

  add_copyright
  replace_license
  RET=$?

  return $RET

}

main
