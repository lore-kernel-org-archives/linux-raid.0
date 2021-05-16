Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71DEC433ED
	for <linux-raid@archiver.kernel.org>; Sun, 16 May 2021 12:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B935F600D3
	for <linux-raid@archiver.kernel.org>; Sun, 16 May 2021 12:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhEPMh7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 16 May 2021 08:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhEPMh6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 16 May 2021 08:37:58 -0400
X-Greylist: delayed 1736 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 May 2021 05:36:44 PDT
Received: from wp118.webpack.hosteurope.de (wp118.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:847d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FBCC061573
        for <linux-raid@vger.kernel.org>; Sun, 16 May 2021 05:36:43 -0700 (PDT)
Received: from [87.247.194.125] (helo=[192.168.1.30]); authenticated
        by wp118.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1liFYe-0004yP-U1; Sun, 16 May 2021 14:07:45 +0200
Date:   Sun, 16 May 2021 14:07:44 +0200
User-Agent: K-9 Mail for Android
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Linux-5.12 regression
To:     linux-raid@vger.kernel.org
From:   "Florian D." <spam02@dazinger.net>
Message-ID: <F368C0E3-1315-42B8-8328-441D2F7ABAC3@dazinger.net>
X-bounce-key: webpack.hosteurope.de;spam02@dazinger.net;1621168604;6bdcc91d;
X-HE-SMSGID: 1liFYe-0004yP-U1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
I get the following kernel error during boot, since kernel 5.12, kernel 5.11 boots fine.
The Raid system seems to work fine, but I don't want to risk anything, so I'm on 5.11. now. My /proc/mdstat:
florian@stimpy ~ $ cat /proc/mdstat                                             Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md0 : inactive sdb2[4](S)
      1949216768 blocks super 1.2
       
md127 : active raid6 sdf2[3] sdc2[1] sdd2[2] sdb4[0] sda7[4](J)
      13672624128 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]      
unused devices: <none>

(sdb2 was part of a RAID 5 (md0) array, which I want to keep as backup, the other disks of the old RAID 5 are outside of the computer)

(Please cc me, as I'm not subscribed)
Thanks, Florian

uname -a:
Linux stimpy 5.11.21 #20 SMP Sat May 15 17:31:58 CEST 2021 x86_64 AMD Athlon(tm) II X2 250e Processor AuthenticAMD GNU/Linux


[    8.229026] ------------[ cut here ]------------
[    8.229029] WARNING: CPU: 1 PID: 765 at drivers/md/raid5.c:5313 raid5_make_request+0x19b/0x9dd
[    8.229038] Modules linked in: i2c_piix4
[    8.229042] CPU: 1 PID: 765 Comm: udevd Tainted: G                T 5.12.4 #4[    8.229045] Hardware name: System manufacturer System Product Name/M4A78LT-M-LE, BIOS 0803    07/23/2012
[    8.229047] RIP: 0010:raid5_make_request+0x19b/0x9dd
[    8.229051] Code: 00 00 8b 55 28 f3 ab c7 44 24 40 00 00 00 00 c7 44 24 44 00 00 00 00 c1 ea 09 4d 8b 26 48 8b 45 08 48 8b 75 20 80 38 00 74 02 <0f> 0b 41 8b 44 24 64 41 39 44 24 30 41 0f 4e 44 24 30 89 c1 ff c8
[    8.229054] RSP: 0018:ffffb65bc0c1b8e8 EFLAGS: 00010202
[    8.229057] RAX: ffff998640429f40 RBX: ffff99864282b800 RCX: 0000000000000000[    8.229059] RDX: 0000000000000008 RSI: 000000032ee83f80 RDI: ffffb65bc0c1b980[    8.229061] RBP: ffff998651b0fe40 R08: 0000000000000000 R09: ffff998640429f40[    8.229062] R10: 0000000000000011 R11: 00000000ffff8dfd R12: ffff99864282b800[    8.229064] R13: ffff998641f03600 R14: ffff998641ffd000 R15: ffff998641a0df00[    8.229066] FS:  00007fe37a9f0740(0000) GS:ffff99865c080000(0000) knlGS:0000000000000000
[    8.229068] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.229081] CR2: 000056274104ffa8 CR3: 000000010284c000 CR4: 00000000000006e0[    8.229083] Call Trace:
[    8.229087]  ? __list_del_entry+0x1d/0x1d
[    8.229091]  ? __kmalloc+0x148/0x157
[    8.229094]  ? mempool_alloc+0x68/0x14f
[    8.229098]  md_handle_request+0xc4/0x12e
[    8.229102]  md_submit_bio+0xd1/0xd8
[    8.229105]  submit_bio_noacct+0x175/0x273
[    8.229110]  submit_bio+0x135/0x151
[    8.229112]  ? xas_start+0x43/0x7b
[    8.229115]  mpage_bio_submit+0x21/0x25
[    8.229119]  mpage_readahead+0xca/0xec
[    8.229123]  ? bd_clear_claiming.part.0+0x2/0x2
[    8.229126]  read_pages+0x5a/0x121
[    8.229130]  page_cache_ra_unbounded+0xd1/0x1be
[    8.229132]  force_page_cache_ra+0x81/0x8c
[    8.229135]  filemap_read+0x158/0x560
[    8.229139]  new_sync_read+0x97/0xca
[    8.229143]  vfs_read+0xc8/0x10a
[    8.229146]  ksys_read+0x80/0xcc
[    8.229150]  do_syscall_64+0x33/0x40
[    8.229154]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[    8.229159] RIP: 0033:0x7fe37ab46c2e
[    8.229161] Code: f7 01 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 85 c0 75 0c 0f 05 <48> 3d 00 f0 ff ff 77 52 f3 c3 48 83 ec 28 48 89 54 24 18 48 89 74
[    8.229163] RSP: 002b:00007ffc93756018 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[    8.229166] RAX: ffffffffffffffda RBX: 0000562741034b38 RCX: 00007fe37ab46c2e[    8.229168] RDX: 0000000000000040 RSI: 0000562741034b48 RDI: 0000000000000008[    8.229169] RBP: 0000562741033ab0 R08: 0000562741034b20 R09: 000056274101e010[    8.229171] R10: 00007fe37ac15a00 R11: 0000000000000246 R12: 000001d1a93f0000[    8.229173] R13: 0000000000000040 R14: 0000562741034b20 R15: 0000562741033b00[    8.229175] ---[ end trace 84ee63e21dbae54e ]---
-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
