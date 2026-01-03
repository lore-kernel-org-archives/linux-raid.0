Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88B630E829
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 15:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455184; cv=none; b=tmbHo80W3UIiUyEmAmiKA3MuRzhR6fL0pPuRG2wnqPYHvFMh9CTO7oXEUVOWsuhRRfD0Z4NpOqFLLRlRJPKvN2f0r5x8FpxHIDwv/zUU41oh4O1TlS9C+vn/xI+R+AlL1K8REMLFZ61y8rvBc475MFYI4ECZCQzA3vDVOhnuKNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455184; c=relaxed/simple;
	bh=FuH4wGnKz/AxuzEeA3Ce/JCmu28kNvAsL7XWn03da9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TW7kASoYoG1nIJPsuyRvEjpU5AInCGMcMyndY1e9OWpeEm6kN5gWjg66959SWhyVx7r826uSjmEzB8J/3PGSjia8ftgtFq8YXZueGoHaOj75/uWd/J2JYsaHAWSnMEb7fhNBWwDtgUvUlNRjRtV59bBX66wL8ovYagwZ7j/cm8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A16AC113D0;
	Sat,  3 Jan 2026 15:46:20 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	colyli@fnnas.com,
	linan122@huawei.com
Subject: [PATCH v2 07/11] md: add a helper md_config_align_limits()
Date: Sat,  3 Jan 2026 23:45:39 +0800
Message-ID: <20260103154543.832844-8-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260103154543.832844-1-yukuai@fnnas.com>
References: <20260103154543.832844-1-yukuai@fnnas.com>
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
index d83b2b1c0049..f3814a69cd13 100644
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
index db0afb0b70e8..005a2404de27 100644
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

