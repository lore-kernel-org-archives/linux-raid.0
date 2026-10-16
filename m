Received: from a27-24.smtp-out.us-west-2.amazonses.com (a27-24.smtp-out.us-west-2.amazonses.com [54.240.27.24])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74DC38331D;
	Fri, 16 Oct 2026 04:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.27.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124750; cv=none; b=ZoffD5lwk8+/hytNLy9+5bNgKg0VhnT4vAXgGTi9U1IZRCu2toglswhzhiQMoUUu/Cx5GpeJmsDePbkKyTG6AdahfZ+KGk2y5jFiekgFSMQSGHRO+qRaeXbCvH9OxAIFzAREIxZ58L5gZ348tWZGQrcqQrdDr3i//QSi5pzohU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124750; c=relaxed/simple;
	bh=IbfsF2Ybe2vF5JrZ+/4TjXZcmnPDjk+npkYcfCPhi+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8X9UABwL74s4f+iRpKgQSyRIUL1Xqgf7F5xSw+/R44mcqpbS4bXOe77xEtvT3B+2SNy0xsvv+HkL6wA+ydg5lMou+NxRbvDuN35bkkUzOVU41QpPib6Q3BsqiwZizc38xsz0wKYoyMSbIcB7JBFmMaCWBHiIIoRSONUkQ8I+yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.me; spf=pass smtp.mailfrom=bounce.dougvj.me; dkim=pass (2048-bit key) header.d=dougvj.me header.i=@dougvj.me header.b=huFs1gf+; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=KTPIJKY5; arc=none smtp.client-ip=54.240.27.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.dougvj.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dougvj.me header.i=@dougvj.me header.b="huFs1gf+";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="KTPIJKY5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=75cpmoop2pyf56gdndy2e364ijbokrge; d=dougvj.me; t=1792124748;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IbfsF2Ybe2vF5JrZ+/4TjXZcmnPDjk+npkYcfCPhi+4=;
	b=huFs1gf+ndtdQ8ZeP1BN27YG3H+jtoPCEQ62oei1vOKuQv6yFJ0KwVI3+HhWKJSg
	dww8VSS3lSUE3Cf42H/2GV78Df65/5eJU6GV+Cl48JJmilMMsQXe/FqNePodTn9cfQs
	UhRSphJe5+L4y4FtD/z/2PGKvPLA+sej1sIhhjxl6tNxgxJjFI9YJGVS6s47o/9uKRM
	ulwuVQbJ9ooEHR1QxaBXhawEhexl6CuGUrScd/bmVlQGUYTH2nVTF1PuDjGr7qjRtwu
	BfcwCYd4csE+PUEQpeSolKm+CjtgBSIjCKnMxYhGGijWoZf8M9NhZGdgibWQnA45ywM
	bafoyvvrSg==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1792124748;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=IbfsF2Ybe2vF5JrZ+/4TjXZcmnPDjk+npkYcfCPhi+4=;
	b=KTPIJKY5WpWPXTsVwGxA2gJ1dl4tIWy86W2GQn5l1k2BB6sgo+a6j5Ll+jKnZvrZ
	SbLn6Klh4+SuklhNzmKjbVLLbUbHQeLKyklrs9BsA/IxZvdv4Z1iQOiuPT3355SjynU
	xGYfjeF3YIzx6X5HvlhWFozfXJa0JbhuA9W5yeb0=
From: Doug V Johnson <me@dougvj.me>
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=me@dougvj.me
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com, 
	xiao@kernel.org, chencheng@fnnas.com, linux-kernel@vger.kernel.org, 
	Doug V Johnson <me@dougvj.me>, Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v4 2/3] md/raid5: do not reshape if overlapping rdev bad block ranges prevent it
Date: Fri, 16 Oct 2026 04:25:48 +0000
Message-ID: <010101a142f581e5-36ad5604-721c-4ad0-86f3-62ca283b6133-000000@us-west-2.amazonses.com>
In-Reply-To: <20261016042537.277516-1-me@dougvj.me>
References: <20261016042537.277516-1-me@dougvj.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: --
Feedback-ID: ::1.us-west-2.yIAaOWcA3P0r3CWRzBxY2mlnWgm/DtEO6k5/iZ9ogRk=:AmazonSES
X-SES-Outgoing: 2026.10.16-54.240.27.24

Ensure that a reshape is not started if there are more than max_degraded
devices in the array that are either out of sync, faulty, missing,
or have overlapping bad blocks such that a read is not recoverable.

