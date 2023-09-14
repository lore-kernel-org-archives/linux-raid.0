Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1AEEEAA51
	for <linux-raid@archiver.kernel.org>; Thu, 14 Sep 2023 15:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbjINPYo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Sep 2023 11:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240832AbjINPYo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Sep 2023 11:24:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3124C1FD0
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 08:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694705080; x=1726241080;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ewnvJ4C3NpqCzHB7cMxPMFYa8eE8+EUPC1dNOuA95a8=;
  b=WCKS0f0+wqPHMMwst1dM4lktozkXkKUjCY0dk7XCS57a1oPBs40o1VfJ
   6NMtEs4sd3UIWGvpd1piIJT/EdDbbSHO5OqybhpCfutn/KqSwpSzoPKOm
   vNXV1XQAhu/IY4c41Ntpl7xfCMJwqdytVyaomG2H1FFAPt43yDB3qRohg
   UMwMTAqQVZeQSmaiIbPHVagpRl3opKe0KzV5HrKZg/yrUDfJgH1BL/8WS
   lQKu09ZycF0LSTcajzVWPd70fk9dxxTRB3bPuOGrCf+ZJSgZjXKbl6JAY
   kt6wzTNZq4dQA86yuKAraN4xb/Aej6DsWKpNOwofjR7dNqM9Kc5334v6Y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="443032798"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="443032798"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 08:24:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="737937667"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="737937667"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 08:24:38 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Yu Kuai <yukuai3@huawei.com>, AceLan Kao <acelan@gmail.com>
Subject: [PATCH v3] md: do not _put wrong device in md_seq_next
Date:   Thu, 14 Sep 2023 17:24:16 +0200
Message-Id: <20230914152416.10819-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If there are multiple arrays in system and one mddevice is marked
with MD_DELETED and md_seq_next() is called in the middle of removal
then it _get()s proper device but it may _put() deleted one. As a result,
active counter may never be zeroed for mddevice and it cannot
be removed.

Put the device which has been _get with previous md_seq_next() call.

Cc: Yu Kuai <yukuai3@huawei.com>
Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the disk is freed")
Reported-by: AceLan Kao <acelan@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217798

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0fe7ab6e8ab9..b8f232840f7c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8256,7 +8256,7 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	spin_unlock(&all_mddevs_lock);
 
 	if (to_put)
-		mddev_put(mddev);
+		mddev_put(to_put);
 	return next_mddev;
 
 }
-- 
2.26.2

