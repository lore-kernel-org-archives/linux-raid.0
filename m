Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EACC4332E
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0969F64FED
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhCEMCa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Mar 2021 07:02:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:35709 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhCEMCG (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 5 Mar 2021 07:02:06 -0500
IronPort-SDR: SmXj4l6r6nUWTOnLXHPNp+niVfWmw0J4t4b709PTPVYTj6P96L3Bv0f40wpYMYqTJ3ZTQ9sl8q
 CCKUpqSRfQcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="185230295"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="185230295"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:02:06 -0800
IronPort-SDR: aAfM6lU1/3TV2fcABcxoCg4ob2nRETwpzs92nPzlLXv+yDXhBMLxopGHXoXxqyiJTC+i1xLl09
 +aUAvkIAtNVg==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="401656636"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:02:05 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 7/8] Create: Block automatic enabling bitmap for external metadata
Date:   Thu, 24 Sep 2020 20:03:03 -0400
Message-Id: <20200925000304.169728-8-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
References: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
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

