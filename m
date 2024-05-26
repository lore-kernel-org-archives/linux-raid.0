Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8295937168;
	Sun, 26 May 2024 09:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716548; cv=none; b=sZvD4YPECXhUURtSjJF2qzQY15IhnXpDM2adbZo8gQylp1WSKbRhDgbfVAcU4Y5Hd8/DEgJee9nv+d33kx2bDFl6X56jElDIeKGTkleyIujVkUDbmQNeSF9HOdLT/GnAhGsyMovLw/OuzQR4DtxlV/ZSZnWrAvu2rpPTrHymQ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716548; c=relaxed/simple;
	bh=nsSV2feWzLit0COy8mIPyRtCh+VRcEiuzlLkj9gVkgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfejfAFgOGEj1IvvC3JzmKJKxPQOmpvSG/XjX0zGWmzrscCf600qgUnuZ1lARYD5F4pZXT9NZR7DNg3/1VZTzEsUfg52F6PHEYFhREgt+1G8/7IDWJuZA/veY3p7psQOr449/r5PwZK13XFVPR1Zp6eJZlPoRbEjQj3tQJtZflw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uOqrL/th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOqrL/th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CAEC32789;
	Sun, 26 May 2024 09:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716548;
	bh=nsSV2feWzLit0COy8mIPyRtCh+VRcEiuzlLkj9gVkgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOqrL/thcKZWXtU0Ox2crNtIA0MHBK4OTlSFAJUaa86hxiEseBR/TpS+f/X7Sb4ip
	 pOYLd+Re9DBGTiO92n8lOZPzs1D7RcbY6QPwC7KQYqVEJtHbqkj1D2MGXus8WaFMpE
	 82xSgDhQ5cSRY+o8UquMcgQ3uB2DqHEEx7JMJvxAM6Hv/Im3oadBoJuNug2wCcOtXl
	 V7Bkr8TmbfB89W6CW/dK8qBTrba5L9HofUQhbciaeI8K78MEA7CI2R8gICGpZP66PE
	 o9nBGp3L8aXq3cymV4mSvW1M8JdEIZ19S7CqqQ2/IRoqVV8FWvC3b+WjCgxtwEWW2X
	 3LBOyCenpRWDw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.8 02/14] md: Fix overflow in is_mddev_idle
Date: Sun, 26 May 2024 05:42:07 -0400
Message-ID: <20240526094224.3412675-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094224.3412675-1-sashal@kernel.org>
References: <20240526094224.3412675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.8.10
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 3f9f231236ce7e48780d8a4f1f8cb9fae2df1e4e ]

UBSAN reports this problem:

  UBSAN: Undefined behaviour in drivers/md/md.c:8175:15
  signed integer overflow:
  -2147483291 - 2072033152 cannot be represented in type 'int'
  Call trace:
   dump_backtrace+0x0/0x310
   show_stack+0x28/0x38
   dump_stack+0xec/0x15c
   ubsan_epilogue+0x18/0x84
   handle_overflow+0x14c/0x19c
   __ubsan_handle_sub_overflow+0x34/0x44
   is_mddev_idle+0x338/0x3d8
   md_do_sync+0x1bb8/0x1cf8
   md_thread+0x220/0x288
   kthread+0x1d8/0x1e0
   ret_from_fork+0x10/0x18

'curr_events' will overflow when stat accum or 'sync_io' is greater than
INT_MAX.

Fix it by changing sync_io, last_events and curr_events to 64bit.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240117031946.2324519-2-linan666@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c        | 7 ++++---
 drivers/md/md.h        | 4 ++--
 include/linux/blkdev.h | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f54012d684414..6eee89ad13b97 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8562,14 +8562,15 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 {
 	struct md_rdev *rdev;
 	int idle;
-	int curr_events;
+	long long curr_events;
 
 	idle = 1;
 	rcu_read_lock();
 	rdev_for_each_rcu(rdev, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_disk;
-		curr_events = (int)part_stat_read_accum(disk->part0, sectors) -
-			      atomic_read(&disk->sync_io);
+		curr_events =
+			(long long)part_stat_read_accum(disk->part0, sectors) -
+			atomic64_read(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
 		 * as sync_io is counted when a request starts, and
 		 * disk_stats is counted when it completes.
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 375ad4a2df71d..061a6fb15fc2e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -50,7 +50,7 @@ struct md_rdev {
 
 	sector_t sectors;		/* Device size (in 512bytes sectors) */
 	struct mddev *mddev;		/* RAID array if running */
-	int last_events;		/* IO event timestamp */
+	long long last_events;		/* IO event timestamp */
 
 	/*
 	 * If meta_bdev is non-NULL, it means that a separate device is
@@ -611,7 +611,7 @@ extern void mddev_unlock(struct mddev *mddev);
 
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
 {
-	atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
+	atomic64_add(nr_sectors, &bdev->bd_disk->sync_io);
 }
 
 static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b43ca3b9d2a26..5240c8dc854c4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -172,7 +172,7 @@ struct gendisk {
 	struct list_head slave_bdevs;
 #endif
 	struct timer_rand_state *random;
-	atomic_t sync_io;		/* RAID */
+	atomic64_t sync_io;		/* RAID */
 	struct disk_events *ev;
 
 #ifdef CONFIG_BLK_DEV_ZONED
-- 
2.43.0

