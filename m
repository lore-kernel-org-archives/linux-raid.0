From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 07/17] prepare for enclosure platform details
Date: Tue, 1 Dec 2015 16:25:23 -0800
Message-ID: <1449015933-255689-8-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@localhost.localdomain>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@localhost.localdomain>

Make platform description entry points independent of the superswitch
for platform details like enclosures that have no metadata ties.  This
allows generically looping through a list of platform_detail operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Create.c      |  2 +-
 Detail.c      | 59 ++++++++++++++++++++++++++++-------------------------------
 mdadm.c       |  9 ++++++++-
 mdadm.h       | 19 ++++++++++++++++---
 super-intel.c |  8 ++++++--
 util.c        |  6 ++++++
 6 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/Create.c b/Create.c
index 2642b36..fda7f67 100644
--- a/Create.c
+++ b/Create.c
@@ -535,7 +535,7 @@ int Create(struct supertype *st, char *mddev,
 		warn = 1;
 	}
 
-	if (st->ss->detail_platform && st->ss->detail_platform(0, 1, NULL) != 0) {
+	if (st->ss->platform && st->ss->platform->detail(0, 1, NULL) != 0) {
 		if (c->runstop != 1 || c->verbose >= 0)
 			pr_err("%s unable to enumerate platform support\n"
 				"    array may not be compatible with hardware/firmware\n",
diff --git a/Detail.c b/Detail.c
index 200f65f..f71afb9 100644
--- a/Detail.c
+++ b/Detail.c
@@ -717,47 +717,44 @@ out:
 	return rv;
 }
 
-int Detail_Platform(struct superswitch *ss, int scan, int verbose, int export, char *controller_path)
+int Detail_Platform(const struct platform_ops *platform, int scan, int verbose, int export, char *controller_path)
 {
-	/* display platform capabilities for the given metadata format
-	 * 'scan' in this context means iterate over all metadata types
+	/* display platform capabilities
+	 * 'scan' in this context means iterate over all platform types
 	 */
-	int i;
-	int err = 1;
-
-	if (ss && export && ss->export_detail_platform)
-		err = ss->export_detail_platform(verbose, controller_path);
-	else if (ss && ss->detail_platform)
-		err = ss->detail_platform(verbose, 0, controller_path);
-	else if (ss) {
+	struct platform_ops const **p;
+	int err = 0;
+
+	if (platform && verbose > 0)
+		pr_err("checking for %s platform components\n",
+			platform->name);
+
+	if (platform && export)
+		err = platform->export_detail(verbose, controller_path);
+	else if (platform)
+		err = platform->detail(verbose, 0, controller_path);
+	else if (!scan) {
 		if (verbose > 0)
-			pr_err("%s metadata is platform independent\n",
-				ss->name ? : "[no name]");
-	} else if (!scan) {
-		if (verbose > 0)
-			pr_err("specify a metadata type or --scan\n");
+			pr_err("no platform components found\n");
 	}
 
 	if (!scan)
 		return err;
 
-	err = 0;
-	for (i = 0; superlist[i]; i++) {
-		struct superswitch *meta = superlist[i];
-
-		if (meta == ss)
+	for (p = platform_list; p; p++) {
+		/* enumerated above */
+		if (*p == platform)
 			continue;
+
 		if (verbose > 0)
-			pr_err("checking metadata %s\n",
-				meta->name ? : "[no name]");
-		if (!meta->detail_platform) {
-			if (verbose > 0)
-				pr_err("%s metadata is platform independent\n",
-					meta->name ? : "[no name]");
-		} else if (export && meta->export_detail_platform) {
-			err |= meta->export_detail_platform(verbose, controller_path);
-		} else
-			err |= meta->detail_platform(verbose, 0, controller_path);
+			pr_err("checking for %s platform components\n",
+				(*p)->name);
+
+		if (export)
+			err |= (*p)->export_detail(verbose, controller_path);
+		else
+			err |= (*p)->detail(verbose, 0, controller_path);
+
 	}
 
 	return err;
diff --git a/mdadm.c b/mdadm.c
index f56a8cf..98ef898 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1492,7 +1492,14 @@ int main(int argc, char *argv[])
 			}
 			rv = Examine(devlist, &c, ss);
 		} else if (devmode == DetailPlatform) {
-			rv = Detail_Platform(ss ? ss->ss : NULL, ss ? c.scan : 1,
+			const struct platform_ops *platform;
+
+			if (ss)
+				platform = ss->ss->platform;
+			else
+				platform = NULL;
+
+			rv = Detail_Platform(platform, platform ? c.scan : 1,
 					     c.verbose, c.export,
 					     devlist ? devlist->devname : NULL);
 		} else if (devlist == NULL) {
diff --git a/mdadm.h b/mdadm.h
index 167ca0c..f3b24b3 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -687,6 +687,17 @@ struct reshape {
 	unsigned long long new_size; /* New size of array in sectors */
 };
 
+/* Platform details describe hardware / firmware capabilites and
+ * limitations.  They can be tied to a metadata format.  For example,
+ * system firmware with a set of raid capabilities and expected
+ * controller, or describe the topology disk enclosures.
+ */
+extern const struct platform_ops {
+	int (*detail)(int verbose, int enumerate_only, char *hwdevice);
+	int (*export_detail)(int verbose, char *hwdevice);
+	char *name;
+} *platform_list[];
+
 /* A superswitch provides entry point the a metadata handler.
  *
  * The superswitch primarily operates on some "metadata" that
@@ -734,8 +745,7 @@ extern struct superswitch {
 	void (*export_detail_super)(struct supertype *st);
 
 	/* Optional: platform hardware / firmware details */
-	int (*detail_platform)(int verbose, int enumerate_only, char *controller_path);
-	int (*export_detail_platform)(int verbose, char *controller_path);
+	const struct platform_ops *platform;
 
 	/* Used:
 	 *   to get uuid to storing in bitmap metadata
@@ -1008,6 +1018,8 @@ extern struct superswitch super0, super1;
 extern struct superswitch super_imsm, super_ddf;
 extern struct superswitch mbr, gpt;
 
+extern const struct platform_ops imsm_platform;
+
 struct metadata_update {
 	int	len;
 	char	*buf;
@@ -1263,7 +1275,8 @@ extern int Create(struct supertype *st, char *mddev,
 		  unsigned long long data_offset);
 
 extern int Detail(char *dev, struct context *c);
-extern int Detail_Platform(struct superswitch *ss, int scan, int verbose, int export, char *controller_path);
+extern int Detail_Platform(const struct platform_ops *platform, int scan, int verbose,
+			   int export, char *controller_path);
 extern int Query(char *dev);
 extern int ExamineBadblocks(char *devname, int brief, struct supertype *forcest);
 extern int Examine(struct mddev_dev *devlist, struct context *c,
diff --git a/super-intel.c b/super-intel.c
index 330b24f..53a9238 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10606,6 +10606,11 @@ abort:
 	return ret_val;
 }
 
+const struct platform_ops imsm_platform = {
+	.detail = detail_platform_imsm,
+	.export_detail = export_detail_platform_imsm,
+	.name = "imsm",
+};
 #endif /* MDASSEMBLE */
 
 struct superswitch super_imsm = {
@@ -10620,8 +10625,6 @@ struct superswitch super_imsm = {
 	.validate_geometry = validate_geometry_imsm,
 	.add_to_super	= add_to_super_imsm,
 	.remove_from_super = remove_from_super_imsm,
-	.detail_platform = detail_platform_imsm,
-	.export_detail_platform = export_detail_platform_imsm,
 	.kill_subarray = kill_subarray_imsm,
 	.update_subarray = update_subarray_imsm,
 	.load_container	= load_container_imsm,
@@ -10631,6 +10634,7 @@ struct superswitch super_imsm = {
 	.manage_reshape = imsm_manage_reshape,
 	.recover_backup = recover_backup_imsm,
 	.copy_metadata = copy_metadata_imsm,
+	.platform = &imsm_platform,
 #endif
 	.match_home	= match_home_imsm,
 	.uuid_from_super= uuid_from_super_imsm,
diff --git a/util.c b/util.c
index 8217e11..e81c45d 100644
--- a/util.c
+++ b/util.c
@@ -1147,6 +1147,12 @@ struct superswitch *superlist[] =
 
 #if !defined(MDASSEMBLE) || defined(MDASSEMBLE) && defined(MDASSEMBLE_AUTO)
 
+const struct platform_ops *platform_list[] =
+{
+	&imsm_platform,
+	NULL,
+};
+
 struct supertype *super_by_fd(int fd, char **subarrayp)
 {
 	mdu_array_info_t array;
-- 
2.4.6

