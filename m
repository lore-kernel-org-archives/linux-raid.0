Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8CAC001B1
	for <linux-raid@archiver.kernel.org>; Sun,  2 Jul 2023 19:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbjGBTq0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjGBTpS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 2 Jul 2023 15:45:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1891735BC;
        Sun,  2 Jul 2023 12:42:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE2760CF6;
        Sun,  2 Jul 2023 19:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15539C433C7;
        Sun,  2 Jul 2023 19:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688326944;
        bh=liKI8go0v6RFrgVnr+DxHksOkqtfIx6X9flTo9resGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIvEpQfsLzuR7Vo6eImThBKzxYrCerIzFppR9CCIfi738e5k84jXFdSQtWt7K9awK
         JMi2wzvZo5MnA7w9X1lJSvusaxpgbZ5pk5Gvj1a60e71NuVYjaPlGBBU+e4P/ppT7A
         wfOcuhiEBG35024/CjjfiaQAZtTxzG9c3bcNAtTQWB7/uExI4ok/7iURy10pU3L0sq
         go3nO44EzdxvrOPMbl//lO2d+zW01K+Xc1YpE8tIVbJDKj9d+qqr04OGy0CentDSKI
         PvLVrJzyZhzE6g9BtjFe0eLd+7qeSC4mYo+kXvur4++6IMvLAd3YLhUZJ+QTvermSR
         GOOWCIclsiBXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Peter Neuwirth <reddunur@online.de>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/5] md: fix data corruption for raid456 when reshape restart while grow up
Date:   Sun,  2 Jul 2023 15:42:17 -0400
Message-Id: <20230702194219.1779408-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230702194219.1779408-1-sashal@kernel.org>
References: <20230702194219.1779408-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 4.19.288
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 873f50ece41aad5c4f788a340960c53774b5526e ]

Currently, if reshape is interrupted, echo "reshape" to sync_action will
restart reshape from scratch, for example:

echo frozen > sync_action
echo reshape > sync_action

This will corrupt data before reshape_position if the array is growing,
fix the problem by continue reshape from reshape_position.

Reported-by: Peter Neuwirth <reddunur@online.de>
Link: https://lore.kernel.org/linux-raid/e2f96772-bfbc-f43b-6da1-f520e5164536@online.de/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230512015610.821290-3-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f8c111b369928..17055cd46fcec 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4636,11 +4636,21 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 			return -EINVAL;
 		err = mddev_lock(mddev);
 		if (!err) {
-			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 				err =  -EBUSY;
-			else {
+			} else if (mddev->reshape_position == MaxSector ||
+				   mddev->pers->check_reshape == NULL ||
+				   mddev->pers->check_reshape(mddev)) {
 				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 				err = mddev->pers->start_reshape(mddev);
+			} else {
+				/*
+				 * If reshape is still in progress, and
+				 * md_check_recovery() can continue to reshape,
+				 * don't restart reshape because data can be
+				 * corrupted for raid456.
+				 */
+				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 			}
 			mddev_unlock(mddev);
 		}
-- 
2.39.2

