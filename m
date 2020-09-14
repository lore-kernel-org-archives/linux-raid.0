Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DE6C433E2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 05:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BDAA214F1
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 05:38:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HnHh+hn4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgINFiW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Sep 2020 01:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726048AbgINFiT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Sep 2020 01:38:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600061914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=9wjHp1jMiYI8TOhmbjxXJIuS85T3wAliI4DXXuRLxEU=;
        b=HnHh+hn4Wlpky3H9A+oiyndXZblkNva3tS/INvuOcv+gSz2O0peOkE48br35pg8x/tL5SM
        HprrI/uuMhwPJfNc5bkGexYxzJcjwMqb/TrnfsNevt1APZxQZ1KgeSZNDHN/F+mRf/oP+M
        BUp6Z/8u+Uk2HqP/MDCd5Afp6mZf/0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-Ut3Siom5Nl29OmOTaIu1fQ-1; Mon, 14 Sep 2020 01:38:31 -0400
X-MC-Unique: Ut3Siom5Nl29OmOTaIu1fQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A3DA1074644;
        Mon, 14 Sep 2020 05:38:30 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2647F5C893;
        Mon, 14 Sep 2020 05:38:26 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, ncroxon@redhat.com
Subject: [mdadm PATCH 2/2] Don't create bitmap for raid5 with journal disk
Date:   Mon, 14 Sep 2020 13:38:15 +0800
Message-Id: <1600061895-16330-3-git-send-email-xni@redhat.com>
In-Reply-To: <1600061895-16330-1-git-send-email-xni@redhat.com>
References: <1600061895-16330-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Journal disk and bitmap can't exist at the same time. It needs to check if the raid
has a journal disk when creating bitmap.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Create.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Create.c b/Create.c
index 6f84e5b..0efa19c 100644
--- a/Create.c
+++ b/Create.c
@@ -542,6 +542,7 @@ int Create(struct supertype *st, char *mddev,
 	if (!s->bitmap_file &&
 	    s->level >= 1 &&
 	    st->ss->add_internal_bitmap &&
+	    s->journaldisks == 0 &&
 	    (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
 	     s->consistency_policy != CONSISTENCY_POLICY_PPL) &&
 	    (s->write_behind || s->size > 100*1024*1024ULL)) {
-- 
2.7.5

