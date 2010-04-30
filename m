From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 2/2] mdadm: Disk removal support for Raid10->Raid0 takeover
Date: Fri, 30 Apr 2010 14:50:37 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801B61C4BB@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids


Raid10->Raid0 takeover was possible only if all the mirrors
where removed before md starts the takover.
Now mdadm, when performing Raid10->raid0 takeover, will remove all
unwanted mirrors from the array before actual md takeover is called.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 Grow.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 17974fa..b804628 100644
--- a/Grow.c
+++ b/Grow.c
@@ -540,7 +540,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			"       Please use a newer kernel\n");
 		return 1;
 	}
-	sra = sysfs_read(fd, 0, GET_VERSION | GET_LEVEL);
+	sra = sysfs_read(fd, 0, GET_VERSION | GET_LEVEL | GET_DEVS | GET_STATE);
 	frozen = freeze_array(sra);
 	if (frozen < 0) {
 		fprintf(stderr, Name ": %s is performing resync/recovery and cannot"
@@ -586,6 +586,102 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			size = array.size;
 	}
 
+	/* ========= check for Raid10 -> Raid0 conversion ===============
+	 * current implemenation assumes that following conditions must be met:
+	 * - far_copies == 1
+	 * - near_copies == 2
+	 * - disks number must be even
+	 */
+	if ((level == 0) && (array.level == 10) &&
+	    (array.layout == ((1 << 8) + 2)) && !(array.raid_disks & 1)) {
+
+		int max_disks = MD_SB_DISKS; /* just a default */
+		if (st != NULL)
+			max_disks = st->max_devs;
+
+		/* Prepare temporary disk table */
+		struct mdinfo *de;
+		mdu_disk_info_t *disks;
+		disks = malloc(max_disks * sizeof(mdu_disk_info_t));
+		if (!disks) {
+			fprintf(stderr, Name ": malloc failed: grow aborted\n");
+			rv = 1;
+			goto release;
+		}
+		for (d = 0; d < max_disks; d++) {
+			disks[d].state = (1<<MD_DISK_REMOVED);
+			disks[d].major = disks[d].minor = 0;
+			disks[d].number = disks[d].raid_disk = d;
+		}
+
+		/* initialize temporary disk table with current devices*/
+		for (de = sra->devs; de; de = de->next) {
+			if ((de->disk.raid_disk >= 0) &&
+			    (de->disk.raid_disk < array.raid_disks))
+				disks[de->disk.raid_disk] = de->disk;
+		}
+
+		/* Get near_copies */
+		int nr_of_copies = array.layout & 0xff;
+		int in_sync, copies;
+		in_sync = copies = nr_of_copies;
+
+		/* Find devices that will be removed from the array */
+		for (d = 0; d < max_disks; d++) {
+			if (disks[d].state & (1<<MD_DISK_REMOVED))
+				continue;
+			/* Count in_sync copies */
+			if (!(disks[d].state & (1<<MD_DISK_SYNC)))
+				in_sync--;
+
+			copies--;
+			if (!copies) {
+				/* We reached end of "mirrored" set of devices */
+				if (!in_sync) {
+					/* The array is failed and cannot be reshaped */
+					free(disks);
+					return 1;
+				}
+
+				int i, remove_all = 0;
+				/* Now mark all disks to be removed as faulty
+				 * (leave only one in_sync disk) */
+				for (i = (d-nr_of_copies+1); i <= d; i++) {
+					if (remove_all)
+						disks[i].state |= (1<<MD_DISK_FAULTY);
+					else {
+						if (disks[i].state & (1<<MD_DISK_SYNC)) {
+							/* this will be the candidate for Raid 0,
+							 * leave it */
+							remove_all = 1;
+							continue;
+						} else {
+							/* make sure it will be removed */
+							disks[i].state |= (1<<MD_DISK_FAULTY);
+						}
+					}
+				}
+				/* update in_sync and copies for the next set of devices */
+				in_sync = copies = nr_of_copies;
+			}
+		}
+
+		/* Remove unwanted devices from the array */
+		for (de = sra->devs; de; de = de->next) {
+			d = de->disk.raid_disk;
+			if (disks[d].state & (1<<MD_DISK_FAULTY)) {
+				sysfs_set_str(sra, de, "state", "faulty");
+				sysfs_set_str(sra, de, "slot", "none");
+				sysfs_set_str(sra, de, "state", "remove");
+			}
+		}
+
+		if (disks) {
+			free(disks);
+			disks = NULL;
+		}
+	}
+
 	/* ======= set level =========== */
 	if (level != UnSet && level != array.level) {
 		/* Trying to change the level.
-- 
1.7.0.2

