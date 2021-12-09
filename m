Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A1BC433F5
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 05:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhLIF7L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 00:59:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231316AbhLIF7L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 00:59:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639029337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=IQGRa+NTDczvwn9Jdy5kV0R/E3hHo/btNlunzOHLwkQ=;
        b=HOffEmQlOOnEgYIwmCbEKaHxFYRtD8/VPKAg7ipcBf5zGA4n1CYKf10RWJchIMd+dINuYF
        jSrikf8PZnaeTgSJPXEBkvC4QQGG+Ec6gHfpYBfcx/lOEP4rLzim/JhVaadTzQcRg+0yj1
        /jA4ryk+LSXuHbbLY8W/+bBu3AU3DWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-pdYZwgjBNfWDF5O9cW6fPg-1; Thu, 09 Dec 2021 00:55:36 -0500
X-MC-Unique: pdYZwgjBNfWDF5O9cW6fPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EE75801AAB;
        Thu,  9 Dec 2021 05:55:35 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2ED410016FE;
        Thu,  9 Dec 2021 05:55:31 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     guoqing.jiang@linux.dev, ncroxon@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md/raid0: Free r0conf memory when register integrity failed
Date:   Thu,  9 Dec 2021 13:55:23 +0800
Message-Id: <1639029324-4026-2-git-send-email-xni@redhat.com>
In-Reply-To: <1639029324-4026-1-git-send-email-xni@redhat.com>
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It doesn't free memory when register integrity failed. And move
free conf codes into a single function.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid0.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 62c8b6adac70..3fa47df1c60e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -356,6 +356,7 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 	return array_sectors;
 }
 
+static void free_conf(struct r0conf *conf);
 static void raid0_free(struct mddev *mddev, void *priv);
 
 static int raid0_run(struct mddev *mddev)
@@ -413,19 +414,30 @@ static int raid0_run(struct mddev *mddev)
 	dump_zones(mddev);
 
 	ret = md_integrity_register(mddev);
+	if (ret)
+		goto free;
 
 	return ret;
+
+free:
+	free_conf(conf);
+	return ret;
 }
 
-static void raid0_free(struct mddev *mddev, void *priv)
+static void free_conf(struct r0conf *conf)
 {
-	struct r0conf *conf = priv;
-
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
 }
 
+static void raid0_free(struct mddev *mddev, void *priv)
+{
+	struct r0conf *conf = priv;
+
+	free_conf(conf);
+}
+
 static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 {
 	struct r0conf *conf = mddev->private;
-- 
2.31.1

