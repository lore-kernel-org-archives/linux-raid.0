From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 02/31] Disk removal support for Raid10->Raid0 takeover
Date: Tue, 9 Nov 2010 17:00:43 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA91@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Until now Raid10->Raid0 takeover was possible only if all the mirrors where removed before md starts the takeover.
Now mdadm, when performing Raid10->raid0 takeover, will remove all unwanted mirrors from the array before actual md takeover is called.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c index 1054979..3721c9c 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -821,7 +821,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			st->update_tail = &st->updates;
 	}
 
-	sra = sysfs_read(fd, 0, GET_VERSION | GET_LEVEL);
+	sra = sysfs_read(fd, 0, GET_VERSION | GET_LEVEL | GET_DEVS | 
+GET_STATE);
 	if (sra) {
 		if (st->ss->external && st->subarray[0] == 0) {
 			array.level = LEVEL_CONTAINER;
@@ -892,6 +892,76 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			size = array.size;
 	}
 
+	/* ========= check for Raid10 -> Raid0 conversion ===============
+	 * current implemenation assumes that following conditions must be met:
+	 * - far_copies == 1
+	 * - near_copies == 2
+	 * - disks number must be even
+	 */
+	if (level == 0 && array.level == 10 &&
+	    array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) {
+		int max_disks;
+		int nr_of_copies, in_sync, copies;
+		struct mdinfo info;
+		struct mdinfo *sd_temp;
+
+		info.array.raid_disks = MD_SB_DISKS;
+		st->ss->getinfo_super(st, &info);
+		max_disks = info.array.raid_disks;
+
+		nr_of_copies = array.layout & 0xff;
+		in_sync = nr_of_copies;
+		copies = nr_of_copies;
+
+		/* Find devices that will be removed from the array */
+		d = 0;
+		sd_temp = sra->devs;
+		for (sd = sra->devs; sd; sd = sd->next, d++) {
+			int i, remove_all = 0;
+
+			if (sd->disk.state & (1<<MD_DISK_REMOVED))
+				continue;
+			if (!(sd->disk.state & (1<<MD_DISK_SYNC)))
+				in_sync--;
+
+			copies--;
+			if (!copies) {
+				/* We reached end of "mirrored" set of devices */
+				if (!in_sync) {
+					/* The array is failed and cannot be reshaped */
+					return 1;
+				}
+
+				/* Now mark all disks to be removed as faulty
+				 * (leave only one in_sync disk) */
+				for (i = (d-nr_of_copies+1); i <= d; i++, sd_temp = sd_temp->next) {
+					if (sd_temp == NULL) {
+						/* error, array is wrong built
+						 */
+						return 1;
+					}
+					if ((sd_temp->disk.state & (1<<MD_DISK_SYNC)) &&
+					    (remove_all == 0)) {
+						/* this will be the candidate for Raid 0,
+						 * leave it */
+						remove_all = 1;
+						continue;
+					} else {
+						/* this one will be removed */
+						sysfs_set_str(sra, sd_temp, "state", "faulty");
+						sysfs_set_str(sra, sd_temp, "slot", "none");
+						sysfs_set_str(sra, sd_temp, "state", "remove");
+
+					}
+				}
+				/* update in_sync and copies for the next set of devices */
+				in_sync =  nr_of_copies;
+				copies = nr_of_copies;
+				sd_temp = sd->next;
+			}
+		}
+	}
+
 	/* ======= set level =========== */
 	if (level != UnSet && level != array.level) {
 		/* Trying to change the level.

