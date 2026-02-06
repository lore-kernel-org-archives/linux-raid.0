Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417E419C566
	for <linux-raid@vger.kernel.org>; Fri,  6 Feb 2026 05:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770356730; cv=none; b=MFzhTfZfDrfu+I+qfDaTu/ZiW6lNiI+ZJvPQuq6Eu0CBIAb3DbV4b66ysZBX+Df0eHKjmTWYf2jVdkEo3itBz7tLmRfYdL4z5JCdzjtAZnz1mHyJHQNBLzyuJh1IHFWNWMJPgTUICc1gEtwecARjJ/pLfXEROtKTzloqRy1lbrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770356730; c=relaxed/simple;
	bh=UHhmAaGZFtWbaHFzFf1XNuxh/+JY3Ape2gWU2P/WYEg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LZwPrPh8tgsLLQLLzrbwEzk6KV/HoGcmcbjlbaVUk/JUBGqvD7eq+YPzHKwbkEEGr+SNidzbbw41mqjCExKAxS9sAHZz9o12UhOvH1I72/NAm2GwLjAyN76+nxYrv0MozAk13+B3d3s0Eb8Fd2QVr99xDwtXWLighvwer2WBj6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TKVVkthB; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TKVVkthB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770356718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZgJFlCBgUgfhxW3RQ7XaSw6izc3bNkF4Jlkj/+s0v0=;
	b=TKVVkthBs9K8PboLNTgnAp9l8uvlqPutgEjQYpGoVNagTIvf+RachBBPvlPfheNp2ebl0M
	77PSPWrCLCUUY1HCnZ4B5yNu7uPHG4z9a1FYz5GKpgCWhzP7gJLQtIuAS4aD+yR7hR4NBh
	01XPWYxA2Ub4GVE4p2iU2tzI38SfCl0=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH v2 1/3] lib/raid6: Divide the raid6 algorithm selection process into two parts
Date: Fri,  6 Feb 2026 13:43:39 +0800
Message-Id: <20260206054341.106878-2-sunliming@linux.dev>
In-Reply-To: <20260206054341.106878-1-sunliming@linux.dev>
References: <20260206054341.106878-1-sunliming@linux.dev>
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
 lib/raid6/algos.c | 85 +++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 28 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..a14469388b0c 100644
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
@@ -152,24 +152,43 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 	return best;
 }
 
-static inline const struct raid6_calls *raid6_choose_gen(
-	void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
+/* Quick selection: selects the first valid algorithm. */
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
+			best->name);
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
@@ -230,24 +243,19 @@ static inline const struct raid6_calls *raid6_choose_gen(
 			(perf * HZ * (disks - 2)) >>
 			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
 	}
-
 out:
 	return best;
 }
 
-
 /* Try to pick the best algorithm */
 /* This code uses the gfmul table as convenient data set to abuse */
-
-int __init raid6_select_algo(void)
+static int raid6_choose_gen_benmark(void)
 {
 	const int disks = RAID6_TEST_DISKS;
-
-	const struct raid6_calls *gen_best;
-	const struct raid6_recov_calls *rec_best;
 	char *disk_ptr, *p;
 	void *dptrs[RAID6_TEST_DISKS];
-	int i, cycle;
+	const struct raid6_calls *best = NULL;
+	int i, cycle, ret = 0;
 
 	/* prepare the buffer and fill it circularly with gfmul table */
 	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
@@ -269,15 +277,36 @@ int __init raid6_select_algo(void)
 	if ((disks - 2) * PAGE_SIZE % 65536)
 		memcpy(p, raid6_gfmul, (disks - 2) * PAGE_SIZE % 65536);
 
-	/* select raid gen_syndrome function */
-	gen_best = raid6_choose_gen(&dptrs, disks);
+	best = raid6_gen_benchmark(&dptrs, disks);
+	if (!best)
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

