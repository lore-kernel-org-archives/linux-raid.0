Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B574231E833;
	Sat,  1 Aug 2026 17:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605211; cv=none; b=ozGTrlqIlW+D+O9IFjYcXuE1TFm44jIvg3xMhy4jYb0Dv5/q5O7hHFHz8zkiDDavBPcwP872541kOCXpXi/2MrMMDhS3xGr9QsldMC5hb112mMDJTj33OaeBHu0vBGW1EkQC9RhcltKsOMWO379or3K3nC/BCy6NrF1Mjre7TE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605211; c=relaxed/simple;
	bh=P9DUBYd2p9B1u+9uXmIYygnbEadelpwOlThwE3Abd8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFub6Vdmo1YG9IbyY6ozLWUb6F9HsfzfAw1FaERn2DCh1kD3WZrkHsraWBFFq6Jw0K8VirwzIV658t25OlpoINr5tud/hBGvh445kh+G47CCKakYgbVNqYqcQHo0jHua5t6+JQ+USUT5sXHA2ePLOxbIA1+9WIx7qdpl8IlKHZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESqNovsq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESqNovsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75C51F00AC4;
	Sat,  1 Aug 2026 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605210;
	bh=053e985NNbRHzt9HVeR1ohHEaM224L+1aYxhMTBikEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESqNovsqUuLNos/CIU8mUlQvc5p80kBF7w/BalbFeJ1VLvuD/jC573wUJ2Se9Puuu
	 +U0ayvNNKIHBfwUDz7UEnTyddfCHHdD87gTRA7Cy+k6kZcCvqnwafphNH9edvDAjyT
	 23Rj6YimQ3isqhTIyGkA0pQ4k0I3mCmsqLLSTA9jacJQCAR94TQUoJTtEff8WK/bgZ
	 LqSZ/7ynrzGMV4Xlz3zUqbLNlz7vwIkf+O/xbStgDboJESnvfMrW4apemVQ4Vc75V0
	 BATtWhlCuiUUZOf7HG3V+kEBYZvD+Ao3jvAEh5cqjdDrykijnxNMhRiQb7pgIPLacM
	 Jr2rCsvNLX7Xg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 12/25] md/md-llbitmap: track target reshape geometry fields
Date: Sun,  2 Aug 2026 01:25:06 +0800
Message-ID: <20260801172519.2982121-13-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
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
index cf522fae78f8..37d1312e3eab 100644
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
@@ -1289,6 +1327,9 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		goto out;
 
 	if (reshape) {
+		llbitmap->reshape_sync_size = blocks;
+		llbitmap->reshape_chunksize = bitmap_chunksize;
+		llbitmap->reshape_chunks = chunks;
 		llbitmap->chunks = max(old_chunks, chunks);
 	} else {
 		if (blocks < old_blocks && chunks < old_chunks)
@@ -1297,6 +1338,7 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		mddev->bitmap_info.chunksize = bitmap_chunksize;
 		llbitmap->chunks = chunks;
 		llbitmap->sync_size = blocks;
+		llbitmap_refresh_reshape(llbitmap);
 		llbitmap_update_sb(llbitmap);
 	}
 	__llbitmap_flush(mddev);
-- 
2.51.0

