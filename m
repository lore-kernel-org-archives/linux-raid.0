Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146C1C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 10 Aug 2021 15:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBEA860F25
	for <linux-raid@archiver.kernel.org>; Tue, 10 Aug 2021 15:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242738AbhHJPPj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 Aug 2021 11:15:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242657AbhHJPPc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 10 Aug 2021 11:15:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628608510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qyNpGiRmPjOd3wcsZFQOeNPTy4tnwO/mG1J5g+gqVD8=;
        b=ePS7RkzWGceq6nxfa7SOCu/45tBH4GYZDeDjFO+vEXmuBS5kczQUCet3ylfrhi7IcVR/xT
        8JIAB7OgXcaVysJKDdDmmjEcieYl1Q2surBfjyd8pcTxmN8p+vkaqWPaTH4xY1u5sQBcnZ
        KAWw0iuZVHFfPyev/edo58MY0uryen0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-It_yHEVmMtKEgcn4E35tLQ-1; Tue, 10 Aug 2021 11:15:09 -0400
X-MC-Unique: It_yHEVmMtKEgcn4E35tLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D155802923;
        Tue, 10 Aug 2021 15:15:08 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDACD5C3DF;
        Tue, 10 Aug 2021 15:15:07 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org, xni@redhat.com
Subject: [PATCH] Fix return value from fstat calls
Date:   Tue, 10 Aug 2021 11:15:07 -0400
Message-Id: <20210810151507.1667518-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To meet requirements of Common Criteria certification vulnerablility
assessment. Static code analysis has been run and found the following
errors:
check_return: Calling "fstat(fd, &dstb)" without checking return value.
This library function may fail and return an error code.

