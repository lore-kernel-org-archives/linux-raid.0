Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9B526D4DD
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 03:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757907828; cv=none; b=jgfJUAIipvbuCeoFxCS1Vc9YgV5qE7Zh/scoMxKKbNfB4AO6NVI92SjMDm5r6uCXhmr4XNffzppN7WuSNqEbSrmqucuHzKxnP18mRFcLsPAvMAbdsB9cWF76DWQKjYidjTtB/wYQAHC/HEO5FfpUiQI8mmwPSMqGS2c9QUCiWf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757907828; c=relaxed/simple;
	bh=wD5CMM6TvPfA/2xDATvKzQg1tYzefqIW7PeON1dutxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jl8k2CcKecVARDwnj7l2Okl8sH96xeKdKQc1B7S+bIDUu7sI/AZsZVM9ri8aHYGojLEOp7PkhODMJqIh4ihXkBFBQCa/6CbZi6vEO6zIWgIgmrIH6ZaOco9VBON8oqgf4NMIx6/DjPZ4hgODTtr75h7vz+Y+xDBaTURmH+ZP/fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=W1rUQz75; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="W1rUQz75"
Received: from fedora (p4504123-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [114.172.113.123])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58F3gpZl004256
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Sep 2025 12:43:16 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=03vpmN1U17dRcmG0NGZtJHktTy8T8Gasill9Rvm0iL0=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1757907796; v=1;
        b=W1rUQz75FBm4uvA1JAJGwHh+FF+NyYqirGbFwqb4v0W5JP4skhjFeIbqjOu8aQZ9
         W5tM1Gnf1Gbsk1GcogYcxYNKHtcf3bTOz5SS5pAQ9P9y4IU7vjlcusZxdz/3CS/B
         da9Z3UmhMkvoNUdP6IElYoR72jScEipTI1OllTpocYvEMxCsUtecHmKBHhpVfats
         V9hZ68OmwUxAaoGtLq0ReEmbKxqU5b+yDV4nykFnl5MRCoKn7bKSYtcP4zrwkhwl
         fdqvWa8Gzhj85xQsL147zvXdRcIZ3CjQl/R3CSLNRgf74uZwloRJGG4bcPEbXRR+
         nymlg4TO/6WrQlDESKHIlg==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v4 4/9] md/raid1,raid10: Don't set MD_BROKEN on failfast bio failure
Date: Mon, 15 Sep 2025 12:42:05 +0900
Message-ID: <20250915034210.8533-5-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250915034210.8533-1-k@mgml.me>
References: <20250915034210.8533-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Failfast is a feature implemented only for RAID1 and RAID10. It instructs
the block device providing the rdev to immediately return a bio error
without retrying if any issue occurs. This allows quickly detaching a
problematic rdev and minimizes IO latency.

Due to its nature, failfast bios can fail easily, and md must not mark
an essential rdev as Faulty or set MD_BROKEN on the array just because
a failfast bio failed.

When failfast was introduced, RAID1 and RAID10 were designed to continue
operating normally even if md_error was called for the last rdev. However,
with the introduction of MD_BROKEN in RAID1/RAID10
in commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"), calling
md_error for the last rdev now prevents further writes to the array.
Despite this, the current failfast error handler still assumes that
calling md_error will not break the array.

Normally, this is not an issue because MD_FAILFAST is not set when a bio
is issued to the last rdev. However, if the array is not degraded and a
bio with MD_FAILFAST has been issued, simultaneous failures could
potentially break the array. This is unusual but can happen; for example,
this can occur when using NVMe over TCP if all rdevs depend on
a single Ethernet link.

In other words, this becomes a problem under the following conditions:
Preconditions:
* Failfast is enabled on all rdevs.
* All rdevs are In_sync - This is a requirement for bio to be submit
  with MD_FAILFAST.
* At least one bio has been submitted but has not yet completed.

Trigger condition:
* All underlying devices of the rdevs return an error for their failfast
  bios.

Whether the bio is a read or a write makes little difference to the
outcome.
In the write case, md_error is invoked on each rdev through its bi_end_io
handler.
In the read case, losing the first rdev triggers a metadata
update. Next, md_super_write, unlike raid1_write_request, issues the bio
with MD_FAILFAST if the rdev supports it, causing the bio to fail
immediately - Before this patchset, LastDev was set only by the failure
path in super_written. Consequently, super_written calls md_error on the
remaining rdev.

Prior to this commit, the following changes were introduced:
* The helper function md_bio_failure_error() that skips the error handler
  if a failfast bio targets the last rdev.
* Serialization md_error() and md_bio_failure_error().
* Setting the LastDev flag for rdevs that must not be lost.

