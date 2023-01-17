#!/usr/bin/env bash

# Parse script arguments
PARAMS=""
while (( "$#" )); do
  case "$1" in
    -u|--url)
      GIT_REPOT_URL="${2}"
      shift 2
      ;;
    -v|--version)
      MODULE_VERSION="${2}"
      shift 2
      ;;
    -h|--help)
      print_usage
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

eval set -- "$PARAMS"

# Define color codes
declare -r INFO="\e[32m"
declare -r ERROR="\e[31m"
declare -r DEFAULT="\e[0m"

# Define bash module dir
declare -r BASH_MODULE_DIR="${BASH_MODULE_DIR:=${HOME}/.local/lib/bash}"

# Get module name from git url
MODULE_NAME="$(basename "${GIT_REPOT_URL}" | sed 's/.git//')"
readonly MODULE_NAME

# Create temp directory to store git content
declare -r GIT_LOCAL_TEMP_DIR="/tmp/bash-module-${MODULE_NAME}"

# Define default module version
declare -r MODULE_VERSION="${MODULE_VERSION:=main}"

# Print script usage
function print_usage(){
  cat << EOF

Usage: $(basename "$0") [-u|--url] [-v|--version]

-u/--url: Define repository url.
-v/--version: Module version to download.

EOF

  exit 0
}

# Output log in info level
function log_info(){
  local mess="${1}"
  printf "[%b%s%b] - %b\n" "${INFO}" "INFO" "${DEFAULT}" "${mess}"
}

# Output log in error level
function log_error(){
  local mess="${1}"
  printf "[%b%s%b] - %b\n" "${ERROR}" "ERROR" "${DEFAULT}" "${mess}"
  exit 1
}

# Remove temporary files and directories
function cleanup(){
  rm -rf "${GIT_LOCAL_TEMP_DIR}"
}

# Run clean before exit
trap cleanup EXIT

# If git repo url is not define,
# stop with an error
[[ -z ${GIT_REPOT_URL} ]] && log_error "Git repot url unknown."

# Ensure module bash dir existe
if [[ ! -d "${BASH_MODULE_DIR}" ]];
then
  log_info "Create '${BASH_MODULE_DIR}' directory"
  mkdir -p "${BASH_MODULE_DIR}"
fi


log_info "Get ${MODULE_NAME} from ${GIT_REPOT_URL}"

# Clone git repository
echo
git clone --depth=1 "${GIT_REPOT_URL}" "${GIT_LOCAL_TEMP_DIR}"

# Switch to wanted version
(
cd "${GIT_LOCAL_TEMP_DIR}" || log_error "Failed to switch to ${GIT_LOCAL_TEMP_DIR} directory."
echo
git switch -c "${MODULE_VERSION}"
echo

# Move module to final bash module dir
log_info "Store module in ${BASH_MODULE_DIR}"
cp -u "${MODULE_NAME}.sh" "${BASH_MODULE_DIR}/"
)
