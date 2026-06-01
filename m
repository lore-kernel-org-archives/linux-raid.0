Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA77D246BCD;
	Mon,  1 Jun 2026 05:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780292840; cv=none; b=GokW469Lrbm7LH0oT5WC0RukTrCfbMQSu/yLvnS9+X2TIA0myostmgOtPOA6bIDWuBw/3cP+ngZQbbAV97xe69cIl/u+kf7YJxRTsTopzpIrGKkEAETrhr2cHOd4khNqBZwyGMt8WLHOiIF/XF77XNOSMdeByCSXWuZRru2YkGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780292840; c=relaxed/simple;
	bh=Pus1GLdfo4/EOp3A0PEFO2dbbZ0eqscbyJ5kfhQJsZM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hy5I3VOqIHLOpX6sMS4/hoLe78QqD/5tv4p55DKJ9GagKh1pgQ/N4yeIfTxY/GlH4yjGba8RavqOvdBaCcnbPRp7CzQGHvSqkY45SbEIKLuY676ky+ygY0tgVuaSACOjZ4sOGipVYizi55Jr6ZOKYDbc6crb2j+/6SYxbYggL5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=kXhN9SuF; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="kXhN9SuF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=E/
	YwQN+ccMKXOQsnHhimMbnPI2PYG3xKcSIRNPQwiY8=; b=kXhN9SuFuDBEhUtnot
	BQQ/jbljG2SkLBhE5/cQEIa8WNZGlGHN5dcPlOvjOOG85UFcc/v6dddwBMlAuVaF
	4r+R984LmbwyKgh/J26oFpvAijqwk6BLDmP/QYlDyo79QPLK4jbfVF+FEJ63mJLD
	0A1dMS8d8gAX14jF/f0EWYCzs=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAnFPS5HB1qgaKPFQ--.61S2;
	Mon, 01 Jun 2026 13:46:36 +0800 (CST)
From: ghuicao@163.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linan122@huawei.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cao Guanghui <caoguanghui@kylinos.cn>
Subject: [PATCH] raid10: badblock-aware reshape write error handling
Date: Mon,  1 Jun 2026 13:46:30 +0800
Message-Id: <20260601054630.74483-1-ghuicao@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgAnFPS5HB1qgaKPFQ--.61S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CrWfJFyxAF1rKr13ur1Utrb_yoW8Zw45pr
	WDGasYyrWDGwn2yw4qvayDWa4Fk392yFWYyrsxXw13W34YqrWSyFWUWryDWw4qqrWaqa1F
	qF1jgFWDur1UKaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jzuWLUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC3xwYqmodHLwo4wAA3t

From: Cao Guanghui <caoguanghui@kylinos.cn>

Replace the FIXME in end_reshape_write(). Instead of failing the device
immediately on write errors during reshape, attempt to record badblocks
using new_data_offset with is_new=1.

rdev_set_badblocks() returns true on success. On failure (e.g., badblocks
table full), it has already called md_error() internally to degrade the
device. Queue WantReplacement for member devices regardless of badblock
recording success, but skip this for replacement devices to avoid
replacement loops.

On successful write, clear stale badblock records at the new location
since data has migrated.

Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
---
 drivers/md/raid10.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4901ebe45c87..08d58a1c680e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4991,9 +4991,30 @@ static void end_reshape_write(struct bio *bio)
 		      conf->mirrors[d].rdev;
 
 	if (bio->bi_status) {
-		/* FIXME should record badblock */
-		md_error(mddev, rdev);
-	}
+		set_bit(WriteErrorSeen, &rdev->flags);
+
+		/* rdev_set_badblocks returns true on success.
+		 * On failure, it has already called md_error() internally.
+		 * Use is_new=1 as reshape writes target the new layout
+		 * (new_data_offset).
+		 */
+		if (rdev_set_badblocks(rdev, r10_bio->devs[slot].addr,
+				       r10_bio->sectors, 1)) {
+			/* Queue async replacement for member devices
+			 * For replacement devices, do not trigger WantReplacement
+			 * to avoid circular replacement storms.
+			 */
+			if (!repl) {
+				if (!test_and_set_bit(WantReplacement, &rdev->flags))
+					set_bit(MD_RECOVERY_NEEDED,
+						&rdev->mddev->recovery);
+			}
+		}
+	} else {
+		/* Write succeeded, clear stale badblock records */
+		rdev_clear_badblocks(rdev, r10_bio->devs[slot].addr,
+				     r10_bio->sectors, 1);
+	}
 
 	rdev_dec_pending(rdev, mddev);
 	end_reshape_request(r10_bio);
-- 
2.25.1

