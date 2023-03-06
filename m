Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF04FC64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCFV3D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCFV2z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:28:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CA21F4BA
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eEfpw9QamGHyb/jcUBaxmQ/IrLQ7kWg6t/wGAmfwvDY=;
        b=SNoikir97Kk9mGu+4beSsakOxtiKr4T5wojkfesiBpLtG5nje0hzxaBur+L8LTuQWe+87X
        KjUcSsvxSsy6Ghp4V43UHDw9zh7cF0rhNujqEeJCQPScubncC4bWltrPDpPuxK2Hla8tNJ
        qP7q4sSStsfqQtvRRdkZ/T9dGEDvPx4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-6ysETEcZNG23xBVqoTgl0A-1; Mon, 06 Mar 2023 16:28:05 -0500
X-MC-Unique: 6ysETEcZNG23xBVqoTgl0A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC964101AA78
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:04 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1531540C83B6;
        Mon,  6 Mar 2023 21:28:03 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 06/34] md: move trailing statements to next line [ERROR]
Date:   Mon,  6 Mar 2023 22:27:29 +0100
Message-Id: <12a6970ce1bf7489aa67a3c6d70438a48b8f8987.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Also, add curly braces where appropriate.

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-autodetect.c |  3 +-
 drivers/md/md-faulty.c     | 10 +++++--
 drivers/md/md.c            | 20 ++++++++-----
 drivers/md/md.h            |  3 +-
 drivers/md/raid10.c        | 11 ++++----
 drivers/md/raid5.c         | 57 +++++++++++++++++++++-----------------
 6 files changed, 61 insertions(+), 43 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 46090cdd02ba..e8acb3021094 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -237,7 +237,8 @@ static int __init raid_setup(char *str)
 		int wlen;
 		if (comma)
 			wlen = (comma-str)-pos;
-		else	wlen = (len-1)-pos;
+		else
+			wlen = (len-1)-pos;
 
 		if (!strncmp(str, "noautodetect", wlen))
 			raid_noautodetect = 1;
diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index 8493432a732e..33cb00115777 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -125,10 +125,12 @@ static void add_sector(struct faulty_conf *conf, sector_t start, int mode)
 {
 	int i;
 	int n = conf->nfaults;
-	for (i = 0; i < conf->nfaults; i++)
+	for (i = 0; i < conf->nfaults; i++) {
 		if (conf->faults[i] == start) {
 			switch (mode) {
-			case NoPersist: conf->modes[i] = mode; return;
+			case NoPersist:
+				conf->modes[i] = mode;
+				return;
 			case WritePersistent:
 				if (conf->modes[i] == ReadPersistent ||
 				    conf->modes[i] == ReadFixable)
@@ -152,6 +154,7 @@ static void add_sector(struct faulty_conf *conf, sector_t start, int mode)
 			}
 		} else if (conf->modes[i] == NoPersist)
 			n = i;
+	}
 
 	if (n >= MaxFault)
 		return;
@@ -271,7 +274,8 @@ static int faulty_reshape(struct mddev *mddev)
 		}
 	} else if (mode < Modes) {
 		conf->period[mode] = count;
-		if (!count) count++;
+		if (!count)
+			count++;
 		atomic_set(&conf->counters[mode], count);
 	} else
 		return -EINVAL;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f8d44832339e..24e55e2cf4db 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1634,7 +1634,8 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	 * and it is safe to read 4k, so we do that
 	 */
 	ret = read_disk_sb(rdev, 4096);
-	if (ret) return ret;
+	if (ret)
+		return ret;
 
 	sb = page_address(rdev->sb_page);
 
@@ -4599,13 +4600,16 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 	/* buf should be <chunk> <chunk> ... or <chunk>-<chunk> ... (range) */
 	while (*buf) {
 		chunk = end_chunk = simple_strtoul(buf, &end, 0);
-		if (buf == end) break;
+		if (buf == end)
+			break;
 		if (*end == '-') { /* range */
 			buf = end + 1;
 			end_chunk = simple_strtoul(buf, &end, 0);
-			if (buf == end) break;
+			if (buf == end)
+				break;
 		}
-		if (*end && !isspace(*end)) break;
+		if (*end && !isspace(*end)) 
+			break;
 		md_bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
 		buf = skip_spaces(end);
 	}
@@ -4975,7 +4979,8 @@ sync_speed_show(struct mddev *mddev, char *page)
 		return sprintf(page, "none\n");
 	resync = mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active);
 	dt = (jiffies - mddev->resync_mark) / HZ;
