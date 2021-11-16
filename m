Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA896C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 02:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE2A761BB6
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 02:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242684AbhKPCkK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Nov 2021 21:40:10 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:11691 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1378352AbhKPCim (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 15 Nov 2021 21:38:42 -0500
X-UUID: 90bc8bf868884a018d55925b20f925ec-20211116
X-UUID: 90bc8bf868884a018d55925b20f925ec-20211116
X-User: zhangyue1@kylinos.cn
Received: from localhost.localdomain [(118.26.139.139)] by nksmu.kylinos.cn
        (envelope-from <zhangyue1@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1740120135; Tue, 16 Nov 2021 10:44:16 +0800
From:   zhangyue <zhangyue1@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] md: fix the problem that the pointer may be double free
Date:   Tue, 16 Nov 2021 10:35:26 +0800
Message-Id: <20211116023526.7077-1-zhangyue1@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

int driver/md/md.c, if the function autorun_array() is called,
the problem of double free may occur.

in function autorun_array(), when the function do_md_run() returns an
error, the function do_md_stop() will be called.

The function do_md_run() called function md_run(), but in function
md_run(), the pointer mddev->private may be freed.

The function do_md_stop() called the function __md_stop(), but in
function __md_stop(), the pointer mddev->private also will be freed
without judging null.

At this time, the pointer mddev->private will be double free, so it
needs to be judged null or not.

Signed-off-by: zhangyue <zhangyue1@kylinos.cn>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f16f190546ef..07c9071578d4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6307,7 +6307,8 @@ static void __md_stop(struct mddev *mddev)
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);
-	pers->free(mddev, mddev->private);
+	if (mddev->private)
+		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	if (pers->sync_request && mddev->to_remove == NULL)
 		mddev->to_remove = &md_redundancy_group;
-- 
2.30.0

