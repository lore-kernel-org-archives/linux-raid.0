Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E8AC54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 20 Sep 2022 01:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiITB3d (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Sep 2022 21:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiITB3a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Sep 2022 21:29:30 -0400
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10B93B5B;
        Mon, 19 Sep 2022 18:29:29 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id C06011E80D17;
        Tue, 20 Sep 2022 09:26:23 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id phhXpdPqhRfZ; Tue, 20 Sep 2022 09:26:21 +0800 (CST)
Received: from nfschina.com.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zhounan@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 1CAB81E80D1C;
        Tue, 20 Sep 2022 09:26:21 +0800 (CST)
From:   Zhou nan <zhounan@nfschina.com>
To:     song@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        zhounan@nfschina.com
Subject: [PATCH] dm: Fix spelling mistake in comments
Date:   Mon, 19 Sep 2022 21:28:48 -0400
Message-Id: <20220920012848.84461-2-zhounan@nfschina.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220920012848.84461-1-zhounan@nfschina.com>
References: <CAPhsuW64vLfGUGOPjnQx-D7=qh7yFL=yvfWUTPn7teCegLeZaQ@mail.gmail.com>
 <20220920012848.84461-1-zhounan@nfschina.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: zhounan <zhounan@nfschina.com>

Fix spelling of dones't in comments.

Signed-off-by: zhounan <zhounan@nfschina.com>
---
 drivers/md/raid5-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index f4e1cc1ece43..683fd4adde17 100644
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
-- 
2.27.0

