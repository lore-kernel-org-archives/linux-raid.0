Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BC1235079;
	Sat, 19 Jul 2025 08:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752914255; cv=none; b=Rw8jc2uxIPgS3MvuqeEtA2BW6HB7zAyNgHJzXe4cb3SLRRmZSXzTF6MEK/LlYFwNzy1MrLbFAqefJFW9KWYz3OFSPUafX8OxiqNy/Xr7YpKWaj4wEbHitXVWg0eLlrot8u9qxO3v+vdOCgI3InJgUUkgv29hLsM4KsKfcyiVnOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752914255; c=relaxed/simple;
	bh=ottWTCcLGS6drWcUnMZXO8vksmDHWK8WuyKlRtZzDG4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WsLgNrWlrrP79OgJyCk0z5RzQRdD6LsZauC1beegx4DQJ900qbVEGSYH74d0h+uuq10NOHPGBaRT6HO7OX17lkMJa1AAErvwog0k3os+OVBinwNyaz/THdf73DNo7DOBUL3aQ+PXTcNOVB3YRhKX04XqGoalA/++V0BB/i06JwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bkg5S4rfKzKHMSV;
	Sat, 19 Jul 2025 16:37:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 518171A0BAC;
	Sat, 19 Jul 2025 16:37:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHERJIWXtorEYVAw--.20439S6;
	Sat, 19 Jul 2025 16:37:31 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com,
	martin.petersen@oracle.com,
	hare@suse.de,
	axboe@kernel.dk
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	hch@infradead.org,
	filipe.c.maia@gmail.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 2/3] md: allow configuring logical_block_size
Date: Sat, 19 Jul 2025 16:31:18 +0800
Message-Id: <20250719083119.1068811-3-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250719083119.1068811-1-linan666@huaweicloud.com>
References: <20250719083119.1068811-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHERJIWXtorEYVAw--.20439S6
X-Coremail-Antispam: 1UD129KBjvJXoW3JF4kWr1rXFWUKrWUuw45KFg_yoWDJrWkpa
	97ZFyfu34UXayYy3Z7AFykuF15X3yUKFWqkrya93y0vF9Ivr17GF4fWFy5Xryqqwn8AwnF
	q3WDKrWDu3WIgr7anT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUULq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	w2AFwI0_Jrv_JF1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II
	8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0E
	n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxAqzxv262kKe7AKxVWUXVWUAwCF54CYxV
	CY1x0262kKe7AKxVW8ZVWrXwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pR2LviUUUUU
	=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Previously, raid array used the maximum logical_block_size (LBS) of
all member disks. Adding a larger LBS during disk at runtime could
unexpectedly increase RAID's LBS, risking corruption of existing
partitions.
Simply restricting larger-LBS disks is inflexible. In some scenarios,
only disks with 512 LBS are available currently, but later, disks with
4k LBS may be added to the array.

Making LBS configurable is the best way to solve this scenario.
After this patch, the raid will:
  - stores LBS in disk metadata.
  - add a read-write sysfs 'mdX/logical_block_size'.

Future mdadm should support setting LBS via metadata field during RAID
creation and the new sysfs. Though the kernel allows runtime LBS changes,
users should avoid modifying it after creating partitions or filesystems
to prevent compatibility issues.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h                |  1 +
 include/uapi/linux/raid/md_p.h |  6 ++--
 drivers/md/md-linear.c         |  1 +
 drivers/md/md.c                | 65 ++++++++++++++++++++++++++++++++++
 drivers/md/raid0.c             |  1 +
 drivers/md/raid1.c             |  1 +
 drivers/md/raid10.c            |  1 +
 drivers/md/raid5.c             |  1 +
 8 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index d45a9e6ead80..2af2df153c58 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -431,6 +431,7 @@ struct mddev {
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
index 5d9b08115375..da8babb8da59 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -72,6 +72,7 @@ static int linear_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_hw_sectors = mddev->chunk_sectors;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b1fceda89846..ad8d44493c0f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1382,6 +1382,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
 		mddev->bitmap_info.default_space = 64*2 - (MD_SB_BYTES >> 9);
 		mddev->reshape_backwards = 0;
+		mddev->logical_block_size = sb->logical_block_size;
 
 		if (mddev->minor_version >= 91) {
 			mddev->reshape_position = sb->reshape_position;
@@ -1544,6 +1545,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_sectors << 9;
+	sb->logical_block_size = mddev->logical_block_size;
 
 	if (mddev->bitmap && mddev->bitmap_info.file == NULL)
 		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
@@ -1878,6 +1880,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 		mddev->layout = le32_to_cpu(sb->layout);
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
 		mddev->dev_sectors = le64_to_cpu(sb->size);
+		mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.space = 0;
@@ -2087,6 +2090,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->chunksize = cpu_to_le32(mddev->chunk_sectors);
 	sb->level = cpu_to_le32(mddev->level);
 	sb->layout = cpu_to_le32(mddev->layout);
+	sb->logical_block_size = cpu_to_le32(mddev->logical_block_size);
 	if (test_bit(FailFast, &rdev->flags))
 		sb->devflags |= FailFast1;
 	else
@@ -5689,6 +5693,64 @@ static struct md_sysfs_entry md_serialize_policy =
 __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
        serialize_policy_store);
 
+static int mddev_set_logical_block_size(struct mddev *mddev,
+				unsigned int lbs)
+{
+	int err = 0;
+	struct queue_limits lim;
+
+	if (queue_logical_block_size(mddev->gendisk->queue) >= lbs) {
+		pr_err("%s: incompatible logical_block_size %u, can not set\n",
+		       mdname(mddev), lbs);
+		return -EINVAL;
+	}
+
+	lim = queue_limits_start_update(mddev->gendisk->queue);
+	lim.logical_block_size = lbs;
+	pr_info("%s: logical_block_size is changed, data may be lost\n",
+		mdname(mddev));
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
+	int err = -EBUSY;
+
+	if (mddev->pers)
+		goto unlock;
+
+	err = kstrtouint(buf, 10, &lbs);
+	if (err < 0)
+		return err;
+
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
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
@@ -5721,6 +5783,7 @@ static struct attribute *md_redundancy_attrs[] = {
 	&md_scan_mode.attr,
 	&md_last_scan_mode.attr,
 	&md_mismatches.attr,
+	&md_logical_block_size.attr,
 	&md_sync_min.attr,
 	&md_sync_max.attr,
 	&md_sync_io_depth.attr,
@@ -5828,6 +5891,7 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 		    !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
 			return -EINVAL;
 	}
+	mddev->logical_block_size = queue_logical_block_size(mddev->gendisk->queue);
 
 	return 0;
 }
@@ -6435,6 +6499,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->chunk_sectors = 0;
 	mddev->ctime = mddev->utime = 0;
 	mddev->layout = 0;
+	mddev->logical_block_size = 0;
 	mddev->max_disks = 0;
 	mddev->events = 0;
 	mddev->can_decrease_events = 0;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d8f639f4ae12..c65732b330eb 100644
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
index 19c5a0ce5a40..7e37f1015646 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3218,6 +3218,7 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c22..ead49c752e42 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4003,6 +4003,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ca5b0e8ba707..963b0310bc13 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7727,6 +7727,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
 
 	md_init_stacking_limits(&lim);
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
-- 
2.39.2

