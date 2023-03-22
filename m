Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58BCC77B60
	for <linux-raid@archiver.kernel.org>; Wed, 22 Mar 2023 20:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjCVUBQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjCVUA0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Mar 2023 16:00:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E99F62B6B;
        Wed, 22 Mar 2023 12:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27797B81DEC;
        Wed, 22 Mar 2023 19:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A50C4331D;
        Wed, 22 Mar 2023 19:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515104;
        bh=rWaeNrrF5M3V94CkeClxm/OUD5fvq2UHmG8t9yd/ndk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaj+UdDDv/04tQvfKG3r4kAY6GSyCsmws+aYwIGemWyFaLf5FUO7+lJHO8STl4jgw
         1zVp1VA0J2JOjfIdJN8jqEJ8I6GpH2nAEr5BCH0t0l/+9uPvI0DwuW1PihbFciitZY
         QCwbw+DqNNkPRQkFwVPFpfc0QuYoPtSpPudkg16+xlOq6GGtLuEcfTYDx7//zQqNZe
         ZLAg2cOxKHY+FPGCGTOJSFsO1FPs0p7iw6JF6DaKlBzJNgAXwpwFygCBGfGHTaNqPu
         AsbQvHtrRl9FnbgRZ8/K8AA/vuT0TMHg1Fiv92eS5NSGH0YRQ+iv28zsV2oqtvRrZs
         fTdl2xG081USg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>, Dan Carpenter <error27@gmail.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 22/45] md: avoid signed overflow in slot_store()
Date:   Wed, 22 Mar 2023 15:56:16 -0400
Message-Id: <20230322195639.1995821-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit 3bc57292278a0b6ac4656cad94c14f2453344b57 ]

slot_store() uses kstrtouint() to get a slot number, but stores the
result in an "int" variable (by casting a pointer).
This can result in a negative slot number if the unsigned int value is
very large.

A negative number means that the slot is empty, but setting a negative
slot number this way will not remove the device from the array.  I don't
think this is a serious problem, but it could cause confusion and it is
best to fix it.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 272cc5d14906f..beab84f0c585c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3131,6 +3131,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = kstrtouint(buf, 10, (unsigned int *)&slot);
 		if (err < 0)
 			return err;
+		if (slot < 0)
+			/* overflow */
+			return -ENOSPC;
 	}
 	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
-- 
2.39.2

