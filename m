Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DF0C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 15:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A195860F94
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 15:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhJRPSS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Oct 2021 11:18:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:64979 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232981AbhJRPSQ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 18 Oct 2021 11:18:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="227037487"
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="227037487"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 08:12:32 -0700
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="493619490"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 08:12:30 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] imsm: introduce helpers to manage file descriptors
Date:   Mon, 18 Oct 2021 17:12:17 +0200
Message-Id: <20211018151217.31583-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To avoid direct comparisions define dedicated inlines.
This patch propagates them in super-intel.c. They are declared globally
for future usage outside IMSM.

Additionally, it adds fd check in save_backup_imsm() to remove
code vulnerability and simplifies targets array implementation.

It also propagates prr_vrb() macro instead if (verbose) condidtion.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
Hi Jes,
For now scope is limited to IMSM. If you ok the idea please apply it.
I would like to use it in other places, but first I need to have it
applied.

 mdadm.h       |  25 ++++++++
 super-intel.c | 168 +++++++++++++++++++++++---------------------------
 2 files changed, 101 insertions(+), 92 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 8f8841d8..4f6da7e2 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -782,6 +782,31 @@ static inline char *map_dev(int major, int minor, int create)
 	return map_dev_preferred(major, minor, create, NULL);
 }
 
+/**
+ * is_fd_valid() - check file descriptor.
+ * @fd: file descriptor.
+ *
+ * The function checks if @fd is nonnegative integer and shall be used only
+ * to verify open() result.
+ */
+static inline int is_fd_valid(int fd)
+{
+	return (fd > -1);
+}
+
+/**
+ * close_fd() - verify, close and unset file descriptor.
+ * @fd: pointer to file descriptor.
+ *
+ * The function closes and invalidates file descriptor if appropriative. It
+ * ignores incorrect file descriptor quitely to simplify error handling.
+ */
+static inline void close_fd(int *fd)
+{
+	if (is_fd_valid(*fd) && close(*fd) == 0)
+		*fd = -1;
+}
+
 struct active_array;
 struct metadata_update;
 
diff --git a/super-intel.c b/super-intel.c
index 83ddc000..13eeac9d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -691,7 +691,7 @@ static struct sys_dev* find_disk_attached_hba(int fd, const char *devname)
 	if ((list = find_intel_devices()) == NULL)
 		return 0;
 
-	if (fd < 0)
+	if (!is_fd_valid(fd))
 		disk_path  = (char *) devname;
 	else
 		disk_path = diskfd_to_devpath(fd, 1, NULL);
@@ -2406,7 +2406,7 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 		}
 
 		fd = dev_open(ent->d_name, O_RDONLY);
