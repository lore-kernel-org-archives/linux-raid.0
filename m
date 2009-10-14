From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 03/12] imsm: disambiguate family_num
Date: Tue, 13 Oct 2009 19:10:31 -0700
Message-ID: <20091014021031.31570.44475.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

This is a result of trawling through the Windows implementation to learn
the mechanism of how it disambiguates family_num.  It is a continuation
of commit 148acb7b "imsm: fix family number handling" which introduced a
regression when reassembling a container with stale disks and rebuilt
members.

When rebuilding, a new family number is assigned to protect against the
"prodigal array member" problem.  It prevents a former family member
from returning to the system and causing a rebuild to go the wrong
direction.  However, this invalidates looking at the generation number to
determine the most up-to-date disk when comparing across family numbers.
Instead the assembly logic looks for agreement between a disk's local
family membership compared against a global list of all families in the
system.  Whenever a disk's local metadata does not match a family number
on the global list that family number is marked offline.

It is possible that this logic results in multiple incompatible but
valid family numbers existing in a container.  In this case mdadm.conf
cannot be consulted because it only records the uuid which is generated
from static fields in the metadata.  The metadata lacks the data needed
to disambiguate "local" versus "foreign".  The "foreign" array in this
case requires updating to change its container-id information
(orig_family_num), and possibly the member array names.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |  580 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 448 insertions(+), 132 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 80cd6c5..e53afbb 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -265,6 +265,14 @@ struct intel_super {
 	struct bbm_log *bbm_log;
 	const char *hba; /* device path of the raid controller for this metadata */
 	const struct imsm_orom *orom; /* platform firmware support */
+	struct intel_super *next; /* (temp) list for disambiguating family_num */
+};
+
+struct intel_disk {
+	struct imsm_disk disk;
+	#define IMSM_UNKNOWN_OWNER (-1)
+	int owner;
+	struct intel_disk *next;
 };
 
 struct extent {
@@ -1477,8 +1485,19 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 	 */
 	if (first->anchor->num_raid_devs > 0 &&
 	    sec->anchor->num_raid_devs > 0) {
-		if (first->anchor->orig_family_num != sec->anchor->orig_family_num ||
-		    first->anchor->family_num != sec->anchor->family_num)
+		/* Determine if these disks might ever have been
+		 * related.  Further disambiguation can only take place
+		 * in load_super_imsm_all
+		 */
+		__u32 first_family = first->anchor->orig_family_num;
+		__u32 sec_family = sec->anchor->orig_family_num;
+
+		if (first_family == 0)
+			first_family = first->anchor->family_num;
+		if (sec_family == 0)
+			sec_family = sec->anchor->family_num;
+
+		if (first_family != sec_family)
 			return 3;
 	}
 
@@ -1548,7 +1567,6 @@ static void fd2devname(int fd, char *name)
 	snprintf(name, MAX_RAID_SERIAL_LEN, "/dev/%s", nm);
 }
 
-
 extern int scsi_get_serial(int fd, void *buf, size_t buf_len);
 
 static int imsm_read_serial(int fd, char *devname,
@@ -1642,14 +1660,32 @@ static struct dl *serial_to_dl(__u8 *serial, struct intel_super *super)
 	return dl;
 }
 
