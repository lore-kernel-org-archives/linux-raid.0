Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FF3C7EE29
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjE2NyC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjE2Nx1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:53:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9253118
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685368377; x=1716904377;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1DOFrGed0KQ4NkAe8NhZQJwPKD2aF5Mb5GhziGPE2Nc=;
  b=TpfB8S6TxHEcWhKLagien6I+vuQYeKUa8EONnJm/iVi2WLPgxIgFjnhl
   a/mbiXAEyylOpRZdiN40vcdLosoCX6VPv77DG4kD6Dyuppw3ar02lHBv0
   Uj5u5QgXwCXmO6i+18absJFR5E4WjcbEPmqqZOQXLpovSBOCJzcQjiGPC
   mJtVOvomKUEeUEiOldxTHp4cjY7jOCQFGpmRapCAaAWUya7iC9GoOdrZJ
   W3Pf3jkU1oGB5+ABI7FfPguy3ZOlz+Tf3SCvdZpXIEzJYg1ymP2PYjGRx
   2/ZCscqqgfaOpesDO44bJD/R67roW5GqbQEDQkVTqlexatcEDKy5g1Dvm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418193837"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="418193837"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:52:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="706069258"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="706069258"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:52:53 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 0/6] imsm: expand improvements
Date:   Mon, 29 May 2023 15:52:32 +0200
Message-Id: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

merge_extents() was initially designed to support creation only. Expand
feature was added later and the current code was not updated properly.
Now, we can see two issues:
1. --size=max used with expand and create result in different array size.
2. In scenarios, where volume were deleted an recreated it may not be
possible to expand the volume.

The patchset addresses listed issues and removes limitation to the last
volume for expand.

Mariusz Tkaczyk (6):
  imsm: move sum_extents calculations to merge_extents()
  imsm: imsm_get_free_size() refactor.
  imsm: introduce round_member_size_to_mb()
  imsm: move expand verification code into new function
  imsm: return free space after volume for expand
  imsm: fix free space calculations

 super-intel.c | 363 ++++++++++++++++++++++++++++----------------------
 1 file changed, 202 insertions(+), 161 deletions(-)

-- 
2.26.2

