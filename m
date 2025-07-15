Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4087273D89;
	Tue, 15 Jul 2025 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752602569; cv=none; b=dIau525DhbxUlHLQ2hZwCyvhcFrjCHteaUXoigS6KyV8ZptzK04+VYzzZeht0j7C9TL7cAJRv715iOncEO5RmaknIop9/awX9yuTFBgeHcG2xh3+dLOiW9zvvb+eQZrIGj1/m4hsu1TP9if1YhchG0I1nqHBZsGsiLFZMdWZgCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752602569; c=relaxed/simple;
	bh=Af+DxG2+ysyDU6gOtaSIdtUVvk5g9lM1d8KO0YhEd8k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UDUkx7g7oliD+9ASIrcO8CxpI8JMQd3qwdoOF8ZFU2F3r9yKYcubqca21mCYLw3DGDWu+y63p4PW5pQodcUIc57RCv1Gr4F6UUOvpJFaUmdNC3KMzgxYgI911XHKvdNjpmmswhU4FrtRpokuhVA4rcSqOiIfjm1GJ659NUjwseQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqTCvhch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqTCvhch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F8DC4CEE3;
	Tue, 15 Jul 2025 18:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752602569;
	bh=Af+DxG2+ysyDU6gOtaSIdtUVvk5g9lM1d8KO0YhEd8k=;
	h=From:To:Cc:Subject:Date:From;
	b=iqTCvhchFTCGB3V/QxGaCFh7GBj0JUvu/fGP+wMZbRnd1D4+II9DONEn5goX4z8R5
	 YzlgZi4ivZmWE4z0PQto4jz2ZmCqmOAC9zXNx+aBma+Z4D5cXs95LS74LPtHEQj4E1
	 muSH1KlN6dfiUI3krRgYH0/8NRmmOpspWhBfd2cUiqkAjOD3GqldC/HSvDVJQEygkV
	 23hjOhAWYUB4ffiqy4F3S7r+crDMxDCQn7/RoI/1XRJHnsYw3aRRJjT7SrH3fCLp1n
	 NS2JOX73gZ+4F8uoPGRHOmnhtHS9XQf8LtgSYXoyXdTq1p+i2keTxvONwQHCVyOm3O
	 X0S2RLeI2rJvQ==
From: colyli@kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Coly Li <colyli@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Date: Wed, 16 Jul 2025 02:02:41 +0800
Message-Id: <20250715180241.29731-1-colyli@kernel.org>
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

(Resend to include Christoph and Keith in CC list.)

Signed-off-by: Coly Li <colyli@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Xiao Ni <xni@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>
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

