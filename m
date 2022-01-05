Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52723C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jan 2022 16:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiAEQjG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jan 2022 11:39:06 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:58058 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiAEQjG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jan 2022 11:39:06 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1AD161F37C;
        Wed,  5 Jan 2022 16:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641400745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ejE0BI1B7U8O1ClAo0sxMpvQ/fJd+RmvBmZEsjsACfU=;
        b=C9W00noGuoKx8tMF2+NkQyLCufmKL/VbdyC0HEY288esKhyc4JnuP9DEzZG5hB9CtS9UDM
        7FK6J0onnFNiSOEzvRt67BhWmaeTi4nVQPtnxNCRWzUrjFwTwVIgxSPs7mmsI9+jRSDc5Q
        qH+GUOrtSew4rr7YO2wmG2mF5AZ8QJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641400745;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ejE0BI1B7U8O1ClAo0sxMpvQ/fJd+RmvBmZEsjsACfU=;
        b=TSthvNh0KzFrbGkm0z+0YK7KL5yuyxzHFehjZ0DmDBej7mz33YfHbas17uxrp+p1B3Q3ZU
        1WBDFBzTOepzG+AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 04C8113BF8;
        Wed,  5 Jan 2022 16:39:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +jkjAKnJ1WGOEAAAMHmgww
        (envelope-from <dmueller@suse.de>); Wed, 05 Jan 2022 16:39:05 +0000
From:   =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
Subject: [PATCH v2 1/2] lib/raid6: skip benchmark of non-chosen xor_syndrome functions
Date:   Wed,  5 Jan 2022 17:38:46 +0100
Message-Id: <20220105163847.18592-1-dmueller@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In commit fe5cbc6e06c7 ("md/raid6 algorithms: delta syndrome functions")
a xor_syndrome() benchmarking was added also to the raid6_choose_gen()
function. However, the results of that benchmarking were intentionally
discarded and did not influence the choice. It picked the
xor_syndrome() variant related to the best performing gen_syndrome().

Reduce runtime of raid6_choose_gen() without modifying its outcome by
only benchmarking the xor_syndrome() of the best gen_syndrome() variant.

For a HZ=250 x86_64 system with avx2 and without avx512 this removes
5 out of 6 xor() benchmarks, saving 340ms of raid6 initialization time.

Signed-off-by: Dirk Müller <dmueller@suse.de>
---
 lib/raid6/algos.c | 76 +++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 39 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 6d5e5000fdd7..9b7e8a837b27 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -145,12 +145,12 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 static inline const struct raid6_calls *raid6_choose_gen(
 	void *(*const dptrs)[RAID6_TEST_DISKS], const int disks)
 {
-	unsigned long perf, bestgenperf, bestxorperf, j0, j1;
+	unsigned long perf, bestgenperf, j0, j1;
 	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half of the disks */
 	const struct raid6_calls *const *algo;
 	const struct raid6_calls *best;
 
-	for (bestgenperf = 0, bestxorperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
+	for (bestgenperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
 		if (!best || (*algo)->prefer >= best->prefer) {
 			if ((*algo)->valid && !(*algo)->valid())
 				continue;
@@ -180,50 +180,48 @@ static inline const struct raid6_calls *raid6_choose_gen(
 			pr_info("raid6: %-8s gen() %5ld MB/s\n", (*algo)->name,
 				(perf * HZ * (disks-2)) >>
 				(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
+		}
+	}
 
-			if (!(*algo)->xor_syndrome)
-				continue;
+	if (!best) {
+		pr_err("raid6: Yikes! No algorithm found!\n");
+		goto out;
+	}
 
-			perf = 0;
+	raid6_call = *best;
 
-			preempt_disable();
-			j0 = jiffies;
-			while ((j1 = jiffies) == j0)
-				cpu_relax();
-			while (time_before(jiffies,
-					    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
-				(*algo)->xor_syndrome(disks, start, stop,
-						      PAGE_SIZE, *dptrs);
-				perf++;
-			}
-			preempt_enable();
-
-			if (best == *algo)
-				bestxorperf = perf;
+	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK)) {
+		pr_info("raid6: skipped pq benchmark and selected %s\n",
+			best->name);
+		goto out;
+	}
 
-			pr_info("raid6: %-8s xor() %5ld MB/s\n", (*algo)->name,
-				(perf * HZ * (disks-2)) >>
-				(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
+	pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
+		best->name,
+		(bestgenperf * HZ * (disks - 2)) >>
+		(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
+
+	if (best->xor_syndrome) {
+		perf = 0;
+
+		preempt_disable();
+		j0 = jiffies;
+		while ((j1 = jiffies) == j0)
+			cpu_relax();
+		while (time_before(jiffies,
+				   j1 + (1 << RAID6_TIME_JIFFIES_LG2))) {
+			best->xor_syndrome(disks, start, stop,
+					   PAGE_SIZE, *dptrs);
+			perf++;
 		}
-	}
+		preempt_enable();
 
-	if (best) {
-		if (IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK)) {
-			pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
-				best->name,
-				(bestgenperf * HZ * (disks-2)) >>
-				(20 - PAGE_SHIFT+RAID6_TIME_JIFFIES_LG2));
-			if (best->xor_syndrome)
-				pr_info("raid6: .... xor() %ld MB/s, rmw enabled\n",
-					(bestxorperf * HZ * (disks-2)) >>
-					(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
-		} else
-			pr_info("raid6: skip pq benchmark and using algorithm %s\n",
-				best->name);
-		raid6_call = *best;
-	} else
-		pr_err("raid6: Yikes!  No algorithm found!\n");
+		pr_info("raid6: .... xor() %ld MB/s, rmw enabled\n",
+			(perf * HZ * (disks - 2)) >>
+			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
+	}
 
+out:
 	return best;
 }
 
-- 
2.34.1

