Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763FFC28D13
	for <linux-raid@archiver.kernel.org>; Mon, 22 Aug 2022 07:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiHVHqx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Aug 2022 03:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiHVHqx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 Aug 2022 03:46:53 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B677632C
        for <linux-raid@vger.kernel.org>; Mon, 22 Aug 2022 00:46:51 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661154409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pfEtl2mHtp/MxnT1vlCDjCdp5BH5eTan9CxSiPw9rE8=;
        b=v/ce2YBCBRssKJDaC7zstO9O1n5DffhsJYS9KPteD+Ik9O7QYHVoJrpUlsFP8xlCjcRFHd
        ZtqCv/Sx4csMGpMp7LooEG6iTN8tK8b784BiT1TZKWnh+RUCfFaluJqBKVxpIgOmHO4Jp0
        xNOQ171KY+uT6viPvRu2VRusnIc0k/Q=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH] md/raid10: fix compile warning
Date:   Mon, 22 Aug 2022 15:45:39 +0800
Message-Id: <20220822074539.12877-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

With W=1, compiler complains.

drivers/md/raid10.c:1983: warning: bad line:

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 26545950ca42..aa5b28017a49 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1980,7 +1980,7 @@ static int enough(struct r10conf *conf, int ignore)
  * Otherwise, it must be degraded:
  *	- recovery is interrupted.
  *	- &mddev->degraded is bumped.
-
+ *
  * @rdev is marked as &Faulty excluding case when array is failed and
  * &mddev->fail_last_dev is off.
  */
-- 
2.31.1

