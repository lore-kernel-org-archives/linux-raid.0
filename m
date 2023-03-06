Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CC1C6FD1C
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjCFV3n (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCFV3I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F379931E3E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tkf/Uh8kRNULlUthMljCS+VSjoh0FSo2IdjXFx3wd20=;
        b=jCC0SZNFWiq98lh2J6kw4o6ZcnNMTO7bZ+bW/58AHNN5t8bNodlh/WCxn2hR9wSZ7TtTXP
        kOqYbJsBD9z8Fk+72v0Z15VnQvHyoOiRY6YNnX3S8VPdPNSa71Obgx9Fwc9K0LDTweAZjg
        1SCwfc3QAXoemcoIzqoGUg1enGtL1Sc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-giPAycpcPSGTbRlHBEbqog-1; Mon, 06 Mar 2023 16:28:13 -0500
X-MC-Unique: giPAycpcPSGTbRlHBEbqog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 850E83801F5B
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:13 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFA0C4010E7B;
        Mon,  6 Mar 2023 21:28:12 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 14/34] md: prefer seq_put[cs]() to seq_printf() |WARNING]
Date:   Mon,  6 Mar 2023 22:27:37 +0100
Message-Id: <ef50d556f676c2b05b0ee5d6bba58fe1fd2b45c8.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md-bitmap.c |  4 ++--
 drivers/md/md-faulty.c |  2 +-
 drivers/md/md.c        | 52 +++++++++++++++++++++---------------------
 drivers/md/raid1.c     |  2 +-
 drivers/md/raid10.c    |  2 +-
 drivers/md/raid5.c     |  2 +-
 6 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 3cee70340024..2db748c998e1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2055,11 +2055,11 @@ void md_bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 		   chunk_kb ? chunk_kb : bitmap->mddev->bitmap_info.chunksize,
 		   chunk_kb ? "KB" : "B");
 	if (bitmap->storage.file) {
-		seq_printf(seq, ", file: ");
+		seq_puts(seq, ", file: ");
 		seq_file_path(seq, bitmap->storage.file, " \t\n");
 	}
 
-	seq_printf(seq, "\n");
+	seq_putc(seq, '\n');
 }
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index d6dbca5edab8..5d2de3f32ae7 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -255,7 +255,7 @@ static void faulty_status(struct seq_file *seq, struct mddev *mddev)
 			   n, conf->period[ReadFixable]);
 
 	if (atomic_read(&conf->counters[WriteAll]))
-		seq_printf(seq, " WriteAll");
+		seq_puts(seq, " WriteAll");
 
 	seq_printf(seq, " nfaults=%d", conf->nfaults);
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e50a1bcf0a1c..2e764ddc55d6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8036,16 +8036,16 @@ static void status_unused(struct seq_file *seq)
 	int i = 0;
 	struct md_rdev *rdev;
 
-	seq_printf(seq, "unused devices: ");
+	seq_puts(seq, "unused devices: ");
 
 	list_for_each_entry(rdev, &pending_raid_disks, same_set) {
 		i++;
 		seq_printf(seq, "%pg ", rdev->bdev);
 	}
 	if (!i)
-		seq_printf(seq, "<none>");
+		seq_puts(seq, "<none>");
 
-	seq_printf(seq, "\n");
+	seq_putc(seq, '\n');
 }
 
 static int status_resync(struct seq_file *seq, struct mddev *mddev)
@@ -8091,23 +8091,23 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 				    !test_bit(Faulty, &rdev->flags) &&
 				    rdev->recovery_offset != MaxSector &&
 				    rdev->recovery_offset) {
-					seq_printf(seq, "\trecover=REMOTE");
+					seq_puts(seq, "\trecover=REMOTE");
 					return 1;
 				}
 			if (mddev->reshape_position != MaxSector)
-				seq_printf(seq, "\treshape=REMOTE");
+				seq_puts(seq, "\treshape=REMOTE");
 			else
-				seq_printf(seq, "\tresync=REMOTE");
+				seq_puts(seq, "\tresync=REMOTE");
 			return 1;
 		}
 		if (mddev->recovery_cp < MaxSector) {
-			seq_printf(seq, "\tresync=PENDING");
+			seq_puts(seq, "\tresync=PENDING");
 			return 1;
 		}
 		return 0;
 	}
 	if (resync < MD_RESYNC_ACTIVE) {
-		seq_printf(seq, "\tresync=DELAYED");
+		seq_puts(seq, "\tresync=DELAYED");
 		return 1;
 	}
 
