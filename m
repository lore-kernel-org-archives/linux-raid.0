Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B064C38145
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 13:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiIGNOM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 09:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiIGNOL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 09:14:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D811F7F247
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 06:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662556450; x=1694092450;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p7BeK1ePZgd/RFBsfkQ7LZqeQo2AfA/OpSRM6LbiizQ=;
  b=nmbDBCNJb4Xpvukn609t6XqcOmnzolJoBvqso2oHH+SoCkuA0bfr2fAF
   d7L4h8mgjhx6G9ACnjlTuuzS4YcyVXwlNK5EiIfIIUAvRnwif63y9hwwI
   KduWxXTSUxa0HPmjDiHWUuR5CKCEchX9Uwslrggr4ps6vPkJ/XTIagBAF
   qPL3N9itQ54UlUtuP8TJLwsMha/ZNUofMo0exsmD46jykLrfyLdG9ZWIT
   T9FXI+ZiXq+t0Ac27jixNPmzTs8Sgrzvbqszvo9oNcCOKQakR8l6x0adp
   g1iX4STSPUE/YgLvmfN6fZ72304cwtY5KI+BXSGHm/hAzX9IftvYxQaUK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="276605350"
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="276605350"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 06:14:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="644608556"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.105.50])
  by orsmga008.jf.intel.com with ESMTP; 07 Sep 2022 06:14:09 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 0/9] Mdmonitor refactor and udev event handling improvements
Date:   Wed,  7 Sep 2022 14:56:48 +0200
Message-Id: <20220907125657.12192-1-mateusz.grzonka@intel.com>
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

Mateusz Grzonka (9):
  Mdmonitor: Split alert() into separate functions
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
 Monitor.c | 707 ++++++++++++++++++++++++++++++++----------------------
 lib.c     |  42 ----
 mdadm.h   |   6 +-
 mdopen.c  |  19 +-
 udev.c    | 191 +++++++++++++++
 udev.h    |  38 +++
 util.c    |  46 ++++
 10 files changed, 713 insertions(+), 343 deletions(-)
 create mode 100644 udev.c
 create mode 100644 udev.h

-- 
2.26.2

