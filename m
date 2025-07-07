Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57FF231A3B
	for <linux-raid@vger.kernel.org>; Mon,  7 Jul 2025 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907203; cv=none; b=nHq1T9wEuucGRNd1oF7exGqXCXLT+TRGX8XW1a2AeaSgVI8S0ZIm5yD8IOHTl7y4XUSC8cqIXw60xh3in9Oi9YgQUnYZn5JG/DJMcCS/FBvq/5pzKDV4sSJBwAnJ5XZAumwCOkO9N5Sin8vkkw5PMN5FOZCKPihXrzYORQBeqMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907203; c=relaxed/simple;
	bh=CE9+jH3HBMeaXALAbxgabDeC/DXY0Ougrawqt+tMcvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpMzcUZ8Etqx1AvBRcAc+91GtXlZQ1vqiU6JOeXiLAW+OX9KLH2BGrxa+yrUmT2nWf2qaP5Laef46BKuEowMcUqMLkk+YzMG0VYu/rovr12Jh+lkaAkPOStDezdwYZZDwLe6wJqUiEuIxNSdiAQzNMWRdI+DT8blyhNTimxTvi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rzgNLBF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rzgNLBF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC21AC4CEF5;
	Mon,  7 Jul 2025 16:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751907203;
	bh=CE9+jH3HBMeaXALAbxgabDeC/DXY0Ougrawqt+tMcvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzgNLBF26UuOPrldBT2AcCOOxl7fJysj/3OU4e4WWol9LoSzvu00jTqOFlITZCzxw
	 /XYrPZjFFReBIYQcs0Hn8qPuajcMoGMbKWQk+4pGl4y5BWnkF6twZ1IBLdH7vSyDo3
	 U4JwRMIKYrfN8YN0TYSuzSB+aBL7Z0EzMxkKXjOHSvTv/pT8KPqA3S1zyjwOGQnhWc
	 qDjW2AmBClrMZf7BOjlmd0HCuy6Y7wDf43q+sIoYdQ5DZ0UFY+XOdDJfX4SHWXBzMO
	 0AakY0cC17vdaEqMU+mRK7uRLqq3cBKGTlB3F6ghReA+pipjn3bE6dNI7i97ilBgCl
	 GcnBWOwM0Cb2g==
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
Subject: [PATCH v2 07/11] md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations
Date: Tue,  8 Jul 2025 00:51:58 +0800
Message-ID: <20250707165202.11073-8-yukuai@kernel.org>
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

This method is used to check if blocks can be skipped before calling
into pers->sync_request(), llbitmap will use this method to skip
resync for unwritten/clean data blocks, and recovery/check/repair for
unwritten data blocks;

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md-bitmap.h | 1 +
 drivers/md/md.c        | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 8616ced49077..95453696c68e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -89,6 +89,7 @@ struct bitmap_operations {
 	md_bitmap_fn *start_discard;
 	md_bitmap_fn *end_discard;
 
+	sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1a60932516bc..373bee3a7da4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9394,6 +9394,12 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
+		if (mddev->bitmap_ops && mddev->bitmap_ops->skip_sync_blocks) {
+			sectors = mddev->bitmap_ops->skip_sync_blocks(mddev, j);
+			if (sectors)
+				goto update;
+		}
+
 		sectors = mddev->pers->sync_request(mddev, j, max_sectors,
 						    &skipped);
 		if (sectors == 0) {
@@ -9409,6 +9415,7 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
+update:
 		j += sectors;
 		if (j > max_sectors)
 			/* when skipping, extra large numbers can be returned. */
-- 
2.43.0

