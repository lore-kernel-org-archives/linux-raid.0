From: Gayatri Kammela <gayatri.kammela@intel.com>
Subject: [PATCH v2 0/6] Add AVX512 optimized gen_syndrome, xor_syndrome and recovery functions
Date: Fri, 12 Aug 2016 18:03:18 -0700
Message-ID: <1471050204-26361-1-git-send-email-gayatri.kammela@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, ravi.v.shankar@intel.com, Gayatri Kammela <gayatri.kammela@intel.com>
List-Id: linux-raid.ids

This is the version 2 patch series for adding AVX512 optimized gen_syndrome,
xor_syndrome and recovery functions.

Optimization of RAID6 using AVX512 instructions should improve the
RAID6 performance.These patches are tested and observed the improvement
in performance.

Changes since v1:
1) Added xor_syndrome functions to avx512 optimized raid6.

Gayatri Kammela (6):
  lib/raid6: Add AVX512 optimized gen_syndrome functions
  lib/raid6: Add AVX512 optimized recovery functions
  lib/raid6/test/Makefile: Add avx512 gen_syndrome and recovery
    functions
  lib/raid6: Add AVX512 optimized xor_syndrome functions
  (DO NOT APPLY) lib/raid6: Add unroll by 8 to AVX512 optimized
    gen_syndrome functions
  (DO NOT APPLY) lib/raid6: Add unroll by 8 to AVX512 optimized    
    xor_syndrome functions.

 arch/x86/Makefile        |   5 +-
 include/linux/raid/pq.h  |   5 +
 lib/raid6/Makefile       |   2 +-
 lib/raid6/algos.c        |  13 +
 lib/raid6/avx512.c       | 972 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/raid6/recov_avx512.c | 388 +++++++++++++++++++
 lib/raid6/test/Makefile  |   5 +-
 lib/raid6/x86.h          |  10 +
 8 files changed, 1396 insertions(+), 4 deletions(-)
 create mode 100644 lib/raid6/avx512.c
 create mode 100644 lib/raid6/recov_avx512.c

-- 
2.7.4
