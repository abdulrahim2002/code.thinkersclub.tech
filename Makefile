#!/bin/sh
# - Makes index for repositories in a single directory.
# - Makes static pages for each repository directory.
#
# NOTE, things to do manually (once) before running this script:
# - copy style.css, logo.png and favicon.png manually, a style.css example
#   is included.
#
# - write clone URL, for example "git://git.codemadness.org/dir" to the "url"
#   file for each repo.
# - write owner of repo to the "owner" file.
# - write description in "description" file.
#
# Usage:
# - mkdir -p htmldir && cd htmldir
# - sh example_create.sh

## check if stagit and stagit-index are installed
ifneq ($(shell which stagit 1>/dev/null 2>&1 && echo 0 || echo 1),0)
$(error stagit is not installed or properly configured)
endif

ifneq ($(shell which stagit-index 1>/dev/null 2>&1 && echo 0 || echo 1),0)
$(error stagit-index is not found)
endif

# path must be absolute.
repodir?="/var/www/domains/"
ifneq ($(shell echo $(repodir) | rev | cut -c1),/)
$(error  Please append "/" to $(repodir))
endif

curdir="$(PWD)"

all:
	## make index.
	stagit-index "${repodir}/"*/ > "${curdir}/index.html"
	# make files per repo
	for dir in $(shell echo ${repodir}*/); do \
		r=$$(basename "$${dir}"); \
		d=$$(basename "$${dir}" .git); \
		echo "$${d}..."; \
		mkdir -p "${curdir}/$${d}"; \
		cd "${curdir}/$${d}" && \
		stagit -c ".cache" -u "https://code.thinkersclub.tech/$${d}/" "${repodir}/$${r}" && \
		ln -sf log.html index.html && \
		ln -sf ../style.css style.css && \
		ln -sf ../logo.png logo.png && \
		ln -sf ../favicon.png favicon.png; \
	done
