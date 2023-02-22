Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D90C61DA4
	for <linux-raid@archiver.kernel.org>; Wed, 22 Feb 2023 04:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjBVEAR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Feb 2023 23:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBVEAP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Feb 2023 23:00:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A31311DE
        for <linux-raid@vger.kernel.org>; Tue, 21 Feb 2023 19:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677038366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xBkjQCGV7p/3sYFnO7HyEL3fl8bOYDO2YOFFwrGDyZ4=;
        b=DUjSO8uZbL/rKypd+1HVsI7e47fDiVC6zWUw9ds2o/Zl7Ao2bayXdcA6q4Df6P5tl2y2Ev
        yvjfOvmGnsen29dluAnbFBCJhVcL1gdfAMMvRSoA4Sm/RDSVcawWiwuFLJQmO5hyb3mOUW
        MeBO7kLPxuJbAaC8nY1Y0HcvyZrt2+g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-2mhfDB6hNP6tyXT_ol7iYw-1; Tue, 21 Feb 2023 22:59:22 -0500
X-MC-Unique: 2mhfDB6hNP6tyXT_ol7iYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9711185A7A4;
        Wed, 22 Feb 2023 03:59:21 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 691CF440D9;
        Wed, 22 Feb 2023 03:59:18 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     yukuai1@huaweicloud.com, linux-raid@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com, heinzm@redhat.com,
        ncroxon@redhat.com
Subject: [PATCH 1/1] md: Free resources in __md_stop
Date:   Wed, 22 Feb 2023 11:59:16 +0800
Message-Id: <20230222035916.83647-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If md_run() fails after ->active_io is initialized, then percpu_ref_exit
is called in error path. However, later md_free_disk will call
percpu_ref_exit again which leads to a panic because of null pointer
dereference. It can also trigger this bug when resources are initialized
but are freed in error path, then will be freed again in md_free_disk.

BUG: kernel NULL pointer dereference, address: 0000000000000038
Oops: 0000 [#1] PREEMPT SMP
Workqueue: md_misc mddev_delayed_delete
RIP: 0010:free_percpu+0x110/0x630
Call Trace:
 <TASK>
 __percpu_ref_exit+0x44/0x70
 percpu_ref_exit+0x16/0x90
 md_free_disk+0x2f/0x80
 disk_release+0x101/0x180
 device_release+0x84/0x110
 kobject_put+0x12a/0x380
 kobject_put+0x160/0x380
 mddev_delayed_delete+0x19/0x30
 process_one_work+0x269/0x680
 worker_thread+0x266/0x640
 kthread+0x151/0x1b0
 ret_from_fork+0x1f/0x30

For creating raid device, md raid calls do_md_run->md_run, dm raid calls
md_run. We alloc those memory in md_run. For stopping raid device, md raid
calls do_md_stop->__md_stop, dm raid calls md_stop->__md_stop. So we can
free those memory resources in __md_stop.

Fixes: 72adae23a72c ("md: Change active_io to percpu")
Reported-and-tested-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 927a43db5dfb..f5480778e2f7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6256,6 +6256,11 @@ static void __md_stop(struct mddev *mddev)
 		mddev->to_remove = &md_redundancy_group;
 	module_put(pers->owner);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+
+	percpu_ref_exit(&mddev->writes_pending);
+	percpu_ref_exit(&mddev->active_io);
+	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->sync_set);
 }
 
 void md_stop(struct mddev *mddev)
@@ -6265,10 +6270,6 @@ void md_stop(struct mddev *mddev)
 	 */
 	__md_stop_writes(mddev);
 	__md_stop(mddev);
-	percpu_ref_exit(&mddev->writes_pending);
-	percpu_ref_exit(&mddev->active_io);
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
@@ -7839,11 +7840,6 @@ static void md_free_disk(struct gendisk *disk)
 {
 	struct mddev *mddev = disk->private_data;
 
-	percpu_ref_exit(&mddev->writes_pending);
-	percpu_ref_exit(&mddev->active_io);
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
-
 	mddev_free(mddev);
 }
 
-- 
2.32.0 (Apple Git-132)

