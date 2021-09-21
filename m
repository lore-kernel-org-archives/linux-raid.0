Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE400C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 21 Sep 2021 07:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3196611BD
	for <linux-raid@archiver.kernel.org>; Tue, 21 Sep 2021 07:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhIUHyw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Sep 2021 03:54:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:5063 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230437AbhIUHyw (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 21 Sep 2021 03:54:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10113"; a="222949640"
X-IronPort-AV: E=Sophos;i="5.85,310,1624345200"; 
   d="scan'208";a="222949640"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 00:53:14 -0700
X-IronPort-AV: E=Sophos;i="5.85,310,1624345200"; 
   d="scan'208";a="549389050"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 00:53:13 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] mdopen: use safe functions in create_mddev
Date:   Tue, 21 Sep 2021 09:52:57 +0200
Message-Id: <20210921075257.10668-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To avoid buffer overflows, add sizes and use safe functions.
Buffers are now limited to NAME_MAX. Potentially, it may
cause regression in non-standard usecases.
Adapt description to kernel-doc standard.
Add verification for name and dev to ensure that at least one of them
is set.
Remove redundant chosen update after verification. It is set already.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Assemble.c    |   2 +-
 Build.c       |   2 +-
 Create.c      |   3 +-
 Incremental.c |  10 ++--
 mdadm.h       |   5 +-
 mdopen.c      | 132 ++++++++++++++++++++++++++++++++------------------
 6 files changed, 96 insertions(+), 58 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 0df46244..77bfc6f7 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1572,7 +1572,7 @@ try_again:
 			name = strchr(name, ':')+1;
 
 		mdfd = create_mddev(mddev, name, ident->autof, trustworthy,
-				    chosen_name, 0);
+				    chosen_name, sizeof(chosen_name), 0);
 	}
 	if (mdfd < 0) {
 		st->ss->free_super(st);
diff --git a/Build.c b/Build.c
index 962c2e37..0561beb5 100644
--- a/Build.c
+++ b/Build.c
@@ -97,7 +97,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	/* We need to create the device.  It can have no name. */
 	map_lock(&map);
 	mdfd = create_mddev(mddev, NULL, c->autof, LOCAL,
-			    chosen_name, 0);
+			    chosen_name, sizeof(chosen_name), 0);
 	if (mdfd < 0) {
 		map_unlock(&map);
 		return 1;
diff --git a/Create.c b/Create.c
index f5d57f8c..12e41b06 100644
--- a/Create.c
+++ b/Create.c
@@ -627,7 +627,8 @@ int Create(struct supertype *st, char *mddev,
 
 	/* We need to create the device */
 	map_lock(&map);
-	mdfd = create_mddev(mddev, name, c->autof, LOCAL, chosen_name, 1);
+	mdfd = create_mddev(mddev, name, c->autof, LOCAL, chosen_name,
+			    sizeof(chosen_name), 1);
 	if (mdfd < 0) {
 		map_unlock(&map);
 		return 1;
diff --git a/Incremental.c b/Incremental.c
index cd9cc0fc..e849db01 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -297,7 +297,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 
 		/* Couldn't find an existing array, maybe make a new one */
 		mdfd = create_mddev(match ? match->devname : NULL,
-				    name_to_use, c->autof, trustworthy, chosen_name, 0);
+				    name_to_use, c->autof, trustworthy,
+				    chosen_name, sizeof(chosen_name), 0);
 
 		if (mdfd < 0)
 			goto out_unlock;
@@ -1568,10 +1569,9 @@ static int Incremental_container(struct supertype *st, char *devname,
 				trustworthy = LOCAL;
 
 			mdfd = create_mddev(match ? match->devname : NULL,
-					    ra->name,
-					    c->autof,
-					    trustworthy,
-					    chosen_name, 0);
+					    ra->name, c->autof, trustworthy,
+					    chosen_name, sizeof(chosen_name),
+					    0);
 		}
 		if (only && (!mp || strcmp(mp->devnm, only) != 0))
 			continue;
diff --git a/mdadm.h b/mdadm.h
index 8f8841d8..fa550e4d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1599,8 +1599,9 @@ extern char *get_md_name(char *devnm);
 
 extern char DefaultConfFile[];
 
-extern int create_mddev(char *dev, char *name, int autof, int trustworthy,
-			char *chosen, int block_udev);
+extern int create_mddev(const char *dev, const char *name, int autof,
+			int trustworthy, char *chosen, const size_t chosen_size,
+			int block_udev);
 /* values for 'trustworthy' */
 #define	LOCAL	1
 #define	LOCAL_ANY 10
diff --git a/mdopen.c b/mdopen.c
index 245be537..7ab23dbf 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -25,6 +25,7 @@
 #include "mdadm.h"
 #include "md_p.h"
 #include <ctype.h>
+#include <linux/limits.h>
 
 void make_parts(char *dev, int cnt)
 {
@@ -128,7 +129,16 @@ int create_named_array(char *devnm)
 	return 1;
 }
 
-/*
+/**
+ * create_mddev() - Create new MD device.
+ * @dev: name given by the user, will be used to determine wanted /dev/md/name.
+ * @name: secondary name specifier, used to determine md-device numer.
+ * @autof: obsolete.
+ * @trustworthy: trustworthy type.
+ * @chosen: pointer to buffer.
+ * @chosen_size: size of @chosen. Minimal length is %DEV_MD_PATH + %NAME_MAX.
+ * @block_udev: if set udev will be blocked.
+ *
  * We need a new md device to assemble/build/create an array.
  * 'dev' is a name given us by the user (command line or mdadm.conf)
  * It might start with /dev or /dev/md any might end with a digit
@@ -160,10 +170,13 @@ int create_named_array(char *devnm)
  * /dev/mdXX in 'chosen'.
  *
  * When we create devices, we use uid/gid/umask from config file.
+ *
+ * Return: O_EXCL file descriptor or negative integer.
+ *
+ * Null terminated name for the volume is returned via *chosen.
  */
-
-int create_mddev(char *dev, char *name, int autof, int trustworthy,
-		 char *chosen, int block_udev)
+int create_mddev(const char *dev, const char *name, int autof, int trustworthy,
+		 char *chosen, const size_t chosen_size, int block_udev)
 {
 	int mdfd;
 	struct stat stb;
@@ -171,16 +184,24 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	int use_mdp = -1;
 	struct createinfo *ci = conf_get_create_info();
 	int parts;
+	const size_t cname_size = NAME_MAX;
 	char *cname;
-	char devname[37];
-	char devnm[32];
-	char cbuf[400];
+	char devname[NAME_MAX + 5];
+	char devnm[NAME_MAX] = "\0";
+	static const char dev_md_path[] = "/dev/md/";
 
 	if (!use_udev())
 		block_udev = 0;
 
-	if (chosen == NULL)
-		chosen = cbuf;
+	if (chosen == NULL) {
+		dprintf("Chosen buffer cannot be NULL.\n");
+		return -1;
+	}
+
+	if (!dev && !name) {
+		dprintf("Both dev and name cannot be NULL.\n");
+		return -1;
+	}
 
 	if (autof == 0)
 		autof = ci->autof;
@@ -188,35 +209,48 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	parts = autof >> 3;
 	autof &= 7;
 
-	strcpy(chosen, "/dev/md/");
-	cname = chosen + strlen(chosen);
+	if (chosen_size <= strlen(dev_md_path) + cname_size) {
+		dprintf("Chosen buffer is to small.\n");
+		return -1;
+	}
+
+	strncpy(chosen, dev_md_path, chosen_size);
+	cname = chosen + strlen(dev_md_path);
 
 	if (dev) {
-		if (strncmp(dev, "/dev/md/", 8) == 0) {
-			strcpy(cname, dev+8);
-		} else if (strncmp(dev, "/dev/", 5) == 0) {
-			char *e = dev + strlen(dev);
+		if (strncmp(dev, dev_md_path, 8) == 0)
+			strncpy(cname, dev+8, cname_size);
+		else if (strncmp(dev, dev_md_path, 5) == 0) {
+			const char *e = dev + 5 + strnlen(dev + 5, NAME_MAX);
+
 			while (e > dev && isdigit(e[-1]))
 				e--;
 			if (e[0])
 				num = strtoul(e, NULL, 10);
-			strcpy(cname, dev+5);
+			strncpy(cname, dev + 5, cname_size);
 			cname[e-(dev+5)] = 0;
+
 			/* name *must* be mdXX or md_dXX in this context */
 			if (num < 0 ||
-			    (strcmp(cname, "md") != 0 && strcmp(cname, "md_d") != 0)) {
+			    (strncmp(cname, "md", 2) != 0 &&
+			     strncmp(cname, "md_d", 4) != 0)) {
 				pr_err("%s is an invalid name for an md device.  Try /dev/md/%s\n",
 					dev, dev+5);
 				return -1;
 			}
-			if (strcmp(cname, "md") == 0)
+			if (strncmp(cname, "md", 2) == 0)
 				use_mdp = 0;
 			else
 				use_mdp = 1;
 			/* recreate name: /dev/md/0 or /dev/md/d0 */
-			sprintf(cname, "%s%d", use_mdp?"d":"", num);
+			snprintf(cname, cname_size, "%s%d",
+				 use_mdp ? "d" : "", num);
 		} else
-			strcpy(cname, dev);
+			strncpy(cname, dev, cname_size);
+		/*
+		 * Force null termination for long names.
+		 */
+		cname[cname_size - 1] = '\0';
 
 		/* 'cname' must not contain a slash, and may not be
 		 * empty.
@@ -271,8 +305,9 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 		 * 'md' or '/dev/md', use that for num
 		 * if it is not already in use */
 		char *ep;
-		char *n2 = name;
-		if (strncmp(n2, "/dev/", 5) == 0)
+		const char *n2 = name;
+
+		if (strncmp(n2, dev_md_path, 5) == 0)
 			n2 += 5;
 		if (strncmp(n2, "md", 2) == 0)
 			n2 += 2;
@@ -282,7 +317,8 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 		if (ep == n2 || *ep)
 			num = -1;
 		else {
-			sprintf(devnm, "md%s%d", use_mdp ? "_d":"", num);
+			snprintf(devnm, sizeof(devnm), "md%s%d",
+				 use_mdp ? "_d" : "", num);
 			if (mddev_busy(devnm))
 				num = -1;
 		}
@@ -290,16 +326,17 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 
 	if (cname[0] == 0 && name) {
 		/* Need to find a name if we can
-		 * We don't completely trust 'name'.  Truncate to
-		 * reasonable length and remove '/'
+		 * We don't completely trust 'name'.
 		 */
 		char *cp;
 		struct map_ent *map = NULL;
 		int conflict = 1;
 		int unum = 0;
 		int cnlen;
-		strncpy(cname, name, 200);
-		cname[200] = 0;
+
+		strncpy(cname, name, cname_size);
+		cname[cname_size - 1] = '\0';
+
 		for (cp = cname; *cp ; cp++)
 			switch (*cp) {
 			case '/':
@@ -317,15 +354,17 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 			if (map_by_name(&map, cname) == NULL)
 				conflict = 0;
 		}
-		cnlen = strlen(cname);
+		cnlen = strnlen(cname, cname_size);
 		while (conflict) {
 			if (trustworthy == METADATA && !isdigit(cname[cnlen-1]))
-				sprintf(cname+cnlen, "%d", unum);
+				snprintf(cname + cnlen, cname_size - cnlen,
+					 "%d", unum);
 			else
 				/* add _%d to FOREIGN array that don't
 				 * a 'host:' prefix
 				 */
-				sprintf(cname+cnlen, "_%d", unum);
+				snprintf(cname + cnlen, cname_size - cnlen,
+					 "_%d", unum);
 			unum++;
 			if (map_by_name(&map, cname) == NULL)
 				conflict = 0;
@@ -333,8 +372,8 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	}
 
 	devnm[0] = 0;
-	if (num < 0 && cname && ci->names) {
-		sprintf(devnm, "md_%s", cname);
+	if (num < 0 && ci->names) {
+		snprintf(devnm, sizeof(devnm), "md_%s", cname);
 		if (block_udev)
 			udev_block(devnm);
 		if (!create_named_array(devnm)) {
@@ -343,7 +382,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 		}
 	}
 	if (num >= 0) {
-		sprintf(devnm, "md%d", num);
+		snprintf(devnm, sizeof(devnm), "md%d", num);
 		if (block_udev)
 			udev_block(devnm);
 		if (!create_named_array(devnm)) {
@@ -359,12 +398,13 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 				pr_err("No avail md devices - aborting\n");
 				return -1;
 			}
-			strcpy(devnm, _devnm);
+			strncpy(devnm, _devnm, sizeof(devnm) - 1);
 		} else {
-			sprintf(devnm, "%s%d", use_mdp?"md_d":"md", num);
+			snprintf(devnm, sizeof(devnm), "%s%d",
+				 use_mdp ? "md_d" : "md", num);
 			if (mddev_busy(devnm)) {
 				pr_err("%s is already in use.\n",
-				       dev);
+				       devnm);
 				return -1;
 			}
 		}
@@ -372,12 +412,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 			udev_block(devnm);
 	}
 
-	sprintf(devname, "/dev/%s", devnm);
-
-	if (dev && dev[0] == '/')
-		strcpy(chosen, dev);
-	else if (cname[0] == 0)
-		strcpy(chosen, devname);
+	snprintf(devname, sizeof(devname), "/dev/%s", devnm);
 
 	/* We have a device number and name.
 	 * If we cannot detect udev, we need to make
@@ -410,7 +445,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 		if (use_mdp == 1)
 			make_parts(devname, parts);
 
-		if (strcmp(chosen, devname) != 0) {
+		if (strncmp(chosen, devname, sizeof(devname)) != 0) {
 			if (mkdir("/dev/md",0700) == 0) {
 				if (chown("/dev/md", ci->uid, ci->gid))
 					perror("chown /dev/md");
@@ -418,27 +453,28 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 					perror("chmod /dev/md");
 			}
 
-			if (dev && strcmp(chosen, dev) == 0)
+			if (dev && strncmp(chosen, dev, chosen_size) == 0)
 				/* We know we are allowed to use this name */
 				unlink(chosen);
 
 			if (lstat(chosen, &stb) == 0) {
-				char buf[300];
+				char buf[PATH_MAX];
 				ssize_t link_len = readlink(chosen, buf, sizeof(buf)-1);
 				if (link_len >= 0)
 					buf[link_len] = '\0';
 
 				if ((stb.st_mode & S_IFMT) != S_IFLNK ||
 				    link_len < 0 ||
-				    strcmp(buf, devname) != 0) {
+				    strncmp(buf, devname, sizeof(devname)) != 0) {
 					pr_err("%s exists - ignoring\n",
 						chosen);
-					strcpy(chosen, devname);
+					strncpy(chosen, devname, chosen_size);
 				}
 			} else if (symlink(devname, chosen) != 0)
 				pr_err("failed to create %s: %s\n",
 					chosen, strerror(errno));
-			if (use_mdp && strcmp(chosen, devname) != 0)
+			if (use_mdp &&
+			    strncmp(chosen, devname, sizeof(devname)) != 0)
 				make_parts(chosen, parts);
 		}
 	}
-- 
2.26.2

