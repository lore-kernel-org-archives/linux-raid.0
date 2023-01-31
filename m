Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BA2C636CD
	for <linux-raid@archiver.kernel.org>; Tue, 31 Jan 2023 06:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjAaGjQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Jan 2023 01:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjAaGjO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Jan 2023 01:39:14 -0500
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6673CE2A
        for <linux-raid@vger.kernel.org>; Mon, 30 Jan 2023 22:39:13 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4P5b4C46JNz4f3jJ6
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 14:39:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
        by APP4 (Coremail) with SMTP id gCh0CgCX_7J7t9hj3eDsCg--.16650S4;
        Tue, 31 Jan 2023 14:39:09 +0800 (CST)
From:   Hou Tao <houtao@huaweicloud.com>
To:     linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Logan Gunthorpe <logang@deltatee.com>, houtao1@huawei.com,
        linan122@huawei.com
Subject: [PATCH] md: don't update recovery_cp when curr_resync is ACTIVE
Date:   Tue, 31 Jan 2023 15:07:19 +0800
Message-Id: <20230131070719.1702279-1-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCX_7J7t9hj3eDsCg--.16650S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr1UAFy7CrWxtr1UCryfWFg_yoW8XFy5pa
        yxCF9xtrW5AFW5twsrJFyDZa95Zw1Syr90yFW7ua9xAr1fJF4UAryUW3WUXFyDC3yvqF48
        X34rJwsxZFn7Ww7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
        CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
        MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJV
        Cq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIY
        CTnIWIevJa73UjIFyTuYvjxUOyCJDUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

Don't update recovery_cp when curr_resync is MD_RESYNC_ACTIVE, otherwise
md may skip the resync of the first 3 sectors if the resync procedure is
interrupted before the first calling of ->sync_request() as shown below:

md_do_sync thread          control thread
  // setup resync
  mddev->recovery_cp = 0
  j = 0
  mddev->curr_resync = MD_RESYNC_ACTIVE

                             // e.g., set array as idle
                             set_bit(MD_RECOVERY_INTR, &&mddev_recovery)
  // resync loop
  // check INTR before calling sync_request
  !test_bit(MD_RECOVERY_INTR, &mddev->recovery

  // resync interrupted
  // update recovery_cp from 0 to 3
  // the resync of three 3 sectors will be skipped
  mddev->recovery_cp = 3

Fixes: eac58d08d493 ("md: Use enum for overloaded magic numbers used by mddev->curr_resync")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 775f1dde190a..16de0ae65447 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9028,7 +9028,7 @@ void md_do_sync(struct md_thread *thread)
 	mddev->pers->sync_request(mddev, max_sectors, &skipped);
 
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
-	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
+	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 				if (mddev->curr_resync >= mddev->recovery_cp) {
-- 
2.29.2

