Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FB7C43381
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD7E923359
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732326AbhAON0e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:26:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:10822 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732159AbhAON0e (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 08:26:34 -0500
IronPort-SDR: gCvbiUOUNsILBGPyyzPXhgTf6OnVtDMuDg/1BXWpAv7PZzyt1ummT2dhLlW8+3EyNHAmg7cTBK
 32UWrbyw1ucQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="166216115"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="166216115"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:20 -0800
IronPort-SDR: JKJs3KHkTRcfwBkGbcCreLVz7fsRVRSDmmyQVEJXnyZ+HIzyWc5hH7ZC6ZCG27lHksshL5IUsJ
 oMn/ymeSDJBA==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="425312389"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:19 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/8] Write-intent bitmap support for IMSM metadata 
Date:   Fri, 15 Jan 2021 00:46:53 -0500
Message-Id: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This patchset is aimed to add write-intent bitmap support for IMSM
metadata.

Additional function in the superswitch (set_bitmap) is proposed as
a place where the internal bitmaps configuration for non-native
metadata can be performed (through sysfs).

Adding the bitmap to existing volumes is implemented similarly like
for the PPL functionality (through --update-subarray).

The patchset was tested on HW and qemu.

Jakub Radtke (8):
  Modify mdstat parsing for volumes with the bitmap
  Enable bitmap support for external metadata
  imsm: Write-intent bitmap support
  imsm: Adding a spare to an existing array with bitmap
  Add "bitmap" to allowed command-line values
  imsm: Update-subarray for write-intent bitmap
  Create: Block automatic enabling bitmap for external metadata
  Grow: Block reshape when external metadata and write-intent bitmap

 Assemble.c    |   6 +
 Create.c      |  11 +
 Grow.c        |  24 +-
 mdadm.8.in    |  13 +-
 mdadm.c       |   4 +-
 mdadm.h       |   3 +
 mdstat.c      |   6 +
 super-intel.c | 679 +++++++++++++++++++++++++++++++++++++++++++++++++-
 8 files changed, 725 insertions(+), 21 deletions(-)

-- 
2.26.2

