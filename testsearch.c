//Necessario per poter utilizzare la struttura params definita dal prof
#include "datatypes.h"


//Parametri ottenuti in input
params *input;


//------------------------------------METODI------------------------------------


// Funzione che quantizza il punto dell query.
int* quantize(int x){
	// Centroidi che quantizzano ciascuna porzione
	int* cents = (int*) malloc(m,sizeof(int))
	int centr;
	double dist,tmp;

	// Calcoliamo il centroide di ciascun sottogruppo
	for(int i=0;i<ns;i++){
		// Calcoliamo il centroide più vicino del sottogruppo
		centr = 0;
		dist = dist_cent(x,0,i);
		for(int j=1;j<k;j++){
			tmp = dist_cent(x,j,i);
			if(tmp < dist){
				centr = j;
				dist = tmp;
			}
			// Abbiamo trovato il centroide della porzione
			cents[i] = centr;
		}
	}
	return cents;
}

// Funzione che calcola la distanza tra il punto ed il centroide del del sottogruppo
// indicato attraverso l'input, in input si passano inoltre l'indirizzo di partenza
// del punto e quel centroide.
// Versione per il query set.
double dist_cent_qs(int point,int centr,int group){
	double sum,diff;

	for(int i=0;i<ns;i++){
		diff = qs[point*d+group*ns+i]-centroids[centr*d+group*ns+i];
		sum = diff*diff;
	}

	return sqrt(sum);
}



void testSearch(params* input2){
  printf("\n###########Chiamata a Funzione TestSearch############\n");
  /*
    Mettere qui tutto quello che serve per testare quanto scritto
  */

	//Collego l'input passato dal main con la struttura usata in questo codice
  input = input2;
}
