Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C54C4167B
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 12:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbjKGMgM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 07:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbjKGMfl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 07:35:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870ED4229;
        Tue,  7 Nov 2023 04:25:02 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5619CC433C8;
        Tue,  7 Nov 2023 12:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699359902;
        bh=mRQkG+dfopQNvnmWgZT+CDWwvaNhCd4CsE5PudPi6lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKTcGyQyNi0NVzJ9bMPRdv28lS48DLHaXSQbrS9AIr4s5udNe/oCa/WHvunaz0tAp
         JnOVGuEmIfqtFNC7l1jKL0wQxezzloC3JE9rPzP/NFIlyrmvaiQ1h+3L9a+6si4tPq
         XJA1dXTX6dED4S8EWwV+Bp+MpIlN2HnfCz5U7JCjOWteGxYqYbTrbxAoPfYmxKDI/7
         5unfJ8kiU72e4ZLD/5mqNKGhJwwu2yOJ6sRyhVoU8MmWXzVNbioA5cah4I6vxDzFkJ
         0oOvyIbkLhZcsRv6YjLq85pHpZdtRcVWECSTOIkTiyQj2tPeZK1G1ueeoIsQlW7WKg
         o8EBS6qaMxNhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.5 08/37] md: don't rely on 'mddev->pers' to be set in mddev_suspend()
Date:   Tue,  7 Nov 2023 07:21:19 -0500
Message-ID: <20231107122407.3760584-8-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231107122407.3760584-1-sashal@kernel.org>
References: <20231107122407.3760584-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.5.10
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit b721e7885eb242aa2459ee66bb42ceef1bcf0f0c ]

'active_io' used to be initialized while the array is running, and
'mddev->pers' is set while the array is running as well. Hence caller
must hold 'reconfig_mutex' and guarantee 'mddev->pers' is set before
calling mddev_suspend().

Now that 'active_io' is initialized when mddev is allocated, such
restriction doesn't exist anymore. In the meantime, follow up patches
will refactor mddev_suspend(), hence add checking for 'mddev->pers' to
prevent null-ptr-deref.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230825030956.1527023-4-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 78d51dddf3a00..34b7196d9634c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -449,7 +449,7 @@ void mddev_suspend(struct mddev *mddev)
 	set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	percpu_ref_kill(&mddev->active_io);
 
-	if (mddev->pers->prepare_suspend)
+	if (mddev->pers && mddev->pers->prepare_suspend)
 		mddev->pers->prepare_suspend(mddev);
 
 	wait_event(mddev->sb_wait, percpu_ref_is_zero(&mddev->active_io));
-- 
2.42.0

