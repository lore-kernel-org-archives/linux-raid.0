Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55059286D6D;
	Fri, 26 Sep 2025 07:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758871748; cv=none; b=gfolAmg2nB3jVlr3LvWYKDhjYSyJwTAxKXRTBehx6hmg488tGyGTf/Uq99DVCM6RtpBp4x/Bz1nS1VnUtz72c/TOk7t39+JSd0SnFhN4jGXadpDyVEvN1IFbdUNPls0hS+wPHFF+jXeAx7jtGtBmG0zkccJNHFY2hO0xSmKwPww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758871748; c=relaxed/simple;
	bh=sJ5pLbToQZxoB2XWMOtsGQJQaDtxFxyMWOY4B6SrwdU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VmMD9j4j1VzG41bxwiW195QVW/4VTl4h0or5l2phMiNL3lWWgYHyzPOpceNbzM0YDWUZ/pAhzNcNQzq8evL9WbpZXo1gohzzEatsEwMG7VjC3AK59FZA3Wp1/uIX/5J3zfgENxWjpCUTUzKu5+gYY7V7MQvP/C7fZpnpKOhwQF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cY2JM6ZMhzKHNFn;
	Fri, 26 Sep 2025 15:28:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 33A9A1A1434;
	Fri, 26 Sep 2025 15:29:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgA3+mG6QNZoxjF0Aw--.29022S4;
	Fri, 26 Sep 2025 15:29:00 +0800 (CST)
From: linan666@huaweicloud.com
To: corbet@lwn.net,
	song@kernel.org,
	yukuai3@huawei.com,
	linan122@huawei.com,
	hare@suse.de,
	xni@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	martin.petersen@oracle.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v6] md: allow configuring logical block size
Date: Fri, 26 Sep 2025 15:18:37 +0800
Message-Id: <20250926071837.766910-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3+mG6QNZoxjF0Aw--.29022S4
X-Coremail-Antispam: 1UD129KBjvJXoWfGF4Dtw1Dtr13WF4DJFWfAFb_yoWkXF4Dpa
	97ZFyfZ34UXayaya97AFykuF15X3yUGFWqkry7W3y0vr9xAr17WF4fGFy5Xryqqwn8A3sF
	q3WDKrWDu3WIgF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r
	1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbfWrJUU
	UUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Previously, raid array used the maximum logical block size (LBS)
of all member disks. Adding a larger LBS disk at runtime could
unexpectedly increase RAID's LBS, risking corruption of existing
partitions. This can be reproduced by:

```
  # LBS of sd[de] is 512 bytes, sdf is 4096 bytes.
  mdadm -CRq /dev/md0 -l1 -n3 /dev/sd[de] missing --assume-clean

  # LBS is 512
  cat /sys/block/md0/queue/logical_block_size

  # create partition md0p1
  parted -s /dev/md0 mklabel gpt mkpart primary 1MiB 100%
  lsblk | grep md0p1

  # LBS becomes 4096 after adding sdf
  mdadm --add -q /dev/md0 /dev/sdf
  cat /sys/block/md0/queue/logical_block_size

  # partition lost
  partprobe /dev/md0
  lsblk | grep md0p1
```

Simply restricting larger-LBS disks is inflexible. In some scenarios,
only disks with 512 bytes LBS are available currently, but later, disks
with 4KB LBS may be added to the array.

Making LBS configurable is the best way to solve this scenario.
After this patch, the raid will:
  - store LBS in disk metadata
  - add a read-write sysfs 'mdX/logical_block_size'

Future mdadm should support setting LBS via metadata field during RAID
creation and the new sysfs. Though the kernel allows runtime LBS changes,
users should avoid modifying it after creating partitions or filesystems
to prevent compatibility issues.

Only 1.x metadata supports configurable LBS. 0.90 metadata inits all
fields to default values at auto-detect. Supporting 0.90 would require
more extensive changes and no such use case has been observed.

Note that many RAID paths rely on PAGE_SIZE alignment, including for
metadata I/O. A larger LBS than PAGE_SIZE will result in metadata
read/write failures. So this config should be prevented.

