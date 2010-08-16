From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 04/35] Support for new disk hot plug actions with DOMAINs.
Date: Mon, 16 Aug 2010 10:41:39 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9B7@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From f99e1fb333d3a95dc1e50c076aefe1928b746d29 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 28 May 2010 14:19:38 +0200
Subject: [PATCH 04/35] Support for new disk hot plug actions with DOMAINs.

  Nowhere near complete, just the initial stages.
  Added support for the call to mdadm.c, some
  sanity checks, helper functions, etc.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 Incremental.c |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 config.c      |    5 +-
 mdadm.c       |   32 ++++++++++++--
 mdadm.h       |    5 ++
 util.c        |   24 ++++++++++
 5 files changed, 189 insertions(+), 8 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index a99811d..d1d9ee1 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -35,6 +35,10 @@ static int count_active(struct supertype *st, int mdfd, char **availp,
 static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
 			int number, __u64 events, int verbose,
 			char *array_name);
+static int IncrementalNewPart(char *devname, int verbose, int export,
+			      struct domain_ent *domain);
+static int IncrementalNewDisk(char *devname, int verbose, int export,
+			      struct domain_ent *domain);
 
 int Incremental(char *devname, int verbose, int runstop,
 		struct supertype *st, char *homehost, int require_homehost,
@@ -888,3 +892,130 @@ int IncrementalRemove(char *devname, int verbose)
 	devlist.disposition = 'r';
 	return Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
 }
+
+/*
+ * IncrementalNewPart - We have a partition or a whole disk device, and we
+ * have a domain that says not to partition the device, so we will either
+ * use the whole disk or the partition directly.
+ */
+static int IncrementalNewPart(char *devname, int verbose, int export,
+			      struct domain_ent *domain)
+{
+	struct mdstat_ent *mdstat, *md;
+	struct stat stb;
+	int dfd;
+
+	mdstat = arrays_in_domain(devname, domain);
+	for (md = mdstat; md; md = md->next)
+		printf(Name ": %s\n", md->dev);
+	/* We've finished with the easy tests that allow us to kick drives
+	 * out without touching actual physical media, now we need to start
+	 * the slower checks.
+	 */
+	dfd = dev_open_check(devname, O_RDONLY|O_EXCL, &stb);
+	if (dfd < 0) 
+		return 1;
+	if (guess_super(dfd) != NULL) {
+		/* This won't happen with our udev rules, but someone might
+		 * try this by hand, make them use normal incremental mode
+		 * instead if the device has a superblock already */
+		fprintf(stderr, Name ": superblock present on %s.\n", devname);
+		close(dfd);
+		return 1;
+	}
+	/*
+	 * OK, at this point we have a valid block device without a
+	 * superblock.  If we aren't in force mode, then don't use the
+	 * device unless it's "clean", meaning no filesystems, no lvm,
+	 * no anything.  The requirement here is that both the first and
+	 * last 4k of the device must be one of three patterns: 0x00, 0x5a,
+	 * or 0xff.
+	 */
+
+	return 0;
+}
+
+/*
+ * IncrementalNewDisk - We have a whole disk device, and we have a domain
+ * that says to partition the disk.  However, we will get called whether
+ * the partition is the correct partition or not, so we need to skip devs
+ * that already have the right partition and partition bare devs or 
+ * repartition devs with stuff already on them only if the force option
+ * is present on our domain.
+ */
+static int IncrementalNewDisk(char *devname, int verbose, int export,
+			      struct domain_ent *domain)
+{
+	struct stat stb;
+	int dfd;
+
+	dfd = dev_open_check(devname, O_RDONLY|O_EXCL, &stb);
+	if (dfd < 0) 
+		return 1;
+	if (guess_super(dfd) != NULL) {
+		/* This won't happen with our udev rules, but someone might
+		 * try this by hand, make them use normal incremental mode
+		 * instead if the device has a superblock already */
+		fprintf(stderr, Name ": superblock present on %s.\n", devname);
+		close(dfd);
+		return 1;
+	}
+	/*
+	 * OK, at this point we have a valid block device without a
+	 * superblock.  If we aren't in force mode, then don't use the
+	 * device unless it's "clean", meaning no filesystems, no lvm,
+	 * no anything.  The requirement here is that both the first and
+	 * last 4k of the device must be one of three patterns: 0x00, 0x5a,
+	 * or 0xff.
+	 */
+
+	return 0;
+}
+
+/*
+ * IncrementalNew - We've got a device that doesn't appear to have any
+ * current existing raid superblock on it, check to see if we should be
+ * claiming it based on DOMAIN entries in the config file.
+ *
+ * @devname - The device to investigate
+ *
+ * Special note: if we have partitioned devices, the whole disk device is
+ * going to get called into this code, we need to detect that the device
+ * is already in use and leave it be, where as if we get a truly new
+ * device we may need to partition it and set it up for the partitions to
+ * be added to various arrays later on in the hot plug process.
+ */
+int IncrementalNew(char *devname, int verbose, int export)
+{
+	struct domain_ent *domain;
+	char *devpath;
+	int rv;
+
+	domain = conf_get_domain(devname);
+	if (!domain)
+		return 0;
+	if (action(domain) <= incremental)
+		/* Nothing to do.  We only get called in the case that there
+		 * is no current superblock on the device in question, and
+		 * since our matching domain says we should either ignore or
+		 * use devices incrementally, they have to already have a
+		 * superblock.  Since we don't, we're done.
+		 */
+		return 0;
+	devpath = get_devpath_from_devname(devname);
+	if (strstr(devpath, "part") || action(domain) != partition)
+		/* We are on a partition, not a whole disk, or we are on a
+		 * whole disk but we want to use the whole disk instead
+		 * of partitioning it */
+		rv = IncrementalNewPart(devname, verbose, export, domain);
+	else
+		/* Only use this if we are dealing with a disk that would
+		 * need partitioned.  This will get called even when our
+		 * disk actually already belongs to all the right arrays
+		 * and there is nothing to be done, so only do work here
+		 * if we really need to */
+		rv = IncrementalNewDisk(devname, verbose, export, domain);
+	free(devpath);
+	return rv;
+}
+
diff --git a/config.c b/config.c
index 10c10e2..bd80cd6 100644
--- a/config.c
+++ b/config.c
@@ -810,8 +810,7 @@ void domainline(char *line)
 		}
 	}
 	/* Some sanity checks now that all the options are parsed */