This commit uses md_bio_failure_error() instead of md_error() for failfast
bio failures, ensuring that failfast bios do not stop array operations.

Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c     |  5 +----
 drivers/md/raid1.c  | 37 ++++++++++++++++++-------------------
 drivers/md/raid10.c |  9 +++++----
 3 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 65fdd9bae8f4..65814bbe9bad 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1004,11 +1004,8 @@ static void super_written(struct bio *bio)
 	if (bio->bi_status) {
 		pr_err("md: %s gets error=%d\n", __func__,
 		       blk_status_to_errno(bio->bi_status));
-		md_error(mddev, rdev);
-		if (!test_bit(Faulty, &rdev->flags)
-		    && (bio->bi_opf & MD_FAILFAST)) {
+		if (!md_bio_failure_error(mddev, rdev, bio))
 			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
-		}
 	}
 
 	bio_put(bio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 32ad6b102ff7..8fff9dacc6e0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -470,7 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
 		    (bio->bi_opf & MD_FAILFAST) &&
 		    /* We never try FailFast to WriteMostly devices */
 		    !test_bit(WriteMostly, &rdev->flags)) {
-			md_error(r1_bio->mddev, rdev);
+			md_bio_failure_error(r1_bio->mddev, rdev, bio);
 		}
 
 		/*
@@ -2178,8 +2178,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	if (test_bit(FailFast, &rdev->flags)) {
 		/* Don't try recovering from here - just fail it
 		 * ... unless it is the last working device of course */
-		md_error(mddev, rdev);
-		if (test_bit(Faulty, &rdev->flags))
+		if (md_bio_failure_error(mddev, rdev, bio))
 			/* Don't try to read from here, but make sure
 			 * put_buf does it's thing
 			 */
@@ -2657,9 +2656,8 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	struct mddev *mddev = conf->mddev;
-	struct bio *bio;
+	struct bio *bio, *updated_bio;
 	struct md_rdev *rdev;
-	sector_t sector;
 
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
 	/* we got a read error. Maybe the drive is bad.  Maybe just
@@ -2672,29 +2670,30 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 */
 
 	bio = r1_bio->bios[r1_bio->read_disk];
-	bio_put(bio);
-	r1_bio->bios[r1_bio->read_disk] = NULL;
+	updated_bio = NULL;
 
 	rdev = conf->mirrors[r1_bio->read_disk].rdev;
-	if (mddev->ro == 0
-	    && !test_bit(FailFast, &rdev->flags)) {
-		freeze_array(conf, 1);
-		fix_read_error(conf, r1_bio);
-		unfreeze_array(conf);
-	} else if (mddev->ro == 0 && test_bit(FailFast, &rdev->flags)) {
-		md_error(mddev, rdev);
+	if (mddev->ro == 0) {
+		if (!test_bit(FailFast, &rdev->flags)) {
+			freeze_array(conf, 1);
+			fix_read_error(conf, r1_bio);
+			unfreeze_array(conf);
+		} else {
+			md_bio_failure_error(mddev, rdev, bio);
+		}
 	} else {
-		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
+		updated_bio = IO_BLOCKED;
 	}
 
+	bio_put(bio);
+	r1_bio->bios[r1_bio->read_disk] = updated_bio;
+
 	rdev_dec_pending(rdev, conf->mddev);
-	sector = r1_bio->sector;
-	bio = r1_bio->master_bio;
 
 	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
 	r1_bio->state = 0;
-	raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
-	allow_barrier(conf, sector);
+	raid1_read_request(mddev, r1_bio->master_bio, r1_bio->sectors, r1_bio);
+	allow_barrier(conf, r1_bio->sector);
 }
 
 static void raid1d(struct md_thread *thread)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dc4edd4689f8..b73af94a88b0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -488,7 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
 			dec_rdev = 0;
 			if (test_bit(FailFast, &rdev->flags) &&
 			    (bio->bi_opf & MD_FAILFAST)) {
-				md_error(rdev->mddev, rdev);
+				md_bio_failure_error(rdev->mddev, rdev, bio);
 			}
 
 			/*
@@ -2443,7 +2443,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 				continue;
 		} else if (test_bit(FailFast, &rdev->flags)) {
 			/* Just give up on this device */
-			md_error(rdev->mddev, rdev);
+			md_bio_failure_error(rdev->mddev, rdev, tbio);
 			continue;
 		}
 		/* Ok, we need to write this bio, either to correct an
@@ -2895,8 +2895,9 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
-	} else
-		md_error(mddev, rdev);
+	} else {
+		md_bio_failure_error(mddev, rdev, bio);
+	}
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
-- 
2.50.1

