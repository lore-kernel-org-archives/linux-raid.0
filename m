Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305351;
	b=i0NtIUtyjhvp+W3k+cN/X4OSS1bQrPBP7p8w24TYEWhUgn+r4oYL4cc5stqfz0HGt8Nu
	 sO419dYBZpVZNmOlXNfjz2VNH2tgpHLPwYKjMOlA3k6JzW8YI62Eu2F0xIFzCl0DCvoOH
	 3ZgY+gaJlYpU84RkGUV2G/DXDTHAuQYiyFUQI/ZiOiKZzhFcG8ypEhlBHdGBfgSl3CZ0x
	 BPhaZNOetvjKMqOOJ8TJtLz2VZUkaro/BxC7esMVOzb7G5ei81p1ASxdlkGyp9hjVb4Vh
	 a7VSJYOMyMEXyIn4M3AKECjR9wRghwWSSFbZipzExoLtcnQSE+v4QntXlvNsDbj/33Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305351;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vO9ylg4VUxVdaZugbo40lpx5rO8zEQdmzReR1vkGI54=;
	b=dTG9V6sTLG3hrZBdVYf6FaRZmLCNNFxGTIfr/9VYlWNxQsSGBP2jJIPOB0zxqXnPFsvz
	 cZEln17XD5OI3ah0kdYzdkN9tzZs0VK2FQGW6dcR16czmughYDCRnvkCLrxpmPVI6Kxr8
	 6aVPFlBt5svwvIsqKN7NmBDqGzV+e+mEtd+SuBYbgJogsJzpSuMLXDT2rXQgs6NUZ6i/C
	 3rhf+57E8fObSf1Lf6N46oe0VkRFLEYVJIEpGCMWH8Y7Iz6G8RlnLGlSTW7Z5F6fZCE97
	 jly1ZffEOjc7p0RVoXNKsuJaNL07z8X3ntrJH+VBmBfG9+ohB09ImbuyxtiwoDJqTIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZnV4ktCY;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46543606A32F
	for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 20:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46543606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZnV4ktCY
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so24799895e9.2
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 13:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793305350; x=1793910150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vO9ylg4VUxVdaZugbo40lpx5rO8zEQdmzReR1vkGI54=;
        b=ZnV4ktCYp3AQOO3uK6bikG5UAIfnSGV9WL/ut2i8u4nhKLuis7RxHUoGsJpTvldUEx
         KuQ8DZMBadtBGs1X2IyrPOtqN2XoXLcOq3HitVCBt6KRnciba/+RLbVUMxfVtgrT9C1o
         pDu+413eJqXtxkhzx/FiE06jvFi0kZLRsXQXC3RwYDKwcgtN9JYUITbOHz+JjWP5h5oL
         +L3RwvIfpD/odWo4tSTCr2meh1rDWxmhgL3Pdie9qUDWyI428aoRKOJF6vtIEmRFHrNh
         9HahuuIVBwxeVPcwLkZ82zpobzoPOTRsVqjU/7ESym+TrHFctH/TWp9WjD+0c3rinjPR
         e7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793305350; x=1793910150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vO9ylg4VUxVdaZugbo40lpx5rO8zEQdmzReR1vkGI54=;
        b=0ndDtv/jTgO9Ncim+amdCz/GSC1I4SOQCoO/LOO0B6h6FKoIgi66G5+r21aT70jRBv
         hukW0M8QW22Y199S/ZhOOk03RAxDBtZssASivG/RnNkoHUWqQLxC6JgS9gmF5sGvjQxa
         EcWQYR/hToCjanzCi0sbhvWQfkDSDl6Ph4ublL12GaA4HmxZbDmRJ2r4D7RqXy51Qikp
         SSeR5jZpy7etucLdziyNqYtrMpMJjbYw3soCaSew3ut1dS5IYqcCjZWCH77udA3gKkAQ
         x2Jk9F1JG+VoqW6cTm+4xI7w/ggNoSjNAOac1zO7WhFW9v1jHYGbJe+7DMFWmaE2lIZj
         NzvA==
X-Gm-Message-State: AFq9FYLofTd0qbG6HV5QnRLHU3I69J+qFsR0vz11V+Nc3+6528I+CjdC
	6i9MEJmFHRb7WsjV/wVEyQ7oMEu0Scu8eXs/3nowfsCkvpZozz4+F5+p
