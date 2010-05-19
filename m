From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 00/13] imsm: new imsm metadata features
Date: Tue, 18 May 2010 18:09:18 -0700
Message-ID: <1274231358.7776.29.camel@dwillia2-linux>
References: <66C59AD0932712458090B447266D638CD405E3B1@irsmsx504.ger.corp.intel.com>
	 <t2se9c3a7c21004291757w49c4697dic28f49245c85ba7a@mail.gmail.com>
	 <4BDB4182.5060805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDB4182.5060805@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, Doug Ledford <dledford@redhat.com>, Doug Healey <douglas.d.healey@intel.com>
List-Id: linux-raid.ids

[ catching up on the patch backlog ]

On Fri, 2010-04-30 at 13:45 -0700, Doug Ledford wrote:
> On 04/29/2010 08:57 PM, Dan Williams wrote:
> > Basically I am looking for a distro person to say "I guess we can live
> > with this" or "no, this violates too many assumptions of our storage
> > management code".
> 
[..]
> So, for F13 or later and for Enterprise Linux 6 or later, it would just
> mean modifying the uuid in grub.conf (and in mdadm.conf if there is an
> appropriate ARRAY line as well) to match the new uuid.  That's at least
> more doable than the hackish mkinitrd stuff.  But it's still not good
> and any failure to update the config file would result in a failed boot.
>  And this is just for x86 arches of course, that doesn't begin to cover
> other arch boot mechanisms.  In general, changing uuids is just *bad*.
> 

So here is a (lightly tested) version of subarray delete that I would be
comfortable with given the unfortunate/unavoidable side effect of
changing uuids.  Przemek, this does not include the delete by name and
delete by uuid support, only delete by index.  Are those methods
required for the other code you are implementing?  I would just as soon
leave them out, but we can add that functionality on top of this if need
be.  It made the interfaces simpler to maintain the current meaning of
st->subarray == (string) index.

Comments welcome,
Dan

--

Subject: Kill subarray

From: Dan Williams <dan.j.williams@intel.com>

Support for deleting a subarray out of an inactive container.  When all
subarrays are deleted the component devices are converted back into
spares, a --zero-superblock is still needed to kill the remaining
metadata at this point.  This operation is specifically only supported
on inactive containers for the following reasons:

1/ Deleting a subarray might change the uuid of other subarrays.  As long
as the container is inactive we can be assured that we are not changing
the uuid of the boot array.

2/ Deleting a subarray needs to be a container wide event to ensure
disks that record the modified subarray list perceive other disks that
did not receive this change as out of date.

Notes:
The st->subarray parsing in super-intel.c and super-ddf.c is updated to
be more strict now that we are reading user supplied subarray values.

Offline container modification performs some mdmon'ish operations so
make is_container_member() and version_to_superswitch() (formerly
find_metadata_methods()) generic utility functions.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Kill.c        |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ReadMe.c      |    1 
 mdadm.c       |    8 +++
 mdadm.h       |    6 +++
 mdmon.c       |   25 +----------
 super-ddf.c   |   25 +++++++++--
 super-intel.c |   97 ++++++++++++++++++++++++++++++++++++------
 util.c        |   26 +++++++++++
 8 files changed, 281 insertions(+), 40 deletions(-)


diff --git a/Kill.c b/Kill.c
index e738978..1957881 100644
--- a/Kill.c
+++ b/Kill.c
@@ -79,3 +79,136 @@ int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl)
 	close(fd);
 	return rv;
 }
