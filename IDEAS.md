# Plugin improvements

* do not maintain a versionstring in git
* have the plugin version exclusively driven by git tags
* add docs and docstrings
also
* share code via a submodule
  * unify changelog generation
    * https://www.gnu.org/prep/standards/html_node/Style-of-Change-Logs.html#Style-of-Change-Logs
  * plugin wide git hooks
  * unified luacheck files for consistent syntax style
  * unified busted files for consistenst test output
    * can be used to analyze mass test output
* excessive use of `make` allows to have a simpified and uniform cli for plugins
  * install
  * bump
  * lint
  * release
  * docs
  * ...


# cons

* maintaining a version in various places sucks
* 