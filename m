Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8CFC74A5B
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 16:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjCWQut (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjCWQus (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 12:50:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF74527F
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 09:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679590246; x=1711126246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QMx9xR3K1JL0OYGR3gumwHeFPQ5Qc9ljQ0PymQGs1Dw=;
  b=iCEAHNg+BQ6QSdAejs7zdHoD8ArmF0fIUt1YwNzCwyK+EXrz+9pGVKWm
   gIPGbNLpKW+0n1DLMyO7Z62r9vNfwt7U1RxiozbxEUn9SqUYCByQnEjJy
   5wCUiVx54gVYom2+eZ9EGo8ngEoozYqBbAtolx5bVeyM1U2altApbYiO4
   2LyWHiaU+giHDkDAZCIj+yI0/WcIxKGR98wob97bFwXy21tiYiYa64Ius
   Lh547UVwhIOCNI4+kDap1QjjCSh49n0UNFPpEDujxUaGRwx8dcX1KXSJq
   wsF1lm7i9koTGD+y2l65Gx4OXy09m0BOV78jRjs0fCUEBWPByOxGCxtph
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="339588420"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="339588420"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="682374190"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="682374190"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:50:44 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH 1/4] mdadm: define DEV_MD_DIR
Date:   Thu, 23 Mar 2023 17:50:14 +0100
Message-Id: <20230323165017.27121-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
References: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It is used many times. Additionally define _LEN to avoid repeated
strlen() calls when length is needed.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Create.c      |  7 +++----
 Detail.c      |  9 ++++-----
 Incremental.c |  4 ++--
 Monitor.c     | 32 ++++++++++++++++++--------------
 config.c      | 10 +++++-----
 lib.c         |  2 +-
 mapfile.c     | 12 ++++++------
 mdadm.h       |  8 ++++++++
 mdopen.c      |  6 +++---
 super-ddf.c   |  2 +-
 super-intel.c |  2 +-
 super1.c      |  3 +--
 sysfs.c       |  2 +-
 13 files changed, 54 insertions(+), 45 deletions(-)

diff --git a/Create.c b/Create.c
index bbe9e13d..f3a02a2e 100644
--- a/Create.c
+++ b/Create.c
@@ -1029,10 +1029,9 @@ int Create(struct supertype *st, char *mddev,
 	 * it could be in conflict with already existing device
 	 * e.g. container, array
 	 */
-	if (strncmp(chosen_name, "/dev/md/", 8) == 0 &&
-	    map_by_name(&map, chosen_name+8) != NULL) {
-		pr_err("Array name %s is in use already.\n",
-			chosen_name);
+	if (strncmp(chosen_name, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0 &&
+	    map_by_name(&map, chosen_name + DEV_MD_DIR_LEN)) {
+		pr_err("Array name %s is in use already.\n", chosen_name);
 		close(mdfd);
 		map_unlock(&map);
 		udev_unblock();
diff --git a/Detail.c b/Detail.c
index 4ef26460..206d88e3 100644
--- a/Detail.c
+++ b/Detail.c
@@ -254,10 +254,9 @@ int Detail(char *dev, struct context *c)
 			fname_from_uuid(st, info, nbuf, ':');
 			printf("MD_UUID=%s\n", nbuf + 5);
 			mp = map_by_uuid(&map, info->uuid);
-			if (mp && mp->path &&
-			    strncmp(mp->path, "/dev/md/", 8) == 0) {
+			if (mp && mp->path && strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0) {
 				printf("MD_DEVNAME=");
-				print_escape(mp->path + 8);
+				print_escape(mp->path + DEV_MD_DIR_LEN);
 				putchar('\n');
 			}
 
@@ -273,9 +272,9 @@ int Detail(char *dev, struct context *c)
 				printf("MD_UUID=%s\n", nbuf+5);
 			}
 			if (mp && mp->path &&
-			    strncmp(mp->path, "/dev/md/", 8) == 0) {
+			    strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0) {
 				printf("MD_DEVNAME=");
-				print_escape(mp->path+8);
+				print_escape(mp->path + DEV_MD_DIR_LEN);
 				putchar('\n');
 			}
 			map_free(map);
diff --git a/Incremental.c b/Incremental.c
index 09b94b9f..b3dc499a 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -460,8 +460,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 			info.array.working_disks ++;
 
 	}
-	if (strncmp(chosen_name, "/dev/md/", 8) == 0)
-		md_devname = chosen_name+8;
+	if (strncmp(chosen_name, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
+		md_devname = chosen_name + DEV_MD_DIR_LEN;
 	else
 		md_devname = chosen_name;
 	if (c->export) {
diff --git a/Monitor.c b/Monitor.c
index 44918184..3273f2fb 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -36,9 +36,18 @@
 #define EVENT_NAME_MAX 32
 #define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
 
+/**
+ * struct state - external array or container properties.
+ * @devname: has length of %DEV_MD_DIR + device name + terminating byte
+ * @devnm: to sync with mdstat info
+ * @parent_devnm: or subarray, devnm of parent, for others, ""
+ * @subarray: for a container it is a link to first subarray, for a subarray it is a link to next
+ *	      subarray in the same container
+ * @parent: for a subarray it is a link to its container
+ */
 struct state {
-	char devname[MD_NAME_MAX + sizeof("/dev/md/")];	/* length of "/dev/md/" + device name + terminating byte*/
-	char devnm[MD_NAME_MAX];	/* to sync with mdstat info */
+	char devname[MD_NAME_MAX + sizeof(DEV_MD_DIR)];
+	char devnm[MD_NAME_MAX];
 	unsigned int utime;
 	int err;
 	char *spare_group;
@@ -49,15 +58,10 @@ struct state {
 	int devstate[MAX_DISKS];
 	dev_t devid[MAX_DISKS];
 	int percent;
-	char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of parent.
-					* For others, ""
-					*/
+	char parent_devnm[MD_NAME_MAX];
 	struct supertype *metadata;
-	struct state *subarray;/* for a container it is a link to first subarray
-				* for a subarray it is a link to next subarray
-				* in the same container */
-	struct state *parent;  /* for a subarray it is a link to its container
-				*/
+	struct state *subarray;
+	struct state *parent;
 	struct state *next;
 };
 
@@ -252,8 +256,8 @@ int Monitor(struct mddev_dev *devlist,
 				continue;
 
 			st = xcalloc(1, sizeof *st);
-			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"),
-				 "/dev/md/%s", basename(mdlist->devname));
+			snprintf(st->devname, MD_NAME_MAX + sizeof(DEV_MD_DIR), DEV_MD_DIR "%s",
+				 basename(mdlist->devname));
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -274,7 +278,7 @@ int Monitor(struct mddev_dev *devlist,
 
 			st = xcalloc(1, sizeof *st);
 			mdlist = conf_get_ident(dv->devname);
-			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"), "%s", dv->devname);
+			snprintf(st->devname, MD_NAME_MAX + sizeof(DEV_MD_DIR), "%s", dv->devname);
 			st->next = statelist;
 			st->devnm[0] = 0;
 			st->percent = RESYNC_UNKNOWN;
@@ -942,7 +946,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist)
 				continue;
 			}
 
-			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"), "%s", name);
+			snprintf(st->devname, MD_NAME_MAX + sizeof(DEV_MD_DIR), "%s", name);
 			if ((fd = open(st->devname, O_RDONLY)) < 0 ||
 			    md_get_array_info(fd, &array) < 0) {
 				/* no such array */
diff --git a/config.c b/config.c
index eeedd0c6..59d5bfb6 100644
--- a/config.c
+++ b/config.c
@@ -405,7 +405,7 @@ void arrayline(char *line)
 			 *  or anything that doesn't start '/' or '<'
 			 */
 			if (strcasecmp(w, "<ignore>") == 0 ||
-			    strncmp(w, "/dev/md/", 8) == 0 ||
+			    strncmp(w, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0 ||
 			    (w[0] != '/' && w[0] != '<') ||
 			    (strncmp(w, "/dev/md", 7) == 0 &&
 			     is_number(w + 7)) ||
@@ -1102,13 +1102,13 @@ int devname_matches(char *name, char *match)
 	 *  mdNN with NN
 	 * then just strcmp
 	 */
-	if (strncmp(name, "/dev/md/", 8) == 0)
-		name += 8;
+	if (strncmp(name, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
+		name += DEV_MD_DIR_LEN;
 	else if (strncmp(name, "/dev/", 5) == 0)
 		name += 5;
 
-	if (strncmp(match, "/dev/md/", 8) == 0)
-		match += 8;
+	if (strncmp(match, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0)
+		match += DEV_MD_DIR_LEN;
 	else if (strncmp(match, "/dev/", 5) == 0)
 		match += 5;
 
diff --git a/lib.c b/lib.c
index e395b28d..65ea51e0 100644
--- a/lib.c
+++ b/lib.c
@@ -313,7 +313,7 @@ char *map_dev_preferred(int major, int minor, int create,
 
 	for (p = devlist; p; p = p->next)
 		if (p->major == major && p->minor == minor) {
-			if (strncmp(p->name, "/dev/md/",8) == 0 ||
+			if (strncmp(p->name, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0 ||
 			    (prefer && strstr(p->name, prefer))) {
 				if (preferred == NULL ||
 				    strlen(p->name) < strlen(preferred))
diff --git a/mapfile.c b/mapfile.c
index ac351768..34fea179 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -320,9 +320,9 @@ struct map_ent *map_by_name(struct map_ent **map, char *name)
 	for (mp = *map ; mp ; mp = mp->next) {
 		if (!mp->path)
 			continue;
-		if (strncmp(mp->path, "/dev/md/", 8) != 0)
+		if (strncmp(mp->path, DEV_MD_DIR, DEV_MD_DIR_LEN) != 0)
 			continue;
-		if (strcmp(mp->path+8, name) != 0)
+		if (strcmp(mp->path + DEV_MD_DIR_LEN, name) != 0)
 			continue;
 		if (!mddev_busy(mp->devnm)) {
 			mp->bad = 1;
@@ -413,7 +413,7 @@ void RebuildMap(void)
 			devid = devnm2devid(md->devnm);
 			path = map_dev(major(devid), minor(devid), 0);
 			if (path == NULL ||
-			    strncmp(path, "/dev/md/", 8) != 0) {
+			    strncmp(path, DEV_MD_DIR, DEV_MD_DIR_LEN) != 0) {
 				/* We would really like a name that provides
 				 * an MD_DEVNAME for udev.
 				 * The name needs to be unique both in /dev/md/
@@ -434,7 +434,7 @@ void RebuildMap(void)
 				if (match && match->devname && match->devname[0] == '/') {
 					path = match->devname;
 					if (path[0] != '/') {
-						strcpy(namebuf, "/dev/md/");
+						strcpy(namebuf, DEV_MD_DIR);
 						strcat(namebuf, path);
 						path = namebuf;
 					}
@@ -478,10 +478,10 @@ void RebuildMap(void)
 
 					while (conflict) {
 						if (unum >= 0)
-							sprintf(namebuf, "/dev/md/%s%s%d",
+							sprintf(namebuf, DEV_MD_DIR "%s%s%d",
 								name, sep, unum);
 						else
-							sprintf(namebuf, "/dev/md/%s",
+							sprintf(namebuf, DEV_MD_DIR "%s",
 								name);
 						unum++;
 						if (lstat(namebuf, &stb) != 0 &&
diff --git a/mdadm.h b/mdadm.h
index b9127f9a..cb644fd8 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -100,6 +100,14 @@ struct dlm_lksb {
 #define DEFAULT_BITMAP_DELAY 5
 #define DEFAULT_MAX_WRITE_BEHIND 256
 
+/* DEV_MD_DIR points to named MD devices directory.
+ * DEV_MD_DIR_LEN is a length with Null byte excluded.
+ */
+#ifndef DEV_MD_DIR
+#define DEV_MD_DIR "/dev/md/"
+#define DEV_MD_DIR_LEN (sizeof(DEV_MD_DIR) - 1)
+#endif /* DEV_MD_DIR */
+
 /* MAP_DIR should be somewhere that persists across the pivotroot
  * from early boot to late boot.
  * /run  seems to have emerged as the best standard.
diff --git a/mdopen.c b/mdopen.c
index d18c9319..ed86df60 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -188,12 +188,12 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	parts = autof >> 3;
 	autof &= 7;
 
-	strcpy(chosen, "/dev/md/");
+	strcpy(chosen, DEV_MD_DIR);
 	cname = chosen + strlen(chosen);
 
 	if (dev) {
-		if (strncmp(dev, "/dev/md/", 8) == 0) {
-			strcpy(cname, dev+8);
+		if (strncmp(dev, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0) {
+			strcpy(cname, dev + DEV_MD_DIR_LEN);
 		} else if (strncmp(dev, "/dev/", 5) == 0) {
 			char *e = dev + strlen(dev);
 			while (e > dev && isdigit(e[-1]))
diff --git a/super-ddf.c b/super-ddf.c
index b86c6acd..7213284e 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1648,7 +1648,7 @@ static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
 		fname_from_uuid(st, &info, nbuf1, ':');
 		_ddf_array_name(namebuf, ddf, i);
 		printf("ARRAY%s%s container=%s member=%d UUID=%s\n",
-		       namebuf[0] == '\0' ? "" : " /dev/md/", namebuf,
+		       namebuf[0] == '\0' ? "" : " " DEV_MD_DIR, namebuf,
 		       nbuf+5, i, nbuf1+5);
 	}
 }
diff --git a/super-intel.c b/super-intel.c
index e155a8ae..bbbd4dc2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2270,7 +2270,7 @@ static void brief_examine_subarrays_imsm(struct supertype *st, int verbose)
 		super->current_vol = i;
 		getinfo_super_imsm(st, &info, NULL);
 		fname_from_uuid(st, &info, nbuf1, ':');
-		printf("ARRAY /dev/md/%.16s container=%s member=%d UUID=%s\n",
+		printf("ARRAY " DEV_MD_DIR "%.16s container=%s member=%d UUID=%s\n",
 		       dev->volume, nbuf + 5, i, nbuf1 + 5);
 	}
 }
diff --git a/super1.c b/super1.c
index f7020320..d0907370 100644
--- a/super1.c
+++ b/super1.c
@@ -642,8 +642,7 @@ static void brief_examine_super1(struct supertype *st, int verbose)
 
 	printf("ARRAY ");
 	if (nm) {
-		printf("/dev/md/");
-		print_escape(nm);
+		printf(DEV_MD_DIR "%s", nm);
 		putchar(' ');
 	}
 	if (verbose && c)
diff --git a/sysfs.c b/sysfs.c
index ca1d888f..94d02f53 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -1114,7 +1114,7 @@ void sysfsline(char *line)
 		if (strncasecmp(w, "name=", 5) == 0) {
 			char *devname = w + 5;
 
-			if (strncmp(devname, "/dev/md/", 8) == 0) {
+			if (strncmp(devname, DEV_MD_DIR, DEV_MD_DIR_LEN) == 0) {
 				if (sr->devname)
 					pr_err("Only give one device per SYSFS line: %s\n",
 						devname);
-- 
2.26.2

