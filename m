Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6E6C32772
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343887AbiHRO6u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343940AbiHRO6d (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:58:33 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA5A1758F
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834708; x=1692370708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sBIAwm83vtuc4r9a/18owVmE6YBxk+U6ywYzlndDAzA=;
  b=kcZnaC2izTEjiKnr3GdQs7hyz4ZpgwdLJawdHIXsUszfWm8Lk1WiV42C
   nlnAjOYhRRQQt9sN/mVapZv3ZGuzLmbwbOzwAsOx9inRAbnl4pUHqE1S+
   7w0hrrjgWri0AJKc2RU0SIsFjGfYUWcB6cZNbQN8VtRIx+fMyUdM43Rz1
   /a+gZpsHEVEAfKfpzjEmDfQJG9A5hcay2GVZj/r6T0ghxI6awtbI2cSl1
   qN+9IQRoYG2gfYE8AG6TLeZLkLf26SrBcgYjT/kAH2bDkzCyuwL10NQci
   DLCKtGkUidc2p2M1Gw3eDg09t5MrYTOCsKQGuJN/sa+QoeWh0cCiLEgc7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275823824"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="275823824"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:58:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084881"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:58:26 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 09/10] Manage&Incremental: code refactor, string to enum
Date:   Thu, 18 Aug 2022 16:56:20 +0200
Message-Id: <20220818145621.21982-10-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818145621.21982-1-mateusz.kusiak@intel.com>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Prepare Manage and Incremental for later changing context->update to enum.
Change update from string to enum in multiple functions and pass enum
where already possible.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Grow.c        |  8 ++++----
 Incremental.c |  8 ++++----
 Manage.c      | 35 +++++++++++++++++------------------
 mdadm.c       | 23 ++++++++++++++++++-----
 mdadm.h       |  4 ++--
 5 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/Grow.c b/Grow.c
