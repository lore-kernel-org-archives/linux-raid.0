Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5D6C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 00:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25AE4610CC
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 00:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhESAOo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 20:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234333AbhESAOn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 May 2021 20:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18A406100A
        for <linux-raid@vger.kernel.org>; Wed, 19 May 2021 00:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621383205;
        bh=E8euNtL7/Bf5wLOQM0r08YIXWI+SyTpPRD7M5raHIBo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SRF6DawQfkzMJVTzfYtcyrnVVLqmrXzx/8UlOFj7BB2Ug9B9fw+H3BIxt7a4wi6z5
         MxA1kjPGVEx3hGXqrq+8lXXDh8cmNzsnMO4mLhSVaR7ZeUj39jE8nVpyrxKZ1LfXTT
         saM5ApyYyocJA9P5q/4FU0GFzJxnwy3mZO/Q/bw95N/CHdFBQlZbQWtC6KozIJn7yz
         shjGouBWyj4Cl6jlelPH/0kcs/7TucIzqGKq6PPdRVWmmuQT7ZDTBQ6JIOU/fqIy9k
         nqw+aeYN8VWoJ25ttQThrFXBul3Qmv5emJql8u2zgQH0zH6JuhTnPVtfw8oesx6Jxs
         8gsWYLgsbDrBg==
Received: by mail-lj1-f173.google.com with SMTP id o8so13533943ljp.0
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 17:13:24 -0700 (PDT)
X-Gm-Message-State: AOAM530jJUnXIzxI5TMg0PvIliB0/N7eu7gezm3C7ny7i0mAQj95j6Jp
        wrmjGJxu4mviJeyyNchk3o9wlU70MD7JFCt6xjU=
X-Google-Smtp-Source: ABdhPJx1pUbbjQpFT1r+T6BWneK+PuY9vVZvmxJzheJruTIIZNIWMQpgxdUnLEmTQXc+xHUoywXsNTqBj0vJZ1/OtKA=
X-Received: by 2002:a2e:7119:: with SMTP id m25mr5876633ljc.177.1621383203370;
 Tue, 18 May 2021 17:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <F368C0E3-1315-42B8-8328-441D2F7ABAC3@dazinger.net>
In-Reply-To: <F368C0E3-1315-42B8-8328-441D2F7ABAC3@dazinger.net>
From:   Song Liu <song@kernel.org>
Date:   Tue, 18 May 2021 17:13:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6rBJFmrT8vZJ4fyoSvY3Z16_Hy8oo67=jkHra64AfmbQ@mail.gmail.com>
Message-ID: <CAPhsuW6rBJFmrT8vZJ4fyoSvY3Z16_Hy8oo67=jkHra64AfmbQ@mail.gmail.com>
Subject: Re: Linux-5.12 regression
To:     "Florian D." <spam02@dazinger.net>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, May 16, 2021 at 9:36 AM Florian D. <spam02@dazinger.net> wrote:
>
> Hi,
> I get the following kernel error during boot, since kernel 5.12, kernel 5=
.11 boots fine.
> The Raid system seems to work fine, but I don't want to risk anything, so=
 I'm on 5.11. now. My /proc/mdstat:
> florian@stimpy ~ $ cat /proc/mdstat                                      =
       Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : inactive sdb2[4](S)
>       1949216768 blocks super 1.2
>
> md127 : active raid6 sdf2[3] sdc2[1] sdd2[2] sdb4[0] sda7[4](J)
>       13672624128 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4]=
 [UUUU]
