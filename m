Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FB132C943
	for <linux-raid@vger.kernel.org>; Wed, 28 Jan 2026 10:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769597433; cv=none; b=LghD/sDdBe07MrRZ93ORZ5cipdlCO6mECHCx1tGe7kba92wbV3StvdtRJYy6CJC203FTpILQnaY2UdVfhYlAtdtU+n6zuR/U1Z7WBXtKdKm9IrDpJq9edFRil7/biGm7UFH1Uwsp9x+NnKW1DSNcweJzk8VHjHuT4zD1TXMgH4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769597433; c=relaxed/simple;
	bh=cpWdcgKiC0KPCgrLlg09v6/ScjKw+Tm6Glne/tnTl0s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LoQ87k/MtxqyrIE2wosurWVtsnJQUnpedR2OErlLxd+vQ2sfCRvL9DMnnkPplsUwnZxloFl3tDtVighuCuvqYUuBmV43yxCxEtvSdYa6x6GBYh+DKP3yet2GtmJnnz/DmzY+uGppYLjGfyY3KYx89EQawJw2hmE60+2Y0Ujua6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RrSj1Dpg; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RrSj1Dpg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769597430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfN+HKIxPojLfnj3CGkpwFshzRxTq1htYY6puasTWyM=;
	b=RrSj1DpgqEzzvL4v4yOUliunx37UNqEUiw5e1SDoBp6wu9oCaBJZ93T3vBQnMQMKa89CZs
	NIhvYky1q6TYNZL1U8YJveg5jvmucBfgnuZ9+NZvAlb0J7OYNpXpaey301U1BDXtu1g6W3
	eGVCvwBiIj+Yp8Sd03MH1ILwtZk7vbE=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH 1/3] lib/raid6: Divide the raid6 algorithm selection process into two parts
Date: Wed, 28 Jan 2026 18:49:21 +0800
Message-Id: <20260128104923.338443-2-sunliming@linux.dev>
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

Divide the RAID6 algorithm selection process into two parts: fast selection
and benchmark selection. To prepare for the asynchronous processing of
the benchmark phase.

Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 lib/raid6/algos.c | 76 +++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 25 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..ac6a77b0ae1d 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -134,7 +134,7 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
 static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 {
 	const struct raid6_recov_calls *const *algo;
-	const struct raid6_recov_calls *best;
+	const struct raid6_recov_calls *best = NULL;
 
 	for (best = NULL, algo = raid6_recov_algos; *algo; algo++)
 		if (!best || (*algo)->priority > best->priority)
@@ -152,24 +152,44 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 	return best;
 }
 
-static inline const struct raid6_calls *raid6_choose_gen(
-	void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
+/* Quick selection: selects the first valid algorithm. */
+static inline const struct raid6_calls *raid6_choose_gen_fast(void)
+{
+	const struct raid6_calls *const *algo;
+	const struct raid6_calls *best = NULL;
+
+	for (algo = raid6_algos; *algo; algo++) {
+		if ((*algo)->valid && !(*algo)->valid())
+			continue;
+
+		best = *algo;
+		break;
+	}
+
+	if (best) {
+		raid6_call = *best;
+		pr_info("raid6: skipped pq benchmark and selected %s\n",
+			best->name);
+	} else {
+		pr_err("raid6: No valid algorithm found even for fast selection!\n");
+	}
+
+	return best;
+}
+
+static inline const struct raid6_calls *raid6_gen_benchmark(
+		void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
 {
 	unsigned long perf, bestgenperf, j0, j1;
 	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half of the disks */
 	const struct raid6_calls *const *algo;
-	const struct raid6_calls *best;
+	const struct raid6_calls *best = NULL;
 
 	for (bestgenperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
 		if (!best || (*algo)->priority >= best->priority) {
 			if ((*algo)->valid && !(*algo)->valid())
 				continue;
 
-			if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK)) {
-				best = *algo;
-				break;
-			}
-
 			perf = 0;
 
 			preempt_disable();
@@ -200,12 +220,6 @@ static inline const struct raid6_calls *raid6_choose_gen(
 
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
@@ -235,16 +249,11 @@ static inline const struct raid6_calls *raid6_choose_gen(
 	return best;
 }
 
-
 /* Try to pick the best algorithm */
 /* This code uses the gfmul table as convenient data set to abuse */
-
-int __init raid6_select_algo(void)
+static int raid6_choose_gen_benmark(const struct raid6_calls **gen_best)
 {
 	const int disks = RAID6_TEST_DISKS;
-
-	const struct raid6_calls *gen_best;
-	const struct raid6_recov_calls *rec_best;
 	char *disk_ptr, *p;
 	void *dptrs[RAID6_TEST_DISKS];
 	int i, cycle;
@@ -269,14 +278,31 @@ int __init raid6_select_algo(void)
 	if ((disks - 2) * PAGE_SIZE % 65536)
 		memcpy(p, raid6_gfmul, (disks - 2) * PAGE_SIZE % 65536);
 
-	/* select raid gen_syndrome function */
-	gen_best = raid6_choose_gen(&dptrs, disks);
+	*gen_best = raid6_gen_benchmark(&dptrs, disks);
+
+	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+
+	return 0;
+}
+
+int __init raid6_select_algo(void)
+{
+	int ret;
+	const struct raid6_calls *gen_best = NULL;
+	const struct raid6_recov_calls *rec_best = NULL;
+
+	/* select raid gen_syndrome functions */
+	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK))
+		gen_best = raid6_choose_gen_fast();
+	else {
+		ret = raid6_choose_gen_benmark(&gen_best);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
-
 	return gen_best && rec_best ? 0 : -EINVAL;
 }
 
-- 
2.25.1

