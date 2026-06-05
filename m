Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55C54DB54F;
	Fri,  5 Jun 2026 09:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650948; cv=none; b=ncYNfiLQXMJyCIs91gOkj505cqGTZXQ4pddxpadcX9C4wfHJC4+dWOD+pcsUNTiBJ2LajAjrGQIF7ZGjxqJVHEUFwiX5qMFh3LFdJmUJpo1PFbVUDUbbmrmGpGyfJAcVmRKB1a3cWMCTQYHNQsUNjzc9Av3oL/BlRhXd+rjnPAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650948; c=relaxed/simple;
	bh=PoDygy9oW9YyGFbP4yY+3Fca7EcNQ3BZ/zzo4p4f39s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7PvI8LWRQAUJ2JzVJd0d5GmlfncX33j3DP65XNrZSQAbFqkn6vKaNbApY2i5W8Bcrcn+tElAbu2fZdSMiaZ/OrjpS1w33VeTWY5/ydS5QPe1GEPZXYC0xaGiKRrsF7pP+oXdsdJBbMvGqs+nMimScZUMYbD5aDsMTUsT+63ZpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pdy4iTWF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pdy4iTWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309D11F00893;
	Fri,  5 Jun 2026 09:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650946;
	bh=yXY4P0VhOFgSjKdZsTw6V8K14zonJCvnNAmu8Yeicf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pdy4iTWFvexk+mp4gUaGfYFRY3k2fJ1f9KgP5EdY774ZskxQRihwPV2hEfAd+P+G3
	 JWGVZrNICjT3tMSqhfzBKjY1I1DlpPsfEpYIepqtSW2HnRTCnTxn2WCgaonxK3vwUK
	 olws/MLtr2h/b4UraKuk28LFfD1DAD414zvELKHqrAOU+DBahsvotJbz2z2Cv8tD8y
	 m9xMxqzfTgnnDvtKxBY3tkxAjXY1fUIe4E9S8t2TjVymHlZB7ZvkW2P/J3S1vRvd6g
	 k3craMh0QT4YmVOh982Db4fK2odSKsng/EHONGber4VWW4SMQwHKCL6rc5vXia8cTt
	 Q3WQ1DihbEXJA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-llbitmap: track target reshape geometry fields
Date: Fri,  5 Jun 2026 17:15:14 +0800
Message-ID: <20260605091527.2463539-8-yukuai@kernel.org>
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

Track llbitmap bookkeeping for the target reshape geometry while keeping
a single live bitmap instance.

Add the reshape geometry fields, refresh helper, and update the load and
resize paths to keep the target geometry in sync.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 91d3dec43d48..f79538a4eb79 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -287,10 +287,13 @@ struct llbitmap {
 	unsigned long chunksize;
 	/* total number of chunks */
 	unsigned long chunks;
 	/* total number of sectors tracked by current bitmap geometry */
 	sector_t sync_size;
+	unsigned long reshape_chunksize;
+	unsigned long reshape_chunks;
+	sector_t reshape_sync_size;
 	unsigned long last_end_sync;
 	/*
 	 * time in seconds that dirty bits will be cleared if the page is not
 	 * accessed.
 	 */
@@ -428,10 +431,42 @@ static void llbitmap_resize_chunks(struct mddev *mddev, sector_t blocks,
 		*chunksize = *chunksize << 1;
 		*chunks = DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
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
+	llbitmap_resize_chunks(llbitmap->mddev, blocks, &llbitmap->reshape_chunksize,
+			       &llbitmap->reshape_chunks);
+	llbitmap->chunks = max(old_chunks, llbitmap->reshape_chunks);
+}
+
 static enum llbitmap_state llbitmap_read(struct llbitmap *llbitmap, loff_t pos)
 {
 	unsigned int idx;
 	unsigned int offset;
 
@@ -1027,10 +1062,11 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
 	llbitmap->sync_size = blocks;
+	llbitmap_refresh_reshape(llbitmap);
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
 	ret = llbitmap_alloc_pages(llbitmap);
 	if (ret)
 		return ret;
@@ -1138,10 +1174,11 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->sync_size = sync_size;
+	llbitmap_refresh_reshape(llbitmap);
 	ret = llbitmap_alloc_pages(llbitmap);
 
 out_put_page:
 	__free_page(sb_page);
 	kunmap_local(sb);
@@ -1293,10 +1330,11 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 			llbitmap_mark_range(llbitmap, chunks, old_chunks - 1,
 					    BitUnwritten);
 		mddev->bitmap_info.chunksize = bitmap_chunksize;
 		llbitmap->chunks = chunks;
 		llbitmap->sync_size = blocks;
+		llbitmap_refresh_reshape(llbitmap);
 		llbitmap_update_sb(llbitmap);
 	}
 	__llbitmap_flush(mddev);
 	mutex_unlock(&mddev->bitmap_info.mutex);
 	return 0;
-- 
2.51.0

