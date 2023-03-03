Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37684C7EE2D
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 16:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjCCQVq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCCQVp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 11:21:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDA7EF8F
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 08:21:40 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2CDE822CE0;
        Fri,  3 Mar 2023 16:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677860499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=MaC8vukfPtFma9hLti/ldnwZtMVnCXfpspOfTd0mCCo=;
        b=QWK7RfBzpou/aztKuQU20x27WDYUJHq/5jF1bvCtBdR/XzOOuJGwIAGXbeAISPyd5kD7cr
        /JVqMRtuz2Z7hQITz6YlytjOFODDzHLTZfIuwiiB30/6foWg+LbsV9xcvG3+97ktCY6edj
        250aK4fvy4lLfcyt0xVLKc2JCUXyObI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677860499;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=MaC8vukfPtFma9hLti/ldnwZtMVnCXfpspOfTd0mCCo=;
        b=z/MLtnHzdF7r5nNCH6jPRp560+B02trh2gCPlHjLMeC9pKfD9zL9GBR/koJDDoBwFBOq16
        r3XjM7J/v8tahwDQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 4D6372C141;
        Fri,  3 Mar 2023 16:21:37 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        pmenzel@molgen.mpg.de, Coly Li <colyli@suse.de>
Subject: [PATCH v2 0/6] rebased patch set from Wu Guanghao 
Date:   Sat,  4 Mar 2023 00:21:29 +0800
Message-Id: <20230303162135.45831-1-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is the rebased patch set from Wu Guanghao, all the patches can
be applied on top of commit 0a07dea8d3b78 ("Mdmonitor: Refactor
check_one_sharer() for better error handling") from the mdadm tree.

The patch from me is to solve conflict for the first patch of Guanghao.
In order to make the commit logs to be more understandable, I recompose
some patch subjects or commit logs.

The V2 series only changes the patch subject of mine by the suggestion
from Paul Menzel. And nothing more changed from V1.

Thank you in advance for taking them.

Coly Li
---
Coly Li (1):
  util.c: reorder code lines in parse_layout_faulty()

Wu Guanghao (5):
  util.c: fix memleak in parse_layout_faulty()
  Detail.c: fix memleak in Detail()
  isuper-intel.c: fix double free in load_imsm_mpb()
  super-intel.c: fix memleak in find_disk_attached_hba()
  super-ddf.c: fix memleak in get_vd_num_of_subarray()

 Detail.c      |  1 +
 super-ddf.c   |  9 +++++++--
 super-intel.c |  5 +++--
 util.c        | 11 ++++++++---
 4 files changed, 19 insertions(+), 7 deletions(-)

-- 
2.39.2

