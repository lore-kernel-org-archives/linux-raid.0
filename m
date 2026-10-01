Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3AF3AEF56
	for <linux-raid@vger.kernel.org>; Thu,  1 Oct 2026 12:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859387; cv=none; b=GWb1deq1coXhj1ESZsCN/JVTGIPncwi8fQ55Ggp/Zt0q88iRKUbQ4jyVvZZjRP9sVsvmcju5JgrF106t0ZLdUnywvglva3EdXhRzZbBTESWzee1uKt0s6OwmlE1YoyOnGO+gkvaPlLa/kJVeTo70E8yI9GG4VSPzlQt12rU/GPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859387; c=relaxed/simple;
	bh=WykIBLd1uoDcKaOVAWtucoJFSXLYzoF6IaQWYpcp7DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VptPxLEr40h0POBUiASnYQ3pk6bYsl0OSzJ35NnABLqD0bbxvn8bmkXE88Kj5VVhqdCeErHJgknXeODm21uJFZopFu61aZ9b3K7ZvGnHZ/HDZDZMJGQG0NxCac0wuLEZBQumLK6JtxPALzqr4wuMFQqgJ/C7ES9Sxun1QxOLUz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DlzInQ8O; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlzInQ8O"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b0591cf85so686522f8f.0
        for <linux-raid@vger.kernel.org>; Thu, 01 Oct 2026 05:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790859384; x=1791464184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q5pmn5Sgmp7NX1gR5GLCnP5AX0iw6ctA6iDoCPY0hq8=;
        b=DlzInQ8Oquip2rJ+pCfxZyWYaj13vIj1uwd/ibAuueAJUu2EMGxjMW6NiUjVyohadC
         b5a/tevJmhxDtbUUhOMEWeDKzq1l9qnf/VnBKkyCUdbl0wjBPL0lb5jEeV6ruLTcwxfy
         5PSx3MNnghk3myrF2Ns7Tn3eSwAkHLGlLlizQfl/MLajqypTnHSTBMO8MFYlry3Q1p7z
         ptqpnyxUFo/njqy2qxayBOpdeKtFuWYcZ67EkEP/IgaqZbot2xdLKjyyMs5aqgTvKJI/
         iN5bBO/rhHHAh/hmBDu2lx+v5ysg3U9++8phHqflKpbAQMDu2QGWDMbrcTWRZmagBbtB
         msjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790859384; x=1791464184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q5pmn5Sgmp7NX1gR5GLCnP5AX0iw6ctA6iDoCPY0hq8=;
        b=juSiVI3s2DWwLXas2rqqbCJc+eBenyy8uegxNc4yb7EIkyzLUtgkJhSiarZxqOTmJK
         zf36k5T7cskJj3jd8Nhe30Tf1umeAlqJW9nWY8FiNs0NLc/RIrRROe1sIlCZZlzjoH7L
         6GNYifgQdmQeCSQeHiTXaLOD6IMPWJby8s1ur7UDeyd6DhOh9W5ilSwAeDZMRm72XiIZ
         x6ycRoClpdnEHWJwlJZ1yzsAM2/W9oflBjNL3gfrlnT5OlZuqfd3z7h/FG5nGSAT2jVK
         W6J/jTblLX6XUUzWa1UsMat+AVK7oi1OyjfxV09e6I9QxmHk0bNiMFSB9N6xz7gA+1GU
         B2Mw==
X-Gm-Message-State: AFuF++kFbtuYz3sTSf77t8WXGfaAUuuthPb1yz5IF4tCVINtzDPIi2QF
	ctKY6UQh0SWHnq1imjc1RD5kIWjAM40G4O//xnlOiuzQ1mZ8CHY0cmZD
X-Gm-Gg: AYBFou1udowZ3w1RVwLO6FcuphnSHz7ZkCr5L9OV66yzIHwhckQYK+VVu9HTbYkbZ2r
	VBBeigsuCkU5fujeVgaaWZQcHzFp8z5YyW3qxjpkYpYe/8X+Ygov6S5eF30kzdX41rt+0y/VbO5
	GZ6XWAVp2gZCrg6f3+76D9ych/YdJO5Y4p9RIu2AKjlWoVAdxIW9EfC0PD8hNaAsplxsnlgGwQY
	hJ3Xw9rJCGzD4ofqDMRBAcBxS26EWLbvgpNB/oQcB34QmUFPJhYb5DLeRZ3m0Ojiv+s5u8EH/q+
	yWPk9ICaNiZZ1YCBCMZc6tspgzDLHZjsSwQ/85/16ias0TYipfTw9gReeb8PkGlCNPSPM8MdSqm
	AXlVpVSofC9DYzvCdRSNZm144d8Uy/3E5kuhZfQT7/ui2MxetihaS8ZbL/YC1rcWxKCwBrqhrv8
	GjM5u+z9axd6fdlb+xLYDruVEi8hvoMs0bSJmwz4bIM1Sv+9yBMNQtTly1kD1SXMRVz8kScfmbW
	PjKEWceibvsBQSIdTQB1DXkCSOSgMMcQEFRME2h6TJENcs=
