From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/6] md/failfast: add failfast flag for md to be used by
 some personalities.
Date: Fri, 18 Nov 2016 16:16:11 +1100
Message-ID: <147944617143.3302.17138878373669282315.stgit@noble>
References: <147944614789.3302.1959091446949640579.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147944614789.3302.1959091446949640579.stgit@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

This patch just adds a 'failfast' per-device flag which can be stored
in v0.90 or v1.x metadata.
The flag is not used yet but the intent is that it can be used for
mirrored (raid1/raid10) arrays where low latency is more important
than keeping all devices on-line.

Setting the flag for a device effectively gives permission for that
device to be marked as Faulty and excluded from the array on the first
error.  The underlying driver will be directed not to retry requests
that result in failures.  There is a proviso that the device must not
be marked faulty if that would cause the array as a whole to fail, it
may only be marked Faulty if the array remains functional, but is
degraded.

Failures on read requests will cause the device to be marked
as Faulty immediately so that further reads will avoid that
device.  No attempt will be made to correct read errors by
over-writing with the correct data.

It is expected that if transient errors, such as cable unplug, are
possible, then something in user-space will revalidate failed
devices and re-add them when they appear to be working again.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c                |   27 +++++++++++++++++++++++++++
 drivers/md/md.h                |    6 ++++++
 include/uapi/linux/raid/md_p.h |    7 ++++++-
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1f1c7f007b68..0d1a9fd9d1c1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1163,6 +1163,8 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 		}
 		if (desc->state & (1<<MD_DISK_WRITEMOSTLY))
 			set_bit(WriteMostly, &rdev->flags);
+		if (desc->state & (1<<MD_DISK_FAILFAST))
+			set_bit(FailFast, &rdev->flags);
 	} else /* MULTIPATH are always insync */
 		set_bit(In_sync, &rdev->flags);
 	return 0;
@@ -1288,6 +1290,8 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 		}
 		if (test_bit(WriteMostly, &rdev2->flags))
 			d->state |= (1<<MD_DISK_WRITEMOSTLY);
+		if (test_bit(FailFast, &rdev2->flags))
+			d->state |= (1<<MD_DISK_FAILFAST);
 	}
 	/* now set the "removed" and "faulty" bits on any missing devices */
 	for (i=0 ; i < mddev->raid_disks ; i++) {
@@ -1672,6 +1676,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		}
 		if (sb->devflags & WriteMostly1)
 			set_bit(WriteMostly, &rdev->flags);
+		if (sb->devflags & FailFast1)
+			set_bit(FailFast, &rdev->flags);
 		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_REPLACEMENT)
 			set_bit(Replacement, &rdev->flags);
 	} else /* MULTIPATH are always insync */
@@ -1710,6 +1716,10 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->chunksize = cpu_to_le32(mddev->chunk_sectors);
 	sb->level = cpu_to_le32(mddev->level);
 	sb->layout = cpu_to_le32(mddev->layout);
+	if (test_bit(FailFast, &rdev->flags))
+		sb->devflags |= FailFast1;
+	else
+		sb->devflags &= ~FailFast1;
 
 	if (test_bit(WriteMostly, &rdev->flags))
 		sb->devflags |= WriteMostly1;
@@ -2554,6 +2564,8 @@ state_show(struct md_rdev *rdev, char *page)
 		len += sprintf(page+len, "replacement%s", sep);
 	if (test_bit(ExternalBbl, &flags))
 		len += sprintf(page+len, "external_bbl%s", sep);
+	if (test_bit(FailFast, &flags))
+		len += sprintf(page+len, "failfast%s", sep);
 
 	if (len)
 		len -= strlen(sep);
@@ -2576,6 +2588,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	 *            so that it gets rebuilt based on bitmap
 	 *  write_error - sets WriteErrorSeen
 	 *  -write_error - clears WriteErrorSeen
+	 *  {,-}failfast - set/clear FailFast
 	 */
 	int err = -EINVAL;
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
@@ -2634,6 +2647,12 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "insync") && rdev->raid_disk == -1) {
 		set_bit(In_sync, &rdev->flags);
 		err = 0;
+	} else if (cmd_match(buf, "failfast")) {
+		set_bit(FailFast, &rdev->flags);
+		err = 0;
+	} else if (cmd_match(buf, "-failfast")) {
+		clear_bit(FailFast, &rdev->flags);
+		err = 0;
 	} else if (cmd_match(buf, "-insync") && rdev->raid_disk >= 0 &&
 		   !test_bit(Journal, &rdev->flags)) {
 		if (rdev->mddev->pers == NULL) {
@@ -5939,6 +5958,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 			info.state |= (1<<MD_DISK_JOURNAL);
 		if (test_bit(WriteMostly, &rdev->flags))
 			info.state |= (1<<MD_DISK_WRITEMOSTLY);
+		if (test_bit(FailFast, &rdev->flags))
+			info.state |= (1<<MD_DISK_FAILFAST);
 	} else {
 		info.major = info.minor = 0;
 		info.raid_disk = -1;
@@ -6046,6 +6067,10 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 			set_bit(WriteMostly, &rdev->flags);
 		else
 			clear_bit(WriteMostly, &rdev->flags);
+		if (info->state & (1<<MD_DISK_FAILFAST))
+			set_bit(FailFast, &rdev->flags);
+		else
+			clear_bit(FailFast, &rdev->flags);
 
 		if (info->state & (1<<MD_DISK_JOURNAL)) {
 			struct md_rdev *rdev2;
@@ -6135,6 +6160,8 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
 			set_bit(WriteMostly, &rdev->flags);
+		if (info->state & (1<<MD_DISK_FAILFAST))
+			set_bit(FailFast, &rdev->flags);
 
 		if (!mddev->persistent) {
 			pr_debug("md: nonpersistent superblock ...\n");
diff --git a/drivers/md/md.h b/drivers/md/md.h
index af6b33c30d2d..bc6712ef8c81 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -171,6 +171,12 @@ enum flag_bits {
 	ExternalBbl,            /* External metadata provides bad
 				 * block management for a disk
 				 */
+	FailFast,		/* Minimal retries should be attempted on
+				 * this device, so use REQ_FAILFAST_DEV.
+				 * Also don't try to repair failed reads.
+				 * It is expects that no bad block log
+				 * is present.
+				 */
 };
 
 static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index c3e654c6d518..9930f3e9040f 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -84,6 +84,10 @@
 #define MD_DISK_CANDIDATE	5 /* disk is added as spare (local) until confirmed
 				   * For clustered enviroments only.
 				   */
+#define MD_DISK_FAILFAST	10 /* Send REQ_FAILFAST if there are multiple
+				    * devices available - and don't try to
+				    * correct read errors.
+				    */
 
 #define	MD_DISK_WRITEMOSTLY	9 /* disk is "write-mostly" is RAID1 config.
 				   * read requests will only be sent here in
@@ -265,8 +269,9 @@ struct mdp_superblock_1 {
 	__le32	dev_number;	/* permanent identifier of this  device - not role in raid */
 	__le32	cnt_corrected_read; /* number of read errors that were corrected by re-writing */
 	__u8	device_uuid[16]; /* user-space setable, ignored by kernel */
-	__u8	devflags;	/* per-device flags.  Only one defined...*/
+	__u8	devflags;	/* per-device flags.  Only two defined...*/
 #define	WriteMostly1	1	/* mask for writemostly flag in above */
+#define	FailFast1	2	/* Should avoid retries and fixups and just fail */
 	/* Bad block log.  If there are any bad blocks the feature flag is set.
 	 * If offset and size are non-zero, that space is reserved and available
 	 */