> unused devices: <none>
>
> (sdb2 was part of a RAID 5 (md0) array, which I want to keep as backup, t=
he other disks of the old RAID 5 are outside of the computer)
>
> (Please cc me, as I'm not subscribed)
> Thanks, Florian
>
> uname -a:
> Linux stimpy 5.11.21 #20 SMP Sat May 15 17:31:58 CEST 2021 x86_64 AMD Ath=
lon(tm) II X2 250e Processor AuthenticAMD GNU/Linux
>
>
> [    8.229026] ------------[ cut here ]------------
> [    8.229029] WARNING: CPU: 1 PID: 765 at drivers/md/raid5.c:5313 raid5_=
make_request+0x19b/0x9dd
> [    8.229038] Modules linked in: i2c_piix4
> [    8.229042] CPU: 1 PID: 765 Comm: udevd Tainted: G                T 5.=
12.4 #4[    8.229045] Hardware name: System manufacturer System Product Nam=
e/M4A78LT-M-LE, BIOS 0803    07/23/2012
> [    8.229047] RIP: 0010:raid5_make_request+0x19b/0x9dd
> [    8.229051] Code: 00 00 8b 55 28 f3 ab c7 44 24 40 00 00 00 00 c7 44 2=
4 44 00 00 00 00 c1 ea 09 4d 8b 26 48 8b 45 08 48 8b 75 20 80 38 00 74 02 <=
0f> 0b 41 8b 44 24 64 41 39 44 24 30 41 0f 4e 44 24 30 89 c1 ff c8
> [    8.229054] RSP: 0018:ffffb65bc0c1b8e8 EFLAGS: 00010202
> [    8.229057] RAX: ffff998640429f40 RBX: ffff99864282b800 RCX: 000000000=
0000000[    8.229059] RDX: 0000000000000008 RSI: 000000032ee83f80 RDI: ffff=
b65bc0c1b980[    8.229061] RBP: ffff998651b0fe40 R08: 0000000000000000 R09:=
 ffff998640429f40[    8.229062] R10: 0000000000000011 R11: 00000000ffff8dfd=
 R12: ffff99864282b800[    8.229064] R13: ffff998641f03600 R14: ffff998641f=
fd000 R15: ffff998641a0df00[    8.229066] FS:  00007fe37a9f0740(0000) GS:ff=
ff99865c080000(0000) knlGS:0000000000000000
> [    8.229068] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    8.229081] CR2: 000056274104ffa8 CR3: 000000010284c000 CR4: 000000000=
00006e0[    8.229083] Call Trace:
> [    8.229087]  ? __list_del_entry+0x1d/0x1d
> [    8.229091]  ? __kmalloc+0x148/0x157
> [    8.229094]  ? mempool_alloc+0x68/0x14f
> [    8.229098]  md_handle_request+0xc4/0x12e
> [    8.229102]  md_submit_bio+0xd1/0xd8
> [    8.229105]  submit_bio_noacct+0x175/0x273
> [    8.229110]  submit_bio+0x135/0x151
> [    8.229112]  ? xas_start+0x43/0x7b
> [    8.229115]  mpage_bio_submit+0x21/0x25
> [    8.229119]  mpage_readahead+0xca/0xec
> [    8.229123]  ? bd_clear_claiming.part.0+0x2/0x2
> [    8.229126]  read_pages+0x5a/0x121
> [    8.229130]  page_cache_ra_unbounded+0xd1/0x1be
> [    8.229132]  force_page_cache_ra+0x81/0x8c
> [    8.229135]  filemap_read+0x158/0x560
> [    8.229139]  new_sync_read+0x97/0xca
> [    8.229143]  vfs_read+0xc8/0x10a
> [    8.229146]  ksys_read+0x80/0xcc
> [    8.229150]  do_syscall_64+0x33/0x40
> [    8.229154]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [    8.229159] RIP: 0033:0x7fe37ab46c2e
> [    8.229161] Code: f7 01 00 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 8=
4 00 00 00 00 00 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 85 c0 75 0c 0f 05 <=
48> 3d 00 f0 ff ff 77 52 f3 c3 48 83 ec 28 48 89 54 24 18 48 89 74
> [    8.229163] RSP: 002b:00007ffc93756018 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000000
> [    8.229166] RAX: ffffffffffffffda RBX: 0000562741034b38 RCX: 00007fe37=
ab46c2e[    8.229168] RDX: 0000000000000040 RSI: 0000562741034b48 RDI: 0000=
000000000008[    8.229169] RBP: 0000562741033ab0 R08: 0000562741034b20 R09:=
 000056274101e010[    8.229171] R10: 00007fe37ac15a00 R11: 0000000000000246=
 R12: 000001d1a93f0000[    8.229173] R13: 0000000000000040 R14: 00005627410=
34b20 R15: 0000562741033b00[    8.229175] ---[ end trace 84ee63e21dbae54e ]=
---

Thanks for the report. This is a WARN_ON_ONCE() we should have removed.
It is harmless. I will remove it.

Best,
Song
