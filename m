From: mwilck@arcor.de
Subject: [PATCH 02/12] DDF: use existing locations for primary and secondary DDF structure
Date: Fri,  1 Mar 2013 23:28:23 +0100
Message-ID: <1362176913-6804-3-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Some RAID BIOSes apparently use hard-coded LBA offsets (presumably
from the end of the disk) for the primary and secondary DDF
structure, ignoring the values given in the DDF anchor. This is
broken BIOS behavior, but it will cause any changes made by MD
(e.g. setting the init_state flag after a full initialization)
to be "forgotten" after the next reboot.

This patch fixes this by using the exiting LBA locations if
available. Verified that this fixes MD+LSI Mega Software RAID
BIOS.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 7f943cb..2f75fc3 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -421,6 +421,9 @@ struct ddf_super {
 				char *devname;
 				int fd;
 				unsigned long long size; /* sectors */
+				unsigned long long primary_lba; /* sectors */
+				unsigned long long secondary_lba; /* sectors */
+				unsigned long long workspace_lba; /* sectors */
 				int pdnum;	/* index in ->phys */
 				struct spare_assign *spare;
 				void *mdupdate; /* hold metadata update */
@@ -668,6 +671,13 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 	dl->size = 0;
 	if (get_dev_size(fd, devname, &dsize))
 		dl->size = dsize >> 9;
+	/* If the disks have different sizes, the LBAs will differ
+	   between phys disks.
+	   At this point here, the values in super->active must be valid
+	   for this phys disk. */
+	dl->primary_lba = super->active->primary_lba;
+	dl->secondary_lba = super->active->secondary_lba;
+	dl->workspace_lba = super->active->workspace_lba;
 	dl->spare = NULL;
 	for (i = 0 ; i < super->max_part ; i++)
 		dl->vlist[i] = NULL;
@@ -2423,9 +2433,21 @@ static int __write_init_super_ddf(struct supertype *st)
 		 */
 		get_dev_size(fd, NULL, &size);
 		size /= 512;
-		ddf->anchor.workspace_lba = __cpu_to_be64(size - 32*1024*2);
-		ddf->anchor.primary_lba = __cpu_to_be64(size - 16*1024*2);
-		ddf->anchor.secondary_lba = __cpu_to_be64(size - 31*1024*2);
+		if (d->workspace_lba != 0)
+			ddf->anchor.workspace_lba = d->workspace_lba;
+		else
+			ddf->anchor.workspace_lba =
+				__cpu_to_be64(size - 32*1024*2);
+		if (d->primary_lba != 0)
+			ddf->anchor.primary_lba = d->primary_lba;
+		else
+			ddf->anchor.primary_lba =
+				__cpu_to_be64(size - 16*1024*2);
+		if (d->secondary_lba != 0)
+			ddf->anchor.secondary_lba = d->secondary_lba;
+		else
+			ddf->anchor.secondary_lba =
+				__cpu_to_be64(size - 32*1024*2);
 		ddf->anchor.seq = __cpu_to_be32(1);
 		memcpy(&ddf->primary, &ddf->anchor, 512);
 		memcpy(&ddf->secondary, &ddf->anchor, 512);
-- 
1.7.3.4
