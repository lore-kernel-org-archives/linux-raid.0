From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Fri, 9 Apr 2010 09:31:53 +1000
Message-ID: <20100409093153.690ea963@notabene.brown>
References: <4BBA1289.4010705@redhat.com>
	<20100407113035.3ca437f2@notabene.brown>
	<4BBBE7D2.6090608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBBE7D2.6090608@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, 06 Apr 2010 22:02:58 -0400
Doug Ledford <dledford@redhat.com> wrote:

> Let me know if you want me to redo/resend any of it.
> 

not necessary, but some remove would be appreciated.

I've create a temporary branch at 'hotunplug':

http://neil.brown.name/git?p=mdadm;a=shortlog;h=refs/heads/hotunplug

with my revised version of your code.

I substantially rewrote the changes to Manage.c and found that 
I didn't need KEEP_GONE_DEVS, though I would still like to tidy
that up.

The combined patch is below.
I have only performed limited testing.

Thanks,
NeilBrown

diff --git a/Incremental.c b/Incremental.c
index 7ad648a..ed29488 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -843,3 +843,42 @@ int Incremental_container(struct supertype *st, char *devname, int verbose,
 	map_unlock(&map);
 	return 0;
 }
+
+/*
+ * IncrementalRemove - Attempt to see if the passed in device belongs to any
+ * raid arrays, and if so first fail (if needed) and then remove the device.
+ *
+ * @devname - The device we want to remove
+ *
+ * Note: the device name must be a kernel name like "sda", so
+ * that we can find it in /proc/mdstat
+ */
+int IncrementalRemove(char *devname, int verbose)
+{
+	int mdfd;
+	struct mdstat_ent *ent;
+	struct mddev_dev_s devlist;
+
+	if (strchr(devname, '/')) {
+		fprintf(stderr, Name ": incremental removal requires a "
+			"kernel device name, not a file: %s\n", devname);
+		return 1;
+	}
+	ent = mdstat_by_component(devname);
+	if (!ent) {
+		fprintf(stderr, Name ": %s does not appear to be a component "
+			"of any array\n", devname);
+		return 1;
+	}
+	mdfd = open_dev(ent->devnum);
+	if (mdfd < 0) {
+		fprintf(stderr, Name ": Cannot open array %s!!\n", ent->dev);
+		return 1;
+	}
+	memset(&devlist, 0, sizeof(devlist));
+	devlist.devname = devname;
+	devlist.disposition = 'f';
+	Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
+	devlist.disposition = 'r';
+	return Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
+}
diff --git a/Manage.c b/Manage.c
index f848d8b..ba585d2 100644
--- a/Manage.c
+++ b/Manage.c
@@ -341,6 +341,8 @@ int Manage_subdevs(char *devname, int fd,
 	 *  'f' - set the device faulty SET_DISK_FAULTY
 	 *        device can be 'detached' in which case any device that
 	 *	  is inaccessible will be marked faulty.
+	 * For 'f' and 'r', the device can also be a kernel-internal
+	 * name such as 'sdb'.
 	 */
 	mdu_array_info_t array;
 	mdu_disk_info_t disc;
@@ -353,6 +355,7 @@ int Manage_subdevs(char *devname, int fd,
 	int duuid[4];
 	int ouuid[4];
 	int lfd = -1;
+	int sysfd = -1;
 
 	if (ioctl(fd, GET_ARRAY_INFO, &array)) {
 		fprintf(stderr, Name ": cannot get array info for %s\n",
@@ -442,6 +445,40 @@ int Manage_subdevs(char *devname, int fd,
 			}
 			if (jnext == 0)
 				continue;
+		} else if (strchr(dv->devname, '/') == NULL &&
+			   strlen(dv->devname) < 50) {
+			/* Assume this is a kernel-internal name like 'sda1' */
+			int found = 0;
+			char dname[55];
+			if (dv->disposition != 'r' && dv->disposition != 'f') {
+				fprintf(stderr, Name ": %s only meaningful "
+					"with -r of -f, not -%c\n",
+					dv->devname, dv->disposition);
+				return 1;
+			}
+
+			sprintf(dname, "dev-%s", dv->devname);
+			sysfd = sysfs_open(fd2devnum(fd), dname, "block/dev");
+			if (sysfd >= 0) {
+				char dn[20];
+				int mj,mn;
+				if (sysfs_fd_get_str(sysfd, dn, 20) > 0 &&
+				    sscanf(dn, "%d:%d", &mj,&mn) == 2) {
+					stb.st_rdev = makedev(mj,mn);
+					found = 1;
+				}
+				close(sysfd);
+				sysfd = -1;
+			}
+			if (!found) {
+				sysfd = sysfs_open(fd2devnum(fd), dname, "state");
+				if (sysfd < 0) {
+					fprintf(stderr, Name ": %s does not appear "
+						"to be a component of %s\n",
+						dv->devname, devname);
+					return 1;
+				}
+			}
 		} else {
 			j = 0;
 
@@ -753,6 +790,8 @@ int Manage_subdevs(char *devname, int fd,
 				fprintf(stderr, Name ": Cannot remove disks from a"
 					" \'member\' array, perform this"
 					" operation on the parent container\n");
+				if (sysfd >= 0)
+					close(sysfd);
 				return 1;
 			}
 			if (tst->ss->external) {
@@ -771,6 +810,8 @@ int Manage_subdevs(char *devname, int fd,
 					fprintf(stderr, Name
 						": Cannot get exclusive access "
 						" to container - odd\n");
+					if (sysfd >= 0)
+						close(sysfd);
 					return 1;
 				}
 				/* in the detached case it is not possible to
@@ -778,6 +819,7 @@ int Manage_subdevs(char *devname, int fd,
 				 * rely on the 'detached' checks
 				 */
 				if (strcmp(dv->devname, "detached") == 0 ||
+				    sysfd >= 0 ||
 				    sysfs_unique_holder(dnum, stb.st_rdev))
 					/* pass */;
 				else {
@@ -791,25 +833,37 @@ int Manage_subdevs(char *devname, int fd,
 				}
 			}
 			/* FIXME check that it is a current member */
-			err = ioctl(fd, HOT_REMOVE_DISK, (unsigned long)stb.st_rdev);
-			if (err && errno == ENODEV) {
-				/* Old kernels rejected this if no personality
-				 * registered */
-				struct mdinfo *sra = sysfs_read(fd, 0, GET_DEVS);
-				struct mdinfo *dv = NULL;
-				if (sra)
-					dv = sra->devs;
-				for ( ; dv ; dv=dv->next)
-					if (dv->disk.major == major(stb.st_rdev) &&
-					    dv->disk.minor == minor(stb.st_rdev))
-						break;
-				if (dv)
-					err = sysfs_set_str(sra, dv,
-							    "state", "remove");
-				else
+			if (sysfd >= 0) {
+				/* device has been removed and we don't know
+				 * the major:minor number
+				 */
+				int n = write(sysfd, "remove", 6);
+				if (n != 6)
 					err = -1;
-				if (sra)
-					sysfs_free(sra);
+				else
+					err = 0;
+				close(sysfd);
+			} else {
+				err = ioctl(fd, HOT_REMOVE_DISK, (unsigned long)stb.st_rdev);
+				if (err && errno == ENODEV) {
+					/* Old kernels rejected this if no personality
+					 * registered */
+					struct mdinfo *sra = sysfs_read(fd, 0, GET_DEVS);
+					struct mdinfo *dv = NULL;
+					if (sra)
+						dv = sra->devs;
+					for ( ; dv ; dv=dv->next)
+						if (dv->disk.major == major(stb.st_rdev) &&
+						    dv->disk.minor == minor(stb.st_rdev))
+							break;
+					if (dv)
+						err = sysfs_set_str(sra, dv,
+								    "state", "remove");
+					else
+						err = -1;
+					if (sra)
+						sysfs_free(sra);
+				}
 			}
 			if (err) {
 				fprintf(stderr, Name ": hot remove failed "
@@ -836,19 +890,26 @@ int Manage_subdevs(char *devname, int fd,
 				ping_manager(name);
 				free(name);
 			}
-			close(lfd);
+			if (lfd >= 0)
+				close(lfd);
 			if (verbose >= 0)
-				fprintf(stderr, Name ": hot removed %s\n",
-					dnprintable);
+				fprintf(stderr, Name ": hot removed %s from %s\n",
+					dnprintable, devname);
 			break;
 
 		case 'f': /* set faulty */
 			/* FIXME check current member */
-			if (ioctl(fd, SET_DISK_FAULTY, (unsigned long) stb.st_rdev)) {
+			if ((sysfd >= 0 && write(sysfd, "faulty", 6) != 6) ||
+			    (sysfd < 0 && ioctl(fd, SET_DISK_FAULTY,
+						(unsigned long) stb.st_rdev))) {
 				fprintf(stderr, Name ": set device faulty failed for %s:  %s\n",
 					dnprintable, strerror(errno));
+				if (sysfd >= 0)
+					close(sysfd);
 				return 1;
 			}
+			if (sysfd >= 0)
+				close(sysfd);
 			if (verbose >= 0)
 				fprintf(stderr, Name ": set %s faulty in %s\n",
 					dnprintable, devname);
diff --git a/ReadMe.c b/ReadMe.c
index 9d5a211..b43d1a0 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -213,7 +213,7 @@ char Help[] =
 "       mdadm --grow options device\n"
 "            resize/reshape an active array\n"
 "       mdadm --incremental device\n"
-"            add a device to an array as appropriate\n"
+"            add/remove a device to/from an array as appropriate\n"
 "       mdadm --monitor options...\n"
 "            Monitor one or more array for significant changes.\n"
 "       mdadm device options...\n"
@@ -256,7 +256,7 @@ char OptionHelp[] =
 "  --examine-bitmap -X: Display the detail of a bitmap file\n"
 "  --monitor     -F   : monitor (follow) some arrays\n"
 "  --grow        -G   : resize/ reshape and array\n"
-"  --incremental -I   : add a single device to an array as appropriate\n"
+"  --incremental -I   : add/remove a single device to/from an array as appropriate\n"
 "  --query       -Q   : Display general information about how a\n"
 "                       device relates to the md driver\n"
 "  --auto-detect      : Start arrays auto-detected by the kernel\n"
@@ -535,20 +535,26 @@ char Help_grow[] =
 ;
 
 char Help_incr[] =
-"Usage: mdadm --incremental [-Rqrs] device\n"
+"Usage: mdadm --incremental [-Rqrsf] device\n"
 "\n"
 "This usage allows for incremental assembly of md arrays.  Devices can be\n"
 "added one at a time as they are discovered.  Once an array has all expected\n"
 "devices, it will be started.\n"
 "\n"
-"Options that are valid with incremental assembly (-I --incremental) more are:\n"
-"  --run       -R  : run arrays as soon as a minimal number of devices are\n"
+"Optionally, the process can be reversed by using the fail option.\n"
+"When fail mode is invoked, mdadm will see if the device belongs to an array\n"
+"and then both fail (if needed) and remove the device from that array.\n"
+"\n"
+"Options that are valid with incremental assembly (-I --incremental) are:\n"
+"  --run       -R  : Run arrays as soon as a minimal number of devices are\n"
 "                  : present rather than waiting for all expected.\n"
 "  --quiet     -q  : Don't print any information messages, just errors.\n"
 "  --rebuild   -r  : Rebuild the 'map' file that mdadm uses for tracking\n"
 "                  : partial arrays.\n"
 "  --scan      -s  : Use with -R to start any arrays that have the minimal\n"
 "                  : required number of devices, but are not yet started.\n"
+"  --fail      -f  : First fail (if needed) and then remove device from\n"
+"                  : any array that it is a member of.\n"
 ;
 
 char Help_config[] =
diff --git a/mdadm.8 b/mdadm.8
index 4edfc41..f547fda 100644
--- a/mdadm.8
+++ b/mdadm.8
@@ -136,6 +136,10 @@ This provides a convenient interface to a
 system.  As each device is detected,
 .I mdadm
 has a chance to include it in some array as appropriate.
+Optionally, when the
+.I \-\-fail
+flag is passed in we will remove the device from any active array
+instead of adding it.
 
 If a
 .B CONTAINER
@@ -189,7 +193,7 @@ Change the size or shape of an active array.
 
 .TP
 .BR \-I ", " \-\-incremental
-Add a single device into an appropriate array, and possibly start the array.
+Add/remove a single device to/from an appropriate array, and possibly start the array.
 
 .TP
 .B \-\-auto-detect
@@ -1235,6 +1239,15 @@ in
 .B mdadm.conf
 as requiring an external bitmap, that bitmap will be attached first.
 
+.TP
+.BR \-\-fail ", " \-f
+This allows the hot-plug system to remove devices that have fully disappeared
+from the kernel.  It will first fail and then remove the device from any
+array it belongs to.
+The device name given should be a kernel device name such as "sda",
+not a name in
+.IR /dev .
+
 .SH For Monitor mode:
 .TP
 .BR \-m ", " \-\-mail
@@ -2141,6 +2154,10 @@ Usage:
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
@@ -2153,6 +2170,11 @@ passed to
 .B "mdadm \-\-incremental"
 to be conditionally added to an appropriate array.
 
+Conversely, it can also be used with the
+.B \-\-fail
+flag to do just the opposite and find whatever array a particular device
+is part of and remove the device from that array.
+
 If the device passed is a
 .B CONTAINER
 device created by a previous call to
diff --git a/mdadm.c b/mdadm.c
index d5e34c0..6690546 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -774,6 +774,9 @@ int main(int argc, char *argv[])
 			devmode = 'r';
 			continue;
 		case O(MANAGE,'f'): /* set faulty */
+		case O(INCREMENTAL,'f'): /* r for incremental is taken, use f
+					  * even though we will both fail and
+					  * remove the device */
 			devmode = 'f';
 			continue;
 		case O(INCREMENTAL,'R'):
@@ -1517,6 +1520,11 @@ int main(int argc, char *argv[])
 			 ": --incremental --scan meaningless without --run.\n");
 				break;
 			}
+			if (devmode == 'f') {
+				fprintf(stderr, Name
+			 ": --incremental --scan --fail not supported.\n");
+				break;
+			}
 			rv = IncrementalScan(verbose);
 		}
 		if (!devlist) {
@@ -1533,6 +1541,10 @@ int main(int argc, char *argv[])
 			rv = 1;
 			break;
 		}
+		if (devmode == 'f') {
+			rv = IncrementalRemove(devlist->devname, verbose-quiet);
+			break;
+		}
 		rv = Incremental(devlist->devname, verbose-quiet, runstop,
 				 ss, homehost, require_homehost, autof);
 		break;
diff --git a/mdadm.h b/mdadm.h
index 0386129..2b47ae7 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -353,6 +353,10 @@ struct mdstat_ent {
 	int		raid_disks;
 	int		chunk_size;
 	char *		metadata_version;
+	struct dev_member {
+		char			*name;
+		struct dev_member	*next;
+	} 		*members;
 	struct mdstat_ent *next;
 };
 
@@ -361,6 +365,7 @@ extern void free_mdstat(struct mdstat_ent *ms);
 extern void mdstat_wait(int seconds);
 extern void mdstat_wait_fd(int fd, const sigset_t *sigmask);
 extern int mddev_busy(int devnum);
+extern struct mdstat_ent *mdstat_by_component(char *name);
 
 struct map_ent {
 	struct map_ent *next;
@@ -815,7 +820,7 @@ extern int Incremental_container(struct supertype *st, char *devname,
 				 int trustworthy);
 extern void RebuildMap(void);
 extern int IncrementalScan(int verbose);
-
+extern int IncrementalRemove(char *devname, int verbose);
 extern int CreateBitmap(char *filename, int force, char uuid[16],
 			unsigned long chunksize, unsigned long daemon_sleep,
 			unsigned long write_behind,
diff --git a/mdstat.c b/mdstat.c
index 4a9f370..58d349d 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -83,14 +83,41 @@
 #include	<sys/select.h>
 #include	<ctype.h>
 
+static void free_member_devnames(struct dev_member *m)
+{
+	while(m) {
+		struct dev_member *t = m;
+
+		m = m->next;
+		free(t->name);
+		free(t);
+	}
+}
+
+static void add_member_devname(struct dev_member **m, char *name)
+{
+	struct dev_member *new;
+	char *t;
+
+	if ((t = strchr(name, '[')) == NULL)
+		/* not a device */
+		return;
+
+	new = malloc(sizeof(*new));
+	new->name = strndup(name, t - name);
+	new->next = *m;
+	*m = new;
+}
+
 void free_mdstat(struct mdstat_ent *ms)
 {
 	while (ms) {
 		struct mdstat_ent *t;
-		if (ms->dev) free(ms->dev);
-		if (ms->level) free(ms->level);
-		if (ms->pattern) free(ms->pattern);
-		if (ms->metadata_version) free(ms->metadata_version);
+		free(ms->dev);
+		free(ms->level);
+		free(ms->pattern);
+		free(ms->metadata_version);
+		free_member_devnames(ms->members);
 		t = ms;
 		ms = ms->next;
 		free(t);
@@ -159,6 +186,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 		ent->raid_disks = 0;
 		ent->chunk_size = 0;
 		ent->devcnt = 0;
+		ent->members = NULL;
 
 		ent->dev = strdup(line);
 		ent->devnum = devnum;
@@ -168,9 +196,10 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 			char *eq;
 			if (strcmp(w, "active")==0)
 				ent->active = 1;
-			else if (strcmp(w, "inactive")==0)
+			else if (strcmp(w, "inactive")==0) {
 				ent->active = 0;
-			else if (ent->active >=0 &&
+				in_devs = 1;
+			} else if (ent->active > 0 &&
 				 ent->level == NULL &&
 				 w[0] != '(' /*readonly*/) {
 				ent->level = strdup(w);
@@ -179,6 +208,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 				in_devs = 0;
 			else if (in_devs) {
 				ent->devcnt++;
+				add_member_devname(&ent->members, w);
 				if (strncmp(w, "md", 2)==0) {
 					/* This has an md device as a component.
 					 * If that device is already in the
@@ -310,3 +340,30 @@ int mddev_busy(int devnum)
 	free_mdstat(mdstat);
 	return me != NULL;
 }
+
+struct mdstat_ent *mdstat_by_component(char *name)
+{
+	struct mdstat_ent *mdstat = mdstat_read(0, 0);
+
+	while (mdstat) {
+		struct dev_member *m;
+		struct mdstat_ent *ent;
+		if (ent->metadata_version &&
+		    strncmp(ent->metadata_version, "external:", 9) == 0	 &&
+		    is_subarray(ent->metadata_version+9))
+			/* don't return subarrays, only containers */
+			;
+		else for (m = mdstat->members; m; m = m->next) {
+				if (strcmp(m->name, name) == 0) {
+					free_mdstat(mdstat->next);
+					mdstat->next = NULL;
+					return mdstat;
+				}
+			}
+		ent = mdstat;
+		mdstat = mdstat->next;
+		ent->next = NULL;
+		free_mdstat(ent);
+	}
+	return NULL;
+}
diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index c9a4f0e..da52058 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -1,13 +1,13 @@
 # do not edit this file, it will be overwritten on update
 
 SUBSYSTEM!="block", GOTO="md_end"
-ACTION!="add|change", GOTO="md_end"
-ACTION=="change", GOTO="md_no_incr"
 
-# import data from a raid member and activate it
-#ENV{ID_FS_TYPE}=="linux_raid_member", IMPORT{program}="/sbin/mdadm --examine --export $tempnode", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
-# import data from a raid set
-LABEL="md_no_incr"
+# handle potential components of arrays
+ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
+
+# handle md arrays
+ACTION!="add|change", GOTO="md_end"
 KERNEL!="md*", GOTO="md_end"
 
 # partitions have no md/{array_state,metadata_version}, but should not
