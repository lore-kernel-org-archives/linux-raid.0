Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13192556E;
	Sat, 14 Feb 2026 06:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771049423; cv=none; b=F8MlgB2ccizt868qB1tMe2qxnBNCndkjuU/gFxvgZsQXUr2zcdc9cBtQWGwKdkwUrsg8bq6gZJjQLgtlLBGF5yZbDux/ucnyaMbcs4l1WapmIay1lrGJbv8VEE5kGy3c94ZAJiCaPhY0MLRcrBQuh+e7ftkStpEDAF/dA355l70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771049423; c=relaxed/simple;
	bh=TWkCZTMhj/SsTk4NR0HUNeixi+fZzYx7zEdXdlaZV/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzzAwOHHo+5uMNdgQgX3o4fvBSfNEmIluleuK6/e1bVbNLsPRrozjP24QXrsTr/JfKvo0Hz2FM5Q08NoW8TijnZojaN2x08xjEGQqVqj7+dVQEYEgwivuZ53eg6w2u/KzrVhiS/NVwEy+H8k5OoKtHSmdpBURaeoMwOuTYsVoPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9403C19423;
	Sat, 14 Feb 2026 06:10:21 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com,
	colyli@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] md: add fallback to correct bitmap_ops on version mismatch
Date: Sat, 14 Feb 2026 14:10:11 +0800
Message-ID: <20260214061013.2335604-4-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214061013.2335604-1-yukuai@fnnas.com>
References: <20260214061013.2335604-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If default bitmap version and on-disk version doesn't match, and mdadm
is not the latest version to set bitmap_type, set bitmap_ops based on
the disk version.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 59cd303548de..d2607ed5c2e9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6447,15 +6447,116 @@ static void md_safemode_timeout(struct timer_list *t)
 
 static int start_dirty_degraded;
 
+/*
+ * Read bitmap superblock and return the bitmap_id based on disk version.
+ * This is used as fallback when default bitmap version and on-disk version
+ * doesn't match, and mdadm is not the latest version to set bitmap_type.
+ */
+static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+	struct page *sb_page;
+	bitmap_super_t *sb;
+	enum md_submodule_id id = ID_BITMAP_NONE;
+	sector_t sector;
+	u32 version;
+
+	if (!mddev->bitmap_info.offset)
+		return ID_BITMAP_NONE;
+
+	sb_page = alloc_page(GFP_KERNEL);
+	if (!sb_page)
+		return ID_BITMAP_NONE;
+
+	sector = mddev->bitmap_info.offset;
+
+	rdev_for_each(rdev, mddev) {
+		u32 iosize;
+
+		if (!test_bit(In_sync, &rdev->flags) ||
+		    test_bit(Faulty, &rdev->flags) ||
+		    test_bit(Bitmap_sync, &rdev->flags))
+			continue;
+
+		iosize = roundup(sizeof(bitmap_super_t),
+				 bdev_logical_block_size(rdev->bdev));
+		if (sync_page_io(rdev, sector, iosize, sb_page, REQ_OP_READ,
+				 true))
+			goto read_ok;
+	}
+	goto out;
+
+read_ok:
+	sb = kmap_local_page(sb_page);
+	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
+		goto out_unmap;
+
+	version = le32_to_cpu(sb->version);
+	switch (version) {
+	case BITMAP_MAJOR_LO:
+	case BITMAP_MAJOR_HI:
+	case BITMAP_MAJOR_CLUSTERED:
+		id = ID_BITMAP;
+		break;
+	case BITMAP_MAJOR_LOCKLESS:
+		id = ID_LLBITMAP;
+		break;
+	default:
+		pr_warn("md: %s: unknown bitmap version %u\n",
+			mdname(mddev), version);
+		break;
+	}
+
+out_unmap:
+	kunmap_local(sb);
+out:
+	__free_page(sb_page);
+	return id;
+}
+
 static int md_bitmap_create(struct mddev *mddev)
 {
+	enum md_submodule_id orig_id = mddev->bitmap_id;
+	enum md_submodule_id sb_id;
+	int err;
+
 	if (mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
 
 	if (!mddev_set_bitmap_ops(mddev))
 		return -ENOENT;
 
-	return mddev->bitmap_ops->create(mddev);
+	err = mddev->bitmap_ops->create(mddev);
+	if (!err)
+		return 0;
+
+	/*
+	 * Create failed, if default bitmap version and on-disk version
+	 * doesn't match, and mdadm is not the latest version to set
+	 * bitmap_type, set bitmap_ops based on the disk version.
+	 */
+	mddev_clear_bitmap_ops(mddev);
+
+	sb_id = md_bitmap_get_id_from_sb(mddev);
+	if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
+		return err;
+
+	pr_info("md: %s: bitmap version mismatch, switching from %d to %d\n",
+		mdname(mddev), orig_id, sb_id);
+
+	mddev->bitmap_id = sb_id;
+	if (!mddev_set_bitmap_ops(mddev)) {
+		mddev->bitmap_id = orig_id;
+		return -ENOENT;
+	}
+
+	err = mddev->bitmap_ops->create(mddev);
+	if (err) {
+		mddev_clear_bitmap_ops(mddev);
+		mddev->bitmap_id = orig_id;
+	}
+
+	return err;
 }
 
 static void md_bitmap_destroy(struct mddev *mddev)
-- 
2.51.0

