Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BF5C7618E
	for <linux-raid@archiver.kernel.org>; Fri, 21 Apr 2023 06:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjDUGWD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Apr 2023 02:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDUGWC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Apr 2023 02:22:02 -0400
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16ED526AC;
        Thu, 20 Apr 2023 23:21:29 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-44.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-44.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:7f29:0:640:9a2b:0])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id C067061759;
        Fri, 21 Apr 2023 09:21:19 +0300 (MSK)
Received: from localhost.localdomain (unknown [2a02:6b8:b081:8908::1:e])
        by mail-nwsmtp-smtp-corp-main-44.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id DLYUsP1On8c0-darOaoMC;
        Fri, 21 Apr 2023 09:21:19 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1682058079; bh=BxtuDSb76jdK6agAY3VDgPDnE6lPtTUCtMV60+my1qs=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=O7J+6PxfyLbDxVqaTBnKnLIPaE90uFD4xKqXPfn0i5jLATvaiqWLvyxehLbpZz0VQ
         K0kvVGlaaQyRm6UbpUjaykluCPeTRyn3qUD+vODG31xiNAXqONBvg7G0In4hK+JT0K
         QPUdSehNn4BFHZnH4CUBmeNL6GbQLyCzvns8cnnQ=
Authentication-Results: mail-nwsmtp-smtp-corp-main-44.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     Song Liu <song@kernel.org>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] md/md-multipath: guard against a possible NULL dereference
Date:   Fri, 21 Apr 2023 09:21:10 +0300
Message-Id: <20230421062110.368253-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

mempool_alloc might fail to allocate a slot, in which case we will end
up dereferencing a NULL mp_bh pointer.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
Changes since v1: fixed a typo
---
 drivers/md/md-multipath.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 66edf5e72bd6..8dfa353440e5 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -108,6 +108,8 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 		return true;
 
 	mp_bh = mempool_alloc(&conf->pool, GFP_NOIO);
+	if (!mp_bh)
+		return false;
 
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
-- 
2.25.1

