Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74360C64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCFV3p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCFV3P (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B476630D1
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LCGuROQ/Kb1G9JfeQNfTp0LsTsDyLGp+Sz8iQSLeyvo=;
        b=VjJBjt1KYDnYJ+HNClXIkTLjG++ab2ZkNcCF6CZfeYJRT85oWQ0ptxxMmuGnviEjp7FRnY
        84wTLavXaRpTDxvTV2Fz3lcNvhSj1GkOgG58zczOy3CPapxcheGZEdShBi8IYWPVoRMBuN
        nEhP/HP4yF2KOzVyHaOYx+RvQ4sV7/I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-tJTq4wY4PIGp5Xy8KzF3gg-1; Mon, 06 Mar 2023 16:28:17 -0500
X-MC-Unique: tJTq4wY4PIGp5Xy8KzF3gg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D4CD29DD981
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:17 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9F9740AE20A;
        Mon,  6 Mar 2023 21:28:16 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 18/34] md: avoid redundant braces in single line statements [WARNING]
Date:   Mon,  6 Mar 2023 22:27:41 +0100
Message-Id: <258d52b52c0e1e202c0e5b3e128e5967ffd5f8a1.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md-bitmap.c  | 3 +--
 drivers/md/md-cluster.c | 3 +--
 drivers/md/raid5.c      | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9f1e25927d13..65e77a7e3656 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2173,9 +2173,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 				unsigned long k;
 
 				/* deallocate the page memory */
-				for (k = 0; k < page; k++) {
+				for (k = 0; k < page; k++)
 					kfree(new_bp[k].map);
-				}
 				kfree(new_bp);
 
 				/* restore some fields from old_counts */
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 7ad5e1a97638..762160e81ce8 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1531,9 +1531,8 @@ static void unlock_all_bitmaps(struct mddev *mddev)
 	/* release other node's bitmap lock if they are existed */
 	if (cinfo->other_bitmap_lockres) {
 		for (i = 0; i < mddev->bitmap_info.nodes - 1; i++) {
-			if (cinfo->other_bitmap_lockres[i]) {
+			if (cinfo->other_bitmap_lockres[i])
 				lockres_free(cinfo->other_bitmap_lockres[i]);
-			}
 		}
 		kfree(cinfo->other_bitmap_lockres);
 		cinfo->other_bitmap_lockres = NULL;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 08a0ee77cacb..f834c497b8fe 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4109,9 +4109,8 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 				pr_debug("Return write for disc %d\n", i);
 				if (test_and_clear_bit(R5_Discard, &dev->flags))
 					clear_bit(R5_UPTODATE, &dev->flags);
-				if (test_and_clear_bit(R5_SkipCopy, &dev->flags)) {
+				if (test_and_clear_bit(R5_SkipCopy, &dev->flags))
 					WARN_ON(test_bit(R5_UPTODATE, &dev->flags));
-				}
 				do_endio = true;
 
 returnbi:
-- 
2.39.2

