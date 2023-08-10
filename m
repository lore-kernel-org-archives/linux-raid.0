Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D477EC001B0
	for <linux-raid@archiver.kernel.org>; Thu, 10 Aug 2023 12:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbjHJMM1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Aug 2023 08:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234658AbjHJMMY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Aug 2023 08:12:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0D31718
        for <linux-raid@vger.kernel.org>; Thu, 10 Aug 2023 05:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691669500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2C+lnqtUFW8OB6r3J+4+8yuiI945xOnrzzLcujFhnhg=;
        b=MF/kS581rH3pYp6VdRWKG7piQfG3soCru562caJmpnpv+nXLqmDgYLjbzOhPhAxbiTEXKl
        kX2xJOuA8n+GRm0qVSB4zj2di4Vr1u7crRngI1BXxgXhKw0VxzLxOLPOuNARD2NHneV246
        0DpMcQRNjMFA06CLXqFBDDIsqLxym0s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-GJWjoP3DOAC1TzUROXetAQ-1; Thu, 10 Aug 2023 08:11:38 -0400
X-MC-Unique: GJWjoP3DOAC1TzUROXetAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA185185A78F;
        Thu, 10 Aug 2023 12:11:37 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F298140C2077;
        Thu, 10 Aug 2023 12:11:35 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com
Subject: [PATCH 3/3] md raid1: add empty line
Date:   Thu, 10 Aug 2023 14:11:32 +0200
Message-ID: <e4334b4ff38cd9faf6d43874deb38138abcbe2af.1691592775.git.heinzm@redhat.com>
In-Reply-To: <cover.1691592775.git.heinzm@redhat.com>
References: <cover.1691592775.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: heinzm <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0aed74efd758..5c469ce843c8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1509,6 +1509,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio = NULL;
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
+
 		if (!r1_bio->bios[i])
 			continue;
 
-- 
2.41.0

