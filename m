Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCB2C77B7A
	for <linux-raid@archiver.kernel.org>; Thu, 25 May 2023 17:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjEYRKH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 May 2023 13:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbjEYRJ6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 May 2023 13:09:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABF2135
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 10:09:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 040F921B7E;
        Thu, 25 May 2023 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685034595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=KM8tQC31IxAlWJ2INM7cCgKM4mZrQfZJ0jA1Cuzeax0=;
        b=iedV3FCJmFrJ5Ch7g/ZiSVM2IYjlp0D3hmvte00prblxlkmuop6qjwsoqQbgqMDUJ/yK3E
        XdoOzX0VNPMhU77xnbDGDy9cyvySD7lJGkHE6bWBTFsBLiVxaIPASvi2uum51a6gKxPll3
        XqKAkhoH/dnSL1m5KfCJZITv9Qix3P4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685034595;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=KM8tQC31IxAlWJ2INM7cCgKM4mZrQfZJ0jA1Cuzeax0=;
        b=USJkK55Q5XDerHudVy4iKGyFuxGEbQwW0XFRPePEYIlVzEwgiIeH3uD4iHTYXriwm1XJj9
        +ac0b49HNE0lYwAA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id F17942C141;
        Thu, 25 May 2023 17:09:52 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH v2] Incremental: remove obsoleted calls to udisks
Date:   Fri, 26 May 2023 01:08:43 +0800
Message-Id: <20230525170843.4616-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Utilility udisks is removed from udev upstream, calling this obsoleted
command in run_udisks() doesn't make any sense now.

This patch removes the calls chain of udisks, which includes routines
run_udisk(), force_remove(), and 2 locations where force_remove() are
called. Considering force_remove() is removed with udisks util, it is
fair to remove Manage_stop() inside force_remove() as well.

After force_remove() is not called anymore, if Manage_subdevs() returns
failure due to a busy array, nothing else to do. If the failure is from
a broken array and verbose information is wanted, a warning message will
be printed by pr_err().

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: Jes Sorensen <jes@trained-monkey.org>
---
Changelog,
v2: improve based on code review comments from Mariusz.
v1: initial version.

 Incremental.c | 88 ++++++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 46 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index f13ce02..d390a08 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1628,56 +1628,38 @@ release:
 	return rv;
 }
 
-static void run_udisks(char *arg1, char *arg2)
-{
-	int pid = fork();
-	int status;
-	if (pid == 0) {
-		manage_fork_fds(1);
-		execl("/usr/bin/udisks", "udisks", arg1, arg2, NULL);
-		execl("/bin/udisks", "udisks", arg1, arg2, NULL);
-		exit(1);
-	}
-	while (pid > 0 && wait(&status) != pid)
-		;
-}
-
-static int force_remove(char *devnm, int fd, struct mdinfo *mdi, int verbose)
-{
-	int rv;
-	int devid = devnm2devid(devnm);
-
-	run_udisks("--unmount", map_dev(major(devid), minor(devid), 0));
-	rv = Manage_stop(devnm, fd, verbose, 1);
-	if (rv) {
-		/* At least we can try to trigger a 'remove' */
-		sysfs_uevent(mdi, "remove");
-		if (verbose)
-			pr_err("Fail to stop %s too.\n", devnm);
-	}
-	return rv;
-}
-
 static void remove_from_member_array(struct mdstat_ent *memb,
 				    struct mddev_dev *devlist, int verbose)
 {
 	int rv;
 	struct mdinfo mmdi;
+	char buf[32];
 	int subfd = open_dev(memb->devnm);
 
-	if (subfd >= 0) {
-		rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
-				    0, UOPT_UNDEFINED, 0);
-		if (rv & 2) {
-			if (sysfs_init(&mmdi, -1, memb->devnm))
-				pr_err("unable to initialize sysfs for: %s\n",
-				       memb->devnm);
-			else
-				force_remove(memb->devnm, subfd, &mmdi,
-					     verbose);
+	if (subfd < 0)
+		return;
+
+	rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
+			    0, UOPT_UNDEFINED, 0);
+	if (rv) {
+		/*
+		 * If the array is busy or no verbose info
+		 * desired, nonthing else to do.
+		 */
+		if ((rv & 2) || verbose <= 0)
+			goto close;
+
+		/* Otherwise if failed due to a broken array, warn */
+		if (sysfs_init(&mmdi, -1, memb->devnm) == 0 &&
+		    sysfs_get_str(&mmdi, NULL, "array_state",
+				  buf, sizeof(buf)) > 0 &&
+		    strncmp(buf, "broken", 6) == 0) {
+			pr_err("Fail to remove %s from broken array.\n",
+			       memb->devnm);
 		}
-		close(subfd);
 	}
+close:
+	close(subfd);
 }
 
 /*
@@ -1760,11 +1742,22 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 	} else {
 		rv |= Manage_subdevs(ent->devnm, mdfd, &devlist,
 				    verbose, 0, UOPT_UNDEFINED, 0);
-		if (rv & 2) {
-		/* Failed due to EBUSY, try to stop the array.
-		 * Give udisks a chance to unmount it first.
-		 */
-			rv = force_remove(ent->devnm, mdfd, &mdi, verbose);
+		if (rv) {
+			/*
+			 * If the array is busy or no verbose info
+			 * desired, nothing else to do.
+			 */
+			if ((rv & 2) || verbose <= 0)
+				goto end;
+
+			/* Otherwise if failed due to a broken array, warn */
+			if (sysfs_get_str(&mdi, NULL, "array_state",
+					  buf, sizeof(buf)) > 0 &&
+			    strncmp(buf, "broken", 6) == 0) {
+				pr_err("Fail to remove %s from broken array.\n",
+				       ent->devnm);
+			}
+
 			goto end;
 		}
 	}
@@ -1775,5 +1768,8 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 end:
 	close(mdfd);
 	free_mdstat(ent);
+	/* Only return 0 or 1 */
+	if (rv != 0)
+		rv = 1;
 	return rv;
 }
-- 
2.35.3

