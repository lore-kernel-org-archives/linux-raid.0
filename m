Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9276321434;
	Thu, 28 Aug 2025 16:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756398821; cv=none; b=FvxFg5v9v4L3rmz242BBGQRPjOQKPJIsivb0TnLfanQmNFHVc7ldYedsHroEsp7lT/a7lN/Id+vpRJsQONDDXI/GOZ5hzcYJCDChD5687Gflf8Sw4SosK6UotywPo9HImUU/RD2fOd6eDXS4BF20nh7UKfBO9Jr/q5DbbdmEABA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756398821; c=relaxed/simple;
	bh=arLbQAKtlt2RHTVwY+TbgapfxKbOwTJaUXbo9RDM4nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EN1Bo7rO2ChEqn6GY0sqESxB9gPQd4dV3sCcd/H+yEAIL+m2Uf/I0WOiQHTlDtt9Hx5V+MGcbTJM5IWksdA2DxgMb+MGSEIxMBp5IYLhgk0ayaKI13t3Fss8nii/XrbBZ5BL0Op1R08IMP09Okq5/GzLuUJgDCmTTNYRSwuS0CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=YbbLTX34; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="YbbLTX34"
Received: from fedora (p4276017-ipxg00p01tokaisakaetozai.aichi.ocn.ne.jp [153.201.109.17])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57SGWlxN041448
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 01:32:52 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=sXHbsNRkr5lLfEcO8xjuUxdzkP1GPof7NWWbYg1rOVI=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1756398772; v=1;
        b=YbbLTX34unIzEXbdLcjjDXjgcZ2MiyK/22KyIlTIuJrAq/uosjs2sl/6LsC1xFfU
         aicmtyZ03i9CJsuDnaDClmtLHl9v79ucGJz0P7fW+ohbC4by+m2XC6MM2ziFy2t7
         NDn7A3jTJ5w2VebsySnIINUrnWFHyKUX7nydT3dP0xnNUc0mflHKfFsMtvuPpGAJ
         IgP5/gXQNIDvCo3/Beet3QV55s7Qzilj/ENVzTvF/9vynUVQiqVNW6r5oQAEQ0tx
         VHndTh7pN+zkS0SV4TUZryt23cTQQLkYTAHMJ6Pil8qzmtTDcQ9RrzqNDTR30+qg
         vuN7tPFi6aducZ/kkyOnPQ==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast io failure
Date: Fri, 29 Aug 2025 01:32:14 +0900
Message-ID: <20250828163216.4225-2-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250828163216.4225-1-k@mgml.me>
References: <20250828163216.4225-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit ensures that an MD_FAILFAST IO failure does not put
the array into a broken state.

When failfast is enabled on rdev in RAID1 or RAID10,
the array may be flagged MD_BROKEN in the following cases.
- If MD_FAILFAST IOs to multiple rdevs fail simultaneously
- If an MD_FAILFAST metadata write to the 'last' rdev fails

The MD_FAILFAST bio error handler always calls md_error on IO failure,
under the assumption that raid{1,10}_error will neither fail
the last rdev nor break the array.
After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
calling md_error on the 'last' rdev in RAID1/10 always sets
the MD_BROKEN flag on the array.
As a result, when failfast IO fails on the last rdev, the array
immediately becomes failed.

Normally, MD_FAILFAST IOs are not issued to the 'last' rdev, so this is
an edge case; however, it can occur if rdevs in a non-degraded
array share the same path and that path is lost, or if a metadata
write is triggered in a degraded array and fails due to failfast.

When a failfast metadata write fails, it is retried through the
following sequence. If a metadata write without failfast fails,
the array will be marked with MD_BROKEN.

1. MD_SB_NEED_REWRITE is set in sb_flags by super_written.
2. md_super_wait, called by the function executing md_super_write,
   returns -EAGAIN due to MD_SB_NEED_REWRITE.
3. The caller of md_super_wait (e.g., md_update_sb) receives the
   negative return value and retries md_super_write.
4. md_super_write issues the metadata write again,
   this time without MD_FAILFAST.

Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c     | 14 +++++++++-----
 drivers/md/md.h     | 13 +++++++------
 drivers/md/raid1.c  | 18 ++++++++++++++++--
 drivers/md/raid10.c | 21 ++++++++++++++++++---
 4 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..547b88e253f7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -999,14 +999,18 @@ static void super_written(struct bio *bio)
 	if (bio->bi_status) {
 		pr_err("md: %s gets error=%d\n", __func__,
 		       blk_status_to_errno(bio->bi_status));
+		if (bio->bi_opf & MD_FAILFAST)
+			set_bit(FailfastIOFailure, &rdev->flags);
 		md_error(mddev, rdev);
 		if (!test_bit(Faulty, &rdev->flags)
 		    && (bio->bi_opf & MD_FAILFAST)) {
+			pr_warn("md: %s: Metadata write will be repeated to %pg\n",
+				mdname(mddev), rdev->bdev);
 			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
-			set_bit(LastDev, &rdev->flags);
 		}
-	} else
-		clear_bit(LastDev, &rdev->flags);
+	} else {
+		clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
+	}
 
 	bio_put(bio);
 
@@ -1048,7 +1052,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 
 	if (test_bit(MD_FAILFAST_SUPPORTED, &mddev->flags) &&
 	    test_bit(FailFast, &rdev->flags) &&
-	    !test_bit(LastDev, &rdev->flags))
+	    !test_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
 		bio->bi_opf |= MD_FAILFAST;
 
 	atomic_inc(&mddev->pending_writes);
