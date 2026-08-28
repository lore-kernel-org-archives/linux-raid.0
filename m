Received: from smtp153-162.sina.com.cn (smtp153-162.sina.com.cn [61.135.153.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFE5346771
	for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2026 10:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.135.153.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787914239; cv=none; b=Z0chY3ofCY3JNNQW9CcSovrZEkchvKAdF0g6bEIwKr4eGdNJh9WuJAIrCfhBUNGrShquKNrrPX+LdhsshAiHJbFsmyTbDIf0NVQne6W4B4mN3RwZIlesdMaObczzHsqCU8yyRRRba3c9wbG5p8ajXrvBbLhY2OicRDCSTeXwoK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787914239; c=relaxed/simple;
	bh=33MVvyU6flxL5cQA6YdkwXg1ZbH1BHoYh3xQUJJJusY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/DmtbGp54Nn28pYmoJHdDACWww5EqGQDPuRfseKGieJ5ZbKRL8jUTITOVpxj7XPJq9QgUAfxH+1Q04Qz3l9LVYP5YNjavBsB/TkGRibHGXC3nPYI0fXSMX/QPXeZmrG7/qNgo0hYXJjLEo079ndIQk3/iojHmdoKga4ynzyK6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=tJwq3R4g; arc=none smtp.client-ip=61.135.153.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="tJwq3R4g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1787914233;
	bh=yuVja7/hyVZ6sVqMdahq1hTCS5fUCdu4lYUx6vfeg8k=;
	h=From:Subject:Date:Message-ID;
	b=tJwq3R4gCxJJwqHnXK3OzNloCk2dB2d6bSaLtzwj2Lep8bwHqp8aLzus/8dsysHBC
	 n694O2bSssmSl+2PiT1TOaM1d+EdKWVQu80PmelLracaHOROxZ2uKGsLSg2UnipR23
	 OhO0Sjz/DiZ0HuyXdkm1mrM5Ccm7SqvjHptV/sfU=
X-SMAIL-HELO: lxu-ped-host..
Received: from unknown (HELO lxu-ped-host..)([111.198.231.89])
	by sina.com (10.54.253.31) with ESMTP
	id 6A9167C800005330; Fri, 28 Aug 2026 18:49:47 +0800 (CST)
X-Sender: eadavis@sina.com
X-Auth-ID: eadavis@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=eadavis@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=eadavis@sina.com
X-SMAIL-MID: 1480266815948
X-SMAIL-UIID: 6BA2352CF4E049E69E411598473469E8-20260828-184947-1
From: Edward Adam Davis <eadavis@sina.com>
To: eadavis@sina.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	magiclinan@didiglobal.com,
	song@kernel.org,
	syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	xiao@kernel.org,
	yukuai@fygo.io
Subject: [PATCH v2] md/raid1: prevent a race between write and stop request
Date: Fri, 28 Aug 2026 18:49:44 +0800
Message-ID: <20260828104944.246837-1-eadavis@sina.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828103957.245658-1-eadavis@sina.com>
References: <20260828103957.245658-1-eadavis@sina.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A race condition exists between write and stop requests, leading to a
null-ptr-deref in [1].

CPU0				CPU1
====				====
md_submit_bio()
md_handle_request()		do_md_stop()
raid1_make_request()		 __md_stop()
raid1_write_request()		   mddev->private = NULL
wait_barrier()
conf->nr_pending //trigger [1]

The intervention of a stop request causes inconsistencies in the state
of mddev members (such as private and pers) while a write request is
executing; the mddev lock is used to synchronize write and stop requests,
thereby ensuring consistent mddev state throughout the execution of the
write request.

Additionally, when a write operation reaches the RAID1 layer, if a stop
request acquires the mddev lock first and releases mddev->private, the
bio is terminated and the write request exits.
	
[1]
KASAN: null-ptr-deref in range [0x0000000000000120-0x0000000000000127]
RIP: 0010:_wait_barrier+0x8d/0x700 drivers/md/raid1.c:1066
Call Trace:
 wait_barrier drivers/md/raid1.c:1154 [inline]
 raid1_write_request drivers/md/raid1.c:1506 [inline]
 raid1_make_request+0x484/0x31a0 drivers/md/raid1.c:1696
 md_handle_request+0x824/0x1230 drivers/md/md.c:417
 md_submit_bio+0x1e9/0x350 drivers/md/md.c:458
 __submit_bio block/blk-core.c:681 [inline]
 __submit_bio+0x20e/0x3d0 block/blk-core.c:670
 __submit_bio_noacct block/blk-core.c:724 [inline]
 submit_bio_noacct_nocheck+0x736/0xc00 block/blk-core.c:792
 submit_bio_noacct+0xc93/0x2130 block/blk-core.c:925
 bio_await+0x1fa/0x240 block/bio.c:1580
 submit_bio_wait+0x19/0x60 block/bio.c:1598
 __blkdev_direct_IO_simple+0x4cb/0x8c0 block/fops.c:98
 blkdev_direct_IO+0xbee/0x2030 block/fops.c:429
 blkdev_direct_write block/fops.c:699 [inline]
 blkdev_write_iter+0x703/0xd30 block/fops.c:767
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6af/0x1050 fs/read_write.c:687

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3fe892ea5fc292e1353f
Tested-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@sina.com>
---
v1 -> v2: typo in comments

 drivers/md/raid1.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f0646fb24371..3b9f1fa65e65 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1674,6 +1674,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 {
 	sector_t sectors;
+	blk_status_t status;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
 	    && md_flush_request(mddev, bio))
@@ -1692,11 +1693,36 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 	if (bio_data_dir(bio) == READ)
 		raid1_read_request(mddev, bio, sectors, NULL);
 	else {
+		int err;
+
 		md_write_start(mddev, bio);
-		if (!raid1_write_request(mddev, bio, sectors))
+		err = mddev_lock(mddev);
+
+		if (err < 0) {
+			md_write_end(mddev);
+			status = BLK_STS_IOERR;
+			goto done;
+		}
+
+		if (!mddev->private) {
+			mddev_unlock(mddev);
+			md_write_end(mddev);
+			status = BLK_STS_OFFLINE;
+			goto done;
+		}
+
+		err = raid1_write_request(mddev, bio, sectors);
+		mddev_unlock(mddev);
+
+		if (!err)
 			md_write_end(mddev);
 	}
+out:
 	return true;
+done:
+	bio->bi_status = status;
+	bio_endio(bio);
+	goto out;
 }
 
 static void raid1_status(struct seq_file *seq, struct mddev *mddev)
-- 
2.43.0

