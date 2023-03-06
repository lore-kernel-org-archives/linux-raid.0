Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6C2C64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCFV3j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjCFV3C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC926457F5
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhUosX8LKj0yKhTPfwLjvtuXnlnSfvTZEsNV49LjImU=;
        b=HkGRqF74HQRYOTfKkGAlGbqr2B8CKX9uSXvVhe/l8kpCS8lwaT6JHdBzRi4lzYSh1FsC6s
        KQqwavdJXD5HiYIlz/EcTe6COrPRxs+p2OTzgDtMrVlOB/R6CT2zpIsSPGfGyzMrhBU28l
        ukajW57vastWKJ0S3PgILFuGvza06Yw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-uWjR7be9Mbu1iv5oZjZkug-1; Mon, 06 Mar 2023 16:28:12 -0500
X-MC-Unique: uWjR7be9Mbu1iv5oZjZkug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 853B2101A521
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:12 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C261D400DFA1;
        Mon,  6 Mar 2023 21:28:11 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 13/34] md: space prohibited between function and opening parenthesis [WARNING]
Date:   Mon,  6 Mar 2023 22:27:36 +0100
Message-Id: <8c56c5f39162477bf15532e8294f632edccf4b7f.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-linear.c    | 12 ++++++------
 drivers/md/md-multipath.c | 26 +++++++++++++-------------
 drivers/md/md.c           |  2 +-
 drivers/md/raid0.c        |  8 ++++----
 drivers/md/raid10.c       |  4 +---
 drivers/md/raid5.c        | 16 +++++++---------
 6 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 35ee116bf45b..35383589ec77 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -132,7 +132,7 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 	return NULL;
 }
 
-static int linear_run (struct mddev *mddev)
+static int linear_run(struct mddev *mddev)
 {
 	struct linear_conf *conf;
 	int ret;
@@ -265,7 +265,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 	return true;
 }
 
-static void linear_status (struct seq_file *seq, struct mddev *mddev)
+static void linear_status(struct seq_file *seq, struct mddev *mddev)
 {
 	seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
 }
@@ -287,14 +287,14 @@ static struct md_personality linear_personality = {
 	.quiesce	= linear_quiesce,
 };
 
-static int __init linear_init (void)
+static int __init linear_init(void)
 {
-	return register_md_personality (&linear_personality);
+	return register_md_personality(&linear_personality);
 }
 
-static void linear_exit (void)
+static void linear_exit(void)
 {
-	unregister_md_personality (&linear_personality);
+	unregister_md_personality(&linear_personality);
 }
 
 module_init(linear_init);
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index a26ed5a3643b..6cc169abef00 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -23,7 +23,7 @@
 
 #define	NR_RESERVED_BUFS	32
 
-static int multipath_map (struct mpconf *conf)
+static int multipath_map(struct mpconf *conf)
 {
 	int i, disks = conf->raid_disks;
 
@@ -49,7 +49,7 @@ static int multipath_map (struct mpconf *conf)
 	return (-1);
 }
 
-static void multipath_reschedule_retry (struct multipath_bh *mp_bh)
+static void multipath_reschedule_retry(struct multipath_bh *mp_bh)
 {
 	unsigned long flags;
 	struct mddev *mddev = mp_bh->mddev;
@@ -88,7 +88,7 @@ static void multipath_end_request(struct bio *bio)
 		/*
 		 * oops, IO error:
 		 */
-		md_error (mp_bh->mddev, rdev);
+		md_error(mp_bh->mddev, rdev);
 		pr_info("multipath: %pg: rescheduling sector %llu\n",
 			rdev->bdev,
 			(unsigned long long)bio->bi_iter.bi_sector);
@@ -137,13 +137,13 @@ static void multipath_status(struct seq_file *seq, struct mddev *mddev)
 	struct mpconf *conf = mddev->private;
 	int i;
 
-	seq_printf (seq, " [%d/%d] [", conf->raid_disks,
-		    conf->raid_disks - mddev->degraded);
+	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
+		   conf->raid_disks - mddev->degraded);
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->multipaths[i].rdev);
 
-		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
+		seq_printf(seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
 	seq_putc(seq, ']');
@@ -152,7 +152,7 @@ static void multipath_status(struct seq_file *seq, struct mddev *mddev)
 /*
  * Careful, this can execute in IRQ contexts as well!
  */
-static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
+static void multipath_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mpconf *conf = mddev->private;
 
@@ -184,7 +184,7 @@ static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
 	       conf->raid_disks - mddev->degraded);
 }
 
