#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>

int n,r;
struct frame{
	char ack;
	int data;
	
}frm[10];
int sender(void);
void rec_vack(void);
void resend_sr(void);
void resend_gb(void);
void goback(void);
void selective(void);



int main(){
	int c;
	do{
		printf("\n \n 1.Selective repeat arq \n 2.Goback arq \n 3.Exit");
		printf("\n Enter your choice");
		scanf("%d",&c);
		switch(c){
			case 1:selective();break;
			case 2:goback();break;
			case 3:exit(0);break;
		}
				
	}
	while(c>=4);
	return 0;
}
void goback(){
	sender();
	rec_vack();
	resend_gb();
	printf("\n All the frames sent successfully \n");
	
}

void selective(){
	sender();
	rec_vack();
	resend_sr();
	printf("\n All the frames sent successfully \n");
	
}




int sender(){
	int i;
	printf("\n Enter the no of frames to be sent \n");
	scanf("%d",&n);
	for(i=1;i<=n;i++){
		printf("\n Enter data for frames[%d] \n",i);
		scanf("%d",&frm[i].data);
		frm[i].ack='y';

	}
	return 0;
	
}

void rec_vack(){
	int i;
	//int m;
	rand();
	r=rand() % n;
	//r=m%n;
	//printf("Random number is : %d",m);
	frm[r].ack='n';
	for(i=1;i<=n;i++){
		if (frm[i].ack=='n') printf("\n The frame number %d is not received \n",r);
		
	}
}

void resend_sr(){
	//int i;
	printf("\n resending frame %d",r);
	//for(i=r;i<=n;i++){
	sleep(2);
	frm[r].ack='y';
	printf("\n Received frame is %d",frm[r].data);
//}
}

void resend_gb(){
	int i;
	printf("\n Resending from frame %d",r);
	for(i=r;i<=n;i++){
		sleep(2);
		frm[i].ack='y';
		printf("\n Received data of frame %d is %d",i,frm[i].data);
		
		
	}
}
