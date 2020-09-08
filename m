Return-Path: <SRS0=DmcQ=CR=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF66C43461
	for <linux-raid@archiver.kernel.org>; Tue,  8 Sep 2020 01:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E28F2193E
	for <linux-raid@archiver.kernel.org>; Tue,  8 Sep 2020 01:24:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SkP9/0jh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgIHBYO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Sep 2020 21:24:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48618 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728241AbgIHBYN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Sep 2020 21:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599528252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nWSUZiWb3snOVulMSALV4he0iSrVT0Kl82xmy7nsew=;
        b=SkP9/0jhouPmrn9oqFaANaZe3wosUGTb+PvdfybzuZ6+g56cKxKOuMN/3rTJbdHOVqsESZ
        4eDE/H8xKw1bZXiQQx/P1ywYc2HTSomJFgyk7gqBqYy1/pevUxRa2PkKzX07D8WUhG/m3R
        2mAElno5NVwardoaCO4PO3Jp8e+suMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-xTneOeobNXysyZTQvrqhrQ-1; Mon, 07 Sep 2020 21:24:10 -0400
X-MC-Unique: xTneOeobNXysyZTQvrqhrQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5197B807335;
        Tue,  8 Sep 2020 01:24:08 +0000 (UTC)
Received: from localhost (ovpn-12-217.pek2.redhat.com [10.72.12.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 886D860C0F;
        Tue,  8 Sep 2020 01:24:04 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Sagi Grimberg <sagi@grimberg.me>, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH V3 1/3] percpu_ref: add percpu_ref_inited() for MD
Date:   Tue,  8 Sep 2020 09:23:49 +0800
Message-Id: <20200908012351.1092986-2-ming.lei@redhat.com>
In-Reply-To: <20200908012351.1092986-1-ming.lei@redhat.com>
References: <20200908012351.1092986-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

MD code uses perpcu-refcount internal to check if this percpu-refcount
variable is initialized, this way is a hack.

Add percpu_ref_inited() for MD so that the hack can be avoided.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Veronika Kabatova <vkabatov@redhat.com>
Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/md.c                 | 2 +-
 include/linux/percpu-refcount.h | 1 +
 lib/percpu-refcount.c           | 6 ++++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9562ef598ae1..a7c2429949fb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5632,7 +5632,7 @@ static void no_op(struct percpu_ref *r) {}
 
 int mddev_init_writes_pending(struct mddev *mddev)
 {
-	if (mddev->writes_pending.percpu_count_ptr)
+	if (percpu_ref_inited(&mddev->writes_pending))
 		return 0;
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL) < 0)
diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 87d8a38bdea1..aed01562387b 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -109,6 +109,7 @@ struct percpu_ref {
 int __must_check percpu_ref_init(struct percpu_ref *ref,
 				 percpu_ref_func_t *release, unsigned int flags,
 				 gfp_t gfp);
+bool percpu_ref_inited(struct percpu_ref *ref);
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_switch);
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 0ba686b8fe57..9e7c4ab5b7bb 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -93,6 +93,12 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 }
 EXPORT_SYMBOL_GPL(percpu_ref_init);
 
+bool percpu_ref_inited(struct percpu_ref *ref)
+{
+	return percpu_count_ptr(ref) != NULL;
+}
+EXPORT_SYMBOL_GPL(percpu_ref_inited);
+
 /**
  * percpu_ref_exit - undo percpu_ref_init()
  * @ref: percpu_ref to exit
-- 
2.25.2

