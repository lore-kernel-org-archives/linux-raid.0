Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BECCC04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238299AbiG1MWb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238279AbiG1MWL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F50B43336
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:10 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2B8A01FEBA;
        Thu, 28 Jul 2022 12:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wL5KC/paEuTE6a/mevN7hATHJlR7KqQR8msfOmeUz0g=;
        b=DxDbSIaoRPeoxt9rjywZxSm2X09dJOBSM0xn7tli17xQyArQM9QhHQdweI766zcleIKN/C
        uc1VsHlR/T66njOD/uf1ll148JvM3iThEkCl5S1iOjNipG7zS1G2WOUYYbux0xTsA21Dqm
        RZOMnyvpKCiKbQNBlH8FaNw+9+Aeqes=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010929;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wL5KC/paEuTE6a/mevN7hATHJlR7KqQR8msfOmeUz0g=;
        b=dufiPaxkW1myDRC4t3LGHowiguJydv0qJcpjBv+JbgdvXPRvd4iIHQbjZdMJVsL/SxAeK3
        7Uh7V/F5bPfR7DDg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 98CC12C141;
        Thu, 28 Jul 2022 12:22:06 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Mateusz Kusiak <mateusz.kusiak@intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 15/23] Grow: Split Grow_reshape into helper function
Date:   Thu, 28 Jul 2022 20:20:53 +0800
Message-Id: <20220728122101.28744-16-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Mateusz Kusiak <mateusz.kusiak@intel.com>

Grow_reshape should be split into helper functions given its size.
- Add helper function for preparing reshape on external metadata.
- Close cfd file descriptor.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 Grow.c  | 125 ++++++++++++++++++++++++++++++--------------------------
 mdadm.h |   1 +
 util.c  |  14 +++++++
 3 files changed, 81 insertions(+), 59 deletions(-)

diff --git a/Grow.c b/Grow.c
index 97f22c75..db719778 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1773,6 +1773,65 @@ static int reshape_container(char *container, char *devname,
 			     char *backup_file, int verbose,
 			     int forked, int restart, int freeze_reshape);
 
