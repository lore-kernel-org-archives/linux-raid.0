Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A441C43334
	for <linux-raid@archiver.kernel.org>; Tue,  5 Jul 2022 11:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiGELvm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Jul 2022 07:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiGELvi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Jul 2022 07:51:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B092175B8
        for <linux-raid@vger.kernel.org>; Tue,  5 Jul 2022 04:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657021897; x=1688557897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/s5c7P74VoMNNJ5KWQIA2V15n2vy9uKwouU4MFSB7tg=;
  b=UHsVrkj19tKyQD8DqV34ldpwsDt8gxeVcqOgOcnIdf/H6Uko4oOtLblO
   MvC6jDLIKIfHSi+wL0lmPP8Ihy5CJy41UMTW5cxCtzjcGFCpUqvPdv+Af
   N+AFaR3KK7H22OdXT70dsoV2SRvxfZc40z6kelOpAExQMrzzEtIkqoBRC
   sB3zl2+ClJQ9PRpAEAGjlhPPW0Is5xEAqDl20qmI8wmo3gIhR4AdEF08f
   0sWpv56YXXv79GLwGiyYJ7b70VNqvIUNncsd/wMZSycDbsdNzCwJGPrs0
   TbLoqmZ2UKdo3hvM3PspyOeHn2ZIO5r251Gs3BdFgnh3sVDg+haiaII97
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="284065296"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="284065296"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 04:51:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="619800198"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 05 Jul 2022 04:51:36 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v3 1/2] Assemble: check if device is container before scheduling force-clean update
Date:   Tue,  5 Jul 2022 13:58:11 +0200
Message-Id: <20220705115812.6946-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220705115812.6946-1-kinga.tanska@intel.com>
References: <20220705115812.6946-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When assemble is used with --force flag and array is not clean then
"force-clean" update is scheduled. Containers are considered as not
clean because this field is not set for them. To exclude them from
meaningless update (it is ignored quietly) check if the device
is a container first.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Assemble.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 704b8293..f31372db 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1813,10 +1813,9 @@ try_again:
 		}
 #endif
 	}
-	if (c->force && !clean &&
+	if (c->force && !clean && content->array.level != LEVEL_CONTAINER &&
 	    !enough(content->array.level, content->array.raid_disks,
-		    content->array.layout, clean,
-		    avail)) {
+		    content->array.layout, clean, avail)) {
 		change += st->ss->update_super(st, content, "force-array",
 					       devices[chosen_drive].devname, c->verbose,
 					       0, NULL);
-- 
2.26.2

