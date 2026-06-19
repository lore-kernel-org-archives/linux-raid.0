Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1A33242B8
	for <linux-raid@vger.kernel.org>; Fri, 19 Jun 2026 04:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781844103; cv=none; b=a3sVxtrjP2GFm+ZkgKlGo5ecJuzbvQ4pM+WVPXP67HHCGeq6sKIjitd2862vcwIIVhiibW4HKqYQYqMJp/oP5ktAWwe7f453Zm4Wf7oQaAvc6Xf7CQPVxWeBI/cXQr/fqf9pxDKejE60RHWeil7J3Gi9sH1mhlHZI5SElX1JyE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781844103; c=relaxed/simple;
	bh=82cjSggUMu1X+a28J2Z/iYJgmc1KX7+SVQKTVVxKZ8k=;
	h=Mime-Version:Cc:Date:Message-Id:From:Content-Type:To:Subject; b=f4iE7HB7+b6bP3hU9+YhhqmLO3sMsLxoRHaLxxJryInTGyolptdafnPqTCJdzQDfV48E8NBHjxdgc3VYiv+nLijR3oJ8FBapqjyWS9hIutB50dI9Zg9IZeF36uR6XCi+iAGDqZzsSU/lKLKZqgomM5Muo/HycJ3W1dE8gFuxo2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=MDND19Ko; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="MDND19Ko"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781844087;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=5aUkXTsY8O5T2aIlVaOGobS3cr1M9hjvirIFOiM3vqY=;
 b=MDND19KoEaELjDUi089jsTNAB4sIWRtNOJad1pr6zl3/oGIfQrCUsg3WlUWYvHdq92y5ME
 qym1jn91NFXizHcFDZVtblKgJEApuTv5A/xhHAhyjTPcZiC5jEdyx3bMi4FdQ4qNU8iloY
 KEl3Bj2h/ij59jHUVNf7s7zx9Z4h0RTScPgvamI+NDgKm/ng9n5tVgmGoYgmQ3CE/Q9OmL
 cfE0hxlTJS9WA4axEChePXCQRMEvw0FnKx3GTVWsgB86rvRhI8TnHzSTF1CfCblNZ7v5ok
 5BCpeML/mSW11TJ0MtTe14K07dP6E4vhU4ynT/HK1D/QL4UzvmGCTdPPCKYCSA==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a34c875+4afffd+vger.kernel.org+chencheng@fnnas.com>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Fri, 19 Jun 2026 12:41:14 +0800
Message-Id: <20260619044114.1208456-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
From: "Chen Cheng" <chencheng@fnnas.com>
Received: from localhost.localdomain ([183.34.170.142]) by smtp.feishu.cn with ESMTPS; Fri, 19 Jun 2026 12:41:25 +0800
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Subject: [PATCH] md/raid1: protect head_position for read balance

From: Chen Cheng <chencheng@fnnas.com>

KCSAN reports a data race between raid1_end_read_request() and
raid1_read_request().

The completion path updates conf->mirrors[disk].head_position in
update_head_pos() without a lock, while the read-balance heuristic reads
the same field locklessly in is_sequential() and choose_best_rdev().

KCSAN report:
=========================
  BUG: KCSAN: data-race in raid1_end_read_request / raid1_read_request

  write to 0xffff8f0306ba7868 of 8 bytes by interrupt on cpu 9:
    raid1_end_read_request+0xb5/0x440
    bio_endio+0x3c9/0x3e0
    blk_update_request+0x257/0x770
    scsi_end_request+0x4d/0x520
    scsi_io_completion+0x6f/0x990
    scsi_finish_command+0x188/0x280
    scsi_complete+0xac/0x160
    blk_complete_reqs+0x8e/0xb0
    blk_done_softirq+0x1d/0x30
   [...]

  read to 0xffff8f0306ba7868 of 8 bytes by task 667002 on cpu 11:
    raid1_read_request+0x497/0x1a10
    raid1_make_request+0xdf/0x1950
    md_handle_request+0x2c5/0x700
    md_submit_bio+0x126/0x320
    __submit_bio+0x2ec/0x3a0
    submit_bio_noacct_nocheck+0x572/0x890
   [...]

  value changed: 0x0000000000000078 -> 0x00000000005fe448

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid1.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5b9368bd9e70..4cdf4484cab6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -357,12 +357,12 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
  */
 static inline void update_head_pos(int disk, struct r1bio *r1_bio)
 {
 	struct r1conf *conf = r1_bio->mddev->private;
 
-	conf->mirrors[disk].head_position =
-		r1_bio->sector + (r1_bio->sectors);
+	WRITE_ONCE(conf->mirrors[disk].head_position,
+		   r1_bio->sector + r1_bio->sectors);
 }
 
 /*
  * Find the disk number which triggered given bio
  */
@@ -735,11 +735,11 @@ static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 
 static bool is_sequential(struct r1conf *conf, int disk, struct r1bio *r1_bio)
 {
 	/* TODO: address issues with this check and concurrency. */
 	return conf->mirrors[disk].next_seq_sect == r1_bio->sector ||
-	       conf->mirrors[disk].head_position == r1_bio->sector;
+	       READ_ONCE(conf->mirrors[disk].head_position) == r1_bio->sector;
 }
 
 /*
  * If buffered sequential IO size exceeds optimal iosize, check if there is idle
  * disk. If yes, choose the idle disk.
@@ -812,11 +812,12 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 		/* At least two disks to choose from so failfast is OK */
 		if (ctl.readable_disks++ == 1)
 			set_bit(R1BIO_FailFast, &r1_bio->state);
 
 		pending = atomic_read(&rdev->nr_pending);
-		dist = abs(r1_bio->sector - conf->mirrors[disk].head_position);
+		dist = abs(r1_bio->sector -
+			   READ_ONCE(conf->mirrors[disk].head_position));
 
 		/* Don't change to another disk for sequential reads */
 		if (is_sequential(conf, disk, r1_bio)) {
 			if (!should_choose_next(conf, disk))
 				return disk;
-- 
2.54.0
