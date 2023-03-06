Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46B1C6FD1A
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCFV3l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCFV3D (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D819533442
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvlV3u9e+84bcIALlUvqhTxG2vkAfj294kNciVI1n4c=;
        b=YfmaG3eSbbfh3xXhb+58m2HjaDuQEMZi+kiml42kpIpZcBZ1McAubhw9joZS2Q7ixjAJs8
        fg6h29GjXuZh83L/T2Wq/+elh6l5JV5z7vVinihU9Lb9GsMYyOL0HjF8QHYyvv012OTuDm
        Pb6Qjfe+1uIxnYFoqimKUfyrhTDYVMg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-DtNvPqmjNiuJRoe-LaMJ9g-1; Mon, 06 Mar 2023 16:28:10 -0500
X-MC-Unique: DtNvPqmjNiuJRoe-LaMJ9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 480AF1C06EC0
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:10 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 833F14097544;
        Mon,  6 Mar 2023 21:28:09 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 11/34] md: do not use assignment in if condition [ERROR]
Date:   Mon,  6 Mar 2023 22:27:34 +0100
Message-Id: <4d3d95b9b6f8ee374571621d72a033c2ac8ca0d3.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md-faulty.c    | 17 +++++++++++------
 drivers/md/md-multipath.c |  9 ++++++---
 drivers/md/md.c           | 36 ++++++++++++++++++++++--------------
 drivers/md/raid10.c       | 10 ++++++----
 drivers/md/raid5.c        |  5 +++--
 5 files changed, 48 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index 33cb00115777..7ac286e28fcb 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -226,28 +226,33 @@ static void faulty_status(struct seq_file *seq, struct mddev *mddev)
 	struct faulty_conf *conf = mddev->private;
 	int n;
 
-	if ((n = atomic_read(&conf->counters[WriteTransient])))
+	n = atomic_read(&conf->counters[WriteTransient]);
+	if (n)
 		seq_printf(seq, " WriteTransient=%d(%d)",
 			   n, conf->period[WriteTransient]);
 
-	if ((n = atomic_read(&conf->counters[ReadTransient])))
+	n = atomic_read(&conf->counters[ReadTransient]);
+	if (n)
 		seq_printf(seq, " ReadTransient=%d(%d)",
 			   n, conf->period[ReadTransient]);
 
-	if ((n = atomic_read(&conf->counters[WritePersistent])))
+	n = atomic_read(&conf->counters[WritePersistent]);
+	if (n)
 		seq_printf(seq, " WritePersistent=%d(%d)",
 			   n, conf->period[WritePersistent]);
 
-	if ((n = atomic_read(&conf->counters[ReadPersistent])))
+	n = atomic_read(&conf->counters[ReadPersistent]);
+	if (n)
 		seq_printf(seq, " ReadPersistent=%d(%d)",
 			   n, conf->period[ReadPersistent]);
 
 
-	if ((n = atomic_read(&conf->counters[ReadFixable])))
+	n = atomic_read(&conf->counters[ReadFixable]);
+	if (n)
 		seq_printf(seq, " ReadFixable=%d(%d)",
 			   n, conf->period[ReadFixable]);
 
-	if ((n = atomic_read(&conf->counters[WriteAll])))
+	if (atomic_read(&conf->counters[WriteAll]))
 		seq_printf(seq, " WriteAll");
 
 	seq_printf(seq, " nfaults=%d", conf->nfaults);
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index c6c0a76c5210..dd180199479b 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -216,8 +216,9 @@ static int multipath_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 
 	print_multipath_conf(conf);
 
-	for (path = first; path <= last; path++)
-		if (!(p = conf->multipaths+path)->rdev) {
+	for (path = first; path <= last; path++) {
+		p = conf->multipaths+path;
+		if (!p->rdev) {
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 
@@ -233,6 +234,7 @@ static int multipath_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			err = 0;
 			break;
 		}
+	}
 
 	print_multipath_conf(conf);
 
@@ -302,7 +304,8 @@ static void multipathd(struct md_thread *thread)
 		bio = &mp_bh->bio;
 		bio->bi_iter.bi_sector = mp_bh->master_bio->bi_iter.bi_sector;
 
-		if ((mp_bh->path = multipath_map(conf)) < 0) {
+		mp_bh->path = multipath_map(conf);
+		if (mp_bh->path < 0) {
 			pr_err("multipath: %pg: unrecoverable IO read error for block %llu\n",
 			       bio->bi_bdev,
 			       (unsigned long long)bio->bi_iter.bi_sector);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 132979e597dd..a48fbc80fc64 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2436,7 +2436,8 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	if (mddev->raid_disks)
 		mddev_create_serial_pool(mddev, rdev, false);
 
-	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
+	err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b);
+	if (err)
 		goto fail;
 
 	/* failure here is OK */
@@ -3059,8 +3060,12 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			 * will land in the local bitmap, which will be synced
 			 * by this node eventually
 			 */
-			if (!mddev_is_clustered(rdev->mddev) ||
-			    (err = md_cluster_ops->gather_bitmaps(rdev)) == 0) {
+			if (mddev_is_clustered(rdev->mddev))
+				err = md_cluster_ops->gather_bitmaps(rdev);
+			else
+				err = 0;
+
+			if (!err) {
 				clear_bit(Faulty, &rdev->flags);
 				err = add_bound_rdev(rdev);
 			}
@@ -9401,17 +9406,20 @@ void md_check_recovery(struct mddev *mddev)
 				goto not_running;
 			set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-		} else if ((spares = remove_and_add_spares(mddev, NULL))) {
-			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
-			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-			clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
-			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-		} else if (mddev->recovery_cp < MaxSector) {
-			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
-			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-		} else if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
-			/* nothing to be done ... */
-			goto not_running;
+		} else {
+			spares = remove_and_add_spares(mddev, NULL);
+			if (spares) {
+				clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+				clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+				clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+				set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+			} else if (mddev->recovery_cp < MaxSector) {
+				set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+				clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+			} else if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+				/* nothing to be done ... */
+				goto not_running;
+		}
 
 		if (mddev->pers->sync_request) {
 			if (spares) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7a15f794b839..8f3339e73f55 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1982,10 +1982,12 @@ static int _enough(struct r10conf *conf, int previous, int ignore)
 		int this = first;
 		while (n--) {
 			struct md_rdev *rdev;
-			if (this != ignore &&
-			    (rdev = rcu_dereference(conf->mirrors[this].rdev)) &&
-			    test_bit(In_sync, &rdev->flags))
-				cnt++;
+			if (this != ignore) {
+				rdev = rcu_dereference(conf->mirrors[this].rdev);
+				if (rdev && test_bit(In_sync, &rdev->flags))
+					cnt++;
+			}
+
 			this = (this+1) % disks;
 		}
 		if (cnt == 0)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d0b6a97200fa..4bdfbe1f8fcf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -549,9 +549,10 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 	for (i = 0; i < num; i++) {
 		struct page *page;
 
-		if (!(page = alloc_page(gfp))) {
+		page = alloc_page(gfp);
+		if (!page)
 			return 1;
-		}
+
 		sh->dev[i].page = page;
 		sh->dev[i].orig_page = page;
 		sh->dev[i].offset = 0;
-- 
2.39.2

