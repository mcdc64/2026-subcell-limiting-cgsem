#!/usr/bin/env bash
#SBATCH --job-name=cases_run
#SBATCH -D .
#SBATCH --output=all_cases_logs_%j.out
#SBATCH --error=all_cases_logs_%j.err
#SBATCH --partition=standard-gpu 

CASES_TO_RUN=(1 2 3 4 5 6)
POLYNOMIAL_ORDERS=(3 4 5)

for d in "${CASES_TO_RUN[@]}"; do
    # delete all pre-existing results files
    rm -f cases/"$d"*/*/results*
    rm -f cases/"$d"*/*/*.dat
done

for d in cases/mms/cfl0.1/cube_*; do
    if [ -d "$d" ] && [ -f "$d/sim.sh" ]; then
        echo "Submitting job in $d"
        (
            cd "$d" || exit
            sbatch sim.sh
        )
    fi
done