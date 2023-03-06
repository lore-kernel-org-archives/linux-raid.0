Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCE5C64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjCFVaD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjCFV3S (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B1355079
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wUwYAf75kzN555j1xhSkYSjgQC7AbJj+p2a7KS8azRA=;
        b=hg4ZwGdnJllgdhkttWTk/Fy3M66/pJeHPyNfQgMZ0+Z1Qezz+3tLcWbC7Aqo8QQNzutEsV
        x1ZFckeEhRd3qP8KMlSvjvbSSxglkizwBX4TX5suzaBPKTh1I467EtZT8FqrbJc/m9UcvZ
        R8C/Mzf/7FwboFnJoAU8RnE2Ns/BpyY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-dN8WH9yxO_mrcSnSUCTIrQ-1; Mon, 06 Mar 2023 16:28:18 -0500
X-MC-Unique: dN8WH9yxO_mrcSnSUCTIrQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BB7D101A55E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:18 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7DAC400DFA1;
        Mon,  6 Mar 2023 21:28:17 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 19/34] md: place constant on the right side of a test [WARNING]
Date:   Mon,  6 Mar 2023 22:27:42 +0100
Message-Id: <df99a439378c49212db62b1b8b42a166e8b014bc.1678136717.git.heinzm@redhat.com>
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
 drivers/md/raid10.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 510000de0886..60c9fba59d9f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3259,8 +3259,8 @@ static void raid10_set_cluster_sync_high(struct r10conf *conf)
 	/*
 	 * At least use a 32M window to align with raid1's resync window
 	 */
-	window_size = (CLUSTER_RESYNC_WINDOW_SECTORS > window_size) ?
-			CLUSTER_RESYNC_WINDOW_SECTORS : window_size;
+	window_size = (window_size < CLUSTER_RESYNC_WINDOW_SECTORS) ?
+		      CLUSTER_RESYNC_WINDOW_SECTORS : window_size;
 
 	conf->cluster_sync_high = conf->cluster_sync_low + window_size;
 }
-- 
2.39.2

