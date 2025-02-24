Received: from mail.bonnevilleinformatics.com (mail.bn-i.net [69.92.154.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A026A24397B;
	Mon, 24 Feb 2025 09:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.92.154.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740387760; cv=none; b=ScezqifkjTo0Ur7MXKaA4Yr2EnLbQuAbh0nJonUQaVDlWG2dnfhr24863tuNwyDcIdMD2yURbmK1USDzxa86tp0C67T83hqsEVroPZSfAsgny991sLZ4mEVXa0r9T4C53EyTK95uAFNSMvwRBoma9HSvsRXyqqpBKoAotQxcUic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740387760; c=relaxed/simple;
	bh=gDHxG0kkUeldAgeCtL4jPoTiu0/zhSccpV0rqhMNq2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZpmimZ0WcBCkifx2sfp4NA4/BtNYym/7QLQuossGWm607eZB3i3v+DONhCELbDslJDu9VM6CGOMH39q7ziO9VpifF/jAZCCGk+CX5TqEVW9l3k4MjZf9G4MNcZdsTjXPnLs3fCZc4yM3ZlnEnJJs598fYHvc8zvUEKvJCFxy8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net; spf=pass smtp.mailfrom=dougvj.net; dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b=xVNJPimZ; arc=none smtp.client-ip=69.92.154.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dougvj.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b="xVNJPimZ"
From: Doug V Johnson <dougvj@dougvj.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dougvj.net; s=dkim;
	t=1740387752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jhl2WGlLymmY/OuBSoRdwp/PIswVgAd6LqWrZryYdwI=;
	b=xVNJPimZDPsqHoaVWIC9c2zeFbew9/mjQnQF4EMZwLgI80rJfUKlPgyHDzVhhsUOFf/mUT
	2I+awQxKObfqY1B43yB2dSiw3KhNBobK6iPs256E3eG7fNw9zGCffekSoZpilZirw8c/15
	ODPtPHUuIGr6kGDxywEtfF/mO0C3LeM=
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=dougvj@dougvj.net
To: 
Cc: Doug Johnson <dougvj@gmail.com>,
	Doug V Johnson <dougvj@dougvj.net>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Multiple Disks) SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 3/3] md/raid5: check for overlapping bad blocks before starting reshape
Date: Mon, 24 Feb 2025 02:02:03 -0700
Message-ID: <20250224090209.2077-3-dougvj@dougvj.net>
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

In addition to halting a reshape in progress when we encounter bad
blocks, we want to make sure that we do not even attempt a reshape if we
know before hand that there are too many overlapping bad blocks and we
would have to stall the reshape.

To do this, we add a new internal function array_has_badblock() which
first checks to see if there are enough drives with bad blocks for the
condition to occur and if there are proceeds to do a simple O(n^2) check
for overlapping bad blocks. If more overlaps are found than can be
corrected for, we return 1 for the presence of bad blocks, otherwise 0

This function is invoked in raid5_start_reshape() and if there are bad
blocks present, returns -EIO which is reported to userspace.

It's possible for bad blocks to be discovered or put in the metadata
after a reshape has started, so we want to leave in place the
functionality to detect and halt a reshape.

Signed-off-by: Doug V Johnson <dougvj@dougvj.net>
---
 drivers/md/raid5.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8b23109d6f37..4b907a674dd1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8451,6 +8451,94 @@ static int check_reshape(struct mddev *mddev)
 				     + mddev->delta_disks));
 }
 
+static int array_has_badblock(struct r5conf *conf)
+{
+	/* Searches for overlapping bad blocks on devices that would result
+	 * in an unreadable condition
+	 */
+	int i, j;
+	/* First see if we even have bad blocks on enough drives to have a
+	 * bad read condition
+	 */
+	int num_badblock_devs = 0;
+
+	for (i = 0; i < conf->raid_disks; i++) {
+		if (rdev_has_badblock(conf->disks[i].rdev,
+				      0, conf->disks[i].rdev->sectors))
+			num_badblock_devs++;
+	}
+	if (num_badblock_devs <= conf->max_degraded) {
+		/* There are not enough devices with bad blocks to pose any
+		 * read problem
+		 */
+		return 0;
+	}
+	pr_debug("%s: running overlapping bad block check",
+		 mdname(conf->mddev));
+	/* Do a more sophisticated check for overlapping regions */
+	for (i = 0; i < conf->raid_disks; i++) {
+		sector_t first_bad;
+		int bad_sectors;
+		sector_t next_check_s = 0;
+		int next_check_sectors = conf->disks[i].rdev->sectors;
+
+		pr_debug("%s: badblock check: %i (s: %lu, sec: %i)",
+			 mdname(conf->mddev), i,
+			 (unsigned long)next_check_s, next_check_sectors);
+		while (is_badblock(conf->disks[i].rdev,
+				   next_check_s, next_check_sectors,
+				   &first_bad,
+				   &bad_sectors) != 0) {
+			/* Align bad blocks to the size of our stripe */
+			sector_t aligned_first_bad = first_bad &
+				~((sector_t)RAID5_STRIPE_SECTORS(conf) - 1);
+			int aligned_bad_sectors =
+				max_t(int, RAID5_STRIPE_SECTORS(conf),
+				      bad_sectors);
+			int this_num_bad = 1;
+
+			pr_debug("%s: found blocks %i %lu -> %i",
+				 mdname(conf->mddev), i,
+				 (unsigned long)aligned_first_bad,
+				 aligned_bad_sectors);
+			for (j = 0; j < conf->raid_disks; j++) {
+				sector_t this_first_bad;
+				int this_bad_sectors;
+
+				if (j == i)
+					continue;
+				if (is_badblock(conf->disks[j].rdev,
+						aligned_first_bad,
+						aligned_bad_sectors,
+						&this_first_bad,
+						&this_bad_sectors)) {
+					this_num_bad++;
+					pr_debug("md/raid:%s: bad block overlap dev %i: %lu %i",
+						 mdname(conf->mddev), j,
+						 (unsigned long)this_first_bad,
+						 this_bad_sectors);
+				}
+			}
+			if (this_num_bad > conf->max_degraded) {
+				pr_debug("md/raid:%s: %i drives with unreadable sector(s) around %lu %i due to bad block list",
+					 mdname(conf->mddev),
+					 this_num_bad,
+					 (unsigned long)first_bad,
+					 bad_sectors);
+				return 1;
+			}
+			next_check_s = first_bad + bad_sectors;
+			next_check_sectors =
+				next_check_sectors - (first_bad + bad_sectors);
+			pr_debug("%s: badblock check: %i (s: %lu, sec: %i)",
+				 mdname(conf->mddev), i,
+				 (unsigned long)next_check_s,
+				 next_check_sectors);
+		}
+	}
+	return 0;
+}
+
 static int raid5_start_reshape(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
@@ -8498,6 +8586,12 @@ static int raid5_start_reshape(struct mddev *mddev)
 		return -EINVAL;
 	}
 
+	if (array_has_badblock(conf)) {
+		pr_warn("md/raid:%s: reshape not possible due to bad block list",
+			mdname(mddev));
+		return -EIO;
+	}
+
 	atomic_set(&conf->reshape_stripes, 0);
 	spin_lock_irq(&conf->device_lock);
 	write_seqcount_begin(&conf->gen_lock);
-- 
2.48.1

