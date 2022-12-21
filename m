Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76899C4167B
	for <linux-raid@archiver.kernel.org>; Wed, 21 Dec 2022 13:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiLUNhQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Dec 2022 08:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiLUNhN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Dec 2022 08:37:13 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4758862F9
        for <linux-raid@vger.kernel.org>; Wed, 21 Dec 2022 05:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671629832; x=1703165832;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1q+eGqLsJMCFptHfveACPCJvAhZw3lZ3gGroqsEZym4=;
  b=mnPZbHcCLwy9925f3rDdmXOlHkeA61VlU7J8gznGwuxQLuAHRWH7sEPq
   QKew3tt4I7jkS10DgdB0q1sLW2/c2CssFE2qymAyI/v2CXfOj3Ij5viTi
   nXzqYlwFbBSfGxuZOYnmRkcsA8hV5EXPuxo9ADZ9PUhuIWDLw38wuQrvU
   3xlVgqKMNDsVAwkmUsFBwM6RfPwo6GhWg86IP1RUCkz6XwsBj0kSX4mJK
   n/d6enPlRUqNOoN1g+65mEvvEfmlma1G+Wkxq9Dg/1BjihiC3clgnxIgG
   EFZTM/L3wal+oPh7eYjqTkPIZrFw8+7NAzQMKv+6qj11JoXJ3WWIy3Nms
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="318566702"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="318566702"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 05:37:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="653515414"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="653515414"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by fmsmga007.fm.intel.com with ESMTP; 21 Dec 2022 05:37:10 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH v2 2/2] manage: move comment with function description
Date:   Wed, 21 Dec 2022 07:38:46 +0100
Message-Id: <20221221063846.20710-3-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221221063846.20710-1-kinga.tanska@intel.com>
References: <20221221063846.20710-1-kinga.tanska@intel.com>
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
index 1e7f9b56..9d85237c 100644
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
-- 
2.26.2

