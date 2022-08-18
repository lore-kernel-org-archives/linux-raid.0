Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204B4C00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245557AbiHROUv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244837AbiHROUv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:20:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FBBAED98
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660832450; x=1692368450;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oizT1hApKL2FIufRyaQLsoW7LskswXJjkC+v7InBU2U=;
  b=HUgEqndjy2c3cGHVGf05DUYYl6uTBRy/8xTlT2kEwBLsKHjzTdfAdaGm
   ZW32sqSA10JCPk1JaEOSDsD93SivaoRzk2uuJZfV1C3TVRr1VlsoMUVKi
   NzP+BYCLyiAhZiiG7st4KQWTlGxkkIRYPVO8YY0syRVuqaTnSEXGBKPRH
   qxG2/zWsZGYXdPfrERD86q1q/aqVnFBrfMk1l9jcP3y+ceA+qhxBXye4p
   fITrwyDVY2bodZSedD96WmfzA+hmA/RBA8odUbvBQLaSSYXVJseWL8kHT
   du+nj8P73m6NeubrQ7F2MBRW71IxMIQpd1I5Vxf8RJitsbBskRyqpITZg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="356757962"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="356757962"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:20:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="636840640"
Received: from unknown (HELO unbrick.amr.corp.intel.com) ([10.102.92.203])
  by orsmga008.jf.intel.com with ESMTP; 18 Aug 2022 07:20:25 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v3 0/2] Fix force addemblation
Date:   Thu, 18 Aug 2022 09:20:39 +0200
Message-Id: <20220818072041.13586-1-kinga.tanska@intel.com>
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