index 83b38a71..3cd4db48 100644
--- a/Grow.c
+++ b/Grow.c
@@ -602,12 +602,12 @@ int Grow_consistency_policy(char *devname, int fd, struct context *c, struct sha
 	}
 
 	if (subarray) {
-		char *update;
+		enum update_opt update;
 
 		if (s->consistency_policy == CONSISTENCY_POLICY_PPL)
-			update = "ppl";
+			update = UOPT_PPL;
 		else
-			update = "no-ppl";
+			update = UOPT_NO_PPL;
 
 		sprintf(container_dev, "/dev/%s", st->container_devnm);
 
@@ -3234,7 +3234,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	 * level and frozen, we can safely add them.
 	 */
 	if (devlist) {
-		if (Manage_subdevs(devname, fd, devlist, verbose, 0, NULL, 0))
+		if (Manage_subdevs(devname, fd, devlist, verbose, 0, UOPT_UNDEFINED, 0))
 			goto release;
 	}
 
diff --git a/Incremental.c b/Incremental.c
index 4d0cd9d6..cfee582f 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1025,7 +1025,7 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 			close(dfd);
 			*dfdp = -1;
 			rv =  Manage_subdevs(chosen->sys_name, mdfd, &devlist,
-					     -1, 0, NULL, 0);
+					     -1, 0, UOPT_UNDEFINED, 0);
 			close(mdfd);
 		}
 		if (verbose > 0) {
@@ -1666,7 +1666,7 @@ static void remove_from_member_array(struct mdstat_ent *memb,
 
 	if (subfd >= 0) {
 		rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
-				    0, NULL, 0);
+				    0, UOPT_UNDEFINED, 0);
 		if (rv & 2) {
 			if (sysfs_init(&mmdi, -1, memb->devnm))
 				pr_err("unable to initialize sysfs for: %s\n",
@@ -1758,7 +1758,7 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 		free_mdstat(mdstat);
 	} else {
 		rv |= Manage_subdevs(ent->devnm, mdfd, &devlist,
-				    verbose, 0, NULL, 0);
+				    verbose, 0, UOPT_UNDEFINED, 0);
 		if (rv & 2) {
 		/* Failed due to EBUSY, try to stop the array.
 		 * Give udisks a chance to unmount it first.
@@ -1770,7 +1770,7 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 
 	devlist.disposition = 'r';
 	rv = Manage_subdevs(ent->devnm, mdfd, &devlist,
-			    verbose, 0, NULL, 0);
+			    verbose, 0, UOPT_UNDEFINED, 0);
 end:
 	close(mdfd);
 	free_mdstat(ent);
diff --git a/Manage.c b/Manage.c
index c47b6262..e560bdb9 100644
--- a/Manage.c
+++ b/Manage.c
@@ -598,14 +598,12 @@ static void add_set(struct mddev_dev *dv, int fd, char set_char)
 
 int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 		   struct supertype *dev_st, struct supertype *tst,
-		   unsigned long rdev,
-		   char *update, char *devname, int verbose,
-		   mdu_array_info_t *array)
+		   unsigned long rdev, enum update_opt update,
+		   char *devname, int verbose, mdu_array_info_t *array)
 {
 	struct mdinfo mdi;
 	int duuid[4];
 	int ouuid[4];
-	enum update_opt update_enum = map_name(update_options, update);
 
 	dev_st->ss->getinfo_super(dev_st, &mdi, NULL);
 	dev_st->ss->uuid_from_super(dev_st, ouuid);
@@ -683,7 +681,7 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 					devname, verbose, 0, NULL);
 			if (update)
 				rv = dev_st->ss->update_super(
-					dev_st, NULL, update_enum,
+					dev_st, NULL, update,
 					devname, verbose, 0, NULL);
 			if (rv == 0)
 				rv = dev_st->ss->store_super(dev_st, tfd);
@@ -715,8 +713,8 @@ skip_re_add:
 int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	       struct supertype *tst, mdu_array_info_t *array,
 	       int force, int verbose, char *devname,
-	       char *update, unsigned long rdev, unsigned long long array_size,
-	       int raid_slot)
+	       enum update_opt update, unsigned long rdev,
+	       unsigned long long array_size, int raid_slot)
 {
 	unsigned long long ldsize;
 	struct supertype *dev_st;
@@ -1288,7 +1286,7 @@ int Manage_with(struct supertype *tst, int fd, struct mddev_dev *dv,
 
 int Manage_subdevs(char *devname, int fd,
 		   struct mddev_dev *devlist, int verbose, int test,
-		   char *update, int force)
+		   enum update_opt update, int force)
 {
 	/* Do something to each dev.
 	 * devmode can be
@@ -1676,12 +1674,13 @@ int autodetect(void)
 	return rv;
 }
 
-int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident *ident, int verbose)
+int Update_subarray(char *dev, char *subarray, enum update_opt update,
+		    struct mddev_ident *ident, int verbose)
 {
 	struct supertype supertype, *st = &supertype;
 	int fd, rv = 2;
 	struct mdinfo *info = NULL;
-	enum update_opt update_enum = map_name(update_options, update);
+	char *update_verb = map_num(update_options, update);
 
 	memset(st, 0, sizeof(*st));
 
@@ -1699,7 +1698,7 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
 	if (is_subarray_active(subarray, st->devnm)) {
 		if (verbose >= 0)
 			pr_err("Subarray %s in %s is active, cannot update %s\n",
-			       subarray, dev, update);
+				subarray, dev, update_verb);
 		goto free_super;
 	}
 
@@ -1708,23 +1707,23 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
 
 	info = st->ss->container_content(st, subarray);
 
-	if (strncmp(update, "ppl", 3) == 0 && !is_level456(info->array.level)) {
+	if (update == UOPT_PPL && !is_level456(info->array.level)) {
 		pr_err("RWH policy ppl is supported only for raid4, raid5 and raid6.\n");
 		goto free_super;
 	}
 
-	rv = st->ss->update_subarray(st, subarray, update_enum, ident);
+	rv = st->ss->update_subarray(st, subarray, update, ident);
 
 	if (rv) {
 		if (verbose >= 0)
 			pr_err("Failed to update %s of subarray-%s in %s\n",
-				update, subarray, dev);
+				update_verb, subarray, dev);
 	} else if (st->update_tail)
 		flush_metadata_updates(st);
 	else
 		st->ss->sync_metadata(st);
 
-	if (rv == 0 && strcmp(update, "name") == 0 && verbose >= 0)
+	if (rv == 0 && update == UOPT_NAME && verbose >= 0)
 		pr_err("Updated subarray-%s name from %s, UUIDs may have changed\n",
 		       subarray, dev);
 
@@ -1765,10 +1764,10 @@ int move_spare(char *from_devname, char *to_devname, dev_t devid)
 	sprintf(devname, "%d:%d", major(devid), minor(devid));
 
 	devlist.disposition = 'r';
-	if (Manage_subdevs(from_devname, fd2, &devlist, -1, 0, NULL, 0) == 0) {
+	if (Manage_subdevs(from_devname, fd2, &devlist, -1, 0, UOPT_UNDEFINED, 0) == 0) {
 		devlist.disposition = 'a';
 		if (Manage_subdevs(to_devname, fd1, &devlist, -1, 0,
-				   NULL, 0) == 0) {
+				   UOPT_UNDEFINED, 0) == 0) {
 			/* make sure manager is aware of changes */
 			ping_manager(to_devname);
 			ping_manager(from_devname);
@@ -1778,7 +1777,7 @@ int move_spare(char *from_devname, char *to_devname, dev_t devid)
 		}
 		else
 			Manage_subdevs(from_devname, fd2, &devlist,
-				       -1, 0, NULL, 0);
+				       -1, 0, UOPT_UNDEFINED, 0);
 	}
 	close(fd1);
 	close(fd2);
