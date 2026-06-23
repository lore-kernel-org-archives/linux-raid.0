Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788D137BE83
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 11:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782213399; cv=none; b=jPejByb9Z1y2axITjoIEJoIR/Lu3aGJTwQX2DCDdo+NmJJ00PXWiKBRk8JJi5dlQmOzjMr2Lo5LEy+tGDuUMcdZ/GkYduQreF3PDqUi2kCe8lvnfJHAu25fa3ErDHu4hDeEih2O7aQq1K/q7ksh+76iGKokRHEAldD/UvixGY6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782213399; c=relaxed/simple;
	bh=+VPd0K2CSn/sORDjMQ1zrY0DAKPQVgHWoYfiys0pttM=;
	h=To:Subject:Cc:From:Message-Id:Date:Mime-Version:Content-Type; b=lYuoR88Jhh4dlFKyHEaq5gAYXEQmTbBUPH/PnsQBpqbD26nl+eH6yFQLVKU178Q3h/svzkXX1zOR7Qqu6Od9RLunsZHcgHOfvOiJPE5nOfDs/6CEJepe56wCYAPJ0cAdzp/eSxDvfsNkPT0fj8xIohh6nl3WPq+qPjsBsJ1jX+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=rnVfhsfM; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="rnVfhsfM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782213391;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=dv7C9+8x8Uhg3rvEkEKsgSoIjr9CG3R+eVtC0POJY7Y=;
 b=rnVfhsfM5VqFFr9zTq30CPMl3MYZFlG/n0ovJ4yPPjB6TIKip4CgrVljNpAgMYKPostGvR
 SVFxQlm2xS6m0gHbaSW0fnF2FYA7YZWxJuFImwGzjQNHycstnGQ9kC/pi/bMTgi/T45heg
 eZHPs22XO5MNoz8hTgutJ/hUD7oOgEc0Iy2C7M869C/nM5r1Ca6dfqXe0U7KmBai4sP3O4
 v2tQcdyKIfWw3xAOUdXNMoSxumU9EGN0grbxL5Xrrog8TeOtMBVdwMQ30s0xPbD2O7rIok
 G/fh0FZqQo7Cxycf1ITbFPth6s30kq/KKFGCe/UUEqNQyoGedE5s2nz3SNCBZQ==
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Subject: [PATCH v2] md: use READ_ONCE() for lockless reads of sb_flags
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 7bit
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260623111617.2500313-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Date: Tue, 23 Jun 2026 19:16:17 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost.localdomain ([183.34.169.141]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 19:16:28 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a3a6b0d+ab61f6+vger.kernel.org+chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

sb_flags is checked without a lock in md, raid1, raid5, and raid10.
KCSAN reports these reads as data races.

The write side uses atomic bit ops.
The read side still has plain loads in a few places.

Use READ_ONCE() for the lockless reads of sb_flags.


v1 -> v2:
        - Add lock-free read paths for other array levels.

KCSAN reports #1:
======================================

BUG: KCSAN: data-race in md_check_recovery / md_write_start

write (marked) to 0xffff8e39f897f030 of 8 bytes by task 248146 on cpu 8:
  md_write_start+0x5dd/0x910
  raid10_make_request+0x9b/0x1080
  md_handle_request+0x4a2/0xa40
  [........]

read to 0xffff8e39f897f030 of 8 bytes by task 250445 on cpu 11:
  md_check_recovery+0x574/0x900
  raid10d+0xb7/0x2950
  [........]

KCSAN reports #2:
======================================
BUG: KCSAN: data-race in md_check_recovery / md_write_start

write (marked) to 0xffff8e39e953f030 of 8 bytes by task 540091 on cpu 11:
  md_write_start+0x5dd/0x910
  raid1_make_request+0x141/0x1990
  [........]

read to 0xffff8e39e953f030 of 8 bytes by task 580822 on cpu 0:
  md_check_recovery+0x574/0x900
  raid1d+0xcc/0x3840
  [........]

value changed: 0x0000000000000002 -> 0x0000000000000006

KCSAN reports #3:
======================================
BUG: KCSAN: data-race in md_check_recovery / md_do_sync.cold

write (marked) to 0xffff8e39e9404030 of 8 bytes by task 492473 on cpu 6:
  md_do_sync.cold+0x3f6/0x1686
  [........]

read to 0xffff8e39e9404030 of 8 bytes by task 492402 on cpu 3:
  md_check_recovery+0x16d/0x900
  raid1d+0xcc/0x3840
  [........]

value changed: 0x0000000000000000 -> 0x0000000000000002

KCSAN reports #4:
======================================
BUG: KCSAN: data-race in md_do_sync.cold / raid5d

write (marked) to 0xffff8e39c35cb030 of 8 bytes by task 192196 on cpu 10:
  md_do_sync.cold+0x3f6/0x1686
  md_thread+0x15a/0x2d0
  [........]

read to 0xffff8e39c35cb030 of 8 bytes by task 190759 on cpu 5:
  raid5d+0x7f9/0xba0
  md_thread+0x15a/0x2d0
  [........]

value changed: 0x0000000000000000 -> 0x0000000000000002

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md.c     | 8 ++++----
 drivers/md/raid1.c  | 2 +-
 drivers/md/raid10.c | 4 ++--
 drivers/md/raid5.c  | 7 ++++---
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 096bb64e87bd..c5c50640b684 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6830,11 +6830,11 @@ int md_run(struct mddev *mddev)
 		 * via sysfs - until a lack of spares is confirmed.
 		 */
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 
-	if (mddev->sb_flags)
+	if (READ_ONCE(mddev->sb_flags))
 		md_update_sb(mddev, 0);
 
 	if (IS_ENABLED(CONFIG_MD_BITMAP) && !mddev->bitmap_info.file &&
 	    !mddev->bitmap_info.offset)
 		md_bitmap_set_none(mddev);
@@ -7024,11 +7024,11 @@ static void __md_stop_writes(struct mddev *mddev)
 			mddev->bitmap_ops->flush(mddev);
 	}
 
 	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
