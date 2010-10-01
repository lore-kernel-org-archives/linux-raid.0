From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [AUTOREBUILD 6/8] Monitor: autorebuild functionality added
Date: Fri, 1 Oct 2010 13:38:38 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D171D0995B@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From f45f97933fddce7d7fcf370e4a74e9281c7c0a38 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 28 Sep 2010 06:26:51 +0200
Subject: [AUTOREBUILD 6/8] Monitor: autorebuild functionality added

For each volume we check state, report any changes, note minimum size
of disks and link with parent container. After all information is updated
we call spare_sharing. spare_sharing searches suitable spares in other
arrays and moves them using move_spare to the arrays that need them.
move_spare removes spare from one array/container and adds to another.
If add fails we add back to original container. Manage_subdev function
is used to perform the spare relocation.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |  312 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 287 insertions(+), 25 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 93dd15d..62cbe98 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -30,6 +30,13 @@
 #include	<limits.h>
 #include	<syslog.h>
 
+/* define verbose mode for DEBUG compilation */
+#ifdef DEBUG
+#define VERBOSE 1
+#else
+#define VERBOSE (-1)
+#endif
+
 static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mailfrom,
 		  char *cmd, int dosyslog);
 
@@ -47,6 +54,7 @@ struct state {
 	int expected_spares;
 	int devstate[MaxDisks];
 	unsigned devid[MaxDisks];
+	unsigned long long min_size;
 	int percent;
 	char *metadata_version;
 	struct state *volumes;/* for a container it is a link its all volumes */
@@ -54,7 +62,8 @@ struct state {
 	struct state *next;
 };
 
-
+static void spare_sharing(struct state *statelist, char *mailaddr,
+			  char *mailfrom, char *alert_cmd, int dosyslog);
 
 static void add_to_cont(struct state *cont, struct state *vol)
 {
@@ -106,6 +115,10 @@ int Monitor(mddev_dev_t devlist,
 	 *    DeviceDisappeared
 	 *      Couldn't access a device which was previously visible
 	 *
+	 * If we detect an array with active<raid and spare==0
+	 * we look at other arrays that have a spare
+	 * and are in the same domain and subset
+	 * Then we hot-remove and hot-add to the other array
 	 *
 	 * If devlist is NULL, then we can monitor everything because --scan
 	 * was given.  We get an initial list from config file and add anything
@@ -113,6 +126,7 @@ int Monitor(mddev_dev_t devlist,
 	 */
 
 	int finished = 0;
+	int anydegraded;
 	struct mdstat_ent *mdstat = NULL;
 	char *mailfrom = NULL;
 	struct state *statelist = NULL;
@@ -222,6 +236,9 @@ int Monitor(mddev_dev_t devlist,
 			st->parent = NULL;
 			st->volumes = NULL;
 			st->total = 0;
+			st->min_size = 0;
+			memset(st->devid, 0, MaxDisks*sizeof(int));
+			memset(st->devstate, 0, MaxDisks*sizeof(int));
 			statelist = st;
 		}
 	} else {
@@ -242,6 +259,9 @@ int Monitor(mddev_dev_t devlist,
 			st->parent = NULL;
 			st->volumes = NULL;
 			st->total = 0;
+			st->min_size = 0;
+			memset(st->devid, 0, MaxDisks*sizeof(int));
+			memset(st->devstate, 0, MaxDisks*sizeof(int));
 			if (mdlist) {
 				st->expected_spares = mdlist->spare_disks;
 			}
@@ -254,6 +274,7 @@ int Monitor(mddev_dev_t devlist,
 		int new_found = 0;
 		struct state *st;
 
+		anydegraded = 0;
 		if (mdstat)
 			free_mdstat(mdstat);
 		mdstat = mdstat_read(oneshot?0:1, 0);
@@ -334,18 +355,17 @@ int Monitor(mddev_dev_t devlist,
 			 * metadata, so treat utime for external
 			 * metadata as different
 			 */
-			if ((st->utime == array.utime &&
-			   ((st->metadata_version == NULL) ||
-			     !is_external(st->metadata_version))) &&
+			if  (st->utime == array.utime &&
+			    (st->metadata_version &&
+			     !is_external(st->metadata_version)) &&
 			     st->failed == array.failed_disks &&
 			     st->working == array.working_disks &&
 			     st->spare == array.spare_disks &&
-			    (mse == NULL  || (mse->percent == st->percent))) {
-				close(fd);
+			    (mse->percent == st->percent)) {
 				st->err = 0;
+				close(fd);
 				continue;
 			}
-
 			if (st->utime == 0 && /* new array */
 			    mse->pattern && strchr(mse->pattern, '_') /* degraded */
 				)
@@ -409,6 +429,7 @@ int Monitor(mddev_dev_t devlist,
 				int newstate=0;
 				int change;
 				char *dv = NULL;
+				unsigned long long dsize;
 				disc.number = i;
 				if (i > array.raid_disks + array.nr_disks) {
 					newstate = 0;
@@ -453,6 +474,19 @@ int Monitor(mddev_dev_t devlist,
 				}
 				st->devstate[i] = newstate;
 				st->devid[i] = makedev(disc.major, disc.minor);
+
+				if (!share)
+					continue;
+				/* for volumes only we get minimum disk size
+				 * (only active disks) */
+				fd = open(dv, O_RDONLY);
+				if (dv && newstate & (1<<MD_DISK_ACTIVE) &&
+				    array.raid_disks && fd >= 0 &&
+				    get_dev_size(fd, dv, &dsize) &&
+				    (st->min_size == 0 || dsize < st->min_size))
+					st->min_size = dsize;
+				if (fd >= 0)
+					close(fd);
 			}
 			st->active = array.active_disks;
 			st->working = array.working_disks;
@@ -462,6 +496,8 @@ int Monitor(mddev_dev_t devlist,
 			st->raid = array.raid_disks;
 			st->total = array.raid_disks + array.nr_disks;
 			st->err = 0;
+			if ((st->active < st->raid) && st->spare == 0)
+				anydegraded = 1;
 			if (mse->metadata_version) {
 				if (!st->metadata_version)
 					st->metadata_version = strdup(mse->metadata_version);
@@ -515,27 +551,26 @@ int Monitor(mddev_dev_t devlist,
 					new_found = 1;
 				}
 		}
-
-		/* search the statelist to connect external
-		 * metadata volumes with their containers
-		 */
-		for (st = statelist; st; st = st->next) {
-			if (st->metadata_version &&
-			    is_external(st->metadata_version) &&
-			    is_subarray(st->metadata_version+9)) {
-				struct state *cont = NULL;
-
-				for (cont = statelist; cont; cont = cont->next) {
-					if (!cont->err &&
-					    cont->parent == NULL &&
-					    cont->metadata_version &&
-					    devname2devnum(st->metadata_version+10)
-					    == cont->devnum) {
-						add_to_cont(cont, st);
-						break;
+		if (share && anydegraded) {
+			/* parent-volume linking only needed when sharing spares */
+			for (st = statelist; st; st = st->next) {
+				if (!st->err &&
+				    st->metadata_version &&
+				    is_external(st->metadata_version) &&
+				    is_subarray(st->metadata_version+9)) {
+					struct state *cont = NULL;
+					for (cont = statelist; cont; cont = cont->next) {
+						if (!cont->err &&
+						cont->parent == NULL &&
+						cont->metadata_version &&
+						devname2devnum(st->metadata_version+10)	== cont->devnum) {
+							add_to_cont(cont, st);
+							break;
+						}
 					}
 				}
 			}
+			spare_sharing(statelist, mailaddr, mailfrom, alert_cmd, dosyslog);
 		}
 		if (!new_found) {
 			if (oneshot)
@@ -550,6 +585,233 @@ int Monitor(mddev_dev_t devlist,
 	return 0;
 }
 
+
+
+/* get states of all disks in native volume or container
+ * from kernel or metadata handler
+ */
+static struct mdinfo *get_raid_disk_info(struct state *st)
+{
+	struct supertype *sty = NULL;
+	int fd = -1, i, rv = 1;
+	unsigned id = 0;
+	struct mdinfo *infolist = NULL, *info;
+
+	/* ignore arrays with error and get info for containers
+	 *  or native volumes
+	 */
+	if (st->err || (is_external(st->metadata_version) &&
+			is_subarray(st->metadata_version+9)))
+		return NULL;
+
+	if (is_external(st->metadata_version)) {
+		fd = open(st->devname, O_RDONLY);
+		if (fd < 0)
+			return NULL;
+		sty = guess_super(fd);
+		if (!sty) {
+			close(fd);
+			return NULL;;
+		}
+		if (sty->ss->load_super(sty, fd, st->devname)) {
+			rv = 0;
+			goto cleanup;
+		}
+		infolist = sty->ss->getinfo_super_disks(sty);
+	} else
+		infolist = sysfs_read(-1, st->devnum,
+				      GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE|
+				      GET_DEGRADED|GET_COMPONENT|GET_VERSION);
+
+	if (!infolist) {
+		rv = 0;
+		goto cleanup;
+	}
+	for (i = 0; i < st->total; i++) {
+		if (st->devid[i] == 0)
+			continue;
+		for (info = infolist->devs; info; info = info->next) {
+			id = makedev(info->disk.major, info->disk.minor);
+			if (st->devid[i] == id) {
+				st->devstate[i] = info->disk.state;
+				break;
+			}
+		}
+		if (!info)
+			st->devstate[i] = 1<<MD_DISK_FAULTY;
+	}
+
+ cleanup:
+	if (fd >= 0)
+		close(fd);
+	if (sty) {				\
+		sty->ss->free_super(sty);
+		free(sty);
+	}
+
+	if (!rv) {
+		if (infolist)
+			sysfs_free(infolist);
+		infolist = NULL;
+		return NULL;
+	}
+	return infolist;
+}
+
+int move_spare(struct state *st2, struct state *st1, unsigned *devid,
+	       char *mailaddr, char *mailfrom, char *alert_cmd,
+	       int dosyslog)
+{
+	struct mddev_dev_s devlist;
+	char devname[20];
+	int from_fd, to_fd;
+	if (!st1 || !st2 || (*devid) == 0)
+		return 0;
+	from_fd = open(st2->devname, O_RDONLY);
+	if (from_fd < 0)
+		return 0;
+	to_fd = open(st1->devname, O_RDONLY);
+	if (to_fd < 0) {
+		close(from_fd);
+		return 0;
+	}
+	devlist.next = NULL;
+	devlist.used = 0;
+	devlist.re_add = 0;
+	devlist.writemostly = 0;
+	devlist.devname = devname;
+	char *dv = map_dev(major(*devid), minor(*devid), 1);
+	if (!dv) {
+		close(from_fd);
+		close(to_fd);
+		return 0;
+	}
+	snprintf(devname, 20, "%s", dv);
+	devlist.disposition = 'r';
+	if (Manage_subdevs(st2->devname, from_fd, &devlist, VERBOSE, 0) == 0) {
+		devlist.disposition = 'a';
+		if (Manage_subdevs(st1->devname, to_fd, &devlist,
+				   VERBOSE, 0) == 0) {
+			*devid = 0;
+			ping_manager(st2->devname);
+			ping_manager(st1->devname);
+			alert("MoveSpare", st1->devname, st2->devname,
+			      mailaddr, mailfrom, alert_cmd, dosyslog);
+			close(from_fd);
+			close(to_fd);
+			return 1;
+		} else if (Manage_subdevs(st2->devname, from_fd,
+					  &devlist, VERBOSE, 0) != 0)
+			fprintf(stderr,
+				"Error: Adding back spare device"
+				"%s to container %s failed!\n",
+				st2->devname, dv);
+	}
+	/* Failed to add spare to new container */
+	close(from_fd);
+	close(to_fd);
+	return 0;
+}
+
+
+static int dev_suitable(unsigned devid, int devstate, unsigned long long size)
+{
+	unsigned long long ssize;
+	/* check if device not used in volumes, not failed, and big enough */
+	if ((devid > 0) && (devstate == 0) &&
+	    dev_size_from_id(devid, &ssize) && (ssize >= size))
+		return 1;
+	return 0;
+}
+
+
+/* If an array has active < raid && spare == 0
+ * Look for another array/container with unused, unfailed spare
+ * and the same domain
+ * if found, hotremove/hotadd the spare (to parent container in external)
+ */
+static void spare_sharing(struct state *statelist, char *mailaddr,
+			  char *mailfrom, char *alert_cmd, int dosyslog)
+{
+	struct state *st, *stp, *vol, *st2 = NULL;
+	int i, ext, found;
+	struct mdinfo *sra = NULL;
+
+	for (st = statelist; st; st = st->next) {
+		if (st->err || st->active == st->raid || st->spare > 0)
+			continue;
+
+		found = 0;
+		ext = is_external(st->metadata_version);
+		/*
+		 * for exernal metadata spare will be moved to parent container
+		 */
+		if (ext) {
+			stp = st->parent;
+			if (!stp)
+				continue;
+		} else {
+			stp = st;
+		}
+		/* get member device state updated */
+		sra = get_raid_disk_info(stp);
+		if (!sra) {
+			dprintf("no sra for device: %s\n", stp->devname);
+			continue;
+		}
+		sysfs_free(sra);
+		for (i = 0; i < stp->total; i++)
+			if (dev_suitable(stp->devid[i], stp->devstate[i],
+					 st->min_size))
+				break;
+		if (i < stp->total)
+			/* there is a spare in array/parent container,
+			 * it was probably just added
+			 * but mdmon has not started recovery yet
+			 * we will not add any more spares for now */
+			continue;
+
+		/* search for an array/container with unused spare */
+		for (st2 = statelist; st2; st2 = st2->next) {
+			if (st2->err || st2 == stp)
+				continue;
+			if ((ext && st2->parent != NULL) ||
+			    (strcmp(stp->metadata_version,
+				    st2->metadata_version) != 0))
+				continue;
+			if (ext) {
+				/* if container has degraded volume
+				 * we can't remove spares */
+				for (vol = st2->volumes; vol; vol = vol->volumes)
+					if (vol->active < vol->raid)
+						break;
+				if (vol)
+					continue;
+			} else {
+				if (st2->active < st2->raid)
+					continue;
+			}
+			/* support for domain comparision needed */
+			for (i = 0; i < st2->total; i++) {
+				if (!dev_suitable(st2->devid[i],
+						  st2->devstate[i],
+						  st->min_size))
+					continue;
+				if (move_spare(st2, stp, &st2->devid[i],
+					       mailaddr, mailfrom, alert_cmd,
+					       dosyslog)) {
+					found = 1;
+					/* stop searching disks */
+					break;
+				}
+			}
+			if (found)
+				break; /* stop searching arrays */
+		}
+	}
+	return;
+}
+
 static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mailfrom, char *cmd,
 		  int dosyslog)
 {
-- 
1.6.4.2

