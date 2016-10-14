NVCC=nvcc
ARCH=-arch sm_20
OMPOPTION= -Xcompiler -fopenmp

all:
	$(NVCC) $(ARCH) -o helloworld helloworld.cu
	$(NVCC) $(ARCH) -o GPUmatmul GPUmatmul.cu
	$(NVCC) $(ARCH) -o GPUmatmul_shared GPUmatmul_shared.cu
	$(NVCC) $(ARCH) $(OMPOPTION) -o omp_shared omp_shared.cu