+
+int Kill_subarray(char *dev, char *subarray, int quiet)
+{
+	/* Delete a subarray out of a container, the container must be
+	 * inactive.  The subarray string must be a subarray index
+	 * number.
+	 *
+	 * 0 = successfully deleted subarray from all container members
+	 * 1 = failed to sync metadata to one or more devices
+	 * 2 = failed to find the container, subarray, or other resource
+	 *     issue
+	 */
+	struct mdstat_ent *mdstat, *ent;
+	struct supertype *st, supertype;
+	struct mdinfo *mdi;
+	int fd, rv = 2;
+
+	st = &supertype;
+	memset(st, 0, sizeof(*st));
+
+	fd = open(dev, O_RDWR|O_EXCL);
+	if (fd < 0) {
+		if (!quiet)
+			fprintf(stderr, Name ": Couldn't open %s, aborting\n",
+				dev);
+		return 2;
+	}
+
+	st->devnum = fd2devnum(fd);
+	if (st->devnum == NoMdDev) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": Failed to determine device number for %s\n",
+				dev);
+		goto close_fd;
+	}
+
+	mdi = sysfs_read(fd, st->devnum, GET_VERSION|GET_LEVEL);
+	if (!mdi) {
+		if (!quiet)
+			fprintf(stderr, Name ": Failed to read sysfs for %s\n",
+				dev);
+		goto close_fd;
+	}
+
+	if (mdi->array.level != UnSet) {
+		if (!quiet)
+			fprintf(stderr, Name ": %s is not a container\n", dev);
+		goto free_sysfs;
+	}
+
+	st->ss = version_to_superswitch(mdi->text_version);
+	if (!st->ss || !st->ss->kill_subarray) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": Operation not supported for %s metadata\n",
+				mdi->text_version);
+		goto free_sysfs;
+	}
+
+	if (snprintf(st->subarray, sizeof(st->subarray), "%s", subarray) >=
+	    sizeof(st->subarray)) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": Input overflow for subarray '%s' > %zu bytes\n",
+				subarray, sizeof(st->subarray) - 1);
+		goto free_sysfs;
+	}
+
+	st->devname = devnum2devname(st->devnum);
+	if (!st->devname) {
+		if (!quiet)
+			fprintf(stderr, Name ": Failed to allocate device name\n");
+		goto free_sysfs;
+	}
+
+	if (st->ss->load_super(st, fd, NULL)) {
+		if (!quiet)
+			fprintf(stderr, Name ": Failed to find subarray-%s in %s\n",
+				subarray, dev);
+		goto free_name;
+	}
+
+	if (!st->loaded_container) {
+		if (!quiet)
+			fprintf(stderr, Name ": %s is not a container\n", dev);
+		goto free_super;
+	}
+
+	mdstat = mdstat_read(0, 0);
+	if (!mdstat) {
+		if (!quiet)
+			fprintf(stderr, Name ": Failed to read /proc/mdstat\n");
+		goto free_super;
+	}
+
+	for (ent = mdstat; ent; ent = ent->next)
+		if (is_container_member(ent, st->devname))
+			break;
+	if (ent) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": %s has active subarray(s), aborting\n",
+				dev);
+		goto free_mdstat;
+	}
+
+	/* ok we've found our victim, drop the axe */
+	st->ss->kill_subarray(st);
+
+	/* FIXME ->sync_metadata() does not report success/failure */
+	st->ss->sync_metadata(st);
+
+	if (!quiet)
+		fprintf(stderr,
+			Name ": Deleted subarray-%s from %s, UUIDs may have changed\n",
+			subarray, dev);
+
+	rv = 0;
+
+ free_mdstat:
+	free_mdstat(mdstat);
+ free_super:
+	st->ss->free_super(st);
+ free_name:
+	free(st->devname);
+ free_sysfs:
+	sysfs_free(mdi);
+ close_fd:
+	close(fd);
+
+	return rv;
+}
diff --git a/ReadMe.c b/ReadMe.c
index 9d5a211..387ba6d 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -108,6 +108,7 @@ struct option long_options[] = {
     {"examine-bitmap", 0, 0, 'X'},
     {"auto-detect", 0, 0, AutoDetect},
     {"detail-platform", 0, 0, DetailPlatform},
+    {"kill-subarray", 1, 0, KillSubarray},
 
     /* synonyms */
     {"monitor",   0, 0, 'F'},
diff --git a/mdadm.c b/mdadm.c
index d5e34c0..446fab8 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -103,6 +103,7 @@ int main(int argc, char *argv[])
 	int dosyslog = 0;
 	int rebuild_map = 0;
 	int auto_update_home = 0;
+	char *subarray = NULL;
 
 	int print_help = 0;
 	FILE *outf;
@@ -216,6 +217,9 @@ int main(int argc, char *argv[])
 		case 'W':
 		case Waitclean:
 		case DetailPlatform:
+		case KillSubarray:
+			if (opt == KillSubarray)
+				subarray = optarg;
 		case 'K': if (!mode) newmode = MISC; break;
 		}
 		if (mode && newmode == mode) {
@@ -807,6 +811,7 @@ int main(int argc, char *argv[])
 		case O(MISC,'W'):
 		case O(MISC, Waitclean):
 		case O(MISC, DetailPlatform):
+		case O(MISC, KillSubarray):
 			if (devmode && devmode != opt &&
 			    (devmode == 'E' || (opt == 'E' && devmode != 'Q'))) {
 				fprintf(stderr, Name ": --examine/-E cannot be given with -%c\n",
@@ -1403,6 +1408,9 @@ int main(int argc, char *argv[])
 					rv |= Wait(dv->devname); continue;
 				case Waitclean:
 					rv |= WaitClean(dv->devname, -1, verbose-quiet); continue;
+				case KillSubarray:
+					rv |= Kill_subarray(dv->devname, subarray, quiet);
+					continue;
 				}
 				mdfd = open_mddev(dv->devname, 1);
 				if (mdfd>=0) {
diff --git a/mdadm.h b/mdadm.h
index d9d17b0..bf055c0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -273,6 +273,7 @@ enum special_options {
 	AutoDetect,
 	Waitclean,
 	DetailPlatform,
+	KillSubarray,
 };
 
 /* structures read from config file */
@@ -609,6 +610,8 @@ extern struct superswitch {
 	struct mdinfo *(*container_content)(struct supertype *st);
 	/* Allow a metadata handler to override mdadm's default layouts */
 	int (*default_layout)(int level); /* optional */
+	/* Permit subarray's to be deleted from inactive containers */
+	void (*kill_subarray)(struct supertype *st);
 
 /* for mdmon */
 	int (*open_new)(struct supertype *c, struct active_array *a,
@@ -805,6 +808,7 @@ extern int Monitor(mddev_dev_t devlist,
 		   int dosyslog, int test, char *pidfile, int increments);
 
 extern int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl);
+extern int Kill_subarray(char *dev, char *subarray, int quiet);
 extern int Wait(char *dev);
 extern int WaitClean(char *dev, int sock, int verbose);
 
@@ -911,6 +915,8 @@ extern int create_mddev(char *dev, char *name, int autof, int trustworthy,
 #define	METADATA 3
 extern int open_mddev(char *dev, int report_errors);
 extern int open_container(int fd);
+extern int is_container_member(struct mdstat_ent *ent, char *devname);
+extern struct superswitch *version_to_superswitch(char *vers);
 
 extern char *pid_dir;
 extern int mdmon_running(int devnum);
diff --git a/mdmon.c b/mdmon.c
index 69c320e..beb39cf 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -104,15 +104,6 @@ int __clone2(int (*fn)(void *),
 	return mon_tid;
 }
 
-static struct superswitch *find_metadata_methods(char *vers)
-{
-	if (strcmp(vers, "ddf") == 0)
-		return &super_ddf;
-	if (strcmp(vers, "imsm") == 0)
-		return &super_imsm;
-	return NULL;
-}
-
 static int make_pidfile(char *devname)
 {
 	char path[100];
@@ -136,18 +127,6 @@ static int make_pidfile(char *devname)
 	return 0;
 }
 
-int is_container_member(struct mdstat_ent *mdstat, char *container)
-{
-	if (mdstat->metadata_version == NULL ||
-	    strncmp(mdstat->metadata_version, "external:", 9) != 0 ||
-	    !is_subarray(mdstat->metadata_version+9) ||
-	    strncmp(mdstat->metadata_version+10, container, strlen(container)) != 0 ||
-	    mdstat->metadata_version[10+strlen(container)] != '/')
-		return 0;
-
-	return 1;
-}
-
 static void try_kill_monitor(pid_t pid, char *devname, int sock)
 {
 	char buf[100];
@@ -414,9 +393,9 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
 		exit(3);
 	}
 
-	container->ss = find_metadata_methods(mdi->text_version);
+	container->ss = version_to_superswitch(mdi->text_version);
 	if (container->ss == NULL) {
-		fprintf(stderr, "mdmon: %s uses unknown metadata: %s\n",
+		fprintf(stderr, "mdmon: %s uses unsupported metadata: %s\n",
 			devname, mdi->text_version);
 		exit(3);
 	}
diff --git a/super-ddf.c b/super-ddf.c
index 0e6f1e5..736e07f 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -845,10 +845,18 @@ static int load_super_ddf(struct supertype *st, int fd,
 	}
 
 	if (st->subarray[0]) {
+		unsigned long val;
 		struct vcl *v;
+		char *ep;
+
+		val = strtoul(st->subarray, &ep, 10);
+		if (*ep != '\0') {
+			free(super);
+			return 1;
+		}
 
 		for (v = super->conflist; v; v = v->next)
-			if (v->vcnum == atoi(st->subarray))
+			if (v->vcnum == val)
 				super->currentconf = v;
 		if (!super->currentconf) {
 			free(super);
@@ -2870,14 +2878,25 @@ static int load_super_ddf_all(struct supertype *st, int fd,
 			return 1;
 	}
 	if (st->subarray[0]) {
+		unsigned long val;
 		struct vcl *v;
+		char *ep;
+
+		val = strtoul(st->subarray, &ep, 10);
+		if (*ep != '\0') {
+			free(super);
+			return 1;
+		}
 
 		for (v = super->conflist; v; v = v->next)
-			if (v->vcnum == atoi(st->subarray))
+			if (v->vcnum == val)
 				super->currentconf = v;
-		if (!super->currentconf)
+		if (!super->currentconf) {
+			free(super);
 			return 1;
+		}
 	}
+
 	*sbp = super;
 	if (st->ss == NULL) {
 		st->ss = &super_ddf;
diff --git a/super-intel.c b/super-intel.c
index bdd7a96..7344a09 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2753,11 +2753,20 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 	}
 
 	if (st->subarray[0]) {
-		if (atoi(st->subarray) <= super->anchor->num_raid_devs)
-			super->current_vol = atoi(st->subarray);
+		unsigned long val;
+		char *ep;
+
+		err = 1;
+		val = strtoul(st->subarray, &ep, 10);
+		if (*ep != '\0') {
+			free_imsm(super);
+			goto error;
+		}
+
+		if (val < super->anchor->num_raid_devs)
+			super->current_vol = val;
 		else {
 			free_imsm(super);
-			err = 1;
 			goto error;
 		}
 	}
@@ -2824,8 +2833,17 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	}
 
 	if (st->subarray[0]) {
-		if (atoi(st->subarray) <= super->anchor->num_raid_devs)
-			super->current_vol = atoi(st->subarray);
+		unsigned long val;
+		char *ep;
+
+		val = strtoul(st->subarray, &ep, 10);
+		if (*ep != '\0') {
+			free_imsm(super);
+			return 1;
+		}
+
+		if (val < super->anchor->num_raid_devs)
+			super->current_vol = val;
 		else {
 			free_imsm(super);
 			return 1;
@@ -4007,6 +4025,45 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	close(cfd);
 	return 0;
 }
+
+static void handle_missing(struct intel_super *super, struct imsm_dev *dev);
+
+static void kill_subarray_imsm(struct supertype *st)
+{
+	/* remove the subarray currently referenced by ->current_vol */
+	struct intel_dev **dp;
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb = super->anchor;
+
+	if (super->current_vol < 0)
+		return;
+
+	for (dp = &super->devlist; *dp;)
+		if ((*dp)->index == super->current_vol) {
+			*dp = (*dp)->next;
+		} else {
+			handle_missing(super, (*dp)->dev);
+			if ((*dp)->index > super->current_vol)
+				(*dp)->index--;
+			dp = &(*dp)->next;
+		}
+
+	/* no more raid devices, all active components are now spares,
+	 * but of course failed are still failed
+	 */
+	if (--mpb->num_raid_devs == 0) {
+		struct dl *d;
+
+		for (d = super->disks; d; d = d->next)
+			if (d->index > -2) {
+				d->index = -1;
+				d->disk.status = SPARE_DISK;
+			}
+	}
+
+	super->current_vol = -1;
+	super->updates_pending++;
+}
 #endif /* MDASSEMBLE */
 
 static int is_rebuilding(struct imsm_dev *dev)
@@ -4347,6 +4404,24 @@ static void mark_missing(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	memmove(&disk->serial[0], &disk->serial[1], MAX_RAID_SERIAL_LEN - 1);
 }
 
+static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
+{
+	__u8 map_state;
+	struct dl *dl;
+	int failed;
+
+	if (!super->missing)
+		return;
+	failed = imsm_count_failed(super, dev);
+	map_state = imsm_check_degraded(super, dev, failed);
+
+	dprintf("imsm: mark missing\n");
+	end_migration(dev, map_state);
+	for (dl = super->missing; dl; dl = dl->next)
+		mark_missing(dev, &dl->disk, dl->index);
+	super->updates_pending++;
+}
+
 /* Handle dirty -> clean transititions and resync.  Degraded and rebuild
  * states are handled in imsm_set_disk() with one exception, when a
  * resync is stopped due to a new failure this routine will set the
@@ -4363,15 +4438,8 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	__u32 blocks_per_unit;
 
 	/* before we activate this array handle any missing disks */
-	if (consistent == 2 && super->missing) {
-		struct dl *dl;
-
-		dprintf("imsm: mark missing\n");
-		end_migration(dev, map_state);
-		for (dl = super->missing; dl; dl = dl->next)
-			mark_missing(dev, &dl->disk, dl->index);
-		super->updates_pending++;
-	}
+	if (consistent == 2)
+		handle_missing(super, dev);
 
 	if (consistent == 2 &&
 	    (!is_resync_complete(&a->info) ||
@@ -5242,6 +5310,7 @@ struct superswitch super_imsm = {
 	.validate_geometry = validate_geometry_imsm,
 	.add_to_super	= add_to_super_imsm,
 	.detail_platform = detail_platform_imsm,
+	.kill_subarray = kill_subarray_imsm,
 #endif
 	.match_home	= match_home_imsm,
 	.uuid_from_super= uuid_from_super_imsm,
diff --git a/util.c b/util.c
index 25f1e56..2e07912 100644
--- a/util.c
+++ b/util.c
@@ -1392,6 +1392,32 @@ int open_container(int fd)
 	return -1;
 }
 
+struct superswitch *version_to_superswitch(char *vers)
+{
+	int i;
+
+	for (i = 0; superlist[i]; i++) {
+		struct superswitch *ss = superlist[i];
+
+		if (strcmp(vers, ss->name) == 0)
+			return ss;
+	}
+
+	return NULL;
+}
+
+int is_container_member(struct mdstat_ent *mdstat, char *container)
+{
+	if (mdstat->metadata_version == NULL ||
+	    strncmp(mdstat->metadata_version, "external:", 9) != 0 ||
+	    !is_subarray(mdstat->metadata_version+9) ||
+	    strncmp(mdstat->metadata_version+10, container, strlen(container)) != 0 ||
+	    mdstat->metadata_version[10+strlen(container)] != '/')
+		return 0;
+
+	return 1;
+}
+
 int add_disk(int mdfd, struct supertype *st,
 	     struct mdinfo *sra, struct mdinfo *info)
 {


