Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AC1E732C8
	for <linux-raid@archiver.kernel.org>; Thu, 28 Sep 2023 12:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbjI1Mzt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Sep 2023 08:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbjI1Mzs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Sep 2023 08:55:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C1A19B
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 05:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695905746; x=1727441746;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vPNf8AZNP22Pz4yQyd195jd2amGcJxw7wrT//WW2h+Y=;
  b=dL+EACrJHyuBNpEKJRUGJkSobmu6t9JELrBi7EFv9mq96x9qZIV4vCdd
   MefNyIBfFLA78hOHKrks99+KdPM09H5NikcmPH9IjF79HP8g8hPoy4cCz
   Yfb0QR8/362EEzoUpCJoljFfkGZ5NCOP3rrTlcvyf2ZD6y0sPzi6XCszB
   cjaNke+MeMG+84rabkTG4ClrAhzuadxGApkpYWFgi1Rc1SA5IOqzqy7BD
   Ni3H9mQtPlCVnQXgFD3HfBaDLqbIbI5bpkq4guWD/sFLLZTkVsby7tR5D
   UlOSKnLHARxU8LdIyBVdVfdQYXecU+O8oxPahO0pf7jn96yP9aIBX/QbI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="446193308"
X-IronPort-AV: E=Sophos;i="6.03,184,1694761200"; 
   d="scan'208";a="446193308"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 05:55:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="873282576"
X-IronPort-AV: E=Sophos;i="6.03,184,1694761200"; 
   d="scan'208";a="873282576"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 05:55:44 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v2] md: do not require mddev_lock() for all options
Date:   Thu, 28 Sep 2023 14:55:17 +0200
Message-Id: <20230928125517.12356-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We don't need to lock device to reject not supported request
in array_state_store(). No functional changes intended.

There are differences between ioctl and sysfs handling during stopping.
With this change, it will be easier to add additional steps which needs
to be completed before mddev_lock() is taken.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
Song, feel free to remove second chapter if you think it is confusing.

 drivers/md/md.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b8f232840f7c..469b1376e66c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4359,6 +4359,18 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	int err = 0;
 	enum array_state st = match_word(buf, array_states);
 
+	/* No lock dependent actions */
+	switch (st) {
+	case suspended:		/* not supported yet */
+	case write_pending:	/* cannot be set */
+	case active_idle:	/* cannot be set */
+	case broken:		/* cannot be set */
+	case bad_word:
+		return -EINVAL;
+	default:
+		break;
+	}
+
 	if (mddev->pers && (st == active || st == clean) &&
 	    mddev->ro != MD_RDONLY) {
 		/* don't take reconfig_mutex when toggling between
@@ -4383,23 +4395,16 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	err = mddev_lock(mddev);
 	if (err)
 		return err;
-	err = -EINVAL;
-	switch(st) {
-	case bad_word:
-		break;
-	case clear:
-		/* stopping an active array */
-		err = do_md_stop(mddev, 0, NULL);
-		break;
+
+	switch (st) {
 	case inactive:
-		/* stopping an active array */
+		/* stop an active array, return 0 otherwise */
 		if (mddev->pers)
 			err = do_md_stop(mddev, 2, NULL);
-		else
-			err = 0; /* already inactive */
 		break;
-	case suspended:
-		break; /* not supported yet */
+	case clear:
+		err = do_md_stop(mddev, 0, NULL);
+		break;
 	case readonly:
 		if (mddev->pers)
 			err = md_set_readonly(mddev, NULL);
@@ -4450,10 +4455,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 			err = do_md_run(mddev);
 		}
 		break;
-	case write_pending:
-	case active_idle:
-	case broken:
-		/* these cannot be set */
+	default:
+		err = -EINVAL;
 		break;
 	}
 
-- 
2.26.2

