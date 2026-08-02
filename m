Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC40331EAB;
	Sun,  2 Aug 2026 19:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700307; cv=none; b=sg3edrTWSV39F1B/J69NzLxhwrl74WMZBTwU6kWZuT+HrYzlQEwbfYFf+/mSbsKKx6p99yu12Bv7oP83U1DSnoc4vbHKJoi1F/+e7hPghePOhH6rPz6jDQk7x4W76funzXOP50Qv6NTzZNwL4zzbzXLkTh+BjeIkAris1O4YDDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700307; c=relaxed/simple;
	bh=lAlHtBTsEC8W2Q2572d5X6A3WNwSXAYJi0r/+zXgnDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efg6EWs582yhJQBnU9tWt+rNkv75da6L16J5pgWDOeutVgD/Du/hPF5k33xuKMRKuE6YcRIrEDknT7xgslwX9WCCsMPvhno5zEZcBcaZTr7hxurh8RsMb3vTUMCsCmaScNYLR8JhTH0fhbHKLzCYz0DxLIzV2H+KMg4cCuZsdcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niamU0uA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niamU0uA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C901F000E9;
	Sun,  2 Aug 2026 19:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700305;
	bh=imcEUxtNLe0XJGPCb7oqWIt8GkXPc+zCyHeqJYskS/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niamU0uAwt0eH2npySELIucX1ueU1mQx7R/yxSSotgIZYWvbIO408VWaddOUXesBc
	 WQqdv212zhl+sU+HCSezt7OXzsJmqf4m3MziYDmWLuZ6ipqngOmoIiWqfKvSA2I6gO
	 gFlFoi3E0qavcPIAZ7alrje4Yx+3ozzWAAhGexW6L9FwGeefQvkKW1d23NJJVJjh2L
	 mNINyaoesJHJ/EI697Bqmk0bv9raPGpNGNySjBoZ1lSFELuqDEGYKAKDZVJgHuRf8Z
	 SOdTIBgZKIX4/6ayna/s4bf9E5TOgowpU4eaWIP+bGFHhMU5N6caRu2fTmREgHslnK
	 xOODsjrZJauGg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 16/29] md/md-llbitmap: track target reshape geometry fields
Date: Mon,  3 Aug 2026 03:50:25 +0800
Message-ID: <20260802195038.164272-17-yukuai@kernel.org>
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

Track llbitmap bookkeeping for the target reshape geometry while keeping
a single live bitmap instance.

Add the reshape geometry fields, refresh helper, and update the load and
resize paths to keep the target geometry in sync.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index ddeea2098987..71a490390142 100644
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
@@ -1030,6 +1066,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
 	llbitmap->sync_size = blocks;
+	llbitmap_refresh_reshape(llbitmap);
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
 	ret = llbitmap_alloc_pages(llbitmap);
@@ -1146,6 +1183,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->sync_size = sync_size;
+	llbitmap_refresh_reshape(llbitmap);
 	ret = llbitmap_alloc_pages(llbitmap);
 
 out_put_page:
@@ -1302,6 +1340,9 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		goto out;
 
 	if (reshape) {
+		llbitmap->reshape_sync_size = blocks;
+		llbitmap->reshape_chunksize = bitmap_chunksize;
+		llbitmap->reshape_chunks = chunks;
 		llbitmap->chunks = max(old_chunks, chunks);
 	} else {
 		if (blocks < old_blocks && chunks < old_chunks)
@@ -1310,6 +1351,7 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		mddev->bitmap_info.chunksize = bitmap_chunksize;
 		llbitmap->chunks = chunks;
 		llbitmap->sync_size = blocks;
+		llbitmap_refresh_reshape(llbitmap);
 		llbitmap_update_sb(llbitmap);
 	}
 	__llbitmap_flush(mddev);
-- 
2.51.0

