Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1BE2D9492;
	Mon, 24 Nov 2025 06:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965942; cv=none; b=O2NC11wGTeuQOrz/WroBXFmodITsXNnAPIzWaOZd9+gQ1ByqpShblbUJ+Xg18fV+PoFsTul80/M5OMjbPr7Hj+Lrt0eVXukCBedBfgVSvw7nzLFMpAH1FJ0GHpjJhe9T9vKNqCWShrsimY9eehiT1N5KZvf9X1kpGZLJhkSPnBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965942; c=relaxed/simple;
	bh=XqqQSI5xgpGNLdeTJz2ljmD1xJP37tkjVNb/x31AvmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRmJHY9gV2U/7BrUNoStMVRv3Glsm4gm6YAt2sAcac09FGtYmP48iJlKrrD9O+gMqJZi1NwjQC9P2kImHFWMciOukziGiPlpwP/TtpRR8wmoSHV2oN4sihUuRsbiU2RXkLfgcxajsgZBNpha4u/Xft5PDcN54OBwe+cn2NCeprk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C53C4CEF1;
	Mon, 24 Nov 2025 06:32:20 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	filippo@debian.org,
	colyli@fnnas.com,
	yukuai@fnnas.com
Subject: [PATCH v2 07/11] md: add a helper md_config_align_limits()
Date: Mon, 24 Nov 2025 14:31:59 +0800
Message-ID: <20251124063203.1692144-8-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124063203.1692144-1-yukuai@fnnas.com>
References: <20251124063203.1692144-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This helper will be used by personalities that want to align bio to
io_opt to get best IO bandwidth.

Also add the new flag to UNSUPPORTED_MDDEV_FLAGS for now, following
patches will enable this for personalities.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.h    | 11 +++++++++++
 drivers/md/raid0.c |  3 ++-
 drivers/md/raid1.c |  3 ++-
 drivers/md/raid5.c |  3 ++-
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index e7aba83b708b..ddf989f2a139 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1091,6 +1091,17 @@ static inline bool rdev_blocked(struct md_rdev *rdev)
 	return false;
 }
 
+static inline void md_config_align_limits(struct mddev *mddev,
+					  struct queue_limits *lim)
+{
+	if ((lim->max_hw_sectors << 9) < lim->io_opt)
+		lim->max_hw_sectors = lim->io_opt >> 9;
+	else
+		lim->max_hw_sectors = rounddown(lim->max_hw_sectors,
+						lim->io_opt >> 9);
+	set_bit(MD_BIO_ALIGN, &mddev->flags);
+}
+
 #define mddev_add_trace_msg(mddev, fmt, args...)			\
 do {									\
 	if (!mddev_is_dm(mddev))					\
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index bf1f3ab59c83..01cce0c3eab7 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -29,7 +29,8 @@ module_param(default_layout, int, 0644);
 	 (1L << MD_HAS_PPL) |		\
 	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
 	 (1L << MD_FAILLAST_DEV) |	\
-	 (1L << MD_SERIALIZE_POLICY))
+	 (1L << MD_SERIALIZE_POLICY) |	\
+	 (1L << MD_BIO_ALIGN))
 
 /*
  * inform the user of the raid configuration
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f4c7004888af..1a957dba2640 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -42,7 +42,8 @@
 	((1L << MD_HAS_JOURNAL) |	\
 	 (1L << MD_JOURNAL_CLEAN) |	\
 	 (1L << MD_HAS_PPL) |		\
-	 (1L << MD_HAS_MULTIPLE_PPLS))
+	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
+	 (1L << MD_BIO_ALIGN))
 
 static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
 static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cd0eff2f69b4..0b607aa5963e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -59,7 +59,8 @@
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_FAILFAST_SUPPORTED) |	\
 	 (1L << MD_FAILLAST_DEV) |		\
-	 (1L << MD_SERIALIZE_POLICY))
+	 (1L << MD_SERIALIZE_POLICY) |		\
+	 (1L << MD_BIO_ALIGN))
 
 
 #define cpu_to_group(cpu) cpu_to_node(cpu)
-- 
2.51.0

