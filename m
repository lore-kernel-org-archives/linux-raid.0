Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9F6C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 13 Sep 2021 16:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D074060E8B
	for <linux-raid@archiver.kernel.org>; Mon, 13 Sep 2021 16:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbhIMQjb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Sep 2021 12:39:31 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55990 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbhIMQja (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Sep 2021 12:39:30 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DE87020007;
        Mon, 13 Sep 2021 16:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631551093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=sADq2YKr9jfwk60jmtDQWCF0BvZ5gi9wFiZf1Lzc8Rk=;
        b=jW8FJT56suitDpb5iPieL89czU/zZON16K6rMwb+KhVmnNl2MeW3UivrZMhQowYPelB2pJ
        X8xg4rQ9/tcIzzwSrB6O7h4Fwo3kBMtDNNJH5rlknJ02cZOZ7VcG4YMcsb65VWooxlQrL7
        nnzhzbIGq/eEF/4TXmhtlAdq140xvXE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631551093;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=sADq2YKr9jfwk60jmtDQWCF0BvZ5gi9wFiZf1Lzc8Rk=;
        b=s92XzRaS0fG41KQdEwFTxkMD6AAkWySnDLncRmTsaBB4P0lfiu9JZJ4cKr7/6WvXpKGeDT
        aXKzRPunealP20AA==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 2AFCBA3B88;
        Mon, 13 Sep 2021 16:38:07 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev
Cc:     antlists@youngman.org.uk, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>,
        Vishal L Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 0/7] badblocks improvement for multiple bad block ranges 
Date:   Tue, 14 Sep 2021 00:36:36 +0800
Message-Id: <20210913163643.10233-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is the second effort to improve badblocks code APIs to handle
multiple ranges in bad block table.

There are 2 changes from previous version,
- Fixes 2 bugs in front_overwrite() which are detected by the user
  space testing code.
- Provide the user space testing code in last patch.

There is NO in-memory or on-disk format change in the whole series, all
existing API and data structures are consistent. This series just only
improve the code algorithm to handle more corner cases, the interfaces
are same and consistency to all existing callers (md raid and nvdimm
drivers).

The original motivation of the change is from the requirement from our
customer, that current badblocks routines don't handle multiple ranges.
For example if the bad block setting range covers multiple ranges from
bad block table, only the first two bad block ranges merged and rested
ranges are intact. The expected behavior should be all the covered
ranges to be handled.

All the patches are tested by modified user space code and the code
logic works as expected. The modified user space testing code is
provided in last patch. The testing code detects 2 defects in helper
front_overwrite() and fixed in this version.

The whole change is divided into 6 patches to make the code review more
clear and easier. If people prefer, I'd like to post a single large
patch finally after the code review accomplished.

This version is seriously tested, and so far no more defect observed.


Coly Li

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Richard Fan <richard.fan@suse.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
---
Changelog:
v3: add tester Richard Fan <richard.fan@suse.com>
v2: the improved version, and with testing code.
v1: the first completed version.


Coly Li (6):
  badblocks: add more helper structure and routines in badblocks.h
  badblocks: add helper routines for badblock ranges handling
  badblocks: improvement badblocks_set() for multiple ranges handling
  badblocks: improve badblocks_clear() for multiple ranges handling
  badblocks: improve badblocks_check() for multiple ranges handling
  badblocks: switch to the improved badblock handling code
Coly Li (1):
  test: user space code to test badblocks APIs

 block/badblocks.c         | 1599 ++++++++++++++++++++++++++++++-------
 include/linux/badblocks.h |   32 +
 2 files changed, 1340 insertions(+), 291 deletions(-)

-- 
2.31.1