-	     mddev->sb_flags)) {
+	     READ_ONCE(mddev->sb_flags))) {
 		/* mark array as shutdown cleanly */
 		if (!mddev_is_clustered(mddev))
 			mddev->in_sync = 1;
 		md_update_sb(mddev, 1);
 	}
@@ -10294,11 +10294,11 @@ static bool md_should_do_recovery(struct mddev *mddev)
 	/*
 	 * MD_SB_CHANGE_PENDING indicates that the array is switching from clean to
 	 * active, and no action is needed for now.
 	 * All other MD_SB_* flags require to update the superblock.
 	 */
-	if (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING))
+	if (READ_ONCE(mddev->sb_flags) & ~ (1<<MD_SB_CHANGE_PENDING))
 		return true;
 
 	/*
 	 * If the array is not using external metadata and there has been no data
 	 * written for some time, then the array's status needs to be set to
@@ -10423,11 +10423,11 @@ void md_check_recovery(struct mddev *mddev)
 			spin_lock(&mddev->lock);
 			set_in_sync(mddev);
 			spin_unlock(&mddev->lock);
 		}
 
-		if (mddev->sb_flags)
+		if (READ_ONCE(mddev->sb_flags))
 			md_update_sb(mddev, 0);
 
 		/*
 		 * Never start a new sync thread if MD_RECOVERY_RUNNING is
 		 * still set.
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 29b58583e381..bd6808656edb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2738,11 +2738,11 @@ static void raid1d(struct md_thread *thread)
 			handle_read_error(conf, r1_bio);
 		else
 			WARN_ON_ONCE(1);
 
 		cond_resched();
-		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
+		if (READ_ONCE(mddev->sb_flags) & ~(1 << MD_SB_CHANGE_PENDING))
 			md_check_recovery(mddev);
 	}
 	blk_finish_plug(&plug);
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index adaf9e432e25..3ffa5a19964d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3030,11 +3030,11 @@ static void raid10d(struct md_thread *thread)
 			handle_read_error(mddev, r10_bio);
 		else
 			WARN_ON_ONCE(1);
 
 		cond_resched();
-		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
+		if (READ_ONCE(mddev->sb_flags) & ~(1 << MD_SB_CHANGE_PENDING))
 			md_check_recovery(mddev);
 	}
 	blk_finish_plug(&plug);
 }
 
@@ -4698,11 +4698,11 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		else
 			mddev->curr_resync_completed = conf->reshape_progress;
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
-		wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
+		wait_event(mddev->sb_wait, READ_ONCE(mddev->sb_flags) == 0 ||
 			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 			allow_barrier(conf);
 			return sectors_done;
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ded6a69f7795..cb58b4353995 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1219,11 +1219,11 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				break;
 
 			if (bad < 0) {
 				set_bit(BlockedBadBlocks, &rdev->flags);
 				if (!conf->mddev->external &&
-				    conf->mddev->sb_flags) {
+				    READ_ONCE(conf->mddev->sb_flags)) {
 					/* It is very unlikely, but we might
 					 * still need to write out the
 					 * bad block log - better give it
 					 * a chance*/
 					md_check_recovery(conf->mddev);
@@ -6469,11 +6469,11 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 					rdev->recovery_offset = sector_nr;
 
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
-		wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
+		wait_event(mddev->sb_wait, READ_ONCE(mddev->sb_flags) == 0 ||
 			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			return 0;
 		spin_lock_irq(&conf->device_lock);
 		conf->reshape_safe = mddev->reshape_position;
@@ -6913,11 +6913,12 @@ static void raid5d(struct md_thread *thread)
 						   conf->temp_inactive_list);
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
 
-		if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
+		if (READ_ONCE(mddev->sb_flags) &
+		    ~(1 << MD_SB_CHANGE_PENDING)) {
 			spin_unlock_irq(&conf->device_lock);
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
 		}
 	}
-- 
2.54.0
