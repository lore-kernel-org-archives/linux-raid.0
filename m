Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C93C10F1B
	for <linux-raid@archiver.kernel.org>; Tue, 27 Dec 2022 12:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiL0MtA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Dec 2022 07:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiL0Ms6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Dec 2022 07:48:58 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28501F12
        for <linux-raid@vger.kernel.org>; Tue, 27 Dec 2022 04:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672145338; x=1703681338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UsKT/OHMZPqJwYAz/zuqaIMFUZy+jMgSbUj/4Cwmuq0=;
  b=b3LKLXu4i8jDl7zDEei6ZbLlcrDVCOTYp3AT7H4LXp8fdTxGegv+NX2c
   qUh+CNa5U4RNmMbshlpl+0hCmcx4llfxbi9+Hq510eM/JHiOEAOlCiK/g
   itBWTcX2SDDwXFP1bXU91eHBU1M2boox0e7AJVIdj4WTVXfNIkJ/L55zB
   nhm3TLPlAX/tzLsIgWJ8+41mTNppJYi63jhUMibpNFfSIJ5J35irr0t58
   eZakN30aRSN2c/qfY4lw3PVXh7ItJDkg1Us4at4AqSJv8MdfhpfqY9n5q
   XAw+4LQwWDrxSzKRk9+Gl7htdJ29/ZxwGTNFlgseOZdtt7aeeYe/Y2VrJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="385117688"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="385117688"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 04:48:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="646415738"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="646415738"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga007.jf.intel.com with ESMTP; 27 Dec 2022 04:48:56 -0800
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, xni@redhat.com
Subject: [PATCH v3 1/3] Manage: do not check array state when drive is removed
Date:   Tue, 27 Dec 2022 06:50:42 +0100
Message-Id: <20221227055044.18168-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221227055044.18168-1-kinga.tanska@intel.com>
References: <20221227055044.18168-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Array state doesn't need to be checked when drive is
removed, but until now clean state was required. Result
of the is_remove_safe() function will be independent
from array state.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Manage.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Manage.c b/Manage.c
index b1d0e630..157a2b98 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1322,8 +1322,7 @@ bool is_remove_safe(mdu_array_info_t *array, const int fd, char *devname, const
 	sysfs_free(mdi);
 
 	bool is_enough = enough(array->level, array->raid_disks,
-				array->layout, (array->state & 1),
-				avail);
+				array->layout, 1, avail);
 
 	free(avail);
 	return is_enough;
-- 
2.26.2

