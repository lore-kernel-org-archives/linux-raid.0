Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C4AC43334
	for <linux-raid@archiver.kernel.org>; Wed, 15 Jun 2022 15:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbiFOPZ7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Jun 2022 11:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349574AbiFOPZ6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Jun 2022 11:25:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBD23190B
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 08:25:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65ABDB81F0B
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 15:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04333C34115
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655306753;
        bh=ryIBE8OFg+n8PEwHSkCC04O9xBPqSfYi2PINbitXf+E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wp2Dhoc8oLnyic0BgBIY0YdCmtpGdTMOlT4R4YeCV0pOZrVk89Ngqr10nqb6b+fWu
         8ofvzBh5qmn/tjb6IzhsbKZBbGISKr1850y7bnTkqULVrfUjnPPCPpTRqGSl4lwQTL
         1D1s1dL3J58gwTkqj4+xafVsBVazOHQSrizxylsW0CCcDfshKgDxITP7Uhf+EUz5tI
         9mxYniHrKSfyG7nbmT35unwXyNIrXoTOJJaaxOKeoeVPjP4i3zG+KsvFF11WNnBL3Z
         ZPk8DA/Dhnn2BVV+BJPf4VwFO8yH9Hlh5uPBek9EP6QN66jenWHvMWNwjw8HPrXhV8
         FGShvb0s47KAg==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2ef5380669cso64615957b3.9
        for <linux-raid@vger.kernel.org>; Wed, 15 Jun 2022 08:25:52 -0700 (PDT)
X-Gm-Message-State: AJIora+gPM8/TQyaBOh8heSvw1mfXiTUftRXR7dSWWJRIYcKlthBEhjj
        viVCIHxxILj5KKIbjRjKwkA7ku43bgqSw3BRvnM=
X-Google-Smtp-Source: AGRyM1suETWC9lotTRUGQ82PvwwT9Hsy/DDCTbNYOFrisNoYeb3qL8y2Rwk2kRN+OEdZbLpwnARUcMknM+I3l2NlIik=
X-Received: by 2002:a81:5c89:0:b0:314:65f9:c775 with SMTP id
 q131-20020a815c89000000b0031465f9c775mr234707ywb.130.1655306751839; Wed, 15
 Jun 2022 08:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <CABcz2k7F7XVvg_hD7CBs3oANbyZndMYOfso2wNQmNb1MqD6ikA@mail.gmail.com>
 <CAPhsuW4KMP+rdx51od4RTH-UbjDhSJdgqQa=LTz7EzF3uOhc-A@mail.gmail.com> <CABcz2k6hzzmTc-zzAPXe_W6S-hbvBFakd3W0bEBZzK-AYD7Kzw@mail.gmail.com>
In-Reply-To: <CABcz2k6hzzmTc-zzAPXe_W6S-hbvBFakd3W0bEBZzK-AYD7Kzw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 15 Jun 2022 08:25:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7ckiBmxC0bCCbktKq1kcDadWAZHMRF=3v1pKpse5Na1g@mail.gmail.com>
Message-ID: <CAPhsuW7ckiBmxC0bCCbktKq1kcDadWAZHMRF=3v1pKpse5Na1g@mail.gmail.com>
Subject: Re: md0_raid5 Hangs Linux 5.18.3
To:     Curtis Lee Bolin <CurtisLeeBolin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jun 14, 2022 at 11:25 PM Curtis Lee Bolin
<CurtisLeeBolin@gmail.com> wrote:
>
> That small function parameter swap seems to be the issue.  I have had
> no problem since rebuilding the kernel patched with that commit.  I
> have been writing to the array for hours with no issue.

That's great. Thanks for the tests!

Song