@@ -1059,7 +1063,7 @@ int md_super_wait(struct mddev *mddev)
 {
 	/* wait for all superblock writes that were scheduled to complete */
 	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
-	if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
+	if (test_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
 		return -EAGAIN;
 	return 0;
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51af29a03079..52c9fc759015 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -281,9 +281,10 @@ enum flag_bits {
 				 * It is expects that no bad block log
 				 * is present.
 				 */
-	LastDev,		/* Seems to be the last working dev as
-				 * it didn't fail, so don't use FailFast
-				 * any more for metadata
+	FailfastIOFailure,	/* rdev with failfast IO failure
+				 * but md_error not yet completed.
+				 * If the last rdev has this flag,
+				 * error_handler must not fail the array
 				 */
 	CollisionCheck,		/*
 				 * check if there is collision between raid1
@@ -331,8 +332,8 @@ struct md_cluster_operations;
  * @MD_CLUSTER_RESYNC_LOCKED: cluster raid only, which means node, already took
  *			       resync lock, need to release the lock.
  * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is supported as
- *			    calls to md_error() will never cause the array to
- *			    become failed.
+ *			    calls to md_error() with FailfastIOFailure will
+ *			    never cause the array to become failed.
  * @MD_HAS_PPL:  The raid array has PPL feature set.
  * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
  * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
@@ -360,7 +361,7 @@ enum mddev_sb_flags {
 	MD_SB_CHANGE_DEVS,		/* Some device status has changed */
 	MD_SB_CHANGE_CLEAN,	/* transition to or from 'clean' */
 	MD_SB_CHANGE_PENDING,	/* switch from 'clean' to 'active' in progress */
-	MD_SB_NEED_REWRITE,	/* metadata write needs to be repeated */
+	MD_SB_NEED_REWRITE,	/* metadata write needs to be repeated, do not use failfast */
 };
 
 #define NR_SERIAL_INFOS		8
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 408c26398321..8a61fd93b3ff 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
 		    (bio->bi_opf & MD_FAILFAST) &&
 		    /* We never try FailFast to WriteMostly devices */
 		    !test_bit(WriteMostly, &rdev->flags)) {
+			set_bit(FailfastIOFailure, &rdev->flags);
 			md_error(r1_bio->mddev, rdev);
 		}
 
@@ -1746,8 +1747,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
  *	- recovery is interrupted.
  *	- &mddev->degraded is bumped.
  *
- * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
+ * then @mddev and @rdev will not be marked as failed.
+ *
+ * @rdev is marked as &Faulty excluding any cases:
+ *	- when @mddev is failed and &mddev->fail_last_dev is off
+ *	- when @rdev is last device and &FailfastIOFailure flag is set
  */
 static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -1758,6 +1763,13 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (test_bit(In_sync, &rdev->flags) &&
 	    (conf->raid_disks - mddev->degraded) == 1) {
+		if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			pr_warn_ratelimited("md/raid1:%s: Failfast IO failure on %pg, "
+				"last device but ignoring it\n",
+				mdname(mddev), rdev->bdev);
+			return;
+		}
 		set_bit(MD_BROKEN, &mddev->flags);
 
 		if (!mddev->fail_last_dev) {
@@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	if (test_bit(FailFast, &rdev->flags)) {
 		/* Don't try recovering from here - just fail it
 		 * ... unless it is the last working device of course */
+		set_bit(FailfastIOFailure, &rdev->flags);
 		md_error(mddev, rdev);
 		if (test_bit(Faulty, &rdev->flags))
 			/* Don't try to read from here, but make sure
@@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 		fix_read_error(conf, r1_bio);
 		unfreeze_array(conf);
 	} else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
+		set_bit(FailfastIOFailure, &rdev->flags);
 		md_error(mddev, rdev);
 	} else {
 		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b60c30bfb6c7..530ad6503189 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -488,6 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
 			dec_rdev = 0;
 			if (test_bit(FailFast, &rdev->flags) &&
 			    (bio->bi_opf & MD_FAILFAST)) {
+				set_bit(FailfastIOFailure, &rdev->flags);
 				md_error(rdev->mddev, rdev);
 			}
 
@@ -1995,8 +1996,12 @@ static int enough(struct r10conf *conf, int ignore)
  *	- recovery is interrupted.
  *	- &mddev->degraded is bumped.
  *
- * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
+ * then @mddev and @rdev will not be marked as failed.
+ *
+ * @rdev is marked as &Faulty excluding any cases:
+ *	- when @mddev is failed and &mddev->fail_last_dev is off
+ *	- when @rdev is last device and &FailfastIOFailure flag is set
  */
 static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -2006,6 +2011,13 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	spin_lock_irqsave(&conf->device_lock, flags);
 
 	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
+		if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) {
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			pr_warn_ratelimited("md/raid10:%s: Failfast IO failure on %pg, "
+				"last device but ignoring it\n",
+				mdname(mddev), rdev->bdev);
+			return;
+		}
 		set_bit(MD_BROKEN, &mddev->flags);
 
 		if (!mddev->fail_last_dev) {
@@ -2413,6 +2425,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 				continue;
 		} else if (test_bit(FailFast, &rdev->flags)) {
 			/* Just give up on this device */
+			set_bit(FailfastIOFailure, &rdev->flags);
 			md_error(rdev->mddev, rdev);
 			continue;
 		}
@@ -2865,8 +2878,10 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
-	} else
+	} else {
+		set_bit(FailfastIOFailure, &rdev->flags);
 		md_error(mddev, rdev);
+	}
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
-- 
2.50.1

