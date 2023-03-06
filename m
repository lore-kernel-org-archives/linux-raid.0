Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91BCC6FD1D
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCFV24 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjCFV2w (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:28:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5379C244A6
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ntRSudzhZdXUzvVU6E5sHdID3YMzjukAYSos7ywKUVo=;
        b=d7PgoO5j2HmKy6QaRMBHSHcc3wBZFsCEf/Hiqasx/iv6egzeTx28jBeZtLnMKdTAODwUEE
        JgBw2v3gsVmsFB+KPMQngQ5qoiBt61lj9Z3+tRJfN3dIudnrn8zg8c0zHN+wcVPz/Ew8ap
        Hfx1DKbNcOg4wZJd913/AuEu6Fv0ZhE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-bg-sq-43MwK6mWB1Rb06xQ-1; Mon, 06 Mar 2023 16:28:01 -0500
X-MC-Unique: bg-sq-43MwK6mWB1Rb06xQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D519B183B3C6
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:00 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CF6D40C83B6;
        Mon,  6 Mar 2023 21:27:59 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 02/34] md: fix 'foo*' and 'foo * bar' [ERROR]
Date:   Mon,  6 Mar 2023 22:27:25 +0100
Message-Id: <991dc88e752cbd7d004cd676b9344a9959f8bef9.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md-multipath.c |  4 ++--
 drivers/md/md.c           | 26 +++++++++++++-------------
 drivers/md/md.h           |  2 +-
 drivers/md/raid1.c        |  4 ++--
 drivers/md/raid10.c       | 12 ++++++------
 drivers/md/raid5.c        |  6 +++---
 include/linux/raid/xor.h  | 28 ++++++++++++++--------------
 7 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index d772143060bb..932e9fc4b953 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -97,10 +97,10 @@ static void multipath_end_request(struct bio *bio)
 	rdev_dec_pending(rdev, conf->mddev);
 }
 
-static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
+static bool multipath_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct mpconf *conf = mddev->private;
-	struct multipath_bh * mp_bh;
+	struct multipath_bh *mp_bh;
 	struct multipath_info *multipath;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 15be41044d32..8727ebab4b95 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1069,7 +1069,7 @@ static u32 md_csum_fold(u32 csum)
 static unsigned int calc_sb_csum(mdp_super_t *sb)
 {
 	u64 newcsum = 0;
-	u32 *sb32 = (u32*)sb;
+	u32 *sb32 = (u32 *)sb;
 	int i;
 	unsigned int disk_csum, csum;
 
@@ -1583,7 +1583,7 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 *sb)
 	u32 csum;
 	unsigned long long newcsum;
 	int size = 256 + le32_to_cpu(sb->max_dev)*2;
-	__le32 *isuper = (__le32*)sb;
+	__le32 *isuper = (__le32 *)sb;
 
 	disk_csum = sb->sb_csum;
 	sb->sb_csum = 0;
@@ -1592,7 +1592,7 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 *sb)
 		newcsum += le32_to_cpu(*isuper++);
 
 	if (size == 2)
-		newcsum += le16_to_cpu(*(__le16*) isuper);
+		newcsum += le16_to_cpu(*(__le16 *) isuper);
 
 	csum = (newcsum & 0xffffffff) + (newcsum >> 32);
 	sb->sb_csum = disk_csum;
@@ -6607,7 +6607,7 @@ static int get_array_info(struct mddev *mddev, void __user *arg)
 	return 0;
 }
 
-static int get_bitmap_file(struct mddev *mddev, void __user * arg)
+static int get_bitmap_file(struct mddev *mddev, void __user *arg)
 {
 	mdu_bitmap_file_t *file = NULL; /* too big for stack allocation */
 	char *ptr;
@@ -6639,7 +6639,7 @@ static int get_bitmap_file(struct mddev *mddev, void __user * arg)
 	return err;
 }
 
-static int get_disk_info(struct mddev *mddev, void __user * arg)
+static int get_disk_info(struct mddev *mddev, void __user *arg)
 {
 	mdu_disk_info_t info;
 	struct md_rdev *rdev;
@@ -8160,7 +8160,7 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 		return NULL;
 	if (!l--)
 		/* header */
-		return (void*)1;
+		return (void *)1;
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each(tmp, &all_mddevs)
@@ -8173,7 +8173,7 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 		}
 	spin_unlock(&all_mddevs_lock);
 	if (!l--)
-		return (void*)2;/* tail */
+		return (void *)2;/* tail */
 	return NULL;
 }
 
@@ -8184,11 +8184,11 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct mddev *to_put = NULL;
 
 	++*pos;
-	if (v == (void*)2)
+	if (v == (void *)2)
 		return NULL;
 
 	spin_lock(&all_mddevs_lock);
