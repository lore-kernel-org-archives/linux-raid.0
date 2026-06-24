Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D02F389E04;
	Wed, 24 Jun 2026 06:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283347; cv=none; b=G7+sUQ58S9VWbLGFkCWrx6XovqIxNJ27j/vUAcxVJPvsdG/dKUGKF4CmxKNz45OLPmQ8V6eMyuAPVoweVlmiOZulqKmhBp/B+09tNzfSm5q/dG6/9jVBFPFgYh264ydasnejkBY/ctzXRIogstCQ0f5rCRxWQsQqHG7D1AiSiU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283347; c=relaxed/simple;
	bh=ZI2N65oTD5VPNHj/tISgcp/CbRYPU4wPG0hY1u/3cSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZYuV1NwWDa9LXPRrhZnkUVcBBEfNQ+3fxGjyC2C7lxdlEECxHdJMVy96OIyas6LP1EZI5Eiyc4H7xT80VhqpmnYE3oo57lxjqPBXxhAd7wrXubbsLSNJuesfniNeCab6cTwWydRusybwtCby65Dp92Ihrpp2H8MfGz4dJp8/Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwB0+xhL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwB0+xhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF87D1F00A3A;
	Wed, 24 Jun 2026 06:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283346;
	bh=bVxxR6yXWLkAuPezHi4TRUQrfY+J7OxSwMG237g7vls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwB0+xhL9ATriTDRQPQpdwRFgrmI0T6keCVTfqUXgbL2WD9i9wral7f9kbHGUcre+
	 9Bcs7+CbcwLmiA+9BzJXOR6L29ykWEvFyQnl2X3YhMkvg845GHnbiaPuW1H3/ohb9F
	 YfhyildC9lpR1zfqUonc6Crv1o9khEbQuLlG+5JhL4wGx6PJ5goZSxiDPym3Tx+3pH
	 I3fzvrZLYpARUUwG4ekSgmg8U1bHAufK7xbJrcX1Q8ngF4oXrZAntrxnqm6Koswr8h
	 T7oa5ep8Ww8r8Rn3xm0iM2743rQf99Hp0Sy0V0uXOKZNVL07CLwsGXsFC0BWhgqslS
	 9wm1DWKwHvauw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/20] md: add exact bitmap mapping and reshape hooks
Date: Wed, 24 Jun 2026 14:41:58 +0800
Message-ID: <b0df6a98edfe3881327ebb7c38dbf040c58607f1.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
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
index 5a4e2abaa757..f0c20afa354e 100644
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
@@ -1780,6 +1787,7 @@ static struct bitmap_operations llbitmap_ops = {
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

