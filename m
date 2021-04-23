Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B847EC433ED
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 06:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85760613B8
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 06:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbhDWGCT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Apr 2021 02:02:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230131AbhDWGCR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 23 Apr 2021 02:02:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619157700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Vgnuwpo1wBhG21LqhxnBrZaVPr7RO2+1JJSFQMUI7bs=;
        b=VNNvfikwnmmuNCM68tbngbn3ZaZGDOTvDwY4J+d0+o28WdgMB3R7Yvln71CfP/XOtft1sh
        nG9lAY+BquknV9KB2oH5XGdfuPoTjpEyEa9WSOXk2amsaY4XYxG0vyUf7qojOaaPbMjEtx
        I/GWXUKSRUWBMsuMmCn5AU5NjRRHWRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-URdz0w9XN5aBbPF0oOkJZA-1; Fri, 23 Apr 2021 02:01:36 -0400
X-MC-Unique: URdz0w9XN5aBbPF0oOkJZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A2BF87A82A;
        Fri, 23 Apr 2021 06:01:35 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0195369A;
        Fri, 23 Apr 2021 06:01:32 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes.sorensen@gmail.com
Cc:     ncroxon@redhat.com, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 1/1] Fix some building errors
Date:   Fri, 23 Apr 2021 14:01:30 +0800
Message-Id: <1619157690-5443-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There are some building errors if treating warning as errors.
Fix them in this patch.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super-intel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 876e077..08bf2a3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3192,7 +3192,7 @@ static int imsm_create_metadata_checkpoint_update(
 	}
 	(*u)->type = update_general_migration_checkpoint;
 	(*u)->curr_migr_unit = current_migr_unit(super->migr_rec);
-	dprintf("prepared for %llu\n", (*u)->curr_migr_unit);
+	dprintf("prepared for %llu\n", (unsigned long long)(*u)->curr_migr_unit);
 
 	return update_memory_size;
 }
@@ -11127,7 +11127,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 			skipped_disks++;
 			continue;
 		}
-		if (read(dl_disk->fd, buf, unit_len) != unit_len) {
+		if (read(dl_disk->fd, buf, unit_len) != (ssize_t)unit_len) {
 			pr_err("Cannot read copy area block: %s\n",
 			       strerror(errno));
 			skipped_disks++;
@@ -11139,7 +11139,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 			skipped_disks++;
 			continue;
 		}
-		if (write(dl_disk->fd, buf, unit_len) != unit_len) {
+		if (write(dl_disk->fd, buf, unit_len) != (ssize_t)unit_len) {
 			pr_err("Cannot restore block: %s\n",
 			       strerror(errno));
 			skipped_disks++;
-- 
2.7.5

