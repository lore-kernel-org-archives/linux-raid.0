Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6479BC04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbiG1MWx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238338AbiG1MWg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E2843336
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:35 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BA40F373CD;
        Thu, 28 Jul 2022 12:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vATnWGO3SG6cCZxoud8lWgNFtNHMXx927KqWxHkFAdo=;
        b=Lp1n78owcxKBmIp0ZM/Le56AEx/yCsp6Z88QxTFKmfuNNC7Y+ARe8wdIxDTajeFIi69NAQ
        xJ5AUG11mNtuS1/WuI0K213R642cHZn9BHjXrPolUSH+ct6IPqs5UZ2wx0ISAUOCURc3hB
        7L6zsj+Q7vksX57dP2H/YXiBt9NUwi8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010953;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vATnWGO3SG6cCZxoud8lWgNFtNHMXx927KqWxHkFAdo=;
        b=zX051r8268r3d5HgQFHP98JnpCXh9NjbICKc6cUHV7UfKLByXbgK1huxjmtmGp0eSOgado
        iypRBwRbC2Dp1EDA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 84A5E2C141;
        Thu, 28 Jul 2022 12:22:31 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 23/23] tests/00readonly: Run udevadm settle before setting ro
Date:   Thu, 28 Jul 2022 20:21:01 +0800
Message-Id: <20220728122101.28744-24-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

In some recent kernel versions, 00readonly fails with:

  mdadm: failed to set readonly for /dev/md0: Device or resource busy
  ERROR: array is not read-only!

This was traced down to a race condition with udev holding a reference
to the block device at the same time as trying to set it read only.

To fix this, call udevadm settle before setting the array read only.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Coly Li <colyli@suse.de>
---
 tests/00readonly | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/00readonly b/tests/00readonly
index 39202487..afe243b3 100644
--- a/tests/00readonly
+++ b/tests/00readonly
@@ -12,6 +12,7 @@ do
 			$dev1 $dev2 $dev3 $dev4 --assume-clean
 		check nosync
 		check $level
+		udevadm settle
 		mdadm -ro $md0
 		check readonly
 		state=$(cat /sys/block/md0/md/array_state)
-- 
2.35.3

