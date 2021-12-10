Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4A9C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 09:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbhLJJfN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 04:35:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230027AbhLJJfM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 10 Dec 2021 04:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639128697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=akyfv2EIeWmoKYTBLL/1MF/z5DrGAJIfBwktrNIT/1M=;
        b=eJGPaW5sKAFzgF/RYZvHOyP8UciM6aS0Cp/F4UjX4t0HeJE0KsV583waIgZmWUQUvUjtAD
        oREB6II46miTNI0YYxLo8HKqmODtJFrlWgn2YBAXNiq4N6aTubCaxWBehCy5J4+2I4qHzX
        6yD2PYoV3UFTdgCJid1f3GOYxclNrdA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-ZlZfaVSGNnuE6SSfRd2CzQ-1; Fri, 10 Dec 2021 04:31:36 -0500
X-MC-Unique: ZlZfaVSGNnuE6SSfRd2CzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D183480BCAC;
        Fri, 10 Dec 2021 09:31:34 +0000 (UTC)
Received: from fedora.redhat.com (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F22451001F4D;
        Fri, 10 Dec 2021 09:31:32 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     guoqing.jiang@linux.dev, ncroxon@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH V2 1/2] md/raid0: Free r0conf memory when register integrity failed
Date:   Fri, 10 Dec 2021 17:31:15 +0800
Message-Id: <20211210093116.7847-2-xni@redhat.com>
In-Reply-To: <20211210093116.7847-1-xni@redhat.com>
References: <20211210093116.7847-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It doesn't free memory when register integrity failed. And it will
add acct_bioset_exit in raid0_free. So split free r0conf codes
into a single function to make error handling more clear.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
V2: set mddev->private to NULL and move free_conf/raid0_free
above to avoid the extra declaration
---
 drivers/md/raid0.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 62c8b6adac70..88424d7a6ebd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -356,7 +356,20 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 	return array_sectors;
 }
 
-static void raid0_free(struct mddev *mddev, void *priv);
+static void free_conf(struct mddev *mddev, struct r0conf *conf)
+{
+	kfree(conf->strip_zone);
+	kfree(conf->devlist);
+	kfree(conf);
+	mddev->private = NULL;
+}
+
+static void raid0_free(struct mddev *mddev, void *priv)
+{
+	struct r0conf *conf = priv;
+
+	free_conf(mddev, conf);
+}
 
 static int raid0_run(struct mddev *mddev)
 {
@@ -413,17 +426,14 @@ static int raid0_run(struct mddev *mddev)
 	dump_zones(mddev);
 
 	ret = md_integrity_register(mddev);
+	if (ret)
+		goto free;
 
 	return ret;
-}
-
-static void raid0_free(struct mddev *mddev, void *priv)
-{
-	struct r0conf *conf = priv;
 
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
-	kfree(conf);
+free:
+	free_conf(mddev, conf);
+	return ret;
 }
 
 static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
-- 
2.31.1

