/* -*- c++ -*- */

#define CUDA_EXAMPLE_API

%include "gnuradio.i"           // the common stuff

//load generated python docstrings
%include "cuda_example_swig_doc.i"

%{
#include "cuda_example/cuda_cpp_mul2.h"
%}

%include "cuda_example/cuda_cpp_mul2.h"
GR_SWIG_BLOCK_MAGIC2(cuda_example, cuda_cpp_mul2);
