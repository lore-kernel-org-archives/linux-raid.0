Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F16D530DF6
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180255; cv=none; b=a6wt9Hhw39XJgwKZh4KAi0fVPwDOtp43wPBEwFJ5bo0wlSE6NfJdXn/BlJnwftWtHzy6xD/P/RPKAms5thaspR5/R4uWSeA8xBRKQyiDvzfU4vPQbagxg8B0vFjZ1H+nyqV/JNtMNVeJa6n0qtSSp0JpFt6vsenl2/A/6tvQNZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180255; c=relaxed/simple;
	bh=sbnmurq/uAX+vNJcFUT4c5jU9IwDiC579Dx07vz6Q7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bkAwp0ar6KP7zMdvs5ITZ2IkRN6O23CZPbxHcjleUX41SNg9OkPm566qW4rUkHlCGOyg0W9gLzeEdI08DI8t8/Cd3eMXWb8odUaCBkIWtYOKgTljC7uGGgfUAK/+1wdbhD3wiPUzRK7jGCLybqDUO3uXZnj9lXwfZYruDP/fJas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q7DczvZl; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q7DczvZl"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4843e397f74so12456f8f.1
        for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 09:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790180252; x=1790785052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6FsqUSBp8jlzbulaQzZnxDz2zVSSSTOE4AXgMopXxYY=;
        b=q7DczvZleVowyfmR//K2jhBCDx0FX6D86DjOCweqf0hKEE8zwvFpJUksV5TwmG+6AR
         bclRVLedfwtMqBMN0xX9u2VmZ/IXgXaWTWqZ7zKfMVlzp8G7B66Km1HEEps2H5PsogK+
         /V/d56NZRn3QkCUC17WIeiPPBcfSFTAFmX2H5IsRH0opIJ4343UMaicQXN6WeL96vONF
         6QHlobj0fijbv3GNGdmyNso+9FtFwD5dTi6+bc5ZwQJb6IGi5AiU6WIN3P8hHlTkkkJM
         ZCuYYoJVYgGI+GM4a99LJQDnD6OomFVCMqa4P/L+18wasKyjRtv11TP5CP8znIyUtuW9
         raAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790180252; x=1790785052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6FsqUSBp8jlzbulaQzZnxDz2zVSSSTOE4AXgMopXxYY=;
        b=WcXF7v4D/46sQWRxCRBPfh1BzRU+WHRzWAhtaGqdUeqBHcIvqy/WHyevciaKzmJ3Hn
         S8ivPX2GsMr6geHwmlcni4YY6VSg77/CrbyiFEr5T0woFQZbiFiKs1WGdanEvTlgvvUZ
         BnFqmuGUaQFM3nRbIcw6sCVCOgTnIWx92gExRFBTXNpGsxuJP2n2BBsIfCGamvAMjsTa
         vkrOGz57rrk5ViyuTdX1Ionbz45mFw5gDYOflxG7ZAUU40hEoMbGORAbTPn22i+E1tp7
         pm6l5S12n2Ulm2mgH5dZJZV7xQm00a6mahWIxEVKMecO6ZLrDQSZGrv15EltARS/MZzt
         0Jnw==
X-Forwarded-Encrypted: i=1; AKwUvBwyJ6cfg0ZtS3KEJjjoos8C4yAv6nqrW9A+JM3cOezqIboW4zXfddZEditbV0IXRcVuMPDFRenFMX7R@vger.kernel.org
X-Gm-Message-State: AFuF++maCR3O3csU/JNNrRanf8lRR/htm7KEF+JA+rG1PijizSP7h3Ri
	5EHM4U3X+vqY4GSci9Vwvu6GtKMB+uq4AMa+RP7ZbtQBsBoUmyB9vYCs2WllO2gEmRqDfQ==