X-Gm-Gg: AYBFou0IE9pAHdwEAmjt+4x0rw6rNWOuHgUYcFkS2fNI2X1xWCEXKGVPE8DA6aA5u8c
	qSUB2d3qNQQo/QDJEwHzTCJQs8XC9SsnZTzwaFRq81khd0nkAVdkZKBpokFd5GAx29VI5Yz1H9F
	8I+abvDQmd4aoVUt932FGFQbmKRSlzpkHmox+IKdc8Fqod+W7uI0qHM0OmMDi2jl25QglfTK4VO
	5Z4f08whiyY/CMQ11cgxbATnjEJ1zEvG7AiHbjNqAksUy2u5Nc79RiVAvLLyb13RX/Zy4Yqb1QO
	cYxRxS77Mdh9v3PPqdl5ap1yEAPlEz7RDL7+zfkZiUEDVIvbUqr7yPXIOLGR3Zj/meYGSkdxaDO
	8HjpXTUkJBywVFi/Ym4aOitVQsuIuShd/DW592yG1DdJs3CRl2pFXw4A5O1NRgft6csR+hPW77V
	5/CG2+pQ3A+DZl769jD4Xoa1NF9Dde7c6UAImkTr7DAwgazCAobdwqX6TROAlCsuvAM3VYT4r2H
	b1M1Bg30P3HrvCSGkloWG35Y/Z8izREyRzIHuUybv6yqG3qFjwaETqu41407v5TqvE5y1J1CvBu
	CTeYvwpQKAHU2omgeoRj/SCYrnFTYTQhe1ww86l7JTAWfxysBt3FGaenCnRrclZAdu5jKUnF1+S
	fGw==
X-Received: by 2002:a05:600c:3b2a:b0:4a1:fae5:f2e2 with SMTP id 5b1f17b1804b1-4ac14fbdd04mr2192255e9.4.1793305349601;
        Thu, 29 Oct 2026 13:22:29 -0700 (PDT)
Received: from env.. (dynamic-176-003-098-140.176.3.pool.telefonica.de. [176.3.98.140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf7146621sm9424335e9.13.2026.10.29.13.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 13:22:29 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	mtkaczyk@kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>
Subject: [RFC PATCH v5 4/4] md: add a control device for array management
Date: Thu, 29 Oct 2026 20:22:08 +0000
Message-ID: <20261029202209.1422567-5-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029202209.1422567-1-abd.masalkhi@gmail.com>
References: <20261029202209.1422567-1-abd.masalkhi@gmail.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
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
payload, either by name, by UUID (it is only available for arrays with
native metadata) or by device number, without the need to open the md
block device. Every request structure has a flags field. Unknown flags
are rejected with -ENOTTY.

md_alloc() adds a new mddev to all_mddevs before its gendisk exists,
and frees the mddev directly if creation fails. Move disks_mutex out
of md_alloc() and take it around the control device lookups, so that
they never take a reference to an mddev that md_alloc() has not
finished.

The existing ioctl on the md block device is unchanged, but a warning
message will be printed to recommend using the control device and
indicate that the per-array MD ioctls will be removed in the future.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 632 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h |   9 +
 2 files changed, 638 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3b4497b615cf..a1425b5e6b3e 100644
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
@@ -8374,7 +8378,7 @@ static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 }
 
 static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
-			unsigned int cmd, unsigned long arg)
+		    unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
 	unsigned int noio_flags = 0;
@@ -8386,6 +8390,8 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	if (err)
 		return err;
 