Cheaply verify that the number of bad or unavailable devices exceeds
the max number of degraded drives and if so sweep the bad block lists
on each device for overlaps using a new function array_has_badblock().

Invoke this function in raid5_start_reshape() and if the array has
unreadable blocks, return -EIO to report it to userspace.

Leave in place the existing functionality to handle a failed reshape
in progress because it's possible for bad blocks to be discovered or
placed in metadata after a reshape has already been initiated.

Link: https://lore.kernel.org/r/21f250f9-04b5-76f6-84c9-1fd245b748c6@huaweicloud.com
Link: https://lore.kernel.org/r/a9119707-4fa1-58cb-377c-63df67f88957@huaweicloud.com
Suggested-by: Yu Kuai <yukuai1@huaweicloud.com>
Assisted-by: LLM
Signed-off-by: Doug V Johnson <me@dougvj.me>
---
 drivers/md/raid5.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 86ea65559576..23ff549fa363 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8636,6 +8636,89 @@ static int check_reshape(struct mddev *mddev)
 				     + mddev->delta_disks));
 }
 
+static int rdev_is_unavailable(struct md_rdev *rdev)
+{
+	return !rdev || test_bit(Faulty, &rdev->flags) ||
+	       !test_bit(In_sync, &rdev->flags);
+}
+
+static int array_has_badblock(struct r5conf *conf)
+{
+	sector_t dev_sectors = conf->mddev->dev_sectors;
+	sector_t stripe_sectors = RAID5_STRIPE_SECTORS(conf);
+	sector_t max_sectors = round_down((sector_t)INT_MAX, stripe_sectors);
+	sector_t offset = 0;
+	int num_bad_devs = 0;
+	int i;
+
+	/* Check if there are even enough bad disks for a bad block condition */
+	for (i = 0; i < conf->raid_disks; i++) {
+		struct md_rdev *rdev = conf->disks[i].rdev;
+
+		if (rdev_is_unavailable(rdev) || rdev->badblocks.count)
+			num_bad_devs++;
+	}
+	if (num_bad_devs <= conf->max_degraded)
+		return 0;
+
+	/*
+	 * Sweep the sectors of the array for bad blocks in constituent devices.
+	 * Within a stripe if there are more bad disks than can be recoverable
+	 * (max degraded) then the array has bad blocks.
+	 *
+	 * The offset tracks the sweep. We advance to the first bad stripe
+	 * boundary found in any device.
+	 */
+	while (offset < dev_sectors) {
+		sector_t len = min(dev_sectors - offset, max_sectors);
+		int bad_disks = 0;
+
+		for (i = 0; i < conf->raid_disks; i++) {
+			struct md_rdev *rdev = conf->disks[i].rdev;
+			sector_t first_bad, bad_sectors, end;
+
+			if (rdev_is_unavailable(rdev)) {
+				bad_disks++;
+				continue;
+			}
+			if (!rdev->badblocks.count)
+				continue;
+			if (!badblocks_check(&rdev->badblocks,
+					     rdev->data_offset + offset, len,
+					     &first_bad, &bad_sectors))
+				continue;
+
+			/*
+			 * Rebase the bad blocks start and end to the device's data
+			 * offset for consistent comparision
+			 */
+			end = first_bad + bad_sectors - rdev->data_offset;
+			first_bad = max(first_bad, rdev->data_offset) -
+				    rdev->data_offset;
+
+			/* Snap the range to the stripe boundary extent */
+			first_bad = round_down(first_bad, stripe_sectors);
+			end = round_up(end, stripe_sectors);
+
+			/*
+			 * This device has a bad block at or overlapping the current
+			 * sweep position, so it's a bad disk
+			 */
+			if (first_bad <= offset) {
+				len = min(len, end - offset);
+				bad_disks++;
+			} else {
+				len = min(len, first_bad - offset);
+			}
+		}
+		if (bad_disks > conf->max_degraded)
+			return 1;
+		offset += len;
+		cond_resched();
+	}
+	return 0;
+}
+
 static int raid5_start_reshape(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
@@ -8685,6 +8768,11 @@ static int raid5_start_reshape(struct mddev *mddev)
 			mdname(mddev));
 		return -EINVAL;
 	}
+	if (array_has_badblock(conf)) {
+		pr_warn("md/raid:%s: reshape not possible due to bad block list\n",
+			mdname(mddev));
+		return -EIO;
+	}
 	if (md_bitmap_enabled(mddev, false) &&
 	    mddev->bitmap_id == ID_LLBITMAP) {
 		i = mddev->bitmap_ops->resize(mddev, mddev->dev_sectors, 0);
-- 
2.54.0

