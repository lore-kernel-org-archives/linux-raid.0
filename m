Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25C428469F;
	Sun, 19 Apr 2026 03:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568196; cv=none; b=enJpeagwk4BlWQw+KpQnwpN3MkzAyaTigp1NHU2fO9C8DoI4IUmh8gYKN5kWlZ7BBJ6sZxxBx2k16a5i0Ewljxtggyh9JN21RX5HPKpwwNllvzbPTlV//0KgJeM76oRAJ4crFDvFN1ciCMlIQcUg2zVkwggT8p+yTZgNiuXKYJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568196; c=relaxed/simple;
	bh=qOcUS+TSCVcfUPh/1ByXl0BCauAEI0szb2rP5C2QIVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0m4Ke5xu+r5W/2yTpQL8zqfJK+lF6G+APTS7qbFv/tMQNLaud6FFD/9KagJ/A96AuacwpoeeChMwqF1ExxpatwB+UXOMmLjh7NPGXbmeTQTwqRQpc02X5mWJ31/2cgJFV7gfnc50FEmbrnrEJuagddI5zl/cntfExSnLll3eRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A387C2BCB6;
	Sun, 19 Apr 2026 03:09:54 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md: add exact bitmap mapping and reshape hooks
Date: Sun, 19 Apr 2026 11:09:24 +0800
Message-ID: <20260419030942.824195-2-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419030942.824195-1-yukuai@fnnas.com>
References: <20260419030942.824195-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bitmap mapping and reshape hooks needed by llbitmap reshape
support without teaching md core to account a single bio against
multiple bitmap ranges.

This also adds the old/new bitmap geometry helpers used by
personalities to describe reshape mapping to llbitmap.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-bitmap.c   |  8 ++++++++
 drivers/md/md-bitmap.h   |  8 ++++++++
 drivers/md/md-llbitmap.c |  8 ++++++++
 drivers/md/md.c          | 12 ++++++++----
 drivers/md/md.h          |  4 ++++
 5 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 83378c033c72..69b3f5fc6bc0 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1728,6 +1728,13 @@ static void bitmap_start_write(struct mddev *mddev, sector_t offset,
 	}
 }
 
+static void bitmap_prepare_range(struct mddev *mddev, sector_t *offset,
+				 unsigned long *sectors)
+{
+	if (mddev->pers->bitmap_sector)
+		mddev->pers->bitmap_sector(mddev, offset, sectors);
+}
+
 static void bitmap_end_write(struct mddev *mddev, sector_t offset,
 			     unsigned long sectors)
 {
@@ -2987,6 +2994,7 @@ static struct bitmap_operations bitmap_ops = {
 	.flush			= bitmap_flush,
 	.write_all		= bitmap_write_all,
 	.dirty_bits		= bitmap_dirty_bits,
+	.prepare_range		= bitmap_prepare_range,
 	.unplug			= bitmap_unplug,
 	.daemon_work		= bitmap_daemon_work,
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b42a28fa83a0..8edc7218a1f4 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -93,6 +93,14 @@ struct bitmap_operations {
 	void (*write_all)(struct mddev *mddev);
 	void (*dirty_bits)(struct mddev *mddev, unsigned long s,
 			   unsigned long e);
+	/* Prepare a range for this bitmap implementation. */
+	void (*prepare_range)(struct mddev *mddev,
+			      sector_t *offset,
+			      unsigned long *sectors);
+	void (*reshape_finish)(struct mddev *mddev);
+	int (*reshape_can_start)(struct mddev *mddev);
+	void (*reshape_mark)(struct mddev *mddev, sector_t old_pos,
+			     sector_t new_pos);
 	void (*unplug)(struct mddev *mddev, bool sync);
 	void (*daemon_work)(struct mddev *mddev);
 
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index cdfecaca216b..62b8f3efa9f5 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1061,6 +1061,13 @@ static void llbitmap_destroy(struct mddev *mddev)
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
 
+static void llbitmap_prepare_range(struct mddev *mddev, sector_t *offset,
+				   unsigned long *sectors)
+{
+	if (mddev->pers->bitmap_sector)
+		mddev->pers->bitmap_sector(mddev, offset, sectors);
+}
+
 static void llbitmap_start_write(struct mddev *mddev, sector_t offset,
 				 unsigned long sectors)
 {
@@ -1596,6 +1603,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.update_sb		= llbitmap_update_sb,
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
+	.prepare_range		= llbitmap_prepare_range,
 	.write_all		= llbitmap_write_all,
 
 	.group			= &md_llbitmap_group,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c9597c6bd341..5b001e3e4cec 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9301,6 +9301,12 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
+static void md_bitmap_prepare_range(struct mddev *mddev, sector_t *offset,
+				    unsigned long *sectors)
+{
+	mddev->bitmap_ops->prepare_range(mddev, offset, sectors);
+}
+
 static void md_bitmap_start(struct mddev *mddev,
 			    struct md_io_clone *md_io_clone)
 {
@@ -9308,10 +9314,8 @@ static void md_bitmap_start(struct mddev *mddev,
 			   mddev->bitmap_ops->start_discard :
 			   mddev->bitmap_ops->start_write;
 
-	if (mddev->pers->bitmap_sector)
-		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
-					   &md_io_clone->sectors);
-
+	md_bitmap_prepare_range(mddev, &md_io_clone->offset,
+				&md_io_clone->sectors);
 	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd..82a36bdaeaaa 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -793,6 +793,10 @@ struct md_personality
 	/* convert io ranges from array to bitmap */
 	void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
 			      unsigned long *sectors);
+	void (*bitmap_sector_map)(struct mddev *mddev, sector_t *offset,
+				  unsigned long *sectors, bool previous);
+	sector_t (*bitmap_sync_size)(struct mddev *mddev, bool previous);
+	sector_t (*bitmap_array_sectors)(struct mddev *mddev, bool previous);
 };
 
 struct md_sysfs_entry {
-- 
2.51.0

