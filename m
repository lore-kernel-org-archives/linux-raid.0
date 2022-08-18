Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D5BC00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 09:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243818AbiHRJty (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 05:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243699AbiHRJtw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 05:49:52 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D0BB02B3
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 02:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660816192; x=1692352192;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OHVyYSvYm2g4tzH7hLjr+HRGwM6VHH+Emt7OYwFc4Os=;
  b=kmTnTaHCJ/Wc46oc82CnOPZL8i/42fxe2ouMt2pCbkiWgHHm8OyiSb/t
   SAS/ni72EfGv84D3HSuWO9BpADt61S882tt2tsFQZiNQ3O4znYgxjFZNw
   e5EU3X4NPZKP3ync8SXEJPdbDZZSWJmfJ/6Fu/FV8CRg46x4oKROSCjEO
   lgsyGBhQjOl3HiL1Lvv5q2s9FgRDOJHdH9xvf7Gw7kU/brJFQ7VWPV23f
   pIp89Mmzv7UcVaIQ7Zv7U/35PqwpKFjhn23oq0o1PIcs2aHM2P7qvPsQs
   jyp4w1WU6DjMs0XjV4UXJDvEPC5u+3sKax5fIMdhUYwV+eu2pd+N7JQV9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="279682997"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="279682997"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 02:49:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="636754701"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by orsmga008.jf.intel.com with ESMTP; 18 Aug 2022 02:49:50 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] Manage: Block unsafe member failing
Date:   Thu, 18 Aug 2022 11:47:21 +0200
Message-Id: <20220818094721.8969-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Kernel may or may not block mdadm from removing member device if it
will cause arrays failed state. It depends on raid personality
implementation in kernel.
Add verification on requested removal path (#mdadm --set-faulty
command).

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Manage.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index f789e0c1..774b8a11 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1285,6 +1285,50 @@ int Manage_with(struct supertype *tst, int fd, struct mddev_dev *dv,
 	return -1;
 }
 
+/**
+ * is_remove_safe() - Check if remove is safe.
+ * @array: Array info.
+ * @fd: Array file descriptor.
+ * @devname: Name of device to remove.
+ * @verbose: Verbose.
+ *
+ * The function determines if array will be operational
+ * after removing &devname.
+ *
+ * Return: True if array will be operational, false otherwise.
+ */
+bool is_remove_safe(mdu_array_info_t *array, const int fd, char *devname, const int verbose)
+{
+	dev_t devid = devnm2devid(devname + 5);
+	struct mdinfo *mdi = sysfs_read(fd, NULL, GET_DEVS | GET_DISKS | GET_STATE);
+
+	if (!mdi) {
+		if (verbose)
+			pr_err("Failed to read sysfs attributes for %s\n", devname);
+		return false;
+	}
+
+	char *avail = xcalloc(array->raid_disks, sizeof(char));
+
+	for (mdi = mdi->devs; mdi; mdi = mdi->next) {
+		if (mdi->disk.raid_disk < 0)
+			continue;
+		if (!(mdi->disk.state & (1 << MD_DISK_SYNC)))
+			continue;
+		if (makedev(mdi->disk.major, mdi->disk.minor) == devid)
+			continue;
+		avail[mdi->disk.raid_disk] = 1;
+	}
+	sysfs_free(mdi);
+
+	bool is_enough = enough(array->level, array->raid_disks,
+				array->layout, (array->state & 1),
+				avail);
+
+	free(avail);
+	return is_enough;
+}
+
 int Manage_subdevs(char *devname, int fd,
 		   struct mddev_dev *devlist, int verbose, int test,
 		   char *update, int force)
@@ -1598,7 +1642,14 @@ int Manage_subdevs(char *devname, int fd,
 			break;
 
 		case 'f': /* set faulty */
-			/* FIXME check current member */
+			if (!is_remove_safe(&array, fd, dv->devname, verbose)) {
+				pr_err("Cannot remove %s from %s, array will be failed.\n",
+				       dv->devname, devname);
+				if (sysfd >= 0)
+					close(sysfd);
+				goto abort;
+			}
+
 			if ((sysfd >= 0 && write(sysfd, "faulty", 6) != 6) ||
 			    (sysfd < 0 && ioctl(fd, SET_DISK_FAULTY,
 						rdev))) {
-- 
2.26.2

