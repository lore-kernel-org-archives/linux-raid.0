Received: from mail.bonnevilleinformatics.com (mail.bn-i.net [69.92.154.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09768148314;
	Mon, 27 Jan 2025 09:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.92.154.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737968490; cv=none; b=rKdleA45gj0lHqfL4snnOnx6NxaObPj0+EPaiKKgwAdHOrpq4ouB1kEVcwVlal3fbk/1sgwOjrMqxSVoQYvlCV2YnzfREJ6IKy4alllYFkcxQ1TeT0TlLy92isPbNnj3TXDy2NA30v25iXQexCQV5bNJIvvLDMD23P9aIN3HOcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737968490; c=relaxed/simple;
	bh=+WfXcO2OHsfAnEipw+TR3isDLDx0r97QtKtbFCu0WZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpW+XUnh2WuODI8N4twuT6epFhnyzZ4+t8iox9HBdS28gUyxjB71+lmfu173deM54vpeYEi42fFZYy4d/ro3QZE//xVUMqMUoz2jaBi3oH10rEE9ISYY/eAmvJLAwuDk7cTRmG4wN0446zVfdr4Eof1dfmaJCXzowOy/wEkj2Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net; spf=pass smtp.mailfrom=dougvj.net; dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b=l7W4P+PO; arc=none smtp.client-ip=69.92.154.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dougvj.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b="l7W4P+PO"
From: Doug V Johnson <dougvj@dougvj.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dougvj.net; s=dkim;
	t=1737968488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eHGhLDr5gPjMl9HrXNdbZDa/gpadpm29VjN1j0rAFik=;
	b=l7W4P+POeRLWKQkSxGP5/yhj53unmuUOhAoVDCvKNGunLDcD/L1sxt3W5CuwDugBGvsNQ+
	gWwdsGDnpFoPlyF4ZTQQc57DowreFbh0M1UkYFgklkoHMnJ/wLVxV3nhcMUbuFEbOfI2Zx
	2tWczC4UO7iLVK02IbSfNCof/z2yvpU=
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=dougvj@dougvj.net
To: 
Cc: Doug Johnson <dougvj@gmail.com>,
	Doug V Johnson <dougvj@dougvj.net>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] md/raid5: warn when failing a read due to bad blocks metadata
Date: Mon, 27 Jan 2025 02:00:42 -0700
Message-ID: <20250127090049.7952-2-dougvj@dougvj.net>
In-Reply-To: <20250127090049.7952-1-dougvj@dougvj.net>
References: <9c3420a9-8f6a-1102-37d2-8f32787b2f9a@huaweicloud.com>
 <20250127090049.7952-1-dougvj@dougvj.net>
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
 drivers/md/raid5.c | 10 +++++++++-
 drivers/md/raid5.h |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bc0b0c2540f0..631ec72e7ab9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3671,7 +3671,14 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
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
+					pr_warn_ratelimited("%s: read encountered block in device bad block list.",
+							    mdname(conf->mddev));
 				bio_io_error(bi);
 				bi = nextbi;
 			}
@@ -4703,6 +4710,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		if (rdev) {
 			is_bad = rdev_has_badblock(rdev, sh->sector,
 						   RAID5_STRIPE_SECTORS(conf));
+			s->bad_blocks++;
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