diff --git a/mdadm.c b/mdadm.c
index 3705d114..b55e0d9a 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1433,10 +1433,22 @@ int main(int argc, char *argv[])
 		/* readonly, add/remove, readwrite, runstop */
 		if (c.readonly > 0)
 			rv = Manage_ro(devlist->devname, mdfd, c.readonly);
-		if (!rv && devs_found>1)
-			rv = Manage_subdevs(devlist->devname, mdfd,
-					    devlist->next, c.verbose, c.test,
-					    c.update, c.force);
+		if (!rv && devs_found > 1) {
+			/*
+			 * This is temporary and will be removed in next patches
+			 * Null c.update will cause segfault
+			 */
+			if (c.update)
+				rv = Manage_subdevs(devlist->devname, mdfd,
+						devlist->next, c.verbose, c.test,
+						map_name(update_options, c.update),
+						c.force);
+			else
+				rv = Manage_subdevs(devlist->devname, mdfd,
+						devlist->next, c.verbose, c.test,
+						UOPT_UNDEFINED,
+						c.force);
+		}
 		if (!rv && c.readonly < 0)
 			rv = Manage_ro(devlist->devname, mdfd, c.readonly);
 		if (!rv && c.runstop > 0)
@@ -1964,7 +1976,8 @@ static int misc_list(struct mddev_dev *devlist,
 				continue;
 			}
 			rv |= Update_subarray(dv->devname, c->subarray,
-					      c->update, ident, c->verbose);
+					      map_name(update_options, c->update),
+					      ident, c->verbose);
 			continue;
 		case Dump:
 			rv |= Dump_metadata(dv->devname, dump_directory, c, ss);
diff --git a/mdadm.h b/mdadm.h
index afc2e2a8..fe09fd46 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1477,7 +1477,7 @@ extern int Manage_stop(char *devname, int fd, int quiet,
 		       int will_retry);
 extern int Manage_subdevs(char *devname, int fd,
 			  struct mddev_dev *devlist, int verbose, int test,
-			  char *update, int force);
+			  enum update_opt update, int force);
 extern int autodetect(void);
 extern int Grow_Add_device(char *devname, int fd, char *newdev);
 extern int Grow_addbitmap(char *devname, int fd,
@@ -1533,7 +1533,7 @@ extern int Monitor(struct mddev_dev *devlist,
 
 extern int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl);
 extern int Kill_subarray(char *dev, char *subarray, int verbose);
-extern int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident *ident, int quiet);
+extern int Update_subarray(char *dev, char *subarray, enum update_opt update, struct mddev_ident *ident, int quiet);
 extern int Wait(char *dev);
 extern int WaitClean(char *dev, int verbose);
 extern int SetAction(char *dev, char *action);
-- 
2.26.2

