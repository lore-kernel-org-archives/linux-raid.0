Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4258AC38A02
	for <linux-raid@archiver.kernel.org>; Fri, 28 Oct 2022 09:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiJ1JxR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Oct 2022 05:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJ1Jwb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Oct 2022 05:52:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E8F24F3D
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 02:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666950678; x=1698486678;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wN6TGKZSmVqZ6PmZLn3527C47khU2QZluMwPh7stl6E=;
  b=dXbt7h3rwQPrbRAH/pf9o/6hLQ2r4Dr94NGda5P5+DqEnqKgdfc9MkgP
   PgFyNrZDAOk4wMNwPN/6mJnUGJlx39VtC7XE/lej2TSSC6t+5pt0inZvK
   uvPllAmB2gosUBsAOV/moOO3S20gTJavqYWsFMJzYTpK+qhK04dTLWxca
   Aa3nbgzINm16No6+47FW1mvulqFLtjZay7FQrdFzyt1WFcpfnXE8AUs/k
   EF48X5iX3vcH/73WgImQ3i5nVUob3hnbHEt04ljEA/Box7inNYgb5KIwI
   /SDmaDTCemhg3e7vIFc3akY3VU6F9NlvozbbTDh4n+rUtOs33tPVn4CH9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="306065173"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="306065173"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 02:51:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="610691019"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="610691019"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga006.jf.intel.com with ESMTP; 28 Oct 2022 02:51:16 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH v2] super-intel: make freesize not required for chunk size migration
Date:   Fri, 28 Oct 2022 04:51:17 +0200
Message-Id: <20221028025117.27048-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Freesize is needed to be set for migrations where size of RAID could
be changed - expand. It tells how many free space is determined for
members. In chunk size migartion freesize is not needed to be set,
pointer shouldn't be checked if exists. This commit moves check to
condition which contains size calculations, instead of checking it
always at the first step.
Fix return value when superblock is not set.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 super-intel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4d82af3d..37c59da5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7714,11 +7714,11 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 		struct intel_super *super = st->sb;
 
 		/*
-		 * Autolayout mode, st->sb and freesize must be set.
+		 * Autolayout mode, st->sb must be set.
 		 */
-		if (!super || !freesize) {
-			pr_vrb("freesize and superblock must be set for autolayout, aborting\n");
-			return 1;
+		if (!super) {
+			pr_vrb("superblock must be set for autolayout, aborting\n");
+			return 0;
 		}
 
 		if (!validate_geometry_imsm_orom(st->sb, level, layout,
@@ -7726,7 +7726,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 						 verbose))
 			return 0;
 
-		if (super->orom) {
+		if (super->orom && freesize) {
 			imsm_status_t rv;
 			int count = count_volumes(super->hba, super->orom->dpa,
 					      verbose);
-- 
2.26.2

