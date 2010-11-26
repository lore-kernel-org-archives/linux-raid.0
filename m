From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 17/53] Disk removal support for Raid10->Raid0 takeover
Date: Fri, 26 Nov 2010 09:06:00 +0100
Message-ID: <20101126080600.5221.13182.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Until now Raid10->Raid0 takeover was possible only if all the mirrors where removed before md starts the takeover.
Now mdadm, when performing Raid10->raid0 takeover, will remove all unwanted mirrors from the array before actual md takeover is called.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 106 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index e977ce2..347f07b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -746,6 +746,92 @@ static void revert_container_raid_disks(struct supertype *st, int fd, char *cont
 	free_mdstat(ent);
 }
 
+int remove_disks_on_raid10_to_raid0_takeover(struct supertype *st,
+					     struct mdinfo *sra,
+					     int layout)
+{
+	int max_disks;
+	int nr_of_copies, in_sync, copies;
+	struct mdinfo info;
+	struct mdinfo *sd_temp;
+	struct mdinfo *sd;
+	int d;
+
+	st->ss->getinfo_super(st, &info);
+	max_disks = info.array.raid_disks;
+
+	nr_of_copies = layout & 0xff;
+	in_sync = nr_of_copies;
+	copies = nr_of_copies;
+
+	/* sort list by slot numbers
+	 */
+	sd_temp = sra->devs;
+	for (sd = sra->devs; sd; sd = sd->next) {
+		struct mdinfo *sd1 = sd;
+		struct mdinfo *sd1_next = sd1->next;
+		struct mdinfo *sd1_prev = NULL;
+		for (sd1 = sd; sd1; sd1 = sd1->next) {
+			if (sd1_next) {
+				if (sd1_next->disk.raid_disk < sd1->disk.raid_disk) {
+					if (sd == sd1)
+						sd = sd1_next;
+					if (sd1_prev)
+						sd1_prev->next = sd1_next;
+					sd1->next = sd1_next->next;
+					sd1_next->next = sd1;
+				}
+			}
+		}
+	}
+	/* Find devices that will be removed from the array */
+	d = 0;
+	sd_temp = sra->devs;
+	for (sd = sra->devs; sd; sd = sd->next, d++) {
+		int i, remove_all = 0;
+
+		if (sd->disk.state & (1<<MD_DISK_REMOVED))
+			continue;
+		if (!(sd->disk.state & (1<<MD_DISK_SYNC)))
+			in_sync--;
+
+		copies--;
+		if (!copies) {
+			/* We reached end of "mirrored" set of devices */
+			if (!in_sync) {
+				/* The array is failed and cannot be reshaped */
+				return 1;
+			}
+			/* Now mark all disks to be removed as faulty
+				 * (leave only one in_sync disk) */
+			for (i = (d-nr_of_copies+1); i <= d; i++, sd_temp = sd_temp->next) {
+				if (sd_temp == NULL) {
+					/* error, array is wrong built
+						 */
+					return 1;
+				}
+				if ((sd_temp->disk.state & (1<<MD_DISK_SYNC)) &&
+				    (remove_all == 0)) {
+					/* this will be the candidate for Raid 0,
+						 * leave it */
+					remove_all = 1;
+					continue;
+				} else {
+					/* this one will be removed */
+					sysfs_set_str(sra, sd_temp, "state", "faulty");
+					sysfs_set_str(sra, sd_temp, "slot", "none");
+					sysfs_set_str(sra, sd_temp, "state", "remove");
+				}
+			}
+			/* update in_sync and copies for the next set of devices */
+			in_sync =  nr_of_copies;
+			copies = nr_of_copies;
+			sd_temp = sd->next;
+		}
+	}
+	return 0;
+}
+
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 long long size,
 		 int level, char *layout_str, int chunksize, int raid_disks)
@@ -872,7 +958,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			st->update_tail = &st->updates;
 	}
 
-	sra = sysfs_read(fd, 0, GET_LEVEL);
+	sra = sysfs_read(fd, 0, GET_LEVEL | GET_DEVS | GET_STATE);
 	if (sra) {
 		if (st->ss->external && st->subarray[0] == 0) {
 			array.level = LEVEL_CONTAINER;
@@ -955,6 +1041,25 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			size = array.size;
 	}
 
+	/* ========= check for Raid10 -> Raid0 conversion ===============
+	 * current implemenation assumes that following conditions must be met:
+	 * - far_copies == 1
+	 * - near_copies == 2
+	 */
+	if (level == 0 && array.level == 10 &&
+	    array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) {
+		int err;
+		err = remove_disks_on_raid10_to_raid0_takeover(st, sra, array.layout);
+		if (err) {
+			dprintf(Name": Array cannot be reshaped\n");
+			if (container)
+				free(container);
+			if (cfd > -1)
+				close(cfd);
+			return 1;
+		}
+	}
+
 	/* ======= set level =========== */
 	if (level != UnSet && level != array.level) {
 		/* Trying to change the level.

