Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE2FC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 21 Feb 2022 12:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357272AbiBUMGC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Feb 2022 07:06:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357268AbiBUMGB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Feb 2022 07:06:01 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C997A201A8
        for <linux-raid@vger.kernel.org>; Mon, 21 Feb 2022 04:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645445138; x=1676981138;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l0gLFvZEPLsboXYQQpJBJSBEHzyFQcdMzqx4xBXOoGY=;
  b=SUMaHQ15ruMqRk/SYCpOipwlmRCzY/QECkjOBIFm3z34Q6Yq5aE2hLZG
   zz+XY1miWmC0nB+pLqEQkPHlRZhEkJQXq/ZeNchg4i7Vs84KpXTURKhOG
   IDldEn18DK5zxVZKOCR5EgHWW8xvFi7J+TbKFkmTMOgIKOaUiL8Q4cSde
   OTnopB0PD9rBs0ohtAtiN8LDbGSpjg6R8zTJnqmwRcpuHk5jppt4RuCSc
   nhgAthsEW22eg29figS9SslFrUdJ18xfHUFGpbVjA1pIrAlbLwmKCRDCI
   z2pN6dsMS0ONR4aToOdTnsqxgsbKIiPgqnPPLLa1m1IuNRe1GBgpEA9GJ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="312241044"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="312241044"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 04:05:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="547311524"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.108.83])
  by orsmga008.jf.intel.com with ESMTP; 21 Feb 2022 04:05:37 -0800
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de
Subject: [PATCH v2 0/2] Improve signal handling.
Date:   Mon, 21 Feb 2022 13:05:19 +0100
Message-Id: <20220221120521.16846-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Patch 1:
- Introduce signal_s() wrapper.
- Replace signal() with signal_s() calls.
- Remove redundant signal.h headers.

Patch 2:
- Optimize signal setting in alert() function.

Lukasz Florczak (2):
  Replace error prone signal() with sigaction()
  Optimize signal setting in alert() function.

 Grow.c       |  4 ++--
 Monitor.c    |  7 +++++--
 managemon.c  |  1 -
 mdadm.h      | 22 ++++++++++++++++++++++
 mdmon.c      |  1 -
 monitor.c    |  1 -
 probe_roms.c |  6 +++---
 raid6check.c | 25 +++++++++++++++----------
 util.c       |  1 -
 9 files changed, 47 insertions(+), 21 deletions(-)

-- 
2.26.2

