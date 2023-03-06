Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BB7C64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCFVaH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjCFV31 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B35D3E60C
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZFbkkNHYbxjgOW4gnOA+H9T/pVEVoNw/tVTDeHnXzI=;
        b=aG3o4QX8c3jpoBCPVl3Wb01JYE0PezwheJ+13C4Xki9naqQLtGc+ORsklFx1D76z/5VdT6
        yuiZFtyHH1/wKPa/4ekkFxFP/zxiq7NVL6tQMXfg6d8J8k6od+MlEDO6+YHNYfiQ1C1uxq
        i45HqD87/XOpSjVex/A2GHcFS2wUxC4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-Gs-HwkgbNzqqgocByKb6kw-1; Mon, 06 Mar 2023 16:28:25 -0500
X-MC-Unique: Gs-HwkgbNzqqgocByKb6kw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74D961C04B7D
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:25 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B065D401B290;
        Mon,  6 Mar 2023 21:28:24 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 26/34] md autodetect: correct placement of __initdata [WARNING]
Date:   Mon,  6 Mar 2023 22:27:49 +0100
Message-Id: <371c4dc93f456e945609724fef7f1563b6497e1d.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-autodetect.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index ff60c2272919..868be6f32191 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -21,11 +21,11 @@
  */
 
 #ifdef CONFIG_MD_AUTODETECT
-static int __initdata raid_noautodetect;
+static int raid_noautodetect __initdata;
 #else
-static int __initdata raid_noautodetect = 1;
+static int raid_noautodetect __initdata = 1;
 #endif
-static int __initdata raid_autopart;
+static int raid_autopart __initdata;
 
 static struct md_setup_args {
 	int minor;
-- 
2.39.2

