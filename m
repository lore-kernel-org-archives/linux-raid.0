Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B71E31062C
	for <linux-raid@vger.kernel.org>; Wed, 28 Jan 2026 10:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769597490; cv=none; b=fp4hd0sheQompaALC7wYZeEGlQpta5ABKzQJVkQj9uo1CR26yRwwwVkG1kvA1uuDddSamikaUN++tKhwsBN3x3monu+AL5CyjwsbEj35OToOK49LOnrPpeKV4/pPD/znr1sBCCgDQis5izzNnukhfMvxyUeHvoSDJXWn9wki6xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769597490; c=relaxed/simple;
	bh=qB342u1Fa9iKIjRjBEPInMZcJOV3JU+F1+1AOruqAcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZSJb205sjhe1ILiZo2HWV/IO8YpEQmo3t23s0VfFrgc3wtQY5ALiSMDvs2PNvHVS6P8Q5NlBBsYlC/bObQbP9Vfls2TVGhYPLI7cBmZLr5ABOARDpPAlz9Qa219OVcbaybjLtoqmzyQN/bhxBLz6qXeEYsOWjBI23rp2VVRu+dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EQyrwGk7; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EQyrwGk7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769597486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eehzFHmt5LTmSet9iPSrcV4IAuJCuW4jScy1n4w7+Bw=;
	b=EQyrwGk76j+TbzoJbGNrCimYa4uUVGcxLcTV8Y0MyqF1qmhju+7yAapX+NgIyPzXoD2P9j
	IJ2nECpjEC3I9RHqyx7fDiqY3jfwlmzzHDozJJt4LZYBzy5QjEEZ02Sj1hkTgj2jxGQuH0
	hvOkAf9zH3XpvHWHzqR9QhXqPDXIl4M=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH 2/3] lib/raid6: Optimizing the raid6_select_algo time through asynchronous processing
Date: Wed, 28 Jan 2026 18:49:22 +0800
Message-Id: <20260128104923.338443-3-sunliming@linux.dev>
In-Reply-To: <20260128104923.338443-1-sunliming@linux.dev>
References: <20260128104923.338443-1-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: sunliming <sunliming@kylinos.cn>

Optimizing the raid6_select_algo time. In raid6_select_algo(), an raid6 gen
algorithm is first selected quickly through synchronous processing, while
the time-consuming process of selecting the optimal algorithm via benchmarking
is handled asynchronously. This approach speeds up the overall startup time
and ultimately ensures the selection of an optimal algorithm.

Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 lib/raid6/algos.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index ac6a77b0ae1d..c92168d59df2 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/raid/pq.h>
+#include <linux/workqueue.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
@@ -168,7 +169,7 @@ static inline const struct raid6_calls *raid6_choose_gen_fast(void)
 
 	if (best) {
 		raid6_call = *best;
-		pr_info("raid6: skipped pq benchmark and selected %s\n",
+		pr_info("raid6: fast selected %s, async benchmark pending\n",
 			best->name);
 	} else {
 		pr_err("raid6: No valid algorithm found even for fast selection!\n");
@@ -177,7 +178,7 @@ static inline const struct raid6_calls *raid6_choose_gen_fast(void)
 	return best;
 }
 
-static inline const struct raid6_calls *raid6_gen_benchmark(
+static inline void raid6_gen_benchmark(
 		void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
 {
 	unsigned long perf, bestgenperf, j0, j1;
@@ -214,12 +215,11 @@ static inline const struct raid6_calls *raid6_gen_benchmark(
 	}
 
 	if (!best) {
-		pr_err("raid6: Yikes! No algorithm found!\n");
-		goto out;
+		pr_err("raid6: async benchmark failed to find any algorithm\n");
+		return;
 	}
 
 	raid6_call = *best;
-
 	pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
 		best->name,
 		(bestgenperf * HZ * (disks - 2)) >>
@@ -244,14 +244,11 @@ static inline const struct raid6_calls *raid6_gen_benchmark(
 			(perf * HZ * (disks - 2)) >>
 			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
 	}
-
-out:
-	return best;
 }
 
 /* Try to pick the best algorithm */
 /* This code uses the gfmul table as convenient data set to abuse */
-static int raid6_choose_gen_benmark(const struct raid6_calls **gen_best)
+static int raid6_choose_gen_benmark(void)
 {
 	const int disks = RAID6_TEST_DISKS;
 	char *disk_ptr, *p;
@@ -278,32 +275,39 @@ static int raid6_choose_gen_benmark(const struct raid6_calls **gen_best)
 	if ((disks - 2) * PAGE_SIZE % 65536)
 		memcpy(p, raid6_gfmul, (disks - 2) * PAGE_SIZE % 65536);
 
-	*gen_best = raid6_gen_benchmark(&dptrs, disks);
+	raid6_gen_benchmark(&dptrs, disks);
 
 	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
 
 	return 0;
 }
 
+static struct work_struct raid6_benchmark_work __initdata;
+
+static __init void benchmark_work_func(struct work_struct *work)
+{
+	raid6_choose_gen_benmark();
+}
+
 int __init raid6_select_algo(void)
 {
-	int ret;
 	const struct raid6_calls *gen_best = NULL;
 	const struct raid6_recov_calls *rec_best = NULL;
 
-	/* select raid gen_syndrome functions */
-	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK))
-		gen_best = raid6_choose_gen_fast();
-	else {
-		ret = raid6_choose_gen_benmark(&gen_best);
-		if (ret < 0)
-			return ret;
-	}
+	/* phase 1: synchronous fast selection generation algorithm */
+	gen_best = raid6_choose_gen_fast();
 
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	return gen_best && rec_best ? 0 : -EINVAL;
+	if (!gen_best || !rec_best)
+		return -EINVAL;
+
+	/* phase 2: asynchronous performance benchmarking */
+	INIT_WORK(&raid6_benchmark_work, benchmark_work_func);
+	schedule_work(&raid6_benchmark_work);
+
+	return 0;
 }
 
 static void raid6_exit(void)
-- 
2.25.1

