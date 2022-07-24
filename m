Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C17DC43334
	for <linux-raid@archiver.kernel.org>; Sun, 24 Jul 2022 18:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiGXSbl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 24 Jul 2022 14:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGXSbl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 24 Jul 2022 14:31:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25ED7DF72
        for <linux-raid@vger.kernel.org>; Sun, 24 Jul 2022 11:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658687497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=+jXaexju4HaYMza343tPSNSwxqPdEIZsFnl1qxJUYFg=;
        b=Q8pOo005ZnJXnDBjdEYf9kdfkMf0bcTlFyck3vDf9AuHzsMagLfnpnhJvzxT7ICMQOR3j0
        EBAKef8ONWrFIABRbYVH+my4Zqt4hWA333UJ45PCz99VcSsen4gSiIEm8ZKK5U7/ZqzG+A
        dY4sUD/mZwm/BuHTJrettYItOh4IJYE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-ZTDew1_bMDOo7epGGI80Hw-1; Sun, 24 Jul 2022 14:31:36 -0400
X-MC-Unique: ZTDew1_bMDOo7epGGI80Hw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAC6B101A54E;
        Sun, 24 Jul 2022 18:31:35 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E1C83492C3B;
        Sun, 24 Jul 2022 18:31:35 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 26OIVZ99026590;
        Sun, 24 Jul 2022 14:31:35 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 26OIVZHY026586;
        Sun, 24 Jul 2022 14:31:35 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sun, 24 Jul 2022 14:31:35 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>
cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
Subject: [PATCH] dm-raid: fix address sanitizer warning in raid_status
Message-ID: <alpine.LRH.2.02.2207241429580.26078@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There is this warning when using a kernel with the address sanitizer and
running this testsuite:
https://gitlab.com/cki-project/kernel-tests/-/tree/main/storage/swraid/scsi_raid

==================================================================
BUG: KASAN: slab-out-of-bounds in raid_status+0x1747/0x2820 [dm_raid]
Read of size 4 at addr ffff888079d2c7e8 by task lvcreate/13319
CPU: 0 PID: 13319 Comm: lvcreate Not tainted 5.18.0-0.rc3.20220421gitb253435746d9a4a.30.eln117.x86_64 #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Call Trace:
 <TASK>
 dump_stack_lvl+0x6a/0x9c
 print_address_description.constprop.0+0x1f/0x1e0
 print_report.cold+0x55/0x244
 kasan_report+0xc9/0x100
 raid_status+0x1747/0x2820 [dm_raid]
 dm_ima_measure_on_table_load+0x4b8/0xca0 [dm_mod]
 table_load+0x35c/0x630 [dm_mod]
 ctl_ioctl+0x411/0x630 [dm_mod]
 dm_ctl_ioctl+0xa/0x10 [dm_mod]
 __x64_sys_ioctl+0x12a/0x1a0
 do_syscall_64+0x5b/0x80

The warning is caused by reading conf->max_nr_stripes in raid_status. The
code in raid_status reads mddev->private, casts it to struct r5conf and
reads the entry max_nr_stripes.

However, if we have different raid type than 4/5/6, mddev->private doesn't
point to struct r5conf; it may point to struct r0conf, struct r1conf,
struct r10conf or struct mpconf. If we cast a pointer to one of these
structs to struct r5conf, we will be reading invalid memory and KASAN
warns about it.

This patch fixes the bug by reading struct r5conf only if raid type is 4,
5 or 6.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c	2022-07-13 15:40:05.000000000 +0200
+++ linux-2.6/drivers/md/dm-raid.c	2022-07-22 21:33:54.000000000 +0200
@@ -3509,7 +3509,7 @@ static void raid_status(struct dm_target
 {
 	struct raid_set *rs = ti->private;
 	struct mddev *mddev = &rs->md;
-	struct r5conf *conf = mddev->private;
+	struct r5conf *conf = rs_is_raid456(rs) ? mddev->private : NULL;
 	int i, max_nr_stripes = conf ? conf->max_nr_stripes : 0;
 	unsigned long recovery;
 	unsigned int raid_param_cnt = 1; /* at least 1 for chunksize */

