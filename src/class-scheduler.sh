#!/bin/bash

# This script runs the class scheduler using all available constraints and
# returns a nicely formatted output for the user.

# Useful directories
BASE_DIR=$(dirname "$0")
CONSTRAINTS_DIR="${BASE_DIR}/constraints"
INPUTS_DIR="${BASE_DIR}/static-input"

# Parsers
OUTPUT_PARSER=$(find "$BASE_DIR" -name "clingo_output_parser.py")
INPUT_PARSER=$(find "$BASE_DIR" -name "parser-input-semestral.py")

# Clingo input
BASIC_CONSTRAINTS="$CONSTRAINTS_DIR/basic_constraints.lp"
HARD_CONSTRAINTS=$(find "$CONSTRAINTS_DIR" -name "hc*[0-9].lp")
SOFT_CONSTRAINTS=$(find "$CONSTRAINTS_DIR" -name "sc*[0-9].lp")
MINIMIZE_SC="$CONSTRAINTS_DIR/minimize_sc.lp"
PYTHON_OPS="$CONSTRAINTS_DIR/python_utils.lp"
SC_METRICS="$CONSTRAINTS_DIR/sc_metrics.lp"
WEIGHT_CONFIG="$BASE_DIR/weight_config.lp"
INPUT=$(find "$INPUTS_DIR" -name "*.lp")
SEMESTER_INPUT=$(mktemp "class-scheduler-semester-input-XXXXXXXX")

CLINGO_FLAGS=("--quiet=1" "--opt-mode=optN" "--time-limit=120")

# Output type option values
OUTPUT_TABLE=0
OUTPUT_CSV=1
OUTPUT_BOTH=2

# Colors
COLOR_RED="\e[31m"
COLOR_YELLOW="\e[33m"
COLOR_CLEAR="\e[0m"

# Print program's usage
usage() {
    cat <<EOF
USAGE:
    class-scheduler -w <workload-csv> -t <teacher-schedule-csv> [OPTIONS]

REQUIRED PARAMS:
    -t | --teacher-schedule-csv <path>: CSV with teacher's semestral schedule
    -w | --workload-csv <path>: CSV with current semester workload

OPTIONS:
    -h | --help: print this help message
    -n | --num-models <number>: number of models to be generated, defaults to 1
    -o | --output-type <table|csv|both>: output style for the generated schedules
EOF
}

# Pretty print errors
# Args:
#   $1 -> error message
err() {
    echo -e "${COLOR_RED}ERR: $1${COLOR_CLEAR}"
}

# Pretty print warnings
# Args:
#   $1 -> warning message
warn() {
    echo -e "${COLOR_YELLOW}WARN: $1${COLOR_CLEAR}"
}

# Parse CLI args
num_models=1
output_type=$OUTPUT_TABLE
teacher_schedule_csv=""
workload_csv=""

while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
        usage
        exit 0
        ;;
    -n | --num-models)
        num_models="$2"
        shift
        shift
        ;;
    -o | --output-type)
        case "$2" in
        csv) output_type=$OUTPUT_CSV ;;
        table) output_type=$OUTPUT_TABLE ;;
        both) output_type=$OUTPUT_BOTH ;;
        *)
            err "bad option for flag --output-type (-o). Expected one of 'csv', 'table' or 'both'"
            exit 1
            ;;
        esac
        shift
        shift
        ;;
    -t | --teacher-schedule-csv)
        teacher_schedule_csv="$2"
        shift
        shift
        ;;
    -w | --workload-csv)
        workload_csv="$2"
        shift
        shift
        ;;
    -*)
        warn "unknown option '$1'."
        shift
        ;;
    *)
        echo default
        exit 1
        ;;
    esac
done

# Asserts that both CSVs where received
if [ -z "$teacher_schedule_csv" ]; then
    err "missing CSV input with teacher's schedule."
    usage
    exit 1
fi

if [ -z "$workload_csv" ]; then
    err "missing CSV input with semester workload."
    usage
    exit 1
fi

# Parse semester input
python3 "$INPUT_PARSER" "$teacher_schedule_csv" "$workload_csv" stdout >"$SEMESTER_INPUT"

# Runs the clingo interpreter
clingo "${CLINGO_FLAGS[@]}" "$num_models" \
    "$MINIMIZE_SC" \
    "$PYTHON_OPS" \
    "$WEIGHT_CONFIG" \
    "$BASIC_CONSTRAINTS" \
    $HARD_CONSTRAINTS \
    $SOFT_CONSTRAINTS \
    $SC_METRICS \
    $INPUT \
    "$SEMESTER_INPUT" |
    python3 "$OUTPUT_PARSER" "$output_type"
