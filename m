Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D4C1C5D77
	for <linux-raid@vger.kernel.org>; Mon,  7 Jul 2025 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907208; cv=none; b=Z4bCfW85E27F8Yfv65PYNWzZRdkBzBeiYOo4lgdWB4HcTWL5powp+ZMTEvR1Wusy39eWu4XohQ6yS5+kyDXTES9gG0jBWOYlS/n45Z3iAQXy2DtaDkW++R4PkTCjZzWPuqGVBZn9PYlatvQxt7avuFZtoVLGI+gd1NOapTuxo50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907208; c=relaxed/simple;
	bh=ySjBQzRtjPZka/V0AkthCdwIssEqa8Xr9ivfpBpWgKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7R3eYzj0R0cbDb7AgfXisRivV6J5RSXzoGqMoupp2CfCtmQ5LvKlvmn7RXJCuj2EgnagQyWRaeXceP62ehAm4Dqi5Vc6d8j/d/8hEYP2CUC0gdN0NjWyBOL+V4luWcgGd8ak50IuRK4F7nyt/OUFSDyO0XvpVeDmHQmCtkFuqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWvM9p2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWvM9p2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FA5C4CEE3;
	Mon,  7 Jul 2025 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751907207;
	bh=ySjBQzRtjPZka/V0AkthCdwIssEqa8Xr9ivfpBpWgKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWvM9p2oxjAevN41xTOirzCIA4g2cHEfHpv54uhmBeKVKzuXLAlNHmfex7Ebz6hUh
	 Mb97BC0XZi+wqdx5ZDn8w4egz6JYXrNjag3pwRKHumb/VZ6hmOBruMumHA3X1jqg3E
	 815+47j2HRYKmpeoCSTMIb+bvHVgL+DwCjNrrXOTMaxWLZRDWFAqcR4/unnOjXNAFf
	 sl8odhmSJiFwsi6lZABTd9zGLiE6MKyDccliOXY5c6gJwy8Ytl3qwNb9i1yLVOHlPx
	 jQoIc/TILt5lWo2GbD+LujsOPNxqUwQmbRn7vssUDmQdbnV86uWBd4rzU0S0UeATdk
	 zRVNSBL6EMeRw==
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
Subject: [PATCH v2 08/11] md/md-bitmap: add a new method blocks_synced() in bitmap_operations
Date: Tue,  8 Jul 2025 00:51:59 +0800
Message-ID: <20250707165202.11073-9-yukuai@kernel.org>
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

Currently, raid456 must perform a whole array initial recovery to build
initail xor data, then IO to the array won't have to read all the blocks
in underlying disks.

This behavior will affect IO performance a lot, and nowadays there are
huge disks and the initial recovery can take a long time. Hence llbitmap
will support lazy initial recovery in following patches. This method is
used to check if data blocks is synced or not, if not then IO will still
have to read all blocks for raid456.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md-bitmap.h | 1 +
 drivers/md/raid5.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 95453696c68e..5f41724cbcd8 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -90,6 +90,7 @@ struct bitmap_operations {
 	md_bitmap_fn *end_discard;
 
 	sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset);
+	bool (*blocks_synced)(struct mddev *mddev, sector_t offset);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 519bbfb67dcb..c1ac4da1119f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3748,6 +3748,7 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
 static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 			   int disk_idx, int disks)
 {
+	struct mddev *mddev = sh->raid_conf->mddev;
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
@@ -3762,6 +3763,11 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 		 */
 		return 0;
 
+	/* The initial recover is not done, must read everything */
+	if (mddev->bitmap_ops && mddev->bitmap_ops->blocks_synced &&
+	    !mddev->bitmap_ops->blocks_synced(mddev, sh->sector))
+		return 1;
+
 	if (dev->toread ||
 	    (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)))
 		/* We need this block to directly satisfy a request */
-- 
2.43.0

