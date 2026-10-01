Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE5E49A3D6
	for <linux-raid@vger.kernel.org>; Thu,  1 Oct 2026 12:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859390; cv=none; b=Ni2ytkjWB5+ebOb4IgWCdW5FvxN8lUU0MOXheDiNFzFhCGmt/XCxyKcUTRWR3119M8N20mRz7FJ9545qriSz7wXJzk5o9liHEV8Q1hW3FT1psWRsDN9EYgCBrYaOTLzRkSj+zV3Py6CRDyzYS2bMxwGb4ULnz74tUUaFbsUJlco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859390; c=relaxed/simple;
	bh=gtEqzIv9LvFXBExNBgPfWChPIVAnd7qOydzmBMD7E/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atJTVFBB6WNR7ysZlSqvazCuyhJjEvGDgR+vD8xP2/yi817YCHa3Fmoyxye/ihniouVWI9+XvLyCJG6a6eFGnOtlHP4D/XGwHxeLiUIs7uPt8+4dJmdy4KQzD19UIR1p1LHFo3Ex8gI+4KMHNF9m7JRSHGfMVqUSnBC0q/hOico=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dxhAmmoo; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxhAmmoo"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a00713639cso34251315e9.1
        for <linux-raid@vger.kernel.org>; Thu, 01 Oct 2026 05:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790859387; x=1791464187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UW3x6tj4hDemkgnzrO8AKf3M0VPWgFFfVLp0HAI0vjU=;
        b=dxhAmmooQC0K4sREytqSs5TvI+DClLdbktEBcn7JB3r3NuJSDyIj3RCIF9elfXH4Bi
         Ye4Fa6a2dOtq/akEReciyYi4n/dgfVEa1eOX9MS4xZOL56r8GlPIpaKjp/UyDcdjm6w6
         9hUxv31Zgt8jN9MZ3HCyQUqo5UyAgeSNF3KPfKKrUYPlUZg5YhwTM4JL5bc/v2qmj9/h
         MgBm0F8arix3UUXDvKIZrBPlnixVl/SaJY2aI1g2RxHj5cFt/raoI/vXlaeySgdOQyAG
         tj1VghrIVzVH+9EJjjJ/FKU5mRROqktXS/gvv/H4nRqDrrhq9dWH+hJzIvcoR//2l6rL
         Xgcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790859387; x=1791464187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UW3x6tj4hDemkgnzrO8AKf3M0VPWgFFfVLp0HAI0vjU=;
        b=oIt5LrntLbpIrsXk9V6wS9MQNuz8phol0Hr/JbJj4qyfGnOXMUpHhqGlxGy7PBHSgs
         QI6u07R4JMLhIYfFc44wrNXAQz56n4XQY6ICSiRKJEZhU32myeV/oIPYHxBC5OmTgnI+
         LS+icfTOsOEY9YURm1HG9lwljemvskeVYBVxeucQpRrRBo2kPRAd0fB58egIZkYRTMiV
         d4lJEqNlrTXJZ/zqYGnSx0owDow4YGVnCzxdJLnqHw6PzfYpJRjFcLG5oDg0hxp8eJWg
         RkUMGDXhxoGX8lF43Lygn+SZ6d5gHdARc60C45dBGOfyq2yH8843f56upFY0Lwz/2q5m
         rbAQ==
X-Gm-Message-State: AFuF++nQSGEWVPcD2H2nGkEmoKHdWghbQ9pzEvOPPYMsRiurN58ntf/5
	79QPGM+mALvZmNPW0dZuGmJjjLwmm8Qstox8wfBgAKXYUtKKuSyQmbKj
X-Gm-Gg: AYBFou0ScXVTvU1ee/oOfYnLClP8HfGHUr/1RXoxM2BLKXpAZ5uMqTs6+paEGurBAh5
	fy8ZMT3Qb2JnBvQ9LvBhLuhLHV7/1wu0x+CCuO+1KNpTpB3/IUm8pL9gus5k0xNAzt+Kk45tm/s
	g4eKUitna+onywQDzKjfheeOPSJK9eBkKzLbYiCdBg/TRyPTsi+eOs7VQvWRY5hszU9XMXPQZKn
	v4XeOgCupBfpqh6GQIGjipjs0eCsYL4ox4yyw082AwdBAYgQosMaT7nxPSXLLFzDGE3L4jUbIAt
	OcNLY5mXvgGjj5sDbClAFj71G9HuwHsbBql0upkx6hwdqKUydYHMfMX6WUsYjBjX0KOZMitv7bR
	D6qC9rnbf+ESaGBAzsvLKpPrFWkz0Nca/UEHbbwtWKwHlAZxcj4LDiPxIpuzeBJE1vppAwfHP/3
	27mloSiRw29VMcQf5hffi/RWdvBpcwyCN3ak9ScSz2xbWIlmCyCIqH/an2yuiW7d4MAJdQVqoRA
	hnjmlK5WTgaW8T30dM9yjJjKXcyHpGpKj2zvBgUyWFILNM=
X-Received: by 2002:a05:600c:45d3:b0:4a0:4f6:3dc5 with SMTP id 5b1f17b1804b1-4a01affe4camr69137855e9.7.1790859386982;
        Thu, 01 Oct 2026 05:56:26 -0700 (PDT)
