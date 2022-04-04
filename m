Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3ECC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 13:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358530AbiDDN7L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 09:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242856AbiDDN7K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 09:59:10 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6583E5F5
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 06:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649080634; x=1680616634;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oizT1hApKL2FIufRyaQLsoW7LskswXJjkC+v7InBU2U=;
  b=SrsZS+2NAQX6hNgSsQDbAWyKD5/1x3PloSxJe546dLYom79uSgnkIUWF
   5tINtVCgNIusDkWLtHKSg2j84wxjIKUi2hKOUksu9IngzFqyk/wkZXl0s
   XzBmXGTpalFdxy+AGL3ngwQypGDRnp/6JT2zDnAYWSBJ2sWXjIjSB9sRQ
   1zh5JERbjW1MtSMnV1cClwPcCSq6A8oMnCgwcb4ttT+QGfTotOxHh+ncQ
   Rm/nOTn0Z5M4Q3sDWmVxueDjSj9Ew1MNeECig5Yx05Kpl86KHCs9NSpgv
   cs+ZPk0+JkxsvADM2RocIdm1t7ctZpsPskhzQOsOIV8s7viaSD3BRqcXO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="321213569"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="321213569"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 06:57:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="587577478"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga001.jf.intel.com with ESMTP; 04 Apr 2022 06:57:12 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2 0/2] Fix force assemblation
Date:   Mon,  4 Apr 2022 16:01:13 +0200
Message-Id: <20220404140115.16973-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Series of patches contains fix to prevent update operation
for container, when force assemblation is triggered. To unify all
uses of checking array level, inline function was introduced and
propagated.

Kinga Tanska (2):
  Assemble: check if device is container before scheduling force-clean
    update
  mdadm: replace container level checking with inline

 Assemble.c    | 10 ++++------
 Create.c      |  6 +++---
 Grow.c        |  6 +++---
 Incremental.c |  4 ++--
 mdadm.h       | 14 ++++++++++++++
 super-ddf.c   |  6 +++---
 super-intel.c |  4 ++--
 super0.c      |  2 +-
 super1.c      |  2 +-
 sysfs.c       |  2 +-
 10 files changed, 34 insertions(+), 22 deletions(-)

-- 
2.26.2

