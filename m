From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 13/17] Monitor: autorebuild functionality added
Date: Fri, 29 Oct 2010 15:25:04 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FD0@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 43c50f74689943e85913db343b33a0ff24812721 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 28 Oct 2010 13:20:21 +0200
Subject: [PATCH 13/17] Monitor: autorebuild functionality added

After all information on arrays is updated we first move spares
using spare-group information from config file, then link containers with
subarrays and call spare_sharing. Arrays with defined spare-groups
are not considered again. spare_sharing searches for suitable spares
in other arrays and moves them using move_spare to the arrays
that need them. move_spare removes spare from one array/container
and adds to another. If add fails we add back to original container.
Manage_subdevs function is used to perform the spare relocation.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Monitor.c |  299 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 294 insertions(+), 5 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 80cc553..a122040 100644
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
 
@@ -62,6 +69,8 @@ struct state {
 static void spare_sharing_in_spare_groups(struct state *statelist, char *mailaddr,
 				   char *mailfrom, char *alert_cmd, int dosyslog);
 static void link_containers_with_subarrays(struct state *list);
+static void spare_sharing(struct state *statelist, char *mailaddr,
+			  char *mailfrom, char *alert_cmd, int dosyslog);
 
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
@@ -100,11 +109,16 @@ int Monitor(mddev_dev_t devlist,
 	 *    DeviceDisappeared
 	 *      Couldn't access a device which was previously visible
 	 *
-	 * if we detect an array with active<raid and spare==0
+	 * If we detect an array with active<raid and spare==0
 	 * we look at other arrays that have same spare-group
 	 * If we find one with active==raid and spare>0,
-	 *  and if we can get_disk_info and find a name
-	 *  Then we hot-remove and hot-add to the other array
+	 * and if we can get_disk_info and find a name
+	 * Then we hot-remove and hot-add to the other array
+	 * This is kept for backward compatibility with the old config format
+	 * and only works with native metadata.
+	 * If there are no spare-groups defined we look for spares
+	 * in arrays with matching domain according to config policy.
+	 * Then we hot-remove and hot-add to the other array.
 	 *
 	 * If devlist is NULL, then we can monitor everything because --scan
 	 * was given.  We get an initial list from config file and add anything
@@ -113,6 +127,7 @@ int Monitor(mddev_dev_t devlist,
 
 	struct state *statelist = NULL;
 	int finished = 0;
+	int anydegraded;
 	struct mdstat_ent *mdstat = NULL;
 	char *mailfrom = NULL;
 
@@ -234,6 +249,8 @@ int Monitor(mddev_dev_t devlist,
 			st->parent = NULL;
 			st->subarray = NULL;
 			st->total = 0;
+			memset(st->devid, 0, MaxDisks*sizeof(int));
+			memset(st->devstate, 0, MaxDisks*sizeof(int));
 			statelist = st;
 		}
 	} else {
@@ -255,6 +272,8 @@ int Monitor(mddev_dev_t devlist,
 			st->parent = NULL;
 			st->subarray = NULL;
 			st->total = 0;
+			memset(st->devid, 0, MaxDisks*sizeof(int));
+			memset(st->devstate, 0, MaxDisks*sizeof(int));
 			if (mdlist) {
 				st->expected_spares = mdlist->spare_disks;
 				if (mdlist->spare_group)
@@ -269,6 +288,7 @@ int Monitor(mddev_dev_t devlist,
 		int new_found = 0;
 		struct state *st;
 
+		anydegraded = 0;
 		if (mdstat)
 			free_mdstat(mdstat);
 		mdstat = mdstat_read(oneshot?0:1, 0);
@@ -360,7 +380,6 @@ int Monitor(mddev_dev_t devlist,
 				st->err = 0;
 				continue;
 			}
-
 			if (st->utime == 0 && /* new array */
 			    mse->pattern && strchr(mse->pattern, '_') /* degraded */
 				)
@@ -477,6 +496,8 @@ int Monitor(mddev_dev_t devlist,
 			st->raid = array.raid_disks;
 			st->total = array.raid_disks + array.nr_disks;
 			st->err = 0;
+			if ((st->active < st->raid) && st->spare == 0)
+				anydegraded = 1;
 			if (mse->metadata_version) {
 				if (!st->metadata_version)
 					st->metadata_version = strdup(mse->metadata_version);
@@ -531,9 +552,10 @@ int Monitor(mddev_dev_t devlist,
 					new_found = 1;
 				}
 		}
-		if (share) {
+		if (share && anydegraded) {
 			spare_sharing_in_spare_groups(statelist, mailaddr, mailfrom, alert_cmd, dosyslog);
 			link_containers_with_subarrays(statelist);
+			spare_sharing(statelist, mailaddr, mailfrom, alert_cmd, dosyslog);
 		}
 		if (!new_found) {
 			if (oneshot)
@@ -612,6 +634,273 @@ static void spare_sharing_in_spare_groups(struct state *statelist, char *mailadd
 				}
 		}
 }
+/* get states of all disks in native volume or container
+ * from kernel or metadata handler
+ */
+static struct mdinfo *get_raid_disk_info(struct state *st, struct supertype *sty)
+{
+	int fd = -1, i;
+	unsigned id = 0;
+	struct mdinfo *infolist = NULL, *info;
+
+	/* ignore arrays with error and get info for containers
+	 *  or native volumes
+	 */
+	if (st->err || (is_external(st->metadata_version) &&
+			is_subarray(st->metadata_version+9)))
+		return NULL;
+	if (is_external(st->metadata_version) && sty->ss->getinfo_super_disks) {
+		fd = open(st->devname, O_RDONLY);
+		if (fd < 0)
+			return NULL;
+		if (sty->ss->load_super(sty, fd, st->devname)) {
+			close(fd);
+			return NULL;
+		}
+		close(fd);
+		/* TODO handler for ddf needed */
+		infolist = sty->ss->getinfo_super_disks(sty);
+		sty->ss->free_super(sty);
+	} else
+		infolist = sysfs_read(-1, st->devnum,
+				      GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE|
+				      GET_DEGRADED|GET_COMPONENT|GET_VERSION);
+	/* update devstates in array st */
+	for (i = 0; i < st->total; i++) {
+		if (!infolist) {
+			/* when we can't get info on disks we can't use them */
+			st->devstate[i] = 1<<MD_DISK_FAULTY;
+			continue;
+		}
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
+static int dev_suitable(unsigned devid, int devstate, unsigned long long size)
+{
+	unsigned long long ssize;
+	/* check if device not used in subarrays, not failed, and big enough */
+	if ((devid > 0) && (devstate == 0) &&
+	    dev_size_from_id(devid, &ssize) && (ssize >= size))
+		return 1;
+	return 0;
+}
+
+unsigned long long min_active_disk_size_in_array(struct state *st)
+{
+       int i;
+       unsigned long long size, min = 0;
+
+	for (i = 0; i < st->total; i++) {
+		if (st->devid[i] && st->devstate[i] & (1<<MD_DISK_ACTIVE) &&
+		    dev_size_from_id(st->devid[i], &size) &&
+		    (min == 0 || size < min))
+			min = size;
+	}
+	return min;
+}
+
+struct state *get_parent(struct state *st)
+{
+	if (is_external(st->metadata_version))
+		return st->parent;
+	else
+		return st;
+}
+
+static struct supertype *get_super(struct state *st)
+{
+	struct supertype *super = NULL;
+	char *metadata = NULL;
+	int i;
+
+	if (is_external(st->metadata_version)) {
+		st = st->parent;
+		if (!st)
+			return NULL;
+		metadata = st->metadata_version + strlen("external:");
+	} else {
+		metadata = st->metadata_version;
+	}
+	for (i = 0; !super && superlist[i]; i++)
+		super = superlist[i]->match_metadata_desc(metadata);
+	return super;
+}
+
+/* check if donating array/container:
+ * - has the same metadata
+ * - has no error reported
+ * - has no degraded subarray
+ * Returns:
+ *   0 - do not use the array/container
+ *   1 - array/container can be potetial spare disk donor
+ */
+static int check_donor(struct state *st2, struct state *stp)
+{
+	struct state *sub;
+	int ext = is_external(st2->metadata_version);
+	if (st2->err || st2 == stp || st2->spare_group ||
+	    (ext && st2->parent != NULL) ||
+	    (strcmp(stp->metadata_version, st2->metadata_version) != 0))
+		return 0;
+	if (ext) {
+		/* if container has degraded subarray
+		 * we can't remove spares */
+		for (sub = st2->subarray; sub; sub = sub->subarray)
+			if (sub->active < sub->raid)
+				return 0;
+	} else if (st2->active < st2->raid)
+		return 0;
+	return 1;
+}
+
+/* If an array has active < raid && spare == 0
+ * Look for another array/container with unused, unfailed spare
+ * and the same domain
+ * if found, hotremove/hotadd the spare (to parent container in external)
+ */
+static void spare_sharing(struct state *statelist, char *mailaddr,
+			  char *mailfrom, char *alert_cmd, int dosyslog)
+{
+	struct state *st, *stp, *st2 = NULL;
+	int i, found;
+	struct mdinfo *sra = NULL;
+	struct supertype *super = NULL;
+	unsigned long long min_size;
+
+	for (st = statelist; st; st = st->next) {
+		if (st->err || st->active == st->raid ||
+		    st->spare > 0 || st->spare_group)
+			continue;
+		found = 0;
+		/* for exernal metadata spare will be moved to parent
+		   container */
+		stp = get_parent(st);
+		if (!stp)
+			continue;
+		super = get_super(st);
+		if (!super)
+			continue;
+		/* get the disk states updated */
+		sra = get_raid_disk_info(stp, super);
+		if (!sra) {
+			dprintf("no sra for device: %s\n", stp->devname);
+			continue;
+		}
+		sysfs_free(sra);
+		min_size = min_active_disk_size_in_array(st);
+		if (min_size == 0)
+			continue;
+		for (i = 0; i < stp->total; i++)
+			if (dev_suitable(stp->devid[i], stp->devstate[i],
+					 min_size))
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
+			/* check donor container/array */
+			if (!check_donor(st2, stp))
+				continue;
+			/* update the disk info in st2 */
+			sra = get_raid_disk_info(st2, super);
+			if (!sra) {
+				dprintf("Cannot retrive the disk states "
+					"for device: %s\n", st2->devname);
+				continue;
+			}
+			sysfs_free(sra);
+			for (i = 0; i < st2->total; i++) {
+				if (!dev_suitable(st2->devid[i],
+						  st2->devstate[i],
+						  min_size))
+					continue;
+				/* domain comparison to be added here */
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
 
 static void add_to_cont(struct state *cont, struct state *sub)
 {
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

