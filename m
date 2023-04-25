Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42F7C7618E
	for <linux-raid@archiver.kernel.org>; Tue, 25 Apr 2023 01:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjDYBRk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 21:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDYBRj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 21:17:39 -0400
X-Greylist: delayed 150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Apr 2023 18:17:38 PDT
Received: from resqmta-h1p-028591.sys.comcast.net (resqmta-h1p-028591.sys.comcast.net [IPv6:2001:558:fd02:2446::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449854ED9
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 18:17:38 -0700 (PDT)
Received: from resomta-h1p-028516.sys.comcast.net ([96.102.179.207])
        by resqmta-h1p-028591.sys.comcast.net with ESMTP
        id qyTwpZwnnj0L6r7GtpLdGt; Tue, 25 Apr 2023 01:15:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1682385307;
        bh=J6HQDYJxQtl3+lj7cwA7aqsKqByGVidt9LaxnrlYR8U=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=S3JrzeSYESF4TJsWUQsoxhN+RZiiqXi9tc+iuU4ODcF2mEcKDoiqzadao6+3oZpC2
         HUrQxfSskYOZPdiWIoZ8BwX4OXG9kYh5214aKWvkC8fLOXCT0ZFprO13dk5IAnNfnO
         9yFevuOnXKmTaCwxzYi8iBTmXXc4NaWW1jOqJThEP+MiVskCUK2q8YlU0aeWpEACsa
         ma06zzx+LSIRJgrSCdkJZ5hQuwDy25OD5pEZtpcipGmW1YNKc1DZS2h5FSsSfYqOY4
         utJ8KNSAAOqTIbTZz+nmKJb8hRPHsLGOtfJDg1wMuoPRrhFu7wiw3nNKUMdrrAAkDg
         WAeFTpbkUHSxA==
Received: from fedora.. ([24.8.191.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 256/256 bits)
        (Client did not present a certificate)
        by resomta-h1p-028516.sys.comcast.net with ESMTPA
        id r7GRpXKbI6sLVr7GVpnc37; Tue, 25 Apr 2023 01:14:44 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduuddggeehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheplfhonhgrthhhrghnucffvghrrhhitghkuceojhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvqeenucggtffrrghtthgvrhhnpedvtdejiefgueelteevudevhfdvjedvhfdtgfehjeeitdevueektdegtedttdehvdenucfkphepvdegrdekrdduledurdekkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehfvgguohhrrgdrrddpihhnvghtpedvgedrkedrudeluddrkeekpdhmrghilhhfrhhomhepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvpdhnsggprhgtphhtthhopeegpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegurghnrdgtrghrphgvnhhtvghrsehlihhnrghrohdrohhrghdprhgtphhtthhopehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvh
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>
Cc:     <linux-raid@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Jonathan Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH] md: Fix bitmap offset type in sb writer
Date:   Mon, 24 Apr 2023 19:14:38 -0600
Message-Id: <20230425011438.71046-1-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Bitmap offset is allowed to be negative, indicating that bitmap precedes
metadata. Change the type back from sector_t to loff_t to satisfy
conditionals and calculations.

Signed-off-by: Jonathan Derrick <jonathan.derrick@linux.dev>
---
 drivers/md/md-bitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 920bb68156d2..29ae7f7015e4 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -237,8 +237,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
-	sector_t offset = mddev->bitmap_info.offset;
-	sector_t ps, sboff, doff;
+	loff_t sboff, offset = mddev->bitmap_info.offset;
+	sector_t ps, doff;
 	unsigned int size = PAGE_SIZE;
 	unsigned int opt_size = PAGE_SIZE;
 
-- 
2.40.0

