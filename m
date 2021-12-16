Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C215EC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 16 Dec 2021 14:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhLPOxN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 09:53:13 -0500
Received: from mga17.intel.com ([192.55.52.151]:29659 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232529AbhLPOxM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 16 Dec 2021 09:53:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="220190263"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="220190263"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:52:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="466093984"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:52:47 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH v2 0/3] Use MD_BROKEN for redundant arrays
Date:   Thu, 16 Dec 2021 15:52:19 +0100
Message-Id: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,
As discussed in first version[1], I've done following:
- errors handler for RAID0 and linear added
- raid5 bug described
- MD_BROKEN described
- removed MD_BROKEN check for superblock update.

[1] https://lore.kernel.org/linux-raid/20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com/

Mariusz Tkaczyk (3):
  raid0, linear, md: add error_handlers for raid0 and linear
  md: Set MD_BROKEN for RAID1 and RAID10
  raid5: introduce MD_BROKEN

 drivers/md/md-linear.c | 15 ++++++++++++++-
 drivers/md/md.c        | 23 +++++++++++++++--------
 drivers/md/md.h        | 14 ++++----------
 drivers/md/raid0.c     | 15 ++++++++++++++-
 drivers/md/raid1.c     |  1 +
 drivers/md/raid10.c    |  1 +
 drivers/md/raid5.c     | 34 ++++++++++++++++------------------
 7 files changed, 65 insertions(+), 38 deletions(-)

-- 
2.26.2

