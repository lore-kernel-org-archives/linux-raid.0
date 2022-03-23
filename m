Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740F1C43217
	for <linux-raid@archiver.kernel.org>; Wed, 23 Mar 2022 09:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243090AbiCWJIS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Mar 2022 05:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243115AbiCWJHz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Mar 2022 05:07:55 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F384174857
        for <linux-raid@vger.kernel.org>; Wed, 23 Mar 2022 02:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648026385; x=1679562385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/s5c7P74VoMNNJ5KWQIA2V15n2vy9uKwouU4MFSB7tg=;
  b=JgO2SmbUXBCz6GabMesZgU8DPV7Ksn6HxwS/asM03MB+B44WxxpLulmh
   mPHOZbsi+uQUoPLudizstPkb7X/Vq7tkqOicZvT+xdGt3024GYvUZcou+
   hnbdblX32QwhFd7W/xA9LN6lAgB6whuiIQXdSGn7djOJwrjzADPzXwx0s
   usLTmeao9pluqWta/oQgX4rxc7FvftKin1nE0Jm6Yvfo4Rf3uYSsN086S
   uHALC6w33IXtrX2BUqV2OYFTSii2F6BAfvmFm8fkELrNVinF5TdAz6NhA
   C+LNJLvLiqqDW+UK4DRsq/+FxCq9vLkBwd45GdBihHg1nMAUfzOnpxjWx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="318770745"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="318770745"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 02:06:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="560809483"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2022 02:06:24 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 1/2] Assemble: check if device is container before scheduling force-clean update
Date:   Wed, 23 Mar 2022 10:10:00 +0100
Message-Id: <20220323091001.27139-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220323091001.27139-1-kinga.tanska@intel.com>
References: <20220323091001.27139-1-kinga.tanska@intel.com>
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

