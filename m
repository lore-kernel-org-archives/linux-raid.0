Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F368299957;
	Mon, 25 Aug 2025 08:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756109277; cv=none; b=gJOTXlV5BC/c2PIqbP4RaERF1my2g3u5EydFGnf3w1vGWtQr3Y/vjndZ3va4N+v8MMRmCLo5SSnJoxGgs643ROJEQXMgHbJIWJVn5EkHJohaeSahNSOVruQbpw5SI3TcXScN9LkgrY7dYMEietugQwhvEQv+xQdzXi8LLX6SmuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756109277; c=relaxed/simple;
	bh=1sfk9x/xuDEIQJEYPCQN8h2zDEbxH45eglDqyNBWzU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rIcqy/Mr0Pwl46HBC0Wtrp19l7p60wTMlFXtZsSJIdLcgpi2RIsEyu2RFZ4P/Dw6LCmrCqMsrmSkD4+Mzsb7RJOxRsSmlUJgW7cprTYR6fcn3wL+fHlQAVGXx6TZ6vMDhIrNdTokj9aZq+mzLJG90UgYwW1wY4AZ3nCWSV0VZbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c9NhB0tf2zYQw4x;
	Mon, 25 Aug 2025 16:07:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A440D1A092F;
	Mon, 25 Aug 2025 16:07:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncIzVGaxosLjpAA--.42805S6;
	Mon, 25 Aug 2025 16:07:52 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	hch@infradead.org,
	filipe.c.maia@gmail.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 2/2] md: allow configuring logical_block_size
Date: Mon, 25 Aug 2025 15:59:24 +0800
Message-Id: <20250825075924.2696723-3-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250825075924.2696723-1-linan666@huaweicloud.com>
References: <20250825075924.2696723-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIzVGaxosLjpAA--.42805S6
X-Coremail-Antispam: 1UD129KBjvJXoW3Kw45try3AFW3CF1rur1DGFg_yoWDAr47pa
	97ZFyfu34UXayYyan7AFyku3WrX3yUGFWqkryag3y0vr9Ivr17GF4fWFy5Xryqqwn8AwnF
	q3WDKrWDu3WIgF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	ACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
	4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
	6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYa0mUUUUU
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

Note that many RAID paths rely on PAGE_SIZE alignment, including for
metadata I/O. A logical_block_size larger than PAGE_SIZE will result in
metadata reads/writes failures. So this config should be prevented.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h                |  1 +
 include/uapi/linux/raid/md_p.h |  6 ++-
 drivers/md/md-linear.c         |  1 +
 drivers/md/md.c                | 75 ++++++++++++++++++++++++++++++++++
 drivers/md/raid0.c             |  1 +
 drivers/md/raid1.c             |  1 +
 drivers/md/raid10.c            |  1 +
 drivers/md/raid5.c             |  1 +
 8 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1979c2d4fe89..0202f6feedea 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -432,6 +432,7 @@ struct mddev {
 	sector_t			array_sectors; /* exported array size */
 	int				external_size; /* size managed
 							* externally */
+	unsigned int			logical_block_size;
 	__u64				events;
 	/* If the last 'event' was simply a clean->dirty transition, and
 	 * we didn't write it to the spares, then it is safe and simple
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index ac74133a4768..190d493044a8 100644
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
index 206434591b97..e78f80d39271 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1467,6 +1467,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
 		mddev->bitmap_info.default_space = 64*2 - (MD_SB_BYTES >> 9);
 		mddev->reshape_backwards = 0;
+		mddev->logical_block_size = sb->logical_block_size;
 
 		if (mddev->minor_version >= 91) {
 			mddev->reshape_position = sb->reshape_position;
@@ -1629,6 +1630,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_sectors << 9;
+	sb->logical_block_size = mddev->logical_block_size;
 
 	if (mddev->bitmap && mddev->bitmap_info.file == NULL)
 		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
@@ -1963,6 +1965,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 		mddev->layout = le32_to_cpu(sb->layout);
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
 		mddev->dev_sectors = le64_to_cpu(sb->size);
+		mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.space = 0;
@@ -2172,6 +2175,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->chunksize = cpu_to_le32(mddev->chunk_sectors);
 	sb->level = cpu_to_le32(mddev->level);
 	sb->layout = cpu_to_le32(mddev->layout);
+	sb->logical_block_size = cpu_to_le32(mddev->logical_block_size);
 	if (test_bit(FailFast, &rdev->flags))
 		sb->devflags |= FailFast1;
 	else
@@ -5900,6 +5904,64 @@ static struct md_sysfs_entry md_serialize_policy =
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
@@ -5933,6 +5995,7 @@ static struct attribute *md_redundancy_attrs[] = {
 	&md_scan_mode.attr,
 	&md_last_scan_mode.attr,
 	&md_mismatches.attr,
+	&md_logical_block_size.attr,
 	&md_sync_min.attr,
 	&md_sync_max.attr,
 	&md_sync_io_depth.attr,
@@ -6052,6 +6115,17 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 			return -EINVAL;
 	}
 
+	/*
+	 * Before RAID adding folio support, the logical_block_size
+	 * should be smaller than the page size.
+	 */
+	if (lim->logical_block_size > PAGE_SIZE) {
+		pr_err("%s: logical_block_size must not larger than PAGE_SIZE\n",
+			mdname(mddev));
+		return -EINVAL;
+	}
+	mddev->logical_block_size = lim->logical_block_size;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
@@ -6690,6 +6764,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->chunk_sectors = 0;
 	mddev->ctime = mddev->utime = 0;
 	mddev->layout = 0;
+	mddev->logical_block_size = 0;
 	mddev->max_disks = 0;
 	mddev->events = 0;
 	mddev->can_decrease_events = 0;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f1d8811a542a..705889a09fc1 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -382,6 +382,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_hw_sectors = mddev->chunk_sectors;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
 	lim.chunk_sectors = mddev->chunk_sectors;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0e792b9bfff8..3e422854cafb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3224,6 +3224,7 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2411399a7352..2dfff3f9ec8e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4005,6 +4005,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2121f0ff5e30..c6bd6d2e4438 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7733,6 +7733,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
 
 	md_init_stacking_limits(&lim);
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
-- 
2.39.2

