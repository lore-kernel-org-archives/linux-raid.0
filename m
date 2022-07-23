Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B10C43334
	for <linux-raid@archiver.kernel.org>; Sat, 23 Jul 2022 06:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiGWGYm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Jul 2022 02:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiGWGYk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Jul 2022 02:24:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F7369F07
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 23:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZB135lCH7JElHDVPu1g6FFLP/NPUkBCIj3h+9kp9LC8=; b=jLs17ZQJKODkh7qAB3oYhkMruO
        vOKCRz7C5B9RyfR+FWBmDHrqhLTgmY/Dya6QDX3/SxcyhDNIgu2GzIRWHcoyJaZJdt1z3/wmB9zvn
        /dRSmsNWlm/PrFMEM2TWN+Y/6rUEb/Tey0CJBkAIxnQJ5NGHwzDKvL5RU3J62jnREjwwxzJ3ewBrs
        /otgy46nZDLkqovbfApgWDNUzCo3FEGP37tYXGF6gexhm/v5rfQZn9FUd93JaL7tg9xkf5M4KBBVI
        mnaDvVZp594MMGhyRzdtSYZfbmPxUhbLexLEyM61/3mJSZgCjLinmN7KsUizGrNkqZ7TKOyzlu7wo
        dASjKYww==;
Received: from [2001:4bb8:199:fe1f:951f:1322:520f:5e75] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oF8Z1-00GKJo-AU; Sat, 23 Jul 2022 06:24:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md: open code md_probe in autorun_devices
Date:   Sat, 23 Jul 2022 08:24:28 +0200
Message-Id: <20220723062429.2210193-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220723062429.2210193-1-hch@lst.de>
References: <20220723062429.2210193-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

autorun_devices should not be limited to the controls for the legacy
probe on open, so just call md_alloc directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2b2267be5c329..5671160ad3982 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6500,7 +6500,7 @@ static void autorun_devices(int part)
 			break;
 		}
 
-		md_probe(dev);
+		md_alloc(dev, NULL);
 		mddev = mddev_find(dev);
 		if (!mddev)
 			break;
-- 
2.30.2

