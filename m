Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D8AC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  5 May 2022 08:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347748AbiEEIWo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 May 2022 04:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347941AbiEEIWQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 May 2022 04:22:16 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B2949938
        for <linux-raid@vger.kernel.org>; Thu,  5 May 2022 01:18:15 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651738693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zz0tQRhiJwK3DQTm54W8v/0hXgAEEK/7chkTa4jxoyY=;
        b=lcGWUG7iR+wbSIQpu3xpTU64giWNydYw/7TCgARccGp5SaORw1KlCneuA636m/cV1Cz24p
        GtbEFH6c4yaMh68qsfDYtBX3q6fhk+MMuWNe7xOZWdyIfcQGzvc7nMSdUnXgsXdW7m1fP/
        EunSj1qhz/gjBST7NYBV68b+fVG8G0c=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     buczek@molgen.mpg.de, linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH 0/2] two fixes for md
Date:   Thu,  5 May 2022 16:16:39 +0800
Message-Id: <20220505081641.21500-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

The first patch addressed the issue in the link as reported by Donald.

https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t

Also add another one per discussion of v2 patch.

Thanks,
Guoqing

Guoqing Jiang (2):
  md: don't unregister sync_thread with reconfig_mutex held
  md: protect md_unregister_thread from reentrancy

 drivers/md/md.c | 24 ++++++++++++++++++------
 drivers/md/md.h |  5 +++++
 2 files changed, 23 insertions(+), 6 deletions(-)

-- 
2.31.1

