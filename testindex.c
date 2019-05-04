#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>

//Necessario per poter utilizzare la struttura params definita dal prof
#include "datatypes.h"



//Matrice che ogni riga rappresenta un punto e ogni colonna un centroide
//L'elemento m[i][j] rappresenta la distanza del punto i dal centroide j
MATRIX distances_from_centroids; //TODO Verificare se serve questa struttura

//Per ogni punto (riga) viene indicato il centroide più vicino e la distanza da stesso
//centroid_of_point[i][0] = centroide a minima distanza
//centroid_of_point[i][1] = distanza dal centroide
MATRIX centroid_of_point;


//Centroidi veri e propri codificati come i punti
MATRIX centroids;

//Parametri ottenuti in input
params *input;


//------------------------------------METODI------------------------------------

/**La funzione seguente seleziona k punti da usare come centroidi iniziali
 * COSTO: d+k*d
 * n =  numero di punti del data set
 * d = numero di dimensioni del data/query set
 * k =  numero di centroidi di ogni sotto-quantizzatore
 * k numeri casuali diversi da 0 a n incluso
 */
void generate_centroids(int n, int d, int k){

	int number,old_number,i,j;

	// Alloco la matrice dei centroidi
	centroids = alloc_matrix(k,d);

  //rand() function returns an integer value between 0 and RAND_MAX(32767)
	// TODO togliere per avere numeri sempre casuali:  srand(time(NULL));

	/**IDEA:
	  * divido gli n punti in k intervalli e ottengo un range di valori;
		* scelgo un numero casuale tra 0 e range e prendo il punto corrispondente;
		* nel caso peggiore viene scelto sempre il max del range e i punti restano sempre entro n;
		* i restanti punti li divido in k-1 intervalli ottenendo un nuovo range;
		* cosi facendo ottengo dei numeri casuali sempre diversi che coprono l'intervallo da  a n;
		*/

	old_number = rand()%(n/k);
	printf("Centroide 0 scelto il punto numero: %d\n",old_number);

	// Inseriamo il primo centroide nella matrice lungo la riga 0
	for(j=0;j<d;j++)
		centroids[j] = input->ds[old_number*d+j];

	int range;
	for(i=1;i<k;i++){
		range = (n-old_number)/(k-i);	//trovo il nuovo range tra cui scegliere i valori casuali
  	number = old_number+rand()%range+1; //seleziono un numero casuale nel range
		printf("Centroide %d scelto il punto numero: %d\n",i, number);

		// Inseriamo il centroide nella matrice
		for(j=0;j<d;j++)
			centroids[i*d+j] = input->ds[number*d+j];

		old_number = number;
 	}//for

	print_matrix(k, d, centroids);

	//TESTATO  	--> 	OK
}//generate_centroids



/** Metodo per calcolare la distanza tra due punti memorizzati row first order
	* COSTO: d
  * d = dimensione dei punti
	* TODO: applicare il loop vectorization cioè più operazioni nello stesso ciclo
  * Oppure più punti alla volta
  */
double distance(VECTOR puntoX, VECTOR puntoY, int d){
	double sum = 0;
	double diff = 0;
	for(int i=0;i<d;i++){
		diff = (puntoX[i]-puntoY[i]);
		sum+= diff*diff;
	}
	return sqrt(sum);
	//TESTATO  	--> 	OK
}//distance



/** La funzione seguente cerca i punti che appartengono ad ogni centroide
	* Logicamente divide lo spazio in celle di Voronoi
	* Per ogni punto del dataset, calcola la di stanza con tutti i centroidi
	* e sceglie la distanza minima
	* COSTO: n*c* O(distance)
  * n =  numero di punti del data set
  * d = numero di dimensioni del data/query set
  * k =  numero di centroidi di ogni sotto-quantizzatore
  * TODO: verificare se è possibile sfruttare gli indirizzi ed evitare l'uso
  *       del vettore punto
  */
void points_of_centroid(int n, int d, int k){

	//VECTOR punto = alloc_matrix(1,d);	// Alloco il vettore che conterrà di volta in volta il punto
	//Si può evitare dal momento che posso accedere ai singoli elementi
	//usando l'aritmetica dei puntatori

	double distanza;
	double minDist; //Distanza dal minimo centroide
	int minCentr;	//Centroide a minima distanza
	int i,j,c; //i = indice per i punti, j = indice per dimensioni, c = indice per centroidi

	for(i=0;i<n;i++){	//per ogni punto del dataset devo trovare il centroide più vicino

		/*
		for(j=0;j<d;j++)	//copio il punto dal dataset nel vettore punto
			punto[j] = input->ds[d*i+j];	// Dataset memorizzato per righe

			*/

		//Inizializzo con il primo punto e con la distanza da esso
		minDist = distance(input->ds+d*i, centroids, d);
		minCentr = 0;
		//printf("Distanza del punto %i dal centroide  0: %f\n", i, minDist);


		for(c=1;c<k;c++){ //Calcolo la distanza tra il punto attuale e ogni centroide

			/*for(j=0;j<d;j++)
				punto[j] = input->ds[d*i+j]; // Dataset memorizzato per righe
				*/

			distanza = distance(input->ds+d*i, centroids+d*c, d);
			//printf("Distanza del punto %i dal centroide %i: %f\n", i, c, distanza);

			if(distanza < minDist){
				minDist = distanza;
				minCentr = c;
			}//if
		}//for ogni centroide

		//Salvo i risultati trovati
		//printf("Distanza del punto %i dal centroide minimo %i: %f\n", i, minCentr, minDist);
		centroid_of_point[2*i] = minCentr;
		centroid_of_point[2*i+1] = minDist;
	}//for ogni punto

	// Liberiamo lo spazio (verificare se si può utilizzare la stessa funzione della matrice)
	//dealloc_matrix(punto);
	printf("Colonna 0: indice del vettore 'centroids' indicante il centroide più vicino al punto\n");
	printf("Colonna 1: distanza tra il punto e il centroide\n");
	print_matrix(input->n,2, centroid_of_point);

	//TESTATO  	--> 	OK
}//points_of_centroid






//Per  ogni punto si ha il centroide di appartenenza (q(x))

//Per ogni centroide bisogna trovare il punto medio e sostituirlo ai centroidi di partenza

//Ripetere finchè la distanza tra il centroide di prima e quello nuovo non è inferiore ad epsilon



void testIndex(params* input2){
  printf("\n###########Chiamata a Funzione TestIndex############\n");
  /*
    Mettere qui tutto quello che serve per testare quanto scritto

  */
	//Collego l'input passato dal main con la struttura usata in questo codice
  input = input2;

//---------------------------Dati piccoli per il test---------------------------
	for(int i=0; i<4; i++)
		for( int j=0; j<4; j++)
 			input->ds[i*4+j] = i+j;

	input->n = 4;
	input->d = 4;
	input->k = 2;

	print_matrix(4,4,input->ds);

  generate_centroids(input->n, input->d, input->k);
  //generate_centroids(100, 128, 10);	//Test


	//double x[4] = {1, 2, 3, 8};
	//double y[4] = {9, 8, 7, 6};
	//printf("Distanza: %f\n", distance(x, y,4) );

	centroid_of_point = alloc_matrix(input->n,2);

	//printf("%s\n", input->ds+2*1 );

	points_of_centroid(input->n, input->d, input->k);
	//points_of_centroid(100, 128, 10);	//Test

	//printf("Centroids: %f\n", *(centroids+128+3) );



}
