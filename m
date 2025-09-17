Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E8130C34D;
	Wed, 17 Sep 2025 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758102305; cv=none; b=HJL1WpkFAIs8PwTl6gxNw1cKvdJ5gasM/b/rVAT6clCJ14FVk0eNO39LUluEekF23oyKlstN7aH/hCc7o/yGex+clNQZ6SFkcqy/d6s0wxg9WBhxGk0dYBiba9osYjz73gcoQ9cPR8aH/wtUagFM215ibnFSXMmb1DKKQmCNAYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758102305; c=relaxed/simple;
	bh=SNwi316Y6Ce/84JIqrdSQClbIb+7vKr7takgs/WWXbs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j5HC0wlYNGferY8/tHAvSCNrqHovQlN/4r2lLNixODRAsPjmlrHOBWaKFSiYcnfFV+Q/bnHPlFp4B1pDKpHp9fQ6C6OiZzywdXfu+m6E4ktf1b275b9949vKznq5rz1MJ07ylhs6qkM+fji0ei0luaA6MR+wKBjrW85yKZF3L18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cRYld4BqgzYQvJh;
	Wed, 17 Sep 2025 17:45:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 335041A223E;
	Wed, 17 Sep 2025 17:45:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0Zg8poSuc1Cw--.51298S5;
	Wed, 17 Sep 2025 17:45:00 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH 1/7] md: factor error handling out of md_done_sync into helper
Date: Wed, 17 Sep 2025 17:35:02 +0800
Message-Id: <20250917093508.456790-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250917093508.456790-1-linan666@huaweicloud.com>
References: <20250917093508.456790-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0Zg8poSuc1Cw--.51298S5
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr4UtF4rZw1kJryUJF4xJFb_yoW3KFWDp3
	yDJFyrAr4UJFWaqFyDJFWDua4Fy34xtFZrtFW7uwn7X3Z8tryDGF1UXa45XFyDJa4rurW3
	X3WDWFW5CF1fJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUml14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	AKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E
	4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
	WUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
	Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjfUe0PSUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

The 'ok' parameter in md_done_sync() is redundant for most callers that
always pass 'true'. Factor error handling logic into a separate helper
function md_sync_error() to eliminate unnecessary parameter passing and
improve code clarity.

No functional changes introduced.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h     |  3 ++-
 drivers/md/md.c     | 17 ++++++++++-------
 drivers/md/raid1.c  | 17 ++++++++---------
 drivers/md/raid10.c | 11 ++++++-----
 drivers/md/raid5.c  | 14 ++++++++------
 5 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1979c2d4fe89..ba567b63afd3 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -904,7 +904,8 @@ extern const char *md_sync_action_name(enum sync_action action);
 extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
-extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
+extern void md_done_sync(struct mddev *mddev, int blocks);
+extern void md_sync_error(struct mddev *mddev);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1de550108756..1795f725f7fb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8937,20 +8937,23 @@ static bool is_mddev_idle(struct mddev *mddev, int init)
 	return idle;
 }
 
-void md_done_sync(struct mddev *mddev, int blocks, int ok)
+void md_done_sync(struct mddev *mddev, int blocks)
 {
 	/* another "blocks" (512byte) blocks have been synced */
 	atomic_sub(blocks, &mddev->recovery_active);
 	wake_up(&mddev->recovery_wait);
-	if (!ok) {
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
-		md_wakeup_thread(mddev->thread);
-		// stop recovery, signal do_sync ....
-	}
 }
 EXPORT_SYMBOL(md_done_sync);
 
