From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 17/53] Disk removal support for Raid10->Raid0 takeover
Date: Mon, 29 Nov 2010 12:00:23 +1100
Message-ID: <20101129120023.18c965a2@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080600.5221.13182.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126080600.5221.13182.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:06:00 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Until now Raid10->Raid0 takeover was possible only if all the mirrors where removed before md starts the takeover.
> Now mdadm, when performing Raid10->raid0 takeover, will remove all unwanted mirrors from the array before actual md takeover is called.
> 
> Signed-off-by: Maciej Trela <maciej.trela@intel.com>
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

This patch makes sense, but I found the logic in choosing which devices to
remove to be vary hard to follow.

I have replaced it with the following:  We select one disk to keep from each
pair, then remove the remainder.

Thanks,
NeilBrown

commit 62a48395f60965d04da1a9cbb937bda79dd071c8
Author: Adam Kwolek <adam.kwolek@intel.com>
Date:   Mon Nov 29 11:57:51 2010 +1100

    Disk removal support for Raid10->Raid0 takeover
    
    Until now Raid10->Raid0 takeover was possible only if all the mirrors
    where removed before md starts the takeover.  Now mdadm, when
    performing Raid10->raid0 takeover, will remove all unwanted mirrors
    from the array before actual md takeover is called.
    
    Signed-off-by: Maciej Trela <maciej.trela@intel.com>
    Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index ea8f493..1d92d68 100644
--- a/Grow.c
+++ b/Grow.c
@@ -771,6 +771,76 @@ static void revert_container_raid_disks(struct supertype *st, int fd, char *cont
 	free_mdstat(ent);
 }
 
+int remove_disks_on_raid10_to_raid0_takeover(struct supertype *st,
+					     struct mdinfo *sra,
+					     int layout)
+{
+	int nr_of_copies;
+	struct mdinfo *remaining;
+	int slot;
+
+	nr_of_copies = layout & 0xff;
+
+	remaining = sra->devs;
+	sra->devs = NULL;
+	/* for each 'copy', select one device and remove from the list. */
+	for (slot = 0; slot < sra->array.raid_disks; slot += nr_of_copies) {
+		struct mdinfo **diskp;
+		int found = 0;
+
+		/* Find a working device to keep */
+		for (diskp =  &remaining; *diskp ; diskp = &(*diskp)->next) {
+			struct mdinfo *disk = *diskp;
+
+			if (disk->disk.raid_disk < slot)
+				continue;
+			if (disk->disk.raid_disk >= slot + nr_of_copies)
+				continue;
+			if (disk->disk.state & (1<<MD_DISK_REMOVED))
+				continue;
+			if (disk->disk.state & (1<<MD_DISK_FAULTY))
+				continue;
+			if (!(disk->disk.state & (1<<MD_DISK_SYNC)))
+				continue;
+
+			/* We have found a good disk to use! */
+			*diskp = disk->next;
+			disk->next = sra->devs;
+			sra->devs = disk;
+			found = 1;
+			break;
+		}
+		if (!found)
+			break;
+	}
+
+	if (slot < sra->array.raid_disks) {
+		/* didn't find all slots */
+		struct mdinfo **e;
+		e = &remaining;
+		while (*e)
+			e = &(*e)->next;
+		*e = sra->devs;
+		sra->devs = remaining;
+		return 1;
+	}
+
+	/* Remove all 'remaining' devices from the array */
+	while (remaining) {
+		struct mdinfo *sd = remaining;
+		remaining = sd->next;
+
+		sysfs_set_str(sra, sd, "state", "faulty");
+		sysfs_set_str(sra, sd, "slot", "none");
+		sysfs_set_str(sra, sd, "state", "remove");
+		sd->disk.state |= (1<<MD_DISK_REMOVED);
+		sd->disk.state &= ~(1<<MD_DISK_SYNC);
+		sd->next = sra->devs;
+		sra->devs = sd;
+	}
+	return 0;
+}
+
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 long long size,
 		 int level, char *layout_str, int chunksize, int raid_disks)
@@ -902,7 +972,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			st->update_tail = &st->updates;
 	}
 
-	sra = sysfs_read(fd, 0, GET_LEVEL);
+	sra = sysfs_read(fd, 0, GET_LEVEL | GET_DISKS | GET_DEVS | GET_STATE);
 	if (sra) {
 		if (st->ss->external && subarray == NULL) {
 			array.level = LEVEL_CONTAINER;
@@ -973,6 +1043,25 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
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
