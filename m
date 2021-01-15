Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB03C433E0
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 687BF22583
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731831AbhAON3R (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:29:17 -0500
Received: from mga18.intel.com ([134.134.136.126]:10830 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731652AbhAON3P (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 08:29:15 -0500
IronPort-SDR: PugGTeGa+sV52wgyW0KICfIINYYejS8jEPFMVItAr5Y0ElB+pEMJUT3Tw9mHC6nwS8av/jFPk1
 tYFb7vodGyMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="166216207"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="166216207"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:36 -0800
IronPort-SDR: eMH/RyciNq6VyChmF2vCbekZaM06k0//AMaQ3tUqsKwG3sX5pfCYdR1vYLLLYdD29XrYNDMmhs
 cu+OAL7GsMNQ==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="425312447"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:35 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 7/8] Create: Block automatic enabling bitmap for external metadata
Date:   Fri, 15 Jan 2021 00:47:00 -0500
Message-Id: <20210115054701.92064-8-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
References: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jakub Radtke <jakub.radtke@intel.com>

For external metadata, bitmap should be added only when
explicitly set by the administrator.
They could be additional requirements to consider before
enabling the external metadata's functionality
(e.g., kernel support).

Change-Id: I3973464b4c73f77b9c2ebc9cbb5f501a14d5eb02
Signed-off-by: Jakub Radtke <jakub.radtke@intel.com>
---
 Create.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Create.c b/Create.c
index 751f18c1..7df3b7e2 100644
--- a/Create.c
+++ b/Create.c
@@ -540,6 +540,7 @@ int Create(struct supertype *st, char *mddev,
 	}
 
 	if (!s->bitmap_file &&
+	    !st->ss->external &&
 	    s->level >= 1 &&
 	    st->ss->add_internal_bitmap &&
 	    s->journaldisks == 0 &&
-- 
2.26.2

