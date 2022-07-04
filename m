Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D133C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Jul 2022 01:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiGDBXk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiGDBXj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jul 2022 21:23:39 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4E536346;
        Sun,  3 Jul 2022 18:23:35 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 842821E80C96;
        Mon,  4 Jul 2022 09:21:42 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FbWKynijn89V; Mon,  4 Jul 2022 09:21:39 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 2BEC71E80C95;
        Mon,  4 Jul 2022 09:21:39 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] block: Fix spelling mistake in comments
Date:   Mon,  4 Jul 2022 09:23:28 +0800
Message-Id: <20220704012328.6507-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There are some typos(dones't, waitting) in comments.
Fix it.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 drivers/md/raid5-cache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 83c184eddbda..4b799005eb6e 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -125,7 +125,7 @@ struct r5l_log {
 					 * reclaimed.  if it's 0, reclaim spaces
 					 * used by io_units which are in
 					 * IO_UNIT_STRIPE_END state (eg, reclaim
-					 * dones't wait for specific io_unit
+					 * doesn't wait for specific io_unit
 					 * switching to IO_UNIT_STRIPE_END
 					 * state) */
 	wait_queue_head_t iounit_wait;
@@ -1327,9 +1327,9 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	 * superblock is updated to new log tail. Updating superblock (either
 	 * directly call md_update_sb() or depend on md thread) must hold
 	 * reconfig mutex. On the other hand, raid5_quiesce is called with
-	 * reconfig_mutex hold. The first step of raid5_quiesce() is waitting
-	 * for all IO finish, hence waitting for reclaim thread, while reclaim
-	 * thread is calling this function and waitting for reconfig mutex. So
+	 * reconfig_mutex hold. The first step of raid5_quiesce() is waiting
+	 * for all IO finish, hence waiting for reclaim thread, while reclaim
+	 * thread is calling this function and waiting for reconfig mutex. So
 	 * there is a deadlock. We workaround this issue with a trylock.
 	 * FIXME: we could miss discard if we can't take reconfig mutex
 	 */
-- 
2.34.1

