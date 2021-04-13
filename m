Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EB8C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 12:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD06261222
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 12:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbhDMMF6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Apr 2021 08:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237609AbhDMMF5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Apr 2021 08:05:57 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF78C061574
        for <linux-raid@vger.kernel.org>; Tue, 13 Apr 2021 05:05:37 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id d15so4528029qkc.9
        for <linux-raid@vger.kernel.org>; Tue, 13 Apr 2021 05:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rtbhouse.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uq73+J1cuRJftoPhd7TxeE/G5Cy5OemXiLzpLIb8ngY=;
        b=DCE4TVJF5kHtXuxLXCOvW06VcdBFg9vuvvQipqYQcEy3B64iAV8xuob5x3FVAjzMZv
         aoKU4mOw+Wiaq069Hd4Zuq2ycszQV+Zn+frd5BhJjpRewZh0kAhYPBr9EW53fbY2J3Fq
         1+xWr5y7Ws7cXk9jVTLgOuRdNSw7RxwibFufBVTWyUR2hgvyovTzd0cLb4AlbW349vBr
         CWQpGxpicyG98g3c1qRTqeY0WPFwpadT6RbdfjnHfKTNQIE1HoZxkEKnE+fCJNYDjY7N
         tE2823DAHgqgzEzfA00bSqi517FUiMd0Ja0ACF6Ugrr302w0SK3n9qxpsFtyFvZLhP2N
         OCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uq73+J1cuRJftoPhd7TxeE/G5Cy5OemXiLzpLIb8ngY=;
        b=q/O5iLhHgY0ui3UNZxdmnMBTHJb46H/qI0DVQaHPyXkuwvkto+czcfGiEZASoy43zH
         wkv0k7Lkx4nTCdr6S/685K+LcjMg/IHkox2QhjsH4nixII8KzUAsXxNOSHvq1cKgju0H
         89WE2ITsU0afO8NmbWGDmw9vVDy5qqYzgsJpPUKqOUQnw5Fsd4/vAwRMdDPRaKp0gdK5
         TPSr1NnBUUURkIxQcDx85ImFTbWE8ntzFJU20xWeD2c3i7YPDee0seowg6q9LwNb5VXq
         UjyGwyLYQtqUfky3TJPHf6IUYVqKMXi+wyu/2qiJSJnRU/aKrCXxGv+tZ/9zz1bZQ+cs
         yiQQ==
X-Gm-Message-State: AOAM531dN/PJys3PeWnEZsgEGuxo5h/bXoPI1Y7IkZ6vsNHu1iUN+U8V
        EGCO4A+8BEihlPqrh/uGI3xWvuR03VU112hSlNQ9GVKyw/GxMQIa
X-Google-Smtp-Source: ABdhPJwJhyU7XKj/rvvocmV3MBeWF/ozbBGFwIJUJ8nu2g3+eXdNR99Mz1NAKhYpYG+nbx8dA9K87xqU/f5jMqiWuLc=
X-Received: by 2002:a37:89c7:: with SMTP id l190mr34041254qkd.361.1618315536635;
 Tue, 13 Apr 2021 05:05:36 -0700 (PDT)
MIME-Version: 1.0
References: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
 <CAPhsuW7YqvSBDhhOxX4oa8-Z0v5DMxtEeEWz4hs5SiNPxWrVmg@mail.gmail.com>
In-Reply-To: <CAPhsuW7YqvSBDhhOxX4oa8-Z0v5DMxtEeEWz4hs5SiNPxWrVmg@mail.gmail.com>
From:   =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Date:   Tue, 13 Apr 2021 14:05:20 +0200
Message-ID: <CADLTsw1EzpA+sp4kh6u0Z-Uy4v6nxjTQrVE3bot3Apo8hsjF0w@mail.gmail.com>
Subject: Re: PROBLEM: double fault in md_end_io
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Song,

That code does not compile, but I guess that what you meant was
something like this:

diff --git drivers/md/md.c drivers/md/md.c
index 04384452a..cbc97a96b 100644
--- drivers/md/md.c
+++ drivers/md/md.c
@@ -78,6 +78,7 @@ static DEFINE_SPINLOCK(pers_lock);

 static struct kobj_type md_ktype;

