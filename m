Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655C05038E6
	for <linux-raid@vger.kernel.org>; Tue, 13 Oct 2026 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898374; cv=none; b=QaKjn3tJl5mgMkQoFdk7Dv0CVbJC/YdQ0TiyVk32mbXGArkApqGmAnGLPGQxppzUbRo58bFVophf4FDAQOZobIbZlx/g7m2BdpRbJ4VsTtZmpx2pD12Wgw4ceXnHt/u87IO7PpUjNLY1ZdMwTfAlWHe3rf3lGbIK7p8xGkXtTTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898374; c=relaxed/simple;
	bh=LB++yc/5BtuetnM9xpDImPRRhclepzJMUkNKdzsXMrw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O4HQOiO3Dkr8al+PizJ9AZliqSylcQ31FlonSMeLrX2j1V8SIXnl0Bp4fkDUPlndNhhnE73REk3ugEBimvY6xPwfX43mQd1WxLW4VTS41OU1fKJOodAM3oyC4Llsgj4LuMEo+0PRTwxw3PHtmXO7/Vpb5mH9myNrgFR6HwOQBOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=p1+3GmmR; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="p1+3GmmR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791898364; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=/b4XIg87XIFrnRGN6R8nO45dFyE+E5QQf6iUZ75askI=;
	b=p1+3GmmRX+nvK7RNx/A6ON9OJmvbdyUVcU0IDnO+RiXajbJ0pSUuioA48a7HJxVkGwKhzNmFcz+6pbkEGcuppaSPBwA0g/JsBDd2xV6HsW4YHDEKfj1LcFddNqbttwjqeJHub06kE6vgmG1VGwuZDTfB8uYY7z38LTEahrb9t1w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XClyIFH_1791898363;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0XClyIFH_1791898363 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 21:32:43 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: linux-raid@vger.kernel.org
Cc: Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Jan Kara <jack@suse.cz>,
	John Garry <john.g.garry@oracle.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	YunyeZhao <yunye.zhao@linux.alibaba.com>
Subject: [PATCH 6.6.y] md/raid0: fix data corruption when chunk size is below PAGE_SIZE
Date: Tue, 13 Oct 2026 21:32:43 +0800
Message-Id: <20261013133243.42145-1-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: YunyeZhao <yunye.zhao@linux.alibaba.com>

Commit 319ff40a5427 ("md/raid0: Fix performance regression for large sequential writes")
assumes that bios reaching RAID0 are no larger than the chunk size.

However, blk_queue_max_hw_sectors() raises limits smaller than
PAGE_SIZE to one page. With 64 KiB pages and a 16 KiB RAID0 chunk, a
bio can therefore span several chunks. raid0_make_request() splits it
only once and maps the multi-chunk remainder to one member device,
causing silent data corruption.

Set the queue chunk boundary after stacking the member limits, combined
with any inherited boundary using gcd(). This makes the block layer
split bios at chunk boundaries before they reach RAID0. Only install a
boundary aligned to the logical block size so that bio splitting
always makes progress.

Setting the boundary after disk_stack_limits() is required because
stacking may clear or reduce a boundary installed earlier. This adapts
the mechanism introduced by upstream commit 4b8beba60d32
("md/raid0: set chunk_sectors limit") to the queue limits API used by
6.6.y.

The corruption was reproduced on arm64 with 64 KiB pages and a 16 KiB
chunk. A 64 KiB chunk configuration is unaffected.

Fixes: 319ff40a5427 ("md/raid0: Fix performance regression for large sequential writes")
Signed-off-by: YunyeZhao <yunye.zhao@linux.alibaba.com>
---
 drivers/md/raid0.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c50a7abda744..5a57e327c6ba 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -11,6 +11,7 @@
 */
 
 #include <linux/blkdev.h>
+#include <linux/gcd.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -382,6 +383,7 @@ static void raid0_free(struct mddev *mddev, void *priv)
 static int raid0_run(struct mddev *mddev)
 {
 	struct r0conf *conf;
+	unsigned int chunk_limit;
 	int ret;
 
 	if (mddev->chunk_sectors == 0) {
@@ -413,6 +415,18 @@ static int raid0_run(struct mddev *mddev)
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 		}
+
+		/*
+		 * Set the chunk boundary after stacking member limits, which
+		 * may clear or reduce it. Without it a bio may span several
+		 * chunks when chunk size < PAGE_SIZE. Keep it a multiple of
+		 * the logical block size so the block layer can split at it.
+		 */
+		chunk_limit = gcd(mddev->queue->limits.chunk_sectors,
+				  mddev->chunk_sectors);
+		if (!(chunk_limit %
+		      (mddev->queue->limits.logical_block_size >> SECTOR_SHIFT)))
+			blk_queue_chunk_sectors(mddev->queue, chunk_limit);
 	}
 
 	/* calculate array device size */
-- 
2.19.1.6.gb485710b

