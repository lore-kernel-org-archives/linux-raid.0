Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEA8C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 01:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D545D61027
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 01:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347629AbhKPB3l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Nov 2021 20:29:41 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:56590 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237761AbhKPB0W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 15 Nov 2021 20:26:22 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 64B3121910;
        Tue, 16 Nov 2021 01:23:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E252113B2D;
        Tue, 16 Nov 2021 01:23:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wyF6JwgIk2EYcAAAMHmgww
        (envelope-from <dave@stgolabs.net>); Tue, 16 Nov 2021 01:23:20 +0000
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH] md/raid5: play nice with PREEMPT_RT
Date:   Mon, 15 Nov 2021 17:23:17 -0800
Message-Id: <20211116012317.69456-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

raid_run_ops() relies on the implicitly disabled preemption for
its percpu ops, although this is really about CPU locality. This
breaks RT semantics as it can take regular (and thus sleeping)
spinlocks, such as stripe_lock.

Add a local_lock such that non-RT does not change and continues
to be just map to preempt_disable/enable, but makes RT happy as
the region will use a per-CPU spinlock and thus be preemptible
and still guarantee CPU locality.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/md/raid5.c | 11 ++++++-----
 drivers/md/raid5.h |  4 +++-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9c1a5877cf9f..1240a5c16af8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2215,10 +2215,9 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	struct r5conf *conf = sh->raid_conf;
 	int level = conf->level;
 	struct raid5_percpu *percpu;
-	unsigned long cpu;
 
-	cpu = get_cpu();
-	percpu = per_cpu_ptr(conf->percpu, cpu);
+	local_lock(&conf->percpu->lock);
+	percpu = this_cpu_ptr(conf->percpu);
 	if (test_bit(STRIPE_OP_BIOFILL, &ops_request)) {
 		ops_run_biofill(sh);
 		overlap_clear++;
@@ -2271,13 +2270,14 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 			BUG();
 	}
 
-	if (overlap_clear && !sh->batch_head)
+	if (overlap_clear && !sh->batch_head) {
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&sh->raid_conf->wait_for_overlap);
 		}
-	put_cpu();
+	}
+	local_unlock(&conf->percpu->lock);
 }
 
 static void free_stripe(struct kmem_cache *sc, struct stripe_head *sh)
@@ -7052,6 +7052,7 @@ static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu
 		return -ENOMEM;
 	}
 
+	local_lock_init(&percpu->lock);
 	return 0;
 }
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 5c05acf20e1f..9e8486a9e445 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -4,6 +4,7 @@
 
 #include <linux/raid/xor.h>
 #include <linux/dmaengine.h>
+#include <linux/local_lock.h>
 
 /*
  *
@@ -640,7 +641,8 @@ struct r5conf {
 					     * lists and performing address
 					     * conversions
 					     */
-		int scribble_obj_size;
+		int             scribble_obj_size;
+		local_lock_t    lock;
 	} __percpu *percpu;
 	int scribble_disks;
 	int scribble_sectors;
-- 
2.26.2

