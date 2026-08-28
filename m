Received: from smtp153-170.sina.com.cn (smtp153-170.sina.com.cn [61.135.153.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7103DAADE
	for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2026 10:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.135.153.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787913622; cv=none; b=DLw6sQiM8A/SGXxUzt0LefI65fffojlzisND6A7PjMqNPJ34x+g5rKaRwWPlUfZZ1ecVOrIae5g24Me3IzsFM455dX8FK9WswpxUpTHXG5z9J7/66Eu+2pVfV4vhJNCiRt8yT7xzAAINyo4Trr5cWvIlZ7ztD1jNE6VuFgfR2S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787913622; c=relaxed/simple;
	bh=YAUw6g07BXmtWFoD9VCDQoHbfUdwW08Jivc6mI48GEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOd/jE5IHxqhgI1riVUpc7i4wWudN7bg5XkdXAkYHDwNmBHPqgVmBS/48waMmG8YHI3/pkkCyS449f6R+8GNJJp69KV+bHs99qAJlPfCVFhkLt5SYr7AIp4vDPtlV5vBmk9HeQ5UBVosF0uCEjYjLn20JsAswIxPIfOykyeVnto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=vc85yMWz; arc=none smtp.client-ip=61.135.153.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="vc85yMWz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1787913613;
	bh=hXY+WbbG19Rh8/V32bq6DCv/4+Yy1+y5L54TzXJtYtU=;
	h=From:Subject:Date:Message-ID;
	b=vc85yMWzuLZVtd/FhgOkMZqCxPTcwIOCQ15awDvkRdN65GrxvKv1FkA8N78tUjsIP
	 5jVtd3vDErBuUHXGAFokuBvD8ltHbAGrA7p5LN//jHOG5W+v7J64DGOo8F+wvzY6ev
	 QeJIL6vVgSaVXuEwFZP0Mi6q4QGfhk5LUk9pr2xE=
X-SMAIL-HELO: lxu-ped-host..
Received: from unknown (HELO lxu-ped-host..)([111.198.231.89])
	by sina.com (10.54.253.34) with ESMTP
	id 6A91657D00006DC1; Fri, 28 Aug 2026 18:40:03 +0800 (CST)
X-Sender: eadavis@sina.com
X-Auth-ID: eadavis@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=eadavis@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=eadavis@sina.com
X-SMAIL-MID: 3546146291675
X-SMAIL-UIID: A782ECB0474B43B095A6A99C9A395CF2-20260828-184003-1
From: Edward Adam Davis <eadavis@sina.com>
To: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
Cc: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] md/raid1: prevent a race between write and stop request
Date: Fri, 28 Aug 2026 18:39:57 +0800
Message-ID: <20260828103957.245658-1-eadavis@sina.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6a908777.1d9ded08.62e62.00da.GAE@google.com>
References: <6a908777.1d9ded08.62e62.00da.GAE@google.com>
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
md_handle_request()		do_md_stop()__md_stop()
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

