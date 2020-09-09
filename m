Return-Path: <SRS0=aYZJ=CS=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9207FC433E2
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 07:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AAAA2078E
	for <linux-raid@archiver.kernel.org>; Wed,  9 Sep 2020 07:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I+GLPs3H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgIIHSq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Sep 2020 03:18:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgIIHSh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Sep 2020 03:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599635915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VJS6uNtnH+76ao3TKdef2QWMU1NUJtW2PxvMiR/M+bw=;
        b=I+GLPs3HMAUFG1U9xEsD/PTMsbCxWxyYVQbiyaIb9prxjo48gdMZVQeHbWLGKhsRW6ZWok
        EeW37odDu4CCFnA+mnuTkvWbifPUJBHRAEkgP98iuXvFp/aFuXl1ZWHug3OemlHfS6ATTS
        KCiSgL/OqlUWW8ilqH3dzLZI1QMzL9Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-WZCouqQQOl6cyijsYXTenw-1; Wed, 09 Sep 2020 03:18:31 -0400
X-MC-Unique: WZCouqQQOl6cyijsYXTenw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8510C425D9;
        Wed,  9 Sep 2020 07:18:29 +0000 (UTC)
Received: from localhost (ovpn-12-76.pek2.redhat.com [10.72.12.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BF8927CC9;
        Wed,  9 Sep 2020 07:18:23 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Song Liu <song@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Veronika Kabatova <vkabatov@redhat.com>,
        linux-raid@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH V4 1/3] percpu_ref: add percpu_ref_is_initialized for MD
Date:   Wed,  9 Sep 2020 15:18:11 +0800
Message-Id: <20200909071813.1580038-2-ming.lei@redhat.com>
In-Reply-To: <20200909071813.1580038-1-ming.lei@redhat.com>
References: <20200909071813.1580038-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

MD code uses perpcu-refcount internal to check if this percpu-refcount
variable is initialized, this way is a hack.

Add percpu_ref_is_initialized for MD so that the hack can be avoided.

Acked-by: Song Liu <song@kernel.org>
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
index 9562ef598ae1..3c711f2968a9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5632,7 +5632,7 @@ static void no_op(struct percpu_ref *r) {}
 
 int mddev_init_writes_pending(struct mddev *mddev)
 {
-	if (mddev->writes_pending.percpu_count_ptr)
+	if (percpu_ref_is_initialized(&mddev->writes_pending))
 		return 0;
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL) < 0)
diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 87d8a38bdea1..2dfdf870f2d0 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -109,6 +109,7 @@ struct percpu_ref {
 int __must_check percpu_ref_init(struct percpu_ref *ref,
 				 percpu_ref_func_t *release, unsigned int flags,
 				 gfp_t gfp);
+bool percpu_ref_is_initialized(struct percpu_ref *ref);
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_switch);
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 0ba686b8fe57..db2ec682e0f7 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -93,6 +93,12 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 }
 EXPORT_SYMBOL_GPL(percpu_ref_init);
 
+bool percpu_ref_is_initialized(struct percpu_ref *ref)
+{
+	return percpu_count_ptr(ref) != NULL;
+}
+EXPORT_SYMBOL_GPL(percpu_ref_is_initialized);
+
 /**
  * percpu_ref_exit - undo percpu_ref_init()
  * @ref: percpu_ref to exit
-- 
2.25.2

