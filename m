From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: Spare disk has wrong serial after takeover
Date: Thu, 15 Sep 2011 18:38:39 +0200
Message-ID: <20110915163839.5674.99218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

Takeover marks disk as failed and adds to serial ':0' string and then
turns it in to spare. This causes that when new spare is about to be used,
it cannot be found due to different disk serial number.

Restore disk serial number to avoid this problem.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a78d723..f1c924f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4407,6 +4407,37 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	return 0;
 }
 
+/* mark_spare()
+ *   Function marks disk as spare and restores disk serial
+ *   in case it was previously marked as failed by takeover operation
+ * reruns:
+ *   -1 : critical error
+ *    0 : disk is marked as spare but serial is not set
+ *    1 : success
+ */
+int mark_spare(struct dl *disk)
+{
+	__u8 serial[MAX_RAID_SERIAL_LEN];
+	int ret_val = -1;
+
+	if (!disk)
+		return ret_val;
+
+	ret_val = 0;
+	if (!imsm_read_serial(disk->fd, NULL, serial)) {
+		/* Restore disk serial number, because takeover marks disk
+		 * as failed and adds to serial ':0' before it becomes
+		 * a spare disk.
+		 */
+		serialcpy(disk->serial, serial);
+		serialcpy(disk->disk.serial, serial);
+		ret_val = 1;
+	}
+	disk->disk.status = SPARE_DISK;
+	disk->index = -1;
+
+	return ret_val;
+}
 
 static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 			     int fd, char *devname)
@@ -4444,7 +4475,6 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	memset(dd, 0, sizeof(*dd));
 	dd->major = major(stb.st_rdev);
 	dd->minor = minor(stb.st_rdev);
-	dd->index = -1;
 	dd->devname = devname ? strdup(devname) : NULL;
 	dd->fd = fd;
 	dd->e = NULL;
@@ -4461,7 +4491,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	size /= 512;
 	serialcpy(dd->disk.serial, dd->serial);
 	dd->disk.total_blocks = __cpu_to_le32(size);
-	dd->disk.status = SPARE_DISK;
+	mark_spare(dd);
 	if (sysfs_disk_to_scsi_id(fd, &id) == 0)
 		dd->disk.scsi_id = __cpu_to_le32(id);
 	else
@@ -4504,9 +4534,8 @@ static int remove_from_super_imsm(struct supertype *st, mdu_disk_info_t *dk)
 	memset(dd, 0, sizeof(*dd));
 	dd->major = dk->major;
 	dd->minor = dk->minor;
-	dd->index = -1;
 	dd->fd = -1;
-	dd->disk.status = SPARE_DISK;
+	mark_spare(dd);
 	dd->action = DISK_REMOVE;
 
 	dd->next = super->disk_mgmt_list;
@@ -5424,10 +5453,8 @@ static int kill_subarray_imsm(struct supertype *st)
 		struct dl *d;
 
 		for (d = super->disks; d; d = d->next)
-			if (d->index > -2) {
-				d->index = -1;
-				d->disk.status = SPARE_DISK;
-			}
+			if (d->index > -2)
+				mark_spare(d);
 	}
 
 	super->updates_pending++;
@@ -7011,8 +7038,7 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 					if (du->index > idx)
 						du->index--;
 				/* mark as spare disk */
-				dm->disk.status = SPARE_DISK;
-				dm->index = -1;
+				mark_spare(dm);
 			}
 		}
 		/* update map */

