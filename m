Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C503C61DA4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Feb 2023 05:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjBCFOm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBCFOl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Feb 2023 00:14:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B3F62788
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 21:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675401232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N5jE5M455v1oJbLDQ/5zpgqk3Vbko40nQbeAjt+p/ro=;
        b=G/2786a1Qasrs0pvOA8hVi2b9lCBOfZIbLBSCZtu+PCAxAYswiF7aazIiDKBwXS9rEeVkv
        ACyTpJ+6UlKlWymItz1vvDf6e15RrvFkUYvAzlkeBkWXzJ83u5ixNvW6oHoObygkigeDJl
        S5AE9ezuYUXs1tnVZHuy9Lh4+jWKE5E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-tO-_GW1bM4CERH86aE9hvA-1; Fri, 03 Feb 2023 00:13:49 -0500
X-MC-Unique: tO-_GW1bM4CERH86aE9hvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 900972A59547;
        Fri,  3 Feb 2023 05:13:49 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-42.pek2.redhat.com [10.72.13.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0474553AA;
        Fri,  3 Feb 2023 05:13:46 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Subject: [PATCH 1/1] md: Increase active_io to count acct_io
Date:   Fri,  3 Feb 2023 13:13:44 +0800
Message-Id: <20230203051344.19328-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It has added io_acct_set for raid0/raid5 io accounting and it needs to
alloc md_io_acct in the i/o path. They are free when the bios come back
from member disks. Now we don't have a method to monitor if those bios
are all come back. In the takeover process, it needs to free the raid0
memory resource including the memory pool for md_io_acct. But maybe some
bios are still not returned. When those bios are returned, it can cause
panic bcause of introducing NULL pointer or invalid address.

[ 6973.767999] RIP: 0010:mempool_free+0x52/0x80
[ 6973.786098] Call Trace:
[ 6973.786549]  md_end_io_acct+0x31/0x40
[ 6973.787227]  blk_update_request+0x224/0x380
[ 6973.787994]  blk_mq_end_request+0x1a/0x130
[ 6973.788739]  blk_complete_reqs+0x35/0x50
[ 6973.789456]  __do_softirq+0xd7/0x2c8
[ 6973.790114]  ? sort_range+0x20/0x20
[ 6973.790763]  run_ksoftirqd+0x2a/0x40
[ 6973.791400]  smpboot_thread_fn+0xb5/0x150
[ 6973.792114]  kthread+0x10b/0x130
[ 6973.792724]  ? set_kthread_struct+0x50/0x50
[ 6973.793491]  ret_from_fork+0x1f/0x40

This patch trys to use ->active_io to count acct_io. The regression
tests have passed. And I did takeover from raid0 to raid5 and from
raid5 to raid0 while I/O is happening. This patch works well.

Reported-by: Fine Fan <ffan@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 6 ++++++
 drivers/md/md.h | 7 ++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index da6370835c47..7f06eb953488 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8627,12 +8627,15 @@ static void md_end_io_acct(struct bio *bio)
 {
 	struct md_io_acct *md_io_acct = bio->bi_private;
 	struct bio *orig_bio = md_io_acct->orig_bio;
+	struct mddev *mddev = md_io_acct->mddev;
 
 	orig_bio->bi_status = bio->bi_status;
 
 	bio_end_io_acct(orig_bio, md_io_acct->start_time);
 	bio_put(bio);
 	bio_endio(orig_bio);
+
+	percpu_ref_put(&mddev->active_io);
 }
 
 /*
@@ -8648,10 +8651,13 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
 	if (!blk_queue_io_stat(bdev->bd_disk->queue))
 		return;
 
+	percpu_ref_get(&mddev->active_io);
+
 	clone = bio_alloc_clone(bdev, *bio, GFP_NOIO, &mddev->io_acct_set);
 	md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
 	md_io_acct->orig_bio = *bio;
 	md_io_acct->start_time = bio_start_io_acct(*bio);
+	md_io_acct->mddev = mddev;
 
 	clone->bi_end_io = md_end_io_acct;
 	clone->bi_private = md_io_acct;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6335cb86e52e..e148e3c83b0d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -710,9 +710,10 @@ struct md_thread {
 };
 
 struct md_io_acct {
-	struct bio *orig_bio;
-	unsigned long start_time;
-	struct bio bio_clone;
+	struct mddev	*mddev;
+	struct bio	*orig_bio;
+	unsigned long	start_time;
+	struct bio	bio_clone;
 };
 
 #define THREAD_WAKEUP  0
-- 
2.32.0 (Apple Git-132)

