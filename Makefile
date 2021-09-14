# Makefile for hg repo conversion.

PYTHON = python3
TOOL   = exporter

EXPORT  = $(TOOL)/exporter.py
AUTHORS = $(TOOL)/list-authors.py

REPOFILE = REPO.txt
JSONFILE = REPO.json
AUTHFILE = authors.txt

HGDIR  = repo-hg
GITDIR = repo-git

OPTS = --plugin-path plugins --plugin fix_comments

all: update

update:
	@ mkdir -p $(HGDIR) $(GITDIR)
	@ echo "{" > $(JSONFILE)
	@ cat $(REPOFILE) | while read name url; do			\
	    hgrepo=$(HGDIR)/$$name;    	    	 			\
	    gitrepo=$(GITDIR)/$$name; 	    	 			\
	    if test -d $$hgrepo; then					\
		hg -R $$hgrepo pull -u;					\
	    else      		      	   				\
		echo cloning $$url into $$name;				\
		(cd $(HGDIR) && hg clone $$url $$name);			\
	    fi;								\
	    echo "    \"$$hgrepo\": \"$$gitrepo\"" >> $(JSONFILE);	\
	done
	@ echo "}" >> $(JSONFILE)

export: $(AUTHFILE)
	$(PYTHON) $(EXPORT) $(JSONFILE) $(OPTS) -A $(AUTHFILE) --hg-hash

authors:
	@ rm -f authors.map
	$(PYTHON) $(AUTHORS) $(JSONFILE)

clean:; rm -f authors.map $(JSONFILE)
