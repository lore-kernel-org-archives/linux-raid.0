Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCBB20298B;
	Tue,  4 Mar 2025 12:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091030; cv=none; b=RF81Ji5e9WIAHg0OCf06jtnnZJb1V0A4FMwGsCt2CWx+ZGAk0r2YW4jjSJPK0BKSoLmlcycRBssc/FOmJ6rIzv4uh7X6p0qeyHPcX9162Lw3nU9AMWlgF0Zxc7a/XCiZK7Kp7akQVlYqIQjpeCe/xf/hNeTxGgEX+4G5ZkDTvkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091030; c=relaxed/simple;
	bh=WaZuf6sQ899CeExjC1r3ZPhnq4HH+D5ogsFML90W6Ko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n+AiM+0/YjvYbEzwj+x3y5PaN68jVfJ615pSKzfFTq4A2tYPSGv7YV/IsfzPTNhtSy6ff1MTDeyCr+7R3yWLitTA7AS/2p87gEu9Ms+f0dyfEz3ZszGIvqmm+nhA3rQ/Rz9HLp/uS/FUoRzWcEDr52tvfZFecJF15bNsRaZ7hXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z6ZbG38Bdz4f3jHy;
	Tue,  4 Mar 2025 20:23:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 808DD1A0DEA;
	Tue,  4 Mar 2025 20:23:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB321_O8MZnFO8VFg--.52907S6;
	Tue, 04 Mar 2025 20:23:44 +0800 (CST)
From: linan666@huaweicloud.com
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	hare@suse.de,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	zhangxiaoxu5@huawei.com,
	wanghai38@huawei.com
Subject: [PATCH 2/4] md: make raid logical_block_size configurable
Date: Tue,  4 Mar 2025 20:19:16 +0800
Message-Id: <20250304121918.3159388-3-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250304121918.3159388-1-linan666@huaweicloud.com>
References: <20250304121918.3159388-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321_O8MZnFO8VFg--.52907S6
X-Coremail-Antispam: 1UD129KBjvJXoW3urWDGryxCF43AFWrJw4rGrg_yoWDCFyfpa
	97ZFyS934UXayFy3ZrAFykuF15X3y8KFWqkryag3y0vr9Ivr17GF4fWFy5Wryjqwn8AwnF
	q3WDKrWDu3WIgF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	ACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
	4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
	6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoApeUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Previously, raid array used the maximum logical_block_size (LBS) from
all member disks. Adding disks with larger LBS during operation could
unexpectedly increase RAID's LBS, risking existing partition data loss.
Simply restricting larger-LBS disks is inflexible. In some scenarios,
only disks with 512 LBS are available currently, but later, disks with
4k LBS may be added to the array.

Making LBS configurable is the best way to solve this scenario.
After this patch, the raid will:
  - handle LBS fields in disk metadata read/write operations.
  - introduce a new sysfs 'md/logical_block_size' for LBS configuration.

