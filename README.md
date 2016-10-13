# cuda_app
行列演算演習用のリポジトリ

## answerフォルダ
### ビルド
$ make
###ファイルの説明
GPUmatmul.cu : GPUによる行列計算（ナイーブ）
GPUmatmul_shared.cu:GPUによる行列計算（シェアードメモリ）
omp_shared.cu:GPUmatmul_sharedのCPU部分をOpenMPにより並列化

###nvccによるコンパイル例
abc.cu からabcという実行ファイルを生成
nvcc -arch sm_20 -o abc abc.cu
