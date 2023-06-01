Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07086C7EE29
	for <linux-raid@archiver.kernel.org>; Thu,  1 Jun 2023 07:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjFAH3h (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Jun 2023 03:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjFAH3c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Jun 2023 03:29:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777A3FB
        for <linux-raid@vger.kernel.org>; Thu,  1 Jun 2023 00:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685604568; x=1717140568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ltQfMhwa5IQ5pylUFbtH1euXqsxkG4fKjeJaXAeNjng=;
  b=PHPzD+l2+q9CaQC9eRWDkx03l/WurAEYCafSlP/n9ssaslCeRrsfkApJ
   AAe3Y8hozf56x9IBXVNaf6A9ageAoliiFDhJadb7MoLpQxR5A+2WiHziA
   UvLFTPe/Ph4kCk5gIvKATL/lHMIV50wtFNGkmfez0TjTwyWw/x+9seAKP
   eTfhO87oQ6iLlEd7usNbbRzCkNbbPB53Oa+cH7hjL7w0SvJgXmDWCfZkh
   qecoCJJ+CHSY6DLAC8t3l+oED8chK/DL3zuaeJtGaeK9IDSaKCexJ+/IE
   v8N9GXyQgM5KvWS2MaZs34nIqgbN423BO5TRIhxdMfn+E8wiiJtwYsmKc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="345007138"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="345007138"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="707221125"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="707221125"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:39 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 3/6] mdadm: set ident.devname if applicable
Date:   Thu,  1 Jun 2023 09:27:47 +0200
Message-Id: <20230601072750.20796-4-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
References: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patch tries to propagate the usage of struct mddev_ident for cmdline
where it is applicable. To avoid regression, this value is derived
from devlist->devname for applicable modes only.
As a result, the whole structure is passed to some functions. It produces
some changes for Build, Create and Assemble.
No functional changes intended.

The goal of the change is to unify devname validation which is done in
next patches.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Build.c  | 21 +++++++++------------
 Create.c | 35 ++++++++++++++++------------------
 mdadm.c  | 57 +++++++++++++++++++++++++-------------------------------
 mdadm.h  | 13 +++++--------
 4 files changed, 55 insertions(+), 71 deletions(-)

diff --git a/Build.c b/Build.c
index 8d6f6f58..657ab315 100644
--- a/Build.c
+++ b/Build.c
@@ -24,8 +24,8 @@
 
 #include "mdadm.h"
 
-int Build(char *mddev, struct mddev_dev *devlist,
-	  struct shape *s, struct context *c)
+int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
+	  struct context *c)
 {
 	/* Build a linear or raid0 arrays without superblocks
 	 * We cannot really do any checks, we just do it.
@@ -75,13 +75,12 @@ int Build(char *mddev, struct mddev_dev *devlist,
 
 	/* We need to create the device.  It can have no name. */
 	map_lock(&map);
-	mdfd = create_mddev(mddev, NULL, c->autof, LOCAL,
+	mdfd = create_mddev(ident->devname, NULL, c->autof, LOCAL,
 			    chosen_name, 0);
 	if (mdfd < 0) {
 		map_unlock(&map);
 		return 1;
 	}
-	mddev = chosen_name;
 
 	map_update(&map, fd2devnm(mdfd), "none", uuid, chosen_name);
 	map_unlock(&map);
@@ -93,7 +92,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	array.nr_disks = s->raiddisks;
 	array.raid_disks = s->raiddisks;
 	array.md_minor = 0;
-	if (fstat_is_blkdev(mdfd, mddev, &rdev))
+	if (fstat_is_blkdev(mdfd, chosen_name, &rdev))
 		array.md_minor = minor(rdev);
 	array.not_persistent = 1;
 	array.state = 0; /* not clean, but no errors */
@@ -108,8 +107,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	array.chunk_size = s->chunk*1024;
 	array.layout = s->layout;
 	if (md_set_array_info(mdfd, &array)) {
-		pr_err("md_set_array_info() failed for %s: %s\n",
-		       mddev, strerror(errno));
+		pr_err("md_set_array_info() failed for %s: %s\n", chosen_name, strerror(errno));
 		goto abort;
 	}
 
@@ -178,8 +176,8 @@ int Build(char *mddev, struct mddev_dev *devlist,
 		}
 		if (bitmap_fd >= 0) {
 			if (ioctl(mdfd, SET_BITMAP_FILE, bitmap_fd) < 0) {
-				pr_err("Cannot set bitmap file for %s: %s\n",
-				       mddev, strerror(errno));
+				pr_err("Cannot set bitmap file for %s: %s\n", chosen_name,
+				       strerror(errno));
 				goto abort;
 			}
 		}
@@ -193,9 +191,8 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	}
 
 	if (c->verbose >= 0)
-		pr_err("array %s built and started.\n",
-			mddev);
-	wait_for(mddev, mdfd);
+		pr_err("array %s built and started.\n", chosen_name);
+	wait_for(chosen_name, mdfd);
 	close(mdfd);
 	return 0;
 
diff --git a/Create.c b/Create.c
index ea6a4745..a280c7bc 100644
--- a/Create.c
+++ b/Create.c
@@ -471,11 +471,8 @@ out:
 	return ret;
 }
 
