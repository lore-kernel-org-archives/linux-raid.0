Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C53274B58;
	Mon, 23 Feb 2026 02:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771814454; cv=none; b=BmXgxMCJ93fiyEhqSS3obLxT+3cB/FiBrimfLNgcRBJZZAtFiHN7jMS1u/ZD7tKlqTnO8GQXQJo0uxrscq+ISMihB3myqR+cZzM4aN9G6eLeV0semJAIZPVhoNtpSAQBGb8l5vHoEoTDuDd+Zj9XqDcCP+WZ31zdscHVgcoHirw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771814454; c=relaxed/simple;
	bh=jVBk1b/wivXQrHrNwPugL4S2SWbQ6unlwk6a0c7bpYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=env4EMaBlBCVoZMIkKhkOb2B5TlUc15ctTIXUhCie5NW2wXAI6OuscXKdHKahaM5GuxAybUAOtHX/a2U6tTLRYamuZv3TX/5SNhRwFLyGcw5vCt6Nvnf7tqsXLwVNnKjX/xD7Z5zYj1WxKstDbeOtvvePAvxyZvSyRGnszn3vYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9545CC116D0;
	Mon, 23 Feb 2026 02:40:50 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com,
	colyli@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] md/md-llbitmap: optimize initial sync with write_zeroes_unmap support
Date: Mon, 23 Feb 2026 10:40:38 +0800
Message-ID: <20260223024038.3084853-6-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223024038.3084853-1-yukuai@fnnas.com>
References: <20260223024038.3084853-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For RAID-456 arrays with llbitmap, if all underlying disks support
write_zeroes with unmap, issue write_zeroes to zero all disk data
regions and initialize the bitmap to BitCleanUnwritten instead of
BitUnwritten.

This optimization skips the initial XOR parity building because:
1. write_zeroes with unmap guarantees zeroed reads after the operation
2. For RAID-456, when all data is zero, parity is automatically
   consistent (0 XOR 0 XOR ... = 0)
3. BitCleanUnwritten indicates parity is valid but no user data
   has been written

The implementation adds two helper functions:
- llbitmap_all_disks_support_wzeroes_unmap(): Checks if all active
  disks support write_zeroes with unmap
- llbitmap_zero_all_disks(): Issues blkdev_issue_zeroout() to each
  rdev's data region to zero all disks

The zeroing and bitmap state setting happens in llbitmap_init_state()
during bitmap initialization. If any disk fails to zero, we fall back
to BitUnwritten and normal lazy recovery.

This significantly reduces array initialization time for RAID-456
arrays built on modern NVMe SSDs or other devices that support
write_zeroes with unmap.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 62 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 461050b2771b..48bc6a639edd 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -654,13 +654,73 @@ static int llbitmap_cache_pages(struct llbitmap *llbitmap)
 	return 0;
 }
 
+/*
+ * Check if all underlying disks support write_zeroes with unmap.
+ */
+static bool llbitmap_all_disks_support_wzeroes_unmap(struct llbitmap *llbitmap)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, mddev) {
+		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
+			continue;
+
+		if (bdev_write_zeroes_unmap_sectors(rdev->bdev) == 0)
+			return false;
+	}
+
+	return true;
+}
+
+/*
+ * Issue write_zeroes to all underlying disks to zero their data regions.
+ * This ensures parity consistency for RAID-456 (0 XOR 0 = 0).
+ * Returns true if all disks were successfully zeroed.
+ */
+static bool llbitmap_zero_all_disks(struct llbitmap *llbitmap)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	struct md_rdev *rdev;
+	sector_t dev_sectors = mddev->dev_sectors;
+	int ret;
+
+	rdev_for_each(rdev, mddev) {
+		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
+			continue;
+
+		ret = blkdev_issue_zeroout(rdev->bdev,
+					   rdev->data_offset,
+					   dev_sectors,
+					   GFP_KERNEL, 0);
+		if (ret) {
+			pr_warn("md/llbitmap: failed to zero disk %pg: %d\n",
+				rdev->bdev, ret);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static void llbitmap_init_state(struct llbitmap *llbitmap)
 {
+	struct mddev *mddev = llbitmap->mddev;
 	enum llbitmap_state state = BitUnwritten;
 	unsigned long i;
 
-	if (test_and_clear_bit(BITMAP_CLEAN, &llbitmap->flags))
+	if (test_and_clear_bit(BITMAP_CLEAN, &llbitmap->flags)) {
 		state = BitClean;
+	} else if (raid_is_456(mddev) &&
+		   llbitmap_all_disks_support_wzeroes_unmap(llbitmap)) {
+		/*
+		 * All disks support write_zeroes with unmap. Zero all disks
+		 * to ensure parity consistency, then set BitCleanUnwritten
+		 * to skip initial sync.
+		 */
+		if (llbitmap_zero_all_disks(llbitmap))
+			state = BitCleanUnwritten;
+	}
 
 	for (i = 0; i < llbitmap->chunks; i++)
 		llbitmap_write(llbitmap, state, i);
-- 
2.51.0

