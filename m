Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D58C7618D
	for <linux-raid@archiver.kernel.org>; Tue, 21 Mar 2023 08:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjCUI7Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Mar 2023 04:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjCUI67 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Mar 2023 04:58:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C02240FC
        for <linux-raid@vger.kernel.org>; Tue, 21 Mar 2023 01:57:18 -0700 (PDT)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pglkh0LnJznY3y;
        Tue, 21 Mar 2023 16:53:32 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 16:56:37 +0800
Message-ID: <df1fc8d7-0a34-aef7-aeeb-db4f59755f78@huawei.com>
Date:   Tue, 21 Mar 2023 16:56:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To:     <song@kernel.org>, <linux-raid@vger.kernel.org>
CC:     "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        <louhongxiang@huawei.com>
From:   Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH] raid0: fix set_disk_faulty doesn't return -EBUSY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The latest kernel version will not report an error through mdadm set_disk_faulty.

$ lsblk
sdb                                           8:16   0   10G  0 disk
└─md0                                         9:0    0 19.9G  0 raid0
sdc                                           8:32   0   10G  0 disk
└─md0                                         9:0    0 19.9G  0 raid0

old kernel:
...
$ mdadm /dev/md0 -f /dev/sdb
mdadm: set device faulty failed for /dev/sdb:  Device or resource busy
...

latest kernel:
...
$ mdadm /dev/md0 -f /dev/sdb
mdadm: set /dev/sdb faulty in /dev/md0
...

The old kernel judges whether the Faulty flag is set in rdev->flags,
and returns -EBUSY if not. And The latest kernel only return -EBUSY
if the MD_BROKEN flag is set in mddev->flags. raid0 doesn't set error_handler,
so MD_BROKEN will not be set, it will return 0.

So if error_handler isn't set for a raid type, also return -EBUSY.

Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 927a43db5dfb..b1786ff60d97 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2928,10 +2928,10 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
        int err = -EINVAL;
        bool need_update_sb = false;

-       if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
-               md_error(rdev->mddev, rdev);
+       if (cmd_match(buf, "faulty") && mddev->pers) {
+               md_error(mddev, rdev);

-               if (test_bit(MD_BROKEN, &rdev->mddev->flags))
+               if (!mddev->pers->error_handler || test_bit(MD_BROKEN, &mddev->flags))
                        err = -EBUSY;
                else
                        err = 0;
@@ -7421,7 +7421,7 @@ static int set_disk_faulty(struct mddev *mddev, dev_t dev)
                err =  -ENODEV;
        else {
                md_error(mddev, rdev);
-               if (test_bit(MD_BROKEN, &mddev->flags))
+               if (!mddev->pers->error_handler || test_bit(MD_BROKEN, &mddev->flags))
                        err = -EBUSY;
        }
        rcu_read_unlock();
--
2.27.0
.
