Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD82C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 19 Apr 2022 14:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244703AbiDSOkO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Apr 2022 10:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353494AbiDSOkM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Apr 2022 10:40:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD4320F70
        for <linux-raid@vger.kernel.org>; Tue, 19 Apr 2022 07:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650379049; x=1681915049;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aTXKv9fmNUiIZQDUwDWShbUhSQhZnxQpzIvbiwoWLhk=;
  b=LSLFHEQfiLVHg4mUoJIT14z6EFzYgaTuxqIjjNZeHthDYU3n5shAG7pG
   YtB2BLqkSGOvdnlelEf3GqKFrW1cxRc92eyvQJPUugizYqJunsO96hsqh
   1vF4KvrIdDWxcC5qC52jFbSG28UoSWgWWm8h2j1wCKiNHIQAjiqfGyj6j
   zC3R4BRQPULpZnqm1h6MFG70k7XeQusCFd0o3sFhBx9jp7Txy5Qn5S4Ji
   LmdaUNoCfRbkmnzynKfXF+N4wHjim95kDwFY0Xgb+n5ZXFeBbPoDZTSoj
   +b5RNoPGO83NqGnGdbltkO1Gird0R3fH/ML7Sm2+6UQSJKe8YBMs0UanR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="263951995"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="263951995"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 07:37:27 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="576128924"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 07:37:26 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/3] IMSM autolayout improvements.
Date:   Tue, 19 Apr 2022 16:37:11 +0200
Message-Id: <20220419143714.16942-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes, Coly

Following patchset modifies some parts of IMSM creation to ensure that
member's order is always same. It is ISM metadata requirement.

Additionally, as discussed with Jes I've started to implement more modern error
handling, by adding special enum for IMSM. Will be great to hear any comments
and opinion.

I've tested it with our internal test scope, no regression observed.

Mariusz Tkaczyk (3):
  imsm: introduce get_disk_slot_in_dev()
  imsm: use same slot across container
  imsm: block changing slots during creation

 super-intel.c        | 250 +++++++++++++++++++++++++++++--------------
 tests/09imsm-overlap |  28 -----
 2 files changed, 167 insertions(+), 111 deletions(-)
 delete mode 100644 tests/09imsm-overlap

-- 
2.26.2

