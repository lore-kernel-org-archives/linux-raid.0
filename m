Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6AAC7EE23
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 15:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbjEaPWC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 11:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbjEaPV3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 11:21:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218FFC0
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 08:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685546488; x=1717082488;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1DOFrGed0KQ4NkAe8NhZQJwPKD2aF5Mb5GhziGPE2Nc=;
  b=i1ly1FEELy7aV+KFoW4QbJKlDk+SCOGBkIb++FA0+Y5HS9VezWtAgP3G
   Is/vEHqRgd7QSh/GLVFP7RETcdlndHhYpozfvIhumv8+DB70gKxC3Ih92
   CEReDpDndS9uYqHOHTK8Cn8h4enkh9pZSXzVbTV3VRoRHueJIsmmOczsX
   QVJEJGMTfSTKKxbYe5rBUm8+AOay2/gR81svV+JH9cx3qkeBcZfQjWu8Q
   sZb77yCTRvyEU3tTr32h8Jq28WIhL8N5BEUDHS9Uc25Yl9G3XONIFenMK
   vJ52qx0K0V1AytjaCkmwekTmTvO2KoeAgI/9z6VHVMA4QcHzj+I3O3lYn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="339864894"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="339864894"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:21:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="796747337"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="796747337"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:21:26 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 0/6] imsm: expand improvements
Date:   Wed, 31 May 2023 17:21:02 +0200
Message-Id: <20230531152108.18103-1-mariusz.tkaczyk@linux.intel.com>
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