X-Received: by 2002:a05:600c:3145:b0:49f:ce73:7a9 with SMTP id 5b1f17b1804b1-4a01b0072cfmr77011125e9.34.1790859383454;
        Thu, 01 Oct 2026 05:56:23 -0700 (PDT)
Received: from env.. (dynamic-176-003-078-112.176.3.pool.telefonica.de. [176.3.78.112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f9a7650sm68298735e9.15.2026.10.01.05.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 05:56:22 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	chengzhihao1@huawei.com,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [RFC PATCH v2 2/4] md: pass struct mdu_disk_info64 to md_add_new_disk()
Date: Thu,  1 Oct 2026 12:56:09 +0000
Message-ID: <20261001125611.943731-3-abd.masalkhi@gmail.com>
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

The md control device passes disk information as struct mdu_disk_info64.
Make md_add_new_disk() take this structure, so that the control device
and the old ADD_NEW_DISK ioctl can share it.

The ADD_NEW_DISK ioctl converts its mdu_disk_info_t with the new helper
convert_to_disk_info64(), and md_setup_drive() uses a struct
mdu_disk_info64 directly.

No functional change.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md-autodetect.c |  2 +-
 drivers/md/md.c            | 26 +++++++++++++++++++++-----
 drivers/md/md.h            |  4 ++--
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 4b80165afd23..9ba061f1a628 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -201,7 +201,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	err = md_set_array_info(mddev, &ainfo);
 
 	for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
-		struct mdu_disk_info_s dinfo = {
+		struct mdu_disk_info64 dinfo = {
 			.major	= MAJOR(devices[i]),
 			.minor	= MINOR(devices[i]),
 		};
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 154ee5a65cb7..be1634ae1d09 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7486,7 +7486,7 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 	return 0;
 }
 
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info64 *info)
 {
 	struct md_rdev *rdev;
 	dev_t dev = MKDEV(info->major,info->minor);
@@ -8305,6 +8305,16 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
 	}
 }
 
+static void convert_to_disk_info64(struct mdu_disk_info64 *info64,
+				   mdu_disk_info_t *info)
+{
+	info64->number = info->number;
+	info64->major = info->major;
+	info64->minor = info->minor;
+	info64->raid_disk = info->raid_disk;
+	info64->state = info->state;
+}
+
 static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 {
 	mdu_array_info_t info;
@@ -8452,13 +8462,16 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		 */
 		if (mddev->pers) {
 			mdu_disk_info_t info;
+			struct mdu_disk_info64 info64 = {0};
 			if (copy_from_user(&info, argp, sizeof(info)))
 				err = -EFAULT;
 			else if (!(info.state & (1<<MD_DISK_SYNC)))
 				/* Need to clear read-only for this */
 				break;
-			else
-				err = md_add_new_disk(mddev, &info);
+			else {
+				convert_to_disk_info64(&info64, &info);
+				err = md_add_new_disk(mddev, &info64);
+			}
 			goto unlock;
 		}
 		break;
@@ -8493,10 +8506,13 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	case ADD_NEW_DISK:
 	{
 		mdu_disk_info_t info;
+		struct mdu_disk_info64 info64 = {0};
 		if (copy_from_user(&info, argp, sizeof(info)))
 			err = -EFAULT;
-		else
-			err = md_add_new_disk(mddev, &info);
+		else {
+			convert_to_disk_info64(&info64, &info);
+			err = md_add_new_disk(mddev, &info64);
+		}
 		goto unlock;
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6440da292105..a84c8b97fa2c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1043,12 +1043,12 @@ static inline void mddev_unlock_and_resume(struct mddev *mddev)
 }
 
 struct mdu_array_info_s;
-struct mdu_disk_info_s;
+struct mdu_disk_info64;
 
 extern int mdp_major;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
-int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info64 *info);
 int do_md_run(struct mddev *mddev);
 #define MDDEV_STACK_INTEGRITY	(1u << 0)
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
-- 
2.43.0

