Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F98D193402;
	Sat, 12 Apr 2025 07:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744443535; cv=none; b=RWlNMplcBbXcqOroO7THl331intELYfQ72mJ54aqAZrlyzTc1zkuhvG/z5koYUUt+eA4A73qpLa51rXy0e2iLqgLZitMEijDOi1vDgTnfn/GOZeNBcZjG3ri+wi9b04Ill0uhSfjVkXK/6sKrCYeCzpsyANqUzSFbMEOx+sLuD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744443535; c=relaxed/simple;
	bh=uyS7+6t9VChEqWACrFvOlaqWp0DQsCFhK/H529Sa/JQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a6jIVwWcV9gGGDQyNtvDGey9o17y7Q7WTQ6jf4tXrH0QgHs/poiT1oHKud3y2/s2sqKOWT3EegGVU2xJtiOad9L2BwG14YN7cdNgl1i4RuYuev3deR6XIqjUZT+OXJo/PrtUoSNGmuOXDAKVR40VwMl0ET8gZ97F+8ol64mXcS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZZQQZ6q1Lz4f3jjr;
	Sat, 12 Apr 2025 15:38:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1BADD1A06D7;
	Sat, 12 Apr 2025 15:38:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CFGPpnI5n6JA--.63008S7;
	Sat, 12 Apr 2025 15:38:48 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	xni@redhat.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 3/4] md: fix is_mddev_idle()
Date: Sat, 12 Apr 2025 15:32:01 +0800
Message-Id: <20250412073202.3085138-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2CFGPpnI5n6JA--.63008S7
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr48WrW5Xw1kGFW7ZF1UZFb_yoW7XryDpF
	W3ua43trW8XFWSqr15JFyv9a4Fg34fJ398tFy3J34xZF15Grn0kF4agF4Yv3s8W3ykZFya
	qw45KF4DCa4UJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUbpwZ7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

If sync_speed is above speed_min, then is_mddev_idle() will be called
for each sync IO to check if the array is idle, and inflihgt sync_io
will be limited if the array is not idle.

However, while mkfs.ext4 for a large raid5 array while recovery is in
progress, it's found that sync_speed is already above speed_min while
lots of stripes are used for sync IO, causing long delay for mkfs.ext4.

Root cause is the following checking from is_mddev_idle():

t1: submit sync IO: events1 = completed IO - issued sync IO
t2: submit next sync IO: events2  = completed IO - issued sync IO
if (events2 - events1 > 64)

For consequence, the more sync IO issued, the less likely checking will
pass. And when completed normal IO is more than issued sync IO, the
condition will finally pass and is_mddev_idle() will return false,
however, last_events will be updated hence is_mddev_idle() can only
return false once in a while.

Fix this problem by changing the checking as following:

1) mddev doesn't have normal IO completed;
2) mddev doesn't have normal IO inflight;
3) if any member disks is partition, and all other partitions doesn't
   have IO completed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 78 ++++++++++++++++++++++++++-----------------------
 drivers/md/md.h |  3 +-
 2 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8966c4afc62a..19da93f8912c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8619,50 +8619,54 @@ void md_cluster_stop(struct mddev *mddev)
 	put_cluster_ops(mddev);
 }
 
-static int is_mddev_idle(struct mddev *mddev, int init)
+static bool is_rdev_idle(struct md_rdev *rdev, bool init)
+{
+	unsigned long last_events = rdev->last_events;
+
+	if (!bdev_is_partition(rdev->bdev))
+		return true;
+
+	rdev->last_events = part_stat_read_accum(rdev->bdev->bd_disk->part0,
+						 sectors) -
+			    part_stat_read_accum(rdev->bdev, sectors);
+
+	if (!init && rdev->last_events > last_events)
+		return false;
+
+	return true;
+}
+
+/*
+ * mddev is idle if following conditions are match since last check:
+ * 1) mddev doesn't have normal IO completed;
+ * 2) mddev doesn't have inflight normal IO;
+ * 3) if any member disk is partition, and other partitions doesn't have IO
+ *    completed;
+ *
+ * Noted this checking rely on IO accounting is enabled.
+ */
+static bool is_mddev_idle(struct mddev *mddev, int init)
 {
 	struct md_rdev *rdev;
-	int idle;
-	int curr_events;
+	bool idle = true;
 
-	idle = 1;
-	rcu_read_lock();
-	rdev_for_each_rcu(rdev, mddev) {
-		struct gendisk *disk = rdev->bdev->bd_disk;
+	if (!mddev_is_dm(mddev)) {
+		unsigned long last_events = mddev->last_events;
 
-		if (!init && !blk_queue_io_stat(disk->queue))
-			continue;
+		mddev->last_events = part_stat_read_accum(mddev->gendisk->part0,
+							  sectors);
 
-		curr_events = (int)part_stat_read_accum(disk->part0, sectors) -
-			      atomic_read(&disk->sync_io);
-		/* sync IO will cause sync_io to increase before the disk_stats
-		 * as sync_io is counted when a request starts, and
-		 * disk_stats is counted when it completes.
-		 * So resync activity will cause curr_events to be smaller than
-		 * when there was no such activity.
-		 * non-sync IO will cause disk_stat to increase without
-		 * increasing sync_io so curr_events will (eventually)
-		 * be larger than it was before.  Once it becomes
-		 * substantially larger, the test below will cause
-		 * the array to appear non-idle, and resync will slow
-		 * down.
-		 * If there is a lot of outstanding resync activity when
-		 * we set last_event to curr_events, then all that activity
-		 * completing might cause the array to appear non-idle
-		 * and resync will be slowed down even though there might
-		 * not have been non-resync activity.  This will only
-		 * happen once though.  'last_events' will soon reflect
-		 * the state where there is little or no outstanding
-		 * resync requests, and further resync activity will
-		 * always make curr_events less than last_events.
-		 *
-		 */
-		if (init || curr_events - rdev->last_events > 64) {
-			rdev->last_events = curr_events;
-			idle = 0;
-		}
+		if (!init && (mddev->last_events > last_events ||
+			      part_in_flight(mddev->gendisk->part0)))
+			idle = false;
 	}
+
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev)
+		if (!is_rdev_idle(rdev, init))
+			idle = false;
 	rcu_read_unlock();
+
 	return idle;
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 63be622467c6..95cf11c4abc6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -132,7 +132,7 @@ struct md_rdev {
 
 	sector_t sectors;		/* Device size (in 512bytes sectors) */
 	struct mddev *mddev;		/* RAID array if running */
-	int last_events;		/* IO event timestamp */
+	unsigned long last_events;	/* IO event timestamp */
 
 	/*
 	 * If meta_bdev is non-NULL, it means that a separate device is
@@ -519,6 +519,7 @@ struct mddev {
 							 * adding a spare
 							 */
 
+	unsigned long			last_events;	/* IO event timestamp */
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
-- 
2.39.2

