Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA282F1FE5;
	Sun, 17 Aug 2025 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755451681; cv=none; b=ixnXI3WTSg1BdLEhdLoAWQTGHfmCcXJPwIGcP9YlGTE9jC39wmv7ap1gncEjiYRH6p1HQLOu/rkCAGsdl5qzgbC8z0AS4x89620Hl1cDRc7wrR96C869zotaytbG2TVy1f4lWaNkAKC66jFWlDwtSLLjcxk/WnlJoyFoftPPg3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755451681; c=relaxed/simple;
	bh=rVKKRlVEgINWP7MeV5cxmJ5wJ/X2l+zWWyy1wIz9UVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5+phJRIb6vsWICNmMQ3U4GLZIyNpVabV2l0ztQK5NsiRu21aMOfLYaCYLxIsVWmyyFAgJgTuZ8gkL0Gqxa7hW3SObVF9BFjipavlcgReZkiPqZJB3DtBoKcHrvmwIfBNE4xS14iiw7gDLYvX6mvClWkv3pRmdaYJMZXGaXK9gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=afwwNa11; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="afwwNa11"
Received: from fedora (p3174069-ipxg00b01tokaisakaetozai.aichi.ocn.ne.jp [122.23.47.69])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57HHRM9a012978
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 18 Aug 2025 02:27:26 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=EO+r2qx58QOPW26498dc8PhKaly1g8RBWBhYbH7YN2g=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1755451646; v=1;
        b=afwwNa11U6vreLSqRWaidwpBzAIjSJWav1VXlKmc9W0ypkyBk1lKc7VZOzuN6uBV
         Cvx+6HrSpCT/qdKPJ8hElTNK+nbwhmx759NmgzRirYzFDOGLaEun1lbhbMsTVqCm
         vCo3fzCkIlxwPqLg6uoZFz0/sGZe5qMDMYYfgqH2Pv2wZJA1HNXznonxy1vZJ7yL
         p7xAB3Z1wF6fguZjEyPlG0OfyPhpp0daReYGcM5IRvQs+Y0C6Ct9TOJppXx/FXKv
         rnrcmNHmJMTeoz9gN8CnuG0NEpxqxD1U+MCguqZUHNe3pULPGsCRpT+5IkbinFhX
         qLkUDvCrAnd0g0NIlX7jQw==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v2 1/3] md/raid1,raid10: don't broken array on failfast metadata write fails
Date: Mon, 18 Aug 2025 02:27:08 +0900
Message-ID: <20250817172710.4892-2-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250817172710.4892-1-k@mgml.me>
References: <20250817172710.4892-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A super_write IO failure with MD_FAILFAST must not cause the array
to fail.

Because a failfast bio may fail even when the rdev is not broken,
so IO must be retried rather than failing the array when a metadata
write with MD_FAILFAST fails on the last rdev.

A metadata write with MD_FAILFAST is retried after failure as
follows:

1. In super_written, MD_SB_NEED_REWRITE is set in sb_flags.

2. In md_super_wait, which is called by the function that
executed md_super_write and waits for completion,
-EAGAIN is returned because MD_SB_NEED_REWRITE is set.

3. The caller of md_super_wait (such as md_update_sb)
receives a negative return value and then retries md_super_write.

4. The md_super_write function, which is called to perform
the same metadata write, issues a write bio without MD_FAILFAST
this time.

When a write from super_written without MD_FAILFAST fails,
the array may broken, and MD_BROKEN should be set.

After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
calling md_error on the last rdev in RAID1/10 always sets
the MD_BROKEN flag on the array.
As a result, when failfast IO fails on the last rdev, the array
immediately becomes failed.

This commit prevents MD_BROKEN from being set when a super_write with
MD_FAILFAST fails on the last rdev, ensuring that the array does
not become failed due to failfast IO failures.

Failfast IO failures on any rdev except the last one are not retried
and are marked as Faulty immediately. This minimizes array IO latency
when an rdev fails.

Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c     |  9 ++++++---
 drivers/md/md.h     |  7 ++++---
 drivers/md/raid1.c  | 12 ++++++++++--
 drivers/md/raid10.c | 12 ++++++++++--
 4 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..61a8188849a3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -999,14 +999,17 @@ static void super_written(struct bio *bio)
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
 	} else
-		clear_bit(LastDev, &rdev->flags);
+		clear_bit(FailfastIOFailure, &rdev->flags);
 
 	bio_put(bio);
 
@@ -1048,7 +1051,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 
 	if (test_bit(MD_FAILFAST_SUPPORTED, &mddev->flags) &&
 	    test_bit(FailFast, &rdev->flags) &&
-	    !test_bit(LastDev, &rdev->flags))
+	    !test_bit(FailfastIOFailure, &rdev->flags))
 		bio->bi_opf |= MD_FAILFAST;
 
 	atomic_inc(&mddev->pending_writes);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51af29a03079..cf989aca72ad 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -281,9 +281,10 @@ enum flag_bits {
 				 * It is expects that no bad block log
 				 * is present.
 				 */
-	LastDev,		/* Seems to be the last working dev as
-				 * it didn't fail, so don't use FailFast
-				 * any more for metadata
+	FailfastIOFailure,	/* A device that failled a metadata write
+				 * with failfast.
+				 * error_handler must not fail the array
+				 * if last device has this flag.
 				 */
 	CollisionCheck,		/*
 				 * check if there is collision between raid1
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 408c26398321..fc7195e58f80 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1746,8 +1746,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
  *	- recovery is interrupted.
  *	- &mddev->degraded is bumped.
  *
- * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * If @rdev is marked with &FailfastIOFailure, it means that super_write
+ * failed in failfast and will be retried, so the @mddev did not fail.
+ *
+ * @rdev is marked as &Faulty excluding any cases:
+ *	- when @mddev is failed and &mddev->fail_last_dev is off
+ *	- when @rdev is last device and &FailfastIOFailure flag is set
  */
 static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -1758,6 +1762,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (test_bit(In_sync, &rdev->flags) &&
 	    (conf->raid_disks - mddev->degraded) == 1) {
+		if (test_bit(FailfastIOFailure, &rdev->flags)) {
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			return;
+		}
 		set_bit(MD_BROKEN, &mddev->flags);
 
 		if (!mddev->fail_last_dev) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b60c30bfb6c7..ff105a0dcd05 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1995,8 +1995,12 @@ static int enough(struct r10conf *conf, int ignore)
  *	- recovery is interrupted.
  *	- &mddev->degraded is bumped.
  *
- * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * If @rdev is marked with &FailfastIOFailure, it means that super_write
+ * failed in failfast, so the @mddev did not fail.
+ *
+ * @rdev is marked as &Faulty excluding any cases:
+ *	- when @mddev is failed and &mddev->fail_last_dev is off
+ *	- when @rdev is last device and &FailfastIOFailure flag is set
  */
 static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -2006,6 +2010,10 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	spin_lock_irqsave(&conf->device_lock, flags);
 
 	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
+		if (test_bit(FailfastIOFailure, &rdev->flags)) {
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			return;
+		}
 		set_bit(MD_BROKEN, &mddev->flags);
 
 		if (!mddev->fail_last_dev) {
-- 
2.50.1

