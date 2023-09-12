Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDBECA0EC3
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 09:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbjILJWf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Sep 2023 05:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbjILJWd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Sep 2023 05:22:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10010E7A
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 02:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694510550; x=1726046550;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=W3yDBJ8KBbAXASmv6+uy2P56DLXaskJViYVFJtHbkek=;
  b=jj0MbwUI6Ed4SRX//EUUzPPDcERJQ3IvByQmHrV2t/z0FvtNkPG8gek6
   qhgmPBhJSGV2wtyGgPb1zASW5ooUDKe6Kgl2wW2R6crkS5OzAXt6VVmQL
   4/1aAfw7lM0Zgz0L4VnIwSzRb8TtKP+graKuMz65CCrc6Lvi4AU8SO0bi
   gkQBD+C9GbApqRXkG96MQ2qiTbXqoM7DVw6WUpAqS3jch/gmEE0g6MEOd
   nocbycNQdy8GS+QHzYZep7BA8Oz5eO8Df3taBEc2Jkzyw2puBe00RH+Rs
   sUdfVOWQVEMpkBf0zX2hLVutBYpr36BBn6Dyfw1HNgviIYYH3Ld29VKga
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="381023669"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="381023669"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 02:22:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="833841023"
X-IronPort-AV: E=Sophos;i="6.02,245,1688454000"; 
   d="scan'208";a="833841023"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Sep 2023 02:22:27 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] Assemble: fix redundant memory free
Date:   Tue, 12 Sep 2023 04:27:01 +0200
Message-Id: <20230912022701.948-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit e9fb93af0f76 ("Fix memory leak in file Assemble")
fixes few memory leaks in Assemble, but it introduces
problem with assembling RAID volume. It was caused by
clearing metadata too fast, not only on fail in
select_devices() function.
This commit removes redundant memory free.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Assemble.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 61e8cd17..5be58e40 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -428,8 +428,6 @@ static int select_devices(struct mddev_dev *devlist,
 
 			/* make sure we finished the loop */
 			tmpdev = NULL;
-			free(st);
-			st = NULL;
 			goto loop;
 		} else {
 			content = *contentp;
-- 
2.26.2

