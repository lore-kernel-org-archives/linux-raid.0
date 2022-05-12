Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B8EC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 12 May 2022 09:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351906AbiELJV0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 May 2022 05:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351915AbiELJVY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 May 2022 05:21:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20CA04D9E1
        for <linux-raid@vger.kernel.org>; Thu, 12 May 2022 02:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652347280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QKIxAxxcEm4gKkB+4CE6heAhANc1/RDV14fF50lMB+s=;
        b=S0In2XRNWuBvz1dOdtNBxEHh1FJajpsAwPiBF42N2rE0MRv5gZj9UKH7dVcMKk2J72HMav
        p4tzDM5fgMKsznfMr3XOn4gj5plPcV0KFpO0FXbdCqOtwVHnkWGYp4OV4SG4h7nqelxTy9
        SWVdwDtUWtV2BpF4kwqSrTaFsX7pNPk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-KOUjglYMMSmA7RdMF8MPVg-1; Thu, 12 May 2022 05:21:17 -0400
X-MC-Unique: KOUjglYMMSmA7RdMF8MPVg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8DA2811E7A;
        Thu, 12 May 2022 09:21:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-14-34.pek2.redhat.com [10.72.14.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4293556C141;
        Thu, 12 May 2022 09:21:13 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com, heinzm@redhat.com,
        ffan@redhat.com
Subject: [PATCH V2 1/2] md: Don't set mddev private to NULL in raid0 pers->free
Date:   Thu, 12 May 2022 17:21:08 +0800
Message-Id: <20220512092109.41606-2-xni@redhat.com>
In-Reply-To: <20220512092109.41606-1-xni@redhat.com>
References: <20220512092109.41606-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In normal stop process, it does like this:
   do_md_stop
      |
   __md_stop (pers->free(); mddev->private=NULL)
      |
   md_free (free mddev)
__md_stop sets mddev->private to NULL after pers->free. The raid device
will be stopped and mddev memory is free. But in reshape, it doesn't
free the mddev and mddev will still be used in new raid.

In reshape, it first sets mddev->private to new_pers and then runs
old_pers->free(). Now raid0 sets mddev->private to NULL in raid0_free.
The new raid can't work anymore. It will panic when dereference
mddev->private because of NULL pointer dereference.

It can panic like this:
[63010.814972] kernel BUG at drivers/md/raid10.c:928!
[63010.819778] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[63010.825011] CPU: 3 PID: 44437 Comm: md0_resync Kdump: loaded Not tainted 5.14.0-86.el9.x86_64 #1
[63010.833789] Hardware name: Dell Inc. PowerEdge R6415/07YXFK, BIOS 1.15.0 09/11/2020
[63010.841440] RIP: 0010:raise_barrier+0x161/0x170 [raid10]
[63010.865508] RSP: 0018:ffffc312408bbc10 EFLAGS: 00010246
[63010.870734] RAX: 0000000000000000 RBX: ffffa00bf7d39800 RCX: 0000000000000000
[63010.877866] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffa00bf7d39800
[63010.884999] RBP: 0000000000000000 R08: fffffa4945e74400 R09: 0000000000000000
[63010.892132] R10: ffffa00eed02f798 R11: 0000000000000000 R12: ffffa00bbc435200
[63010.899266] R13: ffffa00bf7d39800 R14: 0000000000000400 R15: 0000000000000003
[63010.906399] FS:  0000000000000000(0000) GS:ffffa00eed000000(0000) knlGS:0000000000000000
[63010.914485] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[63010.920229] CR2: 00007f5cfbe99828 CR3: 0000000105efe000 CR4: 00000000003506e0
[63010.927363] Call Trace:
[63010.929822]  ? bio_reset+0xe/0x40
[63010.933144]  ? raid10_alloc_init_r10buf+0x60/0xa0 [raid10]
[63010.938629]  raid10_sync_request+0x756/0x1610 [raid10]
[63010.943770]  md_do_sync.cold+0x3e4/0x94c
[63010.947698]  md_thread+0xab/0x160
[63010.951024]  ? md_write_inc+0x50/0x50
[63010.954688]  kthread+0x149/0x170
[63010.957923]  ? set_kthread_struct+0x40/0x40
[63010.962107]  ret_from_fork+0x22/0x30

Removing the code that sets mddev->private to NULL in raid0 can fix
problem.

Fixes: 0c031fd37f69 (md: Move alloc/free acct bioset in to personality)
Reported-by: Fine Fan <ffan@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
V1->V2: Add subsystem in subject and add more information about this problem
---
 drivers/md/raid0.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e11701e394ca..5fa0d401eefc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -362,7 +362,6 @@ static void free_conf(struct mddev *mddev, struct r0conf *conf)
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
-	mddev->private = NULL;
 }
 
 static void raid0_free(struct mddev *mddev, void *priv)
-- 
2.32.0 (Apple Git-132)

