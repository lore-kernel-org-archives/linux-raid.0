Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CE2C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 29 Dec 2021 22:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhL2WeS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Dec 2021 17:34:18 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:45530 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhL2WeS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Dec 2021 17:34:18 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5EF9921106;
        Wed, 29 Dec 2021 22:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640817257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+z3kw5R9xk+IcyO0scZcZ/b22ndC2aci8xFBSKajVeA=;
        b=f1WrmHKZ+VXfA6wwssT8+iMyOnLno3pgwIZ/Y240IYXp3rDuuRE0aXIPNTowSpJgIkY2/q
        ouyc9E+LFbxEIipgIGXUTb0rZsCHEn5hQq/UqmDVORJ7w5ietEB15Xcd+L65WEhbqLFq/2
        MngvMTHhcwquyywglSGLrym+Enr07EQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640817257;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+z3kw5R9xk+IcyO0scZcZ/b22ndC2aci8xFBSKajVeA=;
        b=ywiXb1OUqqzcBDW5MLiaKthDGdT91+f8bZlGknyyElX/NsHOMAv4yAOPQmA0u/oESJcGpu
        rD0J9ge+LGbwpoBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 42AB613C0F;
        Wed, 29 Dec 2021 22:34:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aIm0DmnizGGPXgAAMHmgww
        (envelope-from <dmueller@suse.de>); Wed, 29 Dec 2021 22:34:17 +0000
From:   =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
Subject: [PATCH] Skip benchmarking of non-best xor_syndrome functions
Date:   Wed, 29 Dec 2021 23:34:07 +0100
Message-Id: <20211229223407.11647-1-dmueller@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In commit fe5cbc6e06c7 ("md/raid6 algorithms: delta syndrome functions")
a xor_syndrome() has been added for optimized syndrome calculation and
being added also to to the raid6_choose_gen() function. However, the
result of the xor_syndrome() benchmarking was intentionally discarded
and did not influence the choice.

We can optimize raid6_choose_gen() without changing its behavior by
only benchmarking the chosen xor_syndrome() variant and printing it
output, rather than benchmarking also the ones that are discarded and
never influence the outcome.

For x86_64, this removes 8 out of 18 benchmark loops which each take
16 jiffies, so up to 160 jiffies saved on module load (640ms on a 250HZ
kernel).

Signed-off-by: Dirk Müller <dmueller@suse.de>
---
 lib/raid6/algos.c | 76 +++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 39 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 6d5e5000fdd7..889033b7fc0d 100644
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
+	if (best == NULL) {
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
+		(bestgenperf * HZ * (disks-2)) >>
+		(20 - PAGE_SHIFT+RAID6_TIME_JIFFIES_LG2));
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
+			(perf * HZ * (disks-2)) >>
+			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
+	}
 
+out:
 	return best;
 }
 
-- 
2.34.1

