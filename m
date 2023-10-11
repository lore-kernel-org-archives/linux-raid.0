Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC352CD6E64
	for <linux-raid@archiver.kernel.org>; Wed, 11 Oct 2023 13:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjJKNEi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Oct 2023 09:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbjJKNEh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Oct 2023 09:04:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F6291
        for <linux-raid@vger.kernel.org>; Wed, 11 Oct 2023 06:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697029429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=86/TC+TLx7DhcognvIA9PQHSP3QMFd4CdbX/MJycGvQ=;
        b=Hm3UZzrrDO8xa1t5IRTJ9MwD0ao8qDcfZyjiMmrXxlsH56O3RvQxNZYjQGy9PGLUUb9n6n
        uYtN7cjsQOpWGIrupzuC/hUoqOeLRE0QdGuWJ70SG1CngROQ+ie1yeu7CaLTZQoT1MYqYA
        ubjkthDP+Tc8GGdNJ07M5urCvtfxHB4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-eYCIZEY6NcuIIQCwVuf0WA-1; Wed, 11 Oct 2023 09:03:36 -0400
X-MC-Unique: eYCIZEY6NcuIIQCwVuf0WA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6504C3816C84;
        Wed, 11 Oct 2023 13:03:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.113.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ED4463F67;
        Wed, 11 Oct 2023 13:03:34 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/ddf: Abort when raid disk is smaller in getinfo_super_ddf
Date:   Wed, 11 Oct 2023 21:03:32 +0800
Message-Id: <20231011130332.78933-1-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The metadata is corrupted when the raid_disk<0. So abort directly.
This also can avoid a building error:
super-ddf.c:1988:58: error: array subscript -1 is below array bounds of ‘struct phys_disk_entry[0]’

Suggested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Ackedy-by: Xiao Ni <xni@redhat.com>
---
 super-ddf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 7213284e0a59..7b98333ecd51 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1984,12 +1984,14 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 		info->disk.number = be32_to_cpu(ddf->dlist->disk.refnum);
 		info->disk.raid_disk = find_phys(ddf, ddf->dlist->disk.refnum);
 
+		if (info->disk.raid_disk < 0)
+			return;
+
 		info->data_offset = be64_to_cpu(ddf->phys->
 						  entries[info->disk.raid_disk].
 						  config_size);
 		info->component_size = ddf->dlist->size - info->data_offset;
-		if (info->disk.raid_disk >= 0)
-			pde = ddf->phys->entries + info->disk.raid_disk;
+		pde = ddf->phys->entries + info->disk.raid_disk;
 		if (pde &&
 		    !(be16_to_cpu(pde->state) & DDF_Failed) &&
 		    !(be16_to_cpu(pde->state) & DDF_Missing))
-- 
2.32.0 (Apple Git-132)

