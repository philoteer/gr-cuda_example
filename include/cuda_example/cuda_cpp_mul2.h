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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#ifndef INCLUDED_CUDA_EXAMPLE_CUDA_CPP_MUL2_H
#define INCLUDED_CUDA_EXAMPLE_CUDA_CPP_MUL2_H

#include <cuda_example/api.h>
#include <gnuradio/sync_block.h>

namespace gr {
  namespace cuda_example {

    /*!
     * \brief <+description of block+>
     * \ingroup cuda_example
     *
     */
    class CUDA_EXAMPLE_API cuda_cpp_mul2 : virtual public gr::sync_block
    {
     public:
      typedef boost::shared_ptr<cuda_cpp_mul2> sptr;

      /*!
       * \brief Return a shared_ptr to a new instance of cuda_example::cuda_cpp_mul2.
       *
       * To avoid accidental use of raw pointers, cuda_example::cuda_cpp_mul2's
       * constructor is in a private implementation
       * class. cuda_example::cuda_cpp_mul2::make is the public interface for
       * creating new instances.
       */
      static sptr make(int device_num, int vlen);
    };

  } // namespace cuda_example
} // namespace gr

#endif /* INCLUDED_CUDA_EXAMPLE_CUDA_CPP_MUL2_H */