@@ -8129,13 +8129,13 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	{
 		int i, x = per_milli/50, y = 20-x;
 
-		seq_printf(seq, "[");
+		seq_putc(seq, '[');
 		for (i = 0; i < x; i++)
-			seq_printf(seq, "=");
-		seq_printf(seq, ">");
+			seq_putc(seq, '=');
+		seq_putc(seq, '>');
 		for (i = 0; i < y; i++)
-			seq_printf(seq, ".");
-		seq_printf(seq, "] ");
+			seq_putc(seq, '.');
+		seq_puts(seq, "] ");
 	}
 	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)",
 		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
@@ -8280,7 +8280,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, "[%s] ", pers->name);
 
 		spin_unlock(&pers_lock);
-		seq_printf(seq, "\n");
+		seq_putc(seq, '\n');
 		seq->poll_event = atomic_read(&md_event_count);
 		return 0;
 	}
@@ -8295,9 +8295,9 @@ static int md_seq_show(struct seq_file *seq, void *v)
 						mddev->pers ? "" : "in");
 		if (mddev->pers) {
 			if (mddev->ro == MD_RDONLY)
-				seq_printf(seq, " (read-only)");
+				seq_puts(seq, " (read-only)");
 			if (mddev->ro == MD_AUTO_READ)
-				seq_printf(seq, " (auto-read-only)");
+				seq_puts(seq, " (auto-read-only)");
 			seq_printf(seq, " %s", mddev->pers->name);
 		}
 
@@ -8307,17 +8307,17 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, " %pg[%d]", rdev->bdev, rdev->desc_nr);
 
 			if (test_bit(WriteMostly, &rdev->flags))
-				seq_printf(seq, "(W)");
+				seq_puts(seq, "(W)");
 			if (test_bit(Journal, &rdev->flags))
-				seq_printf(seq, "(J)");
+				seq_puts(seq, "(J)");
 			if (test_bit(Faulty, &rdev->flags)) {
-				seq_printf(seq, "(F)");
+				seq_puts(seq, "(F)");
 				continue;
 			}
 			if (rdev->raid_disk < 0)
-				seq_printf(seq, "(S)"); /* spare */
+				seq_puts(seq, "(S)"); /* spare */
 			if (test_bit(Replacement, &rdev->flags))
-				seq_printf(seq, "(R)");
+				seq_puts(seq, "(R)");
 			sectors += rdev->sectors;
 		}
 		rcu_read_unlock();
@@ -8342,21 +8342,21 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, " super external:%s",
 				   mddev->metadata_type);
 		else
-			seq_printf(seq, " super non-persistent");
+			seq_puts(seq, " super non-persistent");
 
 		if (mddev->pers) {
 			mddev->pers->status(seq, mddev);
-			seq_printf(seq, "\n      ");
+			seq_puts(seq, "\n      ");
 			if (mddev->pers->sync_request) {
 				if (status_resync(seq, mddev))
-					seq_printf(seq, "\n      ");
+					seq_puts(seq, "\n      ");
 			}
 		} else
-			seq_printf(seq, "\n       ");
+			seq_puts(seq, "\n       ");
 
 		md_bitmap_status(seq, mddev->bitmap);
 
-		seq_printf(seq, "\n");
+		seq_putc(seq, '\n');
 	}
 	spin_unlock(&mddev->lock);
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index be86333104fe..42671d0147ea 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1646,7 +1646,7 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
 			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
-	seq_printf(seq, "]");
+	seq_puts(seq, "]");
 }
 
 /**
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c8f909e8a25e..61eb64ecd373 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1963,7 +1963,7 @@ static void raid10_status(struct seq_file *seq, struct mddev *mddev)
 		seq_printf(seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
-	seq_printf(seq, "]");
+	seq_puts(seq, "]");
 }
 
 /* check if there are enough drives for
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f5167eb71b5f..55afe09202c0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8159,7 +8159,7 @@ static void raid5_status(struct seq_file *seq, struct mddev *mddev)
 		seq_printf(seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
-	seq_printf(seq, "]");
+	seq_putc(seq, ']');
 }
 
 static void print_raid5_conf(struct r5conf *conf)
-- 
2.39.2

