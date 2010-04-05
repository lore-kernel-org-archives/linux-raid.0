From: Doug Ledford <dledford@redhat.com>
Subject: [Patch mdadm] Add hot-unplug support to mdadm
Date: Mon, 05 Apr 2010 12:40:41 -0400
Message-ID: <4BBA1289.4010705@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2A6CD8681C80644C374ACC7E"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2A6CD8681C80644C374ACC7E
Content-Type: multipart/mixed;
 boundary="------------030101010301040404020709"

This is a multi-part message in MIME format.
--------------030101010301040404020709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

We have incremental mode for supporting hot plug of devices.  However,
we don't support hot-unplug.  This is something we need in order to
enable automatic device replacement.  When implementing the support
though, I found that we had a problem in that the device special file is
already gone (well, not gone, but both open and lstat fail on the device
special file, which really makes Manage_subdevs unhappy) by the time
udev calls us to remove the device (even if I created a new udev rules
file with a very low number this was still true).  So, along with adding
the code shamelessly stolen from Hawrylewicz with modifications to make
it work on non-container based arrays, I had to modify Manage_subdevs to
work on sysfs subdevice entries in the fail and remove cases.  Anyway,
with this in place, and with the modified udev rules file in place,
hot-unplug now works (or at least it does in my testing, I didn't try a
container device, I'll leave tweaking that to Dan or someone else from
Intel, although it should more or less work, I don't know the Intel
metadata rules and so didn't try to make it work myself).  And by
changing Manage_subdevs to use either a valid device special file or
sysfs entries, it will work on the command line with virtually any
kernel, and work from a udev rules file on kernels recent enough to have
the state entry in sysfs subdevs directories.

Oh, and Neil should review my man page additions to see if they are
sufficient for his tastes.  I didn't get real wordy about the support,
it's pretty straight forward.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------030101010301040404020709
Content-Type: text/plain;
 name="mdadm-decremental.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-decremental.patch"

commit 3212dcca06f81017ec9a50c7b5d4eeb34bedaab6
Author: Doug Ledford <dledford@redhat.com>
Date:   Mon Apr 5 12:32:08 2010 -0400

    Initial implementation of incremental remove support
   =20
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/Incremental.c b/Incremental.c
index 7ad648a..d32a8e5 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -843,3 +843,39 @@ int Incremental_container(struct supertype *st, char=
 *devname, int verbose,
 	map_unlock(&map);
 	return 0;
 }
+
+/*
+ * IncrementalRemove - Attempt to see if the passed in device belongs to=
 any
+ * raid arrays, and if so first fail (if needed) and then remove the dev=
ice.
+ *
+ * @devname - The device we want to remove
+ *
+ * Special note: We would like to just use Managedevs to fail/remove the=

+ * device, but unfortunately, by the time we are called via udev, the de=
vice
+ * special file is already gone, and so we can't stat the device and se =
we
+ * don't have the right rdev value to use in the ioctls.  So, we use the=

+ * sysfs method of device removal instead, but since that's not gaurante=
ed
+ * to work depending on the version of kernel we run on, try to use the
+ * ioctl method first and only fallback if we don't have a valid device
+ * special file.  That way we can support operation manually on older ke=
rnels
+ * even if we won't be able to do this automatically via udev on older
+ * kernels.
+ */
+int IncrementalRemove(char *devname, int verbose)
+{
+	char mddev[100] =3D "/dev/";
+	int mdfd;
+	struct mddev_dev_s devlist;
+
+	strncpy(mddev + 5, devname, sizeof(mddev) - 5);
+	if (mdstat_check_active(mddev + 5))
+		return 1;
+	if ((mdfd =3D open_mddev(mddev, 0)) < 0)
+		return 1;
+	memset(&devlist, 0, sizeof(devlist));
+	devlist.devname =3D devname;
+	devlist.disposition =3D 'f';
+	Manage_subdevs(mddev, mdfd, &devlist, verbose);
+	devlist.disposition =3D 'r';
+	return Manage_subdevs(mddev, mdfd, &devlist, verbose);
+}
diff --git a/Manage.c b/Manage.c
index f848d8b..6539eda 100644
--- a/Manage.c
+++ b/Manage.c
@@ -346,6 +346,9 @@ int Manage_subdevs(char *devname, int fd,
 	mdu_disk_info_t disc;
 	unsigned long long array_size;
 	mddev_dev_t dv, next =3D NULL;
+	struct mdinfo *mdi =3D NULL;
+	struct mdinfo *dev =3D NULL;
+	char sys_name[20] =3D "dev-";
 	struct stat stb;
 	int j, jnext =3D 0;
 	int tfd;
@@ -443,16 +446,43 @@ int Manage_subdevs(char *devname, int fd,
 			if (jnext =3D=3D 0)
 				continue;
 		} else {
+			/*
+			 * For fail/remove operations, allow the disk
+			 * to be completely missing, use name matching
+			 * to a device in our sysfs entries to
+			 * suffice.  For add we need a valid block device.
+			 * Leave this loop one of three ways:
+			 * 1) tfd < 0 and dev is set to our device
+			 * 2) tfd >=3D 0 and dev is NULL
+			 * 3) failed to find suitable device and return
+			 */
 			j =3D 0;
=20
 			tfd =3D dev_open(dv->devname, O_RDONLY);
-			if (tfd < 0 && dv->disposition =3D=3D 'r' &&
-			    lstat(dv->devname, &stb) =3D=3D 0)
-				/* Be happy, the lstat worked, that is
-				 * enough for --remove
-				 */
-				;
-			else {
+			if (tfd < 0 && dv->disposition !=3D 'a') {
+				strcpy(&sys_name[4],
+				       strrchr(dv->devname, '/') + 1);
+				mdi =3D sysfs_read(fd, 0,
+						 GET_DEVS | KEEP_GONE_DEVS);
+				if (!mdi) {
+					fprintf(stderr, Name ": can't open %s "
+						"and can't read sysfs info\n",
+						dv->devname);
+					return 1;
+				}
+				for (dev =3D mdi->devs; dev; dev =3D dev->next) {
+					if (strcmp(sys_name, dev->sys_name))
+						continue;
+					break;
+				}
+				if (!dev) {
+					fprintf(stderr, Name ": can't open %s "
+						"and %s not listed in sysfs\n",
+						dv->devname, sys_name);
+					sysfs_free(mdi);
+					return 1;
+				}
+			} else {
 				if (tfd < 0 || fstat(tfd, &stb) !=3D 0) {
 					fprintf(stderr, Name ": cannot find %s: %s\n",
 						dv->devname, strerror(errno));
@@ -461,12 +491,12 @@ int Manage_subdevs(char *devname, int fd,
 					return 1;
 				}
 				close(tfd);
-			}
-			if ((stb.st_mode & S_IFMT) !=3D S_IFBLK) {
-				fprintf(stderr, Name ": %s is not a "
-					"block device.\n",
-					dv->devname);
-				return 1;
+				if ((stb.st_mode & S_IFMT) !=3D S_IFBLK) {
+					fprintf(stderr, Name ": %s is not a "
+						"block device.\n",
+						dv->devname);
+					return 1;
+				}
 			}
 		}
 		switch(dv->disposition){
@@ -790,26 +820,36 @@ int Manage_subdevs(char *devname, int fd,
 					return 1;
 				}
 			}
-			/* FIXME check that it is a current member */
-			err =3D ioctl(fd, HOT_REMOVE_DISK, (unsigned long)stb.st_rdev);
-			if (err && errno =3D=3D ENODEV) {
+			/* stb.st_rdev is only valid if we have a tfd that
+			 * does not indicate an error on attempt to open
+			 * the devname
+			 */
+			if (tfd >=3D 0)
+				err =3D ioctl(fd, HOT_REMOVE_DISK,
+					    (unsigned long)stb.st_rdev);
+			if (tfd < 0 || (err && errno =3D=3D ENODEV)) {
 				/* Old kernels rejected this if no personality
 				 * registered */
-				struct mdinfo *sra =3D sysfs_read(fd, 0, GET_DEVS);
-				struct mdinfo *dv =3D NULL;
-				if (sra)
-					dv =3D sra->devs;
-				for ( ; dv ; dv=3Ddv->next)
-					if (dv->disk.major =3D=3D major(stb.st_rdev) &&
-					    dv->disk.minor =3D=3D minor(stb.st_rdev))
+				if (!mdi) {
+					strcpy(&sys_name[4],
+					       strrchr(dv->devname, '/') + 1);
+					mdi =3D sysfs_read(fd, 0, GET_DEVS |
+							 KEEP_GONE_DEVS);
+					if (mdi)
+						dev =3D mdi->devs;
+					for ( ; dev ; dev=3Ddev->next) {
+						if (strcmp(sys_name, dev->sys_name))
+							continue;
 						break;
-				if (dv)
-					err =3D sysfs_set_str(sra, dv,
+					}
+				}
+				if (dev)
+					err =3D sysfs_set_str(mdi, dev,
 							    "state", "remove");
 				else
 					err =3D -1;
-				if (sra)
-					sysfs_free(sra);
+				if (mdi)
+					sysfs_free(mdi);
 			}
 			if (err) {
 				fprintf(stderr, Name ": hot remove failed "
@@ -844,11 +884,18 @@ int Manage_subdevs(char *devname, int fd,
=20
 		case 'f': /* set faulty */
 			/* FIXME check current member */
-			if (ioctl(fd, SET_DISK_FAULTY, (unsigned long) stb.st_rdev)) {
+			if ((tfd >=3D 0 && ioctl(fd, SET_DISK_FAULTY,
+					       (unsigned long) stb.st_rdev)) ||
+			    (tfd < 0 && sysfs_set_str(mdi, dev, "state",
+						      "faulty"))) {
 				fprintf(stderr, Name ": set device faulty failed for %s:  %s\n",
 					dnprintable, strerror(errno));
+				if (mdi)
+					sysfs_free(mdi);
 				return 1;
-			}
+			}=20
+			if (mdi)
+				sysfs_free(mdi);
 			if (verbose >=3D 0)
 				fprintf(stderr, Name ": set %s faulty in %s\n",
 					dnprintable, devname);
diff --git a/ReadMe.c b/ReadMe.c
index ba2215c..acaeace 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -86,11 +86,12 @@ char Version[] =3D Name " - v3.1.2-dledford - 30th Ma=
rch 2010\n";
  *     At the time if writing, there is only minimal support.
  */
=20
-char short_options[]=3D"-ABCDEFGIQhVXWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sar=
fRSow1tye:";
+char short_options[]=3D
+	"-ABCDEFGIQhVXWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
 char short_bitmap_options[]=3D
-                   "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRS=
ow1tye:";
+	"-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:";
 char short_bitmap_auto_options[]=3D
-                   "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfR=
Sow1tye:";
+	"-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:";
=20
 struct option long_options[] =3D {
     {"manage",    0, 0, '@'},
@@ -213,7 +214,7 @@ char Help[] =3D
 "       mdadm --grow options device\n"
 "            resize/reshape an active array\n"
 "       mdadm --incremental device\n"
-"            add a device to an array as appropriate\n"
+"            add/remove a device to/from an array as appropriate\n"
 "       mdadm --monitor options...\n"
 "            Monitor one or more array for significant changes.\n"
 "       mdadm device options...\n"
@@ -535,20 +536,26 @@ char Help_grow[] =3D
 ;
=20
 char Help_incr[] =3D
-"Usage: mdadm --incremental [-Rqrs] device\n"
+"Usage: mdadm --incremental [-Rqrsf] device\n"
 "\n"
 "This usage allows for incremental assembly of md arrays.  Devices can b=
e\n"
 "added one at a time as they are discovered.  Once an array has all expe=
cted\n"
 "devices, it will be started.\n"
 "\n"
-"Options that are valid with incremental assembly (-I --incremental) mor=
e are:\n"
-"  --run       -R  : run arrays as soon as a minimal number of devices a=
re\n"
+"Optionally, the process can be reversed by using the fail option.\n"
+"When fail mode is invoked, mdadm will see if the device belongs to an a=
rray\n"
+"and then both fail (if needed) and remove the device from that array.\n=
"
+"\n"
+"Options that are valid with incremental assembly (-I --incremental) are=
:\n"
+"  --run       -R  : Run arrays as soon as a minimal number of devices a=
re\n"
 "                  : present rather than waiting for all expected.\n"
 "  --quiet     -q  : Don't print any information messages, just errors.\=
n"
 "  --rebuild   -r  : Rebuild the 'map' file that mdadm uses for tracking=
\n"
 "                  : partial arrays.\n"
 "  --scan      -s  : Use with -R to start any arrays that have the minim=
al\n"
 "                  : required number of devices, but are not yet started=
=2E\n"
+"  --fail      -f  : First fail (if needed) and then remove device from\=
n"
+"                  : any array that it is a member of.\n"
 ;
=20
 char Help_config[] =3D
diff --git a/mdadm.8 b/mdadm.8
index 4edfc41..eaf9155 100644
--- a/mdadm.8
+++ b/mdadm.8
@@ -135,7 +135,11 @@ This provides a convenient interface to a
 .I hot-plug
 system.  As each device is detected,
 .I mdadm
-has a chance to include it in some array as appropriate.
+has a chance to include it in some array as appropriate.  Optionally,
+with the
+.I \-\-fail
+flag is passed in then we will remove the device from any active array
+instead of adding it.
=20
 If a
 .B CONTAINER
@@ -189,7 +193,7 @@ Change the size or shape of an active array.
=20
 .TP
 .BR \-I ", " \-\-incremental
-Add a single device into an appropriate array, and possibly start the ar=
ray.
+Add/remove a single device to/from an appropriate array, and possibly st=
art the array.
=20
 .TP
 .B \-\-auto-detect
@@ -1235,6 +1239,12 @@ in
 .B mdadm.conf
 as requiring an external bitmap, that bitmap will be attached first.
=20
+.TP
+.BR \-\-fail ", " \-f
+This allows the hot-plug system to remove devices that have fully disapp=
eared
+from the kernel.  It will first fail and then remove the device from any=

+array it belongs to.
+
 .SH For Monitor mode:
 .TP
 .BR \-m ", " \-\-mail
@@ -2141,6 +2151,10 @@ Usage:
 .I component-device
 .HP 12
 Usage:
+.B mdadm \-\-incremental \-\-fail
+.I component-device
+.HP 12
+Usage:
 .B mdadm \-\-incremental \-\-rebuild
 .HP 12
 Usage:
@@ -2153,6 +2167,11 @@ passed to
 .B "mdadm \-\-incremental"
 to be conditionally added to an appropriate array.
=20
+Conversely, it can also be used with the
+.B \-\-fail
+flag to do just the opposite and find whatever array a particular device=

+is part of and remove the device from the array.
+
 If the device passed is a
 .B CONTAINER
 device created by a previous call to
diff --git a/mdadm.c b/mdadm.c
index d5e34c0..cd6fd8f 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -124,6 +124,7 @@ int main(int argc, char *argv[])
 	ident.name[0] =3D 0;
 	ident.container =3D NULL;
 	ident.member =3D NULL;
+	ident.member_index =3D -1;
=20
 	while ((option_index =3D -1) ,
 	       (opt=3Dgetopt_long(argc, argv,
@@ -774,6 +775,9 @@ int main(int argc, char *argv[])
 			devmode =3D 'r';
 			continue;
 		case O(MANAGE,'f'): /* set faulty */
+		case O(INCREMENTAL,'f'): /* r for incremental is taken, use f
+					  * even though we will both fail and
+					  * remove the device */
 			devmode =3D 'f';
 			continue;
 		case O(INCREMENTAL,'R'):
@@ -1517,6 +1521,11 @@ int main(int argc, char *argv[])
 			 ": --incremental --scan meaningless without --run.\n");
 				break;
 			}
+			if (devmode =3D=3D 'f') {
+				fprintf(stderr, Name
+			 ": --incremental --scan --fail not supported.\n");
+				break;
+			}
 			rv =3D IncrementalScan(verbose);
 		}
 		if (!devlist) {
@@ -1533,6 +1542,10 @@ int main(int argc, char *argv[])
 			rv =3D 1;
 			break;
 		}
+		if (devmode =3D=3D 'f') {
+			rv =3D IncrementalRemove(devlist->devname, verbose-quiet);
+			break;
+		}
 		rv =3D Incremental(devlist->devname, verbose-quiet, runstop,
 				 ss, homehost, require_homehost, autof);
 		break;
diff --git a/mdadm.h b/mdadm.h
index d8ab85f..c113d0f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -315,6 +315,7 @@ typedef struct mddev_ident_s {
 				 * of some other entry.
 				 */
 	char	*member;	/* subarray within a container */
+	int	member_index;	/* subarray index within a container */
=20
 	struct mddev_ident_s *next;
 	union {
@@ -355,6 +356,10 @@ struct mdstat_ent {
 	int		raid_disks;
 	int		chunk_size;
 	char *		metadata_version;
+	struct dev_member {
+		char			*name;
+		struct dev_member	*next;
+	} 		*members;
 	struct mdstat_ent *next;
 };
=20
@@ -363,6 +368,7 @@ extern void free_mdstat(struct mdstat_ent *ms);
 extern void mdstat_wait(int seconds);
 extern void mdstat_wait_fd(int fd, const sigset_t *sigmask);
 extern int mddev_busy(int devnum);
+extern int mdstat_check_active(char *devname);
=20
 struct map_ent {
 	struct map_ent *next;
@@ -404,6 +410,7 @@ enum sysfs_read_flags {
 	GET_STATE	=3D (1 << 13),
 	GET_ERROR	=3D (1 << 14),
 	SKIP_GONE_DEVS	=3D (1 << 15),
+	KEEP_GONE_DEVS	=3D (1 << 16),
 };
=20
 /* If fd >=3D 0, get the array it is open on,
@@ -817,6 +824,7 @@ extern int Incremental_container(struct supertype *st=
, char *devname,
 				 int trustworthy);
 extern void RebuildMap(void);
 extern int IncrementalScan(int verbose);
+extern int IncrementalRemove(char *devname, int verbose);
=20
 extern int CreateBitmap(char *filename, int force, char uuid[16],
 			unsigned long chunksize, unsigned long daemon_sleep,
diff --git a/mdstat.c b/mdstat.c
index 4a9f370..81d2212 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -83,6 +83,45 @@
 #include	<sys/select.h>
 #include	<ctype.h>
=20
+static void free_member_devnames(struct dev_member **m)
+{
+       struct dev_member *t;
+       if (!*m)
+               return;
+       while(*m) {
+               t =3D *m;
+               *m =3D (*m)->next;
+               if (t->name)
+                       free(t->name);
+               free(t);
+       }
+       *m =3D NULL;
+}
+
+static struct dev_member *add_member_devname(struct dev_member **m, char=
 *name)
+{
+       struct dev_member *new;
+       char *t;
+
+       if (!m || !name)
+               return NULL;
+
+       new =3D malloc(sizeof(*new));
+       if (!new)
+               return NULL;
+       if ((t =3D strchr(name, '[')) =3D=3D NULL)
+       {
+               /* not a device */
+               free(new);
+               return *m;
+       }
+       new->name =3D strndup(name, t - name);
+       new->next =3D *m;
+       *m =3D new;
+
+       return new;
+}
+
 void free_mdstat(struct mdstat_ent *ms)
 {
 	while (ms) {
@@ -91,6 +130,7 @@ void free_mdstat(struct mdstat_ent *ms)
 		if (ms->level) free(ms->level);
 		if (ms->pattern) free(ms->pattern);
 		if (ms->metadata_version) free(ms->metadata_version);
+		if (ms->members) free_member_devnames(&ms->members);
 		t =3D ms;
 		ms =3D ms->next;
 		free(t);
@@ -159,6 +199,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 		ent->raid_disks =3D 0;
 		ent->chunk_size =3D 0;
 		ent->devcnt =3D 0;
+		ent->members =3D NULL;
=20
 		ent->dev =3D strdup(line);
 		ent->devnum =3D devnum;
@@ -170,15 +211,23 @@ struct mdstat_ent *mdstat_read(int hold, int start)=

 				ent->active =3D 1;
 			else if (strcmp(w, "inactive")=3D=3D0)
 				ent->active =3D 0;
-			else if (ent->active >=3D0 &&
+			else if (ent->active > 0 &&
 				 ent->level =3D=3D NULL &&
 				 w[0] !=3D '(' /*readonly*/) {
 				ent->level =3D strdup(w);
 				in_devs =3D 1;
 			} else if (in_devs && strcmp(w, "blocks")=3D=3D0)
 				in_devs =3D 0;
-			else if (in_devs) {
+			else if (in_devs || (ent->active =3D=3D 0 && w[0] !=3D '(' &&
+					     w[l - 1] =3D=3D ')')) {
+				if (isdigit(w[0]))
+					continue;
+				in_devs =3D 1;
 				ent->devcnt++;
+				if (!add_member_devname(&ent->members, w)) {
+					free_mdstat(ent);
+					break;
+				}
 				if (strncmp(w, "md", 2)=3D=3D0) {
 					/* This has an md device as a component.
 					 * If that device is already in the
@@ -310,3 +359,40 @@ int mddev_busy(int devnum)
 	free_mdstat(mdstat);
 	return me !=3D NULL;
 }
+
+/*
+ * Finds name of the active array holding this device
+ * @param[in]  devname         name of member device
+ * @param[out] devname         name of array
+ *
+ * @return                     found (0), or
+ *                             not found, failure (1)
+ */
+
+int mdstat_check_active(char *devname)
+{
+       struct mdstat_ent *mdstat =3D mdstat_read(0, 0);
+       struct mdstat_ent *ent;
+       char *name;
+
+       if (!devname)
+               return 1;
+       name =3D strrchr(devname, '/');
+       if (name++ =3D=3D NULL)
+               return 1;
+
+       for (ent =3D mdstat; ent; ent =3D ent->next) {
+               struct dev_member *m;
+               if (ent->active && (strstr(ent->metadata_version,"imsm") =
||
+				   strstr(ent->metadata_version,"ddf")))
+		       /* only return container matches, not subarrays */
+                       continue;
+               for (m =3D ent->members; m; m =3D m->next) {
+                       if (!strcmp(m->name, name)) {
+                               strcpy(devname, ent->dev);
+                               return 0;
+                       }
+               }
+       }
+       return 1;
+}
diff --git a/sysfs.c b/sysfs.c
index ebf9d8a..65dd848 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -273,13 +273,16 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsig=
ned long options)
=20
 		strcpy(dbase, "block/dev");
 		if (load_sys(fname, buf)) {
-			free(dev);
-			if (options & SKIP_GONE_DEVS)
+			if (options & SKIP_GONE_DEVS) {
+				free(dev);
 				continue;
-			else
+			} else if (options & KEEP_GONE_DEVS) {
+				dev->disk.major =3D dev->disk.minor =3D -1;
+			} else
 				goto abort;
-		}
-		sscanf(buf, "%d:%d", &dev->disk.major, &dev->disk.minor);
+		} else
+			sscanf(buf, "%d:%d", &dev->disk.major,
+			       &dev->disk.minor);
=20
 		/* special case check for block devices that can go 'offline' */
 		if (options & SKIP_GONE_DEVS) {
diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index c9a4f0e..aff14fa 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -1,17 +1,16 @@
 # do not edit this file, it will be overwritten on update
=20
 SUBSYSTEM!=3D"block", GOTO=3D"md_end"
-ACTION!=3D"add|change", GOTO=3D"md_end"
+ACTION!=3D"add|change|remove", GOTO=3D"md_end"
+ACTION=3D=3D"remove", GOTO=3D"md_remove"
 ACTION=3D=3D"change", GOTO=3D"md_no_incr"
=20
-# import data from a raid member and activate it
-#ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", IMPORT{program}=3D"/sbin/mdad=
m --examine --export $tempnode", RUN+=3D"/sbin/mdadm --incremental $env{D=
EVNAME}"
-# import data from a raid set
+# we are adding a raid member, activate it
+ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", RUN+=3D"/sbin/mdadm -I $env{DE=
VNAME}"
 LABEL=3D"md_no_incr"
 KERNEL!=3D"md*", GOTO=3D"md_end"
=20
-# partitions have no md/{array_state,metadata_version}, but should not
-# for that reason be ignored.
+# partitions have no md/{array_state,metadata_version}
 ENV{DEVTYPE}=3D=3D"partition", GOTO=3D"md_ignore_state"
=20
 # container devices have a metadata version of e.g. 'external:ddf' and
@@ -32,7 +31,12 @@ ENV{DEVTYPE}=3D=3D"partition", ENV{MD_DEVNAME}=3D=3D"*=
[0-9]", SYMLINK+=3D"md/$env{MD_DEVNA
=20
 IMPORT{program}=3D"/sbin/blkid -o udev -p $tempnode"
 OPTIONS+=3D"link_priority=3D100"
+OPTIONS+=3D"watch"
 ENV{ID_FS_USAGE}=3D=3D"filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=3D=3D=
"?*", SYMLINK+=3D"disk/by-uuid/$env{ID_FS_UUID_ENC}"
 ENV{ID_FS_USAGE}=3D=3D"filesystem|other", ENV{ID_FS_LABEL_ENC}=3D=3D"?*"=
, SYMLINK+=3D"disk/by-label/$env{ID_FS_LABEL_ENC}"
+GOTO=3D"md_end"
+
+LABEL=3D"md_remove"
+ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", RUN+=3D"/sbin/mdadm -If $env{D=
EVNAME}"
=20
 LABEL=3D"md_end"

--------------030101010301040404020709--

--------------enig2A6CD8681C80644C374ACC7E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku6EokACgkQg6WylM+/8ZSnsgCeNG0Qa56TOp5PJibWfUP5c5pX
jVUAoKjV6EgitY41VEuv//gFhgXuhoTr
=tQ6/
-----END PGP SIGNATURE-----

--------------enig2A6CD8681C80644C374ACC7E--
