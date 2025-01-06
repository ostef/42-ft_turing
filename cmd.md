# commande pour compiler :
- ocamlc mon_programme.ml -o mon_programme.byte 
Le compilateur bytecode. Il produit un fichier .cmo (compiled module object) qui contient le code compilé. Ce fichier peut être exécuté par l'interpréteur OCaml.
ou
- ocamlopt mon_programme.ml -o mon_programme
Le compilateur natif. Il produit un fichier exécutable (souvent sans extension) qui est plus rapide à exécuter que le bytecode, mais la compilation prend généralement plus de temps.

-o: Spécifie le nom du fichier de sortie.
-I: Ajoute un répertoire à la liste des répertoires où chercher les fichiers d'interface (.cmi).
-c: Compile un fichier sans le lier avec les autres.
-package: Utilise un package OCaml.

# commande pour executer :
- ./mon_programme.byte
ou
- ./mon_programme

