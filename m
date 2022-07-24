Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF366C43334
	for <linux-raid@archiver.kernel.org>; Sun, 24 Jul 2022 18:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGXS0S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 24 Jul 2022 14:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGXS0R (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 24 Jul 2022 14:26:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B05510557
        for <linux-raid@vger.kernel.org>; Sun, 24 Jul 2022 11:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658687174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7qCDug+6K8+kR4m+3zA40Uya7xM55ugxMdeOoFBiS0Y=;
        b=MWrIFiLVN79dI3Fjgzqx36FgUuXHZ1e/e0tHgJapayF0VvRXvK/IYAK+lCjiPLeyuF6BGj
        83uG2MaLXeHH6naApxieYq7RBHY+tKQoAzmVPe2L5BBxmGjk5OCd2RpyD7JoS43VZ7PMVj
        vlDY6OQFnNPMPZL0N7k4YqIPFEGTz7c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-tjVX6b3RPzehOxi0qjXiJQ-1; Sun, 24 Jul 2022 14:26:12 -0400
X-MC-Unique: tjVX6b3RPzehOxi0qjXiJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9309C185A79C;
        Sun, 24 Jul 2022 18:26:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 815E82026D64;
        Sun, 24 Jul 2022 18:26:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 26OIQC75026204;
        Sun, 24 Jul 2022 14:26:12 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 26OIQCm9026200;
        Sun, 24 Jul 2022 14:26:12 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sun, 24 Jul 2022 14:26:12 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
cc:     Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@fb.com>,
        dm-devel@redhat.com
Subject: [PATCH] md-raid: destroy the bitmap after destroying the thread
Message-ID: <alpine.LRH.2.02.2207130714180.12929@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When we ran the lvm test "shell/integrity-blocksize-3.sh" on a kernel with 
kasan, we got failure in write_page.

The reason for the failure is that md_bitmap_destroy is called before
destroying the thread and the thread may be waiting in the function
write_page for the bio to complete. When the thread finishes waiting, it
executes "if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))", which
triggers the kasan warning.

Note that the commit 48df498daf62 that caused this bug claims that it is 
neede for md-cluster, you should check md-cluster and possibly find 
another bugfix for it.

BUG: KASAN: use-after-free in write_page+0x18d/0x680 [md_mod]
Read of size 8 at addr ffff889162030c78 by task mdX_raid1/5539

CPU: 10 PID: 5539 Comm: mdX_raid1 Not tainted 5.19.0-rc2 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x45/0x57a
 ? __lock_text_start+0x18/0x18
 ? write_page+0x18d/0x680 [md_mod]
 kasan_report+0xa8/0xe0
 ? write_page+0x18d/0x680 [md_mod]
 kasan_check_range+0x13f/0x180
 write_page+0x18d/0x680 [md_mod]
 ? super_sync+0x4d5/0x560 [dm_raid]
 ? md_bitmap_file_kick+0xa0/0xa0 [md_mod]
 ? rs_set_dev_and_array_sectors+0x2e0/0x2e0 [dm_raid]
 ? mutex_trylock+0x120/0x120
 ? preempt_count_add+0x6b/0xc0
 ? preempt_count_sub+0xf/0xc0
 md_update_sb+0x707/0xe40 [md_mod]
 md_reap_sync_thread+0x1b2/0x4a0 [md_mod]
 md_check_recovery+0x533/0x960 [md_mod]
 raid1d+0xc8/0x2a20 [raid1]
 ? var_wake_function+0xe0/0xe0
 ? psi_group_change+0x411/0x500
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? raid1_end_read_request+0x2a0/0x2a0 [raid1]
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_unlock_irqrestore+0x19/0x40
 ? del_timer_sync+0xa9/0x100
 ? try_to_del_timer_sync+0xc0/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? __list_del_entry_valid+0x68/0xa0
 ? finish_wait+0xa3/0x100
 md_thread+0x161/0x260 [md_mod]
 ? unregister_md_personality+0xa0/0xa0 [md_mod]
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? prepare_to_wait_event+0x2c0/0x2c0
 ? unregister_md_personality+0xa0/0xa0 [md_mod]
 kthread+0x148/0x180
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 5522:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0x80/0xa0
 md_bitmap_create+0xa8/0xe80 [md_mod]
 md_run+0x777/0x1300 [md_mod]
 raid_ctr+0x249c/0x4a30 [dm_raid]
 dm_table_add_target+0x2b0/0x620 [dm_mod]
 table_load+0x1c8/0x400 [dm_mod]
 ctl_ioctl+0x29e/0x560 [dm_mod]
 dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
 __do_compat_sys_ioctl+0xfa/0x160
 do_syscall_64+0x90/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 5680:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x40
 kasan_set_free_info+0x20/0x40
 __kasan_slab_free+0xf7/0x140
 kfree+0x80/0x240
 md_bitmap_free+0x1c3/0x280 [md_mod]
 __md_stop+0x21/0x120 [md_mod]
 md_stop+0x9/0x40 [md_mod]
 raid_dtr+0x1b/0x40 [dm_raid]
 dm_table_destroy+0x98/0x1e0 [dm_mod]
 __dm_destroy+0x199/0x360 [dm_mod]
 dev_remove+0x10c/0x160 [dm_mod]
 ctl_ioctl+0x29e/0x560 [dm_mod]
 dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
 __do_compat_sys_ioctl+0xfa/0x160
 do_syscall_64+0x90/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 48df498daf62 ("md: move bitmap_destroy to the beginning of __md_stop")

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c	2022-06-08 15:39:08.000000000 +0200
+++ linux-2.6/drivers/md/md.c	2022-06-24 20:22:34.000000000 +0200
@@ -6244,11 +6244,11 @@ static void mddev_detach(struct mddev *m
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
-	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
 	if (mddev->event_work.func)
 		flush_workqueue(md_misc_wq);
+	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);