+struct kmem_cache *md_io_cache;
 struct md_cluster_operations *md_cluster_ops;
 EXPORT_SYMBOL(md_cluster_ops);
 static struct module *md_cluster_mod;
@@ -5701,8 +5702,8 @@ static int md_alloc(dev_t dev, char *name)
         */
        mddev->hold_active =3D UNTIL_STOP;

-   error =3D mempool_init_kmalloc_pool(&mddev->md_io_pool, BIO_POOL_SIZE,
-                     sizeof(struct md_io));
+   error =3D mempool_init_slab_pool(&mddev->md_io_pool, BIO_POOL_SIZE,
+                     md_io_cache);
    if (error)
        goto abort;

@@ -9542,6 +9543,10 @@ static int __init md_init(void)
 {
    int ret =3D -ENOMEM;

+   md_io_cache =3D KMEM_CACHE(md_io, 0);
+   if (!md_io_cache)
+       goto err_md_io_cache;
+
    md_wq =3D alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
    if (!md_wq)
        goto err_wq;
@@ -9578,6 +9583,8 @@ static int __init md_init(void)
 err_misc_wq:
    destroy_workqueue(md_wq);
 err_wq:
+   kmem_cache_destroy(md_io_cache);
+err_md_io_cache:
    return ret;
 }

@@ -9863,6 +9870,7 @@ static __exit void md_exit(void)
    destroy_workqueue(md_rdev_misc_wq);
    destroy_workqueue(md_misc_wq);
    destroy_workqueue(md_wq);
+   kmem_cache_destroy(md_io_cache);
 }

 subsys_initcall(md_init);

Unfortunately, now it crashes with:

<0>[  625.159576] traps: PANIC: double fault, error_code: 0x0
<4>[  625.159578] double fault: 0000 [#1] SMP NOPTI
<4>[  625.159579] CPU: 32 PID: 0 Comm: swapper/32 Tainted: P
OE     5.11.8-pw-fix1 #1
<4>[  625.159579] Hardware name: empty S8030GM2NE/S8030GM2NE, BIOS
V4.00 03/11/2021
<4>[  625.159580] RIP: 0010:__slab_free+0x26/0x380
<4>[  625.159580] Code: 1f 44 00 00 0f 1f 44 00 00 55 49 89 ca 45 89
c3 48 89 e5 41 57 41 56 49 89 fe 41 55 41 54 49 89 f4 53 48 83 e4 f0
48 83 ec 70 <48> 89 54 24 28 0f 1f 44 00 00 41 8b 46 28 4d 8b 6c 24 20
49 8b 5c
<4>[  625.159581] RSP: 0018:ffffb11c4d028fc0 EFLAGS: 00010086
<4>[  625.159582] RAX: ffff9a38cfc34fd0 RBX: ffff9a1a1360b870 RCX:
ffff9a1a1360b870
<4>[  625.159583] RDX: ffff9a1a1360b870 RSI: ffffe328044d82c0 RDI:
ffff9a39536e5e00
<4>[  625.159583] RBP: ffffb11c4d029060 R08: 0000000000000001 R09:
ffffffff9f850a57
<4>[  625.159583] R10: ffff9a1a1360b870 R11: 0000000000000001 R12:
ffffe328044d82c0
<4>[  625.159584] R13: ffffe328044d82c0 R14: ffff9a39536e5e00 R15:
ffff9a39536e5e00
<4>[  625.159584] FS:  0000000000000000(0000)
GS:ffff9a38cfc00000(0000) knlGS:0000000000000000
<4>[  625.159585] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[  625.159585] CR2: ffffb11c4d028fb8 CR3: 000000407aece000 CR4:
0000000000350ee0
<4>[  625.159585] Call Trace:
<4>[  625.159586]  <IRQ>
<4>[  625.159586]  ? kmem_cache_free+0x3bf/0x410
<4>[  625.159586]  ? mempool_free_slab+0x17/0x20
<4>[  625.159587]  ? mempool_free_slab+0x17/0x20
<4>[  625.159587]  ? mempool_free+0x2f/0x80
<4>[  625.159587]  ? md_end_io+0x4a/0x70
<4>[  625.159587]  ? bio_endio+0xe0/0x120
<4>[  625.159588]  ? bio_chain_endio+0x2d/0x40
<4>[  625.159588]  ? md_end_io+0x5c/0x70
<4>[  625.159588]  ? bio_endio+0xe0/0x120
<4>[  625.159589]  ? bio_chain_endio+0x2d/0x40
<4>[  625.159589]  ? md_end_io+0x5c/0x70
<4>[  625.159589]  ? bio_endio+0xe0/0x120
<4>[  625.159589]  ? bio_chain_endio+0x2d/0x40
<4>[  625.159590]  ? md_end_io+0x5c/0x70
<4>[  625.159590]  ? bio_endio+0xe0/0x120
...
<4>[  625.159663] Lost 344 message(s)!

Some info from a moment "just" (~0.2 s) before the crash:

$ cd /sys/dev/block/9:12 ;  watch -n0.2 'for f in `find . -maxdepth 1
-type f` `ls queue/* |grep -v usec` ; do echo $f `cat $f`; done | tee
-a ~/md'
./uevent MAJOR=3D9 MINOR=3D12 DEVNAME=3Dmd12 DEVTYPE=3Ddisk
./ext_range 256
./range 1
./alignment_offset 0
./dev 9:12
./ro 0
./stat 577 0 10446 84 46128254 0 11584858627 400313072 660 1289080
400313156 0 0 0 0 0 0
./events_poll_msecs -1
./events_async
./size 41986624512
./discard_alignment 0
./capability 50
./hidden 0
./removable 0
./events
./inflight 0 666
queue/add_random 0
queue/chunk_sectors 0
queue/dax 0
queue/discard_granularity 512
queue/discard_max_bytes 2199023255040
queue/discard_max_hw_bytes 2199023255040
queue/discard_zeroes_data 0
queue/fua 1
queue/hw_sector_size 512
queue/io_poll 0
queue/io_poll_delay 0
queue/iostats 0
queue/logical_block_size 512
queue/max_discard_segments 256
queue/max_hw_sectors_kb 128
queue/max_integrity_segments 0
queue/max_sectors_kb 128
queue/max_segments 33
queue/max_segment_size 4294967295
queue/minimum_io_size 524288
queue/nomerges 0
queue/nr_requests 128
queue/nr_zones 0
queue/optimal_io_size 1572864
queue/physical_block_size 512
queue/read_ahead_kb 3072
queue/rotational 0
queue/rq_affinity 0
queue/scheduler none
queue/stable_writes 0
queue/write_cache write back
queue/write_same_max_bytes 0
queue/write_zeroes_max_bytes 0
queue/zone_append_max_bytes 0
queue/zoned none


$ cd /sys/kernel/slab; watch -n0.2 'for f in `ls md_io/* | grep -v
calls`; do echo $f `cat $f`; done | tee -a ~/slab'
md_io/aliases 4
md_io/align 8
md_io/cache_dma 0
md_io/cpu_partial 30
md_io/cpu_slabs 625 N0=3D250 N1=3D84 N2=3D23 N3=3D268
md_io/ctor
md_io/destroy_by_rcu 0
md_io/hwcache_align 0
md_io/min_partial 5
md_io/objects 63852 N0=3D23256 N1=3D12138 N2=3D3264 N3=3D25194
md_io/object_size 40
md_io/objects_partial 0
md_io/objs_per_slab 102
md_io/order 0
md_io/partial 8 N0=3D3 N1=3D3 N3=3D2
md_io/poison 0
md_io/reclaim_account 0
md_io/red_zone 0
md_io/remote_node_defrag_ratio 100
md_io/sanity_checks 0
md_io/shrink
md_io/slabs 634 N0=3D231 N1=3D122 N2=3D32 N3=3D249
md_io/slabs_cpu_partial 559(559) C0=3D21(21) C1=3D16(16) C2=3D12(12)
C3=3D21(21) C4=3D7(7) C5=3D23(23) C6=3D19(19) C7=3D19(19) C8=3D5(5) C9=3D4(=
4)
C10=3D3(3) C12=3D5(5) C13=3D6(6) C14=3D6(6) C18=3D1(1) C19=3D2(2) C24=3D19(=
19)
C25=3D20(20) C26=3D15(15
) C27=3D11(11) C28=3D17(17) C29=3D14(14) C30=3D23(23) C31=3D14(14) C32=3D21=
(21)
C33=3D8(8) C34=3D19(19) C35=3D12(12) C36=3D19(19) C37=3D17(17) C38=3D15(15)
C39=3D7(7) C40=3D3(3) C41=3D3(3) C42=3D1(1) C45=3D3(3) C46=3D5(5) C47=3D1(1=
)
C48=3D1(1) C49=3D1(1)
 C53=3D1(1) C56=3D3(3) C57=3D5(5) C58=3D21(21) C59=3D25(25) C60=3D5(5) C61=
=3D25(25)
C62=3D17(17) C63=3D18(18)
md_io/slab_size 40
md_io/store_user 0
md_io/total_objects 64668 N0=3D23562 N1=3D12444 N2=3D3264 N3=3D25398
md_io/trace 0
md_io/usersize 0
md_io/validate


$ watch -n0.2 'cat /proc/meminfo | paste - - | tee -a ~/meminfo'
MemTotal:       528235648 kB    MemFree:        20002732 kB
MemAvailable:   483890268 kB    Buffers:            7356 kB
Cached:         495416180 kB    SwapCached:            0 kB
Active:         96396800 kB     Inactive:       399891308 kB
Active(anon):      10976 kB     Inactive(anon):   890908 kB
Active(file):   96385824 kB     Inactive(file): 399000400 kB
Unevictable:       78768 kB     Mlocked:           78768 kB
SwapTotal:             0 kB     SwapFree:              0 kB
Dirty:          88422072 kB     Writeback:        948756 kB
AnonPages:        945772 kB     Mapped:            57300 kB
Shmem:             26300 kB     KReclaimable:    7248160 kB
Slab:            7962748 kB     SReclaimable:    7248160 kB
SUnreclaim:       714588 kB     KernelStack:       18288 kB
PageTables:        10796 kB     NFS_Unstable:          0 kB
Bounce:                0 kB     WritebackTmp:          0 kB
CommitLimit:    264117824 kB    Committed_AS:   21816824 kB
VmallocTotal:   34359738367 kB  VmallocUsed:      561588 kB
VmallocChunk:          0 kB     Percpu:            65792 kB
HardwareCorrupted:     0 kB     AnonHugePages:         0 kB
ShmemHugePages:        0 kB     ShmemPmdMapped:        0 kB
FileHugePages:         0 kB     FilePmdMapped:         0 kB
HugePages_Total:       0        HugePages_Free:        0
HugePages_Rsvd:        0        HugePages_Surp:        0
Hugepagesize:       2048 kB     Hugetlb:               0 kB
DirectMap4k:      541000 kB     DirectMap2M:    11907072 kB
DirectMap1G:    525336576 kB


Regards,
Pawe=C5=82 Wiejacha.


On Mon, 12 Apr 2021 at 08:49, Song Liu <song@kernel.org> wrote:
>
> On Fri, Apr 9, 2021 at 2:41 PM Pawe=C5=82 Wiejacha
> <pawel.wiejacha@rtbhouse.com> wrote:
> >
> > Hello,
> >
> > Two of my machines constantly crash with a double fault like this:
> >
> > 1146  <0>[33685.629591] traps: PANIC: double fault, error_code: 0x0
> > 1147  <4>[33685.629593] double fault: 0000 [#1] SMP NOPTI
> > 1148  <4>[33685.629594] CPU: 10 PID: 2118287 Comm: kworker/10:0
> > Tainted: P           OE     5.11.8-051108-generic #202103200636
> > 1149  <4>[33685.629595] Hardware name: ASUSTeK COMPUTER INC. KRPG-U8
> > Series/KRPG-U8 Series, BIOS 4201 09/25/2020
> > 1150  <4>[33685.629595] Workqueue: xfs-conv/md12 xfs_end_io [xfs]
> > 1151  <4>[33685.629596] RIP: 0010:__slab_free+0x23/0x340
> > 1152  <4>[33685.629597] Code: 4c fe ff ff 0f 1f 00 0f 1f 44 00 00 55
> > 48 89 e5 41 57 49 89 cf 41 56 49 89 fe 41 55 41 54 49 89 f4 53 48 83
> > e4 f0 48 83 ec 70 <48> 89 54 24 28 0f 1f 44 00 00 41 8b 46 28 4d 8b 6c
> > 24 20 49 8b 5c
> > 1153  <4>[33685.629598] RSP: 0018:ffffa9bc00848fa0 EFLAGS: 00010086
> > 1154  <4>[33685.629599] RAX: ffff94c04d8b10a0 RBX: ffff94437a34a880
> > RCX: ffff94437a34a880
> > 1155  <4>[33685.629599] RDX: ffff94437a34a880 RSI: ffffcec745e8d280
> > RDI: ffff944300043b00
> > 1156  <4>[33685.629599] RBP: ffffa9bc00849040 R08: 0000000000000001
> > R09: ffffffff82a5d6de
> > 1157  <4>[33685.629600] R10: 0000000000000001 R11: 000000009c109000
> > R12: ffffcec745e8d280
> > 1158  <4>[33685.629600] R13: ffff944300043b00 R14: ffff944300043b00
> > R15: ffff94437a34a880
> > 1159  <4>[33685.629601] FS:  0000000000000000(0000)
> > GS:ffff94c04d880000(0000) knlGS:0000000000000000
> > 1160  <4>[33685.629601] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800500=
33
> > 1161  <4>[33685.629602] CR2: ffffa9bc00848f98 CR3: 000000014d04e000
> > CR4: 0000000000350ee0
> > 1162  <4>[33685.629602] Call Trace:
> > 1163  <4>[33685.629603]  <IRQ>
> > 1164  <4>[33685.629603]  ? kfree+0x3bc/0x3e0
> > 1165  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
> > 1166  <4>[33685.629603]  ? mempool_kfree+0xe/0x10
> > 1167  <4>[33685.629604]  ? mempool_free+0x2f/0x80
> > 1168  <4>[33685.629604]  ? md_end_io+0x4a/0x70
> > 1169  <4>[33685.629604]  ? bio_endio+0xdc/0x130
> > 1170  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
> > 1171  <4>[33685.629605]  ? md_end_io+0x5c/0x70
> > 1172  <4>[33685.629605]  ? bio_endio+0xdc/0x130
> > 1173  <4>[33685.629605]  ? bio_chain_endio+0x2d/0x40
> > 1174  <4>[33685.629606]  ? md_end_io+0x5c/0x70
> > 1175  <4>[33685.629606]  ? bio_endio+0xdc/0x130
> > 1176  <4>[33685.629606]  ? bio_chain_endio+0x2d/0x40
> > 1177  <4>[33685.629607]  ? md_end_io+0x5c/0x70
> > ... repeated ...
> > 1436  <4>[33685.629677]  ? bio_endio+0xdc/0x130
> > 1437  <4>[33685.629677]  ? bio_chain_endio+0x2d/0x40
> > 1438  <4>[33685.629677]  ? md_end_io+0x5c/0x70
> > 1439  <4>[33685.629677]  ? bio_endio+0xdc/0x130
> > 1440  <4>[33685.629678]  ? bio_chain_endio+0x2d/0x40
> > 1441  <4>[33685.629678]  ? md_
> > 1442  <4>[33685.629679] Lost 357 message(s)!
> >
> > This happens on:
> > 5.11.8-051108-generic #202103200636 SMP Sat Mar 20 11:17:32 UTC 2021
> > and on 5.8.0-44-generic #50~20.04.1-Ubuntu
> > (https://changelogs.ubuntu.com/changelogs/pool/main/l/linux/linux_5.8.0=
-44.50/changelog)
> > which contains backported
> > https://github.com/torvalds/linux/commit/41d2d848e5c09209bdb57ff9c0ca34=
075e22783d
> > ("md: improve io stats accounting").
> > The 5.8.18-050818-generic #202011011237 SMP Sun Nov 1 12:40:15 UTC
> > 2020 which does not contain above suspected change does not crash.
> >
> > If there's a better way/place to report this bug just let me know. If
> > not, here are steps to reproduce:
> >
> > 1. Create a RAID 0 device using three Micron_9300_MTFDHAL7T6TDP disks.
> > mdadm --create --verbose /dev/md12 --level=3Dstripe --raid-devices=3D3
> > /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1
> >
> > 2. Setup xfs on it:
> > mkfs.xfs /dev/md12 and mount it
> >
> > 3. Write to a file on this filesystem:
> > while true; do rm -rf /mnt/md12/crash* ; for i in `seq 8`; do dd
> > if=3D/dev/zero of=3D/mnt/md12/crash$i bs=3D32K count=3D50000000 & done;=
 wait;
> > done
> > Wait for a crash (usually less than 20 min).
> >
> > I couldn't reproduce it with a single dd process (maybe I have to wait
> > a little longer), but a single cat
> > /very/large/file/on/cephfs/over100GbE > /mnt/md12/crash is enough for
> > this double fault to occur.
> >
> > More info:
> > This long mempool_kfree - md_end_io - *  -md_end_io stack trace looks
> > always the same, but the panic occurs in different places:
> >
> > pstore/6948115143318/dmesg.txt-<4>[545649.087998] CPU: 88 PID: 0 Comm:
> > swapper/88 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> > pstore/6948377398316/dmesg.txt-<4>[11275.914909] CPU: 14 PID: 0 Comm:
> > swapper/14 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> > pstore/6948532816002/dmesg.txt-<4>[33685.629594] CPU: 10 PID: 2118287
> > Comm: kworker/10:0 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> > pstore/6948532816002/dmesg.txt-<4>[33685.629595] Workqueue:
> > xfs-conv/md12 xfs_end_io [xfs]
> > pstore/6948855849083/dmesg.txt-<4>[42934.321129] CPU: 85 PID: 0 Comm:
> > swapper/85 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> > pstore/6948876331782/dmesg.txt-<4>[ 3475.020672] CPU: 86 PID: 0 Comm:
> > swapper/86 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> > pstore/6949083860307/dmesg.txt-<4>[43048.254375] CPU: 45 PID: 0 Comm:
> > swapper/45 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> > pstore/6949091775931/dmesg.txt-<4>[ 1150.790240] CPU: 64 PID: 0 Comm:
> > swapper/64 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> > pstore/6949123356826/dmesg.txt-<4>[ 6963.858253] CPU: 6 PID: 51 Comm:
> > kworker/6:0 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> > pstore/6949123356826/dmesg.txt-<4>[ 6963.858255] Workqueue: ceph-msgr
> > ceph_con_workfn [libceph]
> > pstore/6949123356826/dmesg.txt-<4>[ 6963.858253] CPU: 6 PID: 51 Comm:
> > kworker/6:0 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> > pstore/6949123356826/dmesg.txt-<4>[ 6963.858255] Workqueue: ceph-msgr
> > ceph_con_workfn [libceph]
> > pstore/6949152322085/dmesg.txt-<4>[ 6437.077874] CPU: 59 PID: 0 Comm:
> > swapper/59 Tainted: P           OE     5.11.8-051108-generic
> > #202103200636
> >
> > cat /proc/cmdline
> > BOOT_IMAGE=3D/vmlinuz-5.11.8-051108-generic
> > root=3D/dev/mapper/ubuntu--vg-ubuntu--lv ro net.ifnames=3D0 biosdevname=
=3D0
> > strict-devmem=3D0 mitigations=3Doff iommu=3Dpt
> >
> > cat /proc/cpuinfo
> > model name      : AMD EPYC 7552 48-Core Processor
> >
> > cat /proc/mounts
> > /dev/md12 /mnt/ssd1 xfs
> > rw,noatime,attr2,inode64,logbufs=3D8,logbsize=3D32k,sunit=3D1024,swidth=
=3D3072,prjquota
> > 0 0
> >
> > Let me know if you need more information.
>
> Hi Pawel,
>
> Thanks for the report. Could you please try whether the following
> change fixes the issue?
>
> Song
>
> diff --git i/drivers/md/md.c w/drivers/md/md.c
> index bb09070a63bcf..889e9440a9f38 100644
> --- i/drivers/md/md.c
> +++ w/drivers/md/md.c
> @@ -5648,7 +5648,7 @@ static int md_alloc(dev_t dev, char *name)
>                  */
>                 mddev->hold_active =3D UNTIL_STOP;
>
> -       error =3D mempool_init_kmalloc_pool(&mddev->md_io_pool, BIO_POOL_=
SIZE,
> +       error =3D mempool_init_slab_pool(&mddev->md_io_pool, BIO_POOL_SIZ=
E,
>                                           sizeof(struct md_io));
>         if (error)
>                 goto abort;