+static struct imsm_disk *
+__serial_to_disk(__u8 *serial, struct imsm_super *mpb, int *idx)
+{
+	int i;
+
+	for (i = 0; i < mpb->num_disks; i++) {
+		struct imsm_disk *disk = __get_imsm_disk(mpb, i);
+
+		if (serialcmp(disk->serial, serial) == 0) {
+			if (idx)
+				*idx = i;
+			return disk;
+		}
+	}
+
+	return NULL;
+}
+
 static int
 load_imsm_disk(int fd, struct intel_super *super, char *devname, int keep_fd)
 {
+	struct imsm_disk *disk;
 	struct dl *dl;
 	struct stat stb;
 	int rv;
-	int i;
-	int alloc = 1;
+	char name[40];
 	__u8 serial[MAX_RAID_SERIAL_LEN];
 
 	rv = imsm_read_serial(fd, devname, serial);
@@ -1657,16 +1693,7 @@ load_imsm_disk(int fd, struct intel_super *super, char *devname, int keep_fd)
 	if (rv != 0)
 		return 2;
 
-	/* check if this is a disk we have seen before.  it may be a spare in
-	 * super->disks while the current anchor believes it is a raid member,
-	 * check if we need to update dl->index
-	 */
-	dl = serial_to_dl(serial, super);
-	if (!dl)
-		dl = malloc(sizeof(*dl));
-	else
-		alloc = 0;
-
+	dl = calloc(1, sizeof(*dl));
 	if (!dl) {
 		if (devname)
 			fprintf(stderr,
@@ -1675,51 +1702,35 @@ load_imsm_disk(int fd, struct intel_super *super, char *devname, int keep_fd)
 		return 2;
 	}
 
-	if (alloc) {
-		fstat(fd, &stb);
-		dl->major = major(stb.st_rdev);
-		dl->minor = minor(stb.st_rdev);
-		dl->next = super->disks;
-		dl->fd = keep_fd ? fd : -1;
-		dl->devname = devname ? strdup(devname) : NULL;
-		serialcpy(dl->serial, serial);
-		dl->index = -2;
-		dl->e = NULL;
-	} else if (keep_fd)
-		dl->fd = fd;
+	fstat(fd, &stb);
+	dl->major = major(stb.st_rdev);
+	dl->minor = minor(stb.st_rdev);
+	dl->next = super->disks;
+	dl->fd = keep_fd ? fd : -1;
+	assert(super->disks == NULL);
+	super->disks = dl;
+	serialcpy(dl->serial, serial);
+	dl->index = -2;
+	dl->e = NULL;
+	fd2devname(fd, name);
+	if (devname)
+		dl->devname = strdup(devname);
+	else
+		dl->devname = strdup(name);
 
 	/* look up this disk's index in the current anchor */
-	for (i = 0; i < super->anchor->num_disks; i++) {
-		struct imsm_disk *disk_iter;
-
-		disk_iter = __get_imsm_disk(super->anchor, i);
-
-		if (serialcmp(disk_iter->serial, dl->serial) == 0) {
-			dl->disk = *disk_iter;
-			/* only set index on disks that are a member of a
-			 * populated contianer, i.e. one with raid_devs
-			 */
-			if (dl->disk.status & FAILED_DISK)
-				dl->index = -2;
-			else if (dl->disk.status & SPARE_DISK)
-				dl->index = -1;
-			else
-				dl->index = i;
-
-			break;
-		}
-	}
-
-	/* no match, maybe a stale failed drive */
-	if (i == super->anchor->num_disks && dl->index >= 0) {
-		dl->disk = *__get_imsm_disk(super->anchor, dl->index);
-		if (dl->disk.status & FAILED_DISK)
+	disk = __serial_to_disk(dl->serial, super->anchor, &dl->index);
+	if (disk) {
+		dl->disk = *disk;
+		/* only set index on disks that are a member of a
+		 * populated contianer, i.e. one with raid_devs
+		 */
+		if (is_failed(&dl->disk))
 			dl->index = -2;
+		else if (is_spare(&dl->disk))
+			dl->index = -1;
 	}
 
-	if (alloc)
-		super->disks = dl;
-
 	return 0;
 }
 
@@ -1861,7 +1872,6 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	struct stat;
 	struct imsm_super *anchor;
 	__u32 check_sum;
-	int rc;
 
 	get_dev_size(fd, NULL, &dsize);
 
@@ -1923,10 +1933,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 			return 2;
 		}
 
-		rc = load_imsm_disk(fd, super, devname, 0);
-		if (rc == 0)
-			rc = parse_raid_devices(super);
-		return rc;
+		return 0;
 	}
 
 	/* read the extended mpb */
