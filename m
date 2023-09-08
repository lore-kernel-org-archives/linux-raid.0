Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612B2EEB566
	for <linux-raid@archiver.kernel.org>; Fri,  8 Sep 2023 19:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345028AbjIHTgt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Sep 2023 15:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjIHTgm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Sep 2023 15:36:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6021B0;
        Fri,  8 Sep 2023 12:36:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D21C433CA;
        Fri,  8 Sep 2023 19:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694201727;
        bh=dcHgw5lG4T1RSyZSuYFil0vixaTEjMtdzWRedIsn5hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5PfrjQr9kLnlpR7hi+hECgsCds74wg1RumERzC5Vj69UXmLrKqeRVtKt5fh/P9Bq
         NaYgOwHWxdPr6DXdRXQT4Nwj4WYcX6Le2QuS6DCp6HkAoLNRAWOhmm006s/Vbmz1Aj
         Mm4YWckkzvt5y7chhVlY+Y+21EjOhjyIevUpwMUPlxT8cwbEW1TkE98rQYH2U8jyxj
         lxVxwalv5CrZZr1TzB59TYZf2GzWYiNfMwL1q97btIZ8c7Tr6yaWWFlOOkJbI7akuu
         xax/iBMVSpyC1KQn+E18QoL5oJjkJ53gF+NyZ7Jor7UaV8EgD6UvTpe90b6Tok781y
         WTgpVCW3MPkqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Shurong <zhang_shurong@foxmail.com>,
        Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 21/22] md: raid1: fix potential OOB in raid1_remove_disk()
Date:   Fri,  8 Sep 2023 15:34:05 -0400
Message-Id: <20230908193407.3463368-21-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230908193407.3463368-1-sashal@kernel.org>
References: <20230908193407.3463368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.52
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit 8b0472b50bcf0f19a5119b00a53b63579c8e1e4d ]

If rddev->raid_disk is greater than mddev->raid_disks, there will be
an out-of-bounds in raid1_remove_disk(). We have already found
similar reports as follows:

1) commit d17f744e883b ("md-raid10: fix KASAN warning")
2) commit 1ebc2cec0b7d ("dm raid: fix KASAN warning in raid5_remove_disk")

Fix this bug by checking whether the "number" variable is
valid.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/tencent_0D24426FAC6A21B69AC0C03CE4143A508F09@qq.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ac64c587191b9..72303c6201747 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1826,6 +1826,10 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct r1conf *conf = mddev->private;
 	int err = 0;
 	int number = rdev->raid_disk;
+
+	if (unlikely(number >= conf->raid_disks))
+		goto abort;
+
 	struct raid1_info *p = conf->mirrors + number;
 
 	if (rdev != p->rdev)
-- 
2.40.1

