Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1291296BC1;
	Sun, 19 Apr 2026 03:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568208; cv=none; b=Ki1YEH7CKHP20f+rNbOEJgccHFn6SLjI13nqCic1Bm54D6gIMngiWQeO1sNDRzGy7VqV5exanXpHB+FGZ26hN8vQYmkKGInrbeuCfvF6gIxzfTRqF6fvYBZzFUW1MRfK2lloK/XA2KeMbcLnZGxT+WJFnmZxBcCUD1uuHByd5GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568208; c=relaxed/simple;
	bh=DMICUwxQ3D7M6jznk3A4TPUUbKtWyq1WaQzbubW6TQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2qP0m5FAKBaMyVBF4S6MzxCbE9Bk2Ph19aZtejJF5IC1tlAQkt/aRUFzMpqwkmJKfX5ojzz/fR9/TVE9GoMlqYiGFPwklfS/DjVm7hCF+VcKGiSKdkOGaCjYIfYehTjMSLckHz/EEo2Il5LIkAgtxn4vnAZj5bVi43wWNaGAZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BD0C2BCB0;
	Sun, 19 Apr 2026 03:10:04 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/md-llbitmap: track target reshape geometry fields
Date: Sun, 19 Apr 2026 11:09:29 +0800
Message-ID: <20260419030942.824195-7-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419030942.824195-1-yukuai@fnnas.com>
References: <20260419030942.824195-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Track llbitmap bookkeeping for the target reshape geometry while keeping
a single live bitmap instance.

Add the reshape geometry fields, refresh helper, and update the load and
resize paths to keep the target geometry in sync.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 841b64f0b4e6..cfd97022b283 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -269,6 +269,9 @@ struct llbitmap {
 	unsigned long chunks;
 	/* total number of sectors tracked by current bitmap geometry */
 	sector_t sync_size;
+	unsigned long reshape_chunksize;
+	unsigned long reshape_chunks;
+	sector_t reshape_sync_size;
 	unsigned long last_end_sync;
 	/*
 	 * time in seconds that dirty bits will be cleared if the page is not
@@ -364,6 +367,38 @@ static void llbitmap_resize_chunks(struct mddev *mddev, sector_t blocks,
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
@@ -902,6 +937,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 	llbitmap->chunksize = chunksize;
 	llbitmap->chunks = chunks;
 	llbitmap->sync_size = blocks;
+	llbitmap_refresh_reshape(llbitmap);
 	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
 
 	ret = llbitmap_alloc_pages(llbitmap);
@@ -1013,6 +1049,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
 	llbitmap->sync_size = sync_size;
+	llbitmap_refresh_reshape(llbitmap);
 	ret = llbitmap_alloc_pages(llbitmap);
 
 out_put_page:
@@ -1168,6 +1205,7 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		mddev->bitmap_info.chunksize = bitmap_chunksize;
 		llbitmap->chunks = chunks;
 		llbitmap->sync_size = blocks;
+		llbitmap_refresh_reshape(llbitmap);
 		llbitmap_update_sb(llbitmap);
 	}
 	__llbitmap_flush(mddev);
-- 
2.51.0