-		if (fd < 0)
+		if (!is_fd_valid(fd))
 			printf("          Port%d : - disk info unavailable -\n", port);
 		else {
 			fd2devname(fd, buf);
@@ -2455,7 +2455,7 @@ static int print_nvme_info(struct sys_dev *hba)
 			goto skip;
 
 		fd = open_dev(ent->d_name);
-		if (fd < 0)
+		if (!is_fd_valid(fd))
 			goto skip;
 
 		if (!diskfd_to_devpath(fd, 0, ns_path) ||
@@ -2481,8 +2481,7 @@ static int print_nvme_info(struct sys_dev *hba)
 			printf("()\n");
 
 skip:
-		if (fd > -1)
-			close(fd);
+		close_fd(&fd);
 	}
 
 	closedir(dir);
@@ -3171,10 +3170,11 @@ static int load_imsm_migr_rec(struct intel_super *super)
 		if (slot > 1 || slot < 0)
 			continue;
 
-		if (dl->fd < 0) {
+		if (!is_fd_valid(dl->fd)) {
 			sprintf(nm, "%d:%d", dl->major, dl->minor);
 			fd = dev_open(nm, O_RDONLY);
-			if (fd >= 0) {
+
+			if (is_fd_valid(fd)) {
 				keep_fd = 0;
 				break;
 			}
@@ -3184,7 +3184,7 @@ static int load_imsm_migr_rec(struct intel_super *super)
 		}
 	}
 
-	if (fd < 0)
+	if (!is_fd_valid(fd))
 		return retval;
 	retval = read_imsm_migr_rec(fd, super);
 	if (!keep_fd)
@@ -4544,8 +4544,8 @@ load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd
 
 static void __free_imsm_disk(struct dl *d, int close_fd)
 {
-	if (close_fd && d->fd > -1)
-		close(d->fd);
+	if (close_fd)
+		close_fd(&d->fd);
 	if (d->devname)
 		free(d->devname);
 	if (d->e)
@@ -4650,12 +4650,12 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, char *de
 	struct sys_dev *hba_name;
 	int rv = 0;
 
-	if (fd >= 0 && test_partition(fd)) {
+	if (is_fd_valid(fd) && test_partition(fd)) {
 		pr_err("imsm: %s is a partition, cannot be used in IMSM\n",
 		       devname);
 		return 1;
 	}
-	if (fd < 0 || check_env("IMSM_NO_PLATFORM")) {
+	if (!is_fd_valid(fd) || check_env("IMSM_NO_PLATFORM")) {
 		super->orom = NULL;
 		super->hba = NULL;
 		return 0;
@@ -5064,7 +5064,7 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 	int err = 0;
 	int i = 0;
 
-	if (fd >= 0)
+	if (is_fd_valid(fd))
 		/* 'fd' is an opened container */
 		err = get_sra_super_block(fd, &super_list, devname, &i, keep_fd);
 	else
@@ -5121,7 +5121,7 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 		return err;
 
 	*sbp = super;
-	if (fd >= 0)
+	if (is_fd_valid(fd))
 		strcpy(st->container_devnm, fd2devnm(fd));
 	else
 		st->container_devnm[0] = 0;
@@ -5147,7 +5147,7 @@ get_devlist_super_block(struct md_list *devlist, struct intel_super **super_list
 		if (tmpdev->container == 1) {
 			int lmax = 0;
 			int fd = dev_open(tmpdev->devname, O_RDONLY|O_EXCL);
-			if (fd < 0) {
+			if (!is_fd_valid(fd)) {
 				pr_err("cannot open device %s: %s\n",
 					tmpdev->devname, strerror(errno));
 				err = 8;
@@ -5199,7 +5199,7 @@ static int get_super_block(struct intel_super **super_list, char *devnm, char *d
 
 	sprintf(nm, "%d:%d", major, minor);
 	dfd = dev_open(nm, O_RDWR);
-	if (dfd < 0) {
+	if (!is_fd_valid(dfd)) {
 		err = 2;
 		goto error;
 	}
@@ -5226,11 +5226,10 @@ static int get_super_block(struct intel_super **super_list, char *devnm, char *d
 	} else {
 		if (s)
 			free_imsm(s);
-		if (dfd >= 0)
-			close(dfd);
+		close_fd(&dfd);
 	}
-	if (dfd >= 0 && !keep_fd)
-		close(dfd);
+	if (!keep_fd)
+		close_fd(&dfd);
 	return err;
 
 }
@@ -5707,7 +5706,7 @@ static int drive_validate_sector_size(struct intel_super *super, struct dl *dl)
 {
 	unsigned int member_sector_size;
 
-	if (dl->fd < 0) {
+	if (!is_fd_valid(dl->fd)) {
 		pr_err("Invalid file descriptor for %s\n", dl->devname);
 		return 0;
 	}
@@ -5739,7 +5738,7 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 		return 1;
 	}
 
-	if (fd == -1) {
+	if (!is_fd_valid(fd)) {
 		/* we're doing autolayout so grab the pre-marked (in
 		 * validate_geometry) raid_disk
 		 */
@@ -6115,10 +6114,8 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 		if (write_super_imsm_spare(super, d))
 			return 1;
 
-		if (doclose) {
-			close(d->fd);
-			d->fd = -1;
-		}
+		if (doclose)
+			close_fd(&d->fd);
 	}
 
 	return 0;
@@ -6232,10 +6229,8 @@ static int write_super_imsm(struct supertype *st, int doclose)
 				d->major, d->minor,
 				d->fd, strerror(errno));
 
-		if (doclose) {
-			close(d->fd);
-			d->fd = -1;
-		}
+		if (doclose)
+			close_fd(&d->fd);
 	}
 
 	if (spares)
@@ -6666,10 +6661,8 @@ static int validate_geometry_imsm_container(struct supertype *st, int level,
 		return 1;
 
 	fd = dev_open(dev, O_RDONLY|O_EXCL);
-	if (fd < 0) {
-		if (verbose > 0)
-			pr_err("imsm: Cannot open %s: %s\n",
-				dev, strerror(errno));
+	if (!is_fd_valid(fd)) {
+		pr_vrb("imsm: Cannot open %s: %s\n", dev, strerror(errno));
 		return 0;
 	}
 	if (!get_dev_size(fd, dev, &ldsize))
@@ -6878,12 +6871,12 @@ active_arrays_by_format(char *name, char* hba, struct md_list **devlist,
 		    memb->members) {
 			struct dev_member *dev = memb->members;
 			int fd = -1;
-			while(dev && (fd < 0)) {
+			while (dev && !is_fd_valid(fd)) {
 				char *path = xmalloc(strlen(dev->name) + strlen("/dev/") + 1);
 				num = sprintf(path, "%s%s", "/dev/", dev->name);
 				if (num > 0)
 					fd = open(path, O_RDONLY, 0);
-				if (num <= 0 || fd < 0) {
+				if (num <= 0 || !is_fd_valid(fd)) {
 					pr_vrb("Cannot open %s: %s\n",
 					       dev->name, strerror(errno));
 				}
@@ -6891,7 +6884,7 @@ active_arrays_by_format(char *name, char* hba, struct md_list **devlist,
 				dev = dev->next;
 			}
 			found = 0;
-			if (fd >= 0 && disk_attached_to_hba(fd, hba)) {
+			if (is_fd_valid(fd) && disk_attached_to_hba(fd, hba)) {
 				struct mdstat_ent *vol;
 				for (vol = mdstat ; vol ; vol = vol->next) {
 					if (vol->active > 0 &&
@@ -6911,8 +6904,7 @@ active_arrays_by_format(char *name, char* hba, struct md_list **devlist,
 					*devlist = dv;
 				}
 			}
-			if (fd >= 0)
-				close(fd);
+			close_fd(&fd);
 		}
 	}
 	free_mdstat(mdstat);
@@ -6973,7 +6965,7 @@ get_devices(const char *hba_path)
 		free(path);
 		path = NULL;
 		fd = dev_open(ent->d_name, O_RDONLY);
-		if (fd >= 0) {
+		if (is_fd_valid(fd)) {
 			fd2devname(fd, buf);
 			close(fd);
 		} else {
@@ -7032,7 +7024,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 		}
 		tmpdev->container = 0;
 		dfd = dev_open(devname, O_RDONLY|O_EXCL);
-		if (dfd < 0) {
+		if (!is_fd_valid(dfd)) {
 			dprintf("cannot open device %s: %s\n",
 				devname, strerror(errno));
 			tmpdev->used = 2;
@@ -7069,8 +7061,8 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 				tmpdev->used = 2;
 			}
 		}
-		if (dfd >= 0)
-			close(dfd);
+		close_fd(&dfd);
+
 		if (tmpdev->used == 2 || tmpdev->used == 4) {
 			/* Ignore unrecognised devices during auto-assembly */
 			goto loop;
@@ -7643,26 +7635,27 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 
 	/* This device needs to be a device in an 'imsm' container */
 	fd = open(dev, O_RDONLY|O_EXCL, 0);
-	if (fd >= 0) {
-		if (verbose)
-			pr_err("Cannot create this array on device %s\n",
-			       dev);
+
+	if (is_fd_valid(fd)) {
+		pr_vrb("Cannot create this array on device %s\n", dev);
 		close(fd);
 		return 0;
 	}
-	if (errno != EBUSY || (fd = open(dev, O_RDONLY, 0)) < 0) {
-		if (verbose)
-			pr_err("Cannot open %s: %s\n",
-				dev, strerror(errno));
-		return 0;
+	if (errno != EBUSY) {
+		fd = open(dev, O_RDONLY, 0);
+
+		if (!is_fd_valid(fd)) {
+			pr_vrb("Cannot open %s: %s\n", dev, strerror(errno));
+			return 0;
+		}
 	}
+
 	/* Well, it is in use by someone, maybe an 'imsm' container. */
 	cfd = open_container(fd);
-	close(fd);
-	if (cfd < 0) {
-		if (verbose)
-			pr_err("Cannot use %s: It is busy\n",
-				dev);
+	close_fd(&fd);
+
+	if (!is_fd_valid(cfd)) {
+		pr_vrb("Cannot use %s: It is busy\n", dev);
 		return 0;
 	}
 	sra = sysfs_read(cfd, NULL, GET_VERSION);
@@ -8937,7 +8930,7 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 	for (dl = super->disks; dl; dl = dl->next) {
 		/* If in this array, skip */
 		for (d = a->info.devs ; d ; d = d->next)
-			if (d->state_fd >= 0 &&
+			if (is_fd_valid(d->state_fd) &&
 			    d->disk.major == dl->major &&
 			    d->disk.minor == dl->minor) {
 				dprintf("%x:%x already in array\n",
@@ -9097,13 +9090,15 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	int i;
 	int allowed;
 
-	for (d = a->info.devs ; d ; d = d->next) {
-		if ((d->curr_state & DS_FAULTY) &&
-			d->state_fd >= 0)
+	for (d = a->info.devs ; d; d = d->next) {
+		if (!is_fd_valid(d->state_fd))
+			continue;
+
+		if (d->curr_state & DS_FAULTY)
 			/* wait for Removal to happen */
 			return NULL;
-		if (d->state_fd >= 0)
-			failed--;
+
+		failed--;
 	}
 
 	dprintf("imsm: activate spare: inst=%d failed=%d (%d) level=%d\n",
@@ -9159,7 +9154,7 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 			if (d->disk.raid_disk == i)
 				break;
 		dprintf("found %d: %p %x\n", i, d, d?d->curr_state:0);
-		if (d && (d->state_fd >= 0))
+		if (d && is_fd_valid(d->state_fd))
 			continue;
 
 		/*
@@ -10893,26 +10888,22 @@ int save_backup_imsm(struct supertype *st,
 {
 	int rv = -1;
 	struct intel_super *super = st->sb;
-	unsigned long long *target_offsets;
-	int *targets;
 	int i;
 	struct imsm_map *map_dest = get_imsm_map(dev, MAP_0);
 	int new_disks = map_dest->num_members;
 	int dest_layout = 0;
-	int dest_chunk;
-	unsigned long long start;
+	int dest_chunk, targets[new_disks];
+	unsigned long long start, target_offsets[new_disks];
 	int data_disks = imsm_num_data_members(map_dest);
 
-	targets = xmalloc(new_disks * sizeof(int));
-
 	for (i = 0; i < new_disks; i++) {
 		struct dl *dl_disk = get_imsm_dl_disk(super, i);
-
-		targets[i] = dl_disk->fd;
+		if (dl_disk && is_fd_valid(dl_disk->fd))
+			targets[i] = dl_disk->fd;
+		else
+			goto abort;
 	}
 
-	target_offsets = xcalloc(new_disks, sizeof(unsigned long long));
-
 	start = info->reshape_progress * 512;
 	for (i = 0; i < new_disks; i++) {
 		target_offsets[i] = migr_chkp_area_pba(super->migr_rec) * 512;
@@ -10944,11 +10935,6 @@ int save_backup_imsm(struct supertype *st,
 	rv = 0;
 
 abort:
-	if (targets) {
-		free(targets);
-	}
-	free(target_offsets);
-
 	return rv;
 }
 
@@ -11068,7 +11054,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 		if (dl_disk->index < 0)
 			continue;
 
-		if (dl_disk->fd < 0) {
+		if (!is_fd_valid(dl_disk->fd)) {
 			skipped_disks++;
 			continue;
 		}
@@ -11992,7 +11978,7 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 	unsigned long long to_complete = sra->reshape_progress;
 	unsigned long long position_to_set = to_complete / ndata;
 
-	if (fd < 0) {
+	if (!is_fd_valid(fd)) {
 		dprintf("cannot open reshape_position\n");
 		return 1;
 	}
@@ -12079,6 +12065,7 @@ int check_degradation_change(struct mdinfo *info,
 				continue;
 			if (sd->disk.state & (1<<MD_DISK_SYNC)) {
 				char sbuf[100];
+				int raid_disk = sd->disk.raid_disk;
 
 				if (sysfs_get_str(info,
 					sd, "state", sbuf, sizeof(sbuf)) < 0 ||
@@ -12086,13 +12073,8 @@ int check_degradation_change(struct mdinfo *info,
 					strstr(sbuf, "in_sync") == NULL) {
 					/* this device is dead */
 					sd->disk.state = (1<<MD_DISK_FAULTY);
-					if (sd->disk.raid_disk >= 0 &&
-					    sources[sd->disk.raid_disk] >= 0) {
-						close(sources[
-							sd->disk.raid_disk]);
-						sources[sd->disk.raid_disk] =
-							-1;
-					}
+					if (raid_disk >= 0)
+						close_fd(&sources[raid_disk]);
 					new_degraded++;
 				}
 			}
@@ -12483,9 +12465,10 @@ static int validate_internal_bitmap_for_drive(struct supertype *st,
 		return -1;
 
 	fd = d->fd;
-	if (fd < 0) {
+	if (!is_fd_valid(fd)) {
 		fd = open(d->devname, O_RDONLY, 0);
-		if (fd < 0) {
+
+		if (!is_fd_valid(fd)) {
 			dprintf("cannot open the device %s\n", d->devname);
 			goto abort;
 		}
@@ -12509,8 +12492,9 @@ static int validate_internal_bitmap_for_drive(struct supertype *st,
 
 	ret = 0;
 abort:
-	if ((d->fd < 0) && (fd >= 0))
-		close(fd);
+	if (!is_fd_valid(d->fd))
+		close_fd(&fd);
+
 	if (read_buf)
 		free(read_buf);
 
-- 
2.26.2

