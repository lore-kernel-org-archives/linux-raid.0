Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C9EC83F1B
	for <linux-raid@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjH1CFY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Aug 2023 22:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjH1CFB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Aug 2023 22:05:01 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095E1DA;
        Sun, 27 Aug 2023 19:04:59 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4RYv5K1pGDz4f3nqh;
        Mon, 28 Aug 2023 10:04:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S30;
        Mon, 28 Aug 2023 10:04:56 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        song@kernel.org, xni@redhat.com
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com,
        yangerkun@huawei.com
Subject: [PATCH -next v2 26/28] md/md-linear: cleanup linear_add()
Date:   Mon, 28 Aug 2023 10:00:19 +0800
Message-Id: <20230828020021.2489641-27-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S30
X-Coremail-Antispam: 1UD129KBjvdXoWrKF17uw18ur13CFWUCrW8tFb_yoWktrbE9F
        s7u397Ar1UXFy7Zw1Yvw4Svr90qr1DW34kZFySgrnava48Xw1xAr95Jr45A3srZay3Kay5
        Kryxtw4ftr48tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbqxFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
        IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
        F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
        1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
        M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
        v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
        F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
        IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
        wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
        0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AK
        xVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JV
        WxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbmZ
        X7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

Now that caller already suspend the array, there is no need to suspend
array in liner_add().

Note that mddev_suspend/resume() is not used anymore.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-linear.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 71ac99646827..66412397cef0 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -183,7 +183,6 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	 * in linear_congested(), therefore kfree_rcu() is used to free
 	 * oldconf until no one uses it anymore.
 	 */
-	mddev_suspend(mddev);
 	oldconf = rcu_dereference_protected(mddev->private,
 			lockdep_is_held(&mddev->reconfig_mutex));
 	mddev->raid_disks++;
@@ -192,7 +191,6 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	rcu_assign_pointer(mddev->private, newconf);
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
-	mddev_resume(mddev);
 	kfree_rcu(oldconf, rcu);
 	return 0;
 }
-- 
2.39.2

