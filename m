Return-Path: <SRS0=jE/M=B5=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE640C433E1
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 13:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB1EB204FD
	for <linux-raid@archiver.kernel.org>; Wed, 19 Aug 2020 13:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgHSNnm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Aug 2020 09:43:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9850 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbgHSNnl (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 Aug 2020 09:43:41 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 98585B6C8767EBE9E7F7;
        Wed, 19 Aug 2020 21:43:37 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 21:43:29 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [RFC PATCH] md/raid5: set faulty when cannot record badblocks
Date:   Wed, 19 Aug 2020 21:50:23 +0800
Message-ID: <20200819135023.132749-1-yuyufen@huawei.com>
X-Mailer: git-send-email 2.16.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: y00427003 <yuyufen@huawei.com>

Recently, we reported a io hung on raid5 and it can be reproduced easily,
like as:

 $ pvcreate /dev/sda /dev/sdb /dev/sdc /dev/sdd
 $ vgcreate dm-test /dev/sda /dev/sdb /dev/sdc /dev/sdd
 $ lvcreate --type raid5 -L 2G -i 3 -I 64 -n mylv dm-test
 $ echo offline > /sys/block/sda/device/state

 Then issue io to trigger raid5 set sda as faulty:
 $ dd if=/dev/mapper/dm--test-mylv of=/dev/null bs=4k count=1 iflag=direct

 After that, set another disk sdb as offline:
 $ echo offline > /sys/block/sdb/device/state
 $ dd if=/dev/mapper/dm--test-mylv of=/dev/null bs=8k count=1 iflag=direct

In the end, 'dd' command will hung forever and cannot return. And kernel
will repeatly print message as:

[  105.381220] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
[  105.382955] md/raid:mdX: read error not correctable (sector 8 on dm-3).
[  105.384145] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
[  105.385871] md/raid:mdX: read error not correctable (sector 8 on dm-3).
[  105.387033] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
[  105.388757] md/raid:mdX: read error not correctable (sector 8 on dm-3).
[  105.389915] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
[  105.391639] md/raid:mdX: read error not correctable (sector 8 on dm-3).
[  105.392784] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
[  105.394469] md/raid:mdX: read error not correctable (sector 8 on dm-3).
[  105.395622] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0
[  105.397315] md/raid:mdX: read error not correctable (sector 8 on dm-3).
[  105.398455] blk_update_request: I/O error, dev sdb, sector 10248 op 0x0:(READ) flags 0x4000 phys_seg 1 prio class 0

We found that raid5 try to issue the requested read bio (sector 10248)
repeatly, but can never complete. Since sdb is offline, raid5's bio
issued to that disk will return error. At the same time, mddev->degraded
is set as value 1 after setting sda offline. So, raid5_end_read_request()
will and print "md/raid:mdX: read error not correctable" and try to set
badblocks.

However, raid5 created by dm-raid doesn't support badblocks. Thus,
rdev_set_badblocks() will fail and md_error() try to set the device as
faulty. After commit fb73b357fb98("raid5: block failing device if raid
will be failed"), the device cannot set faulty. Then, the issued bio
neither find badblock nor know the device faulty, it will try again and
agine but never complete.

Even without creating raid5 by dm-raid, rdev_set_badblocks() can also
fail because badblocks count is over than MAX_BADBLOCKS. If md is degraded,
the problem can also happend.

To fix this problem, we can set disk as faulty when badblocks is not
supported or badblocks count is over than MAX_BADBLOCKS.

Signed-off-by: yuyufen <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ef0fd4830803..4bc9cd9a99bb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2704,7 +2704,9 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 	spin_lock_irqsave(&conf->device_lock, flags);
 
 	if (test_bit(In_sync, &rdev->flags) &&
-	    mddev->degraded == conf->max_degraded) {
+	    mddev->degraded == conf->max_degraded &&
+		(rdev->badblocks.shift != -1 ||
+		 rdev->badblocks.count < MAX_BADBLOCKS)) {
 		/*
 		 * Don't allow to achieve failed state
 		 * Don't try to recover this device
-- 
2.16.2.dirty

