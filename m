Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9DE2EC096
	for <linux-raid@vger.kernel.org>; Mon, 27 Oct 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577517; cv=none; b=WTBJDnFR9xIXJKIcuOqkoc/4aYx+eK7ygS05l2FxM+69ZXdHyS8YxA43ATfX/ZS+lvrmkqOrZSIDlGhenNYaK3e9xbLw2rU91N4RVYI02qisEMvSZhDd5QWtwfDZt/qBrF1l7nBoPlukdPyI2KaglWLm39cHO4Q/ri8srmK0VDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577517; c=relaxed/simple;
	bh=o3mPadGkLNtqCe0Xkf+f5lzQl2+6xDrs2obkYDqJCow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBn8WlGwvDn/nm10Vs7+Z74/UQVjHXpq0ln51r46YpBhjFCt5QsjdsVnIZMOXyrBi8wh4GYclSAipnHDQoPGufSsGD8jC+7KzkkyGW7isNNSRzab+Xr37JaVxwx+zItiYh7PHX+gNmn2w/gASd8gtrIdnsj7D4l9Vtv/R+dREGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=oo1fa/4S; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="oo1fa/4S"
Received: from fedora (p3796170-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.173.170])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 59RF4hAc090988
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 28 Oct 2025 00:04:45 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=VKP0RBCaclB0YivyJvOzI9dmKCKygZBpmZQyobzcYlQ=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1761577485; v=1;
        b=oo1fa/4STlJIUJUIP7C0nq0rv7xcWIq3+MMCR554hD0/hcQKnDtT8Y4TwEy5Atoy
         r0EcZkUfCBsmjenmlQT1eFDYX2be1vyY+kY3cOKS846d/CJgu8nBYTYJm9lbz2TC
         2CvFddoYJ/seSRuSLP583upGSyti4ouF37IR6Nf71uCXP0O17QYnNKzeaxz0N1V0
         Ou6IrFLv/7J1UugAk94/y4EPKoe0ZDVaLEZ16aqFTwt2UhEBRadG9pnZQ/wpckJm
         cCtD15d57ELGYz5Z98rHyyyTX8A032+7rPclfMGN9cqRI2G0eEwFPP5sf/hFWgm4
         HmUpvqZAAswnJ4gYuFlUFw==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v5 02/16] md: serialize md_error()
Date: Tue, 28 Oct 2025 00:04:19 +0900
Message-ID: <20251027150433.18193-3-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251027150433.18193-1-k@mgml.me>
References: <20251027150433.18193-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Serialize the md_error() function in preparation for the introduction of
a conditional md_error() in a subsequent commit. The conditional
md_error() is intended to prevent unintentional setting of MD_BROKEN
during RAID1/10 failfast handling.

To enhance the failfast bio error handler, it must verify that the
affected rdev is not the last working device before marking it as
faulty. Without serialization, a race condition can occur if multiple
failfast bios attempt to call the error handler concurrently:

        failfast bio1			failfast bio2
        ---                             ---
        md_cond_error(md,rdev1,bio)	md_cond_error(md,rdev2,bio)
          if(!is_degraded(md))		  if(!is_degraded(md))
             raid1_error(md,rdev1)          raid1_error(md,rdev2)
               spin_lock(md)
               set_faulty(rdev1)
	       spin_unlock(md)
						spin_lock(md)
						set_faulty(rdev2)
						set_broken(md)
						spin_unlock(md)

This can unintentionally cause the array to stop in situations where the
'Last' rdev should not be marked as Faulty.

This commit serializes the md_error() function for all RAID
personalities to avoid this race condition. Future commits will
introduce a conditional md_error() specifically for failfast bio
handling.

Serialization is applied to both the standard and conditional md_error()
for the following reasons:

- Both use the same error-handling mechanism, so it's clearer to
  serialize them consistently.
- The md_error() path is cold, meaning serialization has no performance
  impact.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md-linear.c |  1 +
 drivers/md/md.c        | 10 +++++++++-
 drivers/md/md.h        |  1 +
 drivers/md/raid0.c     |  1 +
 drivers/md/raid1.c     |  6 +-----
 drivers/md/raid10.c    |  9 ++-------
 drivers/md/raid5.c     |  4 +---
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 7033d982d377..0f6893e4b9f5 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -298,6 +298,7 @@ static void linear_status(struct seq_file *seq, struct mddev *mddev)
 }
 
 static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
