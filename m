Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59B9CA0ED3
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 13:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbjILNCf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Sep 2023 09:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbjILNCZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Sep 2023 09:02:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F4010E4
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 06:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694523738; x=1726059738;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UTatiETJL5VP/vkQpd2mKtERswk8KVhTTP4aSsDt1Zg=;
  b=Jf/OCmLPN1e89FVpZJD2JRJ+OgQWXPkTiq1u7sNCrnl/ql64RKaBhLWT
   3XlQzrP0JS3KONQwXO19bCGB0HUU6loICbsDxAD00Nmr8SFvSuFlN8hxH
   VoKu7o9gtLqm9Pdgi2DSxuH2UA5igUEcBcXg+MjM4yJng/kPVg3kGMexy
   re8S6ebzv8ZmNM82FBhRDBj1STdgmPTPgjPTG5SJANXqmX1O291SuMnVq
   nWGtAAvPwRE6p9P9DUdQuMhPJiELcASusnD49Q0o0hvXdMKDwrOxfHQmC
   sUigjPUEJ6Vr+PBr2Sdkdheh/V/WOf7swgYzPB73jItj5qgbFSEFWHkDp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="378278589"
X-IronPort-AV: E=Sophos;i="6.02,139,1688454000"; 
   d="scan'208";a="378278589"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 06:01:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="858800502"
X-IronPort-AV: E=Sophos;i="6.02,139,1688454000"; 
   d="scan'208";a="858800502"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 06:01:56 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Yu Kuai <yukuai3@huawei.com>, AceLan Kao <acelan@gmail.com>
Subject: [PATCH v2] md: do not _put wrong device in md_seq_next
Date:   Tue, 12 Sep 2023 15:01:24 +0200
Message-Id: <20230912130124.666-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

During working on changes proposed by Kuai [1], I determined that
mddev->active is continusly decremented for array marked by MD_CLOSING.
It brought me to md_seq_next() changed by [2]. I determined the regression
here, if mddev_get() fails we updated mddev pointer and as a result we
_put failed device.

I isolated the change in md_seq_next() and tested it- issue is no longer
reproducible but I don't see the root cause in this scenario. The bug
is obvious so I proceed with fixing. I will submit MD_CLOSING patches
separatelly.

Put the device which has been _get with previous md_seq_next() call.
Add guard for inproper mddev_put usage(). It shouldn't be called if
there are less than 1 for mddev->active.

I didn't convert atomic_t to refcount_t because refcount warns when 0 is
achieved which is likely to happen for mddev->active.

[1] https://lore.kernel.org/linux-raid/028a21df-4397-80aa-c2a5-7c754560f595@gmail.com/T/#m6a534677d9654a4236623661c10646d45419ee1b
[2] https://bugzilla.kernel.org/show_bug.cgi?id=217798

Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the disk is freed")
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: AceLan Kao <acelan@gmail.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/md.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0fe7ab6e8ab9..bb654ff62765 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -618,6 +618,12 @@ static void mddev_delayed_delete(struct work_struct *ws);
 
 void mddev_put(struct mddev *mddev)
 {
+	/* Guard for ambiguous put. */
+	if (unlikely(atomic_read(&mddev->active) < 1)) {
+		pr_warn("%s: active refcount is lower than 1\n", mdname(mddev));
+		return;
+	}
+
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
@@ -8227,19 +8233,16 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct list_head *tmp;
 	struct mddev *next_mddev, *mddev = v;
-	struct mddev *to_put = NULL;
 
 	++*pos;
-	if (v == (void*)2)
+	if (v == (void *)2)
 		return NULL;
 
 	spin_lock(&all_mddevs_lock);
-	if (v == (void*)1) {
+	if (v == (void *)1)
 		tmp = all_mddevs.next;
-	} else {
-		to_put = mddev;
+	else
 		tmp = mddev->all_mddevs.next;
-	}
 
 	for (;;) {
 		if (tmp == &all_mddevs) {
@@ -8250,12 +8253,11 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		next_mddev = list_entry(tmp, struct mddev, all_mddevs);
 		if (mddev_get(next_mddev))
 			break;
-		mddev = next_mddev;
-		tmp = mddev->all_mddevs.next;
+		tmp = next_mddev->all_mddevs.next;
 	}
 	spin_unlock(&all_mddevs_lock);
 
-	if (to_put)
+	if (v != (void *)1)
 		mddev_put(mddev);
 	return next_mddev;
 
-- 
2.26.2

