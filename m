Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C8F2FD7BE;
	Sun,  1 Mar 2026 01:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329940; cv=none; b=jydjZwDnVWViFPy4kwQgLicC74h2V3k986Nx29TX6HRaJfacq88CJP74KaHMcvnCgf7UJ0cWkGvYJIoFP3OKB//15iOV0T2U0829CvVCoXy2I6TyumYuLhduYbhAgaOfUuiVuumjT+uRs3uPmMGiTANZBC3Iqc78HYW4RY6k0Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329940; c=relaxed/simple;
	bh=8lbF1j8bYc2jjw1q7zHSl0yiArpqCszERv6Ckuw9lKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ExxbfcSDRbDj71ggWuDpT/XZ5LqAKnLEp8jMJEjH0nX+DwT0Qrz9KJE7wWPeN1KIShBeOg4K7JEBYEpEMv+EOjbgrg7oTwHd+N//5udFikheFf3EAohq5xIRDhA1XQLTBaY7pmwinwKT7C2aqD4i6DbWBreHBYInEYthpAI4z20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRzobopH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRzobopH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4ADC19421;
	Sun,  1 Mar 2026 01:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329939;
	bh=8lbF1j8bYc2jjw1q7zHSl0yiArpqCszERv6Ckuw9lKc=;
	h=From:To:Cc:Subject:Date:From;
	b=rRzobopH0/8uqv36Pb+6xjDCWg2IwJlsVlKBCweYPBOfxYd3xlKYRssjWcbZY43XG
	 /kbQFYNiSGU7eiXSCYS1H5Z55QCdo6rmoUvsxh9KiU4tKzXXjBtr2zU0mv173/go5f
	 PDGXIIxaXD0F7t61aP1S3lCvNxMxhPIPru8N0gngiiAli5m2kvde2Ky8GrQ82cf7Ie
	 DJuWv88llaIe81/CIYcekNUaeSGu+RQSUTN9MgqJI+UbjRFW/GlE2xmVpKQv8hwKj0
	 wVrGApXSbV1PDWauTyLf3Ets2L2Vyz7mrOOEgwh+dnsr+OfbPTPgKp56E/TGeQYovC
	 dmbiC5bxQCSBw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	jinpu.wang@ionos.com
Cc: Yu Kuai <yukuai@fnnas.com>,
	linux-raid@vger.kernel.org
Subject: FAILED: Patch "md/bitmap: fix GPF in write_page caused by resize race" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:52:17 -0500
Message-ID: <20260301015218.1718763-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 46ef85f854dfa9d5226b3c1c46493d79556c9589 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang@ionos.com>
Date: Tue, 20 Jan 2026 11:24:56 +0100
Subject: [PATCH] md/bitmap: fix GPF in write_page caused by resize race

A General Protection Fault occurs in write_page() during array resize:
RIP: 0010:write_page+0x22b/0x3c0 [md_mod]

This is a use-after-free race between bitmap_daemon_work() and
__bitmap_resize(). The daemon iterates over `bitmap->storage.filemap`
without locking, while the resize path frees that storage via
md_bitmap_file_unmap(). `quiesce()` does not stop the md thread,
allowing concurrent access to freed pages.

Fix by holding `mddev->bitmap_info.mutex` during the bitmap update.

Link: https://lore.kernel.org/linux-raid/20260120102456.25169-1-jinpu.wang@ionos.com
Closes: https://lore.kernel.org/linux-raid/CAMGffE=Mbfp=7xD_hYxXk1PAaCZNSEAVeQGKGy7YF9f2S4=NEA@mail.gmail.com/T/#u
Cc: stable@vger.kernel.org
Fixes: d60b479d177a ("md/bitmap: add bitmap_resize function to allow bitmap resizing.")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-bitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index dbe4c4b9a1daf..1d4a050dab3ab 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2453,6 +2453,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
 		       sizeof(bitmap_super_t));
+	mutex_lock(&bitmap->mddev->bitmap_info.mutex);
 	spin_lock_irq(&bitmap->counts.lock);
 	md_bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
@@ -2560,7 +2561,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
 	}
 	spin_unlock_irq(&bitmap->counts.lock);
-
+	mutex_unlock(&bitmap->mddev->bitmap_info.mutex);
 	if (!init) {
 		__bitmap_unplug(bitmap);
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
-- 
2.51.0




