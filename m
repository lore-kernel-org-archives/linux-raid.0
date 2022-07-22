Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF70C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 22 Jul 2022 06:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiGVGmS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Jul 2022 02:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiGVGmS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Jul 2022 02:42:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38C9823BA
        for <linux-raid@vger.kernel.org>; Thu, 21 Jul 2022 23:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658472137; x=1690008137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bFSwCxUWmWNOmPGUiaBw8GfGwFDQlJ1DVzag47UhEuU=;
  b=PNfhi6GPRgepHKAYtgZQkB03kRb3yVK4zl6Y6ADNMrTJ3pZ5CzKv8tFd
   S3QINxTsd124+EEs6U1wuOIi4rOlY9a3kuIwOQPkUIqRoZJ6aT0wRzdc3
   DiXpof6AfHxze27lJNi96RTuHxq2dsLZNMaIezCKlFQrgBkcMPK8yQf60
   Ew16yoWgOVjdTyTJTlljnT/NFw4VKWBEWY1Raj+AdTQApfyO9vfyyuAo5
   6wjxJpyGK2OY1uTWAxfKwUfQoNLacVwIFHO0yBXvmJj+L83Sxzf8Z8FoM
   56mXls/3VLUFVZEfp1HNFnVGtNw6YqMq96+f6LOwamrwBfI5Yw/j7EZfh
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="287254964"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="287254964"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 23:42:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="657096207"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.108.83])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jul 2022 23:42:17 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 1/2 RESEND] mdadm: Fix array size mismatch after grow
Date:   Fri, 22 Jul 2022 08:43:47 +0200
Message-Id: <20220722064348.32136-2-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220722064348.32136-1-lukasz.florczak@linux.intel.com>
References: <20220722064348.32136-1-lukasz.florczak@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

imsm_fix_size_mismatch() is invoked to fix the problem, but it couldn't
proceed due to migration check. This patch allows for intended behavior.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 super-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index d5fad102..102689bc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11757,7 +11757,7 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
 		unsigned long long d_size = imsm_dev_size(dev);
 		int u_size;
 
-		if (calc_size == d_size || dev->vol.migr_type == MIGR_GEN_MIGR)
+		if (calc_size == d_size)
 			continue;
 
 		/* There is a difference, confirm that imsm_dev_size is
-- 
2.27.0

