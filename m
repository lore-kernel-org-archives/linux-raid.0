Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8A92FB08E;
	Wed, 10 Sep 2025 20:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757537257; cv=none; b=onvfFHdamOvQms2ZshPGilFxbTbd9W8P9fNUHBpR44xtyfzuh+UBK4OQEidBbMsYBtg35TSnjWu3geqeuAleT5GjTnnvveHb2AF3Uw9pBq5Qv77eUDvVZ4ePJDTD94o72vubCbRA346ajxqH8DWzwRsqkF4Ro0z4FyyemF2ldrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757537257; c=relaxed/simple;
	bh=B9nXx/uAd8bzj5r9K99vQjrO7Sot+mOg+1OtU9x4TJA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=YnxNTfnY9KDSSC3jKprg16OFlKPDV0ktl0qPiQE3GHHWYb1gQSYPUjniCQ2i7YSVQUnUX01CGs42G4p7GgZNFJ7da7kAcTUFtg3+6gmdkuLcJIHoGm/aL/cgeHDikn+e6undnK9l8STHKW9YBQwhyQmfb+I7qyOYVZrTJHfpp+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pw4J8UXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pw4J8UXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82205C4CEEB;
	Wed, 10 Sep 2025 20:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757537257;
	bh=B9nXx/uAd8bzj5r9K99vQjrO7Sot+mOg+1OtU9x4TJA=;
	h=From:Date:Subject:To:Cc:From;
	b=Pw4J8UXkQy5+jBVfd2aWCgPsOF3LXMVECSVAQ09SL5iQQH4LNdhmS4nAJ1faOP54w
	 ZwSIkie9GiLSvp+f7iCn7fSdm9n84HnC8sf8KmAF0F/BqyPuevrnzZ/z2kDIo1uR2E
	 LDGFqR+kGG7GXalmI3uppOIJMjiDbCQ+8MKaiTZ77pZtqc3REy0f8pCsLYZRjZiLR9
	 JDm8j7NNFYFTSDa8ktJuX0nJkLSRKqknAhEJ1lW4wlFs2bVkPyPDrzrxDsVQntH2Fp
	 7q8v+cJ7zA23X9PUu/eM3d6Q36AFFNkPHmZSSRO8ISV5/PPLQV15QvM2GpjZnX69G1
	 RnZH0iosdNKlA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 10 Sep 2025 13:47:26 -0700
Subject: [PATCH] md/md-llbitmap: Use DIV_ROUND_UP_SECTOR_T
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-llbitmap-fix-64-div-for-32-bit-v1-1-453a5c8e3e00@kernel.org>
X-B4-Tracking: v=1; b=H4sIAN3jwWgC/x2NSwqEMBAFryK99kESP0SvIi4yk3Zs8EciMiDef
 ZpZFq94dVPmJJypL25KfEmWfVOwZUHvOWwfhkRlcsY1prMGy/KScw0HJvmirRHlwrQnVA46oPO
 +CTY676ua9ORIrOI/MIzP8wNeZXLKcAAAAA==
X-Change-ID: 20250910-llbitmap-fix-64-div-for-32-bit-9885a1d28834
To: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai3@huawei.com>, Li Nan <linan122@huawei.com>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4615; i=nathan@kernel.org;
 h=from:subject:message-id; bh=B9nXx/uAd8bzj5r9K99vQjrO7Sot+mOg+1OtU9x4TJA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBkHHz+33p76/YjXv9aEo7McPZx06tnZ1p96u/HJjRnKI
 vXFPam1HaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi3QqMDDta8xw7jy3cXzrt
 U0JPWtyFDM7Xvls5Fn99fUY6VLX4UQojw9na7EeCpj3ZNuuPvSg+9Hju1L/Sq2Xf+Cf1aNztWGZ
 9iRUA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building for 32-bit platforms, there are several link (if builtin)
or modpost (if a module) errors due to dividends of type 'sector_t' in
DIV_ROUND_UP:

  arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o: in function `llbitmap_resize':
  drivers/md/md-llbitmap.c:1017:(.text+0xae8): undefined reference to `__aeabi_uldivmod'
  arm-linux-gnueabi-ld: drivers/md/md-llbitmap.c:1020:(.text+0xb10): undefined reference to `__aeabi_uldivmod'
  arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o: in function `llbitmap_end_discard':
  drivers/md/md-llbitmap.c:1114:(.text+0xf14): undefined reference to `__aeabi_uldivmod'
  arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o: in function `llbitmap_start_discard':
  drivers/md/md-llbitmap.c:1097:(.text+0x1808): undefined reference to `__aeabi_uldivmod'
  arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o: in function `llbitmap_read_sb':
  drivers/md/md-llbitmap.c:867:(.text+0x2080): undefined reference to `__aeabi_uldivmod'
  arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o:drivers/md/md-llbitmap.c:895: more undefined references to `__aeabi_uldivmod' follow

Use DIV_ROUND_UP_SECTOR_T instead of DIV_ROUND_UP, which exists to
handle this exact situation.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/md/md-llbitmap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 3337d5c7e7e5..1eb434306162 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -781,7 +781,7 @@ static int llbitmap_init(struct llbitmap *llbitmap)
 
 	while (chunks > space) {
 		chunksize = chunksize << 1;
-		chunks = DIV_ROUND_UP(blocks, chunksize);
+		chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
 	}
 
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
@@ -864,8 +864,8 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 		goto out_put_page;
 	}
 
-	if (chunksize < DIV_ROUND_UP(mddev->resync_max_sectors,
-				     mddev->bitmap_info.space << SECTOR_SHIFT)) {
+	if (chunksize < DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors,
+					      mddev->bitmap_info.space << SECTOR_SHIFT)) {
 		pr_err("md/llbitmap: %s: chunksize too small %lu < %llu / %lu",
 		       mdname(mddev), chunksize, mddev->resync_max_sectors,
 		       mddev->bitmap_info.space);
@@ -892,7 +892,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 
 	llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
 	llbitmap->chunksize = chunksize;
-	llbitmap->chunks = DIV_ROUND_UP(mddev->resync_max_sectors, chunksize);
+	llbitmap->chunks = DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors, chunksize);
 	llbitmap->chunkshift = ffz(~chunksize);
 	ret = llbitmap_cache_pages(llbitmap);
 
@@ -1014,10 +1014,10 @@ static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 		chunksize = llbitmap->chunksize;
 
 	/* If there is enough space, leave the chunksize unchanged. */
-	chunks = DIV_ROUND_UP(blocks, chunksize);
+	chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
 	while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
 		chunksize = chunksize << 1;
-		chunks = DIV_ROUND_UP(blocks, chunksize);
+		chunks = DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
 	}
 
 	llbitmap->chunkshift = ffz(~chunksize);
@@ -1094,7 +1094,7 @@ static void llbitmap_start_discard(struct mddev *mddev, sector_t offset,
 				   unsigned long sectors)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
-	unsigned long start = DIV_ROUND_UP(offset, llbitmap->chunksize);
+	unsigned long start = DIV_ROUND_UP_SECTOR_T(offset, llbitmap->chunksize);
 	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
 	int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 	int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
@@ -1111,7 +1111,7 @@ static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,
 				 unsigned long sectors)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
-	unsigned long start = DIV_ROUND_UP(offset, llbitmap->chunksize);
+	unsigned long start = DIV_ROUND_UP_SECTOR_T(offset, llbitmap->chunksize);
 	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
 	int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
 	int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;

---
base-commit: 5ab829f1971dc99f2aac10846c378e67fc875abc
change-id: 20250910-llbitmap-fix-64-div-for-32-bit-9885a1d28834

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

