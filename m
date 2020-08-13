Return-Path: <SRS0=qvga=BX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3027C433DF
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 06:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E3422078D
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 06:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IL7uCi+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHMGpE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Aug 2020 02:45:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725960AbgHMGpE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 13 Aug 2020 02:45:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597301102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=tvuFl17dSZbNS7gNSSVrGyylvczAR1lkwfyzFulHwlg=;
        b=IL7uCi+hvDszteoqtR4xoaQbf977hsIzJ4J9kDWtZ21VPeuAIE6Wr6ws2eWYeziNxdSOe6
        pu+6qjg1ou1QlyZBdyZldi8U4uZevlqysDMm9mALfHmawz71cEJ2yuY1pL/AxVVO8k6a/s
        cpKs8RrGDadEfq2kxaNTbKfc/z6nPBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-UV-DCC5LOQe6S6QXRgGFDQ-1; Thu, 13 Aug 2020 02:45:01 -0400
X-MC-Unique: UV-DCC5LOQe6S6QXRgGFDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16A33180DE23;
        Thu, 13 Aug 2020 06:45:00 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29ED15FC1B;
        Thu, 13 Aug 2020 06:44:56 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, guoqing.jiang@cloud.ionos.com, heinzm@redhat.com,
        ncroxon@redhat.com
Subject: [md PATCH V3 2/4] extend r10bio devs to raid disks
Date:   Thu, 13 Aug 2020 14:44:45 +0800
Message-Id: <1597301087-6565-3-git-send-email-xni@redhat.com>
In-Reply-To: <1597301087-6565-1-git-send-email-xni@redhat.com>
References: <1597301087-6565-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now it allocs r10bio->devs[conf->copies]. Discard bio needs to submit
to all member disks and it needs to use r10bio. So extend to
r10bio->devs[geo.raid_disks].

Reviewed-by: Coly Li <colyli@suse.de>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cefda2a..cef3cb8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -91,7 +91,7 @@ static inline struct r10bio *get_resync_r10bio(struct bio *bio)
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct r10conf *conf = data;
-	int size = offsetof(struct r10bio, devs[conf->copies]);
+	int size = offsetof(struct r10bio, devs[conf->geo.raid_disks]);
 
 	/* allocate a r10bio with room for raid_disks entries in the
 	 * bios array */
@@ -238,7 +238,7 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
 {
 	int i;
 
-	for (i = 0; i < conf->copies; i++) {
+	for (i = 0; i < conf->geo.raid_disks; i++) {
 		struct bio **bio = & r10_bio->devs[i].bio;
 		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
@@ -327,7 +327,7 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
 	int slot;
 	int repl = 0;
 
-	for (slot = 0; slot < conf->copies; slot++) {
+	for (slot = 0; slot < conf->geo.raid_disks; slot++) {
 		if (r10_bio->devs[slot].bio == bio)
 			break;
 		if (r10_bio->devs[slot].repl_bio == bio) {
@@ -336,7 +336,7 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
 		}
 	}
 
-	BUG_ON(slot == conf->copies);
+	BUG_ON(slot == conf->geo.raid_disks);
 	update_head_pos(slot, r10_bio);
 
 	if (slotp)
@@ -1518,7 +1518,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
-	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
+	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->geo.raid_disks);
 
 	if (bio_data_dir(bio) == READ)
 		raid10_read_request(mddev, bio, r10_bio);
-- 
2.7.5