X-Gm-Gg: AYBFou3OWdrCpUpjGJgMMvp4Env7/MebKaPBWwJWQhA6Hzp2SaXFD9/R/KsMJlPgVJZ
	NLpGsKKEIJme7Nb6jEZcnKU0y8Kt2A0+D15DubwbVfV91Q6b6kWQoOnV4j9Hd5YyqysxaWVWiSn
	9/hWvNcwpqczHLGnBCoH23qCRRPaMZrdf/U/UT1+hMNTQ4b/S1EAJznMrAyuHOKkQB1KXQx12WQ
	SNMSIuscJ7Ek9Sam7YdIPfJsRuOd9dHv8vZjlrn3QWYyYgJvlcUE3fbgwzGBiaobILdywOjYS46
	HGMGGBqDSGzT5twiczsyfFaugogNxM53LalAWJysq8HEvZNvyBwoDl/SIVlvxW8JM30rHN/Mhao
	7zQBKYx4tynPH+fHZ3l3K0Gnd3wQQCkzSW+RAnTbGFOomMmp474kG6+uGUj6N1OJgkIP11zN/XU
	IfMua0JbD1nZ587ycLkGdQhbzbjnAbNs00jw1lG84+WzO3Gk2TwsKZCWoF7QGGCEfiBKjV+DC5G
	/aa6Vum3OGVmKbhu/zJlMRcd+61t/QHFaXOGW9YuGo+MPFTdYFqrKsZ7s41/G1Hzyn4l5yJr7ov
	lQ==
X-Received: by 2002:a05:6000:1788:b0:487:22b1:e511 with SMTP id ffacd0b85a97d-48860f8dca0mr13416589f8f.9.1790180251439;
        Wed, 23 Sep 2026 09:17:31 -0700 (PDT)