Received: from env.. (dynamic-176-003-078-112.176.3.pool.telefonica.de. [176.3.78.112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f9a7650sm68298735e9.15.2026.10.01.05.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 05:56:25 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	chengzhihao1@huawei.com,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [RFC PATCH v2 3/4] md: use struct mdu_array_info64 for SET_ARRAY_INFO
Date: Thu,  1 Oct 2026 12:56:10 +0000
Message-ID: <20261001125611.943731-4-abd.masalkhi@gmail.com>
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

The md control device passes array information as struct
mdu_array_info64. Make md_set_array_info() and update_array_info()
take the new struct mdu_array_info64, so that the md control device
and the old SET_ARRAY_INFO ioctl can share them.

md_set_array_info() no longer checks for a negative major_version:
the field is unsigned now, and the existing check against the size
of super_types still rejects such values.

md_setup_drive() uses a struct mdu_array_info64 directly.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md-autodetect.c |  2 +-
 drivers/md/md.c            | 37 +++++++++++++++++++++++++++++++------
 drivers/md/md.h            |  4 ++--
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 9ba061f1a628..227cd4a688a5 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -124,7 +124,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 {
 	char *devname = args->device_names;
 	dev_t devices[MD_SB_DISKS + 1], mdev;
-	struct mdu_array_info_s ainfo = { };
+	struct mdu_array_info64 ainfo = { };
 	struct mddev *mddev;
 	int err = 0, i;
 	char name[16];
diff --git a/drivers/md/md.c b/drivers/md/md.c
index be1634ae1d09..63b9468285b0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7904,12 +7904,11 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
  *  The minor and patch _version numbers are also kept incase the
  *  super_block handler wishes to interpret them.
  */
-int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
+int md_set_array_info(struct mddev *mddev, struct mdu_array_info64 *info)
 {
 	if (info->raid_disks == 0) {
 		/* just setting version number for superblock loading */
-		if (info->major_version < 0 ||
-		    info->major_version >= ARRAY_SIZE(super_types) ||
+		if (info->major_version >= ARRAY_SIZE(super_types) ||
 		    super_types[info->major_version].name == NULL) {
 			/* maybe try to auto-load a module? */
 			pr_warn("md: superblock version %d not known\n",
@@ -8101,7 +8100,7 @@ static void put_cluster_ops(struct mddev *mddev)
  * Any differences that cannot be handled will cause an error.
  * Normally, only one change can be managed at a time.
  */
-static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
+static int update_array_info(struct mddev *mddev, struct mdu_array_info64 *info)
 {
 	int rv = 0;
 	int cnt = 0;
@@ -8315,9 +8314,33 @@ static void convert_to_disk_info64(struct mdu_disk_info64 *info64,
 	info64->state = info->state;
 }
 
+static void convert_to_array_info64(struct mdu_array_info64 *info64,
+				    mdu_array_info_t *info)
+{
+	info64->major_version = info->major_version;
+	info64->minor_version = info->minor_version;
+	info64->patch_version = info->patch_version;
+	info64->level = info->level;
+	info64->ctime = info->ctime;
+	info64->size = info->size;
+	info64->nr_disks = info->nr_disks;
+	info64->raid_disks = info->raid_disks;
+	info64->md_minor = info->md_minor;
+	info64->not_persistent = info->not_persistent;
+	info64->utime = info->utime;
+	info64->state = info->state;
+	info64->active_disks = info->active_disks;
+	info64->working_disks = info->working_disks;
+	info64->failed_disks = info->failed_disks;
+	info64->spare_disks = info->spare_disks;
+	info64->layout = info->layout;
+	info64->chunk_size = info->chunk_size;
+}
+
 static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 {
 	mdu_array_info_t info;
+	struct mdu_array_info64 info64 = {0};
 	int err;
 
 	if (!argp)
@@ -8325,8 +8348,10 @@ static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 	else if (copy_from_user(&info, argp, sizeof(info)))
 		return -EFAULT;
 
+	convert_to_array_info64(&info64, &info);
+
 	if (mddev->pers) {
-		err = update_array_info(mddev, &info);
+		err = update_array_info(mddev, &info64);
 		if (err)
 			pr_warn("md: couldn't update array info. %d\n", err);
 		return err;
@@ -8342,7 +8367,7 @@ static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 		return -EBUSY;
 	}
 
-	err = md_set_array_info(mddev, &info);
+	err = md_set_array_info(mddev, &info64);
 	if (err)
 		pr_warn("md: couldn't set array info. %d\n", err);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a84c8b97fa2c..27de34a8bdf9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1042,12 +1042,12 @@ static inline void mddev_unlock_and_resume(struct mddev *mddev)
 	mddev_resume(mddev);
 }
 
-struct mdu_array_info_s;
+struct mdu_array_info64;
 struct mdu_disk_info64;
 
 extern int mdp_major;
 void md_autostart_arrays(int part);
-int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
+int md_set_array_info(struct mddev *mddev, struct mdu_array_info64 *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info64 *info);
 int do_md_run(struct mddev *mddev);
 #define MDDEV_STACK_INTEGRITY	(1u << 0)
-- 
2.43.0

