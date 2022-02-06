#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <errno.h>

//Please comment the "#define WITH_SIGNALS" to run the code without signals 
#define WITH_SIGNALS

#define NUM_CHILD  5

int marker=0;

void sig_handler(int sig){
	marker=1;
	printf("Received keyboard interrupt \n");
}
void sigterm_handler(int sig){
	printf("child[%d]: received SIGTERM signal, terminating \n",getpid());
}


int main(){
    #ifdef WITH_SIGNALS
    
        for(int i=1;i<NSIG ;i++){
            signal(i, SIG_IGN);
        }
        signal(SIGCHLD, SIG_DFL);
        signal(SIGINT, sig_handler);

        int count=0,status;
        pid_t pid[NUM_CHILD];

        for(int i=0;i<NUM_CHILD ;i++){
            if (marker==1) {
                kill(0,SIGTERM);
                printf("parent[%d]: sending SIGTERM signal\n", getpid());
                break;
            }
            pid[i] = fork();	
            if (pid[i]==0){
                signal(SIGINT, SIG_IGN);
                signal(SIGTERM, sigterm_handler);
                printf("child[%d] created with parent[%d]\n",getpid(),getppid());
                sleep(10);
                printf("Finished child[%d] with parent[%d]\n",getpid(),getppid());
                exit(0);
            }else if(pid[i]<0){
                printf("Error: Failed to create child process\n");
                kill(0,SIGTERM);
                exit(1);
            }
            sleep(1);
        }
        printf("All child processes are created with parent[%d]\n",getpid());

        while(wait(&status) != -1 || errno != ECHILD){
            ++count;
        }
        printf("All [%d/%d] child processes has completed Execution with parent[%d] with exit code[%d]\n",count,NUM_CHILD ,getpid(),status);
        printf("With  Signals");
        for(int i=1;i<NSIG ;i++){
            signal(i, SIG_DFL);
        }
    #else
        int count=0,status;
        pid_t pid[NUM_CHILD];
        for(int i=0;i<NUM_CHILD ;i++){
            pid[i] = fork();	
            if (pid[i]==0){
                printf("child[%d] created with parent[%d]\n",getpid(),getppid());
                sleep(10);
                printf("Finished child[%d] with parent[%d]\n",getpid(),getppid());
                exit(0);
            }else if(pid[i]<0){
                printf("Error: Failed to create child process\n");
                kill(0,SIGTERM);
                exit(1);
            }
            sleep(1);
        }
        printf("All child processes are created with parent[%d]\n",getpid());

        while(wait(&status) != -1 || errno != ECHILD){
            ++count;
        }
        printf("All [%d] child processes has completed Execution with parent[%d] with status [%d]\n",count,getpid(),status);
        printf("Without  Signals");
    
    #endif

    return 0;
}