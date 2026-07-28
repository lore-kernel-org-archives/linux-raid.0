Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6715E41A576;
	Tue, 28 Jul 2026 08:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228585; cv=none; b=di8d9dWidZu4Tpej8cvZSFoINJKsNsC/K2Dth/cl9e3SDpcvdpyEkywhwItsJNBSk2gvyZNu6x8McanrSjzSESVOm8BXNb3wKQbphoU6LhCmVqzFS3SGqVZW8/ixSKIpILetvmgZU2pQ/ppjaIqal7yPS2n4vpNUK+tyfr7cMoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228585; c=relaxed/simple;
	bh=zE6V0rS1CYRh8HHF4UU9C4G8OkNMOGRNXdKiUikz4ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtnPgizfRGaFAJBRzJd/4rHtS94kiu3ZDo9kJMqa4QEcVXqFgK3k2Pg12BLMi/UCzw/ha11HQaXSzaPzxnPHWpCQcsYe5wN1GU6AXEWxZN4POlKSA5We9v+H76YNCiu73HrejJ+MQuGbY70pR54wX/n0HuVG5vPDSO9a7xiQB9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VYEuiWfs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VYEuiWfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831E11F00A3A;
	Tue, 28 Jul 2026 08:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228583;
	bh=ExNpf8G5K91gwe32QvrS/B9q/xSMdoQA1ID+InSEdgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYEuiWfsAXSjz+rts5memcmTPj2INwUE4+VgfCbXikxAcnafGcXn761Oe2dCFodbO
	 odWk1/bnrGVBB4EOzVo+e86dJls1ghv4LIqmNxIh8xWXIdryugngisUAwjQnCeaqz0
	 OWefp4Gi0rdQ6kgbVz2zg9N+nFDKL0bFN3PJbPPuN8AGfOMLpam0HQHPV9drOQNmGf
	 Xelc7wQhkWW9Ijb95rg5BokSmABgCxC996krNSsNmqM0Xr1AEynZvxZMTEBwrUGEIj
	 ZqrdTV+zhzJTxGDUt4mqGI8XSKoUM8JRQ5kl+VOKSB8ILBTbqNNG3g/N0SFLwuTnW4
	 6502n+IIbYWwA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/21] md: skip bitmap accounting for empty write ranges
Date: Tue, 28 Jul 2026 16:49:03 +0800
Message-ID: <93b346ed45509176248d86b8b550686bc60c2311.1785206690.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
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
index 3b20a57b8c7e..0b59c676f7c0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9376,6 +9376,8 @@ static void md_bitmap_start(struct mddev *mddev,
 
 	md_bitmap_prepare_range(mddev, &md_io_clone->offset,
 				&md_io_clone->sectors);
+	if (!md_io_clone->sectors)
+		return;
 	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
@@ -9396,7 +9398,8 @@ static void md_end_clone_io(struct bio *bio)
 	struct mddev *mddev = md_io_clone->mddev;
 	struct completion *reshape_completion = bio->bi_private;
 
-	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
+	if (bio_data_dir(orig_bio) == WRITE && md_io_clone->sectors &&
+	    md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
 
 	if (bio->bi_status && !orig_bio->bi_status)
@@ -9423,10 +9426,12 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
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
-- 
2.51.0

