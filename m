From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] raid6: fix the input of raid6 algorithm
Date: Mon, 22 Aug 2016 20:53:05 -0700
Message-ID: <FAA53096-C767-4142-B45C-01889986EDAF@zytor.com>
References: <1471922577-18512-1-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471922577-18512-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: liuzhengyuan@kylinos.cn
Cc: shli@kernel.org, linux-raid@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org, liuzhengyuang521@gmail.com
List-Id: linux-raid.ids

On August 22, 2016 8:22:57 PM PDT, liuzhengyuan@kylinos.cn wrote:
>
>To test and choose an best algorithm for raid6, disk number
>and disk data must be offered. Those input depend on page
>size and gfmul table at current time. It would lead the disk
>number less than 4 when the page size is more than 64KB.This
>patch would support arbitrarily page size by defining a macro
>for disk number and using random number to fill with disk data.
>
>Signed-off-by: ZhengYuan Liu <liuzhengyuan@kylinos.cn>
>---
> lib/raid6/algos.c | 36 ++++++++++++++++++++++--------------
> 1 file changed, 22 insertions(+), 14 deletions(-)
>
>diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
>index 975c6e0..f15a4d2 100644
>--- a/lib/raid6/algos.c
>+++ b/lib/raid6/algos.c
>@@ -23,6 +23,7 @@
> #else
> #include <linux/module.h>
> #include <linux/gfp.h>
>+#include <linux/random.h>
> #if !RAID6_USE_EMPTY_ZERO_PAGE
> /* In .bss so it's zeroed */
>const char raid6_empty_zero_page[PAGE_SIZE]
>__attribute__((aligned(256)));
>@@ -30,6 +31,8 @@ EXPORT_SYMBOL(raid6_empty_zero_page);
> #endif
> #endif
> 
>+#define RAID6_DISKS	8
>+
> struct raid6_calls raid6_call;
> EXPORT_SYMBOL_GPL(raid6_call);
> 
>@@ -129,7 +132,7 @@ static inline const struct raid6_recov_calls
>*raid6_choose_recov(void)
> }
> 
> static inline const struct raid6_calls *raid6_choose_gen(
>-	void *(*const dptrs)[(65536/PAGE_SIZE)+2], const int disks)
>+	void *(*const dptrs)[RAID6_DISKS], const int disks)
> {
> 	unsigned long perf, bestgenperf, bestxorperf, j0, j1;
>	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half
>of the disks */
>@@ -206,27 +209,32 @@ static inline const struct raid6_calls
>*raid6_choose_gen(
> 
> int __init raid6_select_algo(void)
> {
>-	const int disks = (65536/PAGE_SIZE)+2;
>+	const int disks = RAID6_DISKS;
> 
> 	const struct raid6_calls *gen_best;
> 	const struct raid6_recov_calls *rec_best;
>-	char *syndromes;
>-	void *dptrs[(65536/PAGE_SIZE)+2];
>-	int i;
>-
>-	for (i = 0; i < disks-2; i++)
>-		dptrs[i] = ((char *)raid6_gfmul) + PAGE_SIZE*i;
>+	char *disk_ptr;
>+	void *dptrs[RAID6_DISKS];
>+	int i, j;
> 
>-	/* Normal code - use a 2-page allocation to avoid D$ conflict */
>-	syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
>+	/* use a 8-page allocation, The first 6 pages for disks
>+	   and the last 2 pages for syndromes */
>+	disk_ptr = (void *) __get_free_pages(GFP_KERNEL, 3);
> 
>-	if (!syndromes) {
>+	if (!disk_ptr) {
> 		pr_err("raid6: Yikes!  No memory available.\n");
> 		return -ENOMEM;
> 	}
> 
>-	dptrs[disks-2] = syndromes;
>-	dptrs[disks-1] = syndromes + PAGE_SIZE;
>+	/* Fix-me: may should use get_random_bytes_arch() instead of
>get_random_bytes() */
>+	for (i = 0; i < disks-2; i++) {
>+		dptrs[i] = disk_ptr + PAGE_SIZE*i;
>+		for (j = 0; j < PAGE_SIZE; j++)
>+			get_random_bytes(dptrs[i]+j, 1);
>+	}
>+
>+	dptrs[disks-2] = disk_ptr + PAGE_SIZE*(disks-2);
>+	dptrs[disks-1] = disk_ptr + PAGE_SIZE*(disks-1);
> 
> 	/* select raid gen_syndrome function */
> 	gen_best = raid6_choose_gen(&dptrs, disks);
>@@ -234,7 +242,7 @@ int __init raid6_select_algo(void)
> 	/* select raid recover functions */
> 	rec_best = raid6_choose_recov();
> 
>-	free_pages((unsigned long)syndromes, 1);
>+	free_pages((unsigned long)disk_ptr, 3);
> 
> 	return gen_best && rec_best ? 0 : -EINVAL;
> }

Do you have any idea how long this takes to run?  People are already complaining about the boot time penalty.  get_random_*() is quite expensive and is overkill...
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
