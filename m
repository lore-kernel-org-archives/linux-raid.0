Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B4DC6FD1F
	for <linux-raid@archiver.kernel.org>; Wed, 22 Mar 2023 15:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjCVPJ6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Mar 2023 11:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCVPJy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Mar 2023 11:09:54 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3D217CF0
        for <linux-raid@vger.kernel.org>; Wed, 22 Mar 2023 08:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679497793; x=1711033793;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N89XpUPPXfY15Bj2B4JCFRBdDASrhdb2A5wg+Yimy+k=;
  b=aoe3eeg4T7DM/VUR6hugCCHTld4KLONuwQpX5sxv9S59oUStpf4XUA9o
   jATcm/Tacx9hq9i/wZAeFgSVQFZQROcTDU2LuTy3RWyGyu3d3DKiRS5s1
   p45OYHbx9MuJKs9Zq4Xl9Hj1x7spg2EfzpElMa5MqGqxV33/kUchm6JMM
   bghzEKWSacVxD6DSE+xLyyYm6guEjv9E4xysCqXV7moVGfNQBg27nNjwg
   0laKJ1cjNZUrH9uWfzy2oj5m+XAYHvN8ua8r69xehvHwzp6aDh57W/dcc
   QSOgxQ+IBFCTnW2E6n7zUjLnKI9up+y2lacxck4Un9C+s7GtF6JiG+FEY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="404122703"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="404122703"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 08:05:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="712254436"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="712254436"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.104.85])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2023 08:05:51 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Create: Fix checking for container in update_metadata
Date:   Wed, 22 Mar 2023 15:47:39 +0100
Message-Id: <20230322144739.30712-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The commit https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=8a4ce2c053866ac97feb436c4c85a54446ee0016
introduced a regression that caused timeouts and udev failing to create
links.

Steps to reproduce the issue were as following:
$ mdadm -CR imsm -e imsm -n4 /dev/nvme[0-3]n1
$ mdadm -CR vol -l5 -n4 /dev/nvme[0-3]n1 --assume-clean

I found the check for container was wrong because negation was missing.

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

