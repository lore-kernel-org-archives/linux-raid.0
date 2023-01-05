Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63100C3DA7A
	for <linux-raid@archiver.kernel.org>; Thu,  5 Jan 2023 12:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjAEM3V (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Jan 2023 07:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjAEM3U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 Jan 2023 07:29:20 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9FA48CD7
        for <linux-raid@vger.kernel.org>; Thu,  5 Jan 2023 04:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672921759; x=1704457759;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qcQ09Df5Qr2IB8lqIwchqxhAor/sxZMCTAS8zTNlqmI=;
  b=ft7p3/ZFlovsS/MvAdG5L9b8N+IgBQR8D/lkhgxWvnI0oc1x9Zjtx/C/
   1wVNAYCBWiPdxvi+Yqw8+QUGFU+OxDzaVxQKe2jgZUHU9eRYyUkD2iLmV
   DwzqwPaiFHOZgPvNikk18ApOrB3tI8JAqvHgDlvsewAs8Q0cUquLUWbzO
   Jno0Hs6ZI4dMnuP/O8MuWrGgCD48gVq6jkg/5vuohWuk1DHFBxose3eQw
   OfolLxVKmusHlOOf6nKLLixwwIRdnd+0WJ+3g+AFWqptunP0FyNqiWj6D
   NYzasScTvlhoWkKRWuto4xg+Sj6920Ext6o4sDu+yvPtR7b3FrOlc3b7T
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="301886776"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="301886776"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 04:29:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="900915165"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="900915165"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jan 2023 04:29:18 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] manage: move comment with function description
Date:   Thu,  5 Jan 2023 06:31:25 +0100
Message-Id: <20230105053125.31388-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Move the function description from the function body to outside
to obey kernel coding style.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Manage.c | 72 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 28 deletions(-)

diff --git a/Manage.c b/Manage.c
index 594e3d2c..4a980fa0 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1328,38 +1328,54 @@ bool is_remove_safe(mdu_array_info_t *array, const int fd, char *devname, const
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
 		   enum update_opt update, int force)
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
-- 
2.26.2

