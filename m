Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE7BC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 03:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbhLNDRA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Dec 2021 22:17:00 -0500
Received: from out0.migadu.com ([94.23.1.103]:15360 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232633AbhLNDQ7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 13 Dec 2021 22:16:59 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639451816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1vndxrNGB+WzR5xqhu3RD4FILb9wlm0/q3X11bIWkos=;
        b=w5By6ZS3fnzrzSFtNkLbtOkmZ0qL8Bki24Eu+3FK+uNAzyl3IYnsHeHeyyLhQfcxr7dWc4
        Rt22vJPkaHD5KZ0KNldK2yJEYK0xfQpfueDK/MKqILACVT5KKOEKcQ3nxLv/dH9cDS4mTh
        /Ea+/oiAwNdVz9O3P5wQ6xMZX1bOM1Y=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     stockhausen@collogia.de, song@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        linux-raid@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] lib/raid6: fix abnormally high latency
Date:   Tue, 14 Dec 2021 11:15:53 +0800
Message-Id: <20211214031553.16435-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We found an abnormally high latency when executing modprobe raid6_pq, the
latency is greater than 1.2s when CONFIG_PREEMPT_VOLUNTARY=y, greater than
67ms when CONFIG_PREEMPT=y, and greater than 16ms when CONFIG_PREEMPT_RT=y.
This is caused by disable the preemption, this time is too long and
unreasonable. We just need to disable migration. so used migrate_disable()/
migrate_enable() instead of preempt_disable()/preempt_enable(). This is
beneficial for CONFIG_PREEMPT=y or CONFIG_PREEMPT_RT=y, but no effect for
CONFIG_PREEMPT_VOLUNTARY=y.

Fixes: fe5cbc6e06c7 ("md/raid6 algorithms: delta syndrome functions")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 lib/raid6/algos.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 6d5e5000fdd7..21611d05c34c 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -162,7 +162,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 
 			perf = 0;
 
-			preempt_disable();
+			migrate_disable();
 			j0 = jiffies;
 			while ((j1 = jiffies) == j0)
 				cpu_relax();
@@ -171,7 +171,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 				(*algo)->gen_syndrome(disks, PAGE_SIZE, *dptrs);
 				perf++;
 			}
-			preempt_enable();
+			migrate_enable();
 
 			if (perf > bestgenperf) {
 				bestgenperf = perf;
@@ -186,7 +186,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 
 			perf = 0;
 
-			preempt_disable();
+			migrate_disable();
 			j0 = jiffies;
 			while ((j1 = jiffies) == j0)
 				cpu_relax();
@@ -196,7 +196,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 						      PAGE_SIZE, *dptrs);
 				perf++;
 			}
-			preempt_enable();
+			migrate_enable();
 
 			if (best == *algo)
 				bestxorperf = perf;
-- 
2.32.0

