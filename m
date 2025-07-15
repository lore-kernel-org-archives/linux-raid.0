Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F7928C2C1;
	Tue, 15 Jul 2025 18:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752602404; cv=none; b=b9t/FOLk3WI3/XqZfs/GRw4GDKb9MTzD3fsAyOAMU/tiKhwZNHnpbNWQ8KriiJOTr9vKb4X5Y2AU3VU9QQ8bRzgbt731Jw+I3ojSvTsfGncr4ruNplX+CIAWcIhpbUgk5PsQ9BAtdwwH5sYP8t0jb+HC6JU9WlWd83m1d5aMkJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752602404; c=relaxed/simple;
	bh=0KejWqO4UaiW8Qop8hciFZfAu8EtXo23i+3V7FAHoHU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ehqjXoDLdra1M7a9IUSmvLmWhrvVIHkNObcgME7N6iyLPENRtSudLuESMqBukM9ye882XFp3nEZDgZ/iTRxXDbMTzsPOVtEcDueXx3o4bH3pYzuMtPSjLrZJ9wraN0V6JTo+fUMmqElNOqVwzGKyz+ZRArIHsgClLUiJ9GltN7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9NCJ49N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9NCJ49N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886B2C4CEE3;
	Tue, 15 Jul 2025 18:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752602404;
	bh=0KejWqO4UaiW8Qop8hciFZfAu8EtXo23i+3V7FAHoHU=;
	h=From:To:Cc:Subject:Date:From;
	b=G9NCJ49Ny4Yrq2RHJ6I41m/M5qW201kYnAYZBminZ71prLYTTajugfAot/Ekpj6x+
	 GeFhEBmYoyI9jvhDDndtrkOzpfY7Zwg8Z2f0/WBy0DdNRoBy+TkWPCUz3g/eldJcZe
	 ePm0vqwCN517HBxr1NRxgzvlWfagkwyKiaTSFGFjtT2Sp56vAd/LObSHloXGMrEIZG
	 6NwHrlQJY3/rwvF3ic/uDzP1qT5si0neXMGzMkzf+TAJpiSlmOF+2uRthUA8H7MCkQ
	 RC0tbGn2e2+6fF5d2eMc5bZ9h6A/iOZr+r6e7+zPFcHeeuaFzWQ7gJKHKLG6dSkY4k
	 hEZVTD3fr00fw==
From: colyli@kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Coly Li <colyli@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Date: Wed, 16 Jul 2025 01:59:56 +0800
Message-Id: <20250715175956.29702-1-colyli@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@kernel.org>

Currently in md_submit_bio() the incoming request bio is split by
bio_split_to_limits() which makes sure the bio won't exceed
max_hw_sectors of a specific raid level before senting into its
.make_request method.

For raid level 4/5/6 such split method might be problematic and hurt
large read/write perforamnce. Because limits.max_hw_sectors are not
always aligned to limits.io_opt size, the split bio won't be full
stripes covered on all data disks, and will introduce extra read-in I/O.
Even the bio's bi_sector is aligned to limits.io_opt size and large
enough, the resulted split bio is not size-friendly to corresponding
raid456 level.

This patch introduces bio_split_by_io_opt() to solve the above issue,
1, If the incoming bio is not limits.io_opt aligned, split the non-
   aligned head part. Then the next one will be aligned.
2, If the imcoming bio is limits.io_opt aligned, and split is necessary,
   then try to split a by multiple of limits.io_opt but not exceed
   limits.max_hw_sectors.

Then for large bio, the sligned split part will be full-stripes covered
to all data disks, no extra read-in I/Os when rmw_level is 0. And for
rmw_level > 0 condistions, the limits.io_opt aligned bios are welcomed
for performace as well.

This RFC patch only tests on 8 disks raid5 array with 64KiB chunk size.
By this patch, 64KiB chunk size for a 8 disks raid5 array, sequential
write performance increases from 900MiB/s to 1.1GiB/s by fio bs=10M.
If fio bs=488K (exact limits.io_opt size) the peak sequential write
throughput can reach 1.51GiB/s.

Signed-off-by: Coly Li <colyli@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Xiao Ni <xni@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
---
 drivers/md/md.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f03b21e66e4..363cff633af3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -426,6 +426,67 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
+static struct bio *bio_split_by_io_opt(struct bio *bio)
+{
+	sector_t io_opt_sectors, sectors, n;
+	struct queue_limits lim;
+	struct mddev *mddev;
+	struct bio *split;
+	int level;
+
+	mddev = bio->bi_bdev->bd_disk->private_data;
+	level = mddev->level;
+	if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR)
+		return bio_split_to_limits(bio);
+
+	lim = mddev->gendisk->queue->limits;
+	io_opt_sectors = min3(bio_sectors(bio), lim.io_opt >> SECTOR_SHIFT,
+			      lim.max_hw_sectors);
+
+	/* No need to split */
+	if (bio_sectors(bio) == io_opt_sectors)
+		return bio;
+
+	n = bio->bi_iter.bi_sector;
+	sectors = do_div(n, io_opt_sectors);
+	/* Aligned to io_opt size and no need to split for radi456 */
+	if (!sectors && (bio_sectors(bio) <=  lim.max_hw_sectors))
+		return bio;
+
+	if (sectors) {
+		/**
+		 * Not aligned to io_opt, split
+		 * non-aligned head part.
+		 */
+		sectors = io_opt_sectors - sectors;
+	} else {
+		/**
+		 * Aligned to io_opt, split to the largest multiple
+		 * of io_opt within max_hw_sectors, to make full
+		 * stripe write/read for underlying raid456 levels.
+		 */
+		n = lim.max_hw_sectors;
+		do_div(n, io_opt_sectors);
+		sectors = n * io_opt_sectors;
+	}
+
+	/* Almost won't happen */
+	if (unlikely(sectors >= bio_sectors(bio))) {
+		pr_warn("%s raid level %d: sectors %llu >= bio_sectors %u, not split\n",
+			__func__, level, sectors, bio_sectors(bio));
+		return bio;
+	}
+
+	split = bio_split(bio, sectors, GFP_NOIO,
+			  &bio->bi_bdev->bd_disk->bio_split);
+	if (!split)
+		return bio;
+	split->bi_opf |= REQ_NOMERGE;
+	bio_chain(split, bio);
+	submit_bio_noacct(bio);
+	return split;
+}
+
 static void md_submit_bio(struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
@@ -441,7 +502,7 @@ static void md_submit_bio(struct bio *bio)
 		return;
 	}
 
-	bio = bio_split_to_limits(bio);
+	bio = bio_split_by_io_opt(bio);
 	if (!bio)
 		return;
 
-- 
2.39.5

