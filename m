Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB10EC6FD1A
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjCFV3T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCFV25 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:28:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE0A23678
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qCMOQ2Q0kScxlyVP9UdFlrkOHWx7WAu7rPUHQK5wrYg=;
        b=THhDtJ5TmrsL3VNgYOPTFyKOrqasQXVSSJriPg0h/ZE6gI9BD0fr8hHt3NUy/CzUim2+3W
        VZ52gR8V9If4RlkQpIrD3ZC1i1NG+Kz1vxqsYf0Q6sqCQpwG2hsnu1ri71wM1rP9l9D62N
        L64L6OItxEoZSu7k5mGYxv06q1mHpTE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-e1HIPfdkMRmiZEYhUgIqZw-1; Mon, 06 Mar 2023 16:28:03 -0500
X-MC-Unique: e1HIPfdkMRmiZEYhUgIqZw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D13C2885623
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:02 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18C3E40CF8F0;
        Mon,  6 Mar 2023 21:28:01 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 04/34] md: adjust braces on functions/structures [ERROR]
Date:   Mon,  6 Mar 2023 22:27:27 +0100
Message-Id: <6e8d93aeb81a512d025f1bfdd18f58aa6a4a4365.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Also avoided a few superfluous line splits.

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-faulty.c    |  3 +--
 drivers/md/md-linear.c    |  3 +--
 drivers/md/md-linear.h    |  3 +--
 drivers/md/md-multipath.c |  3 +--
 drivers/md/md.c           | 13 +++++--------
 drivers/md/md.h           |  3 +--
 drivers/md/raid0.c        |  6 ++----
 drivers/md/raid1.c        |  3 +--
 drivers/md/raid10.c       |  3 +--
 drivers/md/raid5.c        | 10 ++++------
 10 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index b228447e1f88..8493432a732e 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -331,8 +331,7 @@ static void faulty_free(struct mddev *mddev, void *priv)
 	kfree(conf);
 }
 
-static struct md_personality faulty_personality =
-{
+static struct md_personality faulty_personality = {
 	.name		= "faulty",
 	.level		= LEVEL_FAULTY,
 	.owner		= THIS_MODULE,
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index c0ad603f37a6..35ee116bf45b 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -274,8 +274,7 @@ static void linear_quiesce(struct mddev *mddev, int state)
 {
 }
 
-static struct md_personality linear_personality =
-{
+static struct md_personality linear_personality = {
 	.name		= "linear",
 	.level		= LEVEL_LINEAR,
 	.owner		= THIS_MODULE,
diff --git a/drivers/md/md-linear.h b/drivers/md/md-linear.h
index 24e97db50ebb..56906a30a577 100644
--- a/drivers/md/md-linear.h
+++ b/drivers/md/md-linear.h
@@ -7,8 +7,7 @@ struct dev_info {
 	sector_t	end_sector;
 };
 
-struct linear_conf
-{
+struct linear_conf {
 	struct rcu_head		rcu;
 	sector_t		array_sectors;
 	int			raid_disks; /* a copy of mddev->raid_disks */
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 932e9fc4b953..c6c0a76c5210 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -435,8 +435,7 @@ static void multipath_free(struct mddev *mddev, void *priv)
 	kfree(conf);
 }
 
-static struct md_personality multipath_personality =
-{
+static struct md_personality multipath_personality = {
 	.name		= "multipath",
 	.level		= LEVEL_MULTIPATH,
 	.owner		= THIS_MODULE,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index cfa957c8287b..315b0810dbdd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1456,8 +1456,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->new_chunk = mddev->new_chunk_sectors << 9;
 	}
 	mddev->minor_version = sb->minor_version;
-	if (mddev->in_sync)
-	{
+	if (mddev->in_sync) {
 		sb->recovery_cp = mddev->recovery_cp;
 		sb->cp_events_hi = (mddev->events>>32);
 		sb->cp_events_lo = (u32)mddev->events;
@@ -4480,10 +4479,9 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_array_state =
 __ATTR_PREALLOC(array_state, S_IRUGO|S_IWUSR, array_state_show, array_state_store);
 
-static ssize_t
-max_corrected_read_errors_show(struct mddev *mddev, char *page) {
-	return sprintf(page, "%d\n",
-		       atomic_read(&mddev->max_corr_read_errors));
+static ssize_t max_corrected_read_errors_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%d\n", atomic_read(&mddev->max_corr_read_errors));
 }
 
 static ssize_t
@@ -7847,8 +7845,7 @@ static void md_free_disk(struct gendisk *disk)
 	mddev_free(mddev);
 }
 
-const struct block_device_operations md_fops =
-{
+const struct block_device_operations md_fops = {
 	.owner		= THIS_MODULE,
 	.submit_bio	= md_submit_bio,
 	.open		= md_open,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 10fc3da0dafd..45f8ada8814e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -584,8 +584,7 @@ static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
 	md_sync_acct(bio->bi_bdev, nr_sectors);
 }
 
-struct md_personality
-{
+struct md_personality {
 	char *name;
 	int level;
 	struct list_head list;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6129ab4d4708..582457cea439 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -206,8 +206,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	curr_zone_end = zone->zone_end;
 
 	/* now do the other zones */
-	for (i = 1; i < conf->nr_strip_zones; i++)
-	{
+	for (i = 1; i < conf->nr_strip_zones; i++) {
 		int j;
 
 		zone = conf->strip_zone + i;
@@ -755,8 +754,7 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
 {
 }
 
-static struct md_personality raid0_personality =
-{
+static struct md_personality raid0_personality = {
 	.name		= "raid0",
 	.level		= 0,
 	.owner		= THIS_MODULE,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0701f11a0da8..415b1dd55baa 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3383,8 +3383,7 @@ static void *raid1_takeover(struct mddev *mddev)
 	return ERR_PTR(-EINVAL);
 }
 
-static struct md_personality raid1_personality =
-{
+static struct md_personality raid1_personality = {
 	.name		= "raid1",
 	.level		= 1,
 	.owner		= THIS_MODULE,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f95806a5606e..cdc2f2557966 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -5246,8 +5246,7 @@ static void raid10_finish_reshape(struct mddev *mddev)
 	mddev->reshape_backwards = 0;
 }
 
-static struct md_personality raid10_personality =
-{
+static struct md_personality raid10_personality = {
 	.name		= "raid10",
 	.level		= 10,
 	.owner		= THIS_MODULE,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e4dd6304c018..73060e4124b4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -9003,8 +9003,7 @@ static int raid5_start(struct mddev *mddev)
 	return r5l_start(conf->log);
 }
 
-static struct md_personality raid6_personality =
-{
+static struct md_personality raid6_personality = {
 	.name		= "raid6",
 	.level		= 6,
 	.owner		= THIS_MODULE,
@@ -9027,8 +9026,8 @@ static struct md_personality raid6_personality =
 	.takeover	= raid6_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 };
-static struct md_personality raid5_personality =
-{
+
+static struct md_personality raid5_personality = {
 	.name		= "raid5",
 	.level		= 5,
 	.owner		= THIS_MODULE,
@@ -9052,8 +9051,7 @@ static struct md_personality raid5_personality =
 	.change_consistency_policy = raid5_change_consistency_policy,
 };
 
-static struct md_personality raid4_personality =
-{
+static struct md_personality raid4_personality = {
 	.name		= "raid4",
 	.level		= 4,
 	.owner		= THIS_MODULE,
-- 
2.39.2

