Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFECCC00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343865AbiHRO5U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343873AbiHRO5L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:57:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC64BBD09B
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834630; x=1692370630;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Kpb2cgJMGx8IMJgCYle+NiIWmZfR2w29bnwRz0YDRhs=;
  b=YvNBb8M82K62ObFEfpp5wBfDBpntWGiNn1mnix4HKkxfwV8BC7eWI5B0
   TSkNcTiYvuMHPWoukNSFFFD7SY9oI8U0EVJnhbjCyJJSAlX5ca2l2rpli
   L/E+FyJSLvs5/nUfeUz2nbnC3LtWwR+2+IGhKvlm2J0lrNybFuGOPt/5G
   krid6+rQEcLTTkLZNfohm5LE4DyqMCZscT5WQRUjzOSuQrEpCVmcRDF11
   LOkgGZvHBQFCzp31O7FEp16o4/UgTZ+mad6g39GPesh+MwsqQBo+3ovjt
   3hITLPMix6X0QGlT8bm4vTI5ww35/9E8Pyj7R+itijjhepGSpnZd9ZY2W
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="294052092"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="294052092"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:57:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084251"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:57:09 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 00/10] Block update-subarray and refactor context update
Date:   Thu, 18 Aug 2022 16:56:11 +0200
Message-Id: <20220818145621.21982-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patchset serves three main purposes.

Block updates on active volume with update-subarray and split subset of
options for --update and --update-subarray.

Remove dead code from super-ddf.

Change context->update from string to enum.

Mateusz Kusiak (10):
  mdadm: Add option validation for --update-subarray
  Fix --update-subarray on active volume
  Add code specific update options to enum.
  super-ddf: Remove update_super_ddf.
  super0: refactor the code for enum
  super1: refactor the code for enum
  super-intel: refactor the code for enum
  Change update to enum in update_super and update_subarray
  Manage&Incremental: code refactor, string to enum
  Change char* to enum in context->update & refactor code

 Assemble.c    |  46 ++++++++--------
 Examine.c     |   2 +-
 Grow.c        |  17 +++---
 Incremental.c |   8 +--
 Manage.c      |  42 ++++++++------
 ReadMe.c      |  31 +++++++++++
 maps.c        |  31 +++++++++++
 mdadm.c       | 124 ++++++++++++++---------------------------
 mdadm.h       |  65 +++++++++++++++++++---
 super-ddf.c   |  70 -----------------------
 super-intel.c |  49 ++++++++++-------
 super0.c      | 103 ++++++++++++++++++++--------------
 super1.c      | 150 +++++++++++++++++++++++++++++---------------------
 13 files changed, 399 insertions(+), 339 deletions(-)

-- 
2.26.2