Future mdadm should support setting LBS via metadata field during RAID
creation and the new sysfs. Though the kernel allows runtime LBS changes,
users should avoid modifying it after creating partitions or filesystems
to prevent compatibility issues.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h                |  1 +
 include/uapi/linux/raid/md_p.h |  6 ++-
 drivers/md/md-linear.c         |  1 +
 drivers/md/md.c                | 74 ++++++++++++++++++++++++++++++++++
 drivers/md/raid0.c             |  1 +
 drivers/md/raid1.c             |  1 +
 drivers/md/raid10.c            |  1 +
 drivers/md/raid5.c             |  1 +
 8 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index def808064ad8..96bd10998ae0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -403,6 +403,7 @@ struct mddev {
 	sector_t			array_sectors; /* exported array size */
 	int				external_size; /* size managed
 							* externally */
+	unsigned int			logical_block_size;
 	__u64				events;
 	/* If the last 'event' was simply a clean->dirty transition, and
 	 * we didn't write it to the spares, then it is safe and simple
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index ff47b6f0ba0f..ad1c84e772ba 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -180,7 +180,8 @@ typedef struct mdp_superblock_s {
 	__u32 delta_disks;	/* 15 change in number of raid_disks	      */
 	__u32 new_layout;	/* 16 new layout			      */
 	__u32 new_chunk;	/* 17 new chunk size (bytes)		      */
-	__u32 gstate_sreserved[MD_SB_GENERIC_STATE_WORDS - 18];
+	__u32 logical_block_size;	/* same as q->limits->logical_block_size */
+	__u32 gstate_sreserved[MD_SB_GENERIC_STATE_WORDS - 19];
 
 	/*
 	 * Personality information
@@ -291,7 +292,8 @@ struct mdp_superblock_1 {
 	__le64	resync_offset;	/* data before this offset (from data_offset) known to be in sync */
 	__le32	sb_csum;	/* checksum up to devs[max_dev] */
 	__le32	max_dev;	/* size of devs[] array to consider */
-	__u8	pad3[64-32];	/* set to 0 when writing */
+	__le32  logical_block_size;	/* same as q->limits->logical_block_size */
+	__u8	pad3[64-36];	/* set to 0 when writing */
 
 	/* device state information. Indexed by dev_number.
 	 * 2 bytes per device
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 369aed044b40..c197a90a6bd5 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -73,6 +73,7 @@ static int linear_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_hw_sectors = mddev->chunk_sectors;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 827646b3eb59..cf3d8ff807a7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1335,6 +1335,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
 		mddev->bitmap_info.default_space = 64*2 - (MD_SB_BYTES >> 9);
 		mddev->reshape_backwards = 0;
+		mddev->logical_block_size = sb->logical_block_size;
 
 		if (mddev->minor_version >= 91) {
 			mddev->reshape_position = sb->reshape_position;
@@ -1497,6 +1498,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_sectors << 9;
+	sb->logical_block_size = mddev->logical_block_size;
 
 	if (mddev->bitmap && mddev->bitmap_info.file == NULL)
 		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
@@ -1831,6 +1833,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 		mddev->layout = le32_to_cpu(sb->layout);
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
 		mddev->dev_sectors = le64_to_cpu(sb->size);
+		mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.space = 0;
@@ -2040,6 +2043,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->chunksize = cpu_to_le32(mddev->chunk_sectors);
 	sb->level = cpu_to_le32(mddev->level);
 	sb->layout = cpu_to_le32(mddev->layout);
+	sb->logical_block_size = cpu_to_le32(mddev->logical_block_size);
 	if (test_bit(FailFast, &rdev->flags))
 		sb->devflags |= FailFast1;
 	else
@@ -5630,6 +5634,65 @@ static struct md_sysfs_entry md_serialize_policy =
 __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
        serialize_policy_store);
 
+static int mddev_set_logical_block_size(struct mddev *mddev,
+				unsigned int lbs)
+{
+	int err = 0;
+	struct queue_limits lim;
+
+	if (blk_validate_block_size(lbs) ||
+	    queue_logical_block_size(mddev->gendisk->queue) >= lbs) {
+		pr_err("%s: incompatible logical_block_size, can not set\n",
+		       mdname(mddev));
+		return -EINVAL;
+	}
+
+	lim = queue_limits_start_update(mddev->gendisk->queue);
+	if (blk_set_block_size(&lim, lbs, 0))
+		pr_warn("%s: logical_block_size changes, data may be lost\n",
+		       mdname(mddev));
+	err = queue_limits_commit_update(mddev->gendisk->queue, &lim);
+	if (err)
+		return err;
+
+	mddev->logical_block_size = lbs;
+	md_update_sb(mddev, 1);
+
+	return 0;
+}
+
+static ssize_t
+lbs_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%u\n", mddev->logical_block_size);
+}
+
+static ssize_t
+lbs_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	unsigned int lbs;
+	int err;
+
+	err = kstrtouint(buf, 10, &lbs);
+	if (err < 0)
+		return err;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+	err = -EBUSY;
+	if (mddev->pers)
+		goto unlock;
+
+	err = mddev_set_logical_block_size(mddev, lbs);
+
+unlock:
+	mddev_unlock(mddev);
+	return err ?: len;
+}
+
+static struct md_sysfs_entry md_logical_block_size =
+__ATTR(logical_block_size, S_IRUGO|S_IWUSR, lbs_show, lbs_store);
 
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
@@ -5662,6 +5725,7 @@ static struct attribute *md_redundancy_attrs[] = {
 	&md_scan_mode.attr,
 	&md_last_scan_mode.attr,
 	&md_mismatches.attr,
+	&md_logical_block_size.attr,
 	&md_sync_min.attr,
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
@@ -5760,6 +5824,7 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 		unsigned int flags)
 {
 	struct md_rdev *rdev;
+	unsigned int lbs = mddev->logical_block_size;
 
 	rdev_for_each(rdev, mddev) {
 		queue_limits_stack_bdev(lim, rdev->bdev, rdev->data_offset,
@@ -5768,6 +5833,14 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 		    !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
 			return -EINVAL;
 	}
+	if (lbs) {
+		if (lbs != queue_logical_block_size(mddev->gendisk->queue))
+			pr_warn("%s: logical_block_size is changed, before: %u, now: %u\n",
+			mdname(mddev), lbs,
+			queue_logical_block_size(mddev->gendisk->queue));
+	} else {
+		mddev->logical_block_size = queue_logical_block_size(mddev->gendisk->queue);
+	}
 
 	return 0;
 }
@@ -6377,6 +6450,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->chunk_sectors = 0;
 	mddev->ctime = mddev->utime = 0;
 	mddev->layout = 0;
+	mddev->logical_block_size = 0;
 	mddev->max_disks = 0;
 	mddev->events = 0;
 	mddev->can_decrease_events = 0;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 70bcc3cdf2cd..83e330e30fc2 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -382,6 +382,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_hw_sectors = mddev->chunk_sectors;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 10ea3af40991..5d8a718af9b0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3217,6 +3217,7 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 15b9ae5bf84d..085188f85785 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4016,6 +4016,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c79429acc64..b11e0ae25c2f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7736,6 +7736,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
 
 	md_init_stacking_limits(&lim);
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
-- 
2.39.2

