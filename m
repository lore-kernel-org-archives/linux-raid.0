Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9854C77B0;
	Fri,  5 Jun 2026 09:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650952; cv=none; b=K7jmi4XPuuPJbTxLCyyXUUv2jsbMp2zV2fF2dabxzlMrTX1StsZDtDC++av2VnnVDCHw+4TL3hHhswb+BUU/hxj8CtAjogM6vAeYv2K92o7CGiYu2xu+wdSVeXnid2T3W1QTq19XfqraQZze9GkrGbxmtFUrhUu003bWPE+gDfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650952; c=relaxed/simple;
	bh=xeAqRu+XfLgfoWt8qv4F5fUV7Lm4v3UJeEqQmiMQF/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQVuEilX0nIEaD0ERFToX1X9emVxdSaVPGqc1iaXMirmyT+mSom41t/emKw+UOeYwcAGl+vjhQxNZOS7MGjG8Yr5xNjARHfZi8kX0RZ4GqIZBWcK9unPfBCkIGnRnNjlfGJI0KYnw8lhXeF0xtpqQ+f57iCAUu6FUc2WXCKMDqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDYiI6+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDYiI6+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACA01F00893;
	Fri,  5 Jun 2026 09:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650951;
	bh=o1esgYP4s0s+c4EyQXs0UfsFhmbcfENcrp3SgHa2O14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDYiI6+KqDHV5RrHIGAPY8B/ENlkxysic9/zSTYpjKt5lYS2tC+GN2iwBA5gENRSi
	 LyL0UHJBrehGUHuL7aBnD3Ym12xklau74ET5neCwjVjIktiOC8mde6j6c978M2MFs+
	 fNVOf3kyv7qWB5evDCauKOMyojFSndNpF/inWdAJ0uCppexr1thzoEbwO5Po7/tUJz
	 4whwfa0wnLx3QZRaJgHKwhlJbvypVLYx8RVjmltrjSCeZlp3OgvcUl/OGUzvU/P6jw
	 yNmvRT3HoqZS0L+rImh7S4G8LifmutD5tkgazsJt+ojIB9m3PWb71/6yPwvsDwikcN
	 0UN6mQl7I3s/w==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-llbitmap: refuse reshape while llbitmap still needs sync
Date: Fri,  5 Jun 2026 17:15:16 +0800
Message-ID: <20260605091527.2463539-10-yukuai@kernel.org>
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

Reject reshape when llbitmap still contains NeedSync or Syncing bits.

This keeps reshape from starting until the current llbitmap state has
been reconciled.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 52ab45f2a018..f45daf3be4d5 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1677,10 +1677,33 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
 				unsigned long e)
 {
 	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
 }
 
+static int llbitmap_reshape_can_start(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long chunk;
+	int ret = 0;
+
+	if (!llbitmap)
+		return 0;
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	for (chunk = 0; chunk < llbitmap->chunks; chunk++) {
+		enum llbitmap_state state = llbitmap_read(llbitmap, chunk);
+
+		if (state == BitNeedSync || state == BitSyncing) {
+			ret = -EBUSY;
+			break;
+		}
+	}
+	mutex_unlock(&mddev->bitmap_info.mutex);
+
+	return ret;
+}
+
 static void llbitmap_reshape_finish(struct mddev *mddev)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
 
 	if (mddev->pers->quiesce)
@@ -1996,10 +2019,11 @@ static struct bitmap_operations llbitmap_ops = {
 	.update_sb		= llbitmap_update_sb,
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
 	.reshape_finish		= llbitmap_reshape_finish,
+	.reshape_can_start	= llbitmap_reshape_can_start,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
 };
 
-- 
2.51.0

