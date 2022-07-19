Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0296C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 13:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbiGSNdv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 09:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbiGSNdi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 09:33:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C1B8CCA5
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 05:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658234955; x=1689770955;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3oxFCMGNhtOEsA7iJFtip2KYOpeX+teS8YbwNLUS1sM=;
  b=RynghIxOC1J0uH7ZCC/EKCBzuZvF6+fCYUVl0I6zyijUnxfMar6kayni
   JmQcqQYmqFqPk49VlaiMWXOc6u8NU1I/nYyTremoQ0y//4stHAtZ9KHcZ
   FykVVkOaLkPlOQWZKXZ+csbQfQQEa43Xe3ZXxyGhrnsTFfPWkO1wxFLdU
   1SqbfSUPyQhUyN0VYhOas44zSQvzoOlsKzd77NV+jllOzZpGKCu/hLN2e
   iPeMT172B3tcQIxrCKUTuyGCrpgMqYxJkyJr9wlFSH9LmK0zafTrxUkuc
   CYfkvrAAjrOZutSyMKTpcOzMSSDS7bSRLxLIF8ZRG42Mlyxd2GkVKv6xd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287225184"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="287225184"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 05:48:40 -0700
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="687100939"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 05:48:39 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/3] Add test for names.
Date:   Tue, 19 Jul 2022 14:48:20 +0200
Message-Id: <20220719124823.20302-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,
In first patch test for MD device names is added. This is entry for
future create_mddev() updates - we need test to avoid regression.
Beside that, small code improvements are done.

Thanks,
Mariusz

Mariusz Tkaczyk (3):
  tests: add test for names
  mdadm: remove symlink option
  mdadm: move data_offset to struct shape

 Create.c            | 16 ++++----
 Grow.c              |  7 ++--
 ReadMe.c            |  1 -
 config.c            |  7 +---
 mdadm.8.in          |  9 -----
 mdadm.c             | 40 +++++--------------
 mdadm.conf.5.in     | 15 --------
 mdadm.h             |  7 +---
 tests/00createnames | 93 +++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 116 insertions(+), 79 deletions(-)
 create mode 100644 tests/00createnames

-- 
2.26.2

