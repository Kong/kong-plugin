SEMVER_SCRIPT=./pluginutils/semver.sh


SHELL            =  bash
GIT              =  git
GIT_TAG			 =  $(GIT) tag
GIT_PUSH		 =  $(GIT) push
GIT_ORIGIN       =  'origin'
M4               =  m4


# Determines the plugin name by its current base directory name
PLUGIN_NAME := $(shell basename $(CURDIR))
# Queries for the latest tag
PLUGIN_VERSION := $(shell $(SEMVER_SCRIPT))
# Compares the latest tag against HEAD to determine the patch offset
PLUGIN_VERSION_OFFSET := $(shell git log $(PLUGIN_VERSION)..HEAD --oneline | wc -l)
# Arguments to m4, expand at will
M4_ARGS := -D PLUGIN_VERSION=$(PLUGIN_VERSION) -D PLUGIN_NAME=$(PLUGIN_NAME) -D PLUGIN_VERSION_OFFSET=$(PLUGIN_VERSION_OFFSET)
# Template filename
ROCKSPEC_M4_TEMPLATE := kong-plugin.rockspec.m4
# Target rockspec filename
ROCKSPEC_TARGET := "kong-plugin-$(PLUGIN_NAME)-$(PLUGIN_VERSION)-$(PLUGIN_VERSION_OFFSET).rockspec"

usage:
	@echo "Usage:"
	@echo -e "\tmake install\t Constructs a rockspec for the latest available version and runs 'luarocks make'"
	@echo -e "\tmake release\t level=patch|minor|major\n\t\t\t Tags the current HEAD and pushes a annotated tag to git" 
	@echo -e "\tmake pubrelease\t level=patch|minor|major\n\t\t\t In addition to 'release' upload it to luarocks public rocks repository" 
	@echo -e "\tmake test\t run pongo"
	@echo -e "\tmake version\t prints the current version of the plugin"
	@echo -e "\tmake clean\t cleans the repository from unwanted files"

version:
	@echo "version: $(PLUGIN_VERSION)"

plugin-name:
	@echo "plugin_name: $(PLUGIN_NAME)"

test:
	# This can change once we have a good way to run this in gojira with different versions.
	@echo "running pongo.."
	pongo run
	pongo down

make-rockspec:
	@echo "Generating rockspec"
	$(M4) $(M4_ARGS) $(ROCKSPEC_M4_TEMPLATE) > $(ROCKSPEC_TARGET)
	luarocks lint $(ROCKSPEC_TARGET)

install: make-rockspec
	@echo "installing $(PLUGIN_NAME)"
	luarocks make

release:
# conditionals are weird in gMake.. improve this!
ifeq ($(level), patch)
	$(eval NEW_VER := $(shell ($(SEMVER_SCRIPT) $(level))))
else ifeq ($(level), major)
	$(eval NEW_VER := $(shell ($(SEMVER_SCRIPT) $(level))))
else ifeq ($(level), minor)
	$(eval NEW_VER := $(shell ($(SEMVER_SCRIPT) $(level))))
else
	@echo -e "\nGive a parameter to release. i.e. 'make release level=patch|minor|major'"
	false
endif
	@echo "$(GIT_TAG) -a $(NEW_VER) -m 'release $(NEW_VER)'"
	@echo "$(GIT_PUSH) $(GIT_ORIGIN) $(NEW_VER)"

pubrelease: release
	@echo "TODO: stop when is private"
	@echo "luarocks upload $(ROCKSPEC_TARGET)"
	false

clean:
	@echo "Cleaning non-generic rockspec"
	# This is owned by root..Add sudo checks
	$(shell rm -rf servroot/)
	$(shell rm  *.rockspec)
	@echo "todo"

.PHONY: usage
