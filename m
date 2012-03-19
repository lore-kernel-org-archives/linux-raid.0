From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: [PATCH 3/4] lib/raid6: update test program for recovery functions
Date: Mon, 19 Mar 2012 11:10:48 -0700
Message-ID: <1332180649-9709-4-git-send-email-james.t.kukunas@linux.intel.com>
References: <1332180649-9709-1-git-send-email-james.t.kukunas@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332180649-9709-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: hpa@zytor.com
List-Id: linux-raid.ids

Test each combination of recovery and syndrome generation
functions.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 lib/raid6/test/test.c |   32 +++++++++++++++++++++-----------
 lib/raid6/x86.h       |   13 ++++++++-----
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
index 7a93031..5a485b7 100644
--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -90,25 +90,35 @@ static int test_disks(int i, int j)
 int main(int argc, char *argv[])
 {
 	const struct raid6_calls *const *algo;
+	const struct raid6_recov_calls *const *ra;
 	int i, j;
 	int err = 0;
 
 	makedata();
 
-	for (algo = raid6_algos; *algo; algo++) {
-		if (!(*algo)->valid || (*algo)->valid()) {
-			raid6_call = **algo;
+	for (ra = raid6_recov_algos; *ra; ra++) {
+		if ((*ra)->valid  && !(*ra)->valid())
+			continue;
+		raid6_2data_recov = (*ra)->data2;
+		raid6_datap_recov = (*ra)->datap;
 
-			/* Nuke syndromes */
-			memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
+		printf("using recovery %s\n", (*ra)->name);
 
-			/* Generate assumed good syndrome */
-			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
-						(void **)&dataptrs);
+		for (algo = raid6_algos; *algo; algo++) {
+			if (!(*algo)->valid || (*algo)->valid()) {
+				raid6_call = **algo;
 
-			for (i = 0; i < NDISKS-1; i++)
-				for (j = i+1; j < NDISKS; j++)
-					err += test_disks(i, j);
+				/* Nuke syndromes */
+				memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
+
+				/* Generate assumed good syndrome */
+				raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
+							(void **)&dataptrs);
+
+				for (i = 0; i < NDISKS-1; i++)
+					for (j = i+1; j < NDISKS; j++)
+						err += test_disks(i, j);
+			}
 		}
 		printf("\n");
 	}
diff --git a/lib/raid6/x86.h b/lib/raid6/x86.h
index cb2a8c9..9aff51f 100644
--- a/lib/raid6/x86.h
+++ b/lib/raid6/x86.h
@@ -40,19 +40,22 @@ static inline void kernel_fpu_end(void)
 					   * (fast save and restore) */
 #define X86_FEATURE_XMM		(0*32+25) /* Streaming SIMD Extensions */
 #define X86_FEATURE_XMM2	(0*32+26) /* Streaming SIMD Extensions-2 */
+#define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
+#define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
+#define X86_FEATURE_AVX	(4*32+28) /* Advanced Vector Extensions */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
 
 /* Should work well enough on modern CPUs for testing */
 static inline int boot_cpu_has(int flag)
 {
-	u32 eax = (flag >> 5) ? 0x80000001 : 1;
-	u32 edx;
+	u32 eax = (flag & 0x20) ? 0x80000001 : 1;
+	u32 ecx, edx;
 
 	asm volatile("cpuid"
-		     : "+a" (eax), "=d" (edx)
-		     : : "ecx", "ebx");
+		     : "+a" (eax), "=d" (edx), "=c" (ecx)
+		     : : "ebx");
 
-	return (edx >> (flag & 31)) & 1;
+	return ((flag & 0x80 ? ecx : edx) >> (flag & 31)) & 1;
 }
 
 #endif /* ndef __KERNEL__ */
-- 
1.7.3.4

