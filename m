From: Gayatri Kammela <gayatri.kammela@intel.com>
Subject: [PATCH v2 3/6] lib/raid6/test/Makefile: Add avx512 gen_syndrome and recovery functions
Date: Fri, 12 Aug 2016 18:03:21 -0700
Message-ID: <1471050204-26361-4-git-send-email-gayatri.kammela@intel.com>
References: <1471050204-26361-1-git-send-email-gayatri.kammela@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471050204-26361-1-git-send-email-gayatri.kammela@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, ravi.v.shankar@intel.com, Gayatri Kammela <gayatri.kammela@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Megha Dey <megha.dey@linux.intel.com>
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
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
---
 lib/raid6/test/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index 29090f3db677..2c7b60edea04 100644
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
2.7.4
