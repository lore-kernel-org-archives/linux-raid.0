Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC65C54EBD
	for <linux-raid@archiver.kernel.org>; Tue, 10 Jan 2023 01:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjAJBqY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjAJBqU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 Jan 2023 20:46:20 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A5562C5
        for <linux-raid@vger.kernel.org>; Mon,  9 Jan 2023 17:46:19 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s67so7192289pgs.3
        for <linux-raid@vger.kernel.org>; Mon, 09 Jan 2023 17:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S6cfU45YJ2QEpPTYd3cowb7WGu7MzBSs0rIz44/7hvE=;
        b=T0ru+Bqm/WHpt9NYCuvnTlvLZL5VoK++rrIQdHgdnb0/hzdDe82gNSEteZm8HYMcjX
         4ULBC7XDolafQmJWc+AKzZjGhiEAqCv/J9mPReIt9C9C+Jf75BAx/uIxwXpIA3S+UQPL
         KVJYPt64sV5mOgLepN9aRcNDTZISotQx9/za7dkrFSemlO4xK8imcrOZGC7NuU3cMHG3
         gKaIUFuYnqsXmWi0qRLct6Hh+nT+qHXr4uaDsh476EsH9P94oEjs4qMXm2wsbY9W/Z8Z
         P638VZNKn3u9LdnCOHXjNcVL6p1Xdw6NPaWTbTW5Vez1+FlvuG9TX/F6S6Kd1q+zzamz
         +4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S6cfU45YJ2QEpPTYd3cowb7WGu7MzBSs0rIz44/7hvE=;
        b=H7lBokG/8lGBwmdD4itwJCu2eqEQg0uvNWQnpNqJ0cVl/2XHoWHAwphpeh9W7C2yzJ
         8fTs/6JNrWkfaH+HdHmCvL0wxs9XvUYo5VVF6rA+ILjSdf1mLealtVN3KWPjVTRF9TLI
         IOzV4gTT8/Lpk4w4RwPaZrN08bi0Fe8dt9C+A1jGRxtaQJd+Wx62f03A6hV1w9p3wyFP
         rvJRG/1VYvwRWRigteV7jb/8J51y2KoX5qYWfkGOprY2U3TFF5XbnjYNybQGwCJh5lzL
         LKNwjrUOSqV77isY2sMA0ljyar9i6vmTejJ/7e3EzxdVG6IVuN1BHXBf+MDnvA7xvkoZ
         lB7w==
X-Gm-Message-State: AFqh2komD0Iia/XP2PTo6e/Nnsv8GowgJxe/nJgVOegsd8ywF6gpgg/A
        BUkqCStIB8VwIKHOeghxuGYvGYImN/hhFA==
X-Google-Smtp-Source: AMrXdXs0s99Yja/pMH4c8SWGfdmc4SIK0bmKy0qVuL+sbsl951fUziWsVlwZyIaUCsFYjdWrI05u5g==
X-Received: by 2002:aa7:8043:0:b0:573:487d:e852 with SMTP id y3-20020aa78043000000b00573487de852mr75951349pfm.4.1673315178786;
        Mon, 09 Jan 2023 17:46:18 -0800 (PST)
Received: from AHUANG12-3ZHH9X.lenovo.com (220-143-163-101.dynamic-ip.hinet.net. [220.143.163.101])
        by smtp.gmail.com with ESMTPSA id y127-20020a623285000000b0058abddad316sm19286pfy.209.2023.01.09.17.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 17:46:18 -0800 (PST)
From:   Adrian Huang <adrianhuang0701@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>,
        Adrian Huang <adrianhuang0701@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Adrian Huang <ahuang12@lenovo.com>
Subject: [PATCH 1/1] md: fix incorrect declaration about claim_rdev in md_import_device
Date:   Tue, 10 Jan 2023 09:45:12 +0800
Message-Id: <20230110014512.19233-1-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Adrian Huang <ahuang12@lenovo.com>

Commit fb541ca4c365 ("md: remove lock_bdev / unlock_bdev") removes
wrappers for blkdev_get/blkdev_put. However, the uninitialized local
static variable of pointer type 'claim_rdev' in md_import_device()
is NULL, which leads to the following warning call trace:

  WARNING: CPU: 22 PID: 1037 at block/bdev.c:577 bd_prepare_to_claim+0x131/0x150
  CPU: 22 PID: 1037 Comm: mdadm Not tainted 6.2.0-rc3+ #69
  ..
  RIP: 0010:bd_prepare_to_claim+0x131/0x150
  ..
  Call Trace:
   <TASK>
   ? _raw_spin_unlock+0x15/0x30
   ? iput+0x6a/0x220
   blkdev_get_by_dev.part.0+0x4b/0x300
   md_import_device+0x126/0x1d0
   new_dev_store+0x184/0x240
   md_attr_store+0x80/0xf0
   kernfs_fop_write_iter+0x128/0x1c0
   vfs_write+0x2be/0x3c0
   ksys_write+0x5f/0xe0
   do_syscall_64+0x38/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

It turns out the md device cannot be used:

  md: could not open device unknown-block(259,0).
  md: md127 stopped.

Fix the issue by declaring the local static variable of struct type
and passing the pointer of the variable to blkdev_get_by_dev().

Fixes: fb541ca4c365 ("md: remove lock_bdev / unlock_bdev")
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8af639296b3c..02b0240e7c71 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3644,7 +3644,7 @@ EXPORT_SYMBOL_GPL(md_rdev_init);
  */
 static struct md_rdev *md_import_device(dev_t newdev, int super_format, int super_minor)
 {
-	static struct md_rdev *claim_rdev; /* just for claiming the bdev */
+	static struct md_rdev claim_rdev; /* just for claiming the bdev */
 	struct md_rdev *rdev;
 	sector_t size;
 	int err;
@@ -3662,7 +3662,7 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 
 	rdev->bdev = blkdev_get_by_dev(newdev,
 			FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-			super_format == -2 ? claim_rdev : rdev);
+			super_format == -2 ? &claim_rdev : rdev);
 	if (IS_ERR(rdev->bdev)) {
 		pr_warn("md: could not open device unknown-block(%u,%u).\n",
 			MAJOR(newdev), MINOR(newdev));
-- 
2.25.1

