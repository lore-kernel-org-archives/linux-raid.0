Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6BEC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 27 Dec 2022 12:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiL0MtH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Dec 2022 07:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiL0MtE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Dec 2022 07:49:04 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AF0F28
        for <linux-raid@vger.kernel.org>; Tue, 27 Dec 2022 04:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672145343; x=1703681343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bXEx8eIQTkuFlX6pWtU783H2skdgHa3KrqRNILO2O7I=;
  b=fI4VI4mP/75ZO0/V72DqrbzTgUYc02WFrFPsk5xmn1HFRhQxAvcGw0RY
   co48JAeChpPgVB3mmYQjnQzkQUomAKYABKzn8xOoD9gqpAuK6PraydRrp
   gu1aGO29vOtco1K2CIK+RTt5eDV5UvkLT7PyOog9iukmrvbF5DMu+MjHf
   CXn1z63zgkEJYXYsi6dq5PMjP0QrcsCrLjXzT2yKztyMIIvIjIz1gupOG
   BkLQv6sZSgp3oMbatkpI0oGtkMQR0HcA75iPGUN2ydGKOj6aqTPTveK1k
   gckiWE3/db2RliyDS9+80ZfWHiiLPjPxreHyOtjEaF9XD64whn4ynl296
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="385117701"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="385117701"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 04:49:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="646415746"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="646415746"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga007.jf.intel.com with ESMTP; 27 Dec 2022 04:49:01 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH v3 3/3] manage: move comment with function description
Date:   Tue, 27 Dec 2022 06:50:44 +0100
Message-Id: <20221227055044.18168-4-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221227055044.18168-1-kinga.tanska@intel.com>
References: <20221227055044.18168-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Move the function description from the function body to outside
to obey kernel coding style.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 Manage.c | 72 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 28 deletions(-)

diff --git a/Manage.c b/Manage.c
index 48b479a7..eee25fd8 100644
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
-- 
2.26.2

