Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BB422F76C
	for <linux-raid@vger.kernel.org>; Mon,  7 Jul 2025 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907185; cv=none; b=FRIu+jDl3TdSO9XLx9PcSFaET/ZnF8bhUo80xl2j15sPHQwAT2JQLrD9MVy/O2H4D/dcqeVAGqObgs7C+Ruwd/YOFmKPXitMzsEh04QF6ssTweCjP3fT6giFLEw56DY9gt2fZJE9WoE6iekAHc6AATyY04KeKJSUN7HCbMrmaD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907185; c=relaxed/simple;
	bh=ICWZcIxaFx0oux04+Z7fIUzn73z3Cwd54buNj+ozS5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGxj/ys75oH9zCEU2yA4B21+O/3AO1KJZ2EPxeUe0XBFmGzJ6UrS1HEEf9EErqfA8Y+n9jneW9MJprjV1QB5IoZQc2v2YIVqxgeEFZtKGRDZqHRppI1DuY4h1aAdL4LG+Pmnht/lNmW7EE5vsHEqT6GG+Pn73xhAg1ulqrpnrEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlK8BxwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlK8BxwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BAEC4CEE3;
	Mon,  7 Jul 2025 16:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751907185;
	bh=ICWZcIxaFx0oux04+Z7fIUzn73z3Cwd54buNj+ozS5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlK8BxwBM4K0o7NKC5GSY75gOjMG4ra86/3zhOjOxLLLtnkgWue7voPMsvSZS3OJE
	 OjWPlPx202tj9Sjfv9SQRYSFJZmUNk4xytvXP4RZNYf9i2h7bpsK/gXPV2JgP0LS52
	 2xdi3GYWrYK6l4g2AaezVgcWvVbDTUL76DPZn02hELety4mNsjJaIAGpG/Nz81eqMC
	 bDpj2UmbqBF7hEYYF2pUxoyhP+ErUx7lwnx9QpdDZSnx6YC19hQhAipEdGAg7QMkwQ
	 /SGUTzG4UmhkaIeVjRE2VB1sRS/CXsEJaPdRaZce6UT5EooX4JwYgO+k7fBUA2sZhW
	 +JYFsbmvY1qBQ==
From: Yu Kuai <yukuai@kernel.org>
To: hch@lst.de,
	hare@suse.de,
	xni@redhat.com,
	axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 03/11] md/md-bitmap: support discard for bitmap ops
Date: Tue,  8 Jul 2025 00:51:54 +0800
Message-ID: <20250707165202.11073-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250707165202.11073-1-yukuai@kernel.org>
References: <20250707165202.11073-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

Use two new methods {start, end}_discard in bitmap_ops and a new field 'rw'
in struct md_io_clone to handle discard IO, prepare to support new md
bitmap.

Since all bitmap functions to hanlde write IO are the same, also add
typedef to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md-bitmap.c |  3 +++
 drivers/md/md-bitmap.h | 12 ++++++++----
 drivers/md/md.c        | 15 +++++++++++----
 drivers/md/md.h        |  1 +
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 3c8b8ecf0695..0eb3774f372d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -3006,6 +3006,9 @@ static struct bitmap_operations bitmap_ops = {
 
 	.start_write		= bitmap_start_write,
 	.end_write		= bitmap_end_write,
+	.start_discard		= bitmap_start_write,
+	.end_discard		= bitmap_end_write,
+
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
 	.cond_end_sync		= bitmap_cond_end_sync,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 42f91755a341..8616ced49077 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -61,6 +61,9 @@ struct md_bitmap_stats {
 	struct file	*file;
 };
 
+typedef void (md_bitmap_fn)(struct mddev *mddev, sector_t offset,
+			    unsigned long sectors);
+
 struct bitmap_operations {
 	struct md_submodule_head head;
 
@@ -81,10 +84,11 @@ struct bitmap_operations {
 	void (*end_behind_write)(struct mddev *mddev);
 	void (*wait_behind_writes)(struct mddev *mddev);
 
-	void (*start_write)(struct mddev *mddev, sector_t offset,
-			    unsigned long sectors);
-	void (*end_write)(struct mddev *mddev, sector_t offset,
-			  unsigned long sectors);
+	md_bitmap_fn *start_write;
+	md_bitmap_fn *end_write;
+	md_bitmap_fn *start_discard;
+	md_bitmap_fn *end_discard;
+
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1db7af64184d..efb38b9cfbd0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8858,18 +8858,24 @@ EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 static void md_bitmap_start(struct mddev *mddev,
 			    struct md_io_clone *md_io_clone)
 {
+	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
+			   mddev->bitmap_ops->start_discard :
+			   mddev->bitmap_ops->start_write;
+
 	if (mddev->pers->bitmap_sector)
 		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
 					   &md_io_clone->sectors);
 
-	mddev->bitmap_ops->start_write(mddev, md_io_clone->offset,
-				       md_io_clone->sectors);
+	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
 static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 {
-	mddev->bitmap_ops->end_write(mddev, md_io_clone->offset,
-				     md_io_clone->sectors);
+	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
+			   mddev->bitmap_ops->end_discard :
+			   mddev->bitmap_ops->end_write;
+
+	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
 static void md_end_clone_io(struct bio *bio)
@@ -8908,6 +8914,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
+		md_io_clone->rw = op_stat_group(bio_op(*bio));
 		md_bitmap_start(mddev, md_io_clone);
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 72bce59376d7..8452aaa2295d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -872,6 +872,7 @@ struct md_io_clone {
 	unsigned long	start_time;
 	sector_t	offset;
 	unsigned long	sectors;
+	enum stat_group	rw;
 	struct bio	bio_clone;
 };
 
-- 
2.43.0

