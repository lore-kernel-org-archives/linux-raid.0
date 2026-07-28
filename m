Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DE441B8C3;
	Tue, 28 Jul 2026 08:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228617; cv=none; b=nEXUOX2X3Tfb4gi1ZKhId48bqkxuk9dfD3sUb+CPNSwQ9TlWdqRJqlIygEQrgc16K6QixmzRkYNnt4Bp3djDvBtbwmFXXfeyb5T9CCD0qB0BnYByJmKuA3ehXcBTfHfi7JkZl2rUeQ832s/TmsNSuumhwMc7dTBuMNT8g3dli6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228617; c=relaxed/simple;
	bh=OfBgbdgGO/SbtbQ+rrthB5x0Ye+Tkm6o0ovBdiGHQo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCVOYL7IC6jXc2VrtoBolCtuJaBejJihbdnS0XPz9uepG4H5nmIOMxhgrExdjljmAyDbSh9KTbS7UsGvlMAY8xVzgsx1n/iwN033R/YdO3InvEdZlhs/+Ywzapp+0R2TX8tLtaD4KqdfjJlRQCYL0ogvO6PUS2MbpX5i/rm8ZaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IV0jfX4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IV0jfX4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A9F1F000E9;
	Tue, 28 Jul 2026 08:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228616;
	bh=WpthyC6REHYh1KxU8/PwVt2GMOiTs/0acPWHIjBoJsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IV0jfX4zla3+Xz/SMX0mXLzBD1YvmPmtLImoxC53xCusqzPt+VNmKhRjP/duWxyXu
	 sAIaLKVcDncm8tNidhLhsM0mLU3Unpzji59p9t8T5/VM5gje3IqFdPpwVRqxon8nwQ
	 5CNqjNvI89sdIoz5sZddjoLNxBvi0F22Rzo9g/XK1vHGyzLltMP/GoSUtLFOw2InFC
	 11wAUVuKtPDNMFCi14SuQGHgFu+lIppvkfbndV0DNF+ra7jdd0v425G/d8qyl3WcZx
	 565acBAsdhDFV3BIPGB115HmWESaIFLud1IsXwawHtfBnAAjdLfwItLG/CtAuVv976
	 FZlhGjKhO7MoQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/21] md/md-llbitmap: refuse reshape while llbitmap still needs sync
Date: Tue, 28 Jul 2026 16:49:10 +0800
Message-ID: <0acf74e3881021e14f5a254480f06642ad911d3a.1785206690.git.yukuai@fygo.io>
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

Reject reshape when llbitmap still contains NeedSync or Syncing bits.

This keeps reshape from starting until the current llbitmap state has
been reconciled.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 55ab2a8a11e5..f5df82adef64 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1689,6 +1689,29 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
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
@@ -2011,6 +2034,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
 	.reshape_finish		= llbitmap_reshape_finish,
+	.reshape_can_start	= llbitmap_reshape_can_start,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

