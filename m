Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8880EC77B7A
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 16:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjE2QJI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 12:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjE2QJF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 12:09:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB5CCD
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 09:09:03 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 06B6D21A67;
        Mon, 29 May 2023 16:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685376542; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=lw0ywLHXt41KIUG7iDSlhj3sb6MqxBygXLIDKtz8QLA=;
        b=JGVz7IsGxEg+WLpcCHYQ5RUzs2s9EbEYN7Ih3LdIleaDpAxetV8v4MHunQSARAcEVlLjcO
        BzYs7qbDJZQcB4UHlKf8yUvcKqZLZy/ZpzMwRcA51MWrMYIcjbAdF/R2/5g9IrsPiRJ5L+
        VoKdw1mNF9qXsaTlOzn758tvKe96fjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685376542;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=lw0ywLHXt41KIUG7iDSlhj3sb6MqxBygXLIDKtz8QLA=;
        b=tPlskpkzOAMmTKDWb2BUveUpbQ24L5lr2javws06tSeEk4zvM9r1wYmxwfacgFPLlTrpf9
        iojOt4cJ5nXX0tAw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 078502C141;
        Mon, 29 May 2023 16:08:59 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Subject: [PATCH v3] Incremental: remove obsoleted calls to udisks
Date:   Tue, 30 May 2023 00:07:54 +0800
Message-Id: <20230529160754.26849-1-colyli@suse.de>
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

In the two modifications where calling force_remove() are removed,
the failure from Manage_subdevs() can be safely ignored, because,
1) udisks doesn't exist, no need to check the return value to umount
   the file system by udisks and remove the component disk again.
2) After the 'I' inremental remove, there is another 'r' hot remove
   following up. The first incremental remove is a best-try effort.

Therefore in this patch, where force_remove() is removed, the return
value of calling Manage_subdevs() is not checked too.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: Jes Sorensen <jes@trained-monkey.org>
---
Changelog,
v3: remove the almost-useless warning message, and make the change
    more simplified.
v2: improve based on code review comments from Mariusz.
v1: initial version.

 Incremental.c | 64 +++++++++++----------------------------------------
 1 file changed, 13 insertions(+), 51 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index f13ce02..05b33c4 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1628,54 +1628,18 @@ release:
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
-	int rv;
-	struct mdinfo mmdi;
 	int subfd = open_dev(memb->devnm);
 
 	if (subfd >= 0) {
-		rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
-				    0, UOPT_UNDEFINED, 0);
-		if (rv & 2) {
-			if (sysfs_init(&mmdi, -1, memb->devnm))
-				pr_err("unable to initialize sysfs for: %s\n",
-				       memb->devnm);
-			else
-				force_remove(memb->devnm, subfd, &mmdi,
-					     verbose);
-		}
+		/*
+		 * Ignore the return value because it's necessary
+		 * to handle failure condition here.
+		 */
+		Manage_subdevs(memb->devnm, subfd, devlist, verbose,
+			       0, UOPT_UNDEFINED, 0);
 		close(subfd);
 	}
 }
@@ -1758,21 +1722,19 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 		}
 		free_mdstat(mdstat);
 	} else {
-		rv |= Manage_subdevs(ent->devnm, mdfd, &devlist,
-				    verbose, 0, UOPT_UNDEFINED, 0);
-		if (rv & 2) {
-		/* Failed due to EBUSY, try to stop the array.
-		 * Give udisks a chance to unmount it first.
+		/*
+		 * This 'I' incremental remove is a try-best effort,
+		 * the failure condition can be safely ignored
+		 * because of the following up 'r' remove.
 		 */
-			rv = force_remove(ent->devnm, mdfd, &mdi, verbose);
-			goto end;
-		}
+		Manage_subdevs(ent->devnm, mdfd, &devlist,
+			       verbose, 0, UOPT_UNDEFINED, 0);
 	}
 
 	devlist.disposition = 'r';
 	rv = Manage_subdevs(ent->devnm, mdfd, &devlist,
 			    verbose, 0, UOPT_UNDEFINED, 0);
-end:
+
 	close(mdfd);
 	free_mdstat(ent);
 	return rv;
-- 
2.35.3

