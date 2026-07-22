Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96192C21FD
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 07:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784705239; cv=none; b=eznpIpxDIvQ2/xrcP1788Pq1rpOQi9N6HGp/nsI+k1U9/U3dRCjMxtZ69jnevhFk+62B4nmDw6vPNCDj0sUIL/At8XjvUYQzWfSObF8+/8sv1XCyG2irf9Kn3apY/kippnv1qaHFFDed4/g9qgAPWlIQsJ52dn8XfWnE0O+mDM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784705239; c=relaxed/simple;
	bh=LRnQAZwy5QQ1Qe/0BQj4K9iSt2RG5YgCmu7nB0riUeI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nRsGMCYNiiKdnY9ySJYkXExUz4gnO+LUEP91rHdxgLmcZgGKLdXzR6F1h7r0VKSrPYMAppRXAUBFGCi9u08elGuV5wEdOJ/Mg99n1GGpGVLI8wykKw/oSPfIJBG2fujxb0Sj0qbxD7URQN7Zg0kukbaVc3kgwFB8X156ni369GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NpsBjbRq; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NpsBjbRq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=k9
	apHwg4lcLP2t3vFa2lpXd+o2uQqlBYAliplthwcic=; b=NpsBjbRqiLVm7kELCT
	+eGkbvCRy01XYzrN2EBUqYJnCUn76tE1G8ndXMkNW2Rfnc+SrbnJSpb+YDrxpbWn
	xIeyO/gynBLHDUItTL0y+CvZd2nS3V9PPT7s3Jzgoe7bMDjUmqK1yL6ZpdcxdLJn
	lzm1VIdFiX8hBoo+YjhvrqfZU=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDHzZe2cGBqcuqyKw--.51861S2;
	Wed, 22 Jul 2026 15:26:48 +0800 (CST)
From: dayou5941@163.com
To: song@kernel.org,
	yukuai@fygo.io
Cc: linux-raid@vger.kernel.org,
	liyouhong <liyouhong@kylinos.cn>
Subject: [PATCH] md/raid10: honor REQ_NOWAIT in wait_blocked_dev()
Date: Wed, 22 Jul 2026 15:26:45 +0800
Message-Id: <20260722072645.2714771-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHzZe2cGBqcuqyKw--.51861S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXw1DXr4rZw1fGF43GFWxWFg_yoW5ZF17pa
	yqg3WrtFWjkw4Fga1DAFWkCF1Y9w1UtFZFyry7JwnrJ343JryDGF4rXr4aqr9YvFW3urs8
	Xrn8KFW7u39FyFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UqfOxUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3Rj8q2pgcLie5QAA3r

From: liyouhong <liyouhong@kylinos.cn>

raid10_write_request() already respects REQ_NOWAIT for barrier and reshape
waits, but wait_blocked_dev() still always sleeps in
md_wait_for_blocked_rdev() when a member is Blocked / BlockedBadBlocks.
A NOWAIT write can therefore block in the submit path despite the flag.

Mirror raid1's wait_blocked_rdev(): if nowait is set and an rdev is
blocked, return false without waiting. The write path releases the
barrier, frees r10_bio, and completes the bio with wouldblock.

Discard still calls wait_blocked_dev(..., false). REQ_NOWAIT for discard is
already handled at wait_barrier(); honoring it again in wait_blocked_dev()
is a separate, harder-to-hit path (e.g. io_uring discard) and is left for
a follow-up to keep this fix focused on the reproduced write hang.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
---
 drivers/md/raid10.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..2ccca42e0702 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1293,7 +1293,8 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	}
 }
 
-static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
+static bool wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio,
+			     bool nowait)
 {
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *blocked_rdev;
@@ -1323,6 +1324,8 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 				set_bit(BlockedBadBlocks, &rdev->flags);
 
 			if (rdev_blocked(rdev)) {
+				if (nowait)
+					return false;
 				blocked_rdev = rdev;
 				atomic_inc(&rdev->nr_pending);
 				break;
@@ -1331,6 +1334,8 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 
 		rrdev = conf->mirrors[i].replacement;
 		if (rrdev && rdev_blocked(rrdev)) {
+			if (nowait)
+				return false;
 			atomic_inc(&rrdev->nr_pending);
 			blocked_rdev = rrdev;
 			break;
@@ -1347,6 +1352,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 		wait_barrier(conf, false);
 		goto retry_wait;
 	}
+	return true;
 }
 
 static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
@@ -1421,7 +1427,12 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 	r10_bio->read_slot = -1; /* make sure repl_bio gets freed */
 	raid10_find_phys(conf, r10_bio);
 
-	wait_blocked_dev(mddev, r10_bio);
+	if (!wait_blocked_dev(mddev, r10_bio, bio->bi_opf & REQ_NOWAIT)) {
+		allow_barrier(conf);
+		free_r10bio(r10_bio);
+		bio_wouldblock_error(bio);
+		return false;
+	}
 
 	max_sectors = r10_bio->sectors;
 
@@ -1748,7 +1759,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->sectors = 0;
 	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
-	wait_blocked_dev(mddev, r10_bio);
+	wait_blocked_dev(mddev, r10_bio, false);
 
 	/*
 	 * For far layout it needs more than one r10bio to cover all regions.

