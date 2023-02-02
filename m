Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB32BC636D3
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 11:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjBBLpw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 06:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjBBLpu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 06:45:50 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3026A8C1F0
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 03:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675338350; x=1706874350;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0aIEVknsYhkUdJveX1q3Kx2RMCrHGnlDdvXB0EKVf9s=;
  b=YjjIDP7tsRlSjWHVrK8HK8JTEgkuiNx+es7rkvkvuGB85gGBRB66LVu6
   +LrVaicbCabmB45s2IthPL4q0rYBO4XFywvRn2fQLXhovYGO0Tr9VPCZF
   rfOvja+SE9O82J0VB04fRcA8e4XDufXd57vCRx0A7BsboYzrPgnGIjqRF
   s4eeRpcEOvFsYDBlCDNJfmXZ8WPMUTJSneWkJZsrR4DpPm3Wk9BSOX9pj
   KYq+Pn97Qbv4ZoalPy61I0XZV9epmLnp47Mfd0uTEJ8b/wqgIuPkk+OFN
   GmZsjVrmZULaSPzYorp17WDYWAIlVvGygjWC6SgQbu4q1qQMJM6VbWmDq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="327075839"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="327075839"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 03:45:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="697660768"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="697660768"
Received: from unknown (HELO localhost.elements.local) ([10.102.104.85])
  by orsmga001.jf.intel.com with ESMTP; 02 Feb 2023 03:45:48 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v3 0/8] Mdmonitor refactor and udev event handling improvements
Date:   Thu,  2 Feb 2023 12:26:58 +0100
Message-Id: <20230202112706.14228-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Along the way we observed many problems with current approach to event handling in mdmonitor.
It frequently doesn't report Fail and DeviceDisappeared events.
It's due to time races with udev, and too long delay in some cases.
While there was a patch intending to address time races with udev, it didn't remove them completely.
This patch series presents alternative approach, where mdmonitor wakes up on udev events, so that
there should be no more conflicts with udev we saw before.

Additionally some code quality improvements were done, to make the code more maintainable.

v2:
Fixed mismatched comment style and rebased onto master.

v3:
Resend to cleanup on patchwork.

Mateusz Grzonka (8):
  Mdmonitor: Make alert_info global
  Mdmonitor: Pass events to alert() using enums instead of strings
  Mdmonitor: Add helper functions
  Add helpers to determine whether directories or files are soft links
  Mdmonitor: Refactor write_autorebuild_pid()
  Mdmonitor: Refactor check_one_sharer() for better error handling
  Mdmonitor: Improve udev event handling
  udev: Move udev_block() and udev_unblock() into udev.c

 Create.c  |   1 +
 Makefile  |   3 +-
 Manage.c  |   3 +-
 Monitor.c | 623 +++++++++++++++++++++++++++++++++---------------------
 lib.c     |  42 ----
 mdadm.h   |   5 +-
 mdopen.c  |  19 +-
 udev.c    | 191 +++++++++++++++++
 udev.h    |  38 ++++
 util.c    |  45 ++++
 10 files changed, 668 insertions(+), 302 deletions(-)
 create mode 100644 udev.c
 create mode 100644 udev.h

-- 
2.26.2

