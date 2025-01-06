# Nom du programme
PROGRAM = ft_turing

# Fichiers sources
SRC = types.ml machine.ml parsing.ml ft_turing.ml main.ml

# Compilateur
OCAMLC = ocamlfind ocamlc
OCAMLOPT = ocamlfind ocamlopt
OCAMLDEP = ocamlfind ocamldep

# Fichiers objets
CMI = $(SRC:%.mli=%.cmi)
OBJS = $(SRC:.ml=.cmo)
OPTOBJS = $(SRC:.ml=.cmx)

LIBS = yojson

OCAMLIBS = -package yojson -linkpkg


all: test

check-prog:
	@echo "Checking if $(PROGRAM) already exists..."
	@if [ -f $(PROGRAM) ]; then \
		echo "$(PROGRAM) already exists. Please run 'make re' to rebuild."; \
		exit 1; \
	fi


test:
	@./make.sh

bash: check-prog depend $(PROGRAM)

$(PROGRAM): opt byt
	ln -s $(PROGRAM).byt $(PROGRAM)

opt: $(PROGRAM).opt
byt: $(PROGRAM).byt

.PHONY: check-tools
.PHONY: check-tools
check-tools:
	@echo "Checking for ocamlfind..."
	eval `opam config env`
	@if ! command -v ocamlfind &> /dev/null; then \
		echo "ocamlfind is missing. Installing..."; \
		opam install --yes ocamlfind; \
	else \
		echo "ocamlfind is already installed."; \
	fi

.PHONY: check-libs
check-libs: check-tools
	@opam install ocamlfind yojson
	eval `opam config env`
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

%.cmi: %.mli
	$(OCAMLC) $(FLAGS) -c $<

# For modules without .mli files
%.cmi: %.ml
	$(OCAMLC) $(FLAGS) -c $<

$(PROGRAM).opt: $(CMI) $(OPTOBJS)
	$(OCAMLOPT) $(OCAMLIBS) -o $(PROGRAM).opt $(OPTOBJS)

$(PROGRAM).byt: $(CMI) $(OBJS)
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
