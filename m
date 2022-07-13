Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6EBC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 21:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbiGMVGb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 17:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiGMVGa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 17:06:30 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C6E32EFE;
        Wed, 13 Jul 2022 14:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=Eva5OAEv/RJD0HMIjc3d1CqcCIZEAGFzGgc5x7s6/Ho=; b=KbR/HcHFIkiZJyWdtT8Br+4DZR
        ZGql0iXsIOi+gP6Ige5kvTyzkjGrYfaEfiFapblWysGcLow4+NiK0qL2IdBhH5oY2yQth3pTHFcqx
        OfAwHcmMLMFJDpWgsqGiXQZJ/8oYRkb+6F4OB1wf9fFkq/lvY2NvpZcdlMJugjERYpX0VDyKW8y77
        EcS71qVKls3JTZ2aaV1DSWAC8LqW9cf1bvaH7t8QcTLJoZtau9HWxMQlyNLKDC0uv26/pjSlw+JD7
        7biUwYPPJA7xMW1OIWLld93P+eWZSxjvbBEWwwX/xiqSiC1gj5FUUv7rpMWSPCq7MLiRHU6Y9+kdO
        1ZSpxPEw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oBjYv-00EDFl-Fz; Wed, 13 Jul 2022 15:06:26 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oBjYu-0003py-RH; Wed, 13 Jul 2022 15:06:24 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 13 Jul 2022 15:06:23 -0600
Message-Id: <20220713210623.14705-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: song@kernel.org, hch@lst.de, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH] md: Ensure mddev object is cleaned up with kobject_put on error path
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The documentation for kobject_init() clearly states that the new
object must be cleaned up with a call to kobject_put(), not a
kfree() call directly.

However, the error path in mddev_alloc() frees the newly allocated
mddev object directly with kfree() after kobject_init() is called
in mddev_init().

Fix this by changing the kfree() call to a kobject_put().

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 198d4ceae55a..d9e0e38be38c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -769,7 +769,7 @@ static struct mddev *mddev_alloc(dev_t unit)
 	return new;
 out_free_new:
 	spin_unlock(&all_mddevs_lock);
-	kfree(new);
+	kobject_put(&new->kobj);
 	return ERR_PTR(error);
 }
 

base-commit: 922f4b5c75aa13532382ffb4964d2d12ad98747e
-- 
2.30.2

