#!/bin/bash

# internsctl - Custom Linux command for interns
# Version: v0.1.1

function show_manual() {
    echo "internsctl(1) - Custom Linux command for interns"
    echo "==============================================="
    echo "NAME"
    echo "       internsctl - Perform custom operations"
    echo ""
    echo "SYNOPSIS"
    echo "       internsctl [OPTIONS]"
    echo ""
    echo "DESCRIPTION"
    echo "       internsctl is a custom Linux command designed for interns"
    echo ""
    echo "OPTIONS"
    echo "       --help      Show this help message"
    echo "       --version   Show version information"
    echo "       user create <username>   Create a new user"
    echo "       user list                 List all regular users"
    echo "       user list --sudo-only     List users with sudo permissions"
    echo ""
    echo "EXAMPLES"
    echo "       internsctl operation1"
    echo "       internsctl operation2"
}

function show_help() {
    echo "Usage: internsctl [options]"
    echo "Options:"
    echo "  --version                           ==>Show version information"
    echo "  chmod +x internsctl.sh              ==>Following command grant execution permission"
    echo "  cpu getinfo                         ==>Show cpu information"
    echo "  memory getinfo                      ==>Show memory information"
    echo "  user create <write your username>   ==> Create a new user"
    echo "  user list                           ==>List all regular users"
    echo "  user list --sudo-only               ==>List users with sudo permissions"
    echo "  file getinfo <file-name>            ==>This will provide file information"
    echo "  operation1                          ==>Perform operation 1"
    echo "  operation2                          ==>Perform operation 2"
    
}

function show_version() {
    echo "internsctl v0.1.1"
}

function perform_operation1() {
    echo "Performing Operation 1"
    # Add your logic for operation 1 here
}

function perform_operation2() {
    echo "Performing Operation 2"
    # Add your logic for operation 2 here
}

function get_cpu_info() {
    echo "CPU Information:"
    wmic cpu get caption,deviceid,description,manufacturer,maxclockspeed,numberofcores,numberoflogicalprocessors
}

function get_memory_info() {
    echo "Memory Information:"
    wmic os get FreePhysicalMemory,TotalVisibleMemorySize,FreeVirtualMemory,TotalVirtualMemorySize
}

function create_user() {
    if [ -z "$2" ]; then
        echo "Error: Please provide a username. Usage: 'internsctl user create <username>'"
        exit 1
    fi

    username="$2"
    echo "Creating user: $username"

    # Create a user and set a password using PowerShell with elevated privileges
    if ! powershell -Command "Start-Process powershell -ArgumentList '-Command', 'New-LocalUser -Name \"$username\" -Password (ConvertTo-SecureString -AsPlainText \"945098\" -Force); Set-LocalUser -Name \"$username\" -PasswordNeverExpires 1' -Verb RunAs"; then
        echo "Failed to create user."
        exit 1
    fi

    echo "User created successfully."
}


function list_users() {
    if [ "$2" = "--sudo-only" ]; then
        echo "Listing users with sudo permissions:"
    else
        echo "Listing all regular users:"
        net user
    fi
}

function get_file_info() {
    if [ -z "$2" ]; then
        echo "Error: Please provide a file name. Usage: 'internsctl file getinfo <file-name>'"
        exit 1
    fi

    file_name="$3"

    if [ -e "$file_name" ]; then
        echo "File: $file_name"
        echo "Access: $(stat -c %A "$file_name")"
        echo "Size(B): $(stat -c %s "$file_name")"
        echo "Owner: $(stat -c %U "$file_name")"
        echo "Modification Time: $(stat -c %y "$file_name")"
    else
        echo "Error: File '$file_name' not found."
        exit 1
    fi
}

function get_file_info() {
    if [ -z "$2" ]; then
        echo "Error: Please provide a file name. Usage: 'internsctl file getinfo [options] <file-name>'"
        exit 1
    fi

    file_name="$4"

    if [ ! -e "$file_name" ]; then
        echo "Error: File '$file_name' not found."
        exit 1
    fi

    while [ "$#" -gt 0 ]; do
        case "$3" in
            --size | -s)
                echo "File Size:            $(stat -c %s "$file_name")"
                break
                ;;
            --permissions | -p)
                echo "Permission:           $(stat -c %A "$file_name")"
                break
                ;;
            --owner | -o)
                echo "Owner Name:           $(stat -c %U "$file_name")"
                break
                ;;
            --last-modified | -m)
                echo "Last Modified Date:   $(stat -c %y "$file_name")"
                break
                ;;
            *)
                # Unknown option
                echo "Error: Unknown option '$1'"
                exit 1
                ;;
        esac
        shift
    done
}




# Main function
function main() {
    case "$1" in
        "cpu")
            case "$2" in
                "getinfo")
                    get_cpu_info
                    ;;
                *)
                    echo "Invalid command. Use 'internsctl cpu getinfo' for CPU information."
                    exit 1
                    ;;
            esac
            ;;
        "memory")
            case "$2" in
                "getinfo")
                    get_memory_info
                    ;;
                *)
                    echo "Invalid command. Use 'internsctl memory getinfo' for memory information."
                    exit 1
                    ;;
            esac
            ;;
        "user")
            case "$2" in
                "create")
                    create_user "$@"
                    ;;
                "list")
                    list_users "$@"
                    ;;
                *)
                    echo "Invalid command. Use 'internsctl user create <username>' or 'internsctl user list [--sudo-only]'"
                    exit 1
                    ;;
            esac
            ;;
            
        "file")
            case "$2" in
                "getinfo")
                    get_file_info "$@"
                    ;;
                *)
                    echo "Invalid command. Use 'internsctl file --help' for usage instructions."
                    exit 1
                    ;;
            esac
            ;;
        "--help")
            show_help
            ;;
        "--version")
            show_version
            ;;
        "operation1")
            perform_operation1
            ;;
        "operation2")
            perform_operation2
            ;;
        *)
            echo "Invalid command. Use 'internsctl --help' for usage instructions."
            exit 1
            ;;
    esac
}

# Run the main function with provided arguments
if [ "$#" -eq 0 ]; then
    echo "Error: No arguments provided. Use 'internsctl --help' for usage instructions."
    exit 1
fi

main "$@"