-static void print_multipath_conf (struct mpconf *conf)
+static void print_multipath_conf(struct mpconf *conf)
 {
 	int i;
 	struct multipath_info *tmp;
@@ -338,7 +338,7 @@ static sector_t multipath_size(struct mddev *mddev, sector_t sectors, int raid_d
 	return mddev->dev_sectors;
 }
 
-static int multipath_run (struct mddev *mddev)
+static int multipath_run(struct mddev *mddev)
 {
 	struct mpconf *conf;
 	int disk_idx;
@@ -455,14 +455,14 @@ static struct md_personality multipath_personality = {
 	.size		= multipath_size,
 };
 
-static int __init multipath_init (void)
+static int __init multipath_init(void)
 {
-	return register_md_personality (&multipath_personality);
+	return register_md_personality(&multipath_personality);
 }
 
-static void __exit multipath_exit (void)
+static void __exit multipath_exit(void)
 {
-	unregister_md_personality (&multipath_personality);
+	unregister_md_personality(&multipath_personality);
 }
 
 module_init(multipath_init);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 918565c03279..e50a1bcf0a1c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5638,7 +5638,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	int partitioned;
 	int shift;
 	int unit;
-	int error ;
+	int error;
 
 	/*
 	 * Wait for any previous instance of this device to be completely
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 73da2534da88..0fb47f4d78bf 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -768,14 +768,14 @@ static struct md_personality raid0_personality = {
 	.quiesce	= raid0_quiesce,
 };
 
-static int __init raid0_init (void)
+static int __init raid0_init(void)
 {
-	return register_md_personality (&raid0_personality);
+	return register_md_personality(&raid0_personality);
 }
 
-static void raid0_exit (void)
+static void raid0_exit(void)
 {
-	unregister_md_personality (&raid0_personality);
+	unregister_md_personality(&raid0_personality);
 }
 
 module_init(raid0_init);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b9dbe22818bf..c8f909e8a25e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -5272,9 +5272,7 @@ static void raid10_finish_reshape(struct mddev *mddev)
 		int d;
 
 		rcu_read_lock();
-		for (d = conf->geo.raid_disks ;
-		     d < conf->geo.raid_disks - mddev->delta_disks;
-		     d++) {
+		for (d = conf->geo.raid_disks; d < conf->geo.raid_disks - mddev->delta_disks; d++) {
 			struct md_rdev *rdev = rcu_dereference(conf->mirrors[d].rdev);
 
 			if (rdev)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fb18598e81d3..f5167eb71b5f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -157,7 +157,7 @@ static int raid6_idx_to_slot(int idx, struct stripe_head *sh,
 	return slot;
 }
 
-static void print_raid5_conf (struct r5conf *conf);
+static void print_raid5_conf(struct r5conf *conf);
 
 static int stripe_operations_active(struct stripe_head *sh)
 {
@@ -8151,18 +8151,18 @@ static void raid5_status(struct seq_file *seq, struct mddev *mddev)
 
 	seq_printf(seq, " level %d, %dk chunk, algorithm %d", mddev->level,
 		conf->chunk_sectors / 2, mddev->layout);
-	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->raid_disks - mddev->degraded);
+	seq_printf(seq, " [%d/%d] [", conf->raid_disks, conf->raid_disks - mddev->degraded);
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->disks[i].rdev);
 
-		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
+		seq_printf(seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
-	seq_printf (seq, "]");
+	seq_printf(seq, "]");
 }
 
-static void print_raid5_conf (struct r5conf *conf)
+static void print_raid5_conf(struct r5conf *conf)
 {
 	struct md_rdev *rdev;
 	int i;
@@ -8694,9 +8694,7 @@ static void raid5_finish_reshape(struct mddev *mddev)
 			spin_lock_irq(&conf->device_lock);
 			mddev->degraded = raid5_calc_degraded(conf);
 			spin_unlock_irq(&conf->device_lock);
-			for (d = conf->raid_disks ;
-			     d < conf->raid_disks - mddev->delta_disks;
-			     d++) {
+			for (d = conf->raid_disks; d < conf->raid_disks - mddev->delta_disks; d++) {
 				rdev = rdev_mdlock_deref(mddev,
 							 conf->disks[d].rdev);
 				if (rdev)
@@ -8872,7 +8870,7 @@ static int raid5_check_reshape(struct mddev *mddev)
 			mddev->layout = mddev->new_layout;
 		}
 		if (new_chunk > 0) {
-			conf->chunk_sectors = new_chunk ;
+			conf->chunk_sectors = new_chunk;
 			mddev->chunk_sectors = new_chunk;
 		}
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-- 
2.39.2

