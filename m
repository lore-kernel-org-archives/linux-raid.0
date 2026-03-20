Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B1E19D08F
	for <linux-raid@vger.kernel.org>; Fri, 20 Mar 2026 06:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773986548; cv=none; b=SBUjR+I6WrPG0HwNn3o3MnZZL3D3ot21c8abnc16k6CS7Oz0IChoyCsB5RbCueBi8ZZ6MgN9cPBG6Qu92QQCxkzH818t5594zaGgGoJ2yS90eLib+TAnzsw5n1j7lUFORZCq4zgLG8k2pW503xRarjA6400JQLUh3chNmtbx4do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773986548; c=relaxed/simple;
	bh=7gZTYvCYms6JLg4kbg3LMUFIljecloyM93oJfeULTjg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xriuw2CiDQtcvJyTrlIN6W4hKdxaZoBKoPDiPTAYPqbnmtxBugmP0PjUW3G5Ngi56WnyjKYSqMi6xEGGw/yX5LFUiNlfJ5GPw+WDDKhccE/2pRSrIrCgQ0Cl2JWdB07NUdjmJ5JTShLUIJLw62ieWvq2dSm6lc5k8f/jLa3wqMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lpL0/jza; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lpL0/jza"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773986534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YQcMr+CuWLq8RG6gUzwSk4dQyB0LcYdk73WHFDu273k=;
	b=lpL0/jza0612zsRwBePsrvNBAt5uG0PKzHE86KDZZ5y1svqlPoLcwO6GARh5LQpSkZ/z0w
	ZEyP0OGrRW8S7gCylv0mrqFALfnh4jxY5L7eap9/9VNV54pvzH65Hhz+vCeBFAnN0v2R/l
	cnkppksIyzHrkBfpGq6iO1/0Sh8xi1U=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com,
	akpm@linux-foundation.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH RESEND v3 1/3] lib/raid6: Divide the raid6 algorithm selection process into two parts
Date: Fri, 20 Mar 2026 14:00:19 +0800
Message-Id: <20260320060021.30762-2-sunliming@linux.dev>
In-Reply-To: <20260320060021.30762-1-sunliming@linux.dev>
References: <20260320060021.30762-1-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: sunliming <sunliming@kylinos.cn>

Divide the RAID6 algorithm selection process into two parts: fast selection
and benchmark selection. To prepare for the asynchronous processing of
the benchmark phase.

Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 lib/raid6/algos.c | 76 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 22 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..c21e3ad99d97 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -152,8 +152,32 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 	return best;
 }
 
-static inline const struct raid6_calls *raid6_choose_gen(
-	void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
+/* Quick selection: select the highest priority valid algorithm. */
+static inline int raid6_choose_gen_fast(void)
+{
+	int ret = 0;
+	const struct raid6_calls *const *algo;
+	const struct raid6_calls *best = NULL;
+
+	for (best = NULL, algo = raid6_algos; *algo; algo++)
+		if (!best || (*algo)->priority > best->priority)
+			if (!(*algo)->valid || (*algo)->valid())
+				best = *algo;
+
+	if (best) {
+		raid6_call = *best;
+		pr_info("raid6: skipped pq benchmark and selected %s\n",
+				best->name);
+	} else {
+		pr_err("raid6: No valid algorithm found even for fast selection!\n");
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static inline const struct raid6_calls *raid6_gen_benchmark(
+		void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
 {
 	unsigned long perf, bestgenperf, j0, j1;
 	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half of the disks */
@@ -165,11 +189,6 @@ static inline const struct raid6_calls *raid6_choose_gen(
 			if ((*algo)->valid && !(*algo)->valid())
 				continue;
 
-			if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK)) {
-				best = *algo;
-				break;
-			}
-
 			perf = 0;
 
 			preempt_disable();
@@ -200,12 +219,6 @@ static inline const struct raid6_calls *raid6_choose_gen(
 
 	raid6_call = *best;
 
-	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK)) {
-		pr_info("raid6: skipped pq benchmark and selected %s\n",
-			best->name);
-		goto out;
-	}
-
 	pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
 		best->name,
 		(bestgenperf * HZ * (disks - 2)) >>
@@ -239,15 +252,13 @@ static inline const struct raid6_calls *raid6_choose_gen(
 /* Try to pick the best algorithm */
 /* This code uses the gfmul table as convenient data set to abuse */
 
-int __init raid6_select_algo(void)
+static int raid6_choose_gen_benmark(void)
 {
 	const int disks = RAID6_TEST_DISKS;
-
 	const struct raid6_calls *gen_best;
-	const struct raid6_recov_calls *rec_best;
 	char *disk_ptr, *p;
 	void *dptrs[RAID6_TEST_DISKS];
-	int i, cycle;
+	int i, cycle, ret = 0;
 
 	/* prepare the buffer and fill it circularly with gfmul table */
 	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
@@ -269,15 +280,36 @@ int __init raid6_select_algo(void)
 	if ((disks - 2) * PAGE_SIZE % 65536)
 		memcpy(p, raid6_gfmul, (disks - 2) * PAGE_SIZE % 65536);
 
-	/* select raid gen_syndrome function */
-	gen_best = raid6_choose_gen(&dptrs, disks);
+	gen_best = raid6_gen_benchmark(&dptrs, disks);
+	if (!gen_best)
+		ret = -EINVAL;
+
+	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+
+	return ret;
+}
+
+int __init raid6_select_algo(void)
+{
+	int ret = 0;
+	const struct raid6_recov_calls *rec_best = NULL;
+
+	/* select raid gen_syndrome functions */
+	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK))
+		ret = raid6_choose_gen_fast();
+	else
+		ret = raid6_choose_gen_benmark();
+
+	if (ret < 0)
+		goto out;
 
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
+	if (!rec_best)
+		ret = -EINVAL;
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
-
-	return gen_best && rec_best ? 0 : -EINVAL;
+out:
+	return ret;
 }
 
 static void raid6_exit(void)
-- 
2.25.1

