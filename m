Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC62C6FD1B
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjCFV25 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjCFV2w (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:28:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA392313A
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MN+2LdNSz6cpqQbfgpvfKAiKvHxJ2UtV1VfBoILMXgY=;
        b=RD06XlYB+YmDulZIqEG3D1zI3CR6vDDkXst7hqZs0kOGgCQMWiBzRcExfrqRktLvCvfCwB
        XZT+0NaKdkosAWXkx5k4SSj3dnFO5sBGJdHt7n8oPGDCKA2xPNXMMaFM4cFmC5zMfo14ky
        vVxJeAyB0NScg2VaEE1x33PTKb3r9LE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-Ro_uALqIOIiUoOCnxhOVrw-1; Mon, 06 Mar 2023 16:28:00 -0500
X-MC-Unique: Ro_uALqIOIiUoOCnxhOVrw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6A8E3806631
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:27:59 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1B0740CF8F0;
        Mon,  6 Mar 2023 21:27:58 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 01/34] md: fix required/prohibited spaces [ERROR]
Date:   Mon,  6 Mar 2023 22:27:24 +0100
Message-Id: <f57b30aa3126ae184addbd1184ba0b72ff00ef86.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Once on it, replace comparisons to 0 (i.e. == 0) with negation
as recommended by "checkpatch .pl --strict ...".

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-autodetect.c |  10 ++--
 drivers/md/md-bitmap.c     |  15 +++---
 drivers/md/md-bitmap.h     |   2 +-
 drivers/md/md-cluster.c    |   2 +-
 drivers/md/md-faulty.c     |  22 ++++----
 drivers/md/md-linear.c     |   2 +-
 drivers/md/md-multipath.c  |   9 ++--
 drivers/md/md.c            | 106 ++++++++++++++++++-------------------
 drivers/md/md.h            |   2 +-
 drivers/md/raid0.c         |  10 ++--
 drivers/md/raid1.c         |  20 +++----
 drivers/md/raid10.c        |  28 +++++-----
 drivers/md/raid5.c         |  40 +++++++-------
 include/linux/raid/pq.h    |   2 +-
 14 files changed, 132 insertions(+), 138 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 91836e6de326..46090cdd02ba 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -23,7 +23,7 @@
 #ifdef CONFIG_MD_AUTODETECT
 static int __initdata raid_noautodetect;
 #else
-static int __initdata raid_noautodetect=1;
+static int __initdata raid_noautodetect = 1;
 #endif
 static int __initdata raid_autopart;
 
@@ -73,7 +73,7 @@ static int __init md_setup(char *str)
 		return 0;
 	}
 	str1 = str;
