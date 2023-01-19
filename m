Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58574C00A5A
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 13:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjASNtP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 08:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjASNtE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 08:49:04 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1295337B74
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 05:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674136142; x=1705672142;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3pn6efXInRk8izMJZrp1Ws7Us3ok29VwExqvBJJcXUo=;
  b=RFLjWr97QL0bX8jM1XGKvIqLhD2uu9xcr3cQBDqES/44HqA5WWUJwOY5
   fbBmp63Aa/sjkpNfIzteeTfOMAVJp91xiUOo/K/48Y/Ph+yhbOUbGviAb
   DKet0ZP6Dk6n94xzRTVAHiUmYckqreEKH9J2xIkwAKuELrDQ9ymCSP7nD
   +xKEmW5Yn2QquMhgPoL5bqpE2JK4dUs/0ok5bSikXmSKjiNpvIADRfLZ5
   DMqsfdB0a+GsxiHGjFtB1u3kuihp9fw8AvoKcIlbSoffD87n4bZ1JNVs8
   tTdwfaAIqHceL8us+y0a1v4xSHikN6bIAJ9UH87aUXkhrWB7D9ukpJmCL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="323973346"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="323973346"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 05:49:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="768221927"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="768221927"
Received: from unknown (HELO localhost.elements.local) ([10.102.104.85])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 05:48:58 -0800
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v2 0/8] Mdmonitor refactor and udev event handling improvements
Date:   Thu, 19 Jan 2023 14:30:01 +0100
Message-Id: <20230119133009.12696-1-mateusz.grzonka@intel.com>
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

