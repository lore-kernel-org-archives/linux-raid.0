Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F2E2E06EF;
	Mon, 27 Oct 2025 07:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761550636; cv=none; b=ulEmId5Nsb5F0CmfZgxRfSXGP5ESQnv+n5EFHE5PG76EUmYAEkkzCHXEQM84oBrJPlSrMGS2OausT/PIaCJSbdZHoE91JEW4ocLZ7e88AWO69IXK9+CD6cfPVMAjdUpaj3+Zg+yRsnZ7swndmtocjng3mdk1jZ8I1xRhfgcvND0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761550636; c=relaxed/simple;
	bh=xTTlvCaCtD+dP4ZcwpmAaSgOGSM5Vw3vABlL+ftz62M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aypc1sy9nH7WMCTZlsCSW+2DaHOvfBt/tpcu/Dvn8DPCS0jGwZmsk8Fdug3Ojq0P/NIJj+UVJARJI6WFFIn+YPuheLrYI7zT8Qoc0c4vXIDoohpANh3KAd9jaq57KRH0JzcUGUjn7rkS/ncZGQ8kC36546A9KDMSRVeKIK8XUB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=PgxFvp3m; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="PgxFvp3m"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9zNsStWWRJN2cY0FDEHLW+dBeSJEzqmQM4wkXH5m0JU=;
	b=PgxFvp3m3ySd58H8ykb3Og4NgL6cJ1hTvjMICX1K5eWILVcAg+t77hUxh9R+mjbxgLZFRuyur
	TUDadCmq2cPKxt5D4x/NNnxpqznPLph3e/G6jFtOjEUk3FI9q93+/d0oIYiWU43UAnewjfEUX2C
	wJ99Lxzf99EGHrD9sy19hFc=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cw5121v0WzmVBx;
	Mon, 27 Oct 2025 15:36:38 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id CBB991A0191;
	Mon, 27 Oct 2025 15:37:05 +0800 (CST)
Received: from kwepemn500011.china.huawei.com (7.202.194.152) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Oct 2025 15:37:05 +0800
Received: from huawei.com (10.50.87.129) by kwepemn500011.china.huawei.com
 (7.202.194.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Oct
 2025 15:37:04 +0800
From: <linan122@huawei.com>
To: <corbet@lwn.net>, <song@kernel.org>, <yukuai@fnnas.com>,
	<linan122@huawei.com>, <hare@suse.de>, <xni@redhat.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <linan666@huaweicloud.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v7 4/4] md: allow configuring logical block size
Date: Mon, 27 Oct 2025 15:29:15 +0800
Message-ID: <20251027072915.3014463-5-linan122@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251027072915.3014463-1-linan122@huawei.com>
References: <20251027072915.3014463-1-linan122@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemn500011.china.huawei.com (7.202.194.152)

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
 Documentation/admin-guide/md.rst |  7 +++
 drivers/md/md.h                  |  1 +
 include/uapi/linux/raid/md_p.h   |  3 +-
 drivers/md/md-linear.c           |  1 +
 drivers/md/md.c                  | 76 ++++++++++++++++++++++++++++++++
 drivers/md/raid0.c               |  1 +
 drivers/md/raid1.c               |  1 +
 drivers/md/raid10.c              |  1 +
 drivers/md/raid5.c               |  1 +
 9 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 1c2eacc94758..0f143acd2db7 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -238,6 +238,13 @@ All md devices contain:
      the number of devices in a raid4/5/6, or to support external
      metadata formats which mandate such clipping.
 
+  logical_block_size
+     Configure the array's logical block size in bytes. This attribute
+     is only supported for 1.x meta. The value should be written before
+     starting the array. The final array LBS will use the max value
+     between this configuration and all combined device's LBS. Note that
+     LBS cannot exceed PAGE_SIZE before RAID supports folio.
+
   reshape_position
      This is either ``none`` or a sector number within the devices of
      the array where ``reshape`` is up to.  If this is set, the three
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 38a7c2fab150..a6b3cb69c28c 100644
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
index 7033d982d377..50d4a419a16e 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -72,6 +72,7 @@ static int linear_set_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_hw_sectors = mddev->chunk_sectors;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.max_hw_wzeroes_unmap_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 51f0201e4906..0961bd11f1bc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1998,6 +1998,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 		mddev->layout = le32_to_cpu(sb->layout);
 		mddev->raid_disks = le32_to_cpu(sb->raid_disks);
 		mddev->dev_sectors = le64_to_cpu(sb->size);
+		mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.space = 0;
@@ -2207,6 +2208,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->chunksize = cpu_to_le32(mddev->chunk_sectors);
 	sb->level = cpu_to_le32(mddev->level);
 	sb->layout = cpu_to_le32(mddev->layout);
+	sb->logical_block_size = cpu_to_le32(mddev->logical_block_size);
 	if (test_bit(FailFast, &rdev->flags))
 		sb->devflags |= FailFast1;
 	else
@@ -5935,6 +5937,67 @@ static struct md_sysfs_entry md_serialize_policy =
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
+	md_update_sb(mddev, 1);
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
+__ATTR(logical_block_size, 0644, lbs_show, lbs_store);
 
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
@@ -5957,6 +6020,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_consistency_policy.attr,
 	&md_fail_last_dev.attr,
 	&md_serialize_policy.attr,
+	&md_logical_block_size.attr,
 	NULL,
 };
 
@@ -6087,6 +6151,17 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
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
@@ -6698,6 +6773,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->chunk_sectors = 0;
 	mddev->ctime = mddev->utime = 0;
 	mddev->layout = 0;
+	mddev->logical_block_size = 0;
 	mddev->max_disks = 0;
 	mddev->events = 0;
 	mddev->can_decrease_events = 0;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 49477b560cc9..f3b0d91d903d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -383,6 +383,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_hw_sectors = mddev->chunk_sectors;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.max_hw_wzeroes_unmap_sectors = mddev->chunk_sectors;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
 	lim.chunk_sectors = mddev->chunk_sectors;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 64bfe8ca5b38..167768edaec1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3212,6 +3212,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.max_hw_wzeroes_unmap_sectors = 0;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6b2d4b7057ae..71bfed3b798d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4000,6 +4000,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.max_hw_wzeroes_unmap_sectors = 0;
+	lim.logical_block_size = mddev->logical_block_size;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index aa404abf5d17..92473850f381 100644
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