-	if ((de->action & force) &&
-	    ((de->action & action_mask) <= incremental)) {
+	if (force(de) && (action(de) <= incremental)) {
 		fprintf(stderr, Name ": force makes no sense with ignore or "
 			"incremental, removing.\n");
 		de->action &= action_mask;
@@ -822,7 +821,7 @@ void domainline(char *line)
 		free(de->spare_group);
 		de->spare_group = NULL;
 	}
-	if ((de->action & action_mask) == partition) {
+	if (action(de) == partition) {
 		for (prev_path = NULL, path = de->paths; path; )
 			if ((strstr(path->path, "part") != NULL) ||
 			    (path->path[strlen(path->path) - 1] == '*')) {
diff --git a/mdadm.c b/mdadm.c
index 770fdfd..a111b47 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -73,6 +73,7 @@ int main(int argc, char *argv[])
 	int test = 0;
 	int export = 0;
 	int assume_clean = 0;
+	int new_disk = 0;
 	char *symlinks = NULL;
 	/* autof indicates whether and how to create device node.
 	 * bottom 3 bits are style.  Rest (when shifted) are number of parts
@@ -909,6 +910,9 @@ int main(int argc, char *argv[])
 		case O(INCREMENTAL, 'r'):
 			rebuild_map = 1;
 			continue;
+		case O(INCREMENTAL, 'g'):
+			new_disk = 1;
+			continue;
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
@@ -1513,6 +1517,11 @@ int main(int argc, char *argv[])
 		if (rebuild_map) {
 			RebuildMap();
 		}
+		if (export && !new_disk) {
+			fprintf(stderr, Name
+		 ": --incremental --export only supported with --grab.\n");
+			break;
+		}
 		if (scan) {
 			if (runstop <= 0) {
 				fprintf(stderr, Name
@@ -1524,8 +1533,18 @@ int main(int argc, char *argv[])
 			 ": --incremental --scan --fail not supported.\n");
 				break;
 			}
+			if (new_disk > 0) {
+				fprintf(stderr, Name
+			 ": --incremental --scan --grab not supported.\n");
+				break;
+			}
 			rv = IncrementalScan(verbose);
 		}
+		if (devmode == 'f' && new_disk) {
+			fprintf(stderr, Name
+		 ": --incremental --fail --grab makes no sense.\n");
+			break;
+		}
 		if (!devlist) {
 			if (!rebuild_map && !scan) {
 				fprintf(stderr, Name
@@ -1540,12 +1559,15 @@ int main(int argc, char *argv[])
 			rv = 1;
 			break;
 		}
-		if (devmode == 'f') {
+		if (devmode == 'f')
 			rv = IncrementalRemove(devlist->devname, verbose-quiet);
-			break;
-		}
-		rv = Incremental(devlist->devname, verbose-quiet, runstop,
-				 ss, homehost, require_homehost, autof);
+		else if (new_disk > 0)
+			rv = IncrementalNew(devlist->devname, verbose-quiet,
+					    export);
+		else
+			rv = Incremental(devlist->devname, verbose-quiet,
+					 runstop, ss, homehost,
+					 require_homehost, autof);
 		break;
 	case AUTODETECT:
 		autodetect();
diff --git a/mdadm.h b/mdadm.h
index 4d5a630..3862853 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -292,6 +292,9 @@ enum domain_actions {
 		      other metadata on them */
 };
 
+#define action(domain) ((domain)->action & action_mask)
+#define force(domain) ((domain)->action & force)
+
 struct domain_ent {
 	char			*spare_group; /* only set this in monitor mode
 						 when we know what arrays we
@@ -854,6 +857,7 @@ extern int Incremental_container(struct supertype *st, char *devname,
 extern void RebuildMap(void);
 extern int IncrementalScan(int verbose);
 extern int IncrementalRemove(char *devname, int verbose);
+extern int IncrementalNew(char *devname, int verbose, int export);
 extern int CreateBitmap(char *filename, int force, char uuid[16],
 			unsigned long chunksize, unsigned long daemon_sleep,
 			unsigned long write_behind,
@@ -876,6 +880,7 @@ extern int check_partitions(int fd, char *dname, unsigned long long freesize);
 
 extern int get_mdp_major(void);
 extern int dev_open(char *dev, int flags);
+extern int dev_open_check(char *dev, int flags, struct stat *stb);
 extern int open_dev(int devnum);
 extern int open_dev_excl(int devnum);
 extern int is_standard(char *dev, int *nump);
diff --git a/util.c b/util.c
index 1793b68..b93e21d 100644
--- a/util.c
+++ b/util.c
@@ -975,6 +975,30 @@ int dev_open(char *dev, int flags)
 	return fd;
 }
 
+int dev_open_check(char *devname, int flags, struct stat *stb)
+{
+	int dfd;
+
+	dfd = dev_open(devname, flags);
+	if (dfd < 0) {
+		fprintf(stderr, Name ": cannot open %s: %s.\n",
+			devname, strerror(errno));
+		return -1;
+	}
+	if (fstat(dfd, stb) < 0) {
+		fprintf(stderr, Name ": fstat failed on %s: %s.\n",
+			devname, strerror(errno));
+		close(dfd);
+		return -1;
+	}
+	if ((stb->st_mode & S_IFMT) != S_IFBLK) {
+		fprintf(stderr, Name ": %s is not a block device.\n", devname);
+		close(dfd);
+		return -1;
+	}
+	return dfd;
+}
+
 int open_dev(int devnum)
 {
 	char buf[20];
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

