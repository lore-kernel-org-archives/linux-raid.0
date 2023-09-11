Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEFACA0ECB
	for <linux-raid@archiver.kernel.org>; Mon, 11 Sep 2023 22:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbjIKV7E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbjIKK5X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Sep 2023 06:57:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB602F3
        for <linux-raid@vger.kernel.org>; Mon, 11 Sep 2023 03:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694429837; x=1725965837;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5MeVadFI7ByB0uwOkD6+7qk5E3xio+ht7q5tKWqVjWY=;
  b=bJXelrFY+MP3zavDb7faeXoNlI+eLTX1j4SibhTgQbShPF/b5oB8Q8Qw
   FHgk3oRi6v1ghBmnL6gGPynM/sZL18itbarChoq8nUjFD8VL9QC86FkCw
   dkWJaJPNwgkkda5SW01qZBZcu5tRUzruh0lrxc6h8sphZBsRUMUy3ad0T
   2ndvhtkDAM52PTYUT183nxDSrMvfSRfywuCmhSRImDNPeKo0yBuCKhH9r
   sD5SFntGcavEVeyllNpCeXg/Qo2vfkBtZ1kPQck3IsWHvXneqXnCu2XJd
   2/BPGCewgycTUsvC28cRFkNxLc3lp4MuzW/RGFO6Ydqt+cEcUljHuVjiA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="358354221"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="358354221"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 03:57:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="1074098700"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="1074098700"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 03:57:16 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] md: do not _put wrong device
Date:   Mon, 11 Sep 2023 12:56:57 +0200
Message-Id: <20230911105657.6816-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Put the device which has been _get with previous md_seq_next call.
Add guard for improper mddev_put usage(). It shouldn't be called if
there are less than 1 for mddev->active.

I didn't convert atomic_t to refcount_t because refcount warns when 0 is
achieved which is likely to happen for mddev->active.

It fixes [1], I'm unable to reproduce this issue now.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217798
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---

There is md_seq cleanup proposed by Yu, this one should be merged
first, because it is low risk fix for particular regression.

This is not complete fix for the problem, we need to prevent new open
in the middle of removal, I will propose patchset separately.

 drivers/md/md.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0fe7ab6e8ab9..ffae02406175 100644
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
@@ -8250,8 +8256,7 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		next_mddev = list_entry(tmp, struct mddev, all_mddevs);
 		if (mddev_get(next_mddev))
 			break;
-		mddev = next_mddev;
-		tmp = mddev->all_mddevs.next;
+		tmp = next_mddev->all_mddevs.next;
 	}
 	spin_unlock(&all_mddevs_lock);
 
-- 
2.26.2