+/**
+ * prepare_external_reshape() - prepares update on external metadata if supported.
+ * @devname: Device name.
+ * @subarray: Subarray.
+ * @st: Supertype.
+ * @container: Container.
+ * @cfd: Container file descriptor.
+ *
+ * Function checks that the requested reshape is supported on external metadata,
+ * and performs an initial check that the container holds the pre-requisite
+ * spare devices (mdmon owns final validation).
+ *
+ * Return: 0 on success, else 1
+ */
+static int prepare_external_reshape(char *devname, char *subarray,
+				    struct supertype *st, char *container,
+				    const int cfd)
+{
+	struct mdinfo *cc = NULL;
+	struct mdinfo *content = NULL;
+
+	if (st->ss->load_container(st, cfd, NULL)) {
+		pr_err("Cannot read superblock for %s\n", devname);
+		return 1;
+	}
+
+	if (!st->ss->container_content)
+		return 1;
+
+	cc = st->ss->container_content(st, subarray);
+	for (content = cc; content ; content = content->next) {
+		/*
+		 * check if reshape is allowed based on metadata
+		 * indications stored in content.array.status
+		 */
+		if (is_bit_set(&content->array.state, MD_SB_BLOCK_VOLUME) ||
+		    is_bit_set(&content->array.state, MD_SB_BLOCK_CONTAINER_RESHAPE)) {
+			pr_err("Cannot reshape arrays in container with unsupported metadata: %s(%s)\n",
+			       devname, container);
+			goto error;
+		}
+		if (content->consistency_policy == CONSISTENCY_POLICY_PPL) {
+			pr_err("Operation not supported when ppl consistency policy is enabled\n");
+			goto error;
+		}
+		if (content->consistency_policy == CONSISTENCY_POLICY_BITMAP) {
+			pr_err("Operation not supported when write-intent bitmap consistency policy is enabled\n");
+			goto error;
+		}
+	}
+	sysfs_free(cc);
+	if (mdmon_running(container))
+		st->update_tail = &st->updates;
+	return 0;
+error:
+	sysfs_free(cc);
+	return 1;
+}
+
 int Grow_reshape(char *devname, int fd,
 		 struct mddev_dev *devlist,
 		 unsigned long long data_offset,
@@ -1800,7 +1859,7 @@ int Grow_reshape(char *devname, int fd,
 	struct supertype *st;
 	char *subarray = NULL;
 
-	int frozen;
+	int frozen = 0;
 	int changed = 0;
 	char *container = NULL;
 	int cfd = -1;
@@ -1809,7 +1868,7 @@ int Grow_reshape(char *devname, int fd,
 	int added_disks;
 
 	struct mdinfo info;
-	struct mdinfo *sra;
+	struct mdinfo *sra = NULL;
 
 	if (md_get_array_info(fd, &array) < 0) {
 		pr_err("%s is not an active md array - aborting\n",
@@ -1866,13 +1925,7 @@ int Grow_reshape(char *devname, int fd,
 		}
 	}
 
-	/* in the external case we need to check that the requested reshape is
-	 * supported, and perform an initial check that the container holds the
-	 * pre-requisite spare devices (mdmon owns final validation)
-	 */
 	if (st->ss->external) {
-		int retval;
-
 		if (subarray) {
 			container = st->container_devnm;
 			cfd = open_dev_excl(st->container_devnm);
@@ -1888,13 +1941,12 @@ int Grow_reshape(char *devname, int fd,
 			return 1;
 		}
 
-		retval = st->ss->load_container(st, cfd, NULL);
-
-		if (retval) {
-			pr_err("Cannot read superblock for %s\n", devname);
-			close(cfd);
+		rv = prepare_external_reshape(devname, subarray, st,
+					      container, cfd);
+		if (rv > 0) {
 			free(subarray);
-			return 1;
+			close(cfd);
+			goto release;
 		}
 
 		if (s->raiddisks && subarray) {
@@ -1903,51 +1955,6 @@ int Grow_reshape(char *devname, int fd,
 			free(subarray);
 			return 1;
 		}
-
-		/* check if operation is supported for metadata handler */
-		if (st->ss->container_content) {
-			struct mdinfo *cc = NULL;
-			struct mdinfo *content = NULL;
-
-			cc = st->ss->container_content(st, subarray);
-			for (content = cc; content ; content = content->next) {
-				int allow_reshape = 1;
-
-				/* check if reshape is allowed based on metadata
-				 * indications stored in content.array.status
-				 */
-				if (content->array.state &
-				    (1 << MD_SB_BLOCK_VOLUME))
-					allow_reshape = 0;
-				if (content->array.state &
-				    (1 << MD_SB_BLOCK_CONTAINER_RESHAPE))
-					allow_reshape = 0;
-				if (!allow_reshape) {
-					pr_err("cannot reshape arrays in container with unsupported metadata: %s(%s)\n",
-					       devname, container);
-					sysfs_free(cc);
-					free(subarray);
-					return 1;
-				}
-				if (content->consistency_policy ==
-				    CONSISTENCY_POLICY_PPL) {
-					pr_err("Operation not supported when ppl consistency policy is enabled\n");
-					sysfs_free(cc);
-					free(subarray);
-					return 1;
-				}
-				if (content->consistency_policy ==
-				    CONSISTENCY_POLICY_BITMAP) {
-					pr_err("Operation not supported when write-intent bitmap is enabled\n");
-					sysfs_free(cc);
-					free(subarray);
-					return 1;
-				}
-			}
-			sysfs_free(cc);
-		}
-		if (mdmon_running(container))
-			st->update_tail = &st->updates;
 	}
 
 	added_disks = 0;
diff --git a/mdadm.h b/mdadm.h
index 163f4a49..b25bdd13 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1542,6 +1542,7 @@ extern int stat_is_blkdev(char *devname, dev_t *rdev);
 extern bool is_dev_alive(char *path);
 extern int get_mdp_major(void);
 extern int get_maj_min(char *dev, int *major, int *minor);
+extern bool is_bit_set(int *val, unsigned char index);
 extern int dev_open(char *dev, int flags);
 extern int open_dev(char *devnm);
 extern void reopen_mddev(int mdfd);
diff --git a/util.c b/util.c
index 38f0420e..88b79fb7 100644
--- a/util.c
+++ b/util.c
@@ -1027,6 +1027,20 @@ int get_maj_min(char *dev, int *major, int *minor)
 		*e == 0);
 }
 
+/**
+ * is_bit_set() - get bit value by index.
+ * @val: value.
+ * @index: index of the bit (LSB numbering).
+ *
+ * Return: bit value.
+ */
+bool is_bit_set(int *val, unsigned char index)
+{
+	if ((*val) & (1 << index))
+		return true;
+	return false;
+}
+
 int dev_open(char *dev, int flags)
 {
 	/* like 'open', but if 'dev' matches %d:%d, create a temp
-- 
2.35.3

