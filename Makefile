# Nom du programme
PROGRAM = ft_turing

# Fichiers sources
SRC = types.ml parsing.ml ft_turing.ml main.ml

# Compilateur
OCAMLC = ocamlfind ocamlc
OCAMLOPT = ocamlfind ocamlopt
OCAMLDEP = ocamlfind ocamldep

# Fichiers objets
OBJS = $(SRC:.ml=.cmo)
OPTOBJS = $(SRC:.ml=.cmx)

LIBS = yojson

OCAMLIBS = -package yojson -linkpkg

all: check-libs depend $(PROGRAM)

$(PROGRAM): opt byt
	ln -s $(PROGRAM).byt $(PROGRAM)

opt: $(PROGRAM).opt
byt: $(PROGRAM).byt

.PHONY: check-tools
.PHONY: check-tools
check-tools:
	eval $(opam config env)
	@echo "Checking for ocamlfind..."
	@if ! command -v ocamlfind &> /dev/null; then \
		echo "ocamlfind is missing. Installing..."; \
		opam install --yes ocamlfind; \
	else \
		echo "ocamlfind is already installed."; \
	fi

.PHONY: check-libs
check-libs:
	eval $(opam config env)
	@opam install ocamlfind yojson
	@echo "Checking for missing libraries..."
	@for lib in $(LIBS); do \
		if ! opam list --installed $$lib > /dev/null 2>&1; then \
			echo "$$lib is missing. Installing..."; \
			opam install $$lib; \
		else \
			echo "$$lib is already installed."; \
		fi \
	done

.ml.cmo:
	$(OCAMLC) $(OCAMLIBS) -c $<

.ml.cmx:
	$(OCAMLOPT) $(OCAMLIBS) -c $<

$(PROGRAM).opt: $(OPTOBJS)
	$(OCAMLOPT) $(OCAMLIBS) -o $(PROGRAM).opt $(OPTOBJS)

$(PROGRAM).byt: $(OBJS)
	$(OCAMLC) $(OCAMLIBS) -o $(PROGRAM).byt $(OBJS)

.SUFFIXES:
.SUFFIXES: .ml .mli .cmo .cmi .cmx

clean :
	rm -f *.cm[iox] *.o *~ .*~ #*#

fclean: clean
	rm -f $(PROGRAM) $(PROGRAM).opt $(PROGRAM).byt

depend: .depend
	$(OCAMLDEP) $(SRC) > .depend

re: fclean all

include .depend
# RESULT = ft_turing

# SOURCES = parsing.ml types.ml ft_turing.ml main.ml

# LIBS = yojson

# check-libs:
# 	@echo "Vérification des bibliothèques manquantes..."
# 	@for lib in $(LIBS); do \
# 		if ! opam list --installed $$lib > /dev/null 2>&1; then \
# 			echo "$$lib est manquant. Installation..."; \
# 			opam install $$lib; \
# 		else \
# 			echo "$$lib est déjà installé."; \
# 		fi \
# 	done

