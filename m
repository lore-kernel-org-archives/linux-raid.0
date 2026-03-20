Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11E017A305
	for <linux-raid@vger.kernel.org>; Fri, 20 Mar 2026 06:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773986593; cv=none; b=gtSV8EDNRdeW3zPV+9IZ0dzB1a4jA0eJORSXAhYr/FVSCDl+h43W7/1iO05tb/rTQfDtlapM1g7iGdCaGJjuu+bRtUpw4uyoAlzfA+CMarioV7/aRmj1K54VxdEMtY8JlRgiScbkp9hESZ0uM+g96QjVOQ0H8wd3Z8c2qYgoD7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773986593; c=relaxed/simple;
	bh=tRjI5SXiH5BCcAaQLg7tSNGUURQ24BdhEkmdLr7ZCZA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EGKk038sqsQkHyxDgyJVy4dc20WUpbI7kufjdTe0Vgy/TwMLjuMj+TrNEz84gH5DG/uqERDET0uIlGnt6DLWZijOg30rduM24KFiQeOJtuwDMGwFJxEmHzUAgMG0seUHFshUS2StHL5JvhFhZuceCS6yabEGEu7Edf+XqbAoG/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XAnOggs4; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XAnOggs4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773986587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FMLAU+TNwvgizddZfji1MH8+7sBrNmHxaW+imWLM8p4=;
	b=XAnOggs4tHKOacpvEdk7w/BA2BkX2F/jUve0RCaoBXIUdJqLvLT7eqiH0JTuFub9txjbPL
	XsiozbBwqsZLKtKAi0RumJs/Uwc7sxppcYNMVFz1MDOTABTeMucqhcrxteu89pWEug5VOp
	yJ4m6Iz9amz/p9eq3fI9FsBLlV3iwXg=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com,
	akpm@linux-foundation.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH RESEND v3 2/3] lib/raid6: Optimizing the raid6_select_algo time through asynchronous processing
Date: Fri, 20 Mar 2026 14:00:20 +0800
Message-Id: <20260320060021.30762-3-sunliming@linux.dev>
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

Optimizing the raid6_select_algo time. In raid6_select_algo(), an raid6 gen
algorithm is first selected quickly through synchronous processing, while
the time-consuming process of selecting the optimal algorithm via benchmarking
is handled asynchronously. This approach speeds up the overall startup time
and ultimately ensures the selection of an optimal algorithm.

Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 lib/raid6/algos.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index c21e3ad99d97..b8b5515ac7a6 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/raid/pq.h>
+#include <linux/workqueue.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
@@ -166,7 +167,7 @@ static inline int raid6_choose_gen_fast(void)
 
 	if (best) {
 		raid6_call = *best;
-		pr_info("raid6: skipped pq benchmark and selected %s\n",
+		pr_info("raid6: raid6: fast selected %s, async benchmark pending\n",
 				best->name);
 	} else {
 		pr_err("raid6: No valid algorithm found even for fast selection!\n");
@@ -213,7 +214,7 @@ static inline const struct raid6_calls *raid6_gen_benchmark(
 	}
 
 	if (!best) {
-		pr_err("raid6: Yikes! No algorithm found!\n");
+		pr_warn("raid6: async benchmark failed to find any algorithm\n");
 		goto out;
 	}
 
@@ -289,24 +290,33 @@ static int raid6_choose_gen_benmark(void)
 	return ret;
 }
 
+static struct work_struct raid6_benchmark_work;
+
+static void benchmark_work_func(struct work_struct *work)
+{
+	raid6_choose_gen_benmark();
+}
+
 int __init raid6_select_algo(void)
 {
 	int ret = 0;
 	const struct raid6_recov_calls *rec_best = NULL;
 
-	/* select raid gen_syndrome functions */
-	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK))
-		ret = raid6_choose_gen_fast();
-	else
-		ret = raid6_choose_gen_benmark();
-
+	/* phase 1: synchronous fast selection generation algorithm */
+	ret = raid6_choose_gen_fast();
 	if (ret < 0)
 		goto out;
 
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
-	if (!rec_best)
+	if (!rec_best) {
 		ret = -EINVAL;
+		goto out;
+	}
+
+	/* phase 2: asynchronous performance benchmarking */
+	INIT_WORK(&raid6_benchmark_work, benchmark_work_func);
+	schedule_work(&raid6_benchmark_work);
 
 out:
 	return ret;
@@ -314,7 +324,7 @@ int __init raid6_select_algo(void)
 
 static void raid6_exit(void)
 {
-	do { } while (0);
+	cancel_work_sync(&raid6_benchmark_work);
 }
 
 subsys_initcall(raid6_select_algo);
-- 
2.25.1

