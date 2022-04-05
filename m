Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54898C4707E
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 12:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbiDEMzX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 08:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384310AbiDEM1U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 08:27:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86775FABDC
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 04:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649158617; x=1680694617;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FPBq2LbSplbHiIBLJWxZ2upn9te1HoaZB2wZw3iqfeI=;
  b=S5PUsCq/9ZsXMYdIlnybkCFzvkCAk26OOYnrg2XFihszgxczXdXc/SwL
   Vp4O9KnygsJCuIeQhuBDwEus9fnDrGikh6BrUeoCM6xQZOd23w/qcv6y+
   4/872v/qydbJa9igjmIlb6LnRCSG+Snxr8a4PtBWrTLbEuJs4XOWXlMCo
   S8dhTet9vikJ2TLyGJu19k7LGUXNXzacCyrcHcDCljsOvqkwKIi9vjloI
   chrzHIqjshdOBiriM/lzajawI2wFHKbWUoFuvYiSkIvPgVCGllTUWvpld
   2OZ1Zv8JJMjnjGLvs63jKWvUxDe0tl7gTWahxFI6QIcLUJWDFfatE1I6B
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241313833"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241313833"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:36:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="569845790"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 05 Apr 2022 04:36:55 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH v2 0/2] Mdmonitor improvements
Date:   Tue,  5 Apr 2022 13:40:55 +0200
Message-Id: <20220405114057.27080-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Series of patches contains fix segfault for running
monitor for devices different than md devices. Also
logging was improved to have informations about monitor
in verbose mode.

Kinga Tanska (2):
  Mdmonitor: Fix segfault
  Mdmonitor: Improve logging method

 Monitor.c | 36 ++++++++++++++++++++++++------------
 mdadm.h   |  1 +
 mdopen.c  | 17 +++++++++++++++++
 util.c    |  2 +-
 4 files changed, 43 insertions(+), 13 deletions(-)

-- 
2.26.2

