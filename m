Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3A4C433DF
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F34222BF5
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgHTNXa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:23:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10234 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728335AbgHTNVw (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:21:52 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 733FA9DAAE9D016A39A6;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:45 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 10/10] md/raid5: reallocate page array after setting new stripe_size
Date:   Thu, 20 Aug 2020 09:22:14 -0400
Message-ID: <20200820132214.3749139-11-yuyufen@huawei.com>
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

When try to resize stripe_size, we also need to free old
shared page array and allocate new.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c52c414ca954..c31a72225def 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6682,6 +6682,7 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 	struct r5conf *conf;
 	unsigned long new;
 	int err;
+	int size;
 
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
@@ -6714,10 +6715,29 @@ raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 	pr_debug("md/raid: change stripe_size from %lu to %lu\n",
 			conf->stripe_size, new);
 
+	if (mddev->sync_thread ||
+		test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+		mddev->reshape_position != MaxSector ||
+		mddev->sysfs_active) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
+
 	mddev_suspend(mddev);
+	mutex_lock(&conf->cache_size_mutex);
+	size = conf->max_nr_stripes;
+
+	shrink_stripes(conf);
+
 	conf->stripe_size = new;
 	conf->stripe_shift = ilog2(new) - 9;
 	conf->stripe_sectors = new >> 9;
+	if (grow_stripes(conf, size)) {
+		pr_warn("md/raid:%s: couldn't allocate buffers\n",
+				mdname(mddev));
+		err = -ENOMEM;
+	}
+	mutex_unlock(&conf->cache_size_mutex);
 	mddev_resume(mddev);
 
 out_unlock:
-- 
2.25.4

