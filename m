From: liuzhengyuan@kylinos.cn
Subject: [PATCH v2] raid6: fix the input of raid6 algorithm
Date: Sun, 28 Aug 2016 14:51:04 +0800
Message-ID: <1472367064-10935-1-git-send-email-liuzhengyuan@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: hpa@zytor.com
Cc: shli@kernel.org, linux-raid@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org, liuzhengyuang521@gmail.com, ZhengYuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

From: ZhengYuan Liu <liuzhengyuan@kylinos.cn>

To test and choose the best algorithm for raid6, disks number
and disks data must be offered. These input depend on page
size and gfmul table at current time. It would cause the disk
number less than 4 when the page size is more than 64KB.This
patch would support arbitrarily page size by defining a macro
for disks number and using a PRNG based on linear congruential
bit to fill the disks data.

Signed-off-by: ZhengYuan Liu <liuzhengyuan@kylinos.cn>
---
 lib/raid6/algos.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 975c6e0..3991ac6 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -30,6 +30,8 @@ EXPORT_SYMBOL(raid6_empty_zero_page);
 #endif
 #endif
 
+#define RAID6_DISKS	8
+
 struct raid6_calls raid6_call;
 EXPORT_SYMBOL_GPL(raid6_call);
 
@@ -129,7 +131,7 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 }
 
 static inline const struct raid6_calls *raid6_choose_gen(
-	void *(*const dptrs)[(65536/PAGE_SIZE)+2], const int disks)
+	void *(*const dptrs)[RAID6_DISKS], const int disks)
 {
 	unsigned long perf, bestgenperf, bestxorperf, j0, j1;
 	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half of the disks */
@@ -206,27 +208,36 @@ static inline const struct raid6_calls *raid6_choose_gen(
 
 int __init raid6_select_algo(void)
 {
-	const int disks = (65536/PAGE_SIZE)+2;
+	const int disks = RAID6_DISKS;
 
 	const struct raid6_calls *gen_best;
 	const struct raid6_recov_calls *rec_best;
-	char *syndromes;
-	void *dptrs[(65536/PAGE_SIZE)+2];
-	int i;
-
-	for (i = 0; i < disks-2; i++)
-		dptrs[i] = ((char *)raid6_gfmul) + PAGE_SIZE*i;
+	char *disk_ptr;
+	void *dptrs[RAID6_DISKS];
+	int32_t seed;
+	int i, j;
 
-	/* Normal code - use a 2-page allocation to avoid D$ conflict */
-	syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
+	/* use a 8-page allocation, The first 6 pages for disks
+	   and the last 2 pages for syndromes */
+	disk_ptr = (void *) __get_free_pages(GFP_KERNEL, 3);
 
-	if (!syndromes) {
+	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
 
-	dptrs[disks-2] = syndromes;
-	dptrs[disks-1] = syndromes + PAGE_SIZE;
+	/*use a PRNG based on LCB to fill the disks*/
+	seed = 1;
+	for (i = 0; i < disks-2; i++) {
+		dptrs[i] = disk_ptr + PAGE_SIZE*i;
+		for (j = 0; j < PAGE_SIZE; j = j + 4) {
+			seed = ((seed * 1103515245) + 12345) & 0x7fffffff;
+			*(int32_t *)(dptrs[i]+j) = seed;
+		}
+	}
+
+	dptrs[disks-2] = disk_ptr + PAGE_SIZE*(disks-2);
+	dptrs[disks-1] = disk_ptr + PAGE_SIZE*(disks-1);
 
 	/* select raid gen_syndrome function */
 	gen_best = raid6_choose_gen(&dptrs, disks);
@@ -234,7 +245,7 @@ int __init raid6_select_algo(void)
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	free_pages((unsigned long)syndromes, 1);
+	free_pages((unsigned long)disk_ptr, 3);
 
 	return gen_best && rec_best ? 0 : -EINVAL;
 }
-- 
1.9.1