-int Create(struct supertype *st, char *mddev,
-	   char *name, int *uuid,
-	   int subdevs, struct mddev_dev *devlist,
-	   struct shape *s,
-	   struct context *c)
+int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
+	   struct mddev_dev *devlist, struct shape *s, struct context *c)
 {
 	/*
 	 * Create a new raid array.
@@ -497,6 +494,8 @@ int Create(struct supertype *st, char *mddev,
 	unsigned long long minsize = 0, maxsize = 0;
 	char *mindisc = NULL;
 	char *maxdisc = NULL;
+	char *name = ident->name;
+	int *uuid = ident->uuid_set == 1 ? ident->uuid : NULL;
 	int dnum;
 	struct mddev_dev *dv;
 	dev_t rdev;
@@ -1015,7 +1014,7 @@ int Create(struct supertype *st, char *mddev,
 
 	/* We need to create the device */
 	map_lock(&map);
-	mdfd = create_mddev(mddev, name, c->autof, LOCAL, chosen_name, 1);
+	mdfd = create_mddev(ident->devname, ident->name, c->autof, LOCAL, chosen_name, 1);
 	if (mdfd < 0) {
 		map_unlock(&map);
 		return 1;
@@ -1032,7 +1031,6 @@ int Create(struct supertype *st, char *mddev,
 		udev_unblock();
 		return 1;
 	}
-	mddev = chosen_name;
 
 	memset(&inf, 0, sizeof(inf));
 	md_get_array_info(mdfd, &inf);
@@ -1050,7 +1048,7 @@ int Create(struct supertype *st, char *mddev,
 	 * with, but it chooses to trust me instead. Sigh
 	 */
 	info.array.md_minor = 0;
-	if (fstat_is_blkdev(mdfd, mddev, &rdev))
+	if (fstat_is_blkdev(mdfd, chosen_name, &rdev))
 		info.array.md_minor = minor(rdev);
 	info.array.not_persistent = 0;
 
@@ -1102,8 +1100,8 @@ int Create(struct supertype *st, char *mddev,
 	info.array.layout = s->layout;
 	info.array.chunk_size = s->chunk*1024;
 
-	if (name == NULL || *name == 0) {
-		/* base name on mddev */
+	if (*name == 0) {
+		/* base name on devname */
 		/*  /dev/md0 -> 0
 		 *  /dev/md_d0 -> d0
 		 *  /dev/md_foo -> foo
@@ -1113,15 +1111,16 @@ int Create(struct supertype *st, char *mddev,
 		 *  /dev/mdhome -> home
 		 */
 		/* FIXME compare this with rules in create_mddev */
-		name = strrchr(mddev, '/');
+		name = strrchr(chosen_name, '/');
+
 		if (name) {
 			name++;
 			if (strncmp(name, "md_", 3) == 0 &&
-			    strlen(name) > 3 && (name-mddev) == 5 /* /dev/ */)
+			    strlen(name) > 3 && (name - chosen_name) == 5 /* /dev/ */)
 				name += 3;
 			else if (strncmp(name, "md", 2) == 0 &&
 				 strlen(name) > 2 && isdigit(name[2]) &&
-				 (name-mddev) == 5 /* /dev/ */)
+				 (name - chosen_name) == 5 /* /dev/ */)
 				name += 2;
 		}
 	}
@@ -1215,8 +1214,7 @@ int Create(struct supertype *st, char *mddev,
 	}
 	rv = set_array_info(mdfd, st, &info);
 	if (rv) {
-		pr_err("failed to set array info for %s: %s\n",
-			mddev, strerror(errno));
+		pr_err("failed to set array info for %s: %s\n", chosen_name, strerror(errno));
 		goto abort_locked;
 	}
 
@@ -1237,8 +1235,7 @@ int Create(struct supertype *st, char *mddev,
 			goto abort_locked;
 		}
 		if (ioctl(mdfd, SET_BITMAP_FILE, bitmap_fd) < 0) {
-			pr_err("Cannot set bitmap file for %s: %s\n",
-				mddev, strerror(errno));
+			pr_err("Cannot set bitmap file for %s: %s\n", chosen_name, strerror(errno));
 			goto abort_locked;
 		}
 	}
@@ -1254,7 +1251,7 @@ int Create(struct supertype *st, char *mddev,
 		 * create links */
 		sysfs_uevent(&info, "change");
 		if (c->verbose >= 0)
-			pr_err("container %s prepared.\n", mddev);
+			pr_err("container %s prepared.\n", chosen_name);
 		wait_for(chosen_name, mdfd);
 	} else if (c->runstop == 1 || subdevs >= s->raiddisks) {
 		if (st->ss->external) {
@@ -1312,7 +1309,7 @@ int Create(struct supertype *st, char *mddev,
 			ioctl(mdfd, RESTART_ARRAY_RW, NULL);
 		}
 		if (c->verbose >= 0)
-			pr_info("array %s started.\n", mddev);
+			pr_info("array %s started.\n", chosen_name);
 		if (st->ss->external && st->container_devnm[0]) {
 			if (need_mdmon)
 				start_mdmon(st->container_devnm);
diff --git a/mdadm.c b/mdadm.c
index 076b45e0..14072ec1 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1290,37 +1290,39 @@ int main(int argc, char *argv[])
 			pr_err("an md device must be given in this mode\n");
 			exit(2);
 		}
+		ident.devname = devlist->devname;
+
 		if ((int)ident.super_minor == -2 && c.autof) {
 			pr_err("--super-minor=dev is incompatible with --auto\n");
 			exit(2);
 		}
 		if (mode == MANAGE || mode == GROW) {
-			mdfd = open_mddev(devlist->devname, 1);
+			mdfd = open_mddev(ident.devname, 1);
 			if (mdfd < 0)
 				exit(1);
 
 			ret = fstat(mdfd, &stb);
 			if (ret) {
-				pr_err("fstat failed on %s.\n", devlist->devname);
+				pr_err("fstat failed on %s.\n", ident.devname);
 				exit(1);
 			}
 		} else {
-			char *bname = basename(devlist->devname);
+			char *bname = basename(ident.devname);
 
 			if (strlen(bname) > MD_NAME_MAX) {
-				pr_err("Name %s is too long.\n", devlist->devname);
+				pr_err("Name %s is too long.\n", ident.devname);
 				exit(1);
 			}
 
-			ret = stat(devlist->devname, &stb);
+			ret = stat(ident.devname, &stb);
 			if (ident.super_minor == -2 && ret != 0) {
 				pr_err("--super-minor=dev given, and listed device %s doesn't exist.\n",
-				       devlist->devname);
+				       ident.devname);
 				exit(1);
 			}
 
 			if (!ret && !stat_is_md_dev(&stb)) {
-				pr_err("device %s exists but is not an md array.\n", devlist->devname);
+				pr_err("device %s exists but is not an md array.\n", ident.devname);
 				exit(1);
 			}
 		}
@@ -1409,17 +1411,17 @@ int main(int argc, char *argv[])
 	case MANAGE:
 		/* readonly, add/remove, readwrite, runstop */
 		if (c.readonly > 0)
-			rv = Manage_ro(devlist->devname, mdfd, c.readonly);
+			rv = Manage_ro(ident.devname, mdfd, c.readonly);
 		if (!rv && devs_found > 1)
-			rv = Manage_subdevs(devlist->devname, mdfd,
+			rv = Manage_subdevs(ident.devname, mdfd,
 					    devlist->next, c.verbose,
 					    c.test, c.update, c.force);
 		if (!rv && c.readonly < 0)
-			rv = Manage_ro(devlist->devname, mdfd, c.readonly);
+			rv = Manage_ro(ident.devname, mdfd, c.readonly);
 		if (!rv && c.runstop > 0)
-			rv = Manage_run(devlist->devname, mdfd, &c);
+			rv = Manage_run(ident.devname, mdfd, &c);
 		if (!rv && c.runstop < 0)
-			rv = Manage_stop(devlist->devname, mdfd, c.verbose, 0);
+			rv = Manage_stop(ident.devname, mdfd, c.verbose, 0);
 		break;
 	case ASSEMBLE:
 		if (!c.scan && c.runstop == -1) {
@@ -1429,22 +1431,19 @@ int main(int argc, char *argv[])
 			   ident.super_minor == UnSet && ident.name[0] == 0 &&
 			   !c.scan) {
 			/* Only a device has been given, so get details from config file */
-			struct mddev_ident *array_ident = conf_get_ident(devlist->devname);
+			struct mddev_ident *array_ident = conf_get_ident(ident.devname);
 			if (array_ident == NULL) {
-				pr_err("%s not identified in config file.\n",
-					devlist->devname);
+				pr_err("%s not identified in config file.\n", ident.devname);
 				rv |= 1;
 				if (mdfd >= 0)
 					close(mdfd);
 			} else {
 				if (array_ident->autof == 0)
 					array_ident->autof = c.autof;
-				rv |= Assemble(ss, devlist->devname, array_ident,
-					       NULL, &c);
+				rv |= Assemble(ss, ident.devname, array_ident, NULL, &c);
 			}
 		} else if (!c.scan)
-			rv = Assemble(ss, devlist->devname, &ident,
-				      devlist->next, &c);
+			rv = Assemble(ss, ident.devname, &ident, devlist->next, &c);
 		else if (devs_found > 0) {
 			if (c.update && devs_found > 1) {
 				pr_err("can only update a single array at a time\n");
@@ -1502,7 +1501,7 @@ int main(int argc, char *argv[])
 				break;
 			}
 		}
-		rv = Build(devlist->devname, devlist->next, &s, &c);
+		rv = Build(&ident, devlist->next, &s, &c);
 		break;
 	case CREATE:
 		if (c.delay == 0)
@@ -1539,9 +1538,7 @@ int main(int argc, char *argv[])
 			break;
 		}
 
-		rv = Create(ss, devlist->devname,
-			    ident.name, ident.uuid_set ? ident.uuid : NULL,
-			    devs_found - 1, devlist->next, &s, &c);
+		rv = Create(ss, &ident, devs_found - 1, devlist->next, &s, &c);
 		break;
 	case MISC:
 		if (devmode == 'E') {
@@ -1638,8 +1635,7 @@ int main(int argc, char *argv[])
 				break;
 			}
 			for (dv = devlist->next; dv; dv = dv->next) {
-				rv = Grow_Add_device(devlist->devname, mdfd,
-						     dv->devname);
+				rv = Grow_Add_device(ident.devname, mdfd, dv->devname);
 				if (rv)
 					break;
 			}
@@ -1652,18 +1648,15 @@ int main(int argc, char *argv[])
 			}
 			if (c.delay == 0)
 				c.delay = DEFAULT_BITMAP_DELAY;
-			rv = Grow_addbitmap(devlist->devname, mdfd, &c, &s);
+			rv = Grow_addbitmap(ident.devname, mdfd, &c, &s);
 		} else if (grow_continue)
-			rv = Grow_continue_command(devlist->devname,
-						   mdfd, c.backup_file,
-						   c.verbose);
+			rv = Grow_continue_command(ident.devname, mdfd, c.backup_file, c.verbose);
 		else if (s.size > 0 || s.raiddisks || s.layout_str ||
 			 s.chunk != 0 || s.level != UnSet ||
 			 s.data_offset != INVALID_SECTORS) {
-			rv = Grow_reshape(devlist->devname, mdfd,
-					  devlist->next, &c, &s);
+			rv = Grow_reshape(ident.devname, mdfd, devlist->next, &c, &s);
 		} else if (s.consistency_policy != CONSISTENCY_POLICY_UNKNOWN) {
-			rv = Grow_consistency_policy(devlist->devname, mdfd, &c, &s);
+			rv = Grow_consistency_policy(ident.devname, mdfd, &c, &s);
 		} else if (array_size == 0)
 			pr_err("no changes to --grow\n");
 		break;
diff --git a/mdadm.h b/mdadm.h
index 83f2cf7f..782d7996 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1531,14 +1531,11 @@ extern int Assemble(struct supertype *st, char *mddev,
 		    struct mddev_dev *devlist,
 		    struct context *c);
 
-extern int Build(char *mddev, struct mddev_dev *devlist,
-		 struct shape *s, struct context *c);
-
-extern int Create(struct supertype *st, char *mddev,
-		  char *name, int *uuid,
-		  int subdevs, struct mddev_dev *devlist,
-		  struct shape *s,
-		  struct context *c);
+extern int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
+		 struct context *c);
+
+extern int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
+		  struct mddev_dev *devlist, struct shape *s, struct context *c);
 
 extern int Detail(char *dev, struct context *c);
 extern int Detail_Platform(struct superswitch *ss, int scan, int verbose, int export, char *controller_path);
-- 
2.26.2

