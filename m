Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEBEC4332F
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 10:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiLSKWF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 05:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiLSKWD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 05:22:03 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A6D2BFF
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 02:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671445322; x=1702981322;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xaR46A+YGGP+LlEq5QGAe63BMy9pcXUvtq6SYAkh4iE=;
  b=FGZ3eBeL0o5h2O0hVBDqV34eqnKGI2qg5u2VIGWEqytqrAzx6suUIXQE
   Sl0ITB0l5vy65+p7bLQcuihOADfJ5v01Cp2eBuq4RvMM0JXkDc5JEtNtN
   KeCovAC2ezKuhDah92rPgs7pyZd+njjgakMvJC15WT5DkTy6AyvxzaSBv
   wodGBMGfALCZriIvHHaq2cQA8PuXJ7A6tpyUb4dCFju9CQCaauoHx/WlP
   zzj9TPu8whHiuQm0NoXOg1qMYA463GwauLP1nrSU3ag+OXBHhj+Db1Tsn
   S01FTbABKHKA3ZgbYBBLLE45CqI9v5s2lE+LLwK/CffhuXijpvINjVeKM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="319364334"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="319364334"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 02:22:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="824805155"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="824805155"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orsmga005.jf.intel.com with ESMTP; 19 Dec 2022 02:22:00 -0800
From:   Blazej Kucman <blazej.kucman@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH V2 0/2] Changes in Monitor
Date:   Mon, 19 Dec 2022 11:21:56 +0100
Message-Id: <20221219102158.10180-1-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, Jes, Coly
In first patch blocked is starting monitor when
--scan mode and MD devices list are combiened,
to prevent undefined behaviors.
Second patch containst monitor manual update.

Changes in V2:
- remove unnecessary line from commit message

Blazej Kucman (2):
  Monitor: block if monitor modes are combined.
  Update mdadm Monitor manual.

 Monitor.c  |  7 +++++-
 mdadm.8.in | 71 ++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 56 insertions(+), 22 deletions(-)

-- 
2.35.3

