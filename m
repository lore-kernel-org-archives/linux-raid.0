Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B824C6F18;
	Fri,  5 Jun 2026 09:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650935; cv=none; b=M1kNPPx+3bG0lZpukyQEjFeH8OVVAbFeMeTQSYdb1R+piaZwodWPaTFPfpAROshD3iBBAU4QxwQ8B0gf0g3fFpT2dnATjZBTSIcoe+xh41WRf3uM2wz1f7vfMj0bo+OD1GTqa9k7J1MfL86yZqRGnU8augcbsWVuocpKhVOdoWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650935; c=relaxed/simple;
	bh=6TWKgVCLN+ZtQxMRpFB3X7CM5C4b3tz9RfhbkysMtzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Klh/rBVGG8cR0oeHc1MM0ZGLvqlyaw83U2iUGdRg3V+XKQ+ovP4/xudHAb22AGK5cNF0tcDV5bFtOKcf3U2kqAHNif+P2EFif8B5UkXP5482Q7CeZf3ZnJ6JPDxcBCy/O9xW5dN2Owq8PHDyxoydWljxHe6pQa6t1OaqgJr0BD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsR14doP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsR14doP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90381F00898;
	Fri,  5 Jun 2026 09:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650933;
	bh=igZA1XcYA/kYv/zfHEqFkoYAL+LZa3ydhAHjKfT7rGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MsR14doPEKlqlXNDN20NdGiw07UA2eEH5puMymTddM1Roncxdk+fCo5g156a+Df/4
	 NW9iR7Ia3l4jn70REaajqqVlYcJHQmYg14HR5RAjoYLhhysjF/3sj6gE9CbMhglDUt
	 3co7eRisX8m8g6gMESQHS0WqdHKJ1mPfR/FDS7jDBEyyjqhWRzIsbski3AhHR9obhp
	 JeTj45C0BADRXYyBX5lAhbYoaPeQlleMtOQY7pHJrAbyASnrzRx5MRlEJ+u3/t9UY8
	 ZE2dERlxhwTj7zq7Xu0QvDwXc5cwOfJCbH57s5p2AfZRWYAvCl1qV48MMjAQpM3sIe
	 X+9dTn5d/AHsQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md: add exact bitmap mapping and reshape hooks
Date: Fri,  5 Jun 2026 17:15:08 +0800
Message-ID: <20260605091527.2463539-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Add bitmap mapping and reshape hooks needed by llbitmap reshape
support without teaching md core to account a single bio against
multiple bitmap ranges.

This also adds the old/new bitmap geometry helpers used by
personalities to describe reshape mapping to llbitmap.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-bitmap.c   |  8 ++++++++
 drivers/md/md-bitmap.h   |  8 ++++++++
 drivers/md/md-llbitmap.c |  8 ++++++++
 drivers/md/md.c          | 12 ++++++++----
 drivers/md/md.h          |  4 ++++
 5 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 028b9ca8ce52..e10296788cdd 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1727,10 +1727,17 @@ static void bitmap_start_write(struct mddev *mddev, sector_t offset,
 		else
 			sectors = 0;
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
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -3075,10 +3082,11 @@ static struct bitmap_operations bitmap_ops = {
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
 	.write_all		= bitmap_write_all,
 	.dirty_bits		= bitmap_dirty_bits,
+	.prepare_range		= bitmap_prepare_range,
 	.unplug			= bitmap_unplug,
 	.daemon_work		= bitmap_daemon_work,
 
 	.start_behind_write	= bitmap_start_behind_write,
 	.end_behind_write	= bitmap_end_behind_write,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 214f623c7e79..f0136fc02feb 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -91,10 +91,18 @@ struct bitmap_operations {
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
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
 
 	void (*start_behind_write)(struct mddev *mddev);
 	void (*end_behind_write)(struct mddev *mddev);
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1adc5b117821..bcf34f0c9af6 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1186,10 +1186,17 @@ static void llbitmap_destroy(struct mddev *mddev)
 	llbitmap_free_pages(llbitmap);
 	kfree(llbitmap);
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
 	struct llbitmap *llbitmap = mddev->bitmap;
 	unsigned long start = offset >> llbitmap->chunkshift;
@@ -1775,10 +1782,11 @@ static struct bitmap_operations llbitmap_ops = {
 	.cond_end_sync		= llbitmap_cond_end_sync,
 
 	.update_sb		= llbitmap_update_sb,
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
+	.prepare_range		= llbitmap_prepare_range,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
 };
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 096bb64e87bd..08eabc7e5a71 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9359,21 +9359,25 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 	mddev_trace_remap(mddev, discard_bio, bio->bi_iter.bi_sector);
 	submit_bio_noacct(discard_bio);
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
 	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
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
 
 static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8daf0f75cbb..110cf0f8b107 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -796,10 +796,14 @@ struct md_personality
 	/* Changes the consistency policy of an active array. */
 	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
 	/* convert io ranges from array to bitmap */
 	void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
 			      unsigned long *sectors);
+	void (*bitmap_sector_map)(struct mddev *mddev, sector_t *offset,
+				  unsigned long *sectors, bool previous);
+	sector_t (*bitmap_sync_size)(struct mddev *mddev, bool previous);
+	sector_t (*bitmap_array_sectors)(struct mddev *mddev, bool previous);
 };
 
 struct md_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct mddev *, char *);
-- 
2.51.0

