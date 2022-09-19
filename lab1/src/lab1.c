#include <stdio.h>
#include <stdlib.h>


void cube(){
    int cube = 0b000000000000000000011111;  //部分积与乘数放在一起
    int sqrt = 0b0000000000011111;          //部分积与乘数放在一起
    int mul = 0b0001111100000000;
    for(int i=7; i>=0; i--){
        if(sqrt%2==1){                      //若最后一位是1
           sqrt = sqrt + mul;
        }
        sqrt = sqrt >> 1;
    }
    sqrt = sqrt + 0b000000000000000000000000;
    sqrt = sqrt << 8;
    for(int i=7; i>=0; i--){
        if(cube%2==1){
           cube = cube + sqrt;
        }
        cube = cube >> 1;
    }
    printf("%d\n",cube);
    return;
}


int main(){
    printf("my ID:200210231\n");
    cube();
    return 0;
}