-	if (v == (void*)1) {
+	if (v == (void *)1) {
 		tmp = all_mddevs.next;
 	} else {
 		to_put = mddev;
@@ -8197,7 +8197,7 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 
 	for (;;) {
 		if (tmp == &all_mddevs) {
-			next_mddev = (void*)2;
+			next_mddev = (void *)2;
 			*pos = 0x10000;
 			break;
 		}
@@ -8219,7 +8219,7 @@ static void md_seq_stop(struct seq_file *seq, void *v)
 {
 	struct mddev *mddev = v;
 
-	if (mddev && v != (void*)1 && v != (void*)2)
+	if (mddev && v != (void *)1 && v != (void *)2)
 		mddev_put(mddev);
 }
 
@@ -8229,7 +8229,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	sector_t sectors;
 	struct md_rdev *rdev;
 
-	if (v == (void*)1) {
+	if (v == (void *)1) {
 		struct md_personality *pers;
 		seq_printf(seq, "Personalities : ");
 		spin_lock(&pers_lock);
@@ -8241,7 +8241,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		seq->poll_event = atomic_read(&md_event_count);
 		return 0;
 	}
-	if (v == (void*)2) {
+	if (v == (void *)2) {
 		status_unused(seq);
 		return 0;
 	}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 39df217b51be..10fc3da0dafd 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -652,7 +652,7 @@ static inline void sysfs_notify_dirent_safe(struct kernfs_node *sd)
 		sysfs_notify_dirent(sd);
 }
 
-static inline char * mdname(struct mddev * mddev)
+static inline char *mdname(struct mddev *mddev)
 {
 	return mddev->gendisk ? mddev->gendisk->disk_name : "mdX";
 }
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 884983c89491..0701f11a0da8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -127,7 +127,7 @@ static inline struct r1bio *get_resync_r1bio(struct bio *bio)
 	return get_resync_pages(bio)->raid_bio;
 }
 
-static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
 	int size = offsetof(struct r1bio, bios[pi->raid_disks]);
@@ -143,7 +143,7 @@ static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 #define CLUSTER_RESYNC_WINDOW (16 * RESYNC_WINDOW)
 #define CLUSTER_RESYNC_WINDOW_SECTORS (CLUSTER_RESYNC_WINDOW >> 9)
 
-static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
 	struct r1bio *r1_bio;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3a5946fa2b90..f95806a5606e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -103,7 +103,7 @@ static inline struct r10bio *get_resync_r10bio(struct bio *bio)
 	return get_resync_pages(bio)->raid_bio;
 }
 
-static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct r10conf *conf = data;
 	int size = offsetof(struct r10bio, devs[conf->geo.raid_disks]);
@@ -128,7 +128,7 @@ static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
  * one for write (we recover only one drive per r10buf)
  *
  */
-static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct r10conf *conf = data;
 	struct r10bio *r10_bio;
@@ -909,7 +909,7 @@ static void flush_pending_writes(struct r10conf *conf)
 
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
-			struct md_rdev *rdev = (void*)bio->bi_bdev;
+			struct md_rdev *rdev = (void *)bio->bi_bdev;
 			bio->bi_next = NULL;
 			bio_set_dev(bio, rdev->bdev);
 			if (test_bit(Faulty, &rdev->flags)) {
@@ -1124,7 +1124,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
-		struct md_rdev *rdev = (void*)bio->bi_bdev;
+		struct md_rdev *rdev = (void *)bio->bi_bdev;
 		bio->bi_next = NULL;
 		bio_set_dev(bio, rdev->bdev);
 		if (test_bit(Faulty, &rdev->flags)) {
@@ -3485,7 +3485,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			raise_barrier(conf, rb2 != NULL);
 			atomic_set(&r10_bio->remaining, 0);
 
-			r10_bio->master_bio = (struct bio*)rb2;
+			r10_bio->master_bio = (struct bio *)rb2;
 			if (rb2)
 				atomic_inc(&rb2->remaining);
 			r10_bio->mddev = mddev;
@@ -3662,7 +3662,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (biolist == NULL) {
 			while (r10_bio) {
 				struct r10bio *rb2 = r10_bio;
-				r10_bio = (struct r10bio*) rb2->master_bio;
+				r10_bio = (struct r10bio *) rb2->master_bio;
 				rb2->master_bio = NULL;
 				put_buf(rb2);
 			}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a4351ff3fe31..e4dd6304c018 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2746,7 +2746,7 @@ static struct md_rdev *rdev_mdlock_deref(struct mddev *mddev,
 			lockdep_is_held(&mddev->reconfig_mutex));
 }
 
-static void raid5_end_read_request(struct bio * bi)
+static void raid5_end_read_request(struct bio *bi)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
@@ -5478,7 +5478,7 @@ static void raid5_align_endio(struct bio *bi)
 
 	bio_put(bi);
 
-	rdev = (void*)raid_bi->bi_next;
+	rdev = (void *)raid_bi->bi_next;
 	raid_bi->bi_next = NULL;
 	mddev = rdev->mddev;
 	conf = mddev->private;
@@ -6079,7 +6079,7 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	return ret;
 }
 
-static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
+static bool raid5_make_request(struct mddev *mddev, struct bio *bi)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct r5conf *conf = mddev->private;
diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
index 51b811b62322..1827a54790d7 100644
--- a/include/linux/raid/xor.h
+++ b/include/linux/raid/xor.h
@@ -11,20 +11,20 @@ struct xor_block_template {
         struct xor_block_template *next;
         const char *name;
         int speed;
-	void (*do_2)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict);
-	void (*do_3)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict);
-	void (*do_4)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict);
-	void (*do_5)(unsigned long, unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict,
-		     const unsigned long * __restrict);
+	void (*do_2)(unsigned long, unsigned long *__restrict,
+		     const unsigned long *__restrict);
+	void (*do_3)(unsigned long, unsigned long *__restrict,
+		     const unsigned long *__restrict,
+		     const unsigned long *__restrict);
+	void (*do_4)(unsigned long, unsigned long *__restrict,
+		     const unsigned long *__restrict,
+		     const unsigned long *__restrict,
+		     const unsigned long *__restrict);
+	void (*do_5)(unsigned long, unsigned long *__restrict,
+		     const unsigned long *__restrict,
+		     const unsigned long *__restrict,
+		     const unsigned long *__restrict,
+		     const unsigned long *__restrict);
 };
 
 #endif
-- 
2.39.2

