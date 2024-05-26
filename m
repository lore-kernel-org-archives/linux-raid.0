Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ABB12AACA;
	Sun, 26 May 2024 09:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716595; cv=none; b=tpOb5qF+OHh/g1kzznRSwWMFSYFYax6HJ102lF0pX30i6NU4W1vjA8BFO3K7PpotPyx2CDfM3YN6H+gtexODPrLxgXdH6BQG6akrfic4oDc363EoD4/GxoOa3kxzdMCFR4P4gJlSzUHcknLmktjjhfiF7Ch+2ew0SxjhrqiOEXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716595; c=relaxed/simple;
	bh=ikzD/pPJyDYEsC44NSBTdvkAV6GGd/PPD7UKDhPhev4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZbHfKEgh1aPos2gBBjyWuU29Kslr8aMDiT65YlJE1HxTRJr/aodN7m45sd6ZVNodAd20mR+Js8US6WMDTpzixQqjqy2EEZpAn4MQFrB0feoxXJc47U5DEqLsZq9XfOP5ODaSDhtbQ5wLwXMCQ1VpZoX/ICqLEBsdXYFlL68v65Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MAtnp7vJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MAtnp7vJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD72AC32782;
	Sun, 26 May 2024 09:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716594;
	bh=ikzD/pPJyDYEsC44NSBTdvkAV6GGd/PPD7UKDhPhev4=;
	h=From:To:Cc:Subject:Date:From;
	b=MAtnp7vJpb90jMSvPcOF519uEfG0nwJX2yJ/fino+jLhiuyAFR3MjEpp2+skgHo1b
	 fifKgmOSDptkJv1IhJIwic/a8Xw6cI/a3W2bYcbxyOaKx8rSrOy+gwJVpYgffONiRJ
	 iS+axllub0UWm/CXOpV86UCCeSoUU6DRpN4LskIdX/6MXlPgGLI0SjlnCHKAfdZy9x
	 nrkPR/gSyMVG65ABn7fMYSevd7fz7qG5Vh1hzmM+hX+SPGxS36vztkofkwMd46fwiR
	 erQFTX6wGetu1DlDU0YuZNS6pU/lhaddvKLmaTd/EDhlvqMwkkgVrCkqgp9KZkHVUh
	 UgAboiQquhV/g==
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
Subject: [PATCH AUTOSEL 6.1 1/9] md: Fix overflow in is_mddev_idle
Date: Sun, 26 May 2024 05:43:02 -0400
Message-ID: <20240526094312.3413460-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.91
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
index 788acc81e7a84..7b7c048e2670a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8541,14 +8541,15 @@ static int is_mddev_idle(struct mddev *mddev, int init)
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
index 4f0b480974552..5910527514db2 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -50,7 +50,7 @@ struct md_rdev {
 
 	sector_t sectors;		/* Device size (in 512bytes sectors) */
 	struct mddev *mddev;		/* RAID array if running */
-	int last_events;		/* IO event timestamp */
+	long long last_events;		/* IO event timestamp */
 
 	/*
 	 * If meta_bdev is non-NULL, it means that a separate device is
@@ -576,7 +576,7 @@ extern void mddev_unlock(struct mddev *mddev);
 
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
 {
-	atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
+	atomic64_add(nr_sectors, &bdev->bd_disk->sync_io);
 }
 
 static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e255674a9ee72..02e55676e0283 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -161,7 +161,7 @@ struct gendisk {
 	struct list_head slave_bdevs;
 #endif
 	struct timer_rand_state *random;
-	atomic_t sync_io;		/* RAID */
+	atomic64_t sync_io;		/* RAID */
 	struct disk_events *ev;
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct kobject integrity_kobj;
-- 
2.43.0

