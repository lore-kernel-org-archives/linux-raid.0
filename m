From: Gayatri Kammela <gayatri.kammela@intel.com>
Subject: [PATCH 3/4] lib/raid6/test/Makefile: Add avx512 gen_syndrome and recovery functions
Date: Tue,  2 Aug 2016 16:31:45 -0700
Message-ID: <1470180705-7667-1-git-send-email-gayatri.kammela@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com, james.t.kukunas@linux.intel.com, fenghua.yu@intel.com, megha.dey@linux.intel.com, ravi.v.shankar@intel.com, Gayatri Kammela <gayatri.kammela@intel.com>
List-Id: linux-raid.ids

Adding avx512 gen_syndrome and recovery functions so as to allow code to
be compiled and tested successfully in userspace.

This patch is tested in userspace and improvement in performace is
observed.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
---
 lib/raid6/test/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index 29090f3..2c7b60e 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -32,10 +32,13 @@ ifeq ($(ARCH),arm64)
 endif
 
 ifeq ($(IS_X86),yes)
-        OBJS   += mmx.o sse1.o sse2.o avx2.o recov_ssse3.o recov_avx2.o
+        OBJS   += mmx.o sse1.o sse2.o avx2.o recov_ssse3.o recov_avx2.o avx512.o recov_avx512.o
         CFLAGS += $(shell echo "vpbroadcastb %xmm0, %ymm1" |	\
                     gcc -c -x assembler - >&/dev/null &&	\
                     rm ./-.o && echo -DCONFIG_AS_AVX2=1)
+	CFLAGS += $(shell echo "vpmovm2b %k1, %zmm5" |          \
+		    gcc -c -x assembler - >&/dev/null &&        \
+		    rm ./-.o && echo -DCONFIG_AS_AVX512=1)
 else ifeq ($(HAS_NEON),yes)
         OBJS   += neon.o neon1.o neon2.o neon4.o neon8.o
         CFLAGS += -DCONFIG_KERNEL_MODE_NEON=1
-- 
1.9.1

