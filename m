Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A76238171;
	Sun,  1 Mar 2026 01:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328230; cv=none; b=aZEK/XnjeQERK4l0itSuebEja/3I3mW4SrmH/6WaZhpZsJAgPP0yfWtSLueFg2dc96teVO6tVrNh/yN0njOyn5ZubiopeiEHT4T6sleyBndQ9SyCnzlP6hDA5D5v9NhjYUsObFs0TqULEYMqAP/gym6eTYSKgpRfej0G7i/ktbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328230; c=relaxed/simple;
	bh=MEmVbscMLfi8nxzOZKPHf3zPofiz7/IydSOqD+e6e50=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XWxl41A7NCWj5Vrzi7vUBj6MeAOGr/cMDj+eCYhu3Cjtm03o4OeHEhxJXRj/OBNe5gDeTVqN4gRmlJqsPqYcqwAtMtJUD9khn8BE1w4iQlZhoEJMH22ot7KGSNRtdMuCMuR2HrHzEU2o9+15tG5d5s4wNHYsmitmKZqfBwzv5Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CVPtCuR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CVPtCuR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33668C19421;
	Sun,  1 Mar 2026 01:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328230;
	bh=MEmVbscMLfi8nxzOZKPHf3zPofiz7/IydSOqD+e6e50=;
	h=From:To:Cc:Subject:Date:From;
	b=CVPtCuR9hwUdmp5vZ4Wj/UKuXZJq6JBm6FNaeYZmmPIjH8U8SfiAkznnSLBsIGxzA
	 4qgLof7+V13DHn4H5LIkAEyLCRv/hbQ5x2TReb5Tk6ZeuWDw6nz70FeYIFwbcVl53i
	 /Gi7KAHLGz9wsezMTJTyb7lllbpAsnbFb4ftvzBNIXKM4y0m3hziCfuKcXzIRHoM8U
	 LENCxSJZDwFVF9tYbIPPEzsWyAaIc3jDVvAR15wDtTS+TryJ/+HCdLcSQ2H6Ybheb4
	 ZsVT8SUxDAZsfNsmLNAZb1Bw2xTAfsAl6+RW+iLjSrnj9a7gIry8gM2B0E0ELXhpae
	 VvCWo0WD+BeFQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	jinpu.wang@ionos.com
Cc: Yu Kuai <yukuai@fnnas.com>,
	linux-raid@vger.kernel.org
Subject: FAILED: Patch "md/bitmap: fix GPF in write_page caused by resize race" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:23:48 -0500
Message-ID: <20260301012349.1680573-1-sashal@kernel.org>
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

The patch below does not apply to the 6.12-stable tree.
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




