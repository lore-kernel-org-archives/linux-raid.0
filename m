Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFFE23A0;
	Tue,  7 May 2024 02:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715049676; cv=none; b=q+FMNedFphZBKXq05tylyck9kttbT0rQGnH8OMjlroVfUkMiY6fospTrrmkPw/pSneIms1vcmgBqmm9X9TVgYI6IgqHNFDbGz+37AE4f8lFU3P5UALMutJEEEetaLsoExt+ftbaGtGAJY27GoxDWaeI80CkCWir9nBG0XDmNS3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715049676; c=relaxed/simple;
	bh=Kp4aqPl9id8liFSMAaCIoSWOlCDyUj/2hBr9Oryhgf8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j8OxMJRE8PrRSq/EAoMGf0Kh3zp8popPkl/9TgTCS1L9Z+Ey/UBcN8Pz2XhBG2TIQ/Bl1L19X8iwKZ7msC/mTDljHZpglylFUWWgD+o/Qtg0bP1vd2k5i2+g7uvpPFzH/gq6QUiSN5VTuyternkFhoeX7ld1rfidu1SiCUnhU90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VYMwC31Zcz4f3nJv;
	Tue,  7 May 2024 10:40:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 331681A0572;
	Tue,  7 May 2024 10:41:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBG7lDlmnqXiLw--.5061S4;
	Tue, 07 May 2024 10:41:09 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	axboe@kernel.dk
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linan666@huaweicloud.com,
	yukuai3@huawei.com,
	yi.zhang@huawei.com,
	houtao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] md: Revert "md: Fix overflow in is_mddev_idle"
Date: Tue,  7 May 2024 10:31:03 +0800
Message-Id: <20240507023103.781816-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBG7lDlmnqXiLw--.5061S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGw45Aw4xtryUWF4kGrW5GFg_yoW5XFyUpF
	Z8Aa43K3yUJrWUuw1DJ3yDua4Fg34FkrWxKrW7C34fXFnIgrn0ga1FgFWYqFyDZFWxCFW2
	q34jgFs09a48trJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VU18pnPUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

This reverts commit 3f9f231236ce7e48780d8a4f1f8cb9fae2df1e4e.

Using 64bit for 'sync_io' is unnecessary from the gendisk side. This
overflow will not cause any functional impact, except for a UBSAN
warning. Solving this overflow requires introducing additional
calculations and checks which are not necessary. So just keep using
32bit for 'sync_io'.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h        | 4 ++--
 include/linux/blkdev.h | 2 +-
 drivers/md/md.c        | 7 +++----
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 029dd0491a36..ca085ecad504 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -51,7 +51,7 @@ struct md_rdev {
 
 	sector_t sectors;		/* Device size (in 512bytes sectors) */
 	struct mddev *mddev;		/* RAID array if running */
-	long long last_events;		/* IO event timestamp */
+	int last_events;		/* IO event timestamp */
 
 	/*
 	 * If meta_bdev is non-NULL, it means that a separate device is
@@ -622,7 +622,7 @@ extern void mddev_unlock(struct mddev *mddev);
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
 {
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
-		atomic64_add(nr_sectors, &bdev->bd_disk->sync_io);
+		atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
 }
 
 static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c854d5a6a6fe..41e995ce4bff 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -174,7 +174,7 @@ struct gendisk {
 	struct list_head slave_bdevs;
 #endif
 	struct timer_rand_state *random;
-	atomic64_t sync_io;		/* RAID */
+	atomic_t sync_io;		/* RAID */
 	struct disk_events *ev;
 
 #ifdef CONFIG_BLK_DEV_ZONED
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 00bbafcd27bb..aff9118ff697 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8577,7 +8577,7 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 {
 	struct md_rdev *rdev;
 	int idle;
-	long long curr_events;
+	int curr_events;
 
 	idle = 1;
 	rcu_read_lock();
@@ -8587,9 +8587,8 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 		if (!init && !blk_queue_io_stat(disk->queue))
 			continue;
 
-		curr_events =
-			(long long)part_stat_read_accum(disk->part0, sectors) -
-			atomic64_read(&disk->sync_io);
+		curr_events = (int)part_stat_read_accum(disk->part0, sectors) -
+			      atomic_read(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
 		 * as sync_io is counted when a request starts, and
 		 * disk_stats is counted when it completes.
-- 
2.39.2

