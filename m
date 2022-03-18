Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBFFC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 08:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiCRI1m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Mar 2022 04:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiCRI1l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Mar 2022 04:27:41 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A0210506D
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 01:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647591983; x=1679127983;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wEMl06eunLh752oBjUZbvECjKVoEj+GzIszvOaNKRTc=;
  b=VZBG6gomyOtXxkHCCs4PDoK1eZniXv1Yk0Y7t5z9wXq4Ra/tgxAZ1QuY
   9xhQ1G9X2CdD/XcmSqc1hvEwxTKvydmjZ86G6/Jkycyd4FRqiux/82B50
   vxyWrtOQO9v4WKN2pC7513lKXM9CsxFX9wfFSXFffaXlpdjF4lohNMDbI
   9J9wgcqvtpuhWKFbFe7CeNb6AnoXNiOqX0BU/RN/cqoNVbihUQPGiop1X
   q8v416a/NhhnwelW50Ws/2ZZU1D3nlU4GEa4M1XakhG7j8cV5VGqw3n57
   YiV1Qvy9Nuy9BwkhKx+Gw4P9dQ5y5/yHSu1oUvfUAiLgR6uat2qstRGUL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="281900445"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="281900445"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 01:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="715379744"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga005.jf.intel.com with ESMTP; 18 Mar 2022 01:26:21 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH v2 0/4] Manual improvements
Date:   Fri, 18 Mar 2022 09:26:03 +0100
Message-Id: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Changes in v2:
- Remove periods in commit messages
- Split commits for better clarity

Lukasz Florczak (4):
  mdadm: Respect config file location in man
  mdadm: Update ReadMe
  mdadm: Update config man regarding default files and multi-keyword
    behavior
  mdadm: Update config manual

 .gitignore                      |  1 +
 Makefile                        |  7 ++-
 ReadMe.c                        | 11 +++--
 mdadm.8.in                      | 34 ++++++-------
 mdadm.conf.5 => mdadm.conf.5.in | 84 ++++++++++++++++++++++++++++++---
 5 files changed, 104 insertions(+), 33 deletions(-)
 rename mdadm.conf.5 => mdadm.conf.5.in (90%)

-- 
2.27.0

