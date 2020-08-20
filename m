Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6632DC433E1
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4055F208DB
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgHTNWD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:22:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53300 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbgHTNVx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:21:53 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9EE909672156418861B5;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:42 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 01/10] md/raid5: make sure stripe_size as power of two
Date:   Thu, 20 Aug 2020 09:22:05 -0400
Message-ID: <20200820132214.3749139-2-yuyufen@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200820132214.3749139-1-yuyufen@huawei.com>
References: <20200820132214.3749139-1-yuyufen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit 3b5408b98e4d ("md/raid5: support config stripe_size by sysfs
entry") make stripe_size as a configurable value. It just requires
stripe_size as multiple of 4KB.

In fact, we should make sure stripe_size as power of two. Otherwise,
stripe_shift which is the result of ilog2 can not represent the real
stripe_size. Then, stripe_hash() and stripe_hash_locks_hash() may
get unexpected value.

Fixes: 3b5408b98e4d ("md/raid5: support config stripe_size by sysfs entry")
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ef0fd4830803..a095c7a4cd7c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6514,9 +6514,12 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 
 	/*
 	 * The value should not be bigger than PAGE_SIZE. It requires to
-	 * be multiple of DEFAULT_STRIPE_SIZE.
+	 * be multiple of DEFAULT_STRIPE_SIZE and the value should be power
+	 * of two.
 	 */
-	if (new % DEFAULT_STRIPE_SIZE != 0 || new > PAGE_SIZE || new == 0)
+	if (new % DEFAULT_STRIPE_SIZE != 0 ||
+			new > PAGE_SIZE || new == 0 ||
+			new != roundup_pow_of_two(new))
 		return -EINVAL;
 
 	err = mddev_lock(mddev);
-- 
2.25.4