@@ -1962,11 +1969,23 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	 */
 	super->bbm_log = __get_imsm_bbm_log(super->anchor);
 
-	rc = load_imsm_disk(fd, super, devname, 0);
-	if (rc == 0)
-		rc = parse_raid_devices(super);
+	return 0;
+}
+
+static int
+load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd)
+{
+	int err;
+
+	err = load_imsm_mpb(fd, super, devname);
+	if (err)
+		return err;
+	err = load_imsm_disk(fd, super, devname, keep_fd);
+	if (err)
+		return err;
+	err = parse_raid_devices(super);
 
-	return rc;
+	return err;
 }
 
 static void __free_imsm_disk(struct dl *d)
@@ -2096,19 +2115,333 @@ static int find_missing(struct intel_super *super)
 	return 0;
 }
 
+static struct intel_disk *disk_list_get(__u8 *serial, struct intel_disk *disk_list)
+{
+	struct intel_disk *idisk = disk_list;
+
+	while (idisk) {
+		if (serialcmp(idisk->disk.serial, serial) == 0)
+			break;
+		idisk = idisk->next;
+	}
+
+	return idisk;
+}
+
+static int __prep_thunderdome(struct intel_super **table, int tbl_size,
+			      struct intel_super *super,
+			      struct intel_disk **disk_list)
+{
+	struct imsm_disk *d = &super->disks->disk;
+	struct imsm_super *mpb = super->anchor;
+	int i, j;
+
+	for (i = 0; i < tbl_size; i++) {
+		struct imsm_super *tbl_mpb = table[i]->anchor;
+		struct imsm_disk *tbl_d = &table[i]->disks->disk;
+
+		if (tbl_mpb->family_num == mpb->family_num) {
+			if (tbl_mpb->check_sum == mpb->check_sum) {
+				dprintf("%s: mpb from %d:%d matches %d:%d\n",
+					__func__, super->disks->major,
+					super->disks->minor,
+					table[i]->disks->major,
+					table[i]->disks->minor);
+				break;
+			}
+
+			if (((is_configured(d) && !is_configured(tbl_d)) ||
+			     is_configured(d) == is_configured(tbl_d)) &&
+			    tbl_mpb->generation_num < mpb->generation_num) {
+				/* current version of the mpb is a
+				 * better candidate than the one in
+				 * super_table, but copy over "cross
+				 * generational" status
+				 */
+				struct intel_disk *idisk;
+
+				dprintf("%s: mpb from %d:%d replaces %d:%d\n",
+					__func__, super->disks->major,
+					super->disks->minor,
+					table[i]->disks->major,
+					table[i]->disks->minor);
+
+				idisk = disk_list_get(tbl_d->serial, *disk_list);
+				if (idisk && is_failed(&idisk->disk))
+					tbl_d->status |= FAILED_DISK;
+				break;
+			} else {
+				struct intel_disk *idisk;
+				struct imsm_disk *disk;
+
+				/* tbl_mpb is more up to date, but copy
+				 * over cross generational status before
+				 * returning
+				 */
+				disk = __serial_to_disk(d->serial, mpb, NULL);
+				if (disk && is_failed(disk))
+					d->status |= FAILED_DISK;
+
+				idisk = disk_list_get(d->serial, *disk_list);
+				if (idisk) {
+					idisk->owner = i;
+					if (disk && is_configured(disk))
+						idisk->disk.status |= CONFIGURED_DISK;
+				}
+
+				dprintf("%s: mpb from %d:%d prefer %d:%d\n",
+					__func__, super->disks->major,
+					super->disks->minor,
+					table[i]->disks->major,
+					table[i]->disks->minor);
+
+				return tbl_size;
+			}
+		}
+	}
+
+	if (i >= tbl_size)
+		table[tbl_size++] = super;
+	else
+		table[i] = super;
+
+	/* update/extend the merged list of imsm_disk records */
+	for (j = 0; j < mpb->num_disks; j++) {
+		struct imsm_disk *disk = __get_imsm_disk(mpb, j);
+		struct intel_disk *idisk;
+
+		idisk = disk_list_get(disk->serial, *disk_list);
+		if (idisk) {
+			idisk->disk.status |= disk->status;
+			if (is_configured(&idisk->disk) ||
+			    is_failed(&idisk->disk))
+				idisk->disk.status &= ~(SPARE_DISK);
+		} else {
+			idisk = calloc(1, sizeof(*idisk));
+			if (!idisk)
+				return -1;
+			idisk->owner = IMSM_UNKNOWN_OWNER;
+			idisk->disk = *disk;
+			idisk->next = *disk_list;
+			*disk_list = idisk;
+		}
+
+		if (serialcmp(idisk->disk.serial, d->serial) == 0)
+			idisk->owner = i;
+	}
+
+	return tbl_size;
+}
+
+static struct intel_super *
+validate_members(struct intel_super *super, struct intel_disk *disk_list,
+		 const int owner)
+{
+	struct imsm_super *mpb = super->anchor;
+	int ok_count = 0;
+	int i;
+
+	for (i = 0; i < mpb->num_disks; i++) {
+		struct imsm_disk *disk = __get_imsm_disk(mpb, i);
+		struct intel_disk *idisk;
+
+		idisk = disk_list_get(disk->serial, disk_list);
+		if (idisk) {
+			if (idisk->owner == owner ||
+			    idisk->owner == IMSM_UNKNOWN_OWNER)
+				ok_count++;
+			else
+				dprintf("%s: '%.16s' owner %d != %d\n",
+					__func__, disk->serial, idisk->owner,
+					owner);
+		} else {
+			dprintf("%s: unknown disk %x [%d]: %.16s\n",
+				__func__, __le32_to_cpu(mpb->family_num), i,
+				disk->serial);
+			break;
+		}
+	}
+
+	if (ok_count == mpb->num_disks)
+		return super;
+	return NULL;
+}
+
+static void show_conflicts(__u32 family_num, struct intel_super *super_list)
+{
+	struct intel_super *s;
+
+	for (s = super_list; s; s = s->next) {
+		if (family_num != s->anchor->family_num)
+			continue;
+		fprintf(stderr, "Conflict, offlining family %#x on '%s'\n",
+			__le32_to_cpu(family_num), s->disks->devname);
+	}
+}
+
+static struct intel_super *
+imsm_thunderdome(struct intel_super **super_list, int len)
+{
+	struct intel_super *super_table[len];
+	struct intel_disk *disk_list = NULL;
+	struct intel_super *champion, *spare;
+	struct intel_super *s, **del;
+	int tbl_size = 0;
+	int conflict;
+	int i;
+
+	memset(super_table, 0, sizeof(super_table));
+	for (s = *super_list; s; s = s->next)
+		tbl_size = __prep_thunderdome(super_table, tbl_size, s, &disk_list);
+
+	for (i = 0; i < tbl_size; i++) {
+		struct imsm_disk *d;
+		struct intel_disk *idisk;
+		struct imsm_super *mpb = super_table[i]->anchor;
+
+		s = super_table[i];
+		d = &s->disks->disk;
+
+		/* 'd' must appear in merged disk list for its
+		 * configuration to be valid
+		 */
+		idisk = disk_list_get(d->serial, disk_list);
+		if (idisk && idisk->owner == i)
+			s = validate_members(s, disk_list, i);
+		else
+			s = NULL;
+
+		if (!s)
+			dprintf("%s: marking family: %#x from %d:%d offline\n",
+				__func__, mpb->family_num,
+				super_table[i]->disks->major,
+				super_table[i]->disks->minor);
+		super_table[i] = s;
+	}
+
+	/* This is where the mdadm implementation differs from the Windows
+	 * driver which has no strict concept of a container.  We can only
+	 * assemble one family from a container, so when returning a prodigal
+	 * array member to this system the code will not be able to disambiguate
+	 * the container contents that should be assembled ("foreign" versus
+	 * "local").  It requires user intervention to set the orig_family_num
+	 * to a new value to establish a new container.  The Windows driver in
+	 * this situation fixes up the volume name in place and manages the
+	 * foreign array as an independent entity.
+	 */
+	s = NULL;
+	spare = NULL;
+	conflict = 0;
+	for (i = 0; i < tbl_size; i++) {
+		struct intel_super *tbl_ent = super_table[i];
+		int is_spare = 0;
+
+		if (!tbl_ent)
+			continue;
+
+		if (tbl_ent->anchor->num_raid_devs == 0) {
+			spare = tbl_ent;
+			is_spare = 1;
+		}
+
+		if (s && !is_spare) {
+			show_conflicts(tbl_ent->anchor->family_num, *super_list);
+			conflict++;
+		} else if (!s && !is_spare)
+			s = tbl_ent;
+	}
+
+	if (!s)
+		s = spare;
+	if (!s) {
+		champion = NULL;
+		goto out;
+	}
+	champion = s;
+
+	if (conflict)
+		fprintf(stderr, "Chose family %#x on '%s', "
+			"assemble conflicts to new container with '--update=uuid'\n",
+			__le32_to_cpu(s->anchor->family_num), s->disks->devname);
+
+	/* collect all dl's onto 'champion', and update them to
+	 * champion's version of the status
+	 */
+	for (s = *super_list; s; s = s->next) {
+		struct imsm_super *mpb = champion->anchor;
+		struct dl *dl = s->disks;
+
+		if (s == champion)
+			continue;
+
+		for (i = 0; i < mpb->num_disks; i++) {
+			struct imsm_disk *disk;
+
+			disk = __serial_to_disk(dl->serial, mpb, &dl->index);
+			if (disk) {
+				dl->disk = *disk;
+				/* only set index on disks that are a member of
+				 * a populated contianer, i.e. one with
+				 * raid_devs
+				 */
+				if (is_failed(&dl->disk))
+					dl->index = -2;
+				else if (is_spare(&dl->disk))
+					dl->index = -1;
+				break;
+			}
+		}
+
+		if (i >= mpb->num_disks) {
+			struct intel_disk *idisk;
+
+			idisk = disk_list_get(dl->serial, disk_list);
+			if (is_spare(&idisk->disk) &&
+			    !is_failed(&idisk->disk) && !is_configured(&idisk->disk))
+				dl->index = -1;
+			else {
+				dl->index = -2;
+				continue;
+			}
+		}
+
+		dl->next = champion->disks;
+		champion->disks = dl;
+		s->disks = NULL;
+	}
+
+	/* delete 'champion' from super_list */
+	for (del = super_list; *del; ) {
+		if (*del == champion) {
+			*del = (*del)->next;
+			break;
+		} else
+			del = &(*del)->next;
+	}
+	champion->next = NULL;
+
+ out:
+	while (disk_list) {
+		struct intel_disk *idisk = disk_list;
+
+		disk_list = disk_list->next;
+		free(idisk);
+	}
+
+	return champion;
+}
+
 static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 			       char *devname, int keep_fd)
 {
 	struct mdinfo *sra;
-	struct intel_super *super;
-	struct mdinfo *sd, *best = NULL;
-	__u32 bestgen = 0;
-	__u32 gen;
-	char nm[20];
-	int dfd;
-	int rv;
+	struct intel_super *super_list = NULL;
+	struct intel_super *super = NULL;
 	int devnum = fd2devnum(fd);
+	struct mdinfo *sd;
 	int retry;
+	int err = 0;
+	int i;
 	enum sysfs_read_flags flags;
 
 	flags = GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE;
@@ -2125,81 +2458,51 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 	    strcmp(sra->text_version, "imsm") != 0)
 		return 1;
 
