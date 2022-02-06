#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include <unistd.h>

#define N  5
#define THINKING 0
#define HUNGRY 1
#define EATING 2
#define LEFT ( i + N - 1)%N
#define RIGHT ( i + 1 ) % N

struct shm {
	int state[N];
}*shared_memory;

int shm_ID;
int sem_ID;

void philosopher(int i);
void take_forks(int i);
void put_forks(int i);
void test(int i);
void up(int i);
void down(int i);

union semun {
    int              val;   
    struct semid_ds *buf;    
    unsigned short  *array; 
    struct seminfo  *__buf;  
};

union semun sem_all;

int Initialize_shared_memory(){
    shm_ID=shmget(IPC_PRIVATE, sizeof(*shared_memory), IPC_CREAT|0666);
    printf("Memory attached at shm_ID %d\n", shm_ID);
    shared_memory = (struct shm*)shmat(shm_ID, NULL, 0);
    if ( shared_memory != (void *)-1) printf("Shmat succeed\n");

    for(int i=0;i<N;i++) shared_memory->state[i]=HUNGRY;
    return shm_ID;
}
int initialize_sem_all(){
    sem_ID=semget(IPC_PRIVATE, N+1, IPC_CREAT|0666);
    
    sem_all.array=malloc(N+1 * sizeof(ushort));

    for(int i=0;i<N;i++) sem_all.array[i]=0; //semaphore Initialization
    sem_all.array[N]=1; //Mutex Initialization

    if ( semctl(sem_ID, 0, SETALL, sem_all) > -1)printf("Semaphore initiated\n");
    return sem_ID;
}



void philosopher(int i) {
   while (1) {
      sleep(1);
      printf ("Philosopher[%d] is thinking.\n", getpid());
      take_forks(i);
      sleep(5);
      printf ("Philosopher[%d] is eating.\n", getpid());
      put_forks(i);
   }
}

void take_forks(int i) {
   down(N);
   shared_memory->state[i] = HUNGRY;
   test(i);
   up(N);
   down(i);
}

void put_forks(int i) {
   down(N);
   shared_memory->state[i] = THINKING;
   test(LEFT);
   test(RIGHT);
   up(N);
}

void test(int i) {
   if (shared_memory->state[i] == HUNGRY &&
       shared_memory->state[LEFT] != EATING &&
       shared_memory->state[RIGHT] != EATING) {
      shared_memory->state[i] = EATING;
      up(i);
   }
}

void up(int i) {
   struct sembuf sem_up = { i, +1, SEM_UNDO};
   if(semop(sem_ID, &sem_up, 1) < 0) {
      perror("up"); 
      exit(1);
   }
}

void down(int i) {
   struct sembuf sem_down = { i, -1, SEM_UNDO};
   if(semop(sem_ID, &sem_down, 1) < 0) {
      perror("down"); 
      exit(1);
   }
}


int main()
{
    int count=0,status;
    Initialize_shared_memory();
    sleep(1);
    initialize_sem_all();


    pid_t pid[N];
    for(int i=0;i<N ;i++){
        pid[i] = fork();	
        if (pid[i]==0){
           philosopher(i);

        }else if(pid[i]<0){
            printf("Error: Failed to create child process\n");
            kill(0,SIGTERM);
            exit(1);
        }
        sleep(1);
    }
    
    
    while(wait(&status) != -1 || errno != ECHILD){
        ++count;
    }
    printf("All [%d] Philosophers has parent parent[%d] with status [%d]\n",count,getpid(),status);
    
    return 0;
}

