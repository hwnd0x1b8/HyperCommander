#! /usr/bin/env bash

print_menu() {
    echo "------------------------------"
    echo "| Hyper Commander            |"
    echo "| 0: Exit                    |"
    echo "| 1: OS info                 |"
    echo "| 2: User info               |"
    echo "| 3: File and Dir operations |"
    echo "| 4: Find Executables        |"
    echo "------------------------------"
}

print_file_and_dir_operations_menu() {
    echo "---------------------------------------------------"
    echo "| 0 Main menu | 'up' To parent | 'name' To select |"
    echo "---------------------------------------------------"
}

print_file_operations_menu() {
    echo "---------------------------------------------------------------------"
    echo "| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
    echo "---------------------------------------------------------------------"
}

print_files() {
    local files=("$@")
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            echo "F ${file}"
        else
            echo "D ${file}"
        fi
    done
}

echo "Hello $USER!"
while :
do
    print_menu
    read -r option
    case "${option}" in
        0 )
            echo "Farewell!"
            break
            ;;
        1 )
            echo "$(uname -a)"
            ;;
        2 )
            echo "$(whoami)"
            ;;
        3 )
            while :
            do
                echo "The list of files and directories:"
                files=(*)
                print_files "${files[@]}"
                print_file_and_dir_operations_menu
                read -r operation
                if [[ -e "${operation}" ]]; then
                    if [[ -d "${operation}" ]]; then
                        cd ${operation}
                        files=(*)
                        print_files "${files[@]}"
                        print_file_and_dir_operations_menu
                    else
                        while :
                        do
                            print_file_operations_menu
                            read -r file_operation
                            case "${file_operation}" in
                                1 )
                                    rm "${operation}"
                                    echo "${operation} has been deleted."
                                    break
                                    ;;
                                2 )
                                    echo "Enter the new file name:"
                                    read -r new_file_name
                                    mv "${operation}" ${new_file_name}
                                    echo "${operation} has been renamed as ${new_file_name}"
                                    break
                                    ;;
                                3 )
                                    chmod 666 "${operation}"
                                    echo "Permissions have been updated."
                                    stat "${operation}"
                                    break
                                    ;;
                                4 )
                                    chmod 664 "${operation}"
                                    echo "Permissions have been updated."
                                    stat "${operation}"
                                    break
                                    ;;
                                0 | * )
                                    continue
                                    ;;
                            esac
                        done

                    fi
                else
                    case "${operation}" in
                        "up" )
                            cd ..
                            files=(*)
                            print_files "${files[@]}"
                            print_file_and_dir_operations_menu
                            ;;
                        "0" )
                            break
                            ;;
                        * )
                            echo "Invalid input!"
                            ;;
                    esac
                fi
            done
            ;;
        4 )
            echo "Enter an executable name:"
            read -r executable_name
            location=$(which "${executable_name}")
            if [[ -n "${location}" ]]; then
                echo "Located in: ${location}"
                echo "Enter arguments:"
                read -r executable_arguments
                result=$("${executable_name}" "${executable_arguments}")
                echo "${result}"
            else
                echo "The executable with that name does not exist!"
            fi
            ;;
        * )
            echo "Invalid option!"
    esac
done

