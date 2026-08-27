Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A63A3A2E3F
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 07:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817413; cv=none; b=rE2+kZq6oHLszdJ3Z1ho9E8bpe2znhkVTkAUEjQdXm2riLASJdNRoOkJ9+2SOWZN0oSFi1tJCLu2pop7BrH6LQ39EoqtKKp5V7QwXyCMxLN5Nb67OubcRQ+i2Z831VRzT1YIABbvuRmWwkKv8NtTniWEngaaDOh5eR6KbykKYXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817413; c=relaxed/simple;
	bh=Yd0QBXR5OCWN6B6BOvACRvyr3MRYANfFeaBWbB6EomI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OINQJA/Udvhj3flPD8AFHr8OlWG1iqgKDnykfGsbx8FlGkXk43r+BM10Yqiw2vJPgXl/r7E8Ec6+4byWYszodAaxS6Nrneqk1AWFnVW/K+ITzui6FLGX1g1ykDfXBNaBkYD/eHJroqbAvnQyoefOoJ9GY522nTqHh6oLlUXu9Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=hxp8UQHY; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="hxp8UQHY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=i8
	d2+rXZNC3eZgTKBr+lhMcahtbqu019+ehB0gl8Ix8=; b=hxp8UQHYuw9G2sPzEq
	lhs2ZG8x/x38AhCYhOIktW/T3o4ydKOdAj8JDbImBQ6NXmTZZLzCQaKRYgoMMMyA
	ZNVeTBiAK3+K6kW00s+mTZ4nj0+EqkVnxTdCMTGcrD0+RtG07HGGzTrmO7lnzKi7
	tVhqngqgTHDNC59+NukS4gQmU=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnY4im7Y9qjfSOSQ--.19943S4;
	Thu, 27 Aug 2026 15:56:26 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>
Subject: [PATCH 2/3] md/raid1-10: add rdev_bb_block_sectors() helper
Date: Thu, 27 Aug 2026 15:56:19 +0800
Message-Id: <20260827075620.3599227-3-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260827075620.3599227-1-dayou5941@163.com>
References: <20260827075620.3599227-1-dayou5941@163.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnY4im7Y9qjfSOSQ--.19943S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxAFW5Wr48CF15Wr4rur4UJwb_yoW5Xr4kpa
	97WFyfX3yUKFy0qanrA3yUu3WFva43KFW7Cry7u398WFyxJrZrGF4rJrW5WF1jqFnIgF9F
	qa1UKrWUC3WDKFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jwqXdUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3gok0mqP7apFxgAA3D

From: Li Youhong <liyouhong@kylinos.cn>

raid1 and raid10 narrow_write_error() use the same logic to compute the
badblocks-aligned block size. Factor it into an inline helper in
raid1-10.c. No functional change.

Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
 drivers/md/raid1-10.c | 10 ++++++++++
 drivers/md/raid1.c    |  7 +------
 drivers/md/raid10.c   |  7 +------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 3b0e230692ba..c7ddf136771d 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -155,6 +155,16 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
 	return true;
 }
 
+/* Block size used when narrowing a write error down to badblocks granularity. */
+static inline int rdev_bb_block_sectors(struct md_rdev *rdev)
+{
+	int lbs = bdev_logical_block_size(rdev->bdev) >> 9;
+
+	if (rdev->badblocks.shift < 0)
+		return lbs;
+	return roundup(1 << rdev->badblocks.shift, lbs);
+}
+
 /*
  * current->bio_list will be set under submit_bio() context, in this case bitmap
  * io will be added to the list and wait for current io submission to finish,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9d8441348f14..8a40c69d70a3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2465,16 +2465,11 @@ static void narrow_write_error(struct r1bio *r1_bio, int i)
 	 * We currently own a reference on the rdev.
 	 */
 
-	int block_sectors, lbs = bdev_logical_block_size(rdev->bdev) >> 9;
+	int block_sectors = rdev_bb_block_sectors(rdev);
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r1_bio->sectors;
 
-	if (rdev->badblocks.shift < 0)
-		block_sectors = lbs;
-	else
-		block_sectors = roundup(1 << rdev->badblocks.shift, lbs);
-
 	sector = r1_bio->sector;
 	sectors = ((sector + block_sectors)
 		   & ~(sector_t)(block_sectors - 1))
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c4218d6483ed..5b1dbb0b7f5a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2762,16 +2762,11 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 	 * We currently own a reference to the rdev.
 	 */
 
-	int block_sectors, lbs = bdev_logical_block_size(rdev->bdev) >> 9;
+	int block_sectors = rdev_bb_block_sectors(rdev);
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r10_bio->sectors;
 
-	if (rdev->badblocks.shift < 0)
-		block_sectors = lbs;
-	else
-		block_sectors = roundup(1 << rdev->badblocks.shift, lbs);
-
 	sector = r10_bio->sector;
 	sectors = ((r10_bio->sector + block_sectors)
 		   & ~(sector_t)(block_sectors - 1))
-- 
2.25.1

