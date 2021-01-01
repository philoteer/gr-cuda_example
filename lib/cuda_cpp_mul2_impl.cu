/* -*- c++ -*- */
/*
 * Copyright 2020 gr-cuda_example author.
 *
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.	If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gnuradio/io_signature.h>
#include "cuda_cpp_mul2_impl.cuh"

__global__ void cuda_kernel(float * in, float* out, size_t num_samples) {

	
	//get position
	const int pos = (threadIdx.x + (blockIdx.x * blockDim.x));
	
	if (pos < num_samples) 
	{
		out[pos*2] = in[pos*2] * 2;	//I
		out[pos*2+1] = in[pos*2+1] * 2;	//Q (you can use cuComplex.h also; with an assumption that gr_complex and cuFloatComplex uses similar data structure (I/Q interleaved)
	}


}

namespace gr {
	namespace cuda_example {

		cuda_cpp_mul2::sptr
		cuda_cpp_mul2::make(int device_num, int vlen)
		{
			return gnuradio::get_initial_sptr
				(new cuda_cpp_mul2_impl(device_num, vlen));
		}


		/*
		 * The private constructor
		 */
		cuda_cpp_mul2_impl::cuda_cpp_mul2_impl(int device_num, int _vlen)
			: gr::sync_block("cuda_cpp_mul2",
							gr::io_signature::make(1, 1, sizeof(gr_complex) * _vlen),
							gr::io_signature::make(1, 1, sizeof(gr_complex) * _vlen))
		{
			vlen = _vlen;
			threads.x = 512;	//change ths as needed
			threads.y = 1;
			
			blocks.x = (vlen) / (threads.x);
			threads.y = 1;

			//set CUDA device
			cudaStatus = cudaSetDevice(device_num);
			if (cudaStatus != cudaSuccess) {
				fprintf(stderr, "cudaSetDevice failed!	Do you have a CUDA-capable GPU installed?");

			}

			// Allocate GPU buffers for the input	and output arrays
			cudaStatus = cudaMalloc((void**)&dev_input,	vlen * sizeof(gr_complex));
			if (cudaStatus != cudaSuccess) {
				fprintf(stderr, "cudaMalloc failed!");

			}

			cudaStatus = cudaMalloc((void**)&dev_output, vlen * sizeof(gr_complex));
			if (cudaStatus != cudaSuccess) {
				fprintf(stderr, "cudaMalloc failed!");

			}


		}

		/*
		 * Our virtual destructor.
		 */
		cuda_cpp_mul2_impl::~cuda_cpp_mul2_impl()
		{
		}

		int
		cuda_cpp_mul2_impl::work(int noutput_items,
				gr_vector_const_void_star &input_items,
				gr_vector_void_star &output_items)
		{
			//*in: input data buffer; *out: output data buffer; ring-buffer like implementation (internally)
			const gr_complex *in = (const gr_complex *) input_items[0];
			gr_complex *out = (gr_complex *) output_items[0];

			//for each vector:
			for(int i=0; i < noutput_items; i++)
			{
				//copy data to CUDA device
				cudaStatus = cudaMemcpy(dev_input, (in+i*vlen), vlen * sizeof(gr_complex), cudaMemcpyHostToDevice);
				if (cudaStatus != cudaSuccess) {
					fprintf(stderr, "cudaMemcpy failed!");
				}
				
				//run the CUDA kernel
				cuda_kernel << <blocks, threads >> > (dev_input, dev_output, vlen);
					
				//handle errors
				cudaStatus = cudaGetLastError();
				if (cudaStatus != cudaSuccess) {
					fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
				}
				
				// cudaDeviceSynchronize waits for the kernel to finish, and returns
				// any errors encountered during the launch.
				cudaStatus = cudaDeviceSynchronize();
				if (cudaStatus != cudaSuccess) {
					fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
				}
				
				//copy data from the CUDA device back to GNU Radio
				cudaStatus = cudaMemcpy((out+i*vlen), dev_output, vlen * sizeof(gr_complex), cudaMemcpyDeviceToHost);
				if (cudaStatus != cudaSuccess) {
					fprintf(stderr, "cudaMemcpy failed!");
				}

			}
			
			//clean-up
			return noutput_items;

		}

	} /* namespace cuda_example */
} /* namespace gr */

