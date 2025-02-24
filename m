Received: from mail.bonnevilleinformatics.com (mail.bn-i.net [69.92.154.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D86F13D279;
	Mon, 24 Feb 2025 09:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.92.154.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740387757; cv=none; b=AsIGM27WuPYgoenhvgQIHlSsLTDOJg+sEWPkfeZmF2UPImmudMYX84YuYUY8aMCak+NcBLKSCVKKYpirdLVB4EKlGSYDrkcJ4mfMS7XaqLtueqdTeG7LfokX+HHF7oXu8sS1zm0x1yVKllBl69SznLYIYdbZmHlh3RdpwlGDiCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740387757; c=relaxed/simple;
	bh=UfUZpI7XcI+6FPKOPKPpD/M7oYRwP33igg/hHMVbGAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFkV3dFIOwX8GftilCzSGBN1J/2/Q1+GGG1bFk4cp+XPamZNYlQ/b69nopNbY7Obe5eIM2ZhyXTxV8bAV2cDWlppVTcZvfNn1mPYl1UBJw3HrHX/1DmdXu7HjI7Sf5bBEp0LsR9UUZcX8M4zGSyPGJSS7OgEUp65Fdh/5qwC+HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net; spf=pass smtp.mailfrom=dougvj.net; dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b=DtiqeMjL; arc=none smtp.client-ip=69.92.154.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dougvj.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b="DtiqeMjL"
From: Doug V Johnson <dougvj@dougvj.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dougvj.net; s=dkim;
	t=1740387748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2QejHTw0U1+oFHLvLe8wC2EGmFoh8Qapj5GWF3kkqSI=;
	b=DtiqeMjLIPbg4ekD8oKxp46ZI9C/2rL1BvtpRz6+0vJaPIKoksXq643873uW9/GIe3GtF5
	I0uczXmQZYdZYQJMc90KOyg1nWGP5l1PIWYQ623ZPLg0y3L8/iHSnXVjISjICGSBuDMEbD
	4tK37FkKtWt+GkIvoLUxalcPqZ+9QkY=
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=dougvj@dougvj.net
To: 
Cc: Doug Johnson <dougvj@gmail.com>,
	Doug V Johnson <dougvj@dougvj.net>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/3] md/raid5: warn when failing a read due to bad blocks metadata
Date: Mon, 24 Feb 2025 02:02:02 -0700
Message-ID: <20250224090209.2077-2-dougvj@dougvj.net>
In-Reply-To: <20250224090209.2077-1-dougvj@dougvj.net>
References: <9d878dea7b1afa2472f8f583fd116e31@dougvj.net>
 <20250224090209.2077-1-dougvj@dougvj.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: -----

It's easy to suspect that there might be some underlying hardware
failures or similar issues when userspace receives a Buffer I/O error
from a raid device.

In order to hopefully send more sysadmins on the right track, lets
report that a read failed at least in part due to bad blocks in the bad
block list on device metadata.

There are real world examples where bad block lists accidentally get
propagated or copied around, so having this warning helps mitigate the
consequences

Signed-off-by: Doug V Johnson <dougvj@dougvj.net>
---
 drivers/md/raid5.c | 16 +++++++++++++++-
 drivers/md/raid5.h |  2 +-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3b5345e66daf..8b23109d6f37 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3671,7 +3671,15 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			       sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
 				struct bio *nextbi =
 					r5_next_bio(conf, bi, sh->dev[i].sector);
-
+				/* If we recorded bad blocks from the metadata
+				 * on any of the devices then report this to
+				 * userspace in case anyone might suspect
+				 * something more fundamental instead
+				 */
+				if (s->bad_blocks)
+					pr_warn_ratelimited("%s: read encountered block in device bad block list at %lu",
+							    mdname(conf->mddev),
+							    (unsigned long)sh->sector);
 				bio_io_error(bi);
 				bi = nextbi;
 			}
@@ -4703,6 +4711,12 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		if (rdev) {
 			is_bad = rdev_has_badblock(rdev, sh->sector,
 						   RAID5_STRIPE_SECTORS(conf));
+			if (is_bad) {
+				s->bad_blocks++;
+				pr_debug("bad blocks encountered dev %i sector %lu %lu",
+					 i, (unsigned long)sh->sector,
+					 RAID5_STRIPE_SECTORS(conf));
+			}
 			if (s->blocked_rdev == NULL) {
 				if (is_bad < 0)
 					set_bit(BlockedBadBlocks, &rdev->flags);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index eafc6e9ed6ee..c755c321ae36 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -282,7 +282,7 @@ struct stripe_head_state {
 	 * read all devices, just the replacement targets.
 	 */
 	int syncing, expanding, expanded, replacing;
-	int locked, uptodate, to_read, to_write, failed, written;
+	int locked, uptodate, to_read, to_write, failed, written, bad_blocks;
 	int to_fill, compute, req_compute, non_overwrite;
 	int injournal, just_cached;
 	int failed_num[2];
-- 
2.48.1

