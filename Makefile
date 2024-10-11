# Nom du programme
PROGRAM = ft_turing

# Fichiers sources
SRC = types.ml ft_turing.ml main.ml

# Compilateur
OCAMLC = ocamlc
OCAMLOPT = ocamlopt
OCAMLDEP = ocamldep

# Fichiers objets
OBJS = $(SRC:.ml=.cmo)
OPTOBJS = $(SRC:.ml=.cmx)


all: depend $(PROGRAM)

$(PROGRAM): opt byt
	ln -s $(PROGRAM).byt $(PROGRAM)

opt: $(PROGRAM).opt
byt: $(PROGRAM).byt

.ml.cmo:
	$(OCAMLC) -c $<

.ml.cmx:
	$(OCAMLOPT) -c $<

$(PROGRAM).opt: $(OPTOBJS)
	$(OCAMLOPT) -o $(PROGRAM).opt $(OPTOBJS)

$(PROGRAM).byt: $(OBJS)
	$(OCAMLC) -o $(PROGRAM).byt $(OBJS)

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
# # Cibles
# .PHONY: check-tools
# .PHONY: check-tools
# check-tools:
# 	eval `opam config env`
# 	eval $(opam config env)
# 	@echo "Checking for ocamlfind..."
# 	@if ! command -v ocamlfind &> /dev/null; then \
# 		echo "ocamlfind is missing. Installing..."; \
# 		opam install --yes ocamlfind; \
# 	else \
# 		echo "ocamlfind is already installed."; \
# 	fi

# .PHONY: check-libs
# check-libs: check-tools
# 	@echo "Checking for missing libraries..."
# 	@for lib in $(LIBS); do \
# 		if ! opam list --installed $$lib > /dev/null 2>&1; then \
# 			echo "$$lib is missing. Installing..."; \
# 			opam install $$lib; \
# 		else \
# 			echo "$$lib is already installed."; \
# 		fi \
# 	done