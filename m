Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395B1C25B08
	for <linux-raid@archiver.kernel.org>; Wed, 17 Aug 2022 12:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbiHQMGI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Aug 2022 08:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239263AbiHQMFs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Aug 2022 08:05:48 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADA9861C5
        for <linux-raid@vger.kernel.org>; Wed, 17 Aug 2022 05:05:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660737937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nt9cHzxG0OzhWvkhOhG4E9LoDBtc5Y91z3JlTnregno=;
        b=Zkf8ExnOk79Soh0wAzTUMpk3IA6h2MCq3zjAS+rFHsOYV5HWGVR0FYDKkjVWG0KcLNwbis
        1vVmp2a2w2gPEGgDU7LFVv9SzwHCF9LzqLaaAJuthQpk0o4YGBhcSXC03m2xpSuIgpIbcL
        9tVrZ7UcvlMzd37iEzjBvw9HOY280bo=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     neilb@suse.de, mpatocka@redhat.com
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH 0/2] fix KASAN issue for dm-raid
Date:   Wed, 17 Aug 2022 20:05:12 +0800
Message-Id: <20220817120514.5536-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Let's try another approach to fix the KASAN issue, and to avoid cause 
issue for clustered raid.

Thanks,
Guoqing

Guoqing Jiang (2):
  Revert "md-raid: destroy the bitmap after destroying the thread"
  md: call __md_stop_writes in md_stop

 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.31.1

