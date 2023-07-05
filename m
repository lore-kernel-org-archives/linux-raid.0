Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D5EEB64DA
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jul 2023 15:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbjGEPLX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjGEPLW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jul 2023 11:11:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7035F7
        for <linux-raid@vger.kernel.org>; Wed,  5 Jul 2023 08:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688569881; x=1720105881;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eZW4LUdtgfa6go/ArQmMS2Pvyr9Nc/DK8xF0DQbgavc=;
  b=lTHEF4jLZjuKWVYY+cVlA20c9ni5rYBKn4/IihKusm/XOyB4bG39ErYt
   L10QQmJ82ztX1JrWTd9GgMrIXfB/a6MLA7nSv5BsnHaWyf4k6qTvg6DcT
   22qQEcn3C1cQjRidPwCKAmTX2V9iSrtpyOCHfzHIasdZwMXEll5J+nLRO
   7sLfN+EMkiKFLyYnB2Ao1IcmSTPjfGKQD2ISDUgLphlk/bfoMmUqI2yIe
   Aaew3BaR964Tv1Fwn865BJsG3kUygCAHuXs8HHKf2+QwWIeQAiU7WMuT3
   2tTwT4eSw2dAd0i4CerHUeGWGraibWxjrpeX9yyGqI/udxGqmd2/gTx54
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="342957578"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="342957578"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 08:11:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="713223763"
X-IronPort-AV: E=Sophos;i="6.01,183,1684825200"; 
   d="scan'208";a="713223763"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.104.85])
  by orsmga007.jf.intel.com with ESMTP; 05 Jul 2023 08:11:19 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v4 0/2] Mdmonitor refactor and udev event handling improvements
Date:   Wed,  5 Jul 2023 16:49:42 +0200
Message-Id: <20230705144942.30630-1-mateusz.grzonka@intel.com>
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

v4:
Fix building errors. Only two last patches out of 8 didn't apply, so I'm sending just them.

Mateusz Grzonka (2):
  Mdmonitor: Improve udev event handling
  udev: Move udev_block() and udev_unblock() into udev.c

 Create.c  |   1 +
 Makefile  |  18 ++---
 Manage.c  |   3 +-
 Monitor.c | 137 ++++++++++++++------------------------
 lib.c     |  42 ------------
 mdadm.h   |   3 -
 mdopen.c  |  19 +++---
 udev.c    | 194 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 udev.h    |  40 +++++++++++
 9 files changed, 306 insertions(+), 151 deletions(-)
 create mode 100644 udev.c
 create mode 100644 udev.h

-- 
2.26.2

