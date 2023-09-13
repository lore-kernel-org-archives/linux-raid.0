Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BA1CA5511
	for <linux-raid@archiver.kernel.org>; Wed, 13 Sep 2023 08:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbjIMIzc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Sep 2023 04:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjIMIzb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Sep 2023 04:55:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B880196
        for <linux-raid@vger.kernel.org>; Wed, 13 Sep 2023 01:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694595327; x=1726131327;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gOsEBqZcQ8Pk6V7Io6n7J5Ycd/rwXODPGQIxawAS564=;
  b=nGosWoGf9+NN+eY/7RbMrGPA5lYYskrLKdYJNjHW/0hUadrWm3CIj0wR
   IgPzqjjaQ5PGZcNoHORNksfqQsBOZqCCq3ISZTBJbHl59lvBXzn0yYBqB
   vuf/2cdAex1NUBtQaaBem0z/2XlE7J11LzkKZsCs6myRD+yPtg3WsCsE7
   MTcZQ2tDHAcTGbf2M4g5jQo2gK634WNVtTOz+55Fr/IKeJWdREaQ5Vlff
   xjQ1FTo522J1TFI9z4iQYwe1yU01YMK4nblQh8fm7xB4uaDTZSoY0nDNh
   rr0LAq1nHgn9n8a6WpVxbz+MHZnSBpmQMQmaGDVkMgdezyjVr/5bzzT8x
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="375935118"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="375935118"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 01:55:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="737415646"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="737415646"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 01:55:25 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH] md: do not require mddev_lock() for all options
Date:   Wed, 13 Sep 2023 10:55:02 +0200
Message-Id: <20230913085502.17856-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We don't need to lock device to reject not supported request
in array_state_store().
Main motivation is to make a room for action does not require lock yet,
like prepare to stop (see md_ioctl()).

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
Code refactor, submitting it now because work in this area will be
postponed- we have the issue root caused.

 drivers/md/md.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bb654ff62765..3b1a28a753e5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4365,6 +4365,18 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
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
@@ -4389,23 +4401,16 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
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
@@ -4456,10 +4461,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
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

