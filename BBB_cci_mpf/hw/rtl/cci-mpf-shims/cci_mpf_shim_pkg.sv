//
// Copyright (c) 2016, Intel Corporation
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// Neither the name of the Intel Corporation nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

package cci_mpf_shim_pkg;
    import cci_mpf_if_pkg::*;

    //
    // Shims that generate their own internal read and write traffic
    // need to tag the mdata field to track responses.  They set a
    // reserved mdata bit and may also set other mdata bits with
    // values from this enumeration in order to share the reserved
    // tag bit.
    //
    typedef enum logic [0:0] {
        CCI_MPF_SHIM_TAG_VTP,       // Page table walker
        CCI_MPF_SHIM_TAG_PWRITE     // Reads for partial line writes
    }
    t_cci_mpf_shim_mdata_tag;

    // A sub-field of mdata remains available to shims to manage multiple
    // outstanding requests.
    typedef logic [4:0] t_cci_mpf_shim_mdata_value;

    function automatic t_cci_mdata cci_mpf_setShimMdataTag(int reservedIdx,
                                                           t_cci_mpf_shim_mdata_tag tag,
                                                           t_cci_mpf_shim_mdata_value value);
        t_cci_mdata m = t_cci_mdata'(0);
        m[reservedIdx] = 1'b1;
        m[$bits(tag) +: $bits(value)] = value;
        m[0 +: $bits(tag)] = tag;

        return m;
    endfunction

    function automatic logic cci_mpf_testShimMdataTag(int reservedIdx,
                                                      t_cci_mpf_shim_mdata_tag tag,
                                                      t_cci_mdata m);
        return m[reservedIdx] && (m[0 +: $bits(tag)] == tag);
    endfunction

    function automatic t_cci_mpf_shim_mdata_value cci_mpf_getShimMdataValue(t_cci_mdata m);
        return m[$bits(t_cci_mpf_shim_mdata_tag) +: $bits(t_cci_mpf_shim_mdata_value)];
    endfunction

endpackage // cci_mpf_shim_pkg
