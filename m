Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76385C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  2 Nov 2022 16:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiKBQdI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Nov 2022 12:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiKBQbn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Nov 2022 12:31:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F152D777
        for <linux-raid@vger.kernel.org>; Wed,  2 Nov 2022 09:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667406463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=+X8NvTsJp5OorZQ9td9eE0XJO1fm0tDjulHeQibU3Rs=;
        b=IMNVhP102eeEc4+o9SEMpuRYAhPlRguBJDDgoWmSt4DueWM7Vy3SgV8p+RsRXmHojIX6ih
        9Hyd4o7s99ChnTCGNqp8DGuIuUGB7uViJU2fuHuw+dhhtp59RILEFYUr3hO2aryx0X3Jzu
        tjclf455yeHbvlX4SsujmykEaA5Fd0I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-QilbEzSyPVSeSKRI3OQgQg-1; Wed, 02 Nov 2022 12:27:40 -0400
X-MC-Unique: QilbEzSyPVSeSKRI3OQgQg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4927685A5A6;
        Wed,  2 Nov 2022 16:27:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33650492CA5;
        Wed,  2 Nov 2022 16:27:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 2A2GRev2026132;
        Wed, 2 Nov 2022 12:27:40 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 2A2GRexq026128;
        Wed, 2 Nov 2022 12:27:40 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 2 Nov 2022 12:27:40 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, Song Liu <song@kernel.org>
cc:     Zdenek Kabelac <zkabelac@redhat.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
Subject: A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
Message-ID: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi

There's a crash in the test shell/lvchange-rebuild-raid.sh when running 
the lvm testsuite. It can be reproduced by running "make check_local 
T=shell/lvchange-rebuild-raid.sh" in a loop.

The crash happens in the kernel 6.0 and 6.1-rc3, but not in 5.19.

I bisected the crash and it is caused by the commit 
0dd84b319352bb8ba64752d4e45396d8b13e6018.

I uploaded my .config here (it's 12-core virtual machine): 
https://people.redhat.com/~mpatocka/testcases/md-crash-config/config.txt

Mikulas

[   78.478417] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   78.479166] #PF: supervisor write access in kernel mode
[   78.479671] #PF: error_code(0x0002) - not-present page
[   78.480171] PGD 11557f0067 P4D 11557f0067 PUD 0
[   78.480626] Oops: 0002 [#1] PREEMPT SMP
[   78.481001] CPU: 0 PID: 73 Comm: kworker/0:1 Not tainted 6.1.0-rc3 #5
[   78.481661] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[   78.482471] Workqueue: kdelayd flush_expired_bios [dm_delay]
[   78.483021] RIP: 0010:mempool_free+0x47/0x80
[   78.483455] Code: 48 89 ef 5b 5d ff e0 f3 c3 48 89 f7 e8 32 45 3f 00 48 63 53 08 48 89 c6 3b 53 04 7d 2d 48 8b 43 10 8d 4a 01 48 89 df 89 4b 08 <48> 89 2c d0 e8 b0 45 3f 00 48 8d 7b 30 5b 5d 31 c9 ba 01 00 00 00
[   78.485220] RSP: 0018:ffff88910036bda8 EFLAGS: 00010093
[   78.485719] RAX: 0000000000000000 RBX: ffff8891037b65d8 RCX: 0000000000000001
[   78.486404] RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff8891037b65d8
[   78.487080] RBP: ffff8891447ba240 R08: 0000000000012908 R09: 00000000003d0900
[   78.487764] R10: 0000000000000000 R11: 0000000000173544 R12: ffff889101a14000
[   78.488451] R13: ffff8891562ac300 R14: ffff889102b41440 R15: ffffe8ffffa00d05
[   78.489146] FS:  0000000000000000(0000) GS:ffff88942fa00000(0000) knlGS:0000000000000000
[   78.489913] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   78.490474] CR2: 0000000000000000 CR3: 0000001102e99000 CR4: 00000000000006b0
[   78.491165] Call Trace:
[   78.491429]  <TASK>
[   78.491640]  clone_endio+0xf4/0x1c0 [dm_mod]
[   78.492072]  clone_endio+0xf4/0x1c0 [dm_mod]
[   78.492505]  __submit_bio+0x76/0x120
[   78.492859]  submit_bio_noacct_nocheck+0xb6/0x2a0
[   78.493325]  flush_expired_bios+0x28/0x2f [dm_delay]
[   78.493808]  process_one_work+0x1b4/0x300
[   78.494211]  worker_thread+0x45/0x3e0
[   78.494570]  ? rescuer_thread+0x380/0x380
[   78.494957]  kthread+0xc2/0x100
[   78.495279]  ? kthread_complete_and_exit+0x20/0x20
[   78.495743]  ret_from_fork+0x1f/0x30
[   78.496096]  </TASK>
[   78.496326] Modules linked in: brd dm_delay dm_raid dm_mod af_packet uvesafb cfbfillrect cfbimgblt cn cfbcopyarea fb font fbdev tun autofs4 binfmt_misc configfs ipv6 virtio_rng virtio_balloon rng_core virtio_net pcspkr net_failover failover qemu_fw_cfg button mousedev raid10 raid456 libcrc32c async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod sd_mod t10_pi crc64_rocksoft crc64 virtio_scsi scsi_mod evdev psmouse bsg scsi_common [last unloaded: brd]
[   78.500425] CR2: 0000000000000000
[   78.500752] ---[ end trace 0000000000000000 ]---
[   78.501214] RIP: 0010:mempool_free+0x47/0x80
[   78.501633] Code: 48 89 ef 5b 5d ff e0 f3 c3 48 89 f7 e8 32 45 3f 00 48 63 53 08 48 89 c6 3b 53 04 7d 2d 48 8b 43 10 8d 4a 01 48 89 df 89 4b 08 <48> 89 2c d0 e8 b0 45 3f 00 48 8d 7b 30 5b 5d 31 c9 ba 01 00 00 00
[   78.503420] RSP: 0018:ffff88910036bda8 EFLAGS: 00010093
[   78.503921] RAX: 0000000000000000 RBX: ffff8891037b65d8 RCX: 0000000000000001
[   78.504611] RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff8891037b65d8
[   78.505374] RBP: ffff8891447ba240 R08: 0000000000012908 R09: 00000000003d0900
[   78.506075] R10: 0000000000000000 R11: 0000000000173544 R12: ffff889101a14000
[   78.506766] R13: ffff8891562ac300 R14: ffff889102b41440 R15: ffffe8ffffa00d05
[   78.507481] FS:  0000000000000000(0000) GS:ffff88942fa00000(0000) knlGS:0000000000000000
[   78.508273] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   78.508837] CR2: 0000000000000000 CR3: 0000001102e99000 CR4: 00000000000006b0
[   78.509542] note: kworker/0:1[73] exited with preempt_count 1
[   78.510427] md/raid10:mdX: active with 4 out of 8 devices
[   96.902910] sysrq: Resetting

