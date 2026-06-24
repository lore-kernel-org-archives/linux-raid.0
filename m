Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBE5388378;
	Wed, 24 Jun 2026 06:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283362; cv=none; b=V+IAmsgUduW9pPXmbhRXkJzlvnN/qaenn5Kxtqw5Xi6oa94eaaGntRYhxLhXei+8Rvlo2WJBb4SXH7S/C7cOD99bU0C2g1qS6w2FfHzBZ6Wn14cTtz1dbI6BNmmz7HGUARZk1az2Xfbl3uFNG5w9c5dZRZMvZRSlC9ZWun+WNKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283362; c=relaxed/simple;
	bh=dn+4drJvKh7XR2tkAXyUC8o3310f9qkZ1gVdebwhTsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIv0edT+MTtm4/Kd/wmYOPpG6QuYhjPli6GTDYAHIm/YNPHbutHjyR0SvHBHd3JdOxjEFZUCi768SnIfX4MMZiZzjE4PQYP/3YSkRt0/HssVnCWRqQ4tpSvuYdm2vEo4JLpSZMAc4UwNEtIuJdzlTcoqVzamwoCslbI7bg15cSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/UkeX5r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/UkeX5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0AD1F000E9;
	Wed, 24 Jun 2026 06:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283361;
	bh=8gKrtMiV8BM2LBqO9lS12wIt4TXRcA7sxkYpDsLJbuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/UkeX5rTsH1+OLnTMe6Bwq1sFkL17dKRI71s4NjjFBt0vncyF6O5p4RywrQ9Eszh
	 CSI+P1P+SlQ9CVruWb6yymLKWmMNpttA08O5cQKxu4L0KzDaV5Y0tfHzCBsZjwa3Qa
	 Be+C4vhdUgx8aRfB9TDhF8B/fJGFS+BnHoQVg+wyhgkvxt9mi6mCHaNVPwhOTs63mS
	 rw0XBDWO4UFyvGXd9JtDSLlnCfCPojBvNv//U3cCNJggqaPMbCkTGpYRLL5zJBJRgt
	 ZizhX+1Lo1gdIzAPxcmkz6zN/glx2oH5Gq402AU0NGuhv4KVBl8z789U5dpUql6kf0
	 Wm8Z4ml0/V3TA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/20] md/md-llbitmap: track target reshape geometry fields
Date: Wed, 24 Jun 2026 14:42:04 +0800
Message-ID: <5440f676d6637f4c0262862252191c2244363087.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
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
 drivers/md/md-llbitmap.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 98e7824c7362..cdced2126e97 100644
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
@@ -1295,6 +1333,7 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		mddev->bitmap_info.chunksize = bitmap_chunksize;
 		llbitmap->chunks = chunks;
 		llbitmap->sync_size = blocks;
+		llbitmap_refresh_reshape(llbitmap);
 		llbitmap_update_sb(llbitmap);
 	}
 	__llbitmap_flush(mddev);
-- 
2.51.0

