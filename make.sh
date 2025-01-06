#!/bin/bash

eval `opam config env`

make fclean
make check-libs
make bash
echo -e "\n"
echo -e "\e[32mAvailable machine descriptions:\e[0m"
select machine_path in machine_description/*.json; do
    if [ -n "$machine_path" ]; then
        break
    else
        echo -e "\e[31m***/!\Invalid selection. Please try again./!\***\e[0m"
    fi
done
read -p $'\e[32mGive me input: \e[0m' input_value
./ft_turing "$machine_path" "$input_value"
