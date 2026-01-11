Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E33134EF19
	for <linux-raid@vger.kernel.org>; Sun, 11 Jan 2026 18:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768156037; cv=none; b=F3HZud4RLrI+S9P/6EMSWkdYeWYTyr01YkImUyKmModZVS6srel0pJgVIFy81dgn5It4xXb+ji03uX+qE4qcA7gAb5sgB9kozMnvO6UKlnpj7WyY+XROJ24wl4tjc63rGibe/A800ZoWymCUZg+btnQizFkqfRZPGIsAwcIUWQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768156037; c=relaxed/simple;
	bh=3fBXdaUolu3Inlk9whpLnOvBb9S9iF3RaDchhqpYzvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0MIwYTyhyhtNsyq/RYxQhJpY/JI4LU4IOpmeF0pr+pBEgfQ6Qblr7uIoYeSsCFo0qDoeDbOJokbHsJ9b6Co3cLtDXyMqGLIYS7Mhybfb0kYzo5Xrmp0YiWWusq20FZahRwnD8ct4pXiiA9UGGmGprDkvYJC7q5DZpgnlPRnfKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C17FC116C6;
	Sun, 11 Jan 2026 18:27:14 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v3 07/11] md: add a helper md_config_align_limits()
Date: Mon, 12 Jan 2026 02:26:47 +0800
Message-ID: <20260111182651.2097070-8-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111182651.2097070-1-yukuai@fnnas.com>
References: <20260111182651.2097070-1-yukuai@fnnas.com>
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
Reviewed-by: Li Nan <linan122@huawei.com>
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
index af48ad2bc723..30a7069cbd0c 100644
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

