From: Gayatri Kammela <gayatri.kammela@intel.com>
Subject: [PATCH 0/4] Add AVX512 optimized gen_syndrome and recovery functions
Date: Tue,  2 Aug 2016 16:28:59 -0700
Message-ID: <1470180539-7417-1-git-send-email-gayatri.kammela@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com, james.t.kukunas@linux.intel.com, fenghua.yu@intel.com, megha.dey@linux.intel.com, ravi.v.shankar@intel.com, Gayatri Kammela <gayatri.kammela@intel.com>
List-Id: linux-raid.ids

This is the patch set for adding AVX512 optimized gen_syndrome
and recovery functions.

Optimization of RAID6 using AVX512 instructions should improve the
RAID6 performance.These patches are tested and observed the improvement
in performance.

Gayatri Kammela (4):
  lib/raid6: Add AVX512 optimized gen_syndrome functions
  lib/raid6: Add AVX512 optimized recovery functions
  lib/raid6/test/Makefile: Add avx512 gen_syndrome and recovery
    functions
  (DO NOT APPLY) lib/raid6: Add unroll by 8 to AVX512 optimized 
    gen_syndrome functions

 arch/x86/Makefile        |   5 +-
 include/linux/raid/pq.h  |   5 +
 lib/raid6/Makefile       |   2 +-
 lib/raid6/algos.c        |  13 ++
 lib/raid6/avx512.c       | 466 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/raid6/recov_avx512.c | 335 ++++++++++++++++++++++++++++++++++
 lib/raid6/test/Makefile  |   5 +-
 lib/raid6/x86.h          |  10 +
 8 files changed, 837 insertions(+), 4 deletions(-)
 create mode 100644 lib/raid6/avx512.c
 create mode 100644 lib/raid6/recov_avx512.c

-- 
1.9.1

