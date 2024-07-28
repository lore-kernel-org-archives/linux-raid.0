Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914C8383A2;
	Sun, 28 Jul 2024 00:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722127678; cv=none; b=hyB+0fXd1Aa/6f1EAxRpoA5lh5twrV0hGaSuESlRhdMuHBH5ANHYMDu6umwLBGsLHpTcmHapaUQLoQw6ukRYU9FJHQ4gdBgryl1KDU7pt9bl/23VU4laszCNpER5hdk5nnKsN1lcMH+xKzWI2y7a0By1Tn23Uz9hHb6ZhReKSsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722127678; c=relaxed/simple;
	bh=2DA5ODbPhup3SqaAnpEDurb8Qh4Pb7CHeH+VElaSxjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsejxG8Z5r59lgmz/Ew1rQ//4vz+XFT+Rqv6KvXXWJr1aD8jJ7jnQS2len1ay0PQpTnpbsP5djcXEoiCFUsQn3yZ5gXRXVQ2QJFu4ixLiynxoxStjJYOABZcfYDKkjXyKu/ckxrbu6axa+hL8jzPK74l05UPgBtx1FJUZNx/AMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUhmoMBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUhmoMBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B069C4AF14;
	Sun, 28 Jul 2024 00:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722127678;
	bh=2DA5ODbPhup3SqaAnpEDurb8Qh4Pb7CHeH+VElaSxjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUhmoMBcOLfdLR36mHbFipoWQKx4CQOnrQgeC/nI0DLuE74eMBKjOeLoeR9uoyhZ4
	 HC21L9IT7uVlLxBb0ahvGI5DOdsL/K8cDITn6C8AzPbJgfgQ4vfscEPhkx4Z9zesGe
	 k9iq6kKZ9DxKU2Q4bpB9/7UUf33yIasABsntai3KnLJmiaZofNLjGVsNx0eVOEgrh4
	 CqmqYOs4ykkKOv6ksgdWI6F62zPUHMddrhfbmdRecCvzdVDMEKwtaIcYtqkM3fvwlv
	 F6/yZsqnNL3Hy5x683ZFEStD9hdn6n1s7ntnuyMabYZqWWKr+hagpzI7z3+zWnSFIB
	 r/ENfBG9I+UFA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 09/16] md: change the return value type of md_write_start to void
Date: Sat, 27 Jul 2024 20:47:26 -0400
Message-ID: <20240728004739.1698541-9-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728004739.1698541-1-sashal@kernel.org>
References: <20240728004739.1698541-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.2
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 03e792eaf18ec2e93e2c623f9f1a4bdb97fe4126 ]

Commit cc27b0c78c79 ("md: fix deadlock between mddev_suspend() and
md_write_start()") aborted md_write_start() with false when mddev is
suspended, which fixed a deadlock if calling mddev_suspend() with
holding reconfig_mutex(). Since mddev_suspend() now includes
lockdep_assert_not_held(), it no longer holds the reconfig_mutex. This
makes previous abort unnecessary. Now, remove unnecessary abort and
change function return value to void.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240525185257.3896201-2-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c     | 14 ++++----------
 drivers/md/md.h     |  2 +-
 drivers/md/raid1.c  |  3 +--
 drivers/md/raid10.c |  3 +--
 drivers/md/raid5.c  |  3 +--
 5 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 09c55d9a2c542..6bac20e82ff02 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8640,12 +8640,12 @@ EXPORT_SYMBOL(md_done_sync);
  * A return value of 'false' means that the write wasn't recorded
  * and cannot proceed as the array is being suspend.
  */
-bool md_write_start(struct mddev *mddev, struct bio *bi)
+void md_write_start(struct mddev *mddev, struct bio *bi)
 {
 	int did_change = 0;
 
 	if (bio_data_dir(bi) != WRITE)
-		return true;
+		return;
 
 	BUG_ON(mddev->ro == MD_RDONLY);
 	if (mddev->ro == MD_AUTO_READ) {
@@ -8678,15 +8678,9 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	if (!mddev->has_superblocks)
-		return true;
+		return;
 	wait_event(mddev->sb_wait,
-		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
-		   is_md_suspended(mddev));
-	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
-		percpu_ref_put(&mddev->writes_pending);
-		return false;
-	}
-	return true;
+		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 }
 EXPORT_SYMBOL(md_write_start);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ca085ecad5044..487582058f741 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -785,7 +785,7 @@ extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **t
 extern void md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
-extern bool md_write_start(struct mddev *mddev, struct bio *bi);
+extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b8a71ca66dde..0d80ff471c73d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1687,8 +1687,7 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 	if (bio_data_dir(bio) == READ)
 		raid1_read_request(mddev, bio, sectors, NULL);
 	else {
-		if (!md_write_start(mddev,bio))
-			return false;
+		md_write_start(mddev,bio);
 		raid1_write_request(mddev, bio, sectors);
 	}
 	return true;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a4556d2e46bf9..f8d7c02c6ed56 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1836,8 +1836,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 	    && md_flush_request(mddev, bio))
 		return true;
 
-	if (!md_write_start(mddev, bio))
-		return false;
+	md_write_start(mddev, bio);
 
 	if (unlikely(bio_op(bio) == REQ_OP_DISCARD))
 		if (!raid10_handle_discard(mddev, bio))
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2bd1ce9b39226..a84389311dd1e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6078,8 +6078,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		ctx.do_flush = bi->bi_opf & REQ_PREFLUSH;
 	}
 
-	if (!md_write_start(mddev, bi))
-		return false;
+	md_write_start(mddev, bi);
 	/*
 	 * If array is degraded, better not do chunk aligned read because
 	 * later we might have to read it again in order to reconstruct
-- 
2.43.0

