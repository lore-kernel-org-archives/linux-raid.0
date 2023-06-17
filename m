Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F69EB64D9
	for <linux-raid@archiver.kernel.org>; Sat, 17 Jun 2023 05:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbjFQFYk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 17 Jun 2023 01:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjFQFYi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 17 Jun 2023 01:24:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B9F1FD3
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 22:24:36 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35H2ScJ8000421
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 22:24:36 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r92buh6sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 22:24:35 -0700
Received: from twshared24695.38.frc1.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 22:24:34 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 14AF11F6F226A; Fri, 16 Jun 2023 22:24:17 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <linux-raid@vger.kernel.org>
CC:     <linux-block@vger.kernel.org>, Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] md: use mddev->external to select holder in export_rdev()
Date:   Fri, 16 Jun 2023 22:24:04 -0700
Message-ID: <20230617052405.305871-1-song@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: q_XSFMArXKRbTKIUc-w_2F6x5ndcpIES
X-Proofpoint-ORIG-GUID: q_XSFMArXKRbTKIUc-w_2F6x5ndcpIES
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-17_03,2023-06-16_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

mdadm test "10ddf-create-fail-rebuild" triggers warnings like the following

[  215.526357] ------------[ cut here ]------------
[  215.527243] WARNING: CPU: 18 PID: 1264 at block/bdev.c:617 blkdev_put+0x269/0x350
[  215.528334] Modules linked in:
[  215.528806] CPU: 18 PID: 1264 Comm: mdmon Not tainted 6.4.0-rc2+ #768
[  215.529863] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
[  215.531464] RIP: 0010:blkdev_put+0x269/0x350
[  215.532167] Code: ff ff 49 8d 7d 10 e8 56 bf b8 ff 4d 8b 65 10 49 8d bc
24 58 05 00 00 e8 05 be b8 ff 41 83 ac 24 58 05 00 00 01 e9 44 ff ff ff
<0f> 0b e9 52 fe ff ff 0f 0b e9 6b fe ff ff1
[  215.534780] RSP: 0018:ffffc900040bfbf0 EFLAGS: 00010283
[  215.535635] RAX: ffff888174001000 RBX: ffff88810b1c3b00 RCX: ffffffff819a4061
[  215.536645] RDX: dffffc0000000000 RSI: dffffc0000000000 RDI: ffff88810b1c3ba0
[  215.537657] RBP: ffff88810dbde800 R08: fffffbfff0fca983 R09: fffffbfff0fca983
[  215.538674] R10: ffffc900040bfbf0 R11: fffffbfff0fca982 R12: ffff88810b1c3b38
[  215.539687] R13: ffff88810b1c3b10 R14: ffff88810dbdecb8 R15: ffff88810b1c3b00
[  215.540833] FS:  00007f2aabdff700(0000) GS:ffff888dfb400000(0000) knlGS:0000000000000000
[  215.541961] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  215.542775] CR2: 00007fa19a85d934 CR3: 000000010c076006 CR4: 0000000000370ee0
[  215.543814] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  215.544840] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  215.545885] Call Trace:
[  215.546257]  <TASK>
[  215.546608]  export_rdev.isra.63+0x71/0xe0
[  215.547338]  mddev_unlock+0x1b1/0x2d0
[  215.547898]  array_state_store+0x28d/0x450
[  215.548519]  md_attr_store+0xd7/0x150
[  215.549059]  ? __pfx_sysfs_kf_write+0x10/0x10
[  215.549702]  kernfs_fop_write_iter+0x1b9/0x260
[  215.550351]  vfs_write+0x491/0x760
[  215.550863]  ? __pfx_vfs_write+0x10/0x10
[  215.551445]  ? __fget_files+0x156/0x230
[  215.552053]  ksys_write+0xc0/0x160
[  215.552570]  ? __pfx_ksys_write+0x10/0x10
[  215.553141]  ? ktime_get_coarse_real_ts64+0xec/0x100
[  215.553878]  do_syscall_64+0x3a/0x90
[  215.554403]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  215.555125] RIP: 0033:0x7f2aade11847
[  215.555696] Code: c3 66 90 41 54 49 89 d4 55 48 89 f5 53 89 fb 48 83 ec
10 e8 1b fd ff ff 4c 89 e2 48 89 ee 89 df 41 89 c0 b8 01 00 00 00 0f 05
<48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 448
[  215.558398] RSP: 002b:00007f2aabdfeba0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[  215.559516] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007f2aade11847
[  215.560515] RDX: 0000000000000005 RSI: 0000000000438b8b RDI: 0000000000000010
[  215.561512] RBP: 0000000000438b8b R08: 0000000000000000 R09: 00007f2aaecf0060
[  215.562511] R10: 000000000e3ba40b R11: 0000000000000293 R12: 0000000000000005
[  215.563647] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000c70750
[  215.564693]  </TASK>
[  215.565029] irq event stamp: 15979
[  215.565584] hardirqs last  enabled at (15991): [<ffffffff811a7432>] __up_console_sem+0x52/0x60
[  215.566806] hardirqs last disabled at (16000): [<ffffffff811a7417>] __up_console_sem+0x37/0x60
[  215.568022] softirqs last  enabled at (15716): [<ffffffff8277a2db>] __do_softirq+0x3eb/0x531
[  215.569239] softirqs last disabled at (15711): [<ffffffff810d8f45>] irq_exit_rcu+0x115/0x160
[  215.570434] ---[ end trace 0000000000000000 ]---

This means export_rdev() calls blkdev_put with a different holder than the
one used by blkdev_get_by_dev(). This is because mddev->major_version == -2
is not a good check for external metadata. Fix this by using
mddev->external instead.

Also, do not clear mddev->external in md_clean(), as the flag might be used
later in export_rdev().

Fixes: 2736e8eeb0cc ("block: use the holder as indication for exclusive opens")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Song Liu <song@kernel.org>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cf3733c90c47..8e7cc2e69bc9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2458,7 +2458,7 @@ static void export_rdev(struct md_rdev *rdev, struct mddev *mddev)
 	if (test_bit(AutoDetected, &rdev->flags))
 		md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
-	blkdev_put(rdev->bdev, mddev->major_version == -2 ? &claim_rdev : rdev);
+	blkdev_put(rdev->bdev, mddev->external ? &claim_rdev : rdev);
 	rdev->bdev = NULL;
 	kobject_put(&rdev->kobj);
 }
@@ -6140,7 +6140,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->reshape_position = MaxSector;
-	mddev->external = 0;
+	/* we still need mddev->external in export_rdev, do not clear it yet */
 	mddev->persistent = 0;
 	mddev->level = LEVEL_NONE;
 	mddev->clevel[0] = 0;
-- 
2.34.1

