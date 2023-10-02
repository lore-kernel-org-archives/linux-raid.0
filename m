Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38129E7490C
	for <linux-raid@archiver.kernel.org>; Mon,  2 Oct 2023 18:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjJBShX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Oct 2023 14:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjJBShV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Oct 2023 14:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E259B
        for <linux-raid@vger.kernel.org>; Mon,  2 Oct 2023 11:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696271794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HbXAkQR9Wr5SD1qFwTNzDFjmMck6x9t/rtKWySttB1g=;
        b=XIzDDpmCV9pobNGHVPo2lNcz7lCFESVCSw6oEMy3IHRCAhvHnq/wF3XH/35NeoS9bxx1aT
        eIBBPkmp3SBbpfdFqEfgpZtrTpttTJJBl4+2rB2/xukYx7+SlGJzvbwm5mrTPnYtF40G00
        NboVqM9LDnTqvGRGAIC1DzJeKltS5ho=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-NWAxsdAwOjy0DssPaUlZrA-1; Mon, 02 Oct 2023 14:36:33 -0400
X-MC-Unique: NWAxsdAwOjy0DssPaUlZrA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C800B101B045;
        Mon,  2 Oct 2023 18:36:31 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.18.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4BC351E3;
        Mon,  2 Oct 2023 18:36:31 +0000 (UTC)
From:   David Jeffery <djeffery@redhat.com>
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc:     David Jeffery <djeffery@redhat.com>
Subject: [PATCH] md/raid5: release batch_last before waiting for another stripe_head
Date:   Mon,  2 Oct 2023 14:32:29 -0400
Message-ID: <20231002183422.13047-1-djeffery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When raid5_get_active_stripe is called with a ctx containing a stripe_head in
its batch_last pointer, it can cause a deadlock if the task sleeps waiting on
another stripe_head to become available. The stripe_head held by batch_last
can be blocking the advancement of other stripe_heads, leading to no
stripe_heads being released so raid5_get_active_stripe waits forever.

Like with the quiesce state handling earlier in the function, batch_last
needs to be released by raid5_get_active_stripe before it waits for another
stripe_head.


Fixes: 3312e6c887fe ("md/raid5: Keep a reference to last stripe_head for batch")
Signed-off-by: David Jeffery <djeffery@redhat.com>

---
 drivers/md/raid5.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6383723468e5..0644b83fd3f4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -854,6 +854,13 @@ struct stripe_head *raid5_get_active_stripe(struct r5conf *conf,
 
 		set_bit(R5_INACTIVE_BLOCKED, &conf->cache_state);
 		r5l_wake_reclaim(conf->log, 0);
+
+		/* release batch_last before wait to avoid risk of deadlock */
+		if (ctx && ctx->batch_last) {
+			raid5_release_stripe(ctx->batch_last);
+			ctx->batch_last = NULL;
+		}
+
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    is_inactive_blocked(conf, hash),
 				    *(conf->hash_locks + hash));
-- 
2.41.0

