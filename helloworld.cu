#include <stdio.h>

__global__ void helloFromGPU()
{
  printf("Hello World from GPU! thread\n");
}

int main(int argc, char ** argv)
{
  printf("Hello World from CPU!\n");
  dim3 block(10,1);
  dim3 grid(1,1);
  helloFromGPU <<<grid,block>>>();
  cudaDeviceReset();
  return 0;
}