Received: from Raghu007.. (sgyl-44-b2-v4wan-174108-cust110.vm6.cable.virginm.net. [80.1.81.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48867b49661sm7602716f8f.0.2026.09.23.09.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 09:17:30 -0700 (PDT)
From: Palla Raghunath <raghunathpalla.0209@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	linux-kernel-mentees@lists.linux.dev,
	raghunathpalla.0209@gmail.com,
	syzbot+422b372cabfbaa528725@syzkaller.appspotmail.com,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	"Trela, Maciej" <Maciej.Trela@intel.com>,
	linux-raid@vger.kernel.org
Subject: [PATCH] md/raid0: don't BUG() on a bio that lands off the end of the array
Date: Wed, 23 Sep 2026 17:17:28 +0100
Message-Id: <20260923161729.122240-1-raghunathpalla.0209@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

find_zone() looks for the strip zone holding a given sector and BUG()s if
it can't find one.  That is only a safe assumption while the capacity the
array advertises matches what the zones actually cover, and a personality
takeover can break exactly that.

level_store() lets you switch a live array to a different personality.
The new ->run() recalculates mddev->array_sectors, but level_store() never
tells the gendisk about it - it is the one place in md that changes the
array size without a set_capacity_and_notify(), which do_md_run(),
array_size_store(), update_size(), md_reap_sync_thread() and linear_add()
all do.  So when a takeover makes the array smaller, the block device goes
on advertising the old size and I/O sails off the end of the new mapping.

syzbot got there with a raid1 that had no metadata.  Such a member comes in
through md_import_device(dev, -1, -1), which never sets rdev->sectors, and
the check in bind_rdev_to_array() that keeps mddev->dev_sectors inside the
member is skipped precisely when rdev->sectors is 0:

	if (!test_bit(Journal, &rdev->flags) &&
	    rdev->sectors &&
	    (mddev->dev_sectors == 0 || rdev->sectors < mddev->dev_sectors)) {

md/component_size had set dev_sectors to 2048, so raid1 came up with
array_sectors = 2048 and the disk got a 2048 sector capacity.  Writing
"raid0" to md/level then took the array over: create_strip_zones() rounded
rdev->sectors (0) down to a chunk multiple, so the single strip zone ended
at 0 and raid0_size() returned 0.  The capacity stayed at 2048, so the
partition scan on the next open of /dev/md0 read sector 0 and fell over:

  kernel BUG at drivers/md/raid0.c:318!
  RIP: 0010:find_zone drivers/md/raid0.c:318 [inline]
  RIP: 0010:raid0_map_submit_bio drivers/md/raid0.c:568 [inline]
  RIP: 0010:raid0_make_request+0xf17/0x10b0 drivers/md/raid0.c:626
  Call Trace:
   <TASK>
   md_handle_request+0xb0a/0xe60 drivers/md/md.c:417
   __submit_bio+0x27f/0x340 block/blk-core.c:681
   submit_bio_noacct_nocheck+0x4e8/0xa40 block/blk-core.c:792
   block_read_full_folio+0x7a6/0x810 fs/buffer.c:2373
   read_part_sector+0xb6/0x2b0 block/partitions/core.c:724
   adfspart_check_ICS+0xb1/0x960 block/partitions/acorn.c:357
   bdev_disk_changed+0x851/0x17a0 block/partitions/core.c:695
   blkdev_get_whole+0x372/0x510 block/bdev.c:793
   bdev_open+0x324/0xd70 block/bdev.c:1002
   blkdev_open+0x461/0x600 block/fops.c:674
   __x64_sys_openat+0x138/0x170 fs/open.c:1434

Just refreshing the capacity in level_store() is not enough on its own.
If the size is managed externally - md/array_size written while the array
was stopped, which slips past array_size_store()'s -E2BIG check -
md_set_array_sectors() does nothing, array_sectors keeps the larger value
and we BUG() all the same.  level_store() cannot turn the takeover away
the way do_md_run() does either, because ->takeover() has already run and
the old personality has already been freed.

md-linear has always just failed a sector outside its mapping instead of
asserting, so do the same here: let find_zone() return NULL and have its
two callers report the bio and end it with an I/O error.

Tested both ways into this state - a takeover that leaves the array
zero-length, and one where md/array_size pins array_sectors at 2048.
Before, each panics in find_zone(); after, the read just fails:

  md/raid0:md0: sector 0 out of bounds, array size 0
  md/raid0:md0: sector 0 out of bounds, array size 2048

Reported-by: syzbot+422b372cabfbaa528725@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=422b372cabfbaa528725
Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover")
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
---
 drivers/md/raid0.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3..04c022d74fae 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -301,6 +301,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 
 /* Find the zone which holds a particular offset
  * Update *sectorp to be an offset in that zone
+ * Returns NULL if the sector is off the end of the array.
  */
 static struct strip_zone *find_zone(struct r0conf *conf,
 				    sector_t *sectorp)
@@ -315,7 +316,16 @@ static struct strip_zone *find_zone(struct r0conf *conf,
 				*sectorp = sector - z[i-1].zone_end;
 			return z + i;
 		}
-	BUG();
+	return NULL;
+}
+
+static void raid0_out_of_bounds(struct mddev *mddev, struct bio *bio)
+{
+	pr_err_ratelimited("md/raid0:%s: sector %llu out of bounds, array size %llu\n",
+			   mdname(mddev),
+			   (unsigned long long)bio->bi_iter.bi_sector,
+			   (unsigned long long)mddev->array_sectors);
+	bio_io_error(bio);
 }
 
 /*
@@ -471,6 +481,10 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 
 	orig_start = start;
 	zone = find_zone(conf, &start);
+	if (!zone) {
+		raid0_out_of_bounds(mddev, bio);
+		return;
+	}
 
 	if (bio_end_sector(bio) > zone->zone_end) {
 		bio = bio_submit_split_bioset(bio,
@@ -566,6 +580,11 @@ static void raid0_map_submit_bio(struct mddev *mddev, struct bio *bio)
 	md_account_bio(mddev, &bio);
 
 	zone = find_zone(mddev->private, &sector);
+	if (!zone) {
+		raid0_out_of_bounds(mddev, bio);
+		return;
+	}
+
 	switch (conf->layout) {
 	case RAID0_ORIG_LAYOUT:
 		tmp_dev = map_sector(mddev, zone, bio_sector, &sector);
-- 
2.34.1

