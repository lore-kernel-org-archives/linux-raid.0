Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D751AC433EF
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jul 2022 01:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiGBByX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Jul 2022 21:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBByW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Jul 2022 21:54:22 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C216369F7;
        Fri,  1 Jul 2022 18:54:20 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 47B211E80D4D;
        Sat,  2 Jul 2022 09:52:44 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3zI60_5aEVSi; Sat,  2 Jul 2022 09:52:41 +0800 (CST)
Received: from localhost.localdomain (unknown [112.65.12.78])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 260921E80D10;
        Sat,  2 Jul 2022 09:52:41 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] md: Fix spelling mistake in comments
Date:   Sat,  2 Jul 2022 09:54:11 +0800
Message-Id: <20220702015411.61522-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There are 2 spelling mistakes in comments. Fix it.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 drivers/md/md-cluster.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 37cbcce3cc66..742b2349fea3 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -40,7 +40,7 @@ struct resync_info {
 
 /* Lock the send communication. This is done through
  * bit manipulation as opposed to a mutex in order to
- * accomodate lock and hold. See next comment.
+ * accommodate lock and hold. See next comment.
  */
 #define		MD_CLUSTER_SEND_LOCK			4
 /* If cluster operations (such as adding a disk) must lock the
@@ -689,7 +689,7 @@ static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
 	/*
 	 * If resync thread run after raid1d thread, then process_metadata_update
 	 * could not continue if raid1d held reconfig_mutex (and raid1d is blocked
-	 * since another node already got EX on Token and waitting the EX of Ack),
+	 * since another node already got EX on Token and waiting the EX of Ack),
 	 * so let resync wake up thread in case flag is set.
 	 */
 	if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
-- 
2.25.1

