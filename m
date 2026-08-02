Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC2D3002B9;
	Sun,  2 Aug 2026 19:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700282; cv=none; b=FBvNprsLlRu3dl9viHu97tWp9jXAsHHOb3Q+VfElBCUDgbl2RHKVXD8CSXGjsTjVqogsoesOIqXFmbztz3PROBWA0YIG6QkshyUL/ON/jVZDA38hRXlRiPtT+mySOPZJD9VNWDWjM6tULysEmV2Fs+6RXE6lv6IXVmbv2sJGOMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700282; c=relaxed/simple;
	bh=HyHyVAG3vF6ASrmdXcmDTCd3e/ee9FqThAwpyq5efgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGrn6IsvFVEECCcMhPuAStQ5MBvgLYib41H9KTAI+hxA8PLP+iJ5OwHU0prEZKJMd2vhXGlntwLemhshcVhus2HHtuig4XpbH8xmB1HUk5eg83wewC7oXWfgcViHuVCbzbwSxEHAgZsN23W4vL/YD3P0cLmDRKWmKJvXYf9DOHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1RvNJg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1RvNJg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35B71F00A3A;
	Sun,  2 Aug 2026 19:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700281;
	bh=PNiC5Z7vUv7Ch8OzLEpTUN8kFtKdUAI0tmDK3WigLE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1RvNJg2aN7BszuhBWdGXlsNdiVDfqGHsSUT8yTbTvj3NHOWs1SKmWqbzETgJeT1l
	 HtI0V3eH16qjSu4vFw+5CiEmwBjYCWRHUa5Ds9vKTxF06bRWIUQiq+jMI8/IL2SCG/
	 go5/zyLGAgvwHHaLjpmXKSg8EEbogWiMeq2TIdF7iZwcIilzYNd+rpDFWe9gkFPlPc
	 5GbBIqRWtVTstN7RpdeoUpFyg0VZKoePwu31n4iGv0y4XYysA/oBZ/yq7Id0fyX4vq
	 LvBQxHGXp1fEUpoTyhCwKtSc4Fq+mlOuF9rI6ovsdWSo/yuSITiQ/4PQ+6vb6eyZ+c
	 6u5muwi13q8RA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 10/29] md: skip bitmap accounting for empty write ranges
Date: Mon,  3 Aug 2026 03:50:19 +0800
Message-ID: <20260802195038.164272-11-yukuai@kernel.org>
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

mkfs.ext4 can submit zero-sector flush/FUA bios. These bios are WRITE
bios for md_write_start() purposes, but they do not cover any data sector
and must not dirty bitmap bits.

md bitmap accounting currently passes such bios to bitmap start_write().
For llbitmap this reaches llbitmap_start_write() with sectors == 0,
which underflows the end chunk calculation.

Personality bitmap mapping can also turn a non-empty bio into an empty
bitmap range when the requested sectors are outside the active bitmap
geometry. Treat both cases as not started, so the completion path will not
call end_write() for an empty range.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 58fb5453a819..f88952371b9b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9399,6 +9399,8 @@ static void md_bitmap_start(struct mddev *mddev,
 		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
 					   &md_io_clone->sectors);
 
+	if (!md_io_clone->sectors)
+		return;
 	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
@@ -9419,7 +9421,8 @@ static void md_end_clone_io(struct bio *bio)
 	struct mddev *mddev = md_io_clone->mddev;
 	struct completion *reshape_completion = bio->bi_private;
 
-	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
+	if (bio_data_dir(orig_bio) == WRITE && md_io_clone->sectors &&
+	    md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
 
 	if (bio->bi_status && !orig_bio->bi_status)
@@ -9446,12 +9449,14 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
 	md_io_clone->orig_bio = *bio;
 	md_io_clone->mddev = mddev;
+	md_io_clone->sectors = 0;
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
 	else
 		md_io_clone->start_time = 0;
 
-	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
+	if (bio_data_dir(*bio) == WRITE && bio_sectors(*bio) &&
+	    md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
 		md_io_clone->rw = op_stat_group(bio_op(*bio));
-- 
2.51.0