Changes are to add a test to the return value from fstat calls.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 Assemble.c    | 21 +++++++++++++++++++--
 Dump.c        | 15 +++++++++++++--
 Grow.c        | 12 ++++++++++--
 config.c      |  5 ++++-
 managemon.c   |  9 ++++++---
 mdadm.h       |  2 +-
 mdstat.c      | 10 ++++++++--
 super-ddf.c   | 11 +++++++++--
 super-intel.c | 11 +++++++++--
 9 files changed, 79 insertions(+), 17 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 0df46244..cae3224b 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -649,7 +649,14 @@ static int load_devices(struct devs *devices, char *devmap,
 			/* prepare useful information in info structures */
 			struct stat stb2;
 			int err;
-			fstat(mdfd, &stb2);
+
+			if (fstat(mdfd, &stb2) != 0) {
+				pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
+				close(mdfd);
+				free(devices);
+				free(devmap);
+				return -1;
+			}
 
 			if (strcmp(c->update, "uuid") == 0 && !ident->uuid_set)
 				random_uuid((__u8 *)ident->uuid);
@@ -760,7 +767,17 @@ static int load_devices(struct devs *devices, char *devmap,
 			tst->ss->getinfo_super(tst, content, devmap + devcnt * content->array.raid_disks);
 		}
 
-		fstat(dfd, &stb);
+		if (fstat(dfd, &stb) != 0) {
+			pr_err("fstat failed for %s: %s - aborting\n",devname, strerror(errno));
+			close(dfd);
+			close(mdfd);
+			free(devices);
+			free(devmap);
+			tst->ss->free_super(tst);
+			free(tst);
+			*stp = st;
+			return -1;
+		}
 		close(dfd);
 
 		if (c->verbose > 0)
diff --git a/Dump.c b/Dump.c
index 736bcb60..d1a8bb86 100644
--- a/Dump.c
+++ b/Dump.c
@@ -112,7 +112,14 @@ int Dump_metadata(char *dev, char *dir, struct context *c,
 	}
 	if (c->verbose >= 0)
 		printf("%s saved as %s.\n", dev, fname);
-	fstat(fd, &dstb);
+
+	if (fstat(fd, &dstb) != 0) {
+		pr_err("fstat failed from %s: %s\n",fname, strerror(errno));
+		close(fd);
+		close(fl);
+		free(fname);
+		return 1;
+	}
 	close(fd);
 	close(fl);
 	if ((dstb.st_mode & S_IFMT) != S_IFBLK) {
@@ -200,7 +207,11 @@ int Restore_metadata(char *dev, char *dir, struct context *c,
 		char *chosen = NULL;
 		unsigned int chosen_inode = 0;
 
-		fstat(fd, &dstb);
+		if (fstat(fd, &dstb) != 0) {
+			pr_err("fstat failed for %s: %s\n",dev, strerror(errno));
+			close(fd);
+			return 1;
+		}
 
 		while (d && (de = readdir(d)) != NULL) {
 			if (de->d_name[0] == '.')
diff --git a/Grow.c b/Grow.c
index 7506ab46..4c3ec9c1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1163,9 +1163,17 @@ int reshape_open_backup_file(char *backup_file,
 	 * way this will not notice, but it is better than
 	 * nothing.
 	 */
-	fstat(*fdlist, &stb);
+	if (fstat(*fdlist, &stb) != 0) {
+		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
+		close(*fdlist);
+		return 0;
+	}
 	dev = stb.st_dev;
-	fstat(fd, &stb);
+	if (fstat(fd, &stb) != 0) {
+		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
+		close(*fdlist);
+		return 0;
+	}
 	if (stb.st_rdev == dev) {
 		pr_err("backup file must NOT be on the array being reshaped.\n");
 		close(*fdlist);
diff --git a/config.c b/config.c
index 9c725457..ad0e02fe 100644
--- a/config.c
+++ b/config.c
@@ -803,7 +803,10 @@ void conf_file_or_dir(FILE *f)
 	struct dirent *dp;
 	struct fname *list = NULL;
 
-	fstat(fileno(f), &st);
+	if (fstat(fileno(f), &st) != 0) {
+		pr_err("fstat failed: %s\n", strerror(errno));
+		return;
+	}
 	if (S_ISREG(st.st_mode))
 		conf_file(f);
 	else if (!S_ISDIR(st.st_mode))
diff --git a/managemon.c b/managemon.c
index 200cf83e..d943f2cc 100644
--- a/managemon.c
+++ b/managemon.c
@@ -894,6 +894,7 @@ void do_manager(struct supertype *container)
 {
 	struct mdstat_ent *mdstat;
 	sigset_t set;
+	int rtn;
 
 	sigprocmask(SIG_UNBLOCK, NULL, &set);
 	sigdelset(&set, SIGUSR1);
@@ -926,9 +927,11 @@ void do_manager(struct supertype *container)
 		if (sigterm)
 			wakeup_monitor();
 
-		if (update_queue == NULL)
-			mdstat_wait_fd(container->sock, &set);
-		else
+		if (update_queue == NULL) {
+			rtn = mdstat_wait_fd(container->sock, &set);
+			if (rtn)
+				exit(0);
+		} else
 			/* If an update is happening, just wait for signal */
 			pselect(0, NULL, NULL, NULL, NULL, &set);
 	} while(1);
diff --git a/mdadm.h b/mdadm.h
index 8f8841d8..1273029a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -637,7 +637,7 @@ extern struct mdstat_ent *mdstat_read(int hold, int start);
 extern void mdstat_close(void);
 extern void free_mdstat(struct mdstat_ent *ms);
 extern int mdstat_wait(int seconds);
-extern void mdstat_wait_fd(int fd, const sigset_t *sigmask);
+extern int mdstat_wait_fd(int fd, const sigset_t *sigmask);
 extern int mddev_busy(char *devnm);
 extern struct mdstat_ent *mdstat_by_component(char *name);
 extern struct mdstat_ent *mdstat_by_subdev(char *subdev, char *container);
diff --git a/mdstat.c b/mdstat.c
index 2fd792c5..8664c0ec 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -336,7 +336,7 @@ int mdstat_wait(int seconds)
 	return select(maxfd + 1, NULL, NULL, &fds, &tm);
 }
 
-void mdstat_wait_fd(int fd, const sigset_t *sigmask)
+int mdstat_wait_fd(int fd, const sigset_t *sigmask)
 {
 	fd_set fds, rfds;
 	int maxfd = 0;
@@ -348,7 +348,11 @@ void mdstat_wait_fd(int fd, const sigset_t *sigmask)
 
 	if (fd >= 0) {
 		struct stat stb;
-		fstat(fd, &stb);
+
+		if (fstat(fd, &stb) != 0) {
+			pr_err("fstat failed: %s\n", strerror(errno));
+			return 1;
+		}
 		if ((stb.st_mode & S_IFMT) == S_IFREG)
 			/* Must be a /proc or /sys fd, so expect
 			 * POLLPRI
@@ -367,6 +371,8 @@ void mdstat_wait_fd(int fd, const sigset_t *sigmask)
 
 	pselect(maxfd + 1, &rfds, NULL, &fds,
 		NULL, sigmask);
+
+	return 0;
 }
 
 int mddev_busy(char *devnm)
diff --git a/super-ddf.c b/super-ddf.c
index dc8e512f..3c9eadf7 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1060,7 +1060,11 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 		     0);
 	dl->devname = devname ? xstrdup(devname) : NULL;
 
-	fstat(fd, &stb);
+	if (fstat(fd, &stb) != 0) {
+		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
+		free(dl);
+		return 1;
+	}
 	dl->major = major(stb.st_rdev);
 	dl->minor = minor(stb.st_rdev);
 	dl->next = super->dlist;
@@ -2854,7 +2858,10 @@ static int add_to_super_ddf(struct supertype *st,
 	/* This is device numbered dk->number.  We need to create
 	 * a phys_disk entry and a more detailed disk_data entry.
 	 */
-	fstat(fd, &stb);
+	if (fstat(fd, &stb) != 0) {
+		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
+		return 1;
+	}
 	n = find_unused_pde(ddf);
 	if (n == DDF_NOTFOUND) {
 		pr_err("No free slot in array, cannot add disk\n");
diff --git a/super-intel.c b/super-intel.c
index 83ddc000..1836be76 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4164,7 +4164,11 @@ load_imsm_disk(int fd, struct intel_super *super, char *devname, int keep_fd)
 
 	dl = xcalloc(1, sizeof(*dl));
 
-	fstat(fd, &stb);
+	if (fstat(fd, &stb) != 0) {
+		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
+		free(dl);
+		return 2;
+	}
 	dl->major = major(stb.st_rdev);
 	dl->minor = minor(stb.st_rdev);
 	dl->next = super->disks;
@@ -5910,7 +5914,10 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	if (super->current_vol >= 0)
 		return add_to_super_imsm_volume(st, dk, fd, devname);
 
-	fstat(fd, &stb);
+	if (fstat(fd, &stb) != 0) {
+		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
+		return 1;
+	}
 	dd = xcalloc(sizeof(*dd), 1);
 	dd->major = major(stb.st_rdev);
 	dd->minor = minor(stb.st_rdev);
-- 
2.29.2

