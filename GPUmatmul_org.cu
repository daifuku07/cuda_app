#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
#include <time.h>

const int N = 1024; // 正方行列のサイズを指定（N×N）
const int BLOCK = 16; // ブロックのサイズを指定

double cpuSecond();

__global__ void matrixMul(int *dMatA, int *dMatB, int *dMatC)
{
  int col = blockIdx.x * blockDim.x + threadIdx.x;
  int row = blockIdx.y * blockDim.y + threadIdx.y;
  int scan;
  int target = 0;

  // 行列の演算を行う
}

int main(int argc, char** argv)
{
    // 行列のサイズをバイト単位で算出
    int matrixSize = sizeof(unsigned int) * N * N;

    int test1, test2;

    double start;
    double gpucalctime;
    double cpucalctime;

    // ホスト側の行列変数設定
    int* hMatA;
    int* hMatB;
    int* hMatC;

    // 行列変数のメモリ確保
    hMatA = (int*)malloc(matrixSize);
    hMatB = (int*)malloc(matrixSize);
    hMatC = (int*)malloc(matrixSize);


    // 行列の初期値設定
    // mat[row][col] を一次元配列として格納
    int row, col, scan;
    srand((unsigned)time(NULL));
    for (row = 0; row < N; row++){
        for (col = 0; col < N; col++){
            hMatA[row * N + col] = rand() % (N * N);
            hMatB[row * N + col] = rand() % (N * N);
            hMatC[row * N + col] = 0;
        }
    }
    /* CPU側での処理時間計測 */
    start = cpuSecond();

    for (row = 0; row < N; row++) {
        for (col = 0; col < N; col++) {
            for (scan = 0; scan < N; scan++) {
                hMatC[row * N + col] += hMatA[row * N + scan] * hMatB[scan * N + col];
            }
        }
    }

    cpucalctime = cpuSecond() - start;


    test1 = hMatC[52];

    /* GPU側での処理時間計測 */
    // デバイス側の行列変数設定
    int* dMatA;
    int* dMatB;
    int* dMatC;

    // デバイスメモリ領域の確保
    cudaMalloc((void**)&dMatA, matrixSize);
    cudaMalloc((void**)&dMatB, matrixSize);
    cudaMalloc((void**)&dMatC, matrixSize);

    // GPU 乗算及び時間計測
    start = cpuSecond();

    // ホストからデバイスへの変数の受け渡し
    cudaMemcpy(dMatA, hMatA, matrixSize, cudaMemcpyHostToDevice);
    cudaMemcpy(dMatB, hMatB, matrixSize, cudaMemcpyHostToDevice);

    // ブロックサイズとグリッドサイズの設定
    dim3 block(BLOCK, BLOCK);
    dim3 grid( N / BLOCK, N / BLOCK);

    // カーネルの起動
    matrixMul<<<grid, block>>>(dMatA, dMatB, dMatC);
    cudaDeviceSynchronize();

    // 結果の領域確保とデバイス側からのメモリ転送
    cudaMemcpy(hMatC, dMatC, matrixSize, cudaMemcpyDeviceToHost);

    gpucalctime = cpuSecond() - start;

    test2 = hMatC[52];


    // 結果の出力
    printf("[CPU]calc exetime : %f s.\n", cpucalctime);
    printf("[GPU]calc exetime : %f s.\n", gpucalctime);
    printf("GPUはCPUの処理を　%f 倍高速化 \n",cpucalctime/gpucalctime);

    printf("配列52をみて演算結果の確認\n");
    printf("cpu %d , gpu %d \n", test1, test2);

    // ホスト・デバイスメモリの解放
    free(hMatA);
    free(hMatB);
    free(hMatC);
    cudaFree(dMatA);
    cudaFree(dMatB);
    cudaFree(dMatC);

    // 終了処理
    cudaDeviceReset();
    return 0;
}

/* 時間を秒で返す*/
double cpuSecond()
{
    struct timespec tp;
    clock_gettime(CLOCK_REALTIME, &tp);
    return((double)tp.tv_sec + (double)tp.tv_nsec * 1.e-9);
}
