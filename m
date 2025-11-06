Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0094032721F;
	Thu,  6 Nov 2025 12:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430887; cv=none; b=AkU1hn60M+aCD+hetk8H15zBgjbF9J/5GxkUj+C3ufwvu8aq/tmunRYrwsawLHReG33ADgXcNgPHg4+5FAE+HGMquvw+itBFcvN794brwhrD37icuqTeMqi9XpngmplNglBszuMoCf7vhjh05Nm4oiStsqqHcQ9cpLHvidQupUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430887; c=relaxed/simple;
	bh=93E7Ch3vmR+BkGvbvEtHMgRB1LugShrXPUh+nho14NE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KxJRlIn75wK2VXEdsWGePgBTrf6NEeu53mw5TfsoK0/QO9Orp6bqq1RYF782TrD+6up7IscV8qMpS2YcdCGELyXnxbOvLOQtqqLKpJV47mVW1guSA2wZBpwQVdBHF7j8PWEqvkh2sC2jMs7XC/+jd4aYrJ7Er8SrXBLs81L6tkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d2LYC2mGmzYQtvJ;
	Thu,  6 Nov 2025 20:07:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id AED6C1A1CEC;
	Thu,  6 Nov 2025 20:08:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UWfjwxpEbabCw--.33933S6;
	Thu, 06 Nov 2025 20:08:01 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 02/11] md: factor error handling out of md_done_sync into helper
Date: Thu,  6 Nov 2025 19:59:26 +0800
Message-Id: <20251106115935.2148714-3-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251106115935.2148714-1-linan666@huaweicloud.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH3UWfjwxpEbabCw--.33933S6
X-Coremail-Antispam: 1UD129KBjvJXoW3Wr4UKF15CFWUJw1DGrWUCFg_yoW3Zr4Upa
	yDJFyrA3yjqFWava4DJFWDua4Fy34xtFZrtFW7uwn7X3Z8tryDGF1UX3WYqFyDAa4rurW3
	Xa1DWFW5CFyfJF7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUHnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

The 'ok' parameter in md_done_sync() is redundant for most callers that
always pass 'true'. Factor error handling logic into a separate helper
function md_sync_error() to eliminate unnecessary parameter passing and
improve code clarity.

No functional changes introduced.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h     |  3 ++-
 drivers/md/md.c     | 17 ++++++++++-------
 drivers/md/raid1.c  | 14 +++++++-------
 drivers/md/raid10.c | 11 ++++++-----
 drivers/md/raid5.c  | 14 ++++++++------
 5 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5d5f780b8447..18621dba09a9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -910,7 +910,8 @@ extern const char *md_sync_action_name(enum sync_action action);
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
index 6062e0deb616..1361f211a844 100644
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
index fbd39c44dc04..e65d104cb9c5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2062,7 +2062,7 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 	} while (sectors_to_go > 0);
 }
 
-static void put_sync_write_buf(struct r1bio *r1_bio, int uptodate)
+static void put_sync_write_buf(struct r1bio *r1_bio)
 {
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
 		struct mddev *mddev = r1_bio->mddev;
@@ -2073,7 +2073,7 @@ static void put_sync_write_buf(struct r1bio *r1_bio, int uptodate)
 			reschedule_retry(r1_bio);
 		else {
 			put_buf(r1_bio);
-			md_done_sync(mddev, s, uptodate);
+			md_done_sync(mddev, s);
 		}
 	}
 }
@@ -2098,7 +2098,7 @@ static void end_sync_write(struct bio *bio)
 		set_bit(R1BIO_MadeGood, &r1_bio->state);
 	}
 
-	put_sync_write_buf(r1_bio, 1);
+	put_sync_write_buf(r1_bio);
 }
 
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
@@ -2348,8 +2348,8 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
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
@@ -2384,7 +2384,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 		submit_bio_noacct(wbio);
 	}
 
-	put_sync_write_buf(r1_bio, 1);
+	put_sync_write_buf(r1_bio);
 }
 
 /*
@@ -2575,7 +2575,7 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 		}
 	}
 	put_buf(r1_bio);
-	md_done_sync(conf->mddev, s, 1);
+	md_done_sync(conf->mddev, s);
 }
 
 static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 14dcd5142eb4..231177cee928 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2276,7 +2276,7 @@ static void end_sync_request(struct r10bio *r10_bio)
 				reschedule_retry(r10_bio);
 			else
 				put_buf(r10_bio);
-			md_done_sync(mddev, s, 1);
+			md_done_sync(mddev, s);
 			break;
 		} else {
 			struct r10bio *r10_bio2 = (struct r10bio *)r10_bio->master_bio;
@@ -2452,7 +2452,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 done:
 	if (atomic_dec_and_test(&r10_bio->remaining)) {
-		md_done_sync(mddev, r10_bio->sectors, 1);
+		md_done_sync(mddev, r10_bio->sectors);
 		put_buf(r10_bio);
 	}
 }
@@ -3757,7 +3757,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		/* pretend they weren't skipped, it makes
 		 * no important difference in this case
 		 */
-		md_done_sync(mddev, sectors_skipped, 1);
+		md_done_sync(mddev, sectors_skipped);
 
 	return sectors_skipped + nr_sectors;
  giveup:
@@ -4912,7 +4912,8 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
 		if (handle_reshape_read_error(mddev, r10_bio) < 0) {
 			/* Reshape has been aborted */
-			md_done_sync(mddev, r10_bio->sectors, 0);
+			md_done_sync(mddev, r10_bio->sectors);
+			md_sync_error(mddev);
 			return;
 		}
 
@@ -5070,7 +5071,7 @@ static void end_reshape_request(struct r10bio *r10_bio)
 {
 	if (!atomic_dec_and_test(&r10_bio->remaining))
 		return;
-	md_done_sync(r10_bio->mddev, r10_bio->sectors, 1);
+	md_done_sync(r10_bio->mddev, r10_bio->sectors);
 	bio_put(r10_bio->master_bio);
 	put_buf(r10_bio);
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 24b32a0c95b4..18415745e850 100644
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

