Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A657C38142
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 07:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjBAHbB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 02:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbjBAHa7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 02:30:59 -0500
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B018026594
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 23:30:58 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4P6D9T5PH9z4f3l20
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 15:30:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
        by APP4 (Coremail) with SMTP id gCh0CgD3rLAsFdpjmf4tCw--.37890S4;
        Wed, 01 Feb 2023 15:30:54 +0800 (CST)
From:   Hou Tao <houtao@huaweicloud.com>
To:     linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Logan Gunthorpe <logang@deltatee.com>, houtao1@huawei.com
Subject: [PATCH v2] md: use MD_RESYNC_* whenever possible
Date:   Wed,  1 Feb 2023 15:59:20 +0800
Message-Id: <20230201075920.444720-1-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3rLAsFdpjmf4tCw--.37890S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WF45Cw18Xw1UJryxGryrtFb_yoW8Xr15p3
        yxuFZIgr45Zr45Xa1UXF1v9a4FqryIyFWDtrW7u3ZxCw1fGr4DGry5Ga45XFn09as5Ar43
        X345KF45u3WxWw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
        CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
        MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6r
        W3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
        cSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

Just replace magic numbers by MD_RESYNC_* enumerations.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
v2: rebased on md-next
v1: https://lore.kernel.org/linux-raid/025148b5-f213-86a8-2c1d-ac76c52f7165@huaweicloud.com

 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index da6370835c47..a1635fe82e3d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6166,7 +6166,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->new_level = LEVEL_NONE;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = 0;
-	mddev->curr_resync = 0;
+	mddev->curr_resync = MD_RESYNC_NONE;
 	atomic64_set(&mddev->resync_mismatches, 0);
 	mddev->suspend_lo = mddev->suspend_hi = 0;
 	mddev->sync_speed_min = mddev->sync_speed_max = 0;
@@ -8895,7 +8895,7 @@ void md_do_sync(struct md_thread *thread)
 	atomic_set(&mddev->recovery_active, 0);
 	last_check = 0;
 
-	if (j>2) {
+	if (j >= MD_RESYNC_ACTIVE) {
 		pr_debug("md: resuming %s of %s from checkpoint.\n",
 			 desc, mdname(mddev));
 		mddev->curr_resync = j;
@@ -8967,7 +8967,7 @@ void md_do_sync(struct md_thread *thread)
 		if (j > max_sectors)
 			/* when skipping, extra large numbers can be returned. */
 			j = max_sectors;
-		if (j > 2)
+		if (j >= MD_RESYNC_ACTIVE)
 			mddev->curr_resync = j;
 		mddev->curr_mark_cnt = io_sectors;
 		if (last_check == 0)
-- 
2.29.2

