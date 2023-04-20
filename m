Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EABC77B72
	for <linux-raid@archiver.kernel.org>; Thu, 20 Apr 2023 07:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbjDTHVG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Apr 2023 03:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjDTHVF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Apr 2023 03:21:05 -0400
X-Greylist: delayed 120 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Apr 2023 00:21:01 PDT
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93B51713;
        Thu, 20 Apr 2023 00:21:01 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net [IPv6:2a02:6b8:c00:2582:0:640:9a17:0])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id 0DD515FCA9;
        Thu, 20 Apr 2023 10:18:57 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:b409::1:14])
        by mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id qIYucs0OrW20-wj8KMKWB;
        Thu, 20 Apr 2023 10:18:56 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1681975136; bh=BinArMeIu3kbYSgmasOaJJzxzXIJu8lCXv0hNRpOuZc=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=fcf275M+qVSkY2y//2FVVk8kqqNNjQ2q56qyuWLI8+Yz6wZZB3p77kiwAUBESsWjc
         p/rB38rQVlhRaTTD/FtJdd8uFRAgr+BEu0cWG64dqTSt5Zkl5d0pl2SOdm8JV5wnaE
         plPQkVf7JEQsGIG87KvmDx2UHBsD4wI/RbuGLveQ=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     Song Liu <song@kernel.org>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-multipath: guard against a possible NULL dereference
Date:   Thu, 20 Apr 2023 10:18:51 +0300
Message-Id: <20230420071851.326726-1-d-tatianin@yandex-team.ru>
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
 drivers/md/md-multipath.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 66edf5e72bd6..861c70e49bcc 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -108,6 +108,8 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 		return true;
 
 	mp_bh = mempool_alloc(&conf->pool, GFP_NOIO);
+	if (!map_bh)
+		return false;
 
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
-- 
2.25.1

