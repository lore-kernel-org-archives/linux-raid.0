Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C0BC433ED
	for <linux-raid@archiver.kernel.org>; Wed,  5 May 2021 11:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 582CF613C7
	for <linux-raid@archiver.kernel.org>; Wed,  5 May 2021 11:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhEELCS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 May 2021 07:02:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:4612 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEELCS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 5 May 2021 07:02:18 -0400
IronPort-SDR: x2G6Qca4W0rd+6hiOS+ZRHgXImVknfSo6dhnaLzk7h/FFEeeEZfqo6TTeCtMXUwac8Tyw/qAiv
 iUlGGNjjJS/A==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="195058292"
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="195058292"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 04:01:22 -0700
IronPort-SDR: Sf7ou6mVS+4h6o1T0P2D58ZgjS1uw3e0bA/e80kcacnzQNoGGJc273RenEmJdW+1NwdNL2QSAv
 IgIODcdgPY2w==
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="433760843"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 04:01:19 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] Prevent user from using --stop with ambiguous args
Date:   Wed,  5 May 2021 13:01:02 +0200
Message-Id: <20210505110102.16947-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Norbert Szulc <norbert.szulc@intel.com>

When both --scan and device name is passed to --stop action,
then is executed only for given device. Scan is ignored.

Block the operation when both --scan and device name are passed.

Signed-off-by: Norbert Szulc <norbert.szulc@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 mdadm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mdadm.c b/mdadm.c
index 493d70e4..9f5f7934 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -2039,6 +2039,11 @@ static int misc_list(struct mddev_dev *devlist,
 				rv |= Manage_run(dv->devname, mdfd, c);
 				break;
 			case 'S':
+				if (c->scan) {
+					pr_err("--stop not meaningful with both a --scan assembly and a device name.\n");
+					rv |= 1;
+					break;
+				}
 				rv |= Manage_stop(dv->devname, mdfd, c->verbose, 0);
 				break;
 			case 'o':
-- 
2.26.2

