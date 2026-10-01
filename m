Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970BB3DA7D2
	for <linux-raid@vger.kernel.org>; Thu,  1 Oct 2026 12:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859394; cv=none; b=ZGotSxFgNk9LuufXu2I1MMydCh/AeYfGKr8a5Tgaz+yy2UHKJoYJP+gCqzLdywmKs0mLD0BDEVPHsXXKFFhC+eRJav5Awdq4PXO0swje+rM71vbC9Jyea5i0UUGZkH4sthG/yHoe5uK+rNKaVoHUV3J+Ksop5LZ1G1v38wJGpkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859394; c=relaxed/simple;
	bh=IljWNn3+dGVxL3pCHy8DDAhiDkU2pYcR9K3nKnVk7cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlrB/iEG9unBP6Me5dtELzZ25iMprUN/JbG+zuQ13lHPj0UDrRM213nY21NBVYgMge1UncsjHPHKS4+ztsZg3SdhWYTjcaLfI2ciBdudjsIP3szl9TTpKhHQkItnnXCbV9EZ5RX2wF651BaSAilJYCRSHMqsiN9KnL8/7JxozN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EE+wuhdT; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EE+wuhdT"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffb83bf7aso43168555e9.2
        for <linux-raid@vger.kernel.org>; Thu, 01 Oct 2026 05:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790859390; x=1791464190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9uFesq912gRqzGbV1ADtVeUwXaDqZgQ9WYs/OAF8VuM=;
        b=EE+wuhdTFmKj9Bc+ZVsqP74CF2UWMCQ7X9Aa2GCg+sluZLexkvb8LYDHfe12hnehOu
         iaUzRBCFxFn6NVMtsmroWUANaK+0/RpuTs1ONwWV8WJ9nTV1jc5SWA1J1GPdfrXplxCu
         pfVKK7v7fSrBK6+HLhK75pa6BgtVdWWP24yLTr0p8Ae5MyQRX2MHSkvEVJcH3t7UcbdY
         +2ZduTwYJQW9kI/NvOzKSRh4yL6cnlZJT/c1MOK7IPvqW/uCz7xvOuWULoEwoV2ErONB
         P5H+WLF2z/LTNSoPhdWpdOYbYnX5JzcN9Qj+4ASlkGJwghad/JIOynINbypE4fP/jpnS
         dFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790859390; x=1791464190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9uFesq912gRqzGbV1ADtVeUwXaDqZgQ9WYs/OAF8VuM=;
        b=F0iQHx56O5tVlQQEUrJv5R3k2yf0lLS5Bml5wWQjoNogulcK2oh9AI9iBccC3b00n/
         8NruyWPksjs6HN8Ea5aVanPR3OQU0uM7n++JTLaGZHPr1gqrdT8ULhwnt7JpfQ36xUaC
         H6Cns5tmJ6KDyhjk4awT3b/qHtBNSB6j1YEtSEYnwTronrCX7Ds4WP1assvlYn2xVGTu
         2tqYC7j7dyL2rhQvAt943PQi4/JD2g3cVuP7r6QEvxgJUiO5tjY7CiYcLpaABaDUwLYE
         k8KLJBmE6qgTeuVImYeXVc+VSb+Glwn/0+6fAVbplUn5ODRMzGs6/LWS/W8JOuty+EGj
         1C3g==
X-Gm-Message-State: AFuF++mNObszYrcacpeFyz+1eH02n/ZZos3+kMRB+Hs2bnQZIARZpLEd
	0my/ZY+B70Kt8esxzJDHnm/EwPfInx2v6RWVOHyomnbudu/twdmQM73c
X-Gm-Gg: AYBFou3JiUS2vD8ULObDLaRC+dPy1L6xva00YF76BK9xdtxQvmWL81ooeiqL+vRbl5a
	Ynxtx76TQ5bd2uVyguiKSTSuMkQQSt3sj2/2xKTC/PcoSGKV8bwbTc2eYF7tx1IQ6n6CD2HYlKW
	bmqqMfi1UVQoMdhn+rD/HYvMZ4d7KlLsd3Li232BRHtqQNTFCQDreMEQN5g4Xq2JG0z9UPXM0PR
	BlmNcYg506FlwwLCgtd6pAkYKMVOwGjn4L3zv9iFyTuWD7sFJ0HJTnZX3zq55RdPXGLyRdF4k3h
	nOJ4Yz9e+0i7NTIk6n/emUPkVlBooxPW2wpFR/nsX0hbj3W7FWsxLwhUqLHmdM8CZfBHvRxOakR
	/NfCOX+EiDh1ksq6mMbtcUmGCEuCx9G4fU5vT3mTzWI6k6aPCiAwS4d6d7GUF/dTI8wV8CI3j2q
	XohervHFwGsJbcLyq7xwFOMD5XVXydU+Ngu1XTlf0XlrxaGFHWcPhZkF4w6MUMf73crAaimUWU0
	SC/RLIlzG22pUQzAA0vUmaSQNnwZc5NYDP2YeeBZV1bHape+2Zbuw4F3Q==
