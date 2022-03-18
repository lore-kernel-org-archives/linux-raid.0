Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D50C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 08:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiCRI2b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Mar 2022 04:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiCRI1t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Mar 2022 04:27:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D98915DAA9
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 01:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647591991; x=1679127991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vK9ml61gOs7zqI0UCk1MkLm2jep1Pd3QMXJWA+zjv3o=;
  b=YviYSsMV6BDBeXM4PBtiydGNqLd5OhX+xTgpzWAlXkuJsCmxnqchRTDc
   M4hLygPbjRZ8kkfVQKLG3TEEU+cL0AhkGLDO6MO9/Xa/YhHMZzvSJ7dpJ
   BrSsLa1vTwAYZLw7SHNqLegnprqcccw7bAGCzBpWEiT5yUnsWpICxWSrH
   5x9NZ5XGTdW11sZ6x2/XCLtz1MGwNQ7MKiUhFOy5O1fogmXYqseOq8RPY
   v9HZa//bG84lqE8aL2Ak+CNtuP+yoPsFd2IMhOC3HjjpMAJXpUJkJ2Omn
   Gg2Vhs9Nd87lFx3Co1cnbeV9SYCCrCO9j4PIKoRvegsfiSUHAqI74t4YI
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="281900472"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="281900472"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 01:26:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="715379778"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga005.jf.intel.com with ESMTP; 18 Mar 2022 01:26:30 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH 4/4] mdadm: Update config manual
Date:   Fri, 18 Mar 2022 09:26:07 +0100
Message-Id: <20220318082607.675665-5-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add missing HOMECLUSTER keyword description.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 mdadm.conf.5.in | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
index dd331a6a..cd4e6a9d 100644
--- a/mdadm.conf.5.in
+++ b/mdadm.conf.5.in
@@ -439,6 +439,23 @@ from any possible local name. e.g.
 .B /dev/md/1_1
 or
 .BR /dev/md/home_0 .
+
+.TP
+.B HOMECLUSTER
+The
+.B homcluster
+line gives a default value for the
+.B \-\-homecluster=
+option to mdadm.  It specifies  the  cluster name for the md device.
+The md device can be assembled only on the cluster which matches
+the name specified. If
+.B homcluster
+is not provided, mdadm tries to detect the cluster name automatically.
+
+There should only be one
+.B homecluster
+line.  Any subsequent lines will be silently ignored.
+
 .TP
 .B AUTO
 A list of names of metadata format can be given, each preceded by a
-- 
2.27.0

