Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1432CDB465
	for <linux-raid@archiver.kernel.org>; Thu, 19 Oct 2023 14:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345777AbjJSOfj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346183AbjJSOfh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Oct 2023 10:35:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A469195
        for <linux-raid@vger.kernel.org>; Thu, 19 Oct 2023 07:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697726135; x=1729262135;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hDeUoHVRczdsREXEyW6mJzugeISWUCibdJQ82icFoZg=;
  b=a1a48rG/XWCEk+IVyXuS2FbgSf2erEgMeMV5e52eCtkOAde5grr9o4IF
   PiIb+nFS2ePuKUC1MzNkKDyK2UhnEyffNoGS4eSfjiqIxs6VVJ+ZEmXXU
   Atxvb18naZO4HXJxVilXvATLCKdCK2rCQk1l4uMV5DVIlxwLujgFSXftE
   kF/ur8U9BEqnVLGyi06MBXH/s/xiKIpGAp4Os8F3KtixCUdU/ixMj7YIN
   P7yoi+BNEFkIM3BWPrYvJ8RV5dG/+4cvH/7i2BBS4Pqey/M+bGq4/KrW5
   +bHiDtLIKNJDPRUJQU6M8uTCmrPub/If6AImziqlcTQY0Z/Wzrv6rRTxU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="385139962"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="385139962"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 07:35:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="880675453"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="880675453"
Received: from dev-ppiatko.ger.corp.intel.com ([10.102.95.202])
  by orsmga004.jf.intel.com with ESMTP; 19 Oct 2023 07:35:33 -0700
From:   Pawel Piatkowski <pawel.piatkowski@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 0/2] Remove container_enough logic
Date:   Thu, 19 Oct 2023 16:35:23 +0200
Message-Id: <20231019143525.2086-1-pawel.piatkowski@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Pawel Piatkowski (2):
  mdadm: remove container_enough logic
  Fix assembling RAID volume by using incremental

 Assemble.c    | 10 ++++------
 Incremental.c | 11 -----------
 mdadm.h       |  3 ---
 super-ddf.c   |  1 -
 super-intel.c | 32 +-------------------------------
 5 files changed, 5 insertions(+), 52 deletions(-)

-- 
2.39.1

