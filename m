Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3FCC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4C7422B47
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgHTNW6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:22:58 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10235 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728350AbgHTNVy (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:21:54 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 76E594B8D402E77A5A70;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:45 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 09/10] md/raid5: resize stripe_head when reshape array
Date:   Thu, 20 Aug 2020 09:22:13 -0400
Message-ID: <20200820132214.3749139-10-yuyufen@huawei.com>
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

When reshape array, we try to reuse shared pages of old stripe_head,
and allocate more for the new one if needed.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c038be864257..c52c414ca954 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2535,6 +2535,12 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		osh = get_free_stripe(conf, hash);
 		unlock_device_hash_lock(conf, hash);
 
+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+	for (i = 0; i < osh->nr_pages; i++) {
+		nsh->pages[i] = osh->pages[i];
+		osh->pages[i] = NULL;
+	}
+#endif
 		for(i=0; i<conf->pool_size; i++) {
 			nsh->dev[i].page = osh->dev[i].page;
 			nsh->dev[i].orig_page = osh->dev[i].page;
@@ -2589,6 +2595,23 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
 		list_del_init(&nsh->lru);
 
+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+		for (i = 0; i < nsh->nr_pages; i++) {
+			if (nsh->pages[i])
+				continue;
+			nsh->pages[i] = alloc_page(GFP_NOIO);
+			if (!nsh->pages[i])
+				err = -ENOMEM;
+		}
+
+		for (i = conf->raid_disks; i < newsize; i++) {
+			if (nsh->dev[i].page)
+				continue;
+			nsh->dev[i].page = raid5_get_dev_page(nsh, i);
+			nsh->dev[i].orig_page = nsh->dev[i].page;
+			nsh->dev[i].offset = raid5_get_page_offset(nsh, i);
+		}
+#else
 		for (i=conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
 				struct page *p = alloc_page(GFP_NOIO);
@@ -2598,6 +2621,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 				if (!p)
 					err = -ENOMEM;
 			}
+#endif
 		raid5_release_stripe(nsh);
 	}
 	/* critical section pass, GFP_NOIO no longer needed */
-- 
2.25.4

