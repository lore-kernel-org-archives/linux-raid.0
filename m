From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 7] md: Fix bug with linear hot-add and elsewhere.
Date: Mon, 21 May 2007 11:33:16 +1000
Message-ID: <1070521013316.6714@suse.de>
References: <20070521111837.20906.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


Adding a drive to a linear array seems to have stopped working,
due to changes elsewhere in md, and insufficient ongoing testing...

So the patch to make linear hot-add work in the first place
introduced a subtle bug elsewhere that interracts poorly with
older version of mdadm.

This fixes it all up.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/linear.c |   10 +++++-----
 ./drivers/md/md.c     |   20 ++++++++++++++------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff .prev/drivers/md/linear.c ./drivers/md/linear.c
--- .prev/drivers/md/linear.c	2007-05-21 11:13:25.000000000 +1000
+++ ./drivers/md/linear.c	2007-05-21 11:13:39.000000000 +1000
@@ -139,8 +139,6 @@ static linear_conf_t *linear_conf(mddev_
 	if (!conf)
 		return NULL;
 
-	mddev->private = conf;
-
 	cnt = 0;
 	conf->array_size = 0;
 
@@ -232,7 +230,7 @@ static linear_conf_t *linear_conf(mddev_
 	 * First calculate the device offsets.
 	 */
 	conf->disks[0].offset = 0;
-	for (i=1; i<mddev->raid_disks; i++)
+	for (i=1; i < raid_disks; i++)
 		conf->disks[i].offset =
 			conf->disks[i-1].offset +
 			conf->disks[i-1].size;
@@ -244,7 +242,7 @@ static linear_conf_t *linear_conf(mddev_
 	     curr_offset < conf->array_size;
 	     curr_offset += conf->hash_spacing) {
 
-		while (i < mddev->raid_disks-1 &&
+		while (i < raid_disks-1 &&
 		       curr_offset >= conf->disks[i+1].offset)
 			i++;
 
@@ -299,9 +297,11 @@ static int linear_add(mddev_t *mddev, md
 	 */
 	linear_conf_t *newconf;
 
-	if (rdev->raid_disk != mddev->raid_disks)
+	if (rdev->saved_raid_disk != mddev->raid_disks)
 		return -EINVAL;
 
+	rdev->raid_disk = rdev->saved_raid_disk;
+
 	newconf = linear_conf(mddev,mddev->raid_disks+1);
 
 	if (!newconf)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-21 11:13:25.000000000 +1000
+++ ./drivers/md/md.c	2007-05-21 11:14:54.000000000 +1000
@@ -1298,8 +1298,9 @@ static void super_1_sync(mddev_t *mddev,
 	ITERATE_RDEV(mddev,rdev2,tmp)
 		if (rdev2->desc_nr+1 > max_dev)
 			max_dev = rdev2->desc_nr+1;
-	
-	sb->max_dev = cpu_to_le32(max_dev);
+
+	if (max_dev > le32_to_cpu(sb->max_dev))
+		sb->max_dev = cpu_to_le32(max_dev);
 	for (i=0; i<max_dev;i++)
 		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	
@@ -1365,10 +1366,14 @@ static int bind_rdev_to_array(mdk_rdev_t
 	}
 	/* make sure rdev->size exceeds mddev->size */
 	if (rdev->size && (mddev->size == 0 || rdev->size < mddev->size)) {
-		if (mddev->pers)
-			/* Cannot change size, so fail */
-			return -ENOSPC;
-		else
+		if (mddev->pers) {
+			/* Cannot change size, so fail
+			 * If mddev->level <= 0, then we don't care
+			 * about aligning sizes (e.g. linear)
+			 */
+			if (mddev->level > 0)
+				return -ENOSPC;
+		} else
 			mddev->size = rdev->size;
 	}
 
@@ -2142,6 +2147,9 @@ static void analyze_sbs(mddev_t * mddev)
 			rdev->desc_nr = i++;
 			rdev->raid_disk = rdev->desc_nr;
 			set_bit(In_sync, &rdev->flags);
+		} else if (rdev->raid_disk >= mddev->raid_disks) {
+			rdev->raid_disk = -1;
+			clear_bit(In_sync, &rdev->flags);
 		}
 	}
 
