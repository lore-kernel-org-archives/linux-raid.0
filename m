Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC8C15748E
	for <linux-raid@vger.kernel.org>; Fri,  4 Oct 2024 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728050722; cv=none; b=K9RiHFBxLqV/Ii4Ew7qC8GQv3NeTSJzHIeE4MBLmO9CuaVJFiUKvWwxqg+h1eiMMXJSiRiSduCq3O/zywHRaGjM5+lD0QpyjYW2Ft/EAh6z/lDleA2AyNk/jeFBfOZSr+tADnt/9hyJ1dVULuaqjoZBlKh6t2oX5kJGmmCmhmwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728050722; c=relaxed/simple;
	bh=ChoLaS3sphAOs8K6yYLrbmVjxpCDaHVvu6+UxvvOVp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f4PQ3u8w6KQDKwvyyxAsXSp2+7fo42qG6T2uZUvV/pPj8plgnXWHMS8MgzbW7/JBY5u0KcShiOmQ+++wOcbqLVd9nUMLtoD9chILsxyiJziK4OUTQ43OuSd22rEzn6PNgThR76gDwZw1mR56n5c1xNzi9nyHyGqdeLBKBnblpKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QrKSycpZ; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QrKSycpZ"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e137183587so1843162a91.3
        for <linux-raid@vger.kernel.org>; Fri, 04 Oct 2024 07:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728050719; x=1728655519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M/jkHkLxO1JFtG/m+iJa+D895QCA9iN19d1rF1P3g8k=;
        b=QrKSycpZkq0lE8hmzsc8uMhf9PVMBEo6RkdMq+QNqtv3MrOFKefjPZmRbvZLaEtFW1
         rJySkjk6797JUVQl3eW+CNTPc5Na75GFSn8CF+3NpusSlcmc9Dcywp9ndgSVCLtRKHrC
         w38shdEZk0f2AgkPpIaD8W0BFOWbX4reCi2zjR6H4Fv8OCXTsvKXWN1iAFRzJNnZP6/m
         Gs17/o3umONJmO2LIQbFbs4WOGP4c3Rt3Yardhkq1vicGTrY4llLy+5TeU+wQsLRwoyx
         ZZP53WY6JB0mOEv2KMLJAqMBozCXoApQXt7/CdDEslAbobOiNhra/lgdzuSjlBbahJoI
         6FrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728050719; x=1728655519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/jkHkLxO1JFtG/m+iJa+D895QCA9iN19d1rF1P3g8k=;
        b=lPSwellhsnfLbdK+trCCuTQA7WSEEKYkJlDvd7icQsAYfEdVezg4z34TtCWFzQndJH
         8lofCJ/U0mURVBqc7RLDJnokyW9zLpsOHNVh39cGsAA8smnMV10uZqOiC2uHCJS+qKfT
         2iEYznkLJR8hoAG0mCpINuXfRGCjyLx+TqGIUBbUi20fZY8zAVpJ/jid0sFbrWpKexsj
         6Od1FKPh9L7wEtrfj4G6v1t7OnK502BstI2DzrigVvn16Y0yHv3PEyzgx9COJC2sdFRH
         XjF4Z/dEReprVlhrtSAdPJEy7ATe2vBHP+VopvC21Oa7VTaO+E28cmwRmMn7BBD0Mj7p
         jDZw==
X-Gm-Message-State: AOJu0YwZo+BVh0VlACxhwf3gRWh0tygmIAS5A1wG4U0J09PsS7zsL3vx
	oQiYfg16g+dzFxnEsa7CPvvLdWaUP9gdrp5seUTHimGX3/NLaxVuNLiEUQ==
X-Google-Smtp-Source: AGHT+IF/K3t4h1rTXoLPjlMlxFnk2NUtiJTQ37IPj5ebdGE3JcMf3Y/IiGG2Sfa6TGKtXxe5Vpt8Jw==
X-Received: by 2002:a17:90b:102:b0:2c9:7611:e15d with SMTP id 98e67ed59e1d1-2e1e629fa8cmr3883423a91.20.1728050718446;
        Fri, 04 Oct 2024 07:05:18 -0700 (PDT)
