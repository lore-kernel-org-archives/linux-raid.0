Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E5241A909;
	Tue, 28 Jul 2026 08:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228609; cv=none; b=XMMR2q2xwR5VpVxzj5fIhn9KS69qciOqbsdUAWHTwNANEATzyD6OwGWkE6r76S/ewa6SrMS+hDvsMi3/ghgArR7fB54DOb0rf/w7YL9CCjuonDNS3eglhVHHs8feQEKnwxeYJ9mj/ByyUeMpEW5R7C0UzXpUJZ5F5Mc4S3QcZuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228609; c=relaxed/simple;
	bh=stb4wceulTFh08IkwWeWFkYWGC+8VrcZYCQCLv9NXuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1/6EyboSCl/z2H7LqpLygDljDLYGKNCItmWdEqejyC/F0vv08AGr7C1bKPlqGiz7NnyfgSB+dHXrbhvm5V+p0F4VY8mZR9Mg3W0MoYK2ZxOc/KyZnEKco4eosGKnfRaGoFy61XT5c7glNj6BQ7gQqQ0BmISO8j5qEQj+QRRc8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uho5RDYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uho5RDYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD5E1F00A3A;
	Tue, 28 Jul 2026 08:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228607;
	bh=5JgnaeaSNEylPXKxOST4cCPnSqA8uI3k46p/4myRDUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uho5RDYYiORgvxQafq95u+wzVkUBZRLmTp1eKG4zjozNJZ68JH2EO35pNzVCIXGEc
	 bzntCbfbseuVPSraZOkc8jsTw6PLB56PksYvi49g6eX0gOuXWLSbEsRHSmBMesCFd/
	 qwFYMc/l4YdZjGPqEZb/+inKBSDLJXLkSBaYoYVCUCaC5/0jMEZ2qA4SHVOJm3aEUF
	 cOJ42b04L7BCA6yVZ5RNHdEBD4UUzevZPbRl5ipK1qt8hy3VBPQBoV+MJpUur1wfEw
	 3uI0PBV1BqBZj5oimaVvR9oY2xs8k/fp+GtgU2JuFJCkDC4/PhPRfOfl6gaRIDphFj
	 OuKt3Dgaash1g==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/21] md/md-llbitmap: track target reshape geometry fields
Date: Tue, 28 Jul 2026 16:49:08 +0800
Message-ID: <296e44a8317cd280dbb9c13dadd91b026c4dc561.1785206690.git.yukuai@fygo.io>
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

Track llbitmap bookkeeping for the target reshape geometry while keeping
a single live bitmap instance.

Add the reshape geometry fields, refresh helper, and update the load and
resize paths to keep the target geometry in sync.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1ab9b1689fd8..cdced2126e97 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -289,6 +289,9 @@ struct llbitmap {
 	unsigned long chunks;
 	/* total number of sectors tracked by current bitmap geometry */
 	sector_t sync_size;
+	unsigned long reshape_chunksize;
+	unsigned long reshape_chunks;
+	sector_t reshape_sync_size;
 	unsigned long last_end_sync;
 	/*
 	 * time in seconds that dirty bits will be cleared if the page is not
@@ -430,6 +433,39 @@ static void llbitmap_calculate_chunks(struct mddev *mddev, sector_t blocks,
 	}
 }
 
+static bool llbitmap_reshaping(struct llbitmap *llbitmap)
+{
+	return llbitmap->mddev->reshape_position != MaxSector;
+}
+
+static sector_t llbitmap_personality_sync_size(struct llbitmap *llbitmap,
+					       bool previous)
+{
+	struct mddev *mddev = llbitmap->mddev;
+
+	if (!llbitmap_reshaping(llbitmap) || !mddev->private || !mddev->pers ||
+	    !mddev->pers->bitmap_sync_size)
+		return llbitmap->sync_size;
+	return mddev->pers->bitmap_sync_size(mddev, previous);
+}
+
+static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
+{
+	unsigned long old_chunks = DIV_ROUND_UP_SECTOR_T(llbitmap->sync_size,
+						 llbitmap->chunksize);
+	sector_t blocks = llbitmap_personality_sync_size(llbitmap, false);
+	unsigned long chunksize = llbitmap->chunksize;
+	unsigned long chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
+
+	llbitmap->reshape_sync_size = blocks;
+	llbitmap->reshape_chunksize = chunksize;
+	llbitmap->reshape_chunks = chunks;
+	llbitmap_calculate_chunks(llbitmap->mddev, blocks,
+				  &llbitmap->reshape_chunksize,
+				  &llbitmap->reshape_chunks);
+	llbitmap->chunks = max(old_chunks, llbitmap->reshape_chunks);
+}
+
 static enum llbitmap_state llbitmap_read(struct llbitmap *llbitmap, loff_t pos)
 {
 	unsigned int idx;
@@ -1029,6 +1065,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
 	llbitmap->sync_size = blocks;
+	llbitmap_refresh_reshape(llbitmap);
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
 	ret = llbitmap_alloc_pages(llbitmap);
@@ -1140,6 +1177,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->sync_size = sync_size;
+	llbitmap_refresh_reshape(llbitmap);
 	ret = llbitmap_alloc_pages(llbitmap);
 
 out_put_page:
@@ -1284,6 +1322,9 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		goto out;
 
 	if (reshape) {
+		llbitmap->reshape_sync_size = blocks;
+		llbitmap->reshape_chunksize = bitmap_chunksize;
+		llbitmap->reshape_chunks = chunks;
 		llbitmap->chunks = max(old_chunks, chunks);
 	} else {
 		if (blocks < old_blocks && chunks < old_chunks)
@@ -1292,6 +1333,7 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		mddev->bitmap_info.chunksize = bitmap_chunksize;
 		llbitmap->chunks = chunks;
 		llbitmap->sync_size = blocks;
+		llbitmap_refresh_reshape(llbitmap);
 		llbitmap_update_sb(llbitmap);
 	}
 	__llbitmap_flush(mddev);
-- 
2.51.0