-	super = alloc_super(0);
-	if (!super)
-		return 1;
+	/* load all mpbs */
+	for (sd = sra->devs, i = 0; sd; sd = sd->next, i++) {
+		struct intel_super *s = alloc_super(0);
+		char nm[20];
+		int dfd;
+
+		err = 1;
+		if (!s)
+			goto error;
+		s->next = super_list;
+		super_list = s;
 
-	/* find the most up to date disk in this array, skipping spares */
-	for (sd = sra->devs; sd; sd = sd->next) {
+		err = 2;
 		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
 		dfd = dev_open(nm, keep_fd ? O_RDWR : O_RDONLY);
-		if (dfd < 0) {
-			free_imsm(super);
-			return 2;
-		}
-		rv = load_imsm_mpb(dfd, super, NULL);
+		if (dfd < 0)
+			goto error;
+
+		err = load_and_parse_mpb(dfd, s, NULL, keep_fd);
 
 		/* retry the load if we might have raced against mdmon */
-		if (rv == 3 && mdmon_running(devnum))
+		if (err == 3 && mdmon_running(devnum))
 			for (retry = 0; retry < 3; retry++) {
 				usleep(3000);
-				rv = load_imsm_mpb(dfd, super, NULL);
-				if (rv != 3)
+				err = load_and_parse_mpb(dfd, s, NULL, keep_fd);
+				if (err != 3)
 					break;
 			}
 		if (!keep_fd)
 			close(dfd);
-		if (rv == 0) {
-			if (super->anchor->num_raid_devs == 0)
-				gen = 0;
-			else
-				gen = __le32_to_cpu(super->anchor->generation_num);
-			if (!best || gen > bestgen) {
-				bestgen = gen;
-				best = sd;
-			}
-		} else {
-			free_imsm(super);
-			return rv;
-		}
-	}
-
-	if (!best) {
-		free_imsm(super);
-		return 1;
-	}
-
-	/* load the most up to date anchor */
-	sprintf(nm, "%d:%d", best->disk.major, best->disk.minor);
-	dfd = dev_open(nm, O_RDONLY);
-	if (dfd < 0) {
-		free_imsm(super);
-		return 1;
-	}
-	rv = load_imsm_mpb(dfd, super, NULL);
-	close(dfd);
-	if (rv != 0) {
-		free_imsm(super);
-		return 2;
+		if (err)
+			goto error;
 	}
 
-	/* re-parse the disk list with the current anchor */
-	for (sd = sra->devs ; sd ; sd = sd->next) {
-		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
-		dfd = dev_open(nm, keep_fd? O_RDWR : O_RDONLY);
-		if (dfd < 0) {
-			free_imsm(super);
-			return 2;
-		}
-		load_imsm_disk(dfd, super, NULL, keep_fd);
-		if (!keep_fd)
-			close(dfd);
+	/* all mpbs enter, maybe one leaves */
+	super = imsm_thunderdome(&super_list, i);
+	if (!super) {
+		err = 1;
+		goto error;
 	}
 
-
 	if (find_missing(super) != 0) {
 		free_imsm(super);
-		return 2;
+		err = 2;
+		goto error;
 	}
 
 	if (st->subarray[0]) {
@@ -2207,13 +2510,26 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 			super->current_vol = atoi(st->subarray);
 		else {
 			free_imsm(super);
-			return 1;
+			err = 1;
+			goto error;
 		}
 	}
+	err = 0;
+
+ error:
+	while (super_list) {
+		struct intel_super *s = super_list;
+
+		super_list = super_list->next;
+		free_imsm(s);
+	}
+
+	if (err)
+		return err;
 
 	*sbp = super;
 	st->container_dev = devnum;
-	if (st->ss == NULL) {
+	if (err == 0 && st->ss == NULL) {
 		st->ss = &super_imsm;
 		st->minor_version = 0;
 		st->max_devs = IMSM_MAX_DEVICES;
@@ -2244,7 +2560,7 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 		return 1;
 	}
 
-	rv = load_imsm_mpb(fd, super, devname);
+	rv = load_and_parse_mpb(fd, super, devname, 0);
 
 	if (rv) {
 		if (devname)

