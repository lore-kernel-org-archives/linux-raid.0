Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3940CC77B7C
	for <linux-raid@archiver.kernel.org>; Fri,  5 May 2023 05:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjEEFXn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 May 2023 01:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjEEFXl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 May 2023 01:23:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F311C198E
        for <linux-raid@vger.kernel.org>; Thu,  4 May 2023 22:23:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9A6FD22C68;
        Fri,  5 May 2023 05:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683264219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=3wUO2LlscX/h10SuWSucbpqsNo6H/bRgUzXvWLTnAB8=;
        b=cnaVu4y4QwvV8RHpl7MOqSgG3QIEFdrQwVIab0ZIOc8X0eWscV+p7oC8xzewSJDIuoEHqX
        054KkzBs7jlf+pq5a3J7CR7qoT69uk0sQT3v6Odsds7s+O5FiRtKX5pgDOswaICVddJ6rT
        /IXGoKXcxSDteoKbaf1TrPzZD0diyE0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683264219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=3wUO2LlscX/h10SuWSucbpqsNo6H/bRgUzXvWLTnAB8=;
        b=mH+ozd9YVLqw5/fJFom2XuYENriZBm9KQwAKK8T3czxeYaX0wc+Sb3iNR62AD2BSb+I4+8
        J9Dweio36LsQAuCQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id C9CCF2C141;
        Fri,  5 May 2023 05:23:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] Incremental: remove obsoleted calls to udisks
Date:   Fri,  5 May 2023 13:22:31 +0800
Message-Id: <20230505052231.7787-1-colyli@suse.de>
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
called.

In remove_from_member_array() and IncrementalRemove(), if return value
of calling Manage_subdevs() is not 0, don't call force_remove() and only
print error message when parameter 'verbose' is true.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: Jes Sorensen <jes@trained-monkey.org>
---
 Incremental.c | 50 +++++++-------------------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 49a71f7..e1a953a 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1630,54 +1630,18 @@ release:
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
-	struct mdinfo mmdi;
 	int subfd = open_dev(memb->devnm);
 
 	if (subfd >= 0) {
 		rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
 				    0, UOPT_UNDEFINED, 0);
-		if (rv & 2) {
-			if (sysfs_init(&mmdi, -1, memb->devnm))
-				pr_err("unable to initialize sysfs for: %s\n",
-				       memb->devnm);
-			else
-				force_remove(memb->devnm, subfd, &mmdi,
-					     verbose);
-		}
+		if ((rv & 2) && verbose)
+			pr_err("Fail to remove %s from array.\n", memb->devnm);
+
 		close(subfd);
 	}
 }
@@ -1763,10 +1727,10 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 		rv |= Manage_subdevs(ent->devnm, mdfd, &devlist,
 				    verbose, 0, UOPT_UNDEFINED, 0);
 		if (rv & 2) {
-		/* Failed due to EBUSY, try to stop the array.
-		 * Give udisks a chance to unmount it first.
-		 */
-			rv = force_remove(ent->devnm, mdfd, &mdi, verbose);
+			if (verbose)
+				pr_err("Fail to remove %s from array.\n", ent->devnm);
+			/* Only return 0 or 1 */
+			rv = !!rv;
 			goto end;
 		}
 	}
-- 
2.35.3

