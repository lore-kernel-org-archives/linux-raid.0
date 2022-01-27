Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCBFC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 27 Jan 2022 15:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242669AbiA0PjZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Jan 2022 10:39:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:9378 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241597AbiA0PjY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 27 Jan 2022 10:39:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643297964; x=1674833964;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hTVLnOdVoa2a2lnUsUUqkrppRuux6N9ib4L2CrOdWxk=;
  b=k11dYKIdJg/la7idSYgI1VU2Po3FTyBKLL9cXm0QsKjpzDfC6+ieWJZF
   S7/UQeuk0WmfMK/77KXSoVm61jP564AmvXpHIp4YWJpCJXieuL/5hFP1u
   2ePxt6wb1bquy8LWSvT5pZaTN6qLS4O1QVsA9FhPId9Gb51ax9pII4bga
   rtKs2EbO5W8LjdaQQYEt419dTw0X/ZFgCYd8RBHVnmZXPx61W/fQlllv3
   0JN7nAJqQe/0/Oy7SjG2ubsBr7qGMgl2B93m/gAOL8rFK7wrBCrInRa47
   BY7mP4uRaKLiVyX67yvcx4/LRUwXBwzgZZiz0LvLrKK4cCEappp4xxrXm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="247107842"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="247107842"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:39:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="696692394"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:39:23 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH v3 0/3] Improve failed arrays handling.
Date:   Thu, 27 Jan 2022 16:39:08 +0100
Message-Id: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,
I've made changes as discussed in v2[1]. I did manual testing with IMSM
metadata.

Patch 1:
- "%pg" propagated and raid0/linear_error refactored as Suggested by Guoqing.
- missed dm-event, suggested by Guoqing- verified. IMO the behavior is same as
  before.

Patch 2:
- Commit id fixed, suggested by Gouqing.
- Description rework, suggested by Xiao (discussed offline).
- fail_last_dev handling added (and verified).
- MD_BROKEN description modified, suggested by Gouqing.
- Descriptions for raid1_error and raid10_error are added, redundant comments
  are removed.

Patch3:
- Error message for failed array changed, suggested by you.
- MD_BROKEN setter moved to has_failed(), suggested by Gouqing.
- has_failed() refactored

Other notes:
I followed kernel-doc style guidelines when editing or adding new descriptions.
Please let me know if you consider it as unnecessary and messy.

I also noticed potential issue during refactor related to MD_FAILFAST_SUPPORTED,
please see the flag definition. I'm wondering if fail_last_dev functionality is
not against failfast. Should I start separate thread for that?

[1] https://lore.kernel.org/linux-raid/CAPhsuW43QfDNGEu72o2_eqDZ5vGq3tbFvdZ-W+dxVqcEhHmJ5w@mail.gmail.com/T/#t

Mariusz Tkaczyk (3):
  raid0, linear, md: add error_handlers for raid0 and linear
  md: Set MD_BROKEN for RAID1 and RAID10
  raid5: introduce MD_BROKEN

 drivers/md/md-linear.c | 15 ++++++++-
 drivers/md/md.c        | 23 +++++++++-----
 drivers/md/md.h        | 72 ++++++++++++++++++++++--------------------
 drivers/md/raid0.c     | 15 ++++++++-
 drivers/md/raid1.c     | 42 ++++++++++++++----------
 drivers/md/raid10.c    | 33 ++++++++++++-------
 drivers/md/raid5.c     | 49 ++++++++++++++--------------
 7 files changed, 151 insertions(+), 98 deletions(-)

-- 
2.26.2