Signed-off-by: Li Nan <linan122@huawei.com>
---
v6:
 - Improve print message
 - s/RAID5/RAID456/g

v5: in patch2:
    Fix typo. Add reproducer in log.

v4:
 patch 1: add fix tag.
 patch 2:
 - add documentation for sysfs.
 - only support metadata format 1.x.
 - do not call md_update_sb when writing sysfs. mddev->pers is NULL here.
 - return directly before hold lock in lbs_store.

v3:
 - logical_block_size must not exceed PAGE_SIZE for bio device.
 - Assign lim to mddev rather than to gendisk in mddev_stack_rdev_limits().
 - Remove the patch that modifies the return value.

v2: No new exported interfaces are introduced.

 Documentation/admin-guide/md.rst |  7 +++
 drivers/md/md.h                  |  1 +
 include/uapi/linux/raid/md_p.h   |  3 +-
 drivers/md/md-linear.c           |  1 +
 drivers/md/md.c                  | 75 ++++++++++++++++++++++++++++++++
 drivers/md/raid0.c               |  1 +
 drivers/md/raid1.c               |  1 +
 drivers/md/raid10.c              |  1 +
 drivers/md/raid5.c               |  1 +
 9 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 1c2eacc94758..493071158d8e 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -238,6 +238,13 @@ All md devices contain:
      the number of devices in a raid4/5/6, or to support external
      metadata formats which mandate such clipping.
 
+  logical_block_size
+     Configures the array's logical block size in bytes. This attribute
+     is only supported for RAID1, RAID456, RAID10 with 1.x meta. The value
+     should be written before starting the array. The final array LBS
+     will use the max value between this configuration and all rdev's LBS.
+     Note that LBS cannot exceed PAGE_SIZE.
+
   reshape_position
      This is either ``none`` or a sector number within the devices of
      the array where ``reshape`` is up to.  If this is set, the three
diff --git a/drivers/md/md.h b/drivers/md/md.h
index afb25f727409..b0147b98c8d3 100644
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
index ac74133a4768..310068bb2a1d 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -291,7 +291,8 @@ struct mdp_superblock_1 {
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
index 40f56183c744..91fe955cbd08 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1963,6 +1963,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 		mddev->layout = le32_to_cpu(sb->layout);
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
 		mddev->dev_sectors = le64_to_cpu(sb->size);
+		mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.space = 0;
@@ -2172,6 +2173,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->chunksize = cpu_to_le32(mddev->chunk_sectors);
 	sb->level = cpu_to_le32(mddev->level);
 	sb->layout = cpu_to_le32(mddev->layout);
+	sb->logical_block_size = cpu_to_le32(mddev->logical_block_size);
 	if (test_bit(FailFast, &rdev->flags))
 		sb->devflags |= FailFast1;
 	else
@@ -5900,6 +5902,66 @@ static struct md_sysfs_entry md_serialize_policy =
 __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
        serialize_policy_store);
 
+static int mddev_set_logical_block_size(struct mddev *mddev,
+				unsigned int lbs)
+{
+	int err = 0;
+	struct queue_limits lim;
+
+	if (queue_logical_block_size(mddev->gendisk->queue) >= lbs) {
+		pr_err("%s: Cannot set LBS smaller than mddev LBS %u\n",
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
+	/* Only 1.x meta supports configurable LBS */
+	if (mddev->major_version == 0)
+		return -EINVAL;
+
+	if (mddev->pers)
+		return -EBUSY;
+
+	err = kstrtouint(buf, 10, &lbs);
+	if (err < 0)
+		return -EINVAL;
+
+	err = mddev_lock(mddev);
+	if (err)
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
index d0f6afd2f988..de0c843067dc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3223,6 +3223,7 @@ static int raid1_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c3cfbb0347e7..68c8148386b0 100644
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
index c32ffd9cffce..ff0daa22df65 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7747,6 +7747,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
 
 	md_init_stacking_limits(&lim);
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
-- 
2.39.2

