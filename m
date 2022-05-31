Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82B3C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 10:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245683AbiEaK1r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 06:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245671AbiEaK1p (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 06:27:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247B8996AF
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 03:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653992865; x=1685528865;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tIF538NzYipt7ipeMUxZjjFN4vmoIIy/j8YGq/LCu6c=;
  b=deKGu47J0GiNiIgKkIODgPIs8dFy+CVhxbm7l+YIQONdYnWFDfw1mT9r
   pO1lSQvlSFRe3jBZTy357e/bPNpMWuOxK7vIw73JE4IfASVjkHmvkOVyV
   2XdyNlEoZyqm592LxMskDgyMw4CeHGNUuTxFv8omGozMXXhfvzdey+ggK
   ZBYez8mIPwMqcw21SXC9o8XpAAhGZ/CMtCksuzUdyk9KfIMkAU3vip07i
   epkGNMs4u//ztuNcsNTRHwsHbnSquKtJ2d9+AVpo8GhpGGo3pp4jJKc1P
   So79aIu2w4A+ZiOaKq9gLMXhjrsu9PbbV41Y+8gSmeepTZ8+DsSxUnKKw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="300562480"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="300562480"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 03:27:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="576342786"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 03:27:43 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/3 v2] IMSM autolayout improvements
Date:   Tue, 31 May 2022 12:27:24 +0200
Message-Id: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Following patchset modifies some parts of IMSM creation to ensure that
member's order is always same. It is ISM metadata requirement.

Additionally, as discussed with Jes I've started to implement more modern error
handling, by adding special enum for IMSM. Will be great to hear any comments
and opinion.

V2 improvements:
- typedef added in first patch
- changed order in enum

Mariusz Tkaczyk (3):
  imsm: introduce get_disk_slot_in_dev()
  imsm: use same slot across container
  imsm: block changing slots during creation

 super-intel.c        | 249 ++++++++++++++++++++++++++++---------------
 tests/09imsm-overlap |  28 -----
 2 files changed, 166 insertions(+), 111 deletions(-)
 delete mode 100644 tests/09imsm-overlap

-- 
2.26.2

