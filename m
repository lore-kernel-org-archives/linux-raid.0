Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B73388363;
	Wed, 24 Jun 2026 06:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283369; cv=none; b=XwjJQyXcR57iz7ehpkRnBKX2UaVUIQ+hBMQPL2Ej43rrdqOgXFKywNGkcD9rxP8umvWgy5b6orjOGqfbQM8S7rxljgiZPyfxlHBWFKvEP8qqXV7M+S1AkeQWsEeUQ2TGyF6nj0ImtZN5fR1PHjVaYiT9ogfGjlZ6bt9FJ5URCuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283369; c=relaxed/simple;
	bh=pFpQAn/x6KhY7ftrNcswTe1nLHlz+cW5AX9HPsx1GPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6GezfqBE8i6UahS6mlSqMN6rEQl3nuG0Qf+hxlqueI+v3m0cS/4+0jhg4GHBYAJ9RFU3jc7ri70wutLcMKRFK6+rgAUdmAHQNDPli+Xz8B63IOtZKSDAJv2KLSlRImEDeie74oW79/7PcKGkiBHdSHU3iKfhWIPEVariOpaWVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohrXqCCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohrXqCCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009951F000E9;
	Wed, 24 Jun 2026 06:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283365;
	bh=4fW/zuBGgGUKNgyNHaFCjZgNaJ1kEMMzGCwNI1FS8qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohrXqCCz8Cfz9/TCTHEUoDAe1qGrp45O5O2fq539owXKOR3uPDy519m13REb1VqIf
	 17UoLl3ppCQIKGwFWDZ0JHtP77NYG76Tpz7xxYlPJ9KC95yXyne+fPRzXt0gOXUP3n
	 15iilN5ef7xaj9bAZw2LQbdkIeJ5z8tA/kgYtDusgs7j/0sNCL2rF5pxRCVdWWa+Kt
	 hMTefa30Pzzm6r6nbHe4A1IlfwhHYnA+r/Mhn2gSCJgtOa9Vde8OyXj7RDGjmDTd/E
	 wbhD6nBUeJVCjq4JhtgVk3itzZeCxfWhgSNqV8dA/ruV5DOItg4M/wz9r2pHvEXuwK
	 4qV2r35I73iFg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/20] md/md-llbitmap: refuse reshape while llbitmap still needs sync
Date: Wed, 24 Jun 2026 14:42:06 +0800
Message-ID: <fde37bced9be5e6b4d0f71cdd7d33d9387c022f6.1782282042.git.yukuai@kernel.org>
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

Reject reshape when llbitmap still contains NeedSync or Syncing bits.

This keeps reshape from starting until the current llbitmap state has
been reconciled.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index ae2e87fd5887..11fede1fc79f 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1680,6 +1680,29 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
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
@@ -2002,6 +2025,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
 	.reshape_finish		= llbitmap_reshape_finish,
+	.reshape_can_start	= llbitmap_reshape_can_start,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

