Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85283C74A5B
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 16:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjCWQPv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjCWQPg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 12:15:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E76828D03
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 09:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679588123; x=1711124123;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N4M2UDVelq+/HgWtjwUIbeeW9wpXB7W4DdHmYhcAlZg=;
  b=gTwByN2hIalgYwvnnwpJIQxsbrnINp7f7K41w9k0YhzAUfq71dhshwxI
   YvserMqg4lbYHTMZtM6sJB96fNgAJYVQexX1KCqaQZFpaBjYFRlrVaPL0
   WUE4qUrbYuMfRxNHWKwI6VFB9pJFZqijYqmkTx3Yb3jaZtLjQK3pNxmHH
   OljsPLUTHul8QLKuL/e46D2sY9SX8nXEUHpQsGT2Gzp7vOumCGHCv067I
   zxv4YM9X/k7B1tyqEWlvtgR/80j6lc+fuHUnvFalqkAt7ET7Fi2FukzbS
   AK2OTY3QmNiOV8aL4uUrcvLZHhzev4ZIQIeQY/YJTQ62f77S15UuD8qSt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="341918543"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="341918543"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:13:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="928304743"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="928304743"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 09:13:36 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH] Revert "Revert "mdadm/systemd: remove KillMode=none from service file""
Date:   Thu, 23 Mar 2023 17:13:18 +0100
Message-Id: <20230323161318.25564-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This reverts commit 28a083955c6f58f8e582734c8c82aff909a7d461.

Resolved by commit 723d1df4946e ("mdmon: Improve switchroot
interactions.") We are ready to drop it.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 systemd/mdadm-grow-continue@.service | 1 -
 1 file changed, 1 deletion(-)

diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-continue@.service
index 9ccadca3..64b8254a 100644
--- a/systemd/mdadm-grow-continue@.service
+++ b/systemd/mdadm-grow-continue@.service
@@ -15,4 +15,3 @@ ExecStart=BINDIR/mdadm --grow --continue /dev/%I
 StandardInput=null
 StandardOutput=null
 StandardError=null
-KillMode=none
-- 
2.26.2