-	if (!dt) dt++;
+	if (!dt)
+		dt++;
 	db = resync - mddev->resync_mark_cnt;
 	return sprintf(page, "%lu\n", db/dt/2); /* K/sec */
 }
@@ -7525,7 +7530,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	case RAID_VERSION:
 		err = get_version(argp);
 		goto out;
-	default:;
+	default:
 	}
 
 	/*
@@ -8117,7 +8122,8 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	 *   The '+1' avoids division by zero if db is very small.
 	 */
 	dt = ((jiffies - mddev->resync_mark) / HZ);
-	if (!dt) dt++;
+	if (!dt)
+		dt++;
 
 	curr_mark_cnt = mddev->curr_mark_cnt;
 	recovery_active = atomic_read(&mddev->recovery_active);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 9408cfbd92db..a885bbcebe2d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -720,7 +720,8 @@ struct md_io_acct {
 
 static inline void safe_put_page(struct page *p)
 {
-	if (p) put_page(p);
+	if (p)
+		put_page(p);
 }
 
 extern int register_md_personality(struct md_personality *p);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a26a3764b234..7a15f794b839 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3335,11 +3335,12 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 				md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
 						   &sync_blocks, 1);
-			else for (i = 0; i < conf->geo.raid_disks; i++) {
-				sector_t sect =
-					raid10_find_virt(conf, mddev->curr_resync, i);
-				md_bitmap_end_sync(mddev->bitmap, sect,
-						   &sync_blocks, 1);
+			else {
+				for (i = 0; i < conf->geo.raid_disks; i++) {
+					sector_t sect =
+					   raid10_find_virt(conf, mddev->curr_resync, i);
+					md_bitmap_end_sync(mddev->bitmap, sect, &sync_blocks, 1);
+				}
 			}
 		} else {
 			/* completed sync */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1d5db89acb8d..00151c850a35 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3215,7 +3215,8 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
 	if (i == sh->pd_idx)
 		return 0;
 	switch (conf->level) {
-	case 4: break;
+	case 4:
+		break;
 	case 5:
 		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
@@ -3712,7 +3713,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			sh->dev[i].page = sh->dev[i].orig_page;
 		}
 
-		if (bi) bitmap_end = 1;
+		if (bi)
+			bitmap_end = 1;
 		while (bi && bi->bi_iter.bi_sector <
 		       sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
 			struct bio *bi2 = r5_next_bio(conf, bi, sh->dev[i].sector);
@@ -4202,30 +4204,33 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 		pr_debug("force RCW rmw_level=%u, recovery_cp=%llu sh->sector=%llu\n",
 			 conf->rmw_level, (unsigned long long)recovery_cp,
 			 (unsigned long long)sh->sector);
-	} else for (i = disks; i--; ) {
-		/* would I have to read this buffer for read_modify_write */
-		struct r5dev *dev = &sh->dev[i];
-		if (((dev->towrite && !delay_towrite(conf, dev, s)) ||
-		     i == sh->pd_idx || i == sh->qd_idx ||
-		     test_bit(R5_InJournal, &dev->flags)) &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(uptodate_for_rmw(dev) ||
-		      test_bit(R5_Wantcompute, &dev->flags))) {
-			if (test_bit(R5_Insync, &dev->flags))
-				rmw++;
-			else
-				rmw += 2*disks;  /* cannot read it */
-		}
-		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags) &&
-		    i != sh->pd_idx && i != sh->qd_idx &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		      test_bit(R5_Wantcompute, &dev->flags))) {
-			if (test_bit(R5_Insync, &dev->flags))
-				rcw++;
-			else
-				rcw += 2*disks;
+	} else {
+		for (i = disks; i--; ) {
+			/* would I have to read this buffer for read_modify_write */
+			struct r5dev *dev = &sh->dev[i];
+			if (((dev->towrite && !delay_towrite(conf, dev, s)) ||
+			     i == sh->pd_idx || i == sh->qd_idx ||
+			     test_bit(R5_InJournal, &dev->flags)) &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !(uptodate_for_rmw(dev) ||
+			      test_bit(R5_Wantcompute, &dev->flags))) {
+				if (test_bit(R5_Insync, &dev->flags))
+					rmw++;
+				else
+					rmw += 2*disks;  /* cannot read it */
+			}
+
+			/* Would I have to read this buffer for reconstruct_write */
+			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
+			    i != sh->pd_idx && i != sh->qd_idx &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			      test_bit(R5_Wantcompute, &dev->flags))) {
+				if (test_bit(R5_Insync, &dev->flags))
+					rcw++;
+				else
+					rcw += 2*disks;
+			}
 		}
 	}
 
-- 
2.39.2

