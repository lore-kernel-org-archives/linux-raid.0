Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739D6FA3743
	for <linux-raid@archiver.kernel.org>; Tue,  1 Nov 2022 05:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiKAFJ2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Nov 2022 01:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiKAFJ1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Nov 2022 01:09:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC2110064
        for <linux-raid@vger.kernel.org>; Mon, 31 Oct 2022 22:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667279306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W7O4k+ypAHU4F5jOcJzi+URYiEU1FyNONmCJYftd/lI=;
        b=X6LeDadYapTCDZ0KK/9aO+s9Cr90sT51k4/eIuqiGZuSJbze05Kfn9cyTVzwyC0wMZhqCq
        kVR/qw4XANfbnh35d6ozMgmMVVTSoOK235s+SY+SotBPrgmGIGIHwSnm3N02lTvqBFdLT9
        t5N4Y78bhfOhYaVoqT8BklbCiJ60Zz0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-Hdc7rdIdObez96iBX3Z_KQ-1; Tue, 01 Nov 2022 01:08:24 -0400
X-MC-Unique: Hdc7rdIdObez96iBX3Z_KQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DC1938035CE;
        Tue,  1 Nov 2022 05:08:24 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-146.pek2.redhat.com [10.72.13.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 266091731B;
        Tue,  1 Nov 2022 05:08:21 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     yi.zhang@redhat.com, ming.lei@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 1/1] Don't set discard sectors for request queue
Date:   Tue,  1 Nov 2022 13:08:19 +0800
Message-Id: <20221101050819.12509-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It should use disk_stack_limits to get a proper max_discard_sectors
rather than setting a value by stack drivers.

And there is a bug. If all member disks are rotational devices,
raid0/raid10 set max_discard_sectors. So the member devices are
not ssd/nvme, but raid0/raid10 export the wrong value. It reports
warning messages in function __blkdev_issue_discard when mkfs.xfs

Signed-off-by: Xiao Ni <xni@redhat.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
---
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

