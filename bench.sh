#!/bin/bash
#@author: Benjamin Tokgoez
#implemented for usage with remote postgresdbs

echo "Welcome to the pgbench auto-config"

echo "Please provide your database host (default localhost)"

read PGHOST

if test -z "$PGHOST"
then
    export PGHOST=$PGHOST
fi

echo "Please provide your postgres username"

read PGUSER

if test -z "$PGUSER"
then
        echo "you must provide a valid username"
else
        export PGUSER=$PGUSER
fi

echo "Please provide your database name (default postgres)"

read PGDATABASE

if test -z "$PGDATABASE"
then
        export PGDATABASE=postgres
else
        export PGDATABASE=$PGDATABASE
fi


echo "Please provide a number of worker threads (default 1)"

read workerthreads

if test -z "$workerthreads"
then
        export PGTHREADS=1
else
        export PGTHREADS=$workerthreads
fi
echo "Please provide a number of simulated clients (Should be a multitude of threads. Default 1)"

read pgclients

if test -z "$pgclients"
then
        export PGCLIENTS=1
else
        export PGCLIENTS=$pgclients
fi
echo "Please provide a number of transactions each client runs (default 10)"

read transactions

if test -z "$transactions"
then
        export PGTRANS=10
else
        export PGTRANS=$transactions
fi


echo summary:

echo "database host: $PGHOST, database user: $PGUSER, database name: $PGDATABASE, worker threads: $PGTHREADS, simulated clients: $PGCLIENTS, transactions per client: $PGTRANS"

read -p "Did you already initialized pgbench (pgbench -i)?  <y/N> " prompt
if [[ $prompt =~ [yY](es)* ]]
then
        echo ""
else 
        echo "Initializing pgbench with command: pgbench -i -h $PGHOST -U $PGUSER $PGDATABASE"
        pgbench -i 

fi

#TODO set vars as "global" env vars.

read -p "Continue with benchmark?  <y/N> " prompt
if [[ $prompt =~ [yY](es)* ]]
then
        echo "running command: pgbench -h $PGHOST -j$PGTHREADS -r -Mextended -n -c$PGCLIENTS -t$PGTRANS -U $PGUSER $PGDATABASE >> ./pgbench_results
 ... "

        echo "Benchmark-test time: $(date) against host: $PGHOST" >> ./pgbench_results
        start=$SECONDS
        pgbench -j$PGTHREADS -r -Mextended -n -c$PGCLIENTS -t$PGTRANS >> ./pgbench_results
        end=$SECONDS
        let diff=end-start
        echo "Output concatenated to file ./pgbench_results"
        echo "duration of execution: $diff seconds" >> ./pgbench_results
else 
        echo "cancel benchmark..."
fi

exit 0