Received: from localhost.localdomain ([2600:8800:1600:140::5e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e85d93b1sm1623114a91.25.2024.10.04.07.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 07:05:18 -0700 (PDT)
From: Paul Luse <paulluselinux@gmail.com>
To: linux-raid@vger.kernel.org
Cc: paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: [PATCH] md: raid1 mixed RW performance improvement
Date: Fri,  4 Oct 2024 07:05:14 -0700
Message-ID: <20241004140514.20209-1-paulluselinux@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While working on read_balance() earlier this year I realized that
for nonrot media the primary disk selection criteria for RAID1 reads
was to choose the disk with the least pending IO. At the same time it
was noticed that rarely did this work out to a 50/50 split between
the disks.  Initially I looked at a round-robin scheme however this
proved to be too complex when taking into account concurrency.

That led to this patch.  Writes typically take longer than
reads for nonrot media so choosing the disk with the least pending
IO without knowing the mix of outstanding IO, reads vs writes, is not
optimal.

This patch takes a very simple implantation approach to place more
weight on writes vs reads when selecting a disk to read from.  Based
on empirical testing of multiple drive vendors NVMe and SATA (some
data included below) I found that weighing writes by 1.25x and rounding
gave the best overall performance improvement.  The boost varies by
drive, as do most drive dependent performance optimizations.  Kioxia
gets the least benefit while Samsung gets the most.  I also confirmed
no impact on pure read cases (or writes of course).  I left the total
pending counter in place and simply added one specific to reads, there
was no reason to count them separately especially given the additional
complexity in the write path for tracking pending IO.

The fewer writes that are outstanding the less positive impact this
patch has.  So the math works out well.  Here are the non-weighted
and weighted values for looking at outstanding writes.  The first column
is the unweighted value and the second is what is used with this patch.
Until there are at least 4 pending, no change.  The more pending, the
more the value is weighted which is perfect for how the drives behave.

1 1
2 2
3 3
4 5
5 6
6 7
7 8
8 10
9 11
10 12
11 13
12 15
13 16
14 17
15 18
16 20

Below is performance data for the patch, 3 different NVMe drives
and one SATA.

WD SATA: https://photos.app.goo.gl/1smadpDEzgLaa5G48
WD NVMe: https://photos.app.goo.gl/YkTTcYfU8Yc8XWA58
SamSung NVMe: https://photos.app.goo.gl/F6MvEfmbGtRyPUFz6
Kioxia NVMe: https://photos.app.goo.gl/BAEhi8hUwsdTyj9y5

Signed-off-by: Paul Luse <paulluselinux@gmail.com>
---
 drivers/md/md.h    |  9 +++++++++
 drivers/md/raid1.c | 34 +++++++++++++++++++++++++---------
 2 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5d2e6bd58e4d..1a1040ec3c4a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -162,6 +162,9 @@ struct md_rdev {
 					 */
 	};
 
+	atomic_t nr_reads_pending;      /* tracks only mirrored reads pending
+					 * to support a performance optimization
+					 */
 	atomic_t	nr_pending;	/* number of pending requests.
 					 * only maintained for arrays that
 					 * support hot removal
@@ -923,6 +926,12 @@ static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
 	}
 }
 
+static inline void mirror_rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
+{
+	atomic_dec(&rdev->nr_reads_pending);
+	rdev_dec_pending(rdev, mddev);
+}
+
 extern const struct md_cluster_operations *md_cluster_ops;
 static inline int mddev_is_clustered(struct mddev *mddev)
 {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f55c8e67d059..5315b46d2cca 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -394,7 +394,7 @@ static void raid1_end_read_request(struct bio *bio)
 
 	if (uptodate) {
 		raid_end_bio_io(r1_bio);
-		rdev_dec_pending(rdev, conf->mddev);
+		mirror_rdev_dec_pending(rdev, conf->mddev);
 	} else {
 		/*
 		 * oops, read error:
@@ -584,6 +584,7 @@ static void update_read_sectors(struct r1conf *conf, int disk,
 	struct raid1_info *info = &conf->mirrors[disk];
 
 	atomic_inc(&info->rdev->nr_pending);
+	atomic_inc(&info->rdev->nr_reads_pending);
 	if (info->next_seq_sect != this_sector)
 		info->seq_start = this_sector;
 	info->next_seq_sect = this_sector + len;
@@ -760,9 +761,11 @@ struct read_balance_ctl {
 	int readable_disks;
 };
 
+#define WRITE_WEIGHT 2
 static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	int disk;
+	int nonrot = READ_ONCE(conf->nonrot_disks);
 	struct read_balance_ctl ctl = {
 		.closest_dist_disk      = -1,
 		.closest_dist           = MaxSector,
@@ -774,7 +777,7 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
 		struct md_rdev *rdev;
 		sector_t dist;
-		unsigned int pending;
+		unsigned int total_pending, reads_pending;
 
 		if (r1_bio->bios[disk] == IO_BLOCKED)
 			continue;
@@ -787,7 +790,21 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 		if (ctl.readable_disks++ == 1)
 			set_bit(R1BIO_FailFast, &r1_bio->state);
 
-		pending = atomic_read(&rdev->nr_pending);
+		total_pending = atomic_read(&rdev->nr_pending);
+		if (nonrot) {
+			/* for nonrot we weigh writes slightly heavier than
+			 * reads when deciding disk based on pending IOs as
+			 * writes typically take longer
+			 */
+			reads_pending = atomic_read(&rdev->nr_reads_pending);
+			if (total_pending > reads_pending) {
+				int writes;
+
+				writes = total_pending - reads_pending;
+				writes += (writes >> WRITE_WEIGHT);
+				total_pending = writes + reads_pending;
+			}
+		}
 		dist = abs(r1_bio->sector - conf->mirrors[disk].head_position);
 
 		/* Don't change to another disk for sequential reads */
@@ -799,7 +816,7 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 			 * Add 'pending' to avoid choosing this disk if
 			 * there is other idle disk.
 			 */
-			pending++;
+			total_pending++;
 			/*
 			 * If there is no other idle disk, this disk
 			 * will be chosen.
@@ -807,8 +824,8 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 			ctl.sequential_disk = disk;
 		}
 
-		if (ctl.min_pending > pending) {
-			ctl.min_pending = pending;
+		if (ctl.min_pending > total_pending) {
+			ctl.min_pending = total_pending;
 			ctl.min_pending_disk = disk;
 		}
 
@@ -831,8 +848,7 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 	 * disk is rotational, which might/might not be optimal for raids with
 	 * mixed ratation/non-rotational disks depending on workload.
 	 */
-	if (ctl.min_pending_disk != -1 &&
-	    (READ_ONCE(conf->nonrot_disks) || ctl.min_pending == 0))
+	if (ctl.min_pending_disk != -1 && (nonrot || ctl.min_pending == 0))
 		return ctl.min_pending_disk;
 	else
 		return ctl.closest_dist_disk;
@@ -2622,7 +2638,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
 	}
 
-	rdev_dec_pending(rdev, conf->mddev);
+	mirror_rdev_dec_pending(rdev, conf->mddev);
 	sector = r1_bio->sector;
 	bio = r1_bio->master_bio;
 
-- 
2.46.0

