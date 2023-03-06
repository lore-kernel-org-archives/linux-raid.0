Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228C6C6FD1A
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjCFVa6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCFV3p (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32AA79B08
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDd5P5VAosuwMMUkLlkztfFCkxckm/gcCcf5OmcFEAE=;
        b=J1YFnJweSLMmhEMcp/pLdBmWee4By+wuRNWpP8W5u4PT+TKCtWK7zywqqDhuiOwV89Fyko
        FV+Q4I03CMmo/jbVqq4hnBwgZ0cyTBLg8zDQzy2H8QUnTLuoQv6ts2q0+pzbHi5+/9BB5p
        Wt6U4NB1S6ZZLxsppDuplkHThZL352M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-Tq1HAUKoNe-A08-lx7TL5w-1; Mon, 06 Mar 2023 16:28:30 -0500
X-MC-Unique: Tq1HAUKoNe-A08-lx7TL5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AED03801F61
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:30 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B79F6400DFA1;
        Mon,  6 Mar 2023 21:28:29 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 31/34] md raid5: prefer 'int' instead of 'signed' [WARNING]
Date:   Mon,  6 Mar 2023 22:27:54 +0100
Message-Id: <f3e5bc07a97201d971b92fbc26c16fa12b160c61.1678136717.git.heinzm@redhat.com>
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
 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 557398bf4c72..fb6e0cf727a6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1393,9 +1393,9 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 	struct r5conf *conf = sh->raid_conf;
 
 	if (bio->bi_iter.bi_sector >= sector)
-		page_offset = (signed)(bio->bi_iter.bi_sector - sector) * 512;
+		page_offset = (int)(bio->bi_iter.bi_sector - sector) * 512;
 	else
-		page_offset = (signed)(sector - bio->bi_iter.bi_sector) * -512;
+		page_offset = (int)(sector - bio->bi_iter.bi_sector) * -512;
 
 	if (frombio)
 		flags |= ASYNC_TX_FENCE;
-- 
2.39.2

