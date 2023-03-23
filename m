Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C44C6FD1D
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 12:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCWMIl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 08:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjCWMIZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 08:08:25 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E857BB459
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 05:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679573293; x=1711109293;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zK9pJ7mlgohRWmSvluEOe8dgunweRrAONNQawB86EV4=;
  b=ZfpDd8JzRTkkFsJ4ysOOCFL0ZidnXsCITM7FWYjnfnRgM1CxU/3Yv2Sf
   s5P4NekaUz13eHewb+OrhfZVercxrx2BsHychw21+yBhxXOSUqSiZy2jY
   RSvxqWeJVUy1LPlPO2/N/8ZKFo1K8u3t7rDq2bdGgddxhe3El3S2nF9QH
   FAI+krqzuNpAGc1jPrr5RLX4YE5xAck87Tdz5lFVtJnBGALFesoeT/mzF
   MY98fkD1EaZmjtulHYEBwBQhbkeQCE/CeizXAUgt91Osj1gKybsCbw1K4
   x3j2P1K3IwtlW1kWQAWpEeX410fBQ7mhNxYgtfalkTTN0hOSmo8n5v8Ct
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="341831511"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="341831511"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 05:08:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="746693697"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="746693697"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.104.85])
  by fmsmga008.fm.intel.com with ESMTP; 23 Mar 2023 05:08:12 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH v2] Create: Fix checking for container in update_metadata
Date:   Thu, 23 Mar 2023 12:50:00 +0100
Message-Id: <20230323115000.25364-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The commit 8a4ce2c05386 ("Create: Factor out add_disks() helpers")
introduced a regression that caused timeouts and udev failing to create
links.

Steps to reproduce the issue were as following:
$ mdadm -CR imsm -e imsm -n4 /dev/nvme[0-3]n1
$ mdadm -CR vol -l5 -n4 /dev/nvme[0-3]n1 --assume-clean

I found the check for container was wrong because negation was missing.

Fixes: 8a4ce2c05386 ("Create: Factor out add_disks() helpers")
Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Create.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Create.c b/Create.c
index bbe9e13d..0911bf92 100644
--- a/Create.c
+++ b/Create.c
@@ -328,7 +328,7 @@ static int update_metadata(int mdfd, struct shape *s, struct supertype *st,
 	 * again returns container info.
 	 */
 	st->ss->getinfo_super(st, &info_new, NULL);
-	if (st->ss->external && is_container(s->level) &&
+	if (st->ss->external && !is_container(s->level) &&
 	    !same_uuid(info_new.uuid, info->uuid, 0)) {
 		map_update(map, fd2devnm(mdfd),
 			   info_new.text_version,
-- 
2.26.2

