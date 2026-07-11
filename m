Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212223C7DE1;
	Sat, 11 Jul 2026 16:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783786508; cv=none; b=fAwx5T6Rh43lzsVXcycf0raWr8n7Y488TRvTwBUT+8hHDJarIzYVKBRnvo9sPUOGG0TtZLquy2Fq3iqcIkfSRW1Tz5yvQAi+XcJLg26i0y5ZByJD7CWh1OiAvKeq50s9krqgCr/Gx2V//6Yz3ibLgqpPExNbKJZ4aUijN0NkM2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783786508; c=relaxed/simple;
	bh=bjKPGxvF6g4xZ4tlxMT/HVwwdSSALzXhf2s90xqnpMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RxbfMbmNiILqMNGJWX4HYKi8pv2lhIqua73D/50s3OoZ/vh89/465LPaB87drN6zpcB2/jTc8Yd0K+TtcneOv9CbEn8tl4CFB43ipO2kKtURrOuCliwvuLz3lNCA2Qww3zVMADXKRkENoqB7m0yojZiP2lEIP3i+x30PX2QM7IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=KnvErB9M; arc=none smtp.client-ip=220.197.31.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="KnvErB9M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=S/
	nCML8YVowrgwAtBPKuswGl8UQhJ5J/8ChI1X+1U4c=; b=KnvErB9MaU9y9KGs+D
	Kv5xiYGCrBuMaNlEvKoNC7IIx8OrUAJ7mpPMMQgw/hLFARbn/w5jvOk3mh6nmC2O
	8ewz+y0xJpNJZ2EmFF41WOHfdeYtPSZ86p2PuHZJNdoB/cyJ5RiVyFXd3fje+m7f
	+whi6LWNtbtWXzJQDFTlwq+c0=
Received: from LAPTOP-N9A9U1FG.lan (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCkvCgBH7mPUa1JqkKYRCw--.7817S4;
	Sun, 12 Jul 2026 00:14:26 +0800 (CST)
From: Genjian <zhanggenjian@126.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanggenjian@126.com,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH] md/raid5: complete discard bios while reshape is active
Date: Sun, 12 Jul 2026 00:13:26 +0800
Message-ID: <20260711161326.962336-1-zhanggenjian@126.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCkvCgBH7mPUa1JqkKYRCw--.7817S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFyUCr4DGF1rAFyDtryxZrb_yoW8Gw18p3
	yqka4fZw4jvFWYyF4DWa4jka45ua97Gr98CFZ7Gwn8Aw1DJrnxAF4FvrWUtr1DCF93KayY
	vr4kKry7Gry093JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziHmhxUUUUU=
X-CM-SenderInfo: x2kd0wxjhqyxldq6ij2wof0z/xtbBtQJCwGpSa+KEHQAA3d

From: Genjian Zhang <zhanggenjian@kylinos.cn>

make_discard_request() returns without completing the bio when reshape
is in progress. Discard callers block in submit_bio_wait()
waiting for a completion that never arrives.  The caller hangs in
uninterruptible sleep, and this does not resolve when reshape finishes.

Complete the bio with BLK_STS_AGAIN so userspace can retry after reshape,
consistent with the existing policy of not processing discard during
reshape.

Tested on a loop-backed RAID5 array during mdadm --grow: without this
patch, blkdiscard hangs in bio_await() and remains in uninterruptible
sleep after md reports "reshape done"; with this patch it returns
-EAGAIN instead.

Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
---
 drivers/md/raid5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ffb5fcde54a9..4c3b42b2af85 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5722,9 +5722,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
 		return;
 
-	if (mddev->reshape_position != MaxSector)
+	if (mddev->reshape_position != MaxSector) {
 		/* Skip discard while reshape is happening */
+		bio_endio_status(bi, BLK_STS_AGAIN);
 		return;
+	}
 
 	if (!raid5_discard_limits(mddev, bi))
 		return;
-- 
2.43.0

