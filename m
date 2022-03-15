Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A7BC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 15 Mar 2022 08:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346268AbiCOI51 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Mar 2022 04:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241081AbiCOI50 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Mar 2022 04:57:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DD74D9CF
        for <linux-raid@vger.kernel.org>; Tue, 15 Mar 2022 01:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647334575; x=1678870575;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8QwGgSn01IoGzn3gA3oj0M0BAhpLMhXwBpYAtnTKU7c=;
  b=eacjvpL1DU9U0jiibGcKgOKwoRZGHXr3UoHB97sXHofpNfK7yDT5ENRd
   h30aHC0uAe/nWwSHNb6Oo0SUm0InOS1V8jTXfn6IXHZQbW8M5vTsNY4fn
   +cnHkPGIhhByR6EXfHBYDP0knxX6ULYBFHXSzkNrv2IOFR/Sc2D+CmyPY
   TnkKIgQfwXvz78r2ysu8RRHh4f5OGq1Ht2ZNrNa0avrey3vLSctALM4J1
   SRank3Ud4nizHP0kPD7w6tjUSQci0dLOtA/T2wqb0fv4J0vHK7wuZyYF7
   LlMXjD2+TaLMnXGPTRRuVvGDa84cXuZ7NCFVOzdlTHgs1Fdp1Fcwxk/jT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="243701189"
X-IronPort-AV: E=Sophos;i="5.90,182,1643702400"; 
   d="scan'208";a="243701189"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 01:56:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,182,1643702400"; 
   d="scan'208";a="714079194"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga005.jf.intel.com with ESMTP; 15 Mar 2022 01:56:04 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 0/2] Manual improvements
Date:   Tue, 15 Mar 2022 09:55:47 +0100
Message-Id: <20220315085549.59693-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Patch 1:
- Automatically generate mdadm.conf.5
- Respect Debian default config locations

Patch 2:
- Explain behavior for multiple config files setup
- Add missing Homecluster keyword description

Lukasz Florczak (2):
  mdadm: Respect config file location in man.
  mdadm: Update config man regarding default files and multi-keyword
    behavior.

 .gitignore                      |  1 +
 Makefile                        |  7 ++-
 ReadMe.c                        | 11 ++--
 mdadm.8.in                      | 34 +++++-------
 mdadm.conf.5 => mdadm.conf.5.in | 92 ++++++++++++++++++++++++++++++---
 5 files changed, 112 insertions(+), 33 deletions(-)
 rename mdadm.conf.5 => mdadm.conf.5.in (89%)

-- 
2.27.0