>
> Thank You For Your Time,
> -Curtis Lee Bolin
>
> On Tue, Jun 14, 2022 at 10:58 AM Song Liu <song@kernel.org> wrote:
> >
> > On Tue, Jun 14, 2022 at 8:08 AM Curtis Lee Bolin
> > <CurtisLeeBolin@gmail.com> wrote:
> > >
> > > Newly created arrays on 2 servers are hanging soon after I start using
> > > them.  I recreated the arrays on both servers after zeroing the
> > > superblocks, and again they hang when using the array after resync had
> > > completed.  This last time it hung before btrfs was even able to
> > > finish creating the filesystem.  The drives are new.  SMART data shows
> > > no problem with the drives.
> >
> > Thanks for the report.
> >
> > Could you please try whether this commit fixes the issue?
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=2f37ac322c33e314b9af12de5c8183cbcb7df250
> >
> > Thanks,
> > Song
> >
> >
> > >
> > > Linux sv 5.18.3-arch1-1 #1 SMP PREEMPT_DYNAMIC Thu, 09 Jun 2022
> > > 16:14:10 +0000 x86_64 GNU/Linux
> > >
> > > $ sudo mdadm --create --verbose --level=5 --raid-devices=6
> > > --consistency-policy=ppl /dev/md0 /dev/sde1 /dev/sdf1 /dev/sdg1
> > > /dev/sdi1 /dev/sdk1 /dev/sdl1
> > >
> > > $ sudo mdadm --misc --detail /dev/md0
> > > /dev/md0:
> > >            Version : 1.2
> > >      Creation Time : Tue Jun 14 01:13:09 2022
> > >         Raid Level : raid5
> > >         Array Size : 19534417920 (18.19 TiB 20.00 TB)
> > >      Used Dev Size : 3906883584 (3.64 TiB 4.00 TB)
> > >       Raid Devices : 6
> > >      Total Devices : 6
> > >        Persistence : Superblock is persistent
> > >
> > >        Update Time : Tue Jun 14 09:21:17 2022
> > >              State : clean
> > >     Active Devices : 6
> > >    Working Devices : 6
> > >     Failed Devices : 0
> > >      Spare Devices : 0
> > >
> > >             Layout : left-symmetric
> > >         Chunk Size : 512K
> > >
> > > Consistency Policy : ppl
> > >
> > >               Name : sv:0  (local to host sv)
> > >               UUID : b55ceb54:07883743:d17585ac:bbd37b65
> > >             Events : 100
> > >
> > >     Number   Major   Minor   RaidDevice State
> > >        0       8       65        0      active sync   /dev/sde1
> > >        1       8       81        1      active sync   /dev/sdf1
> > >        2       8       97        2      active sync   /dev/sdg1
> > >        3       8      129        3      active sync   /dev/sdi1
> > >        4       8      161        4      active sync   /dev/sdk1
> > >        6       8      177        5      active sync   /dev/sdl1
> > >
> > > $ sudo mkfs.btrfs /dev/md0
> > > btrfs-progs v5.18.1
> > > See http://btrfs.wiki.kernel.org for more information.
> > >
> > > Performing full device TRIM /dev/md0 (18.19TiB) ...
> > > NOTE: several default settings have changed in version 5.15, please make sure
> > >       this does not affect your deployments:
> > >       - DUP for metadata (-m dup)
> > >       - enabled no-holes (-O no-holes)
> > >       - enabled free-space-tree (-R free-space-tree)
> > >
> > > It hung at this point.
> > >
> > > un 14 09:25:35 sv kernel: ------------[ cut here ]------------
> > > Jun 14 09:25:35 sv kernel: WARNING: CPU: 22 PID: 727 at
> > > drivers/scsi/scsi_lib.c:1024 scsi_alloc_sgtables+0x2b8/0x3e0
> > > Jun 14 09:25:35 sv kernel: Modules linked in: xt_nat xt_tcpudp veth
> > > xt_conntrack xt_MASQUERADE nf_conntrack_netlink xt>
> > > Jun 14 09:25:35 sv kernel:  btrfs blake2b_generic libcrc32c
> > > crc32c_generic xor raid6_pq mpt3sas isci raid_class libsas>
> > > Jun 14 09:25:35 sv kernel: CPU: 22 PID: 727 Comm: md0_raid5 Not
> > > tainted 5.18.3-arch1-1 #1 2090c6f1d9d20f39bd14c0acb6fa>
> > > Jun 14 09:25:35 sv kernel: Hardware name: Supermicro
> > > X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.4 11/20/2019
> > > Jun 14 09:25:35 sv kernel: RIP: 0010:scsi_alloc_sgtables+0x2b8/0x3e0
> > > Jun 14 09:25:35 sv kernel: Code: f7 48 8b 80 a8 00 00 00 48 8b 80 c8
> > > 00 00 00 ff d0 0f 1f 00 84 c0 0f 84 b4 fd ff ff 4>
> > > Jun 14 09:25:35 sv kernel: RSP: 0018:ffffa6bc87d7fa10 EFLAGS: 00010246
> > > Jun 14 09:25:35 sv kernel: RAX: 0000000000000000 RBX: ffff8de28cd8f720
> > > RCX: 0000000000000000
> > > Jun 14 09:25:35 sv kernel: RDX: ffff8de28cd8f8e0 RSI: 0000000000000000
> > > RDI: ffff8de28cd8f720
> > > Jun 14 09:25:35 sv kernel: RBP: ffff8dea03aae000 R08: 0000000000000007
> > > R09: 0000000000000000
> > > Jun 14 09:25:35 sv kernel: R10: 0000000000000000 R11: ffff8de28cd8f7e8
> > > R12: 0000000000000000
> > > Jun 14 09:25:35 sv kernel: R13: 0000000000000000 R14: ffff8de28cd8f600
> > > R15: ffff8dea0673d400
> > > Jun 14 09:25:35 sv kernel: FS:  0000000000000000(0000)
> > > GS:ffff8de9dfd80000(0000) knlGS:0000000000000000
> > > Jun 14 09:25:35 sv kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > Jun 14 09:25:35 sv kernel: CR2: 00007f4e94000020 CR3: 0000000db9a10006
> > > CR4: 00000000000606e0
> > > Jun 14 09:25:35 sv kernel: Call Trace:
> > > Jun 14 09:25:35 sv kernel:  <TASK>
> > > Jun 14 09:25:35 sv kernel:  sd_init_command+0x14c/0xaa0
> > > Jun 14 09:25:35 sv kernel:  scsi_queue_rq+0x768/0xba0
> > > Jun 14 09:25:35 sv kernel:  blk_mq_dispatch_rq_list+0x205/0x8c0
> > > Jun 14 09:25:35 sv kernel:  ? sbitmap_get+0x94/0x1b0
> > > Jun 14 09:25:35 sv kernel:  blk_mq_do_dispatch_sched+0x321/0x3b0
> > > Jun 14 09:25:35 sv kernel:  __blk_mq_sched_dispatch_requests+0xee/0x140
> > > Jun 14 09:25:35 sv kernel:  blk_mq_sched_dispatch_requests+0x34/0x60
> > > Jun 14 09:25:35 sv kernel:  __blk_mq_run_hw_queue+0x34/0x90
> > > Jun 14 09:25:35 sv kernel:  __blk_mq_delay_run_hw_queue+0x13b/0x170
> > > Jun 14 09:25:35 sv kernel:  blk_mq_sched_insert_requests+0x6f/0x150
> > > Jun 14 09:25:35 sv kernel:  blk_mq_flush_plug_list+0x120/0x2e0
> > > Jun 14 09:25:35 sv kernel:  __blk_flush_plug+0x106/0x160
> > > Jun 14 09:25:35 sv kernel:  blk_finish_plug+0x26/0x40
> > > Jun 14 09:25:35 sv kernel:  raid5d+0x5c1/0x680 [raid456
> > > 0e5f2411b60f493a1f46983f29bb4c58c62a1560]
> > > Jun 14 09:25:35 sv kernel:  ? schedule+0x4f/0xb0
> > > Jun 14 09:25:35 sv kernel:  ? md_set_read_only+0x90/0x90 [md_mod
> > > bcf96979787e4ea4bd2fa4be3b38a9bf6b5bf539]
> > > Jun 14 09:25:35 sv kernel:  md_thread+0xaa/0x190 [md_mod
> > > bcf96979787e4ea4bd2fa4be3b38a9bf6b5bf539]
> > > Jun 14 09:25:35 sv kernel:  ? cpuacct_percpu_seq_show+0x20/0x20
> > > Jun 14 09:25:35 sv kernel:  kthread+0xdb/0x110
> > > Jun 14 09:25:35 sv kernel:  ? kthread_complete_and_exit+0x20/0x20
> > > Jun 14 09:25:35 sv kernel:  ret_from_fork+0x1f/0x30
> > > Jun 14 09:25:35 sv kernel:  </TASK>
> > > Jun 14 09:25:35 sv kernel: ---[ end trace 0000000000000000 ]---
> > > Jun 14 09:25:35 sv kernel: I/O error, dev sdl, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:35 sv kernel: I/O error, dev sde, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:35 sv kernel: audit: type=1106 audit(1655216735.305:259):
> > > pid=1443 uid=1000 auid=1000 ses=1 msg='op=PAM:s>
> > > Jun 14 09:25:35 sv kernel: audit: type=1104 audit(1655216735.305:260):
> > > pid=1443 uid=1000 auid=1000 ses=1 msg='op=PAM:s>
> > > Jun 14 09:25:39 sv kernel: audit: type=1100 audit(1655216739.728:261):
> > > pid=1447 uid=0 auid=4294967295 ses=4294967295 m>
> > > Jun 14 09:25:43 sv kernel: audit: type=1101 audit(1655216743.248:262):
> > > pid=1449 uid=1000 auid=1000 ses=1 msg='op=PAM:a>
> > > Jun 14 09:25:43 sv kernel: audit: type=1110 audit(1655216743.248:263):
> > > pid=1449 uid=1000 auid=1000 ses=1 msg='op=PAM:s>
> > > Jun 14 09:25:43 sv kernel: audit: type=1105 audit(1655216743.248:264):
> > > pid=1449 uid=1000 auid=1000 ses=1 msg='op=PAM:s>
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sde, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sdl, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sdk, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sdg, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sdk, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sde, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sdl, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sdf, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sdi, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: I/O error, dev sdg, sector 0 op 0x0:(READ)
> > > flags 0xc00 phys_seg 0 prio class 0
> > > Jun 14 09:25:43 sv kernel: ------------[ cut here ]------------
> > > Jun 14 09:25:43 sv kernel: kernel BUG at block/blk-mq.c:942!
> > > Jun 14 09:25:43 sv kernel: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > > Jun 14 09:25:44 sv kernel: CPU: 0 PID: 727 Comm: md0_raid5 Tainted: G
> > >       W         5.18.3-arch1-1 #1 2090c6f1d9d20>
> > > Jun 14 09:25:44 sv kernel: Hardware name: Supermicro
> > > X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.4 11/20/2019
> > > Jun 14 09:25:44 sv kernel: RIP: 0010:blk_mq_end_request+0x130/0x140
> > > Jun 14 09:25:44 sv kernel: Code: 13 4c 89 e6 48 89 df e8 4e 60 00 00
> > > 8b 43 1c e9 61 ff ff ff 48 8b 35 8f 42 72 01 48 8>
> > > Jun 14 09:25:44 sv kernel: RSP: 0018:ffffa6bc87d7fae8 EFLAGS: 00010202
> > > Jun 14 09:25:44 sv kernel: RAX: 0000000000000001 RBX: ffff8de28cfd4800
> > > RCX: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RDX: 0000000000000000 RSI: ffff8de28bcf0180
> > > RDI: ffff8de28cfd4800
> > > Jun 14 09:25:44 sv kernel: RBP: 000000000000000a R08: ffff8de28cb97c60
> > > R09: ffffa6bc87d7fa28
> > > Jun 14 09:25:44 sv kernel: R10: 0000000000000003 R11: ffff8df1fffaf3e8
> > > R12: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: R13: ffff8de28cfd4800 R14: ffffa6bc87d7fbf8
> > > R15: ffff8dea06cbb5c0
> > > Jun 14 09:25:44 sv kernel: FS:  0000000000000000(0000)
> > > GS:ffff8de9dfa00000(0000) knlGS:0000000000000000
> > > Jun 14 09:25:44 sv kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > Jun 14 09:25:44 sv kernel: CR2: 00007f4f342b7ca8 CR3: 0000000db9a10003
> > > CR4: 00000000000606f0
> > > Jun 14 09:25:44 sv kernel: Call Trace:
> > > Jun 14 09:25:44 sv kernel:  <TASK>
> > > Jun 14 09:25:44 sv kernel:  blk_mq_dispatch_rq_list+0x4d2/0x8c0
> > > Jun 14 09:25:44 sv kernel:  ? sbitmap_get+0x94/0x1b0
> > > Jun 14 09:25:44 sv kernel:  blk_mq_do_dispatch_sched+0x321/0x3b0
> > > Jun 14 09:25:44 sv kernel:  __blk_mq_sched_dispatch_requests+0xee/0x140
> > > Jun 14 09:25:44 sv kernel:  blk_mq_sched_dispatch_requests+0x34/0x60
> > > Jun 14 09:25:44 sv kernel:  __blk_mq_run_hw_queue+0x34/0x90
> > > Jun 14 09:25:44 sv kernel:  __blk_mq_delay_run_hw_queue+0x13b/0x170
> > > Jun 14 09:25:44 sv kernel:  blk_mq_sched_insert_requests+0x6f/0x150
> > > Jun 14 09:25:44 sv kernel:  blk_mq_flush_plug_list+0x120/0x2e0
> > > Jun 14 09:25:44 sv kernel:  __blk_flush_plug+0x106/0x160
> > > Jun 14 09:25:44 sv kernel:  blk_finish_plug+0x26/0x40
> > > Jun 14 09:25:44 sv kernel:  raid5d+0x5c1/0x680 [raid456
> > > 0e5f2411b60f493a1f46983f29bb4c58c62a1560]
> > > Jun 14 09:25:44 sv kernel:  ? schedule+0x4f/0xb0
> > > Jun 14 09:25:44 sv kernel:  ? md_set_read_only+0x90/0x90 [md_mod
> > > bcf96979787e4ea4bd2fa4be3b38a9bf6b5bf539]
> > > Jun 14 09:25:44 sv kernel:  md_thread+0xaa/0x190 [md_mod
> > > bcf96979787e4ea4bd2fa4be3b38a9bf6b5bf539]
> > > Jun 14 09:25:44 sv kernel:  ? cpuacct_percpu_seq_show+0x20/0x20
> > > Jun 14 09:25:44 sv kernel:  kthread+0xdb/0x110
> > > Jun 14 09:25:44 sv kernel:  ? kthread_complete_and_exit+0x20/0x20
> > > Jun 14 09:25:44 sv kernel:  ret_from_fork+0x1f/0x30
> > > Jun 14 09:25:44 sv kernel:  </TASK>
> > > Jun 14 09:25:44 sv kernel: Modules linked in: xt_nat xt_tcpudp veth
> > > xt_conntrack xt_MASQUERADE nf_conntrack_netlink xt>
> > > Jun 14 09:25:44 sv kernel:  btrfs blake2b_generic libcrc32c
> > > crc32c_generic xor raid6_pq mpt3sas isci raid_class libsas>
> > > Jun 14 09:25:44 sv kernel: ---[ end trace 0000000000000000 ]---
> > > Jun 14 09:25:44 sv kernel: RIP: 0010:blk_mq_end_request+0x130/0x140
> > > Jun 14 09:25:44 sv kernel: Code: 13 4c 89 e6 48 89 df e8 4e 60 00 00
> > > 8b 43 1c e9 61 ff ff ff 48 8b 35 8f 42 72 01 48 8>
> > > Jun 14 09:25:44 sv kernel: RSP: 0018:ffffa6bc87d7fae8 EFLAGS: 00010202
> > > Jun 14 09:25:44 sv kernel: RAX: 0000000000000001 RBX: ffff8de28cfd4800
> > > RCX: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RDX: 0000000000000000 RSI: ffff8de28bcf0180
> > > RDI: ffff8de28cfd4800
> > > Jun 14 09:25:44 sv kernel: RBP: 000000000000000a R08: ffff8de28cb97c60
> > > R09: ffffa6bc87d7fa28
> > > Jun 14 09:25:44 sv kernel: R10: 0000000000000003 R11: ffff8df1fffaf3e8
> > > R12: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: R13: ffff8de28cfd4800 R14: ffffa6bc87d7fbf8
> > > R15: ffff8dea06cbb5c0
> > > Jun 14 09:25:44 sv kernel: FS:  0000000000000000(0000)
> > > GS:ffff8de9dfa00000(0000) knlGS:0000000000000000
> > > Jun 14 09:25:44 sv kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > Jun 14 09:25:44 sv kernel: CR2: 00007f4f342b7ca8 CR3: 0000000db9a10003
> > > CR4: 00000000000606f0
> > > Jun 14 09:25:44 sv kernel: note: md0_raid5[727] exited with preempt_count 1
> > > Jun 14 09:25:44 sv kernel: ------------[ cut here ]------------
> > > Jun 14 09:25:44 sv kernel: WARNING: CPU: 0 PID: 727 at
> > > kernel/exit.c:741 do_exit+0x8af/0xac0
> > > Jun 14 09:25:44 sv kernel: Modules linked in: xt_nat xt_tcpudp veth
> > > xt_conntrack xt_MASQUERADE nf_conntrack_netlink xt>
> > > Jun 14 09:25:44 sv kernel:  btrfs blake2b_generic libcrc32c
> > > crc32c_generic xor raid6_pq mpt3sas isci raid_class libsas>
> > > Jun 14 09:25:44 sv kernel: CPU: 0 PID: 727 Comm: md0_raid5 Tainted: G
> > >     D W         5.18.3-arch1-1 #1 2090c6f1d9d20>
> > > Jun 14 09:25:44 sv kernel: Hardware name: Supermicro
> > > X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.4 11/20/2019
> > > Jun 14 09:25:44 sv kernel: RIP: 0010:do_exit+0x8af/0xac0
> > > Jun 14 09:25:44 sv kernel: Code: 89 ab 40 06 00 00 4c 89 a3 48 06 00
> > > 00 48 89 6c 24 10 e9 78 fd ff ff 48 8b bb 28 06 0>
> > > Jun 14 09:25:44 sv kernel: RSP: 0018:ffffa6bc87d7fee0 EFLAGS: 00010282
> > > Jun 14 09:25:44 sv kernel: RAX: 0000000000000000 RBX: ffff8dea0dde2040
> > > RCX: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RDX: 0000000000000001 RSI: 0000000000000001
> > > RDI: 000000000000000b
> > > Jun 14 09:25:44 sv kernel: RBP: ffff8dea0dde2040 R08: 0000000000000000
> > > R09: ffffa6bc87d7fd60
> > > Jun 14 09:25:44 sv kernel: R10: 0000000000000003 R11: ffff8df1fffaf3e8
> > > R12: 000000000000000b
> > > Jun 14 09:25:44 sv kernel: R13: 0000000000000004 R14: ffff8dea0dde2040
> > > R15: ffffa6bc87d7fa38
> > > Jun 14 09:25:44 sv kernel: FS:  0000000000000000(0000)
> > > GS:ffff8de9dfa00000(0000) knlGS:0000000000000000
> > > Jun 14 09:25:44 sv kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > Jun 14 09:25:44 sv kernel: CR2: 00007f4f342b7ca8 CR3: 0000000db9a10003
> > > CR4: 00000000000606f0
> > > Jun 14 09:25:44 sv kernel: Call Trace:
> > > Jun 14 09:25:44 sv kernel:  <TASK>
> > > Jun 14 09:25:44 sv kernel:  make_task_dead+0x55/0x60
> > > Jun 14 09:25:44 sv kernel:  rewind_stack_and_make_dead+0x17/0x17
> > > Jun 14 09:25:44 sv kernel: RIP: 0000:0x0
> > > Jun 14 09:25:44 sv kernel: Code: Unable to access opcode bytes at RIP
> > > 0xffffffffffffffd6.
> > > Jun 14 09:25:44 sv kernel: RSP: 0000:0000000000000000 EFLAGS: 00000000
> > > ORIG_RAX: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RAX: 0000000000000000 RBX: 0000000000000000
> > > RCX: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RDX: 0000000000000000 RSI: 0000000000000000
> > > RDI: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RBP: 0000000000000000 R08: 0000000000000000
> > > R09: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: R10: 0000000000000000 R11: 0000000000000000
> > > R12: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: R13: 0000000000000000 R14: 0000000000000000
> > > R15: 0000000000000000
> > > Jun 14 09:25:44 sv kernel:  </TASK>
> > > Jun 14 09:25:44 sv kernel: ---[ end trace 0000000000000000 ]---
> > >
> > >
> > > Jun 14 09:25:44 sv kernel: ------------[ cut here ]------------
> > > Jun 14 09:25:44 sv kernel: WARNING: CPU: 0 PID: 727 at
> > > kernel/exit.c:741 do_exit+0x8af/0xac0
> > > Jun 14 09:25:44 sv kernel: Modules linked in: xt_nat xt_tcpudp veth
> > > xt_conntrack xt_MASQUERADE nf_conntrack_netlink xt>
> > > Jun 14 09:25:44 sv kernel:  btrfs blake2b_generic libcrc32c
> > > crc32c_generic xor raid6_pq mpt3sas isci raid_class libsas>
> > > Jun 14 09:25:44 sv kernel: CPU: 0 PID: 727 Comm: md0_raid5 Tainted: G
> > >     D W         5.18.3-arch1-1 #1 2090c6f1d9d20>
> > > Jun 14 09:25:44 sv kernel: Hardware name: Supermicro
> > > X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 3.4 11/20/2019
> > > Jun 14 09:25:44 sv kernel: RIP: 0010:do_exit+0x8af/0xac0
> > > Jun 14 09:25:44 sv kernel: Code: 89 ab 40 06 00 00 4c 89 a3 48 06 00
> > > 00 48 89 6c 24 10 e9 78 fd ff ff 48 8b bb 28 06 0>
> > > Jun 14 09:25:44 sv kernel: RSP: 0018:ffffa6bc87d7fee0 EFLAGS: 00010282
> > > Jun 14 09:25:44 sv kernel: RAX: 0000000000000000 RBX: ffff8dea0dde2040
> > > RCX: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RDX: 0000000000000001 RSI: 0000000000000001
> > > RDI: 000000000000000b
> > > Jun 14 09:25:44 sv kernel: RBP: ffff8dea0dde2040 R08: 0000000000000000
> > > R09: ffffa6bc87d7fd60
> > > Jun 14 09:25:44 sv kernel: R10: 0000000000000003 R11: ffff8df1fffaf3e8
> > > R12: 000000000000000b
> > > Jun 14 09:25:44 sv kernel: R13: 0000000000000004 R14: ffff8dea0dde2040
> > > R15: ffffa6bc87d7fa38
> > > Jun 14 09:25:44 sv kernel: FS:  0000000000000000(0000)
> > > GS:ffff8de9dfa00000(0000) knlGS:0000000000000000
> > > Jun 14 09:25:44 sv kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > Jun 14 09:25:44 sv kernel: CR2: 00007f4f342b7ca8 CR3: 0000000db9a10003
> > > CR4: 00000000000606f0
> > > Jun 14 09:25:44 sv kernel: Call Trace:
> > > Jun 14 09:25:44 sv kernel:  <TASK>
> > > Jun 14 09:25:44 sv kernel:  make_task_dead+0x55/0x60
> > > Jun 14 09:25:44 sv kernel:  rewind_stack_and_make_dead+0x17/0x17
> > > Jun 14 09:25:44 sv kernel: RIP: 0000:0x0
> > > Jun 14 09:25:44 sv kernel: Code: Unable to access opcode bytes at RIP
> > > 0xffffffffffffffd6.
> > > Jun 14 09:25:44 sv kernel: RSP: 0000:0000000000000000 EFLAGS: 00000000
> > > ORIG_RAX: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RAX: 0000000000000000 RBX: 0000000000000000
> > > RCX: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RDX: 0000000000000000 RSI: 0000000000000000
> > > RDI: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: RBP: 0000000000000000 R08: 0000000000000000
> > > R09: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: R10: 0000000000000000 R11: 0000000000000000
> > > R12: 0000000000000000
> > > Jun 14 09:25:44 sv kernel: R13: 0000000000000000 R14: 0000000000000000
> > > R15: 0000000000000000
> > > Jun 14 09:25:44 sv kernel:  </TASK>
> > > Jun 14 09:25:44 sv kernel: ---[ end trace 0000000000000000 ]---
> > >
> > >
> > > Thank You For Your Time,
> > > -Curtis Lee Bolin
