From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 3/5] imsm: validate the number of imsm volumes per controller
Date: Fri, 13 Jan 2012 11:20:16 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D4075DD9@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "neilb@suse.de" <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Subject: [PATCH 3/5] imsm: validate the number of imsm volumes per controller

IMSM OROM limits number of volumes per controller. Volumes
above the limit are blocked in OROM. mdadm should follow OROM limitations
in this area. Therefore we need to count number of volumes on the devices
attached to SATA (ahci driver) or SAS (isci) controller.  Adding a new volume
must be blocked if the number of volumes on devices attached to the given
controller is exceeded.      

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |  408 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 401 insertions(+), 7 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0d68002..9b62f8a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4123,12 +4121,12 @@ get_devlist_super_block(struct md_list *devlist, struct intel_super **super_list
 	struct md_list *tmpdev;
 	int err = 0;
 	int i = 0;
-	int lmax = 0;
 
 	for (i = 0, tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
 		if (tmpdev->used != 1)
 			continue;
 		if (tmpdev->container == 1) {
+		  	int lmax = 0;
 			int fd = dev_open(tmpdev->devname, O_RDONLY|O_EXCL);
 			if (fd < 0) {
 				fprintf(stderr, Name ": cannot open device %s: %s\n",
@@ -5364,6 +5362,379 @@ static int is_raid_level_supported(const struct imsm_orom *orom, int level, int
 	return 0;
 }
 
+
+static int 
+active_arrays_by_format(char *name, char* hba, struct md_list **devlist,
+			int dpa, int verbose)
+{
+	struct mdstat_ent *mdstat = mdstat_read(0, 0);
+	struct mdstat_ent *memb = NULL;
+	int count = 0;
+	int num = 0;
+	struct md_list *dv = NULL;
+	int found;
+
+	for (memb = mdstat ; memb ; memb = memb->next) {
+		if (memb->metadata_version &&
+		    (strncmp(memb->metadata_version, "external:", 9) == 0)  &&
+		    (strcmp(&memb->metadata_version[9], name) == 0) &&
+		    !is_subarray(memb->metadata_version+9) &&
+		    memb->members) {
+			struct dev_member *dev = memb->members;
+			int fd = -1;
+			while(dev && (fd < 0)) {
+				char *path = malloc(strlen(dev->name) + strlen("/dev/") + 1);
+				if (path) {
+					num = sprintf(path, "%s%s", "/dev/", dev->name);
+					if (num > 0)
+						fd = open(path, O_RDONLY, 0);
+					if ((num <= 0) || (fd < 0)) {
+						pr_vrb(": Cannot open %s: %s\n",
+						       dev->name, strerror(errno));
+					}
+					free(path);
+				}
+				dev = dev->next;
+			}
+			found = 0;
+			if ((fd >= 0) && disk_attached_to_hba(fd, hba)) {
+				struct mdstat_ent *vol;
+				for (vol = mdstat ; vol ; vol = vol->next) {
+					if ((vol->active > 0) &&
+					    vol->metadata_version &&
+					    is_container_member(vol, memb->dev)) {
+						found++;
+						count++;
+					}
+				}
+				if (*devlist && (found < dpa)) {
+				  dv = calloc(1, sizeof(*dv));
+					if (dv == NULL)
+						fprintf(stderr, Name ": calloc failed\n");
+					else {
+						dv->devname = malloc(strlen(memb->dev) + strlen("/dev/") + 1);
+						if (dv->devname != NULL) {
+							sprintf(dv->devname, "%s%s", "/dev/", memb->dev);
+							dv->found = found;
+							dv->used = 0;
+							dv->next = *devlist;
+							*devlist = dv;
+						} else
+							free(dv);
+					}
+				}
+			}
+			if (fd >= 0)
+				close(fd);
+		}
+	}
+	free_mdstat(mdstat);
+	return count;
+}
+
+#ifdef DEBUG_LOOP
+static struct md_list*
+get_loop_devices(void)
+{
+	int i;
+	struct md_list *devlist = NULL;
+	struct md_list *dv = NULL;
+	
+	for(i = 0; i < 12; i++) {
+		dv = calloc(1, sizeof(*dv));
+		if (dv == NULL) {
+			fprintf(stderr, Name ": calloc failed\n");
+			break;
+		}
+		dv->devname = malloc(40);
+		if (dv->devname == NULL) {
+			fprintf(stderr, Name ": malloc failed\n");
+			free(dv);
+			break;
+		}
+		sprintf(dv->devname, "/dev/loop%d", i);
+		dv->next = devlist;
+		devlist = dv;
+	}
+	return devlist;
+}
+#endif
+
+static struct md_list*
+get_devices(const char *hba_path)
+{
+	struct md_list *devlist = NULL;
+	struct md_list *dv = NULL;
+	struct dirent *ent;
+	DIR *dir;
+	int err = 0;
+
+#if DEBUG_LOOP
+	devlist = get_loop_devices();
+	return devlist;
+#endif
+	/* scroll through /sys/dev/block looking for devices attached to
+	 * this hba
+	 */
+	dir = opendir("/sys/dev/block");
+	for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
+		int fd;
+		char buf[1024];
+		int major, minor;
+		char *path = NULL;
+		if (sscanf(ent->d_name, "%d:%d", &major, &minor) != 2)
+			continue;
+		path = devt_to_devpath(makedev(major, minor));
+		if (!path)
+			continue;
+		if (!path_attached_to_hba(path, hba_path)) {
+			free(path);
+			path = NULL;
+			continue;
+		}
+		free(path);
+		path = NULL;
+		fd = dev_open(ent->d_name, O_RDONLY);
+		if (fd >= 0) {
+			fd2devname(fd, buf);
+			close(fd);
+		} else {
+			fprintf(stderr, Name ": cannot open device: %s\n",
+				ent->d_name);
+			continue;
+		}
+
+
+		dv = calloc(1, sizeof(*dv));
+		if (dv == NULL) {
+			fprintf(stderr, Name ": malloc failed\n");
+			err = 1;
+			break;
+		}
+		dv->devname = strdup(buf);
+		if (dv->devname == NULL) {
+			fprintf(stderr, Name ": malloc failed\n");
+			err = 1;
+			free(dv);
+			break;
+		}
+		dv->next = devlist;
+		devlist = dv;
+	}
+	if (err) {
+		while(devlist) {
+			dv = devlist;
+			devlist = devlist->next;
+			free(dv->devname);
+			free(dv);
+		}
+	}
+	return devlist;
+}
+
+
+
+static int 
+count_volumes_list(struct md_list *devlist, char *homehost,
+		   int verbose, int *found)
+{
+	struct md_list *tmpdev;
+	int count = 0;
+	struct supertype *st = NULL;
+		
+	/* first walk the list of devices to find a consistent set
+	 * that match the criterea, if that is possible.
+	 * We flag the ones we like with 'used'.
+	 */
+	*found = 0;
+	st = match_metadata_desc_imsm("imsm");
+	if (st == NULL) {
+		pr_vrb(": cannot allocate memory for imsm supertype\n");
+		return 0;
+	}
+
+	for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
+		char *devname = tmpdev->devname;
+		struct stat stb;
+		struct supertype *tst;
+		int dfd;
+		if (tmpdev->used > 1)
+			continue;
+		tst = dup_super(st);
+		if (tst == NULL) {
+			pr_vrb(": cannot allocate memory for imsm supertype\n");
+			goto err_1;
+		}
+		tmpdev->container = 0;
+		dfd = dev_open(devname, O_RDONLY|O_EXCL);
+		if (dfd < 0) {
+			dprintf(": cannot open device %s: %s\n",
+				devname, strerror(errno));
+			tmpdev->used = 2;
+		} else if (fstat(dfd, &stb)< 0) {
+			/* Impossible! */
+			dprintf(": fstat failed for %s: %s\n",
+				devname, strerror(errno));
+			tmpdev->used = 2;
+		} else if ((stb.st_mode & S_IFMT) != S_IFBLK) {
+			dprintf(": %s is not a block device.\n",
+				devname);
+			tmpdev->used = 2;
+		} else if (must_be_container(dfd)) {
+			struct supertype *cst;
+			cst = super_by_fd(dfd, NULL);
+			if (cst == NULL) {
+				dprintf(": cannot recognize container type %s\n",
+					devname);
+				tmpdev->used = 2;
+			} else if (tst->ss != st->ss) {
+				dprintf(": non-imsm container - ignore it: %s\n",
+					devname);
+				tmpdev->used = 2;
+			} else if (!tst->ss->load_container ||
+				   tst->ss->load_container(tst, dfd, NULL))
+				tmpdev->used = 2;
+			else {
+				tmpdev->container = 1;
+			}
+			if (cst)
+				cst->ss->free_super(cst);
+		} else {
+			tmpdev->st_rdev = stb.st_rdev;
+			if (tst->ss->load_super(tst,dfd, NULL)) {
+				dprintf(": no RAID superblock on %s\n",
+					devname);
+				tmpdev->used = 2;
+			} else if (tst->ss->compare_super == NULL) {
+				dprintf(": Cannot assemble %s metadata on %s\n",
+					tst->ss->name, devname);
+				tmpdev->used = 2;
+			}
+		}
+		if (dfd >= 0)
+			close(dfd);
+		if (tmpdev->used == 2 || tmpdev->used == 4) {
+			/* Ignore unrecognised devices during auto-assembly */
+			goto loop;
+		}
+		else {
+			struct mdinfo info;
+			tst->ss->getinfo_super(tst, &info, NULL);
+
+			if (st->minor_version == -1)
+				st->minor_version = tst->minor_version;
+
+			if (memcmp(info.uuid, uuid_zero,
+				   sizeof(int[4])) == 0) {
+				/* this is a floating spare.  It cannot define
+				 * an array unless there are no more arrays of
+				 * this type to be found.  It can be included
+				 * in an array of this type though.
+				 */
+				tmpdev->used = 3;
+				goto loop;
+			}
+
+			if (st->ss != tst->ss ||
+			    st->minor_version != tst->minor_version ||
+			    st->ss->compare_super(st, tst) != 0) {
+				/* Some mismatch. If exactly one array matches this host,
+				 * we can resolve on that one.
+				 * Or, if we are auto assembling, we just ignore the second
+				 * for now.
+				 */
+				dprintf(": superblock on %s doesn't match others - assembly aborted\n",
+					devname);
+				goto loop;
+			}
+			tmpdev->used = 1;
+			*found = 1;
+			dprintf("found: devname: %s\n", devname);
+		}
+	loop:
+		if (tst)
+			tst->ss->free_super(tst);
+	}
+	if (*found != 0) {
+		int err;
+		if ((err = load_super_imsm_all(st, -1, &st->sb, NULL, devlist, 0)) == 0) {
+			struct mdinfo *iter, *head = st->ss->container_content(st, NULL);
+			for (iter = head; iter; iter = iter->next) {
+				dprintf("content->text_version: %s vol\n",
+					iter->text_version);
+				if (iter->array.state & (1<<MD_SB_BLOCK_VOLUME)) {
+					/* do not assemble arrays with unsupported
+					   configurations */
+					dprintf(": Cannot activate member %s.\n",
+						iter->text_version);
+				} else
+					count++;
+			}
+			sysfs_free(head);
+			
+		} else {
+			dprintf(" no valid super block on device list: err: %d %p\n",
+				err, st->sb);
+		}
+	} else {
+		dprintf(" no more devices to examin\n");
+	}
+		
+	for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
+		if ((tmpdev->used == 1) && (tmpdev->found)) {
+			if (count) {
+				if (count < tmpdev->found)
+					count = 0;
+				else
+					count -= tmpdev->found;
+			}
+		}
+		if (tmpdev->used == 1)
+			tmpdev->used = 4;
+	}
+	err_1:
+	if (st)
+		st->ss->free_super(st);
+	return count;
+}
+
+
+static int
+count_volumes(char *hba, int dpa, int verbose)
+{
+	struct md_list *devlist = NULL;
+	int count = 0;
+	int found = 0;;
+
+	devlist = get_devices(hba);
+	/* if no intel devices return zero volumes */
+	if (devlist == NULL)
+		return 0;
+	  
+	count = active_arrays_by_format("imsm", hba, &devlist, dpa, verbose);
+	dprintf(" path: %s active arrays: %d\n", hba, count);
+	if (devlist == NULL)
+		return 0;
+	do  {
+		found = 0;
+		count += count_volumes_list(devlist,
+					    NULL,
+					    verbose,
+					    &found);
+		dprintf("found %d count: %d\n", found, count);
+	} while (found);
+	
+	dprintf("path: %s total number of volumes: %d\n", hba, count);
+	
+	while(devlist) {
+		struct md_list *dv = devlist;
+		devlist = devlist->next;
+		free(dv->devname);
+		free(dv);
+	}
+	return count;
+}
+
 static int imsm_default_chunk(const struct imsm_orom *orom)
 {
 	/* up to 512 if the plaform supports it, otherwise the platform max.
@@ -5583,7 +5954,16 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 	}
 
 	*freesize = maxsize;
-
+	
+	if (super->orom) {
+		int count = count_volumes(super->hba->path,
+				      super->orom->dpa, verbose);
+		if (super->orom->vphba <= count) {
+			pr_vrb(": platform does not support more then %d raid volumes.\n",
+			       super->orom->vphba);
+			return 0;
+		}
+	}
 	return 1;
 }
 
@@ -5692,6 +6072,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	
 	if (!dev) {
 		if (st->sb) {
+			struct intel_super *super = st->sb;
 			if (!validate_geometry_imsm_orom(st->sb, level, layout,
 							 raiddisks, chunk,
 							 verbose))
@@ -5704,6 +6085,19 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 			 * created.  add_to_super and getinfo_super
 			 * detect when autolayout is in progress.
 			 */
+			/* assuming that freesize is always given when array is
+			   created */
+			if (super->orom && freesize) {
+				int count;
+				count = count_volumes(super->hba->path,
+						      super->orom->dpa, verbose);
+				if (super->orom->vphba <= count) {
+					pr_vrb(": platform does not support more"
+					       "then %d raid volumes.\n",
+					       super->orom->vphba);
+					return 0;
+				}
+			}
 			if (freesize)
 				return reserve_space(st, raiddisks, size,
 						     chunk?*chunk:0, freesize);
-- 
1.7.1

