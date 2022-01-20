Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3D4C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 20 Jan 2022 12:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241654AbiATMSp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Jan 2022 07:18:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:54204 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241672AbiATMSo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Jan 2022 07:18:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642681124; x=1674217124;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LcovNe/UfpdVcx5+GhEJ5Ytf1OIrn6TuP0xCxHvB0wM=;
  b=eN9hIu+m0pJOWTDf7YyazS+VQKPGGf3CcpsyvQh0SF4ecBnw/gtsKkQ3
   J1z8D9QVoKEU4nQVTrUOXQEuRP5k3EsMfGCMCZJCJ8oBwjHWRL+cAN2sc
   r3WWqPGvNNyc5Jm9Q+e2y0b/zpsBqbFZnfe8rniR8m0yB2Btpl3a0U+Em
   RJQWX9/wxTnBOT76y+mFEDFGSbYrnDGhPUnp+OkKqSo9jFKWxmqDPGE9S
   dMwLVCkVwl9Vnu2rrW2mJyPg+zNYt5Q2gMubxciMXuRSHI9guH2HrLs28
   z1BAPx2V8TdculJq7axugVx2AuK+afV7SQxURmc0iU2aNciXWpkrGjteX
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="242902481"
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="242902481"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 04:18:42 -0800
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="532750992"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 04:18:41 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/2] Add map_num_s
Date:   Thu, 20 Jan 2022 13:18:31 +0100
Message-Id: <20220120121833.16055-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,
In this patchset not null version of map_num() was added.
Additionally, I propagaded default_layout() for Build mode.

I tested changes and I didn't find any regression.

Mariusz Tkaczyk (2):
  Create, Build: use default_layout()
  mdadm: add map_num_s()

 Assemble.c    |  6 ++---
 Build.c       | 23 +-----------------
 Create.c      | 67 +++++++++++++++++++++++++++++++--------------------
 Detail.c      |  4 +--
 Grow.c        | 16 ++++++------
 Query.c       |  4 +--
 maps.c        | 24 ++++++++++++++++++
 mdadm.c       | 20 +++++++--------
 mdadm.h       |  3 ++-
 super-ddf.c   |  6 ++---
 super-intel.c |  2 +-
 super0.c      |  2 +-
 super1.c      |  2 +-
 sysfs.c       |  9 ++++---
 14 files changed, 103 insertions(+), 85 deletions(-)

-- 
2.26.2

