Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536EBC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 20 Dec 2022 10:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiLTKUW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Dec 2022 05:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiLTKUU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Dec 2022 05:20:20 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6194DC16
        for <linux-raid@vger.kernel.org>; Tue, 20 Dec 2022 02:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671531619; x=1703067619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=48lR1yjMqmTyHvaWzl9mbRnkO6ev80Kvf3CmQ09doAE=;
  b=mnXzOP8AkGYvbK3Z0KQ/qKPiqQtSAaGa9XsWT0FDF9XPnUOgIq0WqOx0
   Z2C2w32/WNXlev6elAfgKeh532+klpa6AZLF0oun62wTj3bYhLaAF0rET
   qxtscUZ5TRdMDAl2WGbbiJ/F+sV27sKOmQ2cke9FeV7RUtaXzpAY4jCX2
   k7zjfUd9Lt8garlJxU0VG0HyAy5wqugbLbYVlMMoPduIc0QDyzk6xgtRh
   TsyEDMu4dNqT67ellRE96HBiceREZL/jvtNbNzlqzM4JqagPszy1q5LYm
   SHPQn9jT6KYV8tzr2o2/Myfk5/MXuwQqvjjKwHHUnTs0mpsPE3go8RH1s
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="307260872"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="307260872"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 02:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="714368959"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="714368959"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2022 02:20:14 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH] incremental, manage: do not verify if remove is safe
Date:   Tue, 20 Dec 2022 04:21:51 +0100
Message-Id: <20221220032151.12067-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Function is_remove_safe() was introduced to verify if removing
member device won't cause failed state of the array. This
verification should be used only with set-faulty command. Add
special mode indicating that Incremental removal was executed.
If this mode is used do not execute is_remove_safe() routine.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Incremental.c |  2 +-
 Manage.c      | 79 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 5a5f4c4c..bccfdeb9 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1744,7 +1744,7 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 
 	memset(&devlist, 0, sizeof(devlist));
 	devlist.devname = devname;
-	devlist.disposition = 'f';
+	devlist.disposition = 'I';
 	/* for a container, we must fail each member array */
 	if (ent->metadata_version &&
 	    strncmp(ent->metadata_version, "external:", 9) == 0) {
diff --git a/Manage.c b/Manage.c
index b1d0e630..9d85237c 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1329,38 +1329,54 @@ bool is_remove_safe(mdu_array_info_t *array, const int fd, char *devname, const
 	return is_enough;
 }
 
+/**
+ * Manage_subdevs() - Execute operation depending on devmode.
+ *
+ * @devname: name of the device.
+ * @fd: file descriptor.
+ * @devlist: list of sub-devices to manage.
+ * @verbose: verbose level.
+ * @test: test flag.
+ * @update: type of update.
+ * @force: force flag.
+ *
+ * This function executes operation defined by devmode
+ * for each dev from devlist.
+ * Devmode can be:
+ * 'a' - add the device
+ * 'S' - add the device as a spare - don't try re-add
+ * 'j' - add the device as a journal device
+ * 'A' - re-add the device
+ * 'r' - remove the device: HOT_REMOVE_DISK
+ *       device can be 'faulty' or 'detached' in which case all
+ *       matching devices are removed.
+ * 'f' - set the device faulty SET_DISK_FAULTY
+ *       device can be 'detached' in which case any device that
+ *       is inaccessible will be marked faulty.
+ * 'I' - remove device by using incremental fail
+ *       which is executed when device is removed surprisingly.
+ * 'R' - mark this device as wanting replacement.
+ * 'W' - this device is added if necessary and activated as
+ *       a replacement for a previous 'R' device.
+ * -----
+ * 'w' - 'W' will be changed to 'w' when it is paired with
+ *       a 'R' device.  If a 'W' is found while walking the list
+ *       it must be unpaired, and is an error.
+ * 'M' - this is created by a 'missing' target.  It is a slight
+ *       variant on 'A'
+ * 'F' - Another variant of 'A', where the device was faulty
+ *       so must be removed from the array first.
+ * 'c' - confirm the device as found (for clustered environments)
+ *
+ * For 'f' and 'r', the device can also be a kernel-internal
+ * name such as 'sdb'.
+ *
+ * Return: 0 on success, otherwise 1 or 2.
+ */
 int Manage_subdevs(char *devname, int fd,
 		   struct mddev_dev *devlist, int verbose, int test,
 		   char *update, int force)
 {
-	/* Do something to each dev.
-	 * devmode can be
-	 *  'a' - add the device
-	 *  'S' - add the device as a spare - don't try re-add
-	 *  'j' - add the device as a journal device
-	 *  'A' - re-add the device
-	 *  'r' - remove the device: HOT_REMOVE_DISK
-	 *        device can be 'faulty' or 'detached' in which case all
-	 *	  matching devices are removed.
-	 *  'f' - set the device faulty SET_DISK_FAULTY
-	 *        device can be 'detached' in which case any device that
-	 *	  is inaccessible will be marked faulty.
-	 *  'R' - mark this device as wanting replacement.
-	 *  'W' - this device is added if necessary and activated as
-	 *        a replacement for a previous 'R' device.
-	 * -----
-	 *  'w' - 'W' will be changed to 'w' when it is paired with
-	 *        a 'R' device.  If a 'W' is found while walking the list
-	 *        it must be unpaired, and is an error.
-	 *  'M' - this is created by a 'missing' target.  It is a slight
-	 *        variant on 'A'
-	 *  'F' - Another variant of 'A', where the device was faulty
-	 *        so must be removed from the array first.
-	 *  'c' - confirm the device as found (for clustered environments)
-	 *
-	 * For 'f' and 'r', the device can also be a kernel-internal
-	 * name such as 'sdb'.
-	 */
 	mdu_array_info_t array;
 	unsigned long long array_size;
 	struct mddev_dev *dv;
@@ -1496,8 +1512,9 @@ int Manage_subdevs(char *devname, int fd,
 			/* Assume this is a kernel-internal name like 'sda1' */
 			int found = 0;
 			char dname[55];
-			if (dv->disposition != 'r' && dv->disposition != 'f') {
-				pr_err("%s only meaningful with -r or -f, not -%c\n",
+			if (dv->disposition != 'r' && dv->disposition != 'f' &&
+			    dv->disposition != 'I') {
+				pr_err("%s only meaningful with -r, -f or -I, not -%c\n",
 					dv->devname, dv->disposition);
 				goto abort;
 			}
@@ -1649,7 +1666,7 @@ int Manage_subdevs(char *devname, int fd,
 					close(sysfd);
 				goto abort;
 			}
-
+		case 'I': /* incremental fail */
 			if ((sysfd >= 0 && write(sysfd, "faulty", 6) != 6) ||
 			    (sysfd < 0 && ioctl(fd, SET_DISK_FAULTY,
 						rdev))) {
-- 
2.26.2

