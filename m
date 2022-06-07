Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35928C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  7 Jun 2022 02:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbiFGCEr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 22:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiFGCEq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 22:04:46 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EEC27B1B
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 19:04:45 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654567483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mRSBAZgqHNwfWX26DLg2vFcfqbrFGtTijiym1rTnvaI=;
        b=IB06Obt/mVmJag3i6XkSquIC0Ve7ebXJwuN8LB4TYcndFCsW8mpn9uMhUNcjoSgDGTFCzF
        XtY1oJunPMD2Uo4oJdSvDcFEFKKyvHRKdTUSuBt4gPkfcss2+E0HmBrW4oE8U/a2Th8U4Z
        iCFWeMN/p/oYtN+LraYYcwJ8bcr1E6A=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     buczek@molgen.mpg.de, logang@deltatee.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 0/2] md: regression fix
Date:   Tue,  7 Jun 2022 10:03:55 +0800
Message-Id: <20220607020357.14831-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

The first one reverts commit 8b48ec23cc51a ("md: don't unregister
sync_thread with reconfig_mutex held") since 07reshape5intr is
broken because of it.

The second one tried another way to fix previous problem.

Thanks,
Guoqing

Guoqing Jiang (2):
  Revert "md: don't unregister sync_thread with reconfig_mutex held"
  md: unlock mddev before reap sync_thread in action_store

 drivers/md/dm-raid.c |  3 ++-
 drivers/md/md.c      | 26 +++++++++++++++-----------
 drivers/md/md.h      |  2 +-
 3 files changed, 18 insertions(+), 13 deletions(-)

-- 
2.31.1

