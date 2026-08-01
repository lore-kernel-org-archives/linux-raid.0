Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6AC338595;
	Sat,  1 Aug 2026 17:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605177; cv=none; b=TpuG+rLKQMVg2DaTcFrbf7VBRUk3EmjHkjRcgYXHe7nQsi0Q8rknScHsS6AgE5/X1Gex3l33uBCiwk3JBE+eDOhUm2BXVVxgh2lylL5fp5gC2aCGNZa6wrhuE6qazjoIAkX0vYNvrG0lx0+xwXxDvNsPpCM29b/xcF4TjzDYM0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605177; c=relaxed/simple;
	bh=jnyvs/KO6BxTm9w3UPBPbnF/7ysonfXI9GGYn5ayj+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOE6iYBb0Ia/gw2XsOuMabtZo4KU8IzJHBbY1qmkVZZnJpTk//4XptP4sHTuhdLnX+hx0AXLypcP+48aOyemSQUIWYevbDBnVomMIISnqlFhUvL5oxCsZJz+kQkvS2eKCM38mIuRzv8jYQ3SxlHTdhvvMNFZBz1b7+evMVYrH6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVMN0FOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVMN0FOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C281F00AC4;
	Sat,  1 Aug 2026 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605176;
	bh=VpjaDGraCKKjOgRHEyxek/gzqF6TEcMXbCvzpvy0qjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVMN0FOq9fbxsadTkruFMvseUCN1hTfgU8Umwf4t52gMPUctYDAHHt6QeTUG2urmC
	 bkayLh51hR/fU3opOlJj2SUv76BxFhbK9YbhXBR3Xd0LBv1jqjnyculCgrkvAljXXQ
	 fRcPTgPP9fyRPrRIi5yXSCe+CBC+woDYTs+EQ+bXZ2Hzz9VuSxvTuDuGas9WwLJE6l
	 YKdr1OJYZoh6A1UWDEODG+E89/oGrqFbTg2IiZmMoyjE1KdzeNA90ss6pnPTvtTkPu
	 SKI1cNNnVbfbRK2BNFjJ7MIgm1wXgqd9P8SoxGn4TO4BnoK72sMZyMzos3pPQgg+m7
	 NwXwB3uViMXXg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/25] md: add exact bitmap mapping and reshape hooks
Date: Sun,  2 Aug 2026 01:25:00 +0800
Message-ID: <20260801172519.2982121-7-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
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
index 0f02e2956398..4c31807e6bcc 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1730,6 +1730,13 @@ static void bitmap_start_write(struct mddev *mddev, sector_t offset,
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
@@ -3083,6 +3090,7 @@ static struct bitmap_operations bitmap_ops = {
 	.flush			= bitmap_flush,
 	.write_all		= bitmap_write_all,
 	.dirty_bits		= bitmap_dirty_bits,
+	.prepare_range		= bitmap_prepare_range,
 	.unplug			= bitmap_unplug,
 	.daemon_work		= bitmap_daemon_work,
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index f46674bdfeb9..26cd07737aab 100644
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
index be580601d5b9..1fa2adf0ada1 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1188,6 +1188,13 @@ static void llbitmap_destroy(struct mddev *mddev)
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
@@ -1785,6 +1792,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.update_sb		= llbitmap_update_sb,
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
+	.prepare_range		= llbitmap_prepare_range,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..3b20a57b8c7e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9361,6 +9361,12 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
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
@@ -9368,10 +9374,8 @@ static void md_bitmap_start(struct mddev *mddev,
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
index d8daf0f75cbb..110cf0f8b107 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -798,6 +798,10 @@ struct md_personality
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