X-Received: by 2002:a05:600c:3b86:b0:4a0:263b:1f73 with SMTP id 5b1f17b1804b1-4a0263b2163mr4449155e9.26.1790859389756;
        Thu, 01 Oct 2026 05:56:29 -0700 (PDT)
Received: from env.. (dynamic-176-003-078-112.176.3.pool.telefonica.de. [176.3.78.112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f9a7650sm68298735e9.15.2026.10.01.05.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 05:56:29 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	chengzhihao1@huawei.com,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [RFC PATCH v2 4/4] md: add a control device for array management
Date: Thu,  1 Oct 2026 12:56:11 +0000
Message-ID: <20261001125611.943731-5-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001125611.943731-1-abd.masalkhi@gmail.com>
References: <20261001125611.943731-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All md management ioctls (SET_ARRAY_INFO, ADD_NEW_DISK, RUN_ARRAY,
STOP_ARRAY, ...) are issued on the md block device itself, so the
caller must hold the array open while it configures or stops it.

This is a problem for STOP_ARRAY and STOP_ARRAY_RO. Before the array is
stopped, the page cache must be flushed, and no other task may have the
device open or be writing to it. The issue arises when several tasks
share the same file descriptor table, as they count as a single opener.
Consequently, one task may still be writing while another task flushes
the page cache and stops the array. A write within this window can race
with the stop operation.

Add a misc character device, /dev/md-control. The control device is
not tied to any md device, each request specifies the array in the
payload, either by name, by UUID or by device number, without the need
to open the md block device. Every request structure has a flags field.
Unknown flags are rejected with -ENOTTY.

Each new command matches an existing block device ioctl with only one
exception. The STOP_ARRAY_RO has no separate command, it is handled
via MD_STOP_ARRAY with the MD_RO_FLAG set.

md_alloc() adds a new mddev to all_mddevs before its gendisk exists,
and frees the mddev directly if creation fails. Move disks_mutex out
of md_alloc() and take it around the control device lookups, so that
they never take a reference to an mddev that md_alloc() has not
finished.

The existing ioctl on the md block device is unchanged, but a warning
message will be printed to recommend upgrading mdadm.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 637 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h |   9 +
 2 files changed, 643 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 63b9468285b0..ef137662760d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -64,6 +64,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
 #include <linux/part_stat.h>
+#include <linux/miscdevice.h>
 
 #include "md.h"
 #include "md-bitmap.h"
@@ -367,6 +368,8 @@ EXPORT_SYMBOL_GPL(md_new_event);
 static LIST_HEAD(all_mddevs);
 static DEFINE_SPINLOCK(all_mddevs_lock);
 
+static DEFINE_MUTEX(disks_mutex);
+
 static bool is_md_suspended(struct mddev *mddev)
 {
 	return percpu_ref_is_dying(&mddev->active_io);
@@ -6319,7 +6322,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	 * If "name" is not NULL, the device is being created by
 	 * writing to /sys/module/md_mod/parameters/new_array.
 	 */
-	static DEFINE_MUTEX(disks_mutex);
 	struct mddev *mddev;
 	struct gendisk *disk;
 	int partitioned;
@@ -6386,8 +6388,10 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
 	error = add_disk(disk);
-	if (error)
+	if (error) {
+		mddev->gendisk = NULL;
 		goto out_put_disk;
+	}
 
 	kobject_init(&mddev->kobj, &md_ktype);
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
@@ -8375,7 +8379,7 @@ static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 }
 
 static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
-			unsigned int cmd, unsigned long arg)
+		    unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
 	unsigned int noio_flags = 0;
@@ -8387,6 +8391,8 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	if (err)
 		return err;
 
+	pr_warn_once("md: ioctl is deprecated and will be removed in future, please upgrade to mdadm-4.6+\n");
+
 	/*
 	 * Commands dealing with the RAID driver but not any
 	 * particular array:
@@ -8602,6 +8608,623 @@ static int md_compat_ioctl(struct block_device *bdev, blk_mode_t mode,
 }
 #endif /* CONFIG_COMPAT */
 
+static struct mddev *mdctl_get_mddev_dev(dev_t dev)
+{
+	struct mddev *mddev, *ret = ERR_PTR(-EINVAL);
+
+	if (MINOR(dev) >= (1 << MINORBITS))
+		return ret;
+
+	if (MAJOR(dev) != MD_MAJOR)
+		dev &= ~((1 << MdpMinorShift) - 1);
+
+	ret = ERR_PTR(-ENODEV);
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		if (mddev->unit == dev) {
+			ret = mddev_get(mddev);
+			if (!ret)
+				ret = ERR_PTR(-ENODEV);
+			break;
+		}
+	}
+	spin_unlock(&all_mddevs_lock);
+
+	return ret;
+}
+
+static struct mddev *mdctl_get_mddev_name(const char *name)
+{
+	unsigned long minor;
+	struct mddev *mddev, *ret = ERR_PTR(-EINVAL);
+
+	if (strncmp(name, "md", 2) || name[MD_NAME_LEN - 1])
+		return ret;
+
+	if (name[2] != '_' && (!isdigit(name[2]) ||
+			       kstrtoul(&name[2], 10, &minor) ||
+			       minor > MINORMASK))
+		return ret;
+
+	ret = ERR_PTR(-ENODEV);
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		if (mddev->gendisk &&
+		    strcmp(mddev->gendisk->disk_name, name) == 0) {
+			ret = mddev_get(mddev);
+			if (!ret)
+				ret = ERR_PTR(-ENODEV);
+			break;
+		}
+	}
+	spin_unlock(&all_mddevs_lock);
+
+	return ret;
+}
+
+static struct mddev *mdctl_get_mddev_uuid(const char *uuid)
+{
+	struct mddev *mddev, *ret = ERR_PTR(-ENODEV);
+
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		if (memcmp(mddev->uuid, uuid, sizeof(mddev->uuid)) == 0) {
+			ret = mddev_get(mddev);
+			if (!ret)
+				ret = ERR_PTR(-ENODEV);
+			break;
+		}
+	}
+	spin_unlock(&all_mddevs_lock);
+
+	return ret;
+}
+
+static struct mddev *mdctl_find_mddev(struct mdu_ioctl *md_ctl)
+{
+	struct mddev *ret = ERR_PTR(-EINVAL);
+
+	/*
+	 * md_alloc() adds a new mddev to all_mddevs before it creates the
+	 * gendisk. If creation fails. it frees the mddev directly, without
+	 * looking at ->active. All of this happens under disks_mutex.
+	 * Holding disks_mutex for the lookup means we only see mddevs that
+	 * md_alloc() has finished, so taking a reference is safe and every
+	 * mddev we find has a gendisk.
+	 */
+	mutex_lock(&disks_mutex);
+
+	if (memchr_inv(md_ctl->uuid, 0, MD_UUID_LEN)) {
+		if (*md_ctl->name || md_ctl->dev) {
+			pr_err_ratelimited("md: only supply one of name, uuid or dev number\n");
+			goto out;
+		}
+		ret = mdctl_get_mddev_uuid(md_ctl->uuid);
+	} else if (*md_ctl->name) {
+		if (md_ctl->dev) {
+			pr_err_ratelimited("md: only supply one of name, uuid or dev number\n");
+			goto out;
+		}
+		ret = mdctl_get_mddev_name(md_ctl->name);
+	} else if (md_ctl->dev) {
+		ret = mdctl_get_mddev_dev(new_decode_dev(md_ctl->dev));
+	}
+
+out:
+	mutex_unlock(&disks_mutex);
+	return ret;
+}
+
+static int mdctl_get_raid_version(struct mdu_version64 __user *user)
+{
+	struct mdu_version64 v = {0};
+
+	v.major = MD_MAJOR_VERSION;
+	v.minor = MD_MINOR_VERSION;
+	v.patchlevel = MD_PATCHLEVEL_VERSION;
+
+	if (copy_to_user(user, &v, sizeof(v)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int mdctl_get_array_info(struct mddev *mddev, void __user *arg)
+{
+	struct mdu_array_info64 info = {0};
+	int nr, working, insync, failed, spare, journal;
+	struct md_rdev *rdev;
+
+	nr = working = insync = failed = spare = journal = 0;
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
+		nr++;
+		if (test_bit(Faulty, &rdev->flags)) {
+			failed++;
+		} else {
+			working++;
+			if (test_bit(In_sync, &rdev->flags))
+				insync++;
+			else if (test_bit(Journal, &rdev->flags))
+				journal++;
+			else
+				spare++;
+		}
+	}
+	rcu_read_unlock();
+
+	info.major_version = mddev->major_version;
+	info.minor_version = mddev->minor_version;
+	info.patch_version = MD_PATCHLEVEL_VERSION;
+	info.ctime         = mddev->ctime;
+	info.level         = mddev->level;
+	info.size          = mddev->dev_sectors / 2;
+	info.nr_disks      = nr;
+	info.raid_disks    = mddev->raid_disks;
+	info.md_minor      = mddev->md_minor;
+	info.not_persistent = !mddev->persistent;
+
+	info.utime         = mddev->utime;
+	info.state         = 0;
+	if (mddev->in_sync)
+		info.state = (1 << MD_SB_CLEAN);
+	if (mddev->bitmap && mddev->bitmap_info.offset)
+		info.state |= (1 << MD_SB_BITMAP_PRESENT);
+	if (mddev_is_clustered(mddev))
+		info.state |= (1 << MD_SB_CLUSTERED);
+	info.active_disks  = insync;
+	info.working_disks = working;
+	info.failed_disks  = failed;
+	info.spare_disks   = spare;
+	info.journal_disks = journal;
+
+	info.layout        = mddev->layout;
+	info.chunk_size    = mddev->chunk_sectors << 9;
+
+	if (copy_to_user(arg, &info, sizeof(info)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int mdctl_get_disk_info(struct mddev *mddev, void __user *arg)
+{
+	struct mdu_disk_info64 info = {0};
+	struct md_rdev *rdev;
+
+	if (copy_from_user(&info, arg, sizeof(info)))
+		return -EFAULT;
+
+	rcu_read_lock();
+	rdev = md_find_rdev_nr_rcu(mddev, info.number);
+	if (rdev) {
+		info.major = MAJOR(rdev->bdev->bd_dev);
+		info.minor = MINOR(rdev->bdev->bd_dev);
+		info.raid_disk = rdev->raid_disk;
+		info.state = 0;
+		if (test_bit(Faulty, &rdev->flags))
+			info.state |= (1 << MD_DISK_FAULTY);
+		else if (test_bit(In_sync, &rdev->flags)) {
+			info.state |= (1 << MD_DISK_ACTIVE);
+			info.state |= (1 << MD_DISK_SYNC);
+		}
+		if (test_bit(Journal, &rdev->flags))
+			info.state |= (1 << MD_DISK_JOURNAL);
+		if (test_bit(WriteMostly, &rdev->flags))
+			info.state |= (1 << MD_DISK_WRITEMOSTLY);
+		if (test_bit(FailFast, &rdev->flags))
+			info.state |= (1 << MD_DISK_FAILFAST);
+	} else {
+		info.major = info.minor = 0;
+		info.raid_disk = -1;
+		info.state = (1 << MD_DISK_REMOVED);
+	}
+	rcu_read_unlock();
+
+	if (copy_to_user(arg, &info, sizeof(info)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int mdctl_get_bitmap_file(struct mddev *mddev, void __user *arg)
+{
+	struct mdu_bitmap_file64 *file; /* too big for stack allocation */
+	char *ptr;
+	int err;
+
+	file = kzalloc_obj(*file, GFP_NOIO);
+	if (!file)
+		return -ENOMEM;
+
+	err = 0;
+	spin_lock(&mddev->lock);
+	/* bitmap enabled */
+	if (mddev->bitmap_info.file) {
+		ptr = file_path(mddev->bitmap_info.file, file->pathname,
+				sizeof(file->pathname));
+		if (IS_ERR(ptr))
+			err = PTR_ERR(ptr);
+		else
+			memmove(file->pathname, ptr,
+				sizeof(file->pathname)-(ptr-file->pathname));
+	}
+	spin_unlock(&mddev->lock);
+
+	if (err == 0 &&
+	    copy_to_user(arg, file, sizeof(*file)))
+		err = -EFAULT;
+
+	kfree(file);
+	return err;
+}
+
+static int mdctl_set_array_info(struct mddev *mddev,
+				struct mdu_array_info64 __user *user)
+{
+	struct mdu_array_info64 info;
+	int err;
+
+	if (!user)
+		memset(&info, 0, sizeof(info));
+	else if (copy_from_user(&info, user, sizeof(info)))
+		return -EFAULT;
+
+	if (mddev->pers) {
+		err = update_array_info(mddev, &info);
+		if (err)
+			pr_warn("md: couldn't update array info. %d\n", err);
+		return err;
+	}
+
+	if (!list_empty(&mddev->disks)) {
+		pr_warn("md: array %s already has disks!\n", mdname(mddev));
+		return -EBUSY;
+	}
+
+	if (mddev->raid_disks) {
+		pr_warn("md: array %s already initialised!\n", mdname(mddev));
+		return -EBUSY;
+	}
+
+	err = md_set_array_info(mddev, &info);
+	if (err)
+		pr_warn("md: couldn't set array info. %d\n", err);
+
+	return err;
+}
+
+/*
+ * Return true if @cmd needs a configured array, false otherwise.
+ */
+static bool mdctl_ioctl_need_config(unsigned int cmd, u32 flags)
+{
+	switch (cmd) {
+	case MD_RAID_AUTORUN:
+	case MD_HOT_ADD_DISK:
+	case MD_HOT_REMOVE_DISK:
+	case MD_RESTART_ARRAY_RW:
+	case MD_CLUSTERED_DISK_NACK:
+		return true;
+
+	case MD_STOP_ARRAY:
+		/* switching to read-only needs an array, a full stop does not */
+		return !!(flags & MD_RO_FLAG);
+
+	default:
+		return false;
+	}
+}
+
+static bool mdctl_ioctl_need_suspend(unsigned int cmd)
+{
+	switch (cmd) {
+	case MD_ADD_NEW_DISK:
+	case MD_HOT_ADD_DISK:
+	case MD_HOT_REMOVE_DISK:
+	case MD_SET_BITMAP_FILE:
+	case MD_SET_ARRAY_INFO:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int mdctl_ioctl_valid(unsigned int cmd)
+{
+	switch (cmd) {
+	case MD_GET_ARRAY_INFO:
+	case MD_GET_DISK_INFO:
+	case MD_RAID_VERSION:
+		return 0;
+
+	case MD_RAID_AUTORUN:
+	case MD_SET_DISK_FAULTY:
+	case MD_GET_BITMAP_FILE:
+	case MD_ADD_NEW_DISK:
+	case MD_HOT_ADD_DISK:
+	case MD_HOT_REMOVE_DISK:
+	case MD_RESTART_ARRAY_RW:
+	case MD_RUN_ARRAY:
+	case MD_SET_ARRAY_INFO:
+	case MD_SET_BITMAP_FILE:
+	case MD_STOP_ARRAY:
+	case MD_CLUSTERED_DISK_NACK:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int mdctl_flags_valid(unsigned int cmd, u32 flags)
+{
+	switch (cmd) {
+	case MD_GET_ARRAY_INFO:
+	case MD_GET_DISK_INFO:
+	case MD_RAID_VERSION:
+	case MD_RAID_AUTORUN:
+	case MD_GET_BITMAP_FILE:
+	case MD_ADD_NEW_DISK:
+	case MD_HOT_ADD_DISK:
+	case MD_HOT_REMOVE_DISK:
+	case MD_RESTART_ARRAY_RW:
+	case MD_RUN_ARRAY:
+	case MD_SET_ARRAY_INFO:
+	case MD_SET_BITMAP_FILE:
+	case MD_SET_DISK_FAULTY:
+	case MD_CLUSTERED_DISK_NACK:
+		if (flags)
+			return -ENOTTY;
+		return 0;
+	case MD_STOP_ARRAY:
+		if (flags && flags != MD_RO_FLAG)
+			return -ENOTTY;
+		return 0;
+	default:
+		return -ENOTTY;
+	}
+}
+
+static long mdctl_ioctl(struct file *filp, uint cmd, ulong u)
+{
+	int err;
+	unsigned int noio_flags = 0;
+	struct mddev *mddev;
+	void __user *arg;
+	struct mdu_ioctl md_ctl;
+	bool suspend;
+	u32 flags;
+
+	err = mdctl_ioctl_valid(cmd);
+	if (err)
+		return err;
+
+	/*
+	 * Commands dealing with the RAID driver but not any
+	 * particular array:
+	 */
+	if (cmd == MD_RAID_VERSION)
+		return mdctl_get_raid_version((struct mdu_version64 __user *)u);
+
+	if (copy_from_user(&md_ctl, (void __user *)u, sizeof(md_ctl)))
+		return -EFAULT;
+
+	flags = md_ctl.flags;
+
+	/*
+	 * for now, Only MD_STOP_ARRAY takes flags; other commands need
+	 * flags == 0.
+	 */
+	err = mdctl_flags_valid(cmd, flags);
+	if (err)
+		return err;
+
+	mddev = mdctl_find_mddev(&md_ctl);
+	if (IS_ERR(mddev))
+		return PTR_ERR(mddev);
+
+	arg = u64_to_user_ptr(md_ctl.arg);
+
+	/* These commands do not need reconfig_mutex. */
+	err = -ENODEV;
+	switch (cmd) {
+	case MD_GET_ARRAY_INFO:
+		if (mddev_configured(mddev))
+			err = mdctl_get_array_info(mddev, arg);
+		goto out;
+
+	case MD_GET_DISK_INFO:
+		if (mddev_configured(mddev))
+			err = mdctl_get_disk_info(mddev, arg);
+		goto out;
+
+	case MD_GET_BITMAP_FILE:
+		err = mdctl_get_bitmap_file(mddev, arg);
+		goto out;
+
+	case MD_SET_DISK_FAULTY:
+		err = set_disk_faulty(mddev, new_decode_dev(md_ctl.arg));
+		goto out;
+	}
+
+	if (cmd == MD_STOP_ARRAY) {
+		/* Need to flush page cache, and ensure no openers */
+		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
+		if (err)
+			goto out;
+	}
+
+	if (!md_is_rdwr(mddev))
+		flush_work(&mddev->sync_work);
+
+	suspend = mdctl_ioctl_need_suspend(cmd);
+	err = suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
+	if (err) {
+		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
+			 err, cmd);
+		goto out;
+	}
+	if (suspend)
+		noio_flags = memalloc_noio_save();
+
+	/*
+	 * Commands querying/configuring an existing array.
+	 *
+	 * If the array is not initialised yet, check of the command requires
+	 * the array to be initialised.
+	 */
+	if (!mddev_configured(mddev) && mdctl_ioctl_need_config(cmd, flags)) {
+		err = -ENODEV;
+		goto unlock;
+	}
+
+	/*
+	 * Commands even a read-only array can execute:
+	 */
+	switch (cmd) {
+	case MD_SET_ARRAY_INFO:
+		err = mdctl_set_array_info(mddev, arg);
+		goto unlock;
+
+	case MD_RESTART_ARRAY_RW:
+		err = restart_array(mddev);
+		goto unlock;
+
+	case MD_STOP_ARRAY:
+		err = -EINVAL;
+		if (!flags)
+			err = do_md_stop(mddev, 0);
+		else if (flags == MD_RO_FLAG && mddev->pers)
+			err = md_set_readonly(mddev);
+		goto unlock;
+
+	case MD_HOT_REMOVE_DISK:
+		err = hot_remove_disk(mddev, new_decode_dev(md_ctl.arg));
+		goto unlock;
+
+	case MD_ADD_NEW_DISK:
+		/* We can support ADD_NEW_DISK on read-only arrays
+		 * only if we are re-adding a preexisting device.
+		 * So require mddev->pers and MD_DISK_SYNC.
+		 */
+		if (mddev->pers) {
+			struct mdu_disk_info64 info;
+
+			if (copy_from_user(&info, arg, sizeof(info)))
+				err = -EFAULT;
+			else if (!(info.state & (1 << MD_DISK_SYNC)))
+				/* Need to clear read-only for this */
+				break;
+			else
+				err = md_add_new_disk(mddev, &info);
+			goto unlock;
+		}
+		break;
+	}
+
+	/*
+	 * The remaining ioctls are changing the state of the
+	 * superblock, so we do not allow them on read-only arrays.
+	 */
+	if (!md_is_rdwr(mddev) && mddev->pers) {
+		if (mddev->ro != MD_AUTO_READ) {
+			err = -EROFS;
+			goto unlock;
+		}
+		mddev->ro = MD_RDWR;
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		/* mddev_unlock will wake thread */
+		/* If a device failed while we were read-only, we
+		 * need to make sure the metadata is updated now.
+		 */
+		if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {
+			mddev_unlock(mddev);
+			wait_event(mddev->sb_wait,
+				   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&
+				   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
+			mddev_lock_nointr(mddev);
+		}
+	}
+
+	switch (cmd) {
+	case MD_ADD_NEW_DISK:
+	{
+		struct mdu_disk_info64 info;
+
+		if (copy_from_user(&info, arg, sizeof(info)))
+			err = -EFAULT;
+		else
+			err = md_add_new_disk(mddev, &info);
+
+		goto unlock;
+	}
+
+	case MD_CLUSTERED_DISK_NACK:
+		if (mddev_is_clustered(mddev))
+			mddev->cluster_ops->new_disk_ack(mddev, false);
+		else
+			err = -EINVAL;
+		goto unlock;
+
+	case MD_HOT_ADD_DISK:
+		err = hot_add_disk(mddev, new_decode_dev(md_ctl.arg));
+		goto unlock;
+
+	case MD_RUN_ARRAY:
+		err = do_md_run(mddev);
+		goto unlock;
+
+	case MD_SET_BITMAP_FILE:
+		err = set_bitmap_file(mddev, md_ctl.arg);
+		goto unlock;
+
+	default:
+		err = -EINVAL;
+		goto unlock;
+	}
+
+unlock:
+	if (!err && mddev->hold_active == UNTIL_IOCTL)
+		mddev->hold_active = 0;
+
+	if (suspend) {
+		memalloc_noio_restore(noio_flags);
+		mddev_unlock_and_resume(mddev);
+	} else {
+		mddev_unlock(mddev);
+	}
+out:
+	mddev_put(mddev);
+	return err;
+}
+
+static const struct file_operations mdctl_file_ops = {
+	.open = nonseekable_open,
+	.unlocked_ioctl = mdctl_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
+	.owner = THIS_MODULE,
+	.llseek  = noop_llseek,
+};
+
+static struct miscdevice mdctl_misc = {
+	.name = MD_CTL_NODE,
+	.minor = MISC_DYNAMIC_MINOR,
+	.fops = &mdctl_file_ops,
+};
+
+static int __init mdctl_init(void)
+{
+	return misc_register(&mdctl_misc);
+}
+
+static void __exit mdctl_exit(void)
+{
+	misc_deregister(&mdctl_misc);
+}
+
 static int md_set_read_only(struct block_device *bdev, bool ro)
 {
 	struct mddev *mddev = bdev->bd_disk->private_data;
@@ -10815,12 +11438,19 @@ static int __init md_init(void)
 		goto err_mdp;
 	mdp_major = ret;
 
+	ret = mdctl_init();
+	if (ret < 0)
+		goto err_ctl;
+
 	register_reboot_notifier(&md_notifier);
 	raid_table_header = register_sysctl("dev/raid", raid_table);
 
 	md_geninit();
 	return 0;
 
+err_ctl:
+	unregister_blkdev(mdp_major, "mdp");
+	mdp_major = 0;
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
@@ -11098,6 +11728,7 @@ static __exit void md_exit(void)
 	struct mddev *mddev;
 	int delay = 1;
 
+	mdctl_exit();
 	unregister_blkdev(MD_MAJOR,"md");
 	unregister_blkdev(mdp_major, "mdp");
 	unregister_reboot_notifier(&md_notifier);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 27de34a8bdf9..0dfae7b86830 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -996,6 +996,15 @@ static inline void rdev_record_write_error(struct md_rdev *rdev)
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
 }
 
+/*
+ * Return true if array is configured or its metadata is managed by user space,
+ * false otherwise.
+ */
+static inline bool mddev_configured(struct mddev *mddev)
+{
+	return mddev->raid_disks || mddev->external;
+}
+
 static inline int mddev_is_clustered(struct mddev *mddev)
 {
 	return mddev->cluster_info && mddev->bitmap_info.nodes > 1;
-- 
2.43.0

