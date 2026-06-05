Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1512E39AAD7;
	Fri,  5 Jun 2026 09:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650950; cv=none; b=ZQYcTPiHPET84/BiYxN7nEQ92yijmhRYlXG+a+kXHiVljvNPYermMgjirbMujvnfsPTRtbJX13/2JamDqVVj2R3Cjel/rI+Dydmku+MzXaaU99IunSU8ecmQ8Dh8uKfEKvSpBU8jTV9Y7JRjjDAkEVWvG/qmgcXtT1tb1pSScHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650950; c=relaxed/simple;
	bh=yg7CyhhIQwVCpk6NNWfYbTZQjJ63uetu94cceUEw0JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIMSw6tFn/srX27HZLRgkhwKpW/AW0QFO4k7lfMcpZ/zBuTJVDrBcNhRBgpsurt2Xt2YJ/SAGw0maU5or7Vrxl+OjxcxHFpkFNp0NN66G/FyrEFt6MkYyShGJYTLv0xC/AsEr+cXibhwX4SW4Z/aCKfxwHR1ii9OD26coXqi/bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XY42hFiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XY42hFiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551EC1F00898;
	Fri,  5 Jun 2026 09:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650949;
	bh=nnNOmq2GJi/KGP1MhqYv/h0DrHTBmsgF+oDIrmAju2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XY42hFiYtqvbjsGnUdHgkv++imQKcn5aRkrQJ0wmZsgnPMJjfwPkZMGJfYsriGNNH
	 Odv6YC20dkR+5jj2JGAs2QAg/GENv56/BiVyPOvNyVoYPm+55R4LRjWyolVRNFWvm6
	 nG+Byj+uFX3DIuGs/XzH9Md6bDdxH0gN1b/5dlBAIAiWG00GrUyTQOssi4LWWj1kvn
	 0jR0x2cee4y0zitCdzICbtw7JOeKkAbKwrORVHCc4zBKSHtWL+KU0XUAmEJBivTsfn
	 ABBkKGzGMppSuEVHXsl2id1ZmOgVDLi1KnBn1Z6QI+JbgbdrWhIsZJa+MRMtXspw7z
	 O9lqxgqJmD3ug==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-llbitmap: finish reshape geometry
Date: Fri,  5 Jun 2026 17:15:15 +0800
Message-ID: <20260605091527.2463539-9-yukuai@kernel.org>
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

Commit the staged llbitmap geometry when reshape finishes.

The reshape staging itself is handled through llbitmap_resize(), so only
the finish step remains in this patch.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index f79538a4eb79..52ab45f2a018 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1677,10 +1677,34 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
 				unsigned long e)
 {
 	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
 }
 
+static void llbitmap_reshape_finish(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (mddev->pers->quiesce)
+		mddev->pers->quiesce(mddev, 1);
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	llbitmap_flush(mddev);
+
+	llbitmap->chunksize = llbitmap->reshape_chunksize;
+	llbitmap->chunkshift = ffz(~llbitmap->chunksize);
+	llbitmap->chunks = llbitmap->reshape_chunks;
+	llbitmap->sync_size = llbitmap->reshape_sync_size;
+	llbitmap_refresh_reshape(llbitmap);
+	mddev->bitmap_info.chunksize = llbitmap->chunksize;
+	llbitmap_update_sb(llbitmap);
+	__llbitmap_flush(mddev);
+	mutex_unlock(&mddev->bitmap_info.mutex);
+
+	if (mddev->pers->quiesce)
+		mddev->pers->quiesce(mddev, 0);
+}
+
 static void llbitmap_write_sb(struct llbitmap *llbitmap)
 {
 	int nr_blocks = DIV_ROUND_UP(BITMAP_DATA_OFFSET, llbitmap->io_size);
 
 	bitmap_fill(llbitmap->pctl[0]->dirty, nr_blocks);
@@ -1971,10 +1995,11 @@ static struct bitmap_operations llbitmap_ops = {
 
 	.update_sb		= llbitmap_update_sb,
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
+	.reshape_finish		= llbitmap_reshape_finish,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
 };
 
-- 
2.51.0

