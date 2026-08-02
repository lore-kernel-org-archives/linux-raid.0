Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B154F2C3268;
	Sun,  2 Aug 2026 19:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700291; cv=none; b=iTQyRaNWwfyVDNC8ZSQX7mXIMTjKrgtoBHcS+EI0/z+hSdHBCodI1/v2FSpQEX8tO0++T6ieg+4iERRzTgr7O2P0Wb1iOEd36XMWgd76TzWXaMRmF+Ncw+xJndYqn5A+xeORaRP4mHxejMVSnyLa5jipFA2osEXMurcrptWNtMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700291; c=relaxed/simple;
	bh=1p2nJTQOKn8idEgBa6FWCSV1o/It0iDsnvAKzXSbZkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujPeAUOth5aC2bpB1sBjXfqL9qdB2n6CS936ZVVAbqcZ544cYBDv0rsFmWw1+ixMbqblOcn4gPoERcfBF1gZwSZrfaxx4g0Ju/4gqcHJOBtijIPCz8ytkq5xPDllHEa8aY5GTlzcuzOHEC0sv+5l9R7Yb2eyENt4j2sR0TKDypo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGIWH899; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGIWH899"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0F71F000E9;
	Sun,  2 Aug 2026 19:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700290;
	bh=qZ4vXAPCYvJ89FeEjdHZT7m4iU7j8fXxTea+mwBzEFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGIWH899bok3l3MsVUWXGgXEf+jHhhajZTeDT5MO/V4Wop0Vq9BgnY392Vw2mHBvp
	 Wjse7NyC5g+W60ObXvnwFiRvpr/3cbZys5IaFlfJzSWvP08vwIwIsI8G8/QeKLhDPL
	 VlLD81bpgK9+sQH2XQVFGvxAxDP8k79OFGuPj4/TbCcUON8KnzOrXieoYWtsBumB8u
	 a50Q/87oMB4Y/azQctCkWArzA/OFnjf/QY91YbPybah3dJL7lo0hd0s/If08b7ChV6
	 0R68u3vAhkp72PRxkd133UtA5HVpJwM7kZIGqlnn+a7bmX7dGGEs0Tuh6EK81Xj7FO
	 Q2HnGD2dDaGZQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 12/29] md: add exact bitmap mapping and reshape hooks
Date: Mon,  3 Aug 2026 03:50:21 +0800
Message-ID: <20260802195038.164272-13-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
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

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-bitmap.c   |  8 ++++++++
 drivers/md/md-bitmap.h   |  8 ++++++++
 drivers/md/md-llbitmap.c |  8 ++++++++
 drivers/md/md.c          | 11 ++++++++---
 drivers/md/md.h          |  4 ++++
 5 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 7e4fbca93ccb..b7f0d4acce04 100644
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
@@ -3081,6 +3088,7 @@ static struct bitmap_operations bitmap_ops = {
 	.flush			= bitmap_flush,
 	.write_all		= bitmap_write_all,
 	.dirty_bits		= bitmap_dirty_bits,
+	.prepare_range		= bitmap_prepare_range,
 	.unplug			= bitmap_unplug,
 	.daemon_work		= bitmap_daemon_work,
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 890276d9c66e..6478cf9d8816 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -94,6 +94,14 @@ struct bitmap_operations {
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
index 3ec5b5985d48..4583bbc37c2e 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1198,6 +1198,13 @@ static void llbitmap_destroy(struct mddev *mddev)
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
@@ -1789,6 +1796,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.update_sb		= llbitmap_update_sb,
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
+	.prepare_range		= llbitmap_prepare_range,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f0eecdfff1cc..538ba7bab060 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9427,6 +9427,12 @@ struct bio *mddev_bio_split_at_reshape_offset(struct mddev *mddev,
 }
 EXPORT_SYMBOL_GPL(mddev_bio_split_at_reshape_offset);
 
+static void md_bitmap_prepare_range(struct mddev *mddev, sector_t *offset,
+				    unsigned long *sectors)
+{
+	mddev->bitmap_ops->prepare_range(mddev, offset, sectors);
+}
+
 static void md_bitmap_start(struct mddev *mddev,
 			    struct md_io_clone *md_io_clone)
 {
@@ -9434,9 +9440,8 @@ static void md_bitmap_start(struct mddev *mddev,
 			   mddev->bitmap_ops->start_discard :
 			   mddev->bitmap_ops->start_write;
 
-	if (mddev->pers->bitmap_sector)
-		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
-					   &md_io_clone->sectors);
+	md_bitmap_prepare_range(mddev, &md_io_clone->offset,
+				&md_io_clone->sectors);
 
 	if (!md_io_clone->sectors)
 		return;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8146a6f50a7d..b6d2e8929a0f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -797,6 +797,10 @@ struct md_personality
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

