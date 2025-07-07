Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D1D23816A
	for <linux-raid@vger.kernel.org>; Mon,  7 Jul 2025 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907181; cv=none; b=UY8/R/a1oGAPA9vBjwGlbRBIyfgKiPZtwGhZOk/jFO+nBh8lytstFowUpRv/jFHM1giMTCJt2P+C4PBBQ8qDcT2bKkYbWZfj+uzk6tiKc/81ZhHxSE3TM/v81K4iB2/y5FgyxHvQPFAgWQLwLdf348REaQ3R/cQdO/RjpPi0VBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907181; c=relaxed/simple;
	bh=hDz3DFXOYFPizJGAaypFAC4xK+xh8V9TABn0O0/Ut5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH2qqESN7DY6+0mv7fEZmq/xf75QsWtlFfNGFYMnr1he4OUdAiRMsgDufLZOYbefePV5y8h15J7wwpYejGIQneddY8ywMVCt/EbZ5KQl82n+SiqbhvcbSv6t0Wls9gbNrR/1D5xHnF4/j3pCFwCxjxw1/+hJhNV/S+kkKTL1Wiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOrTHPZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOrTHPZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540A8C4CEE3;
	Mon,  7 Jul 2025 16:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751907181;
	bh=hDz3DFXOYFPizJGAaypFAC4xK+xh8V9TABn0O0/Ut5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOrTHPZOpuvOBdFedINFa317eQ8zCB24o/t62mTD3J+wL+rTrMSWe6+ZSLD330OFr
	 3B6E+TK/LM0AqRsDV6P56KbhL6Db07wf3HL+tSRhcH4b+lpFY76lGxDjauwm8vswWB
	 5hWFEhoCJk26iJwjLSVVweRF722pO2cSYfEQ/UNkUOs7W2XMzQLW6g/Aqj1Ua/z1ce
	 Y/fzQ844fWzmd2mqGNNGGJx+Lsmwwmu1L8Mo2pF0mwavwHbQ8DtnkxcnDLodb8BBQL
	 FSqGjTJtGv8jdu/4ubfZQf+aHK1oNtEbtWG8AUAWRz0hswFUdLFZFLcMWBDv0ewjPH
	 rPTRYZYvEqbqA==
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
Subject: [PATCH v2 02/11] md: factor out a helper raid_is_456()
Date: Tue,  8 Jul 2025 00:51:53 +0800
Message-ID: <20250707165202.11073-3-yukuai@kernel.org>
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

There are no functional changes, the helper will be used by llbitmap in
following patches.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 9 +--------
 drivers/md/md.h | 6 ++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c4ef23ade9e2..1db7af64184d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9050,19 +9050,12 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 
 static bool sync_io_within_limit(struct mddev *mddev)
 {
-	int io_sectors;
-
 	/*
 	 * For raid456, sync IO is stripe(4k) per IO, for other levels, it's
 	 * RESYNC_PAGES(64k) per IO.
 	 */
-	if (mddev->level == 4 || mddev->level == 5 || mddev->level == 6)
-		io_sectors = 8;
-	else
-		io_sectors = 128;
-
 	return atomic_read(&mddev->recovery_active) <
-		io_sectors * sync_io_depth(mddev);
+	       (raid_is_456(mddev) ? 8 : 128) * sync_io_depth(mddev);
 }
 
 #define SYNC_MARKS	10
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 9e37c6c18722..72bce59376d7 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1033,6 +1033,12 @@ static inline bool mddev_is_dm(struct mddev *mddev)
 	return !mddev->gendisk;
 }
 
+static inline bool raid_is_456(struct mddev *mddev)
+{
+	return mddev->level == ID_RAID4 || mddev->level == ID_RAID5 ||
+	       mddev->level == ID_RAID6;
+}
+
 static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		sector_t sector)
 {
-- 
2.43.0

