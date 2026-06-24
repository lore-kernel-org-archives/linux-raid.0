Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7BF38AC75;
	Wed, 24 Jun 2026 06:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283368; cv=none; b=EL6x1UMB+7srrKbvgootlfaH0sIaEQsfKT6x5TsIgbpJ01+BPaDN8YXX2ilXC2A2Ase26hmAYMCWGo+HpkEkqVh143s9U9vU89PR2jm0A/OhtSlqMNmwGspMUoyQwTjFw/cFp2EKvCA8+YdTqEfUcPZi8Aa8OZnhxxGz3NlxynE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283368; c=relaxed/simple;
	bh=ej1zq0GGvXd56XB9ngqTAAuTKhigTcRPZMrir/hK7GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmQfuA+kFeJxYn5xl6x6CSL1dhHeI0ap+giBMD4Ya1V6FgkEcoXCOkuSVj9fkSH9RwsR5GhscXfDPY0WFKdrJeEgtlC16ZGvFHyfifMxo5/hogpJ6v1adfEigHfIpMt23dybJ7axPlQmbowmDamHqnBuqASe4Hjk19nj7lDJb4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a990Vwy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a990Vwy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978541F00A3A;
	Wed, 24 Jun 2026 06:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283363;
	bh=Z7B0Fn/TqgguIdxE91QnM6TajeZHR72v+6vJJ0hIUZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a990Vwy3IfCWt7UGJ4gdxRegxhXkphVW3PvsoGi9nMIyJAKMioCOAiBJUQGxUi67H
	 cgvdi3ET3HH3EAeOOLGMvv1tySKLgmHz2Vch2O3nnjT1Uc3Y8kITwb7SJxSEt47Fix
	 FjZ7adCrLRDUllfUUzfdLb+OSwsnoLzHGe+iPPszh0EDRbfyFWPhdMU9NwnQjxX+n4
	 O+HeDR4OfpoVUrtdFLBiOzn5rKJDuJZIjG76CT+yOzmdzQXhg+jGnpZIH3gJEkXRmp
	 EjW/VsNlUJ2DvL+7DcgwxZ4Xetx+TiGNpl1ZxeCes6KquzgkiZEzid9EbXi3iNlZzT
	 lZj85fANDc05w==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/20] md/md-llbitmap: finish reshape geometry
Date: Wed, 24 Jun 2026 14:42:05 +0800
Message-ID: <73a8a0409b741c57bbc9927abc7a9981cbafbf27.1782282042.git.yukuai@kernel.org>
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

Commit the staged llbitmap geometry when reshape finishes.

The reshape staging itself is handled through llbitmap_resize(), so only
the finish step remains in this patch.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index cdced2126e97..ae2e87fd5887 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1680,6 +1680,30 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
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
@@ -1977,6 +2001,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
+	.reshape_finish		= llbitmap_reshape_finish,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

