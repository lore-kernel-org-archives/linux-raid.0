From: liuzhengyuan@kylinos.cn
Subject: [PATCH v3] raid6: fix the input of raid6 algorithm
Date: Tue, 30 Aug 2016 21:48:19 +0800
Message-ID: <1472564899-28208-1-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: hpa@zytor.com
Cc: shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, liuzhengyuang521@gmail.com, ZhengYuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

From: ZhengYuan Liu <liuzhengyuan@kylinos.cn>

To test and choose the best algorithm for raid6, disks number
and disks data must be offered. These input depend on page
size and gfmul table at current time. It would cause the disk
number less than 4 when the page size is more than 64KB.This
patch would support arbitrarily page size by defining a macro
for disks number and using a PRNG based on non-linear inversive
congruential algorithm to fill the disks data.

Signed-off-by: ZhengYuan Liu <liuzhengyuan@kylinos.cn>
---
 lib/raid6/algos.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 77 insertions(+), 14 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 975c6e0..ca227b7 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -30,6 +30,9 @@ EXPORT_SYMBOL(raid6_empty_zero_page);
 #endif
 #endif
 
+#define RAID6_DISKS	8
+#define RAID6_DISKS_SHIFT	3
+
 struct raid6_calls raid6_call;
 EXPORT_SYMBOL_GPL(raid6_call);
 
@@ -129,7 +132,7 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 }
 
 static inline const struct raid6_calls *raid6_choose_gen(
-	void *(*const dptrs)[(65536/PAGE_SIZE)+2], const int disks)
+	void *(*const dptrs)[RAID6_DISKS], const int disks)
 {
 	unsigned long perf, bestgenperf, bestxorperf, j0, j1;
 	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half of the disks */
@@ -200,33 +203,93 @@ static inline const struct raid6_calls *raid6_choose_gen(
 	return best;
 }
 
+/* Euclidean Algorithm is selected to realize inversion */
+static uint32_t invert_euclidian(uint32_t c)
+{
+	uint32_t l1 = 0;
+	uint32_t l2 = 1;
+	uint32_t n = c;
+	uint32_t modulus = 2147483647;
+	uint32_t p = modulus, q, q2;
+
+	for (;;) {
+		q = p / n;
+		l1 += q * l2;
+		p -= q * n;
+		if (p == 0)
+			return l2;
+		q2 = n / p;
+		l2 +=  q2 * l1;
+		n -= q2 * p;
+		if (n == 0)
+			return modulus - l1;
+	}
+}
+
+/* a pseudorandom number generator based on non-linear inversive */
+/* congruential,use a initial state suggested by Peter Hellekalek */
+static uint32_t inversive_congruential(void)
+{
+	uint32_t multipler = 9102;
+	uint32_t increment = 2147483647-36884165;
+	uint32_t modulus = 2147483647; /* cycle length 2^31 - 1 */
+	static uint32_t seed = 1;
+	uint32_t add_ret, mult_ret, invert_ret;
+	uint32_t mult_q, mult_r, sub_q, sub_r;
+
+	invert_ret = invert_euclidian(seed);
+
+	/* use Schrage’s method to avoid multiplication overflow */
+	mult_q = modulus / multipler;
+	mult_r = modulus % multipler;
+	sub_q = multipler * (invert_ret % mult_q);
+	sub_r = mult_r * (invert_ret / mult_q);
+	if (sub_q < sub_r)
+		mult_ret = modulus - (sub_r - sub_q);
+	else
+		mult_ret = sub_q - sub_r;
+
+	/* avoid addition overflow */
+	if (mult_ret < modulus - increment)
+		add_ret = mult_ret + increment;
+	else
+		add_ret = mult_ret - (modulus - increment);
+
+	seed = add_ret;
+	return add_ret;
+}
 
 /* Try to pick the best algorithm */
 /* This code uses the gfmul table as convenient data set to abuse */
 
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
+	int i, j;
 
-	/* Normal code - use a 2-page allocation to avoid D$ conflict */
-	syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
+	/* use a 8-page allocation, The first 6 pages for disks
+	   and the last 2 pages for syndromes */
+	disk_ptr = (void *) __get_free_pages(GFP_KERNEL, RAID6_DISKS_SHIFT);
 
-	if (!syndromes) {
+	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
 
-	dptrs[disks-2] = syndromes;
-	dptrs[disks-1] = syndromes + PAGE_SIZE;
+	for (i = 0; i < disks-2; i++) {
+		dptrs[i] = disk_ptr + PAGE_SIZE*i;
+		for (j = 0; j < PAGE_SIZE; j = j + 4) {
+			*(uint32_t *)(dptrs[i]+j) = inversive_congruential();
+		}
+	}
+
+	dptrs[disks-2] = disk_ptr + PAGE_SIZE*(disks-2);
+	dptrs[disks-1] = disk_ptr + PAGE_SIZE*(disks-1);
 
 	/* select raid gen_syndrome function */
 	gen_best = raid6_choose_gen(&dptrs, disks);
@@ -234,7 +297,7 @@ int __init raid6_select_algo(void)
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	free_pages((unsigned long)syndromes, 1);
+	free_pages((unsigned long)disk_ptr, RAID6_DISKS_SHIFT);
 
 	return gen_best && rec_best ? 0 : -EINVAL;
 }
-- 
1.9.1




