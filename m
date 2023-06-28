Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C78EEB64D9
	for <linux-raid@archiver.kernel.org>; Wed, 28 Jun 2023 01:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjF1Baa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Jun 2023 21:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjF1Ba1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Jun 2023 21:30:27 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253F6297A;
        Tue, 27 Jun 2023 18:30:26 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QrPCf4B0Kz4f3l8j;
        Wed, 28 Jun 2023 09:30:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgAHcLMtjZtksx7IMg--.35564S6;
        Wed, 28 Jun 2023 09:30:23 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     xni@redhat.com, song@kernel.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com,
        yangerkun@huawei.com
Subject: [PATCH -next 2/2] md: restore 'noio_flag' for the last mddev_resume()
Date:   Wed, 28 Jun 2023 09:29:31 +0800
Message-Id: <20230628012931.88911-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230628012931.88911-1-yukuai1@huaweicloud.com>
References: <20230628012931.88911-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHcLMtjZtksx7IMg--.35564S6
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF4rtFWkCF47GrWDWF45ZFb_yoW8Jw1rp3
        yIqFZYyry8AFZ8Ar4Dta4kWFy5Jan3KrZFy3y3uw43Z3W3ur1UCr4rWr1DXFyqkFWIyr4D
        tw40vayrAw1UC3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9m14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
        0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUfwIDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

memalloc_noio_save() is called for the first mddev_suspend(), and
repeated mddev_suspend() only increase 'suspended'. However,
memalloc_noio_restore() is also called for the first mddev_resume(),
which means that memory reclaim will be enabled before the last
mddev_resume() is called, while the array is still suspended.

Fix this problem by restore 'noio_flag' for the last mddev_resume().

Fixes: 78f57ef9d50a ("md: use memalloc scope APIs in mddev_suspend()/mddev_resume()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 962dacfd98cf..a3d98273b295 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -464,11 +464,13 @@ EXPORT_SYMBOL_GPL(mddev_suspend);
 
 void mddev_resume(struct mddev *mddev)
 {
-	/* entred the memalloc scope from mddev_suspend() */
-	memalloc_noio_restore(mddev->noio_flag);
 	lockdep_assert_held(&mddev->reconfig_mutex);
 	if (--mddev->suspended)
 		return;
+
+	/* entred the memalloc scope from mddev_suspend() */
+	memalloc_noio_restore(mddev->noio_flag);
+
 	percpu_ref_resurrect(&mddev->active_io);
 	wake_up(&mddev->sb_wait);
 
-- 
2.39.2

