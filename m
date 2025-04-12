Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2335175D39;
	Sat, 12 Apr 2025 07:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744443534; cv=none; b=Zmx4Db/Ss1N9uFjIbAOfB0fCKNYc62PoPm/djkUcaadEMTgAHn49ZYkQihVfpM5OZnYAetURaMbsAhUs3B3ArV4/URo/4jqW/lwMh4fL5aj/Vv4ZlXfXJpMoc2k3+2jgGDCApxCZzOqlckVbxbyi4CLwfi/26kEt1WkBw/yZQVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744443534; c=relaxed/simple;
	bh=wqUsknWX45ds/7i1Cde5dLEavp4rEqUzhD5K5rpiwC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GzDWJdfFwF12MqArW9x1oqJLNlRR3404mYjd8S0eDCVHvXcu/bsSo8lGSaEYa4LjdOK3VIEM5Z6fj610WGZnvNMvEO4E7sffCElbRuBrbtjY81MnWM4SPf3lamG3Lw9J2+yhQmQ5YeMIUAeBVA0y+LDfiPqErz0dQNJocmGImGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZZQQZ3XzZz4f3jtT;
	Sat, 12 Apr 2025 15:38:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A1C731A111E;
	Sat, 12 Apr 2025 15:38:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CFGPpnI5n6JA--.63008S6;
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
Subject: [PATCH 2/4] md: add a new api sync_io_depth
Date: Sat, 12 Apr 2025 15:32:00 +0800
Message-Id: <20250412073202.3085138-3-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnC2CFGPpnI5n6JA--.63008S6
X-Coremail-Antispam: 1UD129KBjvJXoWxKFW7uw47JF4UKr4UAF4ruFg_yoWxCF48pa
	y2yFy3Wr4UZFZxXw43JFsxC3WFqr4fK3yDt3y7Gw1xJF13Wr9rGF1SgFW5XF9rWa4fCrnx
	XF1UJFZ8ua1xtr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
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
	nUUI43ZEXa7VUj5Ef7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently if sync speed is above speed_min and below speed_max,
md_do_sync() will wait for all sync IOs to be done before issuing new
sync IO, means sync IO depth is limited to just 1.

This limit is too low, in order to prevent sync speed drop conspicuously
after fixing is_mddev_idle() in the next patch, add a new api for
limiting sync IO depth, the default value is 32.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 103 +++++++++++++++++++++++++++++++++++++++---------
 drivers/md/md.h |   1 +
 2 files changed, 85 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 438e71e45c16..8966c4afc62a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -111,32 +111,42 @@ static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
 /* Default safemode delay: 200 msec */
 #define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
 /*
- * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
- * is 1000 KB/sec, so the extra system load does not show up that much.
- * Increase it if you want to have more _guaranteed_ speed. Note that
- * the RAID driver will use the maximum available bandwidth if the IO
- * subsystem is idle. There is also an 'absolute maximum' reconstruction
- * speed limit - in case reconstruction slows down your system despite
- * idle IO detection.
+ * Background sync IO speed control:
  *
- * you can change it via /proc/sys/dev/raid/speed_limit_min and _max.
- * or /sys/block/mdX/md/sync_speed_{min,max}
+ * - below speed min:
+ *   no limit;
+ * - above speed min and below speed max:
+ *   a) if mddev is idle, then no limit;
+ *   b) if mddev is busy handling normal IO, then limit inflight sync IO
+ *   to sync_io_depth;
+ * - above speed max:
+ *   sync IO can't be issued;
+ *
+ * Following configurations can be changed via /proc/sys/dev/raid/ for system
+ * or /sys/block/mdX/md/ for one array.
  */
-
 static int sysctl_speed_limit_min = 1000;
 static int sysctl_speed_limit_max = 200000;
-static inline int speed_min(struct mddev *mddev)
+static int sysctl_sync_io_depth = 32;
+
+static int speed_min(struct mddev *mddev)
 {
 	return mddev->sync_speed_min ?
 		mddev->sync_speed_min : sysctl_speed_limit_min;
 }
 
-static inline int speed_max(struct mddev *mddev)
+static int speed_max(struct mddev *mddev)
 {
 	return mddev->sync_speed_max ?
 		mddev->sync_speed_max : sysctl_speed_limit_max;
 }
 
