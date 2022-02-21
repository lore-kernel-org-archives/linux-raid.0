Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5835AC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 21 Feb 2022 10:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353281AbiBUK0f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Feb 2022 05:26:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354416AbiBUK0S (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Feb 2022 05:26:18 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AF6E6E
        for <linux-raid@vger.kernel.org>; Mon, 21 Feb 2022 01:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645436886; x=1676972886;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l0gLFvZEPLsboXYQQpJBJSBEHzyFQcdMzqx4xBXOoGY=;
  b=jOmBeKQdHWAQCUOsCetD8Zmzcs1L6cJSQ/xfX/uB1vJgVw9CmiA0T+wp
   P5RsNyAo1sKIW2JXBFp8v/ruGQt8U6q0OWa7trKDExY65SG9t8A5cA7b0
   FnItch0GT70+yB0JQL9MGh1TROLuMrXS98inzjCvfvsLgLEHrpQXSPNR9
   6na+z3gizT3ZlOfW/aDHlSxX0AVnxqSTzk2GNaMI68qVDiVfk3oDn+E+c
   5lIOgb7wJ1ALI2NedfvUyGP9pg34JSDNEz/Wo0A61ikpGqk1cqYjzPngz
   z4xek194nZ9k6PhS+XlP+PAof+VfJbnOn6jsn9Jl6MimqP7vJJQg3cjJs
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251658564"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="251658564"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 01:48:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="507579542"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.108.83])
  by orsmga006.jf.intel.com with ESMTP; 21 Feb 2022 01:48:04 -0800
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de
Subject: [PATCH 0/2] Improve signal handling.
Date:   Mon, 21 Feb 2022 10:47:49 +0100
Message-Id: <20220221094749.9327-1-lukasz.florczak@linux.intel.com>
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

