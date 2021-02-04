Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D085C433E6
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 500E264F58
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhBDHw3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 02:52:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46493 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234658AbhBDHw2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 02:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612425062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=bWEFGPX4VHmdBXDfqcD2PcfPhNxQ+GeiCKbrlmvV0EY=;
        b=VBrA37k4xnrPcwJue1/pw07wCoi+R0Jrk3BeUE48E7XUqkw/t3n/5YqR9rwmS1vQ4rJyNo
        troLLSYUVLeWDHtaSG/jK3dEEIO8tvJ4g2xsjKGdvlTExTFlNQ1wk0oRdfEX87/1HyKyPV
        oprjST3wY7Y/kpU8vXepGduhPoh7jM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-77PG3UIENCG3RkDHeXv0UA-1; Thu, 04 Feb 2021 02:51:01 -0500
X-MC-Unique: 77PG3UIENCG3RkDHeXv0UA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8ED0427C3;
        Thu,  4 Feb 2021 07:50:59 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A344C5B695;
        Thu,  4 Feb 2021 07:50:56 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
Subject: [PATCH V2 2/5] md/raid10: extend r10bio devs to raid disks
Date:   Thu,  4 Feb 2021 15:50:44 +0800
Message-Id: <1612425047-10953-3-git-send-email-xni@redhat.com>
In-Reply-To: <1612425047-10953-1-git-send-email-xni@redhat.com>
References: <1612425047-10953-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index be8f14a..0a734de 100644
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
@@ -336,7 +336,6 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
 		}
 	}
 
-	BUG_ON(slot == conf->copies);
 	update_head_pos(slot, r10_bio);
 
 	if (slotp)
@@ -1492,7 +1491,8 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
 	r10_bio->read_slot = -1;
-	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
+	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
+			conf->geo.raid_disks);
 
 	if (bio_data_dir(bio) == READ)
 		raid10_read_request(mddev, bio, r10_bio);
-- 
2.7.5

