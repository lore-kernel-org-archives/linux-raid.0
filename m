Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611F8C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 23 Mar 2022 09:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243060AbiCWJIO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Mar 2022 05:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243106AbiCWJHx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Mar 2022 05:07:53 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C6674857
        for <linux-raid@vger.kernel.org>; Wed, 23 Mar 2022 02:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648026384; x=1679562384;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oizT1hApKL2FIufRyaQLsoW7LskswXJjkC+v7InBU2U=;
  b=Vt1CPyRkrAiT0cr/207degCgkaGzt9N/QnrDt3wKQGIts8J9WjELjmwY
   M3vWq7c9acTyG4XitkY0/KcUyqnJm10RFdbjAXepSdffxcVWwpULt+gzP
   H9Fo1Wsa+Ve9OF5ZmOCVSbe9Lf+/iRmssIYbjoO3sAuFaMF+mJ7YT/3pX
   hhMuWJfVY8Ly+RdB0cnV8GoOCV0OD15LBhU8MzIS5BqKVbpXb/3+7zLe0
   /VgUC+3QIcKqXlNzKvhA5qhdzwSeuvk7703Veb7TiQd0MbuxefqxOmXdM
   rAhfCUy9IjcjXJIAbxS7vl51wjRr/0CFVbQnr3FKgcZQdiWlhG6Z1lGkF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="318770734"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="318770734"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 02:06:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="560809472"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2022 02:06:22 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 0/2] Fix force assemblation
Date:   Wed, 23 Mar 2022 10:09:59 +0100
Message-Id: <20220323091001.27139-1-kinga.tanska@intel.com>
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

