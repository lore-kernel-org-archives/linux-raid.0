Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF08C433E0
	for <linux-raid@archiver.kernel.org>; Tue,  5 Jan 2021 15:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B7922B4B
	for <linux-raid@archiver.kernel.org>; Tue,  5 Jan 2021 15:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbhAEPIf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Jan 2021 10:08:35 -0500
Received: from mga04.intel.com ([192.55.52.120]:52229 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbhAEPIf (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 5 Jan 2021 10:08:35 -0500
IronPort-SDR: yuJa8d85Uiy1/Xs25Xh61lWp1OWUDrmkc0HHhjmVaOw/+Rcaa8b2Z8p1U9SJm50mkd+6Nsv3dC
 m1s4Unk1Re6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="174542154"
X-IronPort-AV: E=Sophos;i="5.78,477,1599548400"; 
   d="scan'208";a="174542154"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 07:06:49 -0800
IronPort-SDR: +BVnA2g6FMJ0usc1u4xTfNpXyQ0kPcfb65yDoM+m908rOWvVH+nidnexwbAEWcihIvO5h0whbp
 7O3E4RLOZXOw==
X-IronPort-AV: E=Sophos;i="5.78,477,1599548400"; 
   d="scan'208";a="421803758"
Received: from jradtke-mobl1.ger.corp.intel.com ([10.249.137.61])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 07:06:48 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] md: change bitmap offset verification in write_sb_page
Date:   Tue,  5 Jan 2021 16:06:35 +0100
Message-Id: <20210105150635.2551-1-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jakub Radtke <jakub.radtke@intel.com>

Removes the code that is correct only for the native metadata.
Write-intent bitmap support for the other metadata formats is blocked.

rdev->sb_start is used in the calculations.
The sb_start is only set and used for native metadata format, and
the bitmap offset check will always fail if it is not set.

In the case of external metadata, the bitmap can be placed in various
places e.g. like the PPL between two volumes (the boundary checks are
performed on the sysfs level and in the mdadm).

Signed-off-by: Jakub Radtke <jakub.radtke@linux.intel.com>
---
 drivers/md/md-bitmap.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 200c5d0f08bf..a78b15df4d82 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -236,14 +236,6 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 		 */
 		if (mddev->external) {
 			/* Bitmap could be anywhere. */
-			if (rdev->sb_start + offset + (page->index
-						       * (PAGE_SIZE/512))
-			    > rdev->data_offset
-			    &&
-			    rdev->sb_start + offset
-			    < (rdev->data_offset + mddev->dev_sectors
-			     + (PAGE_SIZE/512)))
-				goto bad_alignment;
 		} else if (offset < 0) {
 			/* DATA  BITMAP METADATA  */
 			if (offset
-- 
2.17.1