+void md_sync_error(struct mddev *mddev)
+{
+	// stop recovery, signal do_sync ....
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+	set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
+}
+EXPORT_SYMBOL(md_sync_error);
+
 /* md_write_start(mddev, bi)
  * If we need to update some array metadata (e.g. 'active' flag
  * in superblock) before writing, schedule a superblock update
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0e792b9bfff8..397b3a2eaee4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2074,7 +2074,7 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 	} while (sectors_to_go > 0);
 }
 
-static void put_sync_write_buf(struct r1bio *r1_bio, int uptodate)
+static void put_sync_write_buf(struct r1bio *r1_bio)
 {
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
 		struct mddev *mddev = r1_bio->mddev;
@@ -2085,20 +2085,19 @@ static void put_sync_write_buf(struct r1bio *r1_bio, int uptodate)
 			reschedule_retry(r1_bio);
 		else {
 			put_buf(r1_bio);
-			md_done_sync(mddev, s, uptodate);
+			md_done_sync(mddev, s);
 		}
 	}
 }
 
 static void end_sync_write(struct bio *bio)
 {
-	int uptodate = !bio->bi_status;
 	struct r1bio *r1_bio = get_resync_r1bio(bio);
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
 	struct md_rdev *rdev = conf->mirrors[find_bio_disk(r1_bio, bio)].rdev;
 
-	if (!uptodate) {
+	if (bio->bi_status) {
 		abort_sync_write(mddev, r1_bio);
 		set_bit(WriteErrorSeen, &rdev->flags);
 		if (!test_and_set_bit(WantReplacement, &rdev->flags))
@@ -2111,7 +2110,7 @@ static void end_sync_write(struct bio *bio)
 		set_bit(R1BIO_MadeGood, &r1_bio->state);
 	}
 
-	put_sync_write_buf(r1_bio, uptodate);
+	put_sync_write_buf(r1_bio);
 }
 
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
@@ -2361,8 +2360,8 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
 		    !fix_sync_read_error(r1_bio)) {
 			conf->recovery_disabled = mddev->recovery_disabled;
-			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_done_sync(mddev, r1_bio->sectors, 0);
+			md_done_sync(mddev, r1_bio->sectors);
+			md_sync_error(mddev);
 			put_buf(r1_bio);
 			return;
 		}
@@ -2397,7 +2396,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 		submit_bio_noacct(wbio);
 	}
 
-	put_sync_write_buf(r1_bio, 1);
+	put_sync_write_buf(r1_bio);
 }
 
 /*
@@ -2588,7 +2587,7 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 		}
 	}
 	put_buf(r1_bio);
-	md_done_sync(conf->mddev, s, 1);
+	md_done_sync(conf->mddev, s);
 }
 
 static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2411399a7352..2899fd1ecc57 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2282,7 +2282,7 @@ static void end_sync_request(struct r10bio *r10_bio)
 				reschedule_retry(r10_bio);
 			else
 				put_buf(r10_bio);
-			md_done_sync(mddev, s, 1);
+			md_done_sync(mddev, s);
 			break;
 		} else {
 			struct r10bio *r10_bio2 = (struct r10bio *)r10_bio->master_bio;
@@ -2458,7 +2458,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 done:
 	if (atomic_dec_and_test(&r10_bio->remaining)) {
-		md_done_sync(mddev, r10_bio->sectors, 1);
+		md_done_sync(mddev, r10_bio->sectors);
 		put_buf(r10_bio);
 	}
 }
@@ -3763,7 +3763,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		/* pretend they weren't skipped, it makes
 		 * no important difference in this case
 		 */
-		md_done_sync(mddev, sectors_skipped, 1);
+		md_done_sync(mddev, sectors_skipped);
 
 	return sectors_skipped + nr_sectors;
  giveup:
@@ -4917,7 +4917,8 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
 		if (handle_reshape_read_error(mddev, r10_bio) < 0) {
 			/* Reshape has been aborted */
-			md_done_sync(mddev, r10_bio->sectors, 0);
+			md_done_sync(mddev, r10_bio->sectors);
+			md_sync_error(mddev);
 			return;
 		}
 
@@ -5075,7 +5076,7 @@ static void end_reshape_request(struct r10bio *r10_bio)
 {
 	if (!atomic_dec_and_test(&r10_bio->remaining))
 		return;
-	md_done_sync(r10_bio->mddev, r10_bio->sectors, 1);
+	md_done_sync(r10_bio->mddev, r10_bio->sectors);
 	bio_put(r10_bio->master_bio);
 	put_buf(r10_bio);
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5112658ef5f6..b09265fb872a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3723,11 +3723,13 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 						   RAID5_STRIPE_SECTORS(conf), 0))
 				abort = 1;
 		}
-		if (abort)
-			conf->recovery_disabled =
-				conf->mddev->recovery_disabled;
 	}
-	md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf), !abort);
+	md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf));
+
+	if (abort) {
+		conf->recovery_disabled = conf->mddev->recovery_disabled;
+		md_sync_error(conf->mddev);
+	}
 }
 
 static int want_replace(struct stripe_head *sh, int disk_idx)
@@ -5156,7 +5158,7 @@ static void handle_stripe(struct stripe_head *sh)
 	if ((s.syncing || s.replacing) && s.locked == 0 &&
 	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	    test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf), 1);
+		md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf));
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
 			wake_up_bit(&sh->dev[sh->pd_idx].flags, R5_Overlap);
@@ -5223,7 +5225,7 @@ static void handle_stripe(struct stripe_head *sh)
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_reshape);
-		md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf), 1);
+		md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf));
 	}
 
 	if (s.expanding && s.locked == 0 &&
-- 
2.39.2

