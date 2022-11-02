Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386B5C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  2 Nov 2022 02:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiKBCIn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Nov 2022 22:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKBCIm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Nov 2022 22:08:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED74017E3F
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 19:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667354868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xK+RxByhWF23POGThWgECvWm7xvx4ce/Z2d9Xv+Yr9c=;
        b=DMFFpX2Tx+ahe7AnZMvOaCG9XbzhwjvFWPxv0TE7Ty4vpcCXf/M4orcUMG5v9/OIFgK9Rn
        hQrLGU6OjPVhJJL4t4PT93zZQ7gqKBdrYNhz3PnpmWKy+mL5lJ3qwABfZosp0LReQI8QJw
        3Oq3l9+RszhamNnvwsVBDK9EcpdHpDI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-q38SOAZOOgqBV1dXwPAMFg-1; Tue, 01 Nov 2022 22:07:39 -0400
X-MC-Unique: q38SOAZOOgqBV1dXwPAMFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6510E38005C7;
        Wed,  2 Nov 2022 02:07:38 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-146.pek2.redhat.com [10.72.13.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC49240C94CE;
        Wed,  2 Nov 2022 02:07:32 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     yi.zhang@redhat.com, ming.lei@redhat.com, ncroxon@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH V2 1/1] md/raid0, raid10: Don't set discard sectors for request queue
Date:   Wed,  2 Nov 2022 10:07:30 +0800
Message-Id: <20221102020730.23815-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It should use disk_stack_limits to get a proper max_discard_sectors
rather than setting a value by stack drivers.

And there is a bug. If all member disks are rotational devices,
raid0/raid10 set max_discard_sectors. So the member devices are
not ssd/nvme, but raid0/raid10 export the wrong value. It reports
warning messages in function __blkdev_issue_discard when mkfs.xfs
like this:

[ 4616.022599] ------------[ cut here ]------------
[ 4616.027779] WARNING: CPU: 4 PID: 99634 at block/blk-lib.c:50 __blkdev_issue_discard+0x16a/0x1a0
[ 4616.140663] RIP: 0010:__blkdev_issue_discard+0x16a/0x1a0
[ 4616.146601] Code: 24 4c 89 20 31 c0 e9 fe fe ff ff c1 e8 09 8d 48 ff 4c 89 f0 4c 09 e8 48 85 c1 0f 84 55 ff ff ff b8 ea ff ff ff e9 df fe ff ff <0f> 0b 48 8d 74 24 08 e8 ea d6 00 00 48 c7 c6 20 1e 89 ab 48 c7 c7
[ 4616.167567] RSP: 0018:ffffaab88cbffca8 EFLAGS: 00010246
[ 4616.173406] RAX: ffff9ba1f9e44678 RBX: 0000000000000000 RCX: ffff9ba1c9792080
[ 4616.181376] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ba1c9792080
[ 4616.189345] RBP: 0000000000000cc0 R08: ffffaab88cbffd10 R09: 0000000000000000
[ 4616.197317] R10: 0000000000000012 R11: 0000000000000000 R12: 0000000000000000
[ 4616.205288] R13: 0000000000400000 R14: 0000000000000cc0 R15: ffff9ba1c9792080
[ 4616.213259] FS:  00007f9a5534e980(0000) GS:ffff9ba1b7c80000(0000) knlGS:0000000000000000
[ 4616.222298] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4616.228719] CR2: 000055a390a4c518 CR3: 0000000123e40006 CR4: 00000000001706e0
[ 4616.236689] Call Trace:
[ 4616.239428]  blkdev_issue_discard+0x52/0xb0
[ 4616.244108]  blkdev_common_ioctl+0x43c/0xa00
[ 4616.248883]  blkdev_ioctl+0x116/0x280
[ 4616.252977]  __x64_sys_ioctl+0x8a/0xc0
[ 4616.257163]  do_syscall_64+0x5c/0x90
[ 4616.261164]  ? handle_mm_fault+0xc5/0x2a0
[ 4616.265652]  ? do_user_addr_fault+0x1d8/0x690
[ 4616.270527]  ? do_syscall_64+0x69/0x90
[ 4616.274717]  ? exc_page_fault+0x62/0x150
[ 4616.279097]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 4616.284748] RIP: 0033:0x7f9a55398c6b

Signed-off-by: Xiao Ni <xni@redhat.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
---
v2: Modify title and add warning calltrace
 drivers/md/raid0.c  | 1 -
 drivers/md/raid10.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index aced0ad8cdab..9d4831ca802c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -398,7 +398,6 @@ static int raid0_run(struct mddev *mddev)
 
 		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
-		blk_queue_max_discard_sectors(mddev->queue, UINT_MAX);
 
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
 		blk_queue_io_opt(mddev->queue,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3aa8b6e11d58..9a6503f5cb98 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4145,8 +4145,6 @@ static int raid10_run(struct mddev *mddev)
 	conf->thread = NULL;
 
 	if (mddev->queue) {
-		blk_queue_max_discard_sectors(mddev->queue,
-					      UINT_MAX);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
 		raid10_set_io_opt(conf);
-- 
2.32.0 (Apple Git-132)

