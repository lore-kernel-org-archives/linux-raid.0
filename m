Return-Path: <SRS0=2a2u=EE=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6279DC55179
	for <linux-raid@archiver.kernel.org>; Thu, 29 Oct 2020 01:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A2820790
	for <linux-raid@archiver.kernel.org>; Thu, 29 Oct 2020 01:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKppPdoI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgJ1WIq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:08:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728730AbgJ1WHK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 28 Oct 2020 18:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603922828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=53vG2f+Yp/xCo65Ted4x3V7LSvlV/Bm/ByBHBLx0eH8=;
        b=QKppPdoIEQ5/2azhd12GPENAcwQ8E0VEk0zUVYMpTXpjkYgJ4hFJ9A7gQ3//ZlfAPhCpHZ
        jDcd6BV0KPwB5F41td9ckyVDfHZFcK/NevqfADAckXDqO3yO06TcuMPYdF4JpO+9NILTmK
        qSfxa4vxOcpIVKzs0KJWwwGIKcpUUwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-E_bmg_ISOLmsPReGxJ74NA-1; Wed, 28 Oct 2020 02:04:32 -0400
X-MC-Unique: E_bmg_ISOLmsPReGxJ74NA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2954D5F9CB;
        Wed, 28 Oct 2020 06:04:31 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 885565D9EF;
        Wed, 28 Oct 2020 06:04:26 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     heming.zhao@suse.com, ncroxon@redhat.com, heinzm@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/bitmap: locate bitmap calcuate bitmap position wrongly
Date:   Wed, 28 Oct 2020 14:04:24 +0800
Message-Id: <1603865064-27404-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now it only adds bitmap offset based on cluster nodes. It's not right. It needs to
add per node bitmap space to find next node bitmap position.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/super1.c b/super1.c
index 8b0d6ff..b5b379b 100644
--- a/super1.c
+++ b/super1.c
@@ -2582,8 +2582,9 @@ add_internal_bitmap1(struct supertype *st,
 
 static int locate_bitmap1(struct supertype *st, int fd, int node_num)
 {
-	unsigned long long offset;
+	unsigned long long offset, bm_sectors_per_node;
 	struct mdp_superblock_1 *sb;
+	bitmap_super_t *bms;
 	int mustfree = 0;
 	int ret;
 
@@ -2598,8 +2599,13 @@ static int locate_bitmap1(struct supertype *st, int fd, int node_num)
 		ret = 0;
 	else
 		ret = -1;
-	offset = __le64_to_cpu(sb->super_offset);
-	offset += (int32_t) __le32_to_cpu(sb->bitmap_offset) * (node_num + 1);
+
+	offset = __le64_to_cpu(sb->super_offset) + __le32_to_cpu(sb->bitmap_offset);
+	if (node_num) {
+		bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
+		bm_sectors_per_node = calc_bitmap_size(bms, 4096) >> 9;
+		offset += bm_sectors_per_node * node_num;
+	}
 	if (mustfree)
 		free(sb);
 	lseek64(fd, offset<<9, 0);
-- 
2.7.5

