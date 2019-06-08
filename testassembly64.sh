nasm -f elf64 pqnn64.nasm

for file in $(ls ./assembly64 | grep .nasm); do
    nasm -f elf64 ./assembly64/$file
done

sed -i '1s/.*/#include "pqnn64c.c"/' algorithm.c

a[0]="assembly64/accumulate64.o"
a[1]="assembly64/distance64.o"
a[2]="assembly64/divide64.o"
a[3]="assembly64/memset_float64.o"
a[4]="assembly64/objective64.o"
a[5]="assembly64/residual64.o"

gcc -O0 -m64 -mavx pqnn64.o ${a[*]} testassembly.c -o pqnn64c -lm

./pqnn64c $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 $14 $15 $16 $17 $18 $19 $20 $21 $22 $23 $24 $25 $26 $27 $28 $29 $30
