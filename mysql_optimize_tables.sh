#!/usr/bin/env bash

###############################################################################
# Display functions
###############################################################################

if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
   RED="$(tput setaf 1)"
   GREEN="$(tput setaf 2)"
   YELLOW="$(tput setaf 3)"
   BLUE="$(tput setaf 4)"
   BOLD="$(tput bold)"
   NORMAL="$(tput sgr0)"
else
   RED=""
   GREEN=""
   YELLOW=""
   BLUE=""
   BOLD=""
   NORMAL=""
fi

tell() {
  echo "${BLUE}|-- ${*}${NORMAL}"
  $* || {
    echo "${RED}Fail !" 1>&2 ;
    exit 1 ;
  }
}

explain() {
  echo "${YELLOW}${1}${NORMAL}"
}

success() {
  echo "${GREEN}${1}${NORMAL}"
}

error() {
  echo "${RED}${1}${NORMAL}"
}


###############################################################################
# Help function
###############################################################################
display_help() {
    explain "Usage: mysql_optimize_tables.sh [OPTIONS] database"
    echo ""
    explain "The following options may be given as the first argument:"
    echo "  --defaults-extra-file #   Read this file after the global files are read."
    #  echo "  --gzip-bin #              Gzip binary path."
    echo "  --help                    Display this help message and exit."
    echo "  -h, --host #              Connect to host."
    echo "  --mysqlcheck-bin #        MySQLCheck binary path. (mysqldump default)"
    echo "  -u, --user #              User for login if not current user."
    echo "  -p, --password #          Password to use when connecting to server.
                            If password is not given it's solicited on the tty."
}


###############################################################################
# VARIABLES
###############################################################################
MYSQLCHECK=mysqlcheck

# OPTIONS
MYSQLCHECKOPTIONS=""

###############################################################################
# OPTIONS
###############################################################################
while :
do
    case "$1" in
      --defaults-extra-file)
        # EXTRA FILE LIKE ~/my.cnf
        MYSQLCHECKOPTIONS="$MYSQLCHECKOPTIONS --defaults-extra-file=$2"
        shift 2
        ;;
      --help)
        # DISPLAY HELP
        display_help
        exit 0
        ;;
      -h | --host)
        MYSQLCHECKOPTIONS="$MYSQLCHECKOPTIONS -h $2"
        shift 2
        ;;
      --mysqlcheck-bin)
        MYSQLCHECK="$2"
        shift 2
        ;;
      -u | --user)
        MYSQLCHECKOPTIONS="$MYSQLCHECKOPTIONS -u $2"
        shift 2
        ;;
      -p | --password)
        MYSQLCHECKOPTIONS="$MYSQLCHECKOPTIONS -p$2"
        shift 2
        ;;
      --) # End of all options
        shift
        break
        ;;
      -*)
        error "Error: Unknown option: $1" >&2
        display_help
        exit 1
        ;;
      *)  # No more options
        break
        ;;
    esac
done

###############################################################################
# CHECK ARGS
###############################################################################
if test -z "$1"
then
    error "Usage: mysql_optimize_tables.sh [OPTIONS] database"  >&2
    echo "For more options, use $0 --help" >&2
    exit
fi

###############################################################################
# OPTIMIZE TABLES
###############################################################################
$MYSQLCHECK $MYSQLCHECKOPTIONS --optimize $1
