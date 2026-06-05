Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0994C77A0;
	Fri,  5 Jun 2026 09:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650937; cv=none; b=TNRYrhIgnwFF0MX6avnJCTbeO2Uljk6sS268Lb8D0KyKXdFaLqWsI0F1JmfeBpiT2ciUnofGOoYe22cPs/2SOQcftnG5O41bZsyIy1AozwIs2/SmW7bvCMUPvSEOTl4OKp8i+GpOqh0YPPNz0CYWgUSfcZohpYEM8H1MgrhXIF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650937; c=relaxed/simple;
	bh=NfeFQ5c7xS1HT33OlwtulEh/DnHm2VZSeqJvDHMdAXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myIH6QBgn3yeoK874xDnuMDzpmsR5LBsylXSRDkG+SnxqwBeowZYA0eXmYkCBUCq7UEJElShdCNH805kqQhy7grkQEFbBpBEnGQ0OvNBSZIa9AdMAjINqCDJDNOA91doOSgC/Or3JaoMvQu9F7sDIasuvb56lQkNOP7Or/76lk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbG2Pfo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbG2Pfo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB121F00893;
	Fri,  5 Jun 2026 09:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650936;
	bh=Iunclv6O0yezJRv0NhUXtZC4ADeNsTZXzX2/AFXKdMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbG2Pfo8PADoG8UWV/awLvZSTjSXv8+ix91OAb7p23UbhKwN+1lLr1EFWUqw9/kTT
	 RN65Y54Ky/OEO4ZrXpAhX0crug56/0k5pJSFTufPqntYBD1Og+4PU5GjYePWcBVchs
	 I8P9jm8wPt3/t8DEh6aeq7w9Pifr/2N6EK7s0jePCf7BjLGCTdfBkw3QLnsE385m/2
	 4QW6rNDL62xOJRukc7ili7eDbiSgatuZrdxmFRNdNxd8vBQ/qQeo6GPRVkqQAxR1LE
	 y8Rjg22x4aSBUD732NaQuEIpR2PwluO7nuKdH2v4yWAWP7rbs8ENPdGAUEWw5njfSb
	 uOcaqDdD8gExw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md: skip bitmap accounting for empty write ranges
Date: Fri,  5 Jun 2026 17:15:09 +0800
Message-ID: <20260605091527.2463539-3-yukuai@kernel.org>
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

mkfs.ext4 can submit zero-sector flush/FUA bios. These bios are WRITE
bios for md_write_start() purposes, but they do not cover any data sector
and must not dirty bitmap bits.

md bitmap accounting currently passes such bios to bitmap start_write().
For llbitmap this reaches llbitmap_start_write() with sectors == 0,
which underflows the end chunk calculation.

The new bitmap prepare_range() hook can also turn a non-empty bio into an
empty bitmap range when the requested sectors are outside the active
bitmap geometry. Treat both cases as not started, so the completion path
will not call end_write() for an empty range.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 08eabc7e5a71..ccc4180d2c1d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9374,10 +9374,12 @@ static void md_bitmap_start(struct mddev *mddev,
 			   mddev->bitmap_ops->start_discard :
 			   mddev->bitmap_ops->start_write;
 
 	md_bitmap_prepare_range(mddev, &md_io_clone->offset,
 				&md_io_clone->sectors);
+	if (!md_io_clone->sectors)
+		return;
 	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
 static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 {
@@ -9394,11 +9396,12 @@ static void md_end_clone_io(struct bio *bio)
 						       bio_clone);
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 	struct completion *reshape_completion = bio->bi_private;
 
-	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
+	if (bio_data_dir(orig_bio) == WRITE && md_io_clone->sectors &&
+	    md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
 
 	if (bio->bi_status && !orig_bio->bi_status)
 		orig_bio->bi_status = bio->bi_status;
 
@@ -9421,14 +9424,16 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 		bio_alloc_clone(bdev, *bio, GFP_NOIO, &mddev->io_clone_set);
 
 	md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
 	md_io_clone->orig_bio = *bio;
 	md_io_clone->mddev = mddev;
+	md_io_clone->sectors = 0;
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
 
-	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
+	if (bio_data_dir(*bio) == WRITE && bio_sectors(*bio) &&
+	    md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
 		md_io_clone->rw = op_stat_group(bio_op(*bio));
 		md_bitmap_start(mddev, md_io_clone);
 	}
-- 
2.51.0