+	__must_hold(&mddev->device_lock)
 {
 	if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
 		char *md_name = mdname(mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d667580e3125..4ad9cb0ac98c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8444,7 +8444,8 @@ void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **threadp)
 }
 EXPORT_SYMBOL(md_unregister_thread);
 
-void md_error(struct mddev *mddev, struct md_rdev *rdev)
+void _md_error(struct mddev *mddev, struct md_rdev *rdev)
+	__must_hold(&mddev->device_lock)
 {
 	if (!rdev || test_bit(Faulty, &rdev->flags))
 		return;
@@ -8469,6 +8470,13 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 		queue_work(md_misc_wq, &mddev->event_work);
 	md_new_event();
 }
+
+void md_error(struct mddev *mddev, struct md_rdev *rdev)
+{
+	spin_lock(&mddev->device_lock);
+	_md_error(mddev, rdev);
+	spin_unlock(&mddev->device_lock);
+}
 EXPORT_SYMBOL(md_error);
 
 /* seq_file implementation /proc/mdstat */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 64ac22edf372..c982598cbf97 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -913,6 +913,7 @@ extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
+void _md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e443e478645a..8cf3caf9defd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -625,6 +625,7 @@ static void raid0_status(struct seq_file *seq, struct mddev *mddev)
 }
 
 static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
+	__must_hold(&mddev->device_lock)
 {
 	if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
 		char *md_name = mdname(mddev);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7924d5ee189d..202e510f73a4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1749,11 +1749,9 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
  * &mddev->fail_last_dev is off.
  */
 static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
+	__must_hold(&mddev->device_lock)
 {
 	struct r1conf *conf = mddev->private;
-	unsigned long flags;
-
-	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 
 	if (test_bit(In_sync, &rdev->flags) &&
 	    (conf->raid_disks - mddev->degraded) == 1) {
@@ -1761,7 +1759,6 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 
 		if (!mddev->fail_last_dev) {
 			conf->recovery_disabled = mddev->recovery_disabled;
-			spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 			return;
 		}
 	}
@@ -1769,7 +1766,6 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (test_and_clear_bit(In_sync, &rdev->flags))
 		mddev->degraded++;
 	set_bit(Faulty, &rdev->flags);
-	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	/*
 	 * if recovery is running, make sure it aborts.
 	 */
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 57c887070df3..25c0ab09807b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1993,19 +1993,15 @@ static int enough(struct r10conf *conf, int ignore)
  * &mddev->fail_last_dev is off.
  */
 static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
+	__must_hold(&mddev->device_lock)
 {
 	struct r10conf *conf = mddev->private;
-	unsigned long flags;
-
-	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 
 	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
 		set_bit(MD_BROKEN, &mddev->flags);
 
-		if (!mddev->fail_last_dev) {
-			spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
+		if (!mddev->fail_last_dev)
 			return;
-		}
 	}
 	if (test_and_clear_bit(In_sync, &rdev->flags))
 		mddev->degraded++;
@@ -2015,7 +2011,6 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(Faulty, &rdev->flags);
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
-	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
 		"md/raid10:%s: Operation continuing on %d devices.\n",
 		mdname(mddev), rdev->bdev,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3350dcf9cab6..d1372b1bc405 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2905,15 +2905,14 @@ static void raid5_end_write_request(struct bio *bi)
 }
 
 static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
+	__must_hold(&mddev->device_lock)
 {
 	struct r5conf *conf = mddev->private;
-	unsigned long flags;
 	pr_debug("raid456: error called\n");
 
 	pr_crit("md/raid:%s: Disk failure on %pg, disabling device.\n",
 		mdname(mddev), rdev->bdev);
 
-	spin_lock_irqsave(&conf->mddev->device_lock, flags);
 	set_bit(Faulty, &rdev->flags);
 	clear_bit(In_sync, &rdev->flags);
 	mddev->degraded = raid5_calc_degraded(conf);
@@ -2929,7 +2928,6 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 			mdname(mddev), conf->raid_disks - mddev->degraded);
 	}
 
-	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 
 	set_bit(Blocked, &rdev->flags);
-- 
2.50.1

