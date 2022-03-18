Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BE1C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 08:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiCRI1q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Mar 2022 04:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiCRI1p (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Mar 2022 04:27:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CC114FBBB
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 01:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647591987; x=1679127987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hw+RqgT/VInockD0wqSVgnhkkoTZfjipS480gQpRs/0=;
  b=hbXgO/AOkbnm6f0bfH/O2LjJPn23m8FLrKfpl7RA+8tE8jGXYCZR7bbt
   568BZ56ObP42az5yt5VtNTnxxmaJWprE9UR+JonJi19hpjdmv3Y1WzY/P
   tyPWJRzF1PARwtZ6EI/DJgBsH1MU2Jc/C5B/TDh5IGkbECX3ZBp2qx1b2
   qdHuFkQh5BOmrHqNSsZjuCUacjmFUh7wiVK3QKxW4os5dN5J74NC7+HdQ
   SHL2pl3Mu+cu/cvTqX2ITHez/9CZTjh5eAZ7LHtK3VukThIzCvcJwKeEw
   7rL2+fDQDRtNvDRjMcy7bWmQNl1qnTp87xCsgHucEecVJLFDlYdxpe+zI
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="281900460"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="281900460"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 01:26:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="715379763"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga005.jf.intel.com with ESMTP; 18 Mar 2022 01:26:26 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH 2/4] mdadm: Update ReadMe
Date:   Fri, 18 Mar 2022 09:26:05 +0100
Message-Id: <20220318082607.675665-3-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Instead of hardcoded config file path give reference to config manual.

Add missing monitordelay and homecluster parameters.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 ReadMe.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index 81399765..8f873c48 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -613,7 +613,6 @@ char Help_incr[] =
 ;
 
 char Help_config[] =
-"The /etc/mdadm.conf config file:\n\n"
 " The config file contains, apart from blank lines and comment lines that\n"
 " start with a hash(#), array lines, device lines, and various\n"
 " configuration lines.\n"
@@ -636,10 +635,12 @@ char Help_config[] =
 " than a device must match all of them to be considered.\n"
 "\n"
 " Other configuration lines include:\n"
-"  mailaddr, mailfrom, program     used for --monitor mode\n"
-"  create, auto                    used when creating device names in /dev\n"
-"  homehost, policy, part-policy   used to guide policy in various\n"
-"                                  situations\n"
+"  mailaddr, mailfrom, program, monitordelay    used for --monitor mode\n"
+"  create, auto                                 used when creating device names in /dev\n"
+"  homehost, homecluster, policy, part-policy   used to guide policy in various\n"
+"                                               situations\n"
+"\n"
+"For more details see mdadm.conf(5).\n"
 "\n"
 ;
 
-- 
2.27.0

