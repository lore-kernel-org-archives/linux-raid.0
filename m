Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D70C4167B
	for <linux-raid@archiver.kernel.org>; Mon,  2 Jan 2023 08:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjABIh1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjABIhE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Jan 2023 03:37:04 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C5BC19
        for <linux-raid@vger.kernel.org>; Mon,  2 Jan 2023 00:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672648616; x=1704184616;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DdfYszLzuczZup3tld5qVabTWEliSa1WtfCwuHQ7v3s=;
  b=cTvP/OPpmVHn5fCwpl/yUHVR4FInUlYRmwkZUm4jOxXh9kdmqQOD9BO1
   qoM3xBl50mDIQmZ+7ponAyU5xreAOVgxsoCOvYhj5qbw+ZhS3aBw/T+B1
   KZAilAnXTshoGKP9Me0yJfTYLZtxCwQA0pjhr3tdZaEq5f6GokjLt50S4
   5XWEQgkwxKzVN/WzI0ZTpFYWpvN6bm0EfAgVxwIAGxPHWKI9Lu0w+M/at
   Yk19ACzQe2Yhb5Ti+Zg0t033dQMT7gBDRJPQhlIs+G1qtn86n0DrEVSD/
   sIHEpiv6qZH64frI/3rpj3O+9IFT3Qg7alJuUbXItxoRs7RlLyUosUr0r
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="322685296"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="322685296"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 00:36:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="647864597"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="647864597"
Received: from unknown (HELO DESKTOP-QODMV9C.igk.intel.com.com) ([10.102.109.29])
  by orsmga007.jf.intel.com with ESMTP; 02 Jan 2023 00:36:55 -0800
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2 00/10] Block update-subarray and refactor context update v2
Date:   Mon,  2 Jan 2023 09:35:14 +0100
Message-Id: <20230102083524.28893-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is the v2 of the patchset I submitted long time ago.
I applied the changes that were requested, but since long time has
passed I'm submitting the whole patchset once again.

Mateusz Kusiak (10):
  mdadm: Add option validation for --update-subarray
  Fix --update-subarray on active volume
  Add code specific update options to enum.
  super-ddf: Remove update_super_ddf.
  super0: refactor the code for enum
  super1: refactor the code for enum
  super-intel: refactor the code for enum
  Change update to enum in update_super and update_subarray
  Manage&Incremental: code refactor, string to enum
  Change char* to enum in context->update & refactor code

 Assemble.c    |  46 ++++++++-------
 Examine.c     |   2 +-
 Grow.c        |  17 +++---
 Incremental.c |   8 +--
 Manage.c      |  42 ++++++++------
 ReadMe.c      |  31 ++++++++++
 maps.c        |  31 ++++++++++
 mdadm.c       | 129 ++++++++++++++----------------------------
 mdadm.h       |  65 ++++++++++++++++++---
 super-ddf.c   |  70 -----------------------
 super-intel.c |  48 +++++++++-------
 super0.c      | 103 ++++++++++++++++++++-------------
 super1.c      | 153 ++++++++++++++++++++++++++++++--------------------
 13 files changed, 406 insertions(+), 339 deletions(-)

-- 
2.26.2