+static int sync_io_depth(struct mddev *mddev)
+{
+	return mddev->sync_io_depth ?
+		mddev->sync_io_depth : sysctl_sync_io_depth;
+}
+
 static void rdev_uninit_serial(struct md_rdev *rdev)
 {
 	if (!test_and_clear_bit(CollisionCheck, &rdev->flags))
@@ -293,14 +303,21 @@ static const struct ctl_table raid_table[] = {
 		.procname	= "speed_limit_min",
 		.data		= &sysctl_speed_limit_min,
 		.maxlen		= sizeof(int),
-		.mode		= S_IRUGO|S_IWUSR,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "speed_limit_max",
 		.data		= &sysctl_speed_limit_max,
 		.maxlen		= sizeof(int),
-		.mode		= S_IRUGO|S_IWUSR,
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "sync_io_depth",
+		.data		= &sysctl_sync_io_depth,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 };
@@ -5091,7 +5108,7 @@ static ssize_t
 sync_min_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_min(mddev),
-		       mddev->sync_speed_min ? "local": "system");
+		       mddev->sync_speed_min ? "local" : "system");
 }
 
 static ssize_t
@@ -5100,7 +5117,7 @@ sync_min_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned int min;
 	int rv;
 
-	if (strncmp(buf, "system", 6)==0) {
+	if (strncmp(buf, "system", 6) == 0) {
 		min = 0;
 	} else {
 		rv = kstrtouint(buf, 10, &min);
@@ -5120,7 +5137,7 @@ static ssize_t
 sync_max_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_max(mddev),
-		       mddev->sync_speed_max ? "local": "system");
+		       mddev->sync_speed_max ? "local" : "system");
 }
 
 static ssize_t
@@ -5129,7 +5146,7 @@ sync_max_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned int max;
 	int rv;
 
-	if (strncmp(buf, "system", 6)==0) {
+	if (strncmp(buf, "system", 6) == 0) {
 		max = 0;
 	} else {
 		rv = kstrtouint(buf, 10, &max);
@@ -5145,6 +5162,35 @@ sync_max_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_sync_max =
 __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
 
+static ssize_t
+sync_io_depth_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%d (%s)\n", sync_io_depth(mddev),
+		       mddev->sync_io_depth ? "local" : "system");
+}
+
+static ssize_t
+sync_io_depth_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	unsigned int max;
+	int rv;
+
+	if (strncmp(buf, "system", 6) == 0) {
+		max = 0;
+	} else {
+		rv = kstrtouint(buf, 10, &max);
+		if (rv < 0)
+			return rv;
+		if (max == 0)
+			return -EINVAL;
+	}
+	mddev->sync_io_depth = max;
+	return len;
+}
+
+static struct md_sysfs_entry md_sync_io_depth =
+__ATTR_RW(sync_io_depth);
+
 static ssize_t
 degraded_show(struct mddev *mddev, char *page)
 {
@@ -5671,6 +5717,7 @@ static struct attribute *md_redundancy_attrs[] = {
 	&md_mismatches.attr,
 	&md_sync_min.attr,
 	&md_sync_max.attr,
+	&md_sync_io_depth.attr,
 	&md_sync_speed.attr,
 	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
@@ -8927,6 +8974,23 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 	}
 }
 
+static bool sync_io_within_limit(struct mddev *mddev)
+{
+	int io_sectors;
+
+	/*
+	 * For raid456, sync IO is stripe(4k) per IO, for other levels, it's
+	 * RESYNC_PAGES(64k) per IO.
+	 */
+	if (mddev->level == 4 || mddev->level == 5 || mddev->level == 6)
+		io_sectors = 8;
+	else
+		io_sectors = 128;
+
+	return atomic_read(&mddev->recovery_active) <
+		io_sectors * sync_io_depth(mddev);
+}
+
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 #define UPDATE_FREQUENCY (5*60*HZ)
@@ -9195,7 +9259,8 @@ void md_do_sync(struct md_thread *thread)
 				msleep(500);
 				goto repeat;
 			}
-			if (!is_mddev_idle(mddev, 0)) {
+			if (!sync_io_within_limit(mddev) &&
+			    !is_mddev_idle(mddev, 0)) {
 				/*
 				 * Give other IO more of a chance.
 				 * The faster the devices, the less we wait.
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1cf00a04bcdd..63be622467c6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -483,6 +483,7 @@ struct mddev {
 	/* if zero, use the system-wide default */
 	int				sync_speed_min;
 	int				sync_speed_max;
+	int				sync_io_depth;
 
 	/* resync even though the same disks are shared among md-devices */
 	int				parallel_resync;
-- 
2.39.2