+	pr_warn_once("md: %s uses the deprecated per-array md ioctls, which will be removed in future; use /dev/%s instead\n",
+		     current->comm, MD_CTL_NODE);
 	/*
 	 * Commands dealing with the RAID driver but not any
 	 * particular array:
@@ -8601,6 +8607,618 @@ static int md_compat_ioctl(struct block_device *bdev, blk_mode_t mode,
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
+	if (strnlen(name, MD_NAME_LEN) == MD_NAME_LEN || strncmp(name, "md", 2))
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
+	if (memchr_inv(md_ctl->md_uuid, 0, MD_UUID_LEN)) {
+		if (*md_ctl->md_name || md_ctl->md_dev) {
+			pr_err_ratelimited("md: only supply one of name, uuid or dev number\n");
+			goto out;
+		}
+		ret = mdctl_get_mddev_uuid(md_ctl->md_uuid);
+	} else if (*md_ctl->md_name) {
+		if (md_ctl->md_dev) {
+			pr_err_ratelimited("md: only supply one of name, uuid or dev number\n");
+			goto out;
+		}
+		ret = mdctl_get_mddev_name(md_ctl->md_name);
+	} else if (md_ctl->md_dev) {
+		ret = mdctl_get_mddev_dev(new_decode_dev(md_ctl->md_dev));
+	}
+
+out:
+	mutex_unlock(&disks_mutex);
+	return ret;
+}
+
+static int mdctl_lookup_array(struct mddev *mddev, struct mdu_ioctl __user *u)
+{
+	struct mdu_ioctl md_ctl;
+
+	memset(&md_ctl, 0, sizeof(md_ctl));
+	memcpy(md_ctl.md_uuid, mddev->uuid, MD_UUID_LEN);
+	strscpy(md_ctl.md_name, mddev->gendisk->disk_name, MD_NAME_LEN);
+	md_ctl.md_dev = new_encode_dev(mddev->unit);
+
+	if (copy_to_user(u, &md_ctl, sizeof(md_ctl)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int mdctl_get_raid_version(struct mdu_version64 __user *user)
+{
+	struct mdu_version64 v;
+
+	memset(&v, 0, sizeof(v));
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
+	struct mdu_array_info64 info;
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
+	memset(&info, 0, sizeof(info));
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
+	struct mdu_disk_info64 info;
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
+	case MD_CTL_HOT_ADD_DISK:
+	case MD_CTL_HOT_REMOVE_DISK:
+	case MD_CTL_RESTART_ARRAY_RW:
+	case MD_CTL_CLUSTERED_DISK_NACK:
+		return true;
+
+	case MD_CTL_STOP_ARRAY:
+		/* switching to read-only needs an array, a full stop does not */
+		return !!(flags & MD_CTL_RO_FLAG);
+
+	default:
+		return false;
+	}
+}
+
+static bool mdctl_ioctl_need_suspend(unsigned int cmd)
+{
+	switch (cmd) {
+	case MD_CTL_ADD_NEW_DISK:
+	case MD_CTL_HOT_ADD_DISK:
+	case MD_CTL_HOT_REMOVE_DISK:
+	case MD_CTL_SET_BITMAP_FILE:
+	case MD_CTL_SET_ARRAY_INFO:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int mdctl_ioctl_valid(unsigned int cmd)
+{
+	switch (cmd) {
+	case MD_CTL_RAID_VERSION:
+	case MD_CTL_LOOKUP_ARRAY:
+	case MD_CTL_GET_ARRAY_INFO:
+	case MD_CTL_GET_DISK_INFO:
+		return 0;
+
+	case MD_CTL_SET_DISK_FAULTY:
+	case MD_CTL_GET_BITMAP_FILE:
+	case MD_CTL_ADD_NEW_DISK:
+	case MD_CTL_HOT_ADD_DISK:
+	case MD_CTL_HOT_REMOVE_DISK:
+	case MD_CTL_RESTART_ARRAY_RW:
+	case MD_CTL_RUN_ARRAY:
+	case MD_CTL_SET_ARRAY_INFO:
+	case MD_CTL_SET_BITMAP_FILE:
+	case MD_CTL_STOP_ARRAY:
+	case MD_CTL_CLUSTERED_DISK_NACK:
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
+	/*
+	 * for now, Only MD_CTL_STOP_ARRAY takes flags; other commands need
+	 * flags == 0.
+	 */
+	switch (cmd) {
+	case MD_CTL_RAID_VERSION:
+	case MD_CTL_LOOKUP_ARRAY:
+	case MD_CTL_GET_ARRAY_INFO:
+	case MD_CTL_GET_DISK_INFO:
+	case MD_CTL_GET_BITMAP_FILE:
+	case MD_CTL_ADD_NEW_DISK:
+	case MD_CTL_HOT_ADD_DISK:
+	case MD_CTL_HOT_REMOVE_DISK:
+	case MD_CTL_RESTART_ARRAY_RW:
+	case MD_CTL_RUN_ARRAY:
+	case MD_CTL_SET_ARRAY_INFO:
+	case MD_CTL_SET_BITMAP_FILE:
+	case MD_CTL_SET_DISK_FAULTY:
+	case MD_CTL_CLUSTERED_DISK_NACK:
+		if (flags)
+			return -ENOTTY;
+		return 0;
+	case MD_CTL_STOP_ARRAY:
+		if (flags && flags != MD_CTL_RO_FLAG)
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
+	bool closing = false;
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
+	if (cmd == MD_CTL_RAID_VERSION)
+		return mdctl_get_raid_version((struct mdu_version64 __user *)u);
+
+	if (copy_from_user(&md_ctl, (void __user *)u, sizeof(md_ctl)))
+		return -EFAULT;
+
+	flags = md_ctl.flags;
+
+	err = mdctl_flags_valid(cmd, flags);
+	if (err)
+		return err;
+
+	mddev = mdctl_find_mddev(&md_ctl);
+	if (IS_ERR(mddev))
+		return PTR_ERR(mddev);
+
+	if (cmd == MD_CTL_LOOKUP_ARRAY) {
+		err = mdctl_lookup_array(mddev, (struct mdu_ioctl __user *)u);
+		goto out;
+	}
+
+	arg = u64_to_user_ptr(md_ctl.arg);
+
+	/* These commands do not need reconfig_mutex. */
+	err = -ENODEV;
+	switch (cmd) {
+	case MD_CTL_GET_ARRAY_INFO:
+		if (mddev_configured(mddev))
+			err = mdctl_get_array_info(mddev, arg);
+		goto out;
+
+	case MD_CTL_GET_DISK_INFO:
+		if (mddev_configured(mddev))
+			err = mdctl_get_disk_info(mddev, arg);
+		goto out;
+
+	case MD_CTL_GET_BITMAP_FILE:
+		err = get_bitmap_file(mddev, arg);
+		goto out;
+
+	case MD_CTL_SET_DISK_FAULTY:
+		err = set_disk_faulty(mddev, new_decode_dev(md_ctl.arg));
+		goto out;
+	}
+
+	if (cmd == MD_CTL_STOP_ARRAY) {
+		/* Need to flush page cache, and ensure no openers */
+		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
+		if (err)
+			goto out;
+
+		closing = true;
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
+	case MD_CTL_SET_ARRAY_INFO:
+		err = mdctl_set_array_info(mddev, arg);
+		goto unlock;
+
+	case MD_CTL_RESTART_ARRAY_RW:
+		err = restart_array(mddev);
+		goto unlock;
+
+	case MD_CTL_STOP_ARRAY:
+		err = -EINVAL;
+		if (!flags)
+			err = do_md_stop(mddev, 0);
+		else if (flags == MD_CTL_RO_FLAG && mddev->pers)
+			err = md_set_readonly(mddev);
+		goto unlock;
+
+	case MD_CTL_HOT_REMOVE_DISK:
+		err = hot_remove_disk(mddev, new_decode_dev(md_ctl.arg));
+		goto unlock;
+
+	case MD_CTL_ADD_NEW_DISK:
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
+	case MD_CTL_ADD_NEW_DISK:
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
+	case MD_CTL_CLUSTERED_DISK_NACK:
+		if (mddev_is_clustered(mddev))
+			mddev->cluster_ops->new_disk_ack(mddev, false);
+		else
+			err = -EINVAL;
+		goto unlock;
+
+	case MD_CTL_HOT_ADD_DISK:
+		err = hot_add_disk(mddev, new_decode_dev(md_ctl.arg));
+		goto unlock;
+
+	case MD_CTL_RUN_ARRAY:
+		err = do_md_run(mddev);
+		goto unlock;
+
+	case MD_CTL_SET_BITMAP_FILE:
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
+	if (closing && (err || flags == MD_CTL_RO_FLAG))
+		clear_bit(MD_CLOSING, &mddev->flags);
+
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
@@ -10814,12 +11432,19 @@ static int __init md_init(void)
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
@@ -11097,6 +11722,7 @@ static __exit void md_exit(void)
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