-	for (ent=0 ; ent< md_setup_ents ; ent++)
+	for (ent = 0; ent < md_setup_ents; ent++)
 		if (md_setup_args[ent].minor == minor &&
 		    md_setup_args[ent].partitioned == partitioned) {
 			printk(KERN_WARNING "md: md=%s%d, Specified more than once. "
@@ -108,7 +108,7 @@ static int __init md_setup(char *str)
 		fallthrough;
 	case 0:
 		md_setup_args[ent].level = LEVEL_NONE;
-		pername="super-block";
+		pername = "super-block";
 	}
 
 	printk(KERN_INFO "md: Will configure md%d (%s) from %s, below.\n",
@@ -243,9 +243,9 @@ static int __init raid_setup(char *str)
 			raid_noautodetect = 1;
 		if (!strncmp(str, "autodetect", wlen))
 			raid_noautodetect = 0;
-		if (strncmp(str, "partitionable", wlen)==0)
+		if (!strncmp(str, "partitionable", wlen))
 			raid_autopart = 1;
-		if (strncmp(str, "part", wlen)==0)
+		if (!strncmp(str, "part", wlen))
 			raid_autopart = 1;
 		pos += wlen+1;
 	}
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e7cc6ba1b657..f2192aa8b826 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -156,7 +156,7 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 	sector_t target;
 
 	rdev_for_each(rdev, mddev) {
-		if (! test_bit(In_sync, &rdev->flags)
+		if (!test_bit(In_sync, &rdev->flags)
 		    || test_bit(Faulty, &rdev->flags)
 		    || test_bit(Bitmap_sync, &rdev->flags))
 			continue;
@@ -307,8 +307,7 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 		}
 
 		if (wait)
-			wait_event(bitmap->write_wait,
-				   atomic_read(&bitmap->pending_writes)==0);
+			wait_event(bitmap->write_wait, !atomic_read(&bitmap->pending_writes));
 	}
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		md_bitmap_file_kick(bitmap);
@@ -401,8 +400,8 @@ static int read_page(struct file *file, unsigned long index,
 	}
 	page->index = index;
 
-	wait_event(bitmap->write_wait,
-		   atomic_read(&bitmap->pending_writes)==0);
+	wait_event(bitmap->write_wait, !atomic_read(&bitmap->pending_writes));
+
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		ret = -EIO;
 out:
@@ -426,8 +425,7 @@ static int read_page(struct file *file, unsigned long index,
 static void md_bitmap_wait_writes(struct bitmap *bitmap)
 {
 	if (bitmap->storage.file)
-		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes)==0);
+		wait_event(bitmap->write_wait, !atomic_read(&bitmap->pending_writes));
 	else
 		/* Note that we ignore the return value.  The writes
 		 * might have failed, but that would just mean that
@@ -2629,8 +2627,7 @@ behind_writes_used_reset(struct mddev *mddev, const char *buf, size_t len)
 }
 
 static struct md_sysfs_entry max_backlog_used =
-__ATTR(max_backlog_used, S_IRUGO | S_IWUSR,
-       behind_writes_used_show, behind_writes_used_reset);
+__ATTR(max_backlog_used, S_IRUGO | S_IWUSR, behind_writes_used_show, behind_writes_used_reset);
 
 static struct attribute *md_bitmap_attrs[] = {
 	&bitmap_location.attr,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index cfd7395de8fd..0433a0a96c95 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -116,7 +116,7 @@ typedef __u16 bitmap_counter_t;
 enum bitmap_state {
 	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
 	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
-	BITMAP_HOSTENDIAN  =15,
+	BITMAP_HOSTENDIAN  = 15,
 };
 
 /* the superblock at the front of the bitmap file -- little endian */
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 10e0c5381d01..9bcf816b80a1 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -55,7 +55,7 @@ struct resync_info {
  * set up all the related infos such as bitmap and personality */
 #define		MD_CLUSTER_ALREADY_IN_CLUSTER		6
 #define		MD_CLUSTER_PENDING_RECV_EVENT		7
-#define 	MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD		8
+#define		MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD	8
 
 struct md_cluster_info {
 	struct mddev *mddev; /* the md device which md_cluster_info belongs to */
diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index 50ad818978a4..b228447e1f88 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -101,7 +101,7 @@ static int check_sector(struct faulty_conf *conf, sector_t start, sector_t end,
 {
 	/* If we find a ReadFixable sector, we fix it ... */
 	int i;
-	for (i=0; i<conf->nfaults; i++)
+	for (i = 0; i < conf->nfaults; i++)
 		if (conf->faults[i] >= start &&
 		    conf->faults[i] < end) {
 			/* found it ... */
@@ -125,9 +125,9 @@ static void add_sector(struct faulty_conf *conf, sector_t start, int mode)
 {
 	int i;
 	int n = conf->nfaults;
-	for (i=0; i<conf->nfaults; i++)
+	for (i = 0; i < conf->nfaults; i++)
 		if (conf->faults[i] == start) {
-			switch(mode) {
+			switch (mode) {
 			case NoPersist: conf->modes[i] = mode; return;
 			case WritePersistent:
 				if (conf->modes[i] == ReadPersistent ||
@@ -223,28 +223,28 @@ static void faulty_status(struct seq_file *seq, struct mddev *mddev)
 	struct faulty_conf *conf = mddev->private;
 	int n;
 
-	if ((n=atomic_read(&conf->counters[WriteTransient])) != 0)
+	if ((n = atomic_read(&conf->counters[WriteTransient])))
 		seq_printf(seq, " WriteTransient=%d(%d)",
 			   n, conf->period[WriteTransient]);
 
-	if ((n=atomic_read(&conf->counters[ReadTransient])) != 0)
+	if ((n = atomic_read(&conf->counters[ReadTransient])))
 		seq_printf(seq, " ReadTransient=%d(%d)",
 			   n, conf->period[ReadTransient]);
 
-	if ((n=atomic_read(&conf->counters[WritePersistent])) != 0)
+	if ((n = atomic_read(&conf->counters[WritePersistent])))
 		seq_printf(seq, " WritePersistent=%d(%d)",
 			   n, conf->period[WritePersistent]);
 
-	if ((n=atomic_read(&conf->counters[ReadPersistent])) != 0)
+	if ((n = atomic_read(&conf->counters[ReadPersistent])))
 		seq_printf(seq, " ReadPersistent=%d(%d)",
 			   n, conf->period[ReadPersistent]);
 
 
-	if ((n=atomic_read(&conf->counters[ReadFixable])) != 0)
+	if ((n = atomic_read(&conf->counters[ReadFixable])))
 		seq_printf(seq, " ReadFixable=%d(%d)",
 			   n, conf->period[ReadFixable]);
 
-	if ((n=atomic_read(&conf->counters[WriteAll])) != 0)
+	if ((n = atomic_read(&conf->counters[WriteAll])))
 		seq_printf(seq, " WriteAll");
 
 	seq_printf(seq, " nfaults=%d", conf->nfaults);
@@ -265,7 +265,7 @@ static int faulty_reshape(struct mddev *mddev)
 		conf->nfaults = 0;
 	else if (mode == ClearErrors) {
 		int i;
-		for (i=0 ; i < Modes ; i++) {
+		for (i = 0; i < Modes ; i++) {
 			conf->period[i] = 0;
 			atomic_set(&conf->counters[i], 0);
 		}
@@ -304,7 +304,7 @@ static int faulty_run(struct mddev *mddev)
 	if (!conf)
 		return -ENOMEM;
 
-	for (i=0; i<Modes; i++) {
+	for (i = 0; i < Modes; i++) {
 		atomic_set(&conf->counters[i], 0);
 		conf->period[i] = 0;
 	}
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 6e7797b4e738..c0ad603f37a6 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -172,7 +172,7 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	rdev->raid_disk = rdev->saved_raid_disk;
 	rdev->saved_raid_disk = -1;
 
-	newconf = linear_conf(mddev,mddev->raid_disks+1);
+	newconf = linear_conf(mddev, mddev->raid_disks+1);
 
 	if (!newconf)
 		return -ENOMEM;
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 66edf5e72bd6..d772143060bb 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -198,8 +198,7 @@ static void print_multipath_conf (struct mpconf *conf)
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
 			pr_debug(" disk%d, o:%d, dev:%pg\n",
-				 i,!test_bit(Faulty, &tmp->rdev->flags),
-				 tmp->rdev->bdev);
+				 i, !test_bit(Faulty, &tmp->rdev->flags), tmp->rdev->bdev);
 	}
 }
 
@@ -218,7 +217,7 @@ static int multipath_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	print_multipath_conf(conf);
 
 	for (path = first; path <= last; path++)
-		if ((p=conf->multipaths+path)->rdev == NULL) {
+		if (!(p = conf->multipaths+path)->rdev) {
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 
@@ -303,7 +302,7 @@ static void multipathd(struct md_thread *thread)
 		bio = &mp_bh->bio;
 		bio->bi_iter.bi_sector = mp_bh->master_bio->bi_iter.bi_sector;
 
-		if ((mp_bh->path = multipath_map (conf))<0) {
+		if ((mp_bh->path = multipath_map(conf)) < 0) {
 			pr_err("multipath: %pg: unrecoverable IO read error for block %llu\n",
 			       bio->bi_bdev,
 			       (unsigned long long)bio->bi_iter.bi_sector);
@@ -447,7 +446,7 @@ static struct md_personality multipath_personality =
 	.status		= multipath_status,
 	.error_handler	= multipath_error,
 	.hot_add_disk	= multipath_add_disk,
-	.hot_remove_disk= multipath_remove_disk,
+	.hot_remove_disk = multipath_remove_disk,
 	.size		= multipath_size,
 };
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 927a43db5dfb..15be41044d32 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -871,7 +871,7 @@ static struct md_personality *find_pers(int level, char *clevel)
 	list_for_each_entry(pers, &pers_list, list) {
 		if (level != LEVEL_NONE && pers->level == level)
 			return pers;
-		if (strcmp(pers->name, clevel)==0)
+		if (!strcmp(pers->name, clevel))
 			return pers;
 	}
 	return NULL;
@@ -974,7 +974,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 int md_super_wait(struct mddev *mddev)
 {
 	/* wait for all superblock writes that were scheduled to complete */
-	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
+	wait_event(mddev->sb_wait, !atomic_read(&mddev->pending_writes));
 	if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
 		return -EAGAIN;
 	return 0;
@@ -1036,8 +1036,8 @@ static int md_sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 	int ret;
 	mdp_super_t *tmp1, *tmp2;
 
-	tmp1 = kmalloc(sizeof(*tmp1),GFP_KERNEL);
-	tmp2 = kmalloc(sizeof(*tmp2),GFP_KERNEL);
+	tmp1 = kmalloc(sizeof(*tmp1), GFP_KERNEL);
+	tmp2 = kmalloc(sizeof(*tmp2), GFP_KERNEL);
 
 	if (!tmp1 || !tmp2) {
 		ret = 0;
@@ -1335,7 +1335,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 		memcpy(mddev->uuid+0, &sb->set_uuid0, 4);
 		memcpy(mddev->uuid+4, &sb->set_uuid1, 4);
 		memcpy(mddev->uuid+8, &sb->set_uuid2, 4);
-		memcpy(mddev->uuid+12,&sb->set_uuid3, 4);
+		memcpy(mddev->uuid+12, &sb->set_uuid3, 4);
 
 		mddev->max_disks = MD_SB_DISKS;
 
@@ -1417,7 +1417,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	 * been initialised or not.
 	 */
 	int i;
-	int active=0, working=0,failed=0,spare=0,nr_disks=0;
+	int active = 0, working = 0, failed = 0, spare = 0, nr_disks = 0;
 
 	rdev->sb_size = MD_SB_BYTES;
 
@@ -1432,7 +1432,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	memcpy(&sb->set_uuid0, mddev->uuid+0, 4);
 	memcpy(&sb->set_uuid1, mddev->uuid+4, 4);
 	memcpy(&sb->set_uuid2, mddev->uuid+8, 4);
-	memcpy(&sb->set_uuid3, mddev->uuid+12,4);
+	memcpy(&sb->set_uuid3, mddev->uuid+12, 4);
 
 	sb->ctime = clamp_t(time64_t, mddev->ctime, 0, U32_MAX);
 	sb->level = mddev->level;
@@ -1521,7 +1521,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			d->state |= (1<<MD_DISK_FAILFAST);
 	}
 	/* now set the "removed" and "faulty" bits on any missing devices */
-	for (i=0 ; i < mddev->raid_disks ; i++) {
+	for (i = 0; i < mddev->raid_disks; i++) {
 		mdp_disk_t *d = &sb->disks[i];
 		if (d->state == 0 && d->number == 0) {
 			d->number = i;
@@ -1616,7 +1616,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	 * 1: At start of device
 	 * 2: 4K from start of device.
 	 */
-	switch(minor_version) {
+	switch (minor_version) {
 	case 0:
 		sb_start = bdev_nr_sectors(rdev->bdev) - 8 * 2;
 		sb_start &= ~(sector_t)(4*2-1);
@@ -1908,7 +1908,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			rdev->desc_nr = -1;
 		} else
 			role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
-		switch(role) {
+
+		switch (role) {
 		case MD_DISK_ROLE_SPARE: /* spare */
 			break;
 		case MD_DISK_ROLE_FAULTY: /* faulty */
@@ -2043,7 +2044,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_CLUSTERED);
 
 	if (rdev->badblocks.count == 0)
-		/* Nothing to do for bad blocks*/ ;
+		/* Nothing to do for bad blocks*/;
 	else if (sb->bblog_offset == 0)
 		/* Cannot record bad blocks on this device */
 		md_error(mddev, rdev);
@@ -2091,7 +2092,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	} else
 		max_dev = le32_to_cpu(sb->max_dev);
 
-	for (i=0; i<max_dev;i++)
+	for (i = 0; i < max_dev; i++)
 		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_SPARE);
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
@@ -2720,7 +2721,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 		mddev->can_decrease_events = 0;
 	} else {
 		/* otherwise we have to go forward and ... */
-		mddev->events ++;
+		mddev->events++;
 		mddev->can_decrease_events = nospares;
 	}
 
@@ -2753,7 +2754,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 			continue; /* no noise on spare devices */
 
 		if (!test_bit(Faulty, &rdev->flags)) {
-			md_super_write(mddev,rdev,
+			md_super_write(mddev, rdev,
 				       rdev->sb_start, rdev->sb_size,
 				       rdev->sb_page);
 			pr_debug("md: (write) %pg's sb offset: %llu\n",
@@ -3122,7 +3123,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 
 	if (test_bit(Journal, &rdev->flags))
 		return -EBUSY;
-	if (strncmp(buf, "none", 4)==0)
+	if (!strncmp(buf, "none", 4))
 		slot = -1;
 	else {
 		err = kstrtouint(buf, 10, (unsigned int *)&slot);
@@ -3242,7 +3243,7 @@ static ssize_t new_offset_store(struct md_rdev *rdev,
 		return -EINVAL;
 
 	if (mddev->sync_thread ||
-	    test_bit(MD_RECOVERY_RUNNING,&mddev->recovery))
+	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 	if (new_offset == rdev->data_offset)
 		/* reset is always permitted */
@@ -3841,7 +3842,7 @@ safe_delay_store(struct mddev *mddev, const char *cbuf, size_t len)
 	return len;
 }
 static struct md_sysfs_entry md_safe_delay =
-__ATTR(safe_mode_delay, S_IRUGO|S_IWUSR,safe_delay_show, safe_delay_store);
+__ATTR(safe_mode_delay, S_IRUGO|S_IWUSR, safe_delay_show, safe_delay_store);
 
 static ssize_t
 level_show(struct mddev *mddev, char *page)
@@ -4315,7 +4316,7 @@ static char *array_states[] = {
 static int match_word(const char *word, char **list)
 {
 	int n;
-	for (n=0; list[n]; n++)
+	for (n = 0; list[n]; n++)
 		if (cmd_match(word, list[n]))
 			break;
 	return n;
@@ -4327,7 +4328,7 @@ array_state_show(struct mddev *mddev, char *page)
 	enum array_state st = inactive;
 
 	if (mddev->pers && !test_bit(MD_NOT_READY, &mddev->flags)) {
-		switch(mddev->ro) {
+		switch (mddev->ro) {
 		case MD_RDONLY:
 			st = readonly;
 			break;
@@ -4395,7 +4396,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 	err = -EINVAL;
-	switch(st) {
+	switch (st) {
 	case bad_word:
 		break;
 	case clear:
@@ -4725,11 +4726,11 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	major = simple_strtoul(buf, &e, 10);
 	err = -EINVAL;
-	if (e==buf || *e != '.')
+	if (e == buf || *e != '.')
 		goto out_unlock;
 	buf = e+1;
 	minor = simple_strtoul(buf, &e, 10);
-	if (e==buf || (*e && *e != '\n') )
+	if (e == buf || (*e && *e != '\n'))
 		goto out_unlock;
 	err = -ENOENT;
 	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
@@ -4879,7 +4880,7 @@ static ssize_t
 sync_min_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_min(mddev),
-		       mddev->sync_speed_min ? "local": "system");
+		       mddev->sync_speed_min ? "local" : "system");
 }
 
 static ssize_t
@@ -4888,7 +4889,7 @@ sync_min_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned int min;
 	int rv;
 
-	if (strncmp(buf, "system", 6)==0) {
+	if (!strncmp(buf, "system", 6)) {
 		min = 0;
 	} else {
 		rv = kstrtouint(buf, 10, &min);
@@ -4908,7 +4909,7 @@ static ssize_t
 sync_max_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_max(mddev),
-		       mddev->sync_speed_max ? "local": "system");
+		       mddev->sync_speed_max ? "local" : "system");
 }
 
 static ssize_t
@@ -4917,7 +4918,7 @@ sync_max_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned int max;
 	int rv;
 
-	if (strncmp(buf, "system", 6)==0) {
+	if (!strncmp(buf, "system", 6)) {
 		max = 0;
 	} else {
 		rv = kstrtouint(buf, 10, &max);
@@ -6303,7 +6304,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
 	if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
 	    mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-		pr_warn("md: %s still in use.\n",mdname(mddev));
+		pr_warn("md: %s still in use.\n", mdname(mddev));
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -6365,7 +6366,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	    mddev->sysfs_active ||
 	    mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-		pr_warn("md: %s still in use.\n",mdname(mddev));
+		pr_warn("md: %s still in use.\n", mdname(mddev));
 		mutex_unlock(&mddev->open_mutex);
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -6549,7 +6550,7 @@ static int get_version(void __user *arg)
 static int get_array_info(struct mddev *mddev, void __user *arg)
 {
 	mdu_array_info_t info;
-	int nr,working,insync,failed,spare;
+	int nr, working, insync, failed, spare;
 	struct md_rdev *rdev;
 
 	nr = working = insync = failed = spare = 0;
@@ -6582,7 +6583,7 @@ static int get_array_info(struct mddev *mddev, void __user *arg)
 	info.nr_disks      = nr;
 	info.raid_disks    = mddev->raid_disks;
 	info.md_minor      = mddev->md_minor;
-	info.not_persistent= !mddev->persistent;
+	info.not_persistent = !mddev->persistent;
 
 	info.utime         = clamp_t(time64_t, mddev->utime, 0, U32_MAX);
 	info.state         = 0;
@@ -6681,7 +6682,7 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 {
 	struct md_rdev *rdev;
-	dev_t dev = MKDEV(info->major,info->minor);
+	dev_t dev = MKDEV(info->major, info->minor);
 
 	if (mddev_is_clustered(mddev) &&
 		!(info->state & ((1 << MD_DISK_CLUSTER_ADD) | (1 << MD_DISK_CANDIDATE)))) {
@@ -7140,7 +7141,7 @@ int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
 		mddev->recovery_cp = MaxSector;
 	else
 		mddev->recovery_cp = 0;
-	mddev->persistent    = ! info->not_persistent;
+	mddev->persistent    = !info->not_persistent;
 	mddev->external	     = 0;
 
 	mddev->layout        = info->layout;
@@ -7729,7 +7730,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		mddev->hold_active = 0;
 	mddev_unlock(mddev);
 out:
-	if(did_set_md_closing)
+	if (did_set_md_closing)
 		clear_bit(MD_CLOSING, &mddev->flags);
 	return err;
 }
@@ -8078,7 +8079,7 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	 */
 	scale = 10;
 	if (sizeof(sector_t) > sizeof(unsigned long)) {
-		while ( max_sectors/2 > (1ULL<<(scale+32)))
+		while (max_sectors/2 > (1ULL<<(scale+32)))
 			scale++;
 	}
 	res = (resync>>scale)*1000;
@@ -8096,9 +8097,9 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 		seq_printf(seq, "] ");
 	}
 	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)",
-		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)?
+		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
 		    "reshape" :
-		    (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)?
+		    (test_bit(MD_RECOVERY_CHECK, &mddev->recovery) ?
 		     "check" :
 		     (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?
 		      "resync" : "recovery"))),
@@ -8162,7 +8163,7 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 		return (void*)1;
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each(tmp,&all_mddevs)
+	list_for_each(tmp, &all_mddevs)
 		if (!l--) {
 			mddev = list_entry(tmp, struct mddev, all_mddevs);
 			if (!mddev_get(mddev))
@@ -8290,7 +8291,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		if (mddev->persistent) {
 			if (mddev->major_version != 0 ||
 			    mddev->minor_version != 90) {
-				seq_printf(seq," super %d.%d",
+				seq_printf(seq, " super %d.%d",
 					   mddev->major_version,
 					   mddev->minor_version);
 			}
@@ -8708,11 +8709,11 @@ void md_do_sync(struct md_thread *thread)
 	struct mddev *mddev = thread->mddev;
 	struct mddev *mddev2;
 	unsigned int currspeed = 0, window;
-	sector_t max_sectors,j, io_sectors, recovery_done;
+	sector_t max_sectors, j, io_sectors, recovery_done;
 	unsigned long mark[SYNC_MARKS];
 	unsigned long update_time;
 	sector_t mark_cnt[SYNC_MARKS];
-	int last_mark,m;
+	int last_mark, m;
 	sector_t last_check;
 	int skipped = 0;
 	struct md_rdev *rdev;
@@ -8988,7 +8989,7 @@ void md_do_sync(struct md_thread *thread)
 
 		last_check = io_sectors;
 	repeat:
-		if (time_after_eq(jiffies, mark[last_mark] + SYNC_MARK_STEP )) {
+		if (time_after_eq(jiffies, mark[last_mark] + SYNC_MARK_STEP)) {
 			/* step marks */
 			int next = (last_mark+1) % SYNC_MARKS;
 
@@ -9031,7 +9032,7 @@ void md_do_sync(struct md_thread *thread)
 			}
 		}
 	}
-	pr_info("md: %s: %s %s.\n",mdname(mddev), desc,
+	pr_info("md: %s: %s %s.\n", mdname(mddev), desc,
 		test_bit(MD_RECOVERY_INTR, &mddev->recovery)
 		? "interrupted" : "done");
 	/*
@@ -9139,7 +9140,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 		    rdev->raid_disk >= 0 &&
 		    !test_bit(Blocked, &rdev->flags) &&
 		    test_bit(Faulty, &rdev->flags) &&
-		    atomic_read(&rdev->nr_pending)==0) {
+		    !atomic_read(&rdev->nr_pending)) {
 			/* Faulty non-Blocked devices with nr_pending == 0
 			 * never get nr_pending incremented,
 			 * never get Faulty cleared, and never get Blocked set.
@@ -9159,7 +9160,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 		    ((test_bit(RemoveSynchronized, &rdev->flags) ||
 		     (!test_bit(In_sync, &rdev->flags) &&
 		      !test_bit(Journal, &rdev->flags))) &&
-		    atomic_read(&rdev->nr_pending)==0)) {
+		    !atomic_read(&rdev->nr_pending))) {
 			if (mddev->pers->hot_remove_disk(
 				    mddev, rdev) == 0) {
 				sysfs_unlink_rdev(mddev, rdev);
@@ -9296,14 +9297,11 @@ void md_check_recovery(struct mddev *mddev)
 	if (!md_is_rdwr(mddev) &&
 	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return;
-	if ( ! (
-		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
-		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
-		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-		(mddev->external == 0 && mddev->safemode == 1) ||
-		(mddev->safemode == 2
-		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
-		))
+	if (!((mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING)) ||
+	       test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
+	       test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
+	       (mddev->external == 0 && mddev->safemode == 1) ||
+	       (mddev->safemode == 2 && !mddev->in_sync && mddev->recovery_cp == MaxSector)))
 		return;
 
 	if (mddev_trylock(mddev)) {
@@ -9894,7 +9892,7 @@ void md_autostart_arrays(int part)
 		dev = node_detected_dev->dev;
 		kfree(node_detected_dev);
 		mutex_unlock(&detected_devices_mutex);
-		rdev = md_import_device(dev,0, 90);
+		rdev = md_import_device(dev, 0, 90);
 		mutex_lock(&detected_devices_mutex);
 		if (IS_ERR(rdev))
 			continue;
@@ -9920,7 +9918,7 @@ static __exit void md_exit(void)
 	struct mddev *mddev, *n;
 	int delay = 1;
 
-	unregister_blkdev(MD_MAJOR,"md");
+	unregister_blkdev(MD_MAJOR, "md");
 	unregister_blkdev(mdp_major, "mdp");
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e148e3c83b0d..39df217b51be 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -652,7 +652,7 @@ static inline void sysfs_notify_dirent_safe(struct kernfs_node *sd)
 		sysfs_notify_dirent(sd);
 }
 
-static inline char * mdname (struct mddev * mddev)
+static inline char * mdname(struct mddev * mddev)
 {
 	return mddev->gendisk ? mddev->gendisk->disk_name : "mdX";
 }
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b536befd8898..6129ab4d4708 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -41,7 +41,7 @@ static void dump_zones(struct mddev *mddev)
 	int raid_disks = conf->strip_zone[0].nb_dev;
 	pr_debug("md: RAID0 configuration for %s - %d zone%s\n",
 		 mdname(mddev),
-		 conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
+		 conf->nr_strip_zones, conf->nr_strip_zones == 1 ? "" : "s");
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		char line[200];
 		int len = 0;
@@ -218,7 +218,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		smallest = NULL;
 		c = 0;
 
-		for (j=0; j<cnt; j++) {
+		for (j = 0; j < cnt; j++) {
 			rdev = conf->devlist[j];
 			if (rdev->sectors <= zone->dev_start) {
 				pr_debug("md/raid0:%s: checking %pg ... nope\n",
@@ -323,7 +323,7 @@ static struct md_rdev *map_sector(struct mddev *mddev, struct strip_zone *zone,
 		chunk = *sector_offset;
 		/* quotient is the chunk in real device*/
 		sector_div(chunk, zone->nb_dev << chunksect_bits);
-	} else{
+	} else {
 		sect_in_chunk = sector_div(sector, chunk_sects);
 		chunk = *sector_offset;
 		sector_div(chunk, chunk_sects * zone->nb_dev);
@@ -660,7 +660,7 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
-	mddev->delta_disks = - mddev->raid_disks / 2;
+	mddev->delta_disks = -mddev->raid_disks / 2;
 	mddev->raid_disks += mddev->delta_disks;
 	mddev->degraded = 0;
 	/* make sure it will be not marked as dirty */
@@ -755,7 +755,7 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
 {
 }
 
-static struct md_personality raid0_personality=
+static struct md_personality raid0_personality =
 {
 	.name		= "raid0",
 	.level		= 0,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 68a9e2d9985b..884983c89491 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1616,7 +1616,7 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 	if (bio_data_dir(bio) == READ)
 		raid1_read_request(mddev, bio, sectors, NULL);
 	else {
-		if (!md_write_start(mddev,bio))
+		if (!md_write_start(mddev, bio))
 			return false;
 		raid1_write_request(mddev, bio, sectors);
 	}
@@ -2040,7 +2040,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			bio->bi_end_io = end_sync_write;
 	}
 
-	while(sectors) {
+	while (sectors) {
 		int s = sectors;
 		int d = r1_bio->read_disk;
 		int success = 0;
@@ -2130,7 +2130,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		}
 		sectors -= s;
 		sect += s;
-		idx ++;
+		idx++;
 	}
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
 	bio->bi_status = 0;
@@ -2280,7 +2280,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			   sector_t sect, int sectors)
 {
 	struct mddev *mddev = conf->mddev;
-	while(sectors) {
+	while (sectors) {
 		int s = sectors;
 		int d = read_disk;
 		int success = 0;
@@ -2327,7 +2327,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		/* write it back and re-read */
 		start = d;
 		while (d != read_disk) {
-			if (d==0)
+			if (!d)
 				d = conf->raid_disks * 2;
 			d--;
 			rcu_read_lock();
@@ -2344,7 +2344,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		}
 		d = start;
 		while (d != read_disk) {
-			if (d==0)
+			if (!d)
 				d = conf->raid_disks * 2;
 			d--;
 			rcu_read_lock();
@@ -2772,7 +2772,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		} else if (!test_bit(In_sync, &rdev->flags)) {
 			bio->bi_opf = REQ_OP_WRITE;
 			bio->bi_end_io = end_sync_write;
-			write_targets ++;
+			write_targets++;
 		} else {
 			/* may need to read from here */
 			sector_t first_bad = MaxSector;
@@ -3282,8 +3282,8 @@ static int raid1_reshape(struct mddev *mddev)
 	raid_disks = mddev->raid_disks + mddev->delta_disks;
 
 	if (raid_disks < conf->raid_disks) {
-		cnt=0;
-		for (d= 0; d < conf->raid_disks; d++)
+		cnt = 0;
+		for (d = 0; d < conf->raid_disks; d++)
 			if (conf->mirrors[d].rdev)
 				cnt++;
 		if (cnt > raid_disks)
@@ -3394,7 +3394,7 @@ static struct md_personality raid1_personality =
 	.status		= raid1_status,
 	.error_handler	= raid1_error,
 	.hot_add_disk	= raid1_add_disk,
-	.hot_remove_disk= raid1_remove_disk,
+	.hot_remove_disk = raid1_remove_disk,
 	.spare_active	= raid1_spare_active,
 	.sync_request	= raid1_sync_request,
 	.resize		= raid1_resize,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6c66357f92f5..3a5946fa2b90 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -261,7 +261,7 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
 	int i;
 
 	for (i = 0; i < conf->geo.raid_disks; i++) {
-		struct bio **bio = & r10_bio->devs[i].bio;
+		struct bio **bio = &r10_bio->devs[i].bio;
 		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
 		*bio = NULL;
@@ -303,7 +303,7 @@ static void reschedule_retry(struct r10bio *r10_bio)
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	list_add(&r10_bio->retry_list, &conf->retry_list);
-	conf->nr_queued ++;
+	conf->nr_queued++;
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	/* wake up frozen array... */
@@ -588,7 +588,7 @@ static void raid10_end_write_request(struct bio *bio)
 
 static void __raid10_find_phys(struct geom *geo, struct r10bio *r10bio)
 {
-	int n,f;
+	int n, f;
 	sector_t sector;
 	sector_t chunk;
 	sector_t stripe;
@@ -2402,7 +2402,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	atomic_set(&r10_bio->remaining, 1);
 
 	/* find the first device with a block */
-	for (i=0; i<conf->copies; i++)
+	for (i = 0; i < conf->copies; i++)
 		if (!r10_bio->devs[i].bio->bi_status)
 			break;
 
@@ -2417,7 +2417,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
 	/* now find blocks with errors */
-	for (i=0 ; i < conf->copies ; i++) {
+	for (i = 0; i < conf->copies; i++) {
 		int  j, d;
 		struct md_rdev *rdev;
 		struct resync_pages *rp;
@@ -2742,7 +2742,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		return;
 	}
 
-	while(sectors) {
+	while (sectors) {
 		int s = sectors;
 		int sl = r10_bio->read_slot;
 		int success = 0;
@@ -2806,7 +2806,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		/* write it back and re-read */
 		rcu_read_lock();
 		while (sl != r10_bio->read_slot) {
-			if (sl==0)
+			if (!sl)
 				sl = conf->copies;
 			sl--;
 			d = r10_bio->devs[sl].devnum;
@@ -2840,7 +2840,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		}
 		sl = start;
 		while (sl != r10_bio->read_slot) {
-			if (sl==0)
+			if (!sl)
 				sl = conf->copies;
 			sl--;
 			d = r10_bio->devs[sl].devnum;
@@ -3511,7 +3511,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 							 &sync_blocks, still_degraded);
 
 			any_working = 0;
-			for (j=0; j<conf->copies;j++) {
+			for (j = 0; j < conf->copies; j++) {
 				int k;
 				int d = r10_bio->devs[j].devnum;
 				sector_t from_addr, to_addr;
@@ -3552,7 +3552,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				atomic_inc(&rdev->nr_pending);
 				/* and we write to 'i' (if not in_sync) */
 
-				for (k=0; k<conf->copies; k++)
+				for (k = 0; k < conf->copies; k++)
 					if (r10_bio->devs[k].devnum == i)
 						break;
 				BUG_ON(k == conf->copies);
@@ -3774,7 +3774,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 
 		if (count < 2) {
-			for (i=0; i<conf->copies; i++) {
+			for (i = 0; i < conf->copies; i++) {
 				int d = r10_bio->devs[i].devnum;
 				if (r10_bio->devs[i].bio->bi_end_io)
 					rdev_dec_pending(conf->mirrors[d].rdev,
@@ -3801,7 +3801,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
-		for (bio= biolist ; bio ; bio=bio->bi_next) {
+		for (bio = biolist; bio; bio = bio->bi_next) {
 			struct resync_pages *rp = get_resync_pages(bio);
 			page = resync_fetch_page(rp, page_idx);
 			/*
@@ -3892,7 +3892,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		max_sector = sector_nr + max_sync;
 
 	sectors_skipped += (max_sector - sector_nr);
-	chunks_skipped ++;
+	chunks_skipped++;
 	sector_nr = max_sector;
 	goto skipped;
 }
@@ -5257,7 +5257,7 @@ static struct md_personality raid10_personality =
 	.status		= raid10_status,
 	.error_handler	= raid10_error,
 	.hot_add_disk	= raid10_add_disk,
-	.hot_remove_disk= raid10_remove_disk,
+	.hot_remove_disk = raid10_remove_disk,
 	.spare_active	= raid10_spare_active,
 	.sync_request	= raid10_sync_request,
 	.quiesce	= raid10_quiesce,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b820b81d8c2..a4351ff3fe31 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -225,7 +225,7 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 	int injournal = 0;	/* number of date pages with R5_InJournal */
 
 	BUG_ON(!list_empty(&sh->lru));
-	BUG_ON(atomic_read(&conf->active_stripes)==0);
+	BUG_ON(!atomic_read(&conf->active_stripes));
 
 	if (r5c_is_writeback(conf->log))
 		for (i = sh->disks; i--; )
@@ -2606,7 +2606,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		osh->pages[i] = NULL;
 	}
 #endif
-		for(i=0; i<conf->pool_size; i++) {
+		for (i = 0; i < conf->pool_size; i++) {
 			nsh->dev[i].page = osh->dev[i].page;
 			nsh->dev[i].orig_page = osh->dev[i].page;
 			nsh->dev[i].offset = osh->dev[i].offset;
@@ -2654,7 +2654,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	conf->active_name = 1-conf->active_name;
 
 	/* Step 4, return new stripes to service */
-	while(!list_empty(&newstripes)) {
+	while (!list_empty(&newstripes)) {
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
 		list_del_init(&nsh->lru);
 
@@ -2675,7 +2675,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 			nsh->dev[i].offset = raid5_get_page_offset(nsh, i);
 		}
 #else
-		for (i=conf->raid_disks; i < newsize; i++)
+		for (i = conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
 				struct page *p = alloc_page(GFP_NOIO);
 				nsh->dev[i].page = p;
@@ -2754,7 +2754,7 @@ static void raid5_end_read_request(struct bio * bi)
 	struct md_rdev *rdev = NULL;
 	sector_t s;
 
-	for (i=0 ; i<disks; i++)
+	for (i = 0; i < disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
 
@@ -3026,7 +3026,7 @@ sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
 	 * Select the parity disk based on the user selected algorithm.
 	 */
 	pd_idx = qd_idx = -1;
-	switch(conf->level) {
+	switch (conf->level) {
 	case 4:
 		pd_idx = data_disks;
 		break;
@@ -3214,7 +3214,7 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
 
 	if (i == sh->pd_idx)
 		return 0;
-	switch(conf->level) {
+	switch (conf->level) {
 	case 4: break;
 	case 5:
 		switch (algorithm) {
@@ -3568,7 +3568,7 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
 	if (forwrite) {
 		/* check if page is covered */
 		sector_t sector = sh->dev[dd_idx].sector;
-		for (bi=sh->dev[dd_idx].towrite;
+		for (bi = sh->dev[dd_idx].towrite;
 		     sector < sh->dev[dd_idx].sector + RAID5_STRIPE_SECTORS(conf) &&
 			     bi && bi->bi_iter.bi_sector <= sector;
 		     bi = r5_next_bio(conf, bi, sh->dev[dd_idx].sector)) {
@@ -4291,7 +4291,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 	}
 	if ((rcw < rmw || (rcw == rmw && conf->rmw_level != PARITY_PREFER_RMW)) && rcw > 0) {
 		/* want reconstruct write, but need to get some data */
-		int qread =0;
+		int qread = 0;
 		rcw = 0;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -4702,7 +4702,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
-	for (i=disks; i--; ) {
+	for (i = disks; i--; ) {
 		struct md_rdev *rdev;
 		sector_t first_bad;
 		int bad_sectors;
@@ -5426,7 +5426,7 @@ static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
  *  add bio to the retry LIFO  ( in O(1) ... we are in interrupt )
  *  later sampled by raid5d.
  */
-static void add_bio_to_retry(struct bio *bi,struct r5conf *conf)
+static void add_bio_to_retry(struct bio *bi, struct r5conf *conf)
 {
 	unsigned long flags;
 
@@ -5451,7 +5451,7 @@ static struct bio *remove_bio_from_retry(struct r5conf *conf,
 		return bi;
 	}
 	bi = conf->retry_read_aligned_list;
-	if(bi) {
+	if (bi) {
 		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
 		*offset = 0;
@@ -6328,8 +6328,8 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Cannot proceed until we've updated the superblock... */
 		wait_event(conf->wait_for_overlap,
-			   atomic_read(&conf->reshape_stripes)==0
-			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
+			   !atomic_read(&conf->reshape_stripes) ||
+			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (atomic_read(&conf->reshape_stripes) != 0)
 			return 0;
 		mddev->reshape_position = conf->reshape_progress;
@@ -6368,7 +6368,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		/* If any of this stripe is beyond the end of the old
 		 * array, then we need to zero those blocks
 		 */
-		for (j=sh->disks; j--;) {
+		for (j = sh->disks; j--; ) {
 			sector_t s;
 			if (j == sh->pd_idx)
 				continue;
@@ -7400,7 +7400,7 @@ static unsigned long raid5_cache_scan(struct shrinker *shrink,
 	unsigned long ret = SHRINK_STOP;
 
 	if (mutex_trylock(&conf->cache_size_mutex)) {
-		ret= 0;
+		ret = 0;
 		while (ret < sc->nr_to_scan &&
 		       conf->max_nr_stripes > conf->min_nr_stripes) {
 			if (drop_one_stripe(conf) == 0) {
@@ -8580,7 +8580,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 		rdev_for_each(rdev, mddev)
 			rdev->new_data_offset = rdev->data_offset;
 		smp_wmb();
-		conf->generation --;
+		conf->generation--;
 		conf->reshape_progress = MaxSector;
 		mddev->reshape_position = MaxSector;
 		write_seqcount_end(&conf->gen_lock);
@@ -9015,7 +9015,7 @@ static struct md_personality raid6_personality =
 	.status		= raid5_status,
 	.error_handler	= raid5_error,
 	.hot_add_disk	= raid5_add_disk,
-	.hot_remove_disk= raid5_remove_disk,
+	.hot_remove_disk = raid5_remove_disk,
 	.spare_active	= raid5_spare_active,
 	.sync_request	= raid5_sync_request,
 	.resize		= raid5_resize,
@@ -9039,7 +9039,7 @@ static struct md_personality raid5_personality =
 	.status		= raid5_status,
 	.error_handler	= raid5_error,
 	.hot_add_disk	= raid5_add_disk,
-	.hot_remove_disk= raid5_remove_disk,
+	.hot_remove_disk = raid5_remove_disk,
 	.spare_active	= raid5_spare_active,
 	.sync_request	= raid5_sync_request,
 	.resize		= raid5_resize,
@@ -9064,7 +9064,7 @@ static struct md_personality raid4_personality =
 	.status		= raid5_status,
 	.error_handler	= raid5_error,
 	.hot_add_disk	= raid5_add_disk,
-	.hot_remove_disk= raid5_remove_disk,
+	.hot_remove_disk = raid5_remove_disk,
 	.spare_active	= raid5_spare_active,
 	.sync_request	= raid5_sync_request,
 	.resize		= raid5_resize,
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index f29aaaf2eb21..c629bfae826f 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -160,7 +160,7 @@ void raid6_dual_recov(int disks, size_t bytes, int faila, int failb,
 #ifndef __KERNEL__
 
 # define jiffies	raid6_jiffies()
-# define printk 	printf
+# define printk		printf
 # define pr_err(format, ...) fprintf(stderr, format, ## __VA_ARGS__)
 # define pr_info(format, ...) fprintf(stdout, format, ## __VA_ARGS__)
 # define GFP_KERNEL	0
-- 
2.39.2

