Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9012C4321E
	for <linux-raid@archiver.kernel.org>; Tue, 29 Nov 2022 13:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiK2Ndh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Nov 2022 08:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbiK2NdW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Nov 2022 08:33:22 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B846314B
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 05:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2MRaTrBHxw8ratunwhegDqefaw524ePxMU+0AiCcbKE=; b=OaVp+8VHZDw8PN8uY61/PVlaNF
        t5XO8fdU1ZfCaj+m4gzTSTTnvha+MQOhwgVx7m/+ddRTEn7teK+MKgIgO93hqiRWg62dwnzSp11ah
        LA7BPP4y9PUMRqhVXyC+BcNtSGB4oyHHmrKNTNh4v/6yZ97sUX8efZ6Yu4x31viftTIEZIuibFVGJ
        ONnoQOLlHAaO5lbjF7j/IRJN1CD4N158NMaSb2AHh8/zv+Gn9klcLEPZXj72eB0mfQUkJ8QN9DH/U
        NeMTkg6r79oIi1hI1u9mnDoXc2VSwaXbR6X+hHDYq0Dt4PlNxoRM08I1SFjanLI23fqx6E1CMyqa5
        9rRQgPOw==;
Received: from [2001:4bb8:192:26e7:691d:40a8:d7b5:b2f5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p00jQ-008poZ-Tm; Tue, 29 Nov 2022 13:33:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/3] md: mark md_kick_rdev_from_array static
Date:   Tue, 29 Nov 2022 14:32:54 +0100
Message-Id: <20221129133255.8228-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221129133255.8228-1-hch@lst.de>
References: <20221129133255.8228-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

md_kick_rdev_from_array is only used in md.c, so unexport it and mark
the symbol static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 3 +--
 drivers/md/md.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 27ce98b018aff9..94adb403946534 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2508,12 +2508,11 @@ static void export_rdev(struct md_rdev *rdev)
 	kobject_put(&rdev->kobj);
 }
 
-void md_kick_rdev_from_array(struct md_rdev *rdev)
+static void md_kick_rdev_from_array(struct md_rdev *rdev)
 {
 	unbind_rdev_from_array(rdev);
 	export_rdev(rdev);
 }
-EXPORT_SYMBOL_GPL(md_kick_rdev_from_array);
 
 static void export_array(struct mddev *mddev)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b4e2d8b87b6113..554a9026669ad9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -782,7 +782,6 @@ extern void mddev_resume(struct mddev *mddev);
 
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
-extern void md_kick_rdev_from_array(struct md_rdev * rdev);
 extern void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
 				     bool is_suspend);
 extern void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
-- 
2.30.2

