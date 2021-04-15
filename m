Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725EBC433B4
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 15:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DBF461152
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 15:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhDOPgl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Apr 2021 11:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhDOPgk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Apr 2021 11:36:40 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB66C061574
        for <linux-raid@vger.kernel.org>; Thu, 15 Apr 2021 08:36:16 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id j7so18461551qtx.5
        for <linux-raid@vger.kernel.org>; Thu, 15 Apr 2021 08:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rtbhouse.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eW9YUUh6dvue9WPmPtMjs9lHcXUOFSEuyMokBvJFYSA=;
        b=VsCHI9mgkzY80svl0nGwFcZUiC9KWbY+jg/jp1yQherYrYPVFMOrTS8DtRkFEmXfVE
         k+veWC1065GYJ/K9NnPL9I0MJHk4ia1KSSvxsksV+GxBP1l6BzYKAoe+EUYyPPvBWNTQ
         s5K1QPokNRLdQeRyjzV13oeh1UQPgd2okodyOBnKGrcmVc+NIgFFgKURe7MmmzINYJ4S
         TlpyEofHsVJOuEkOh27bRWVvlu5f/epOkvnwFX8eL9s+MTSTgNrGnubkdv8Itm7GznNM
         IHFEVb7GilRraZ8juU7gmbuBYi2JZemNa45sN+IWQS5EiXTFoqk0wpTM+fsDYkpvH0F5
         O1Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eW9YUUh6dvue9WPmPtMjs9lHcXUOFSEuyMokBvJFYSA=;
        b=TMFJ0ZzvFwHcPaqYK6T9oiLvsNDqJHokLkFHI7VR1NDvHhVOaZsRpDKfZefNF58N3v
         DO9R0HnrSUxuX6OEWC7bV3khSlgH3ShwxjNM4DSwYlUdO+Berqjy0sa5HFyBcVBR09Pk
         ftvW5MLIs4HVLQjUvFRrKjRTMJhFZFHyfy97jD3V7jAQWg3RUxXaVUCoo2xCsbDgAD2L
         1hz6Dohp6U4XKfuS/8DBkywbkJ6X32drCQ6ioTYgVl6OggY2cScCG1is/Z8bUsNsWm/R
         HbPzcyGTDGFn4qVhdUBxWDrZ5hgS+TskTqNsPSxoFFz/WzqYu5XDfduLMNxf9zGFBgJt
         VgGA==
X-Gm-Message-State: AOAM531I+zfEr+ZcFCE90i1J+40Jk+3Bv2j1f74CbWKIw9JCtZjovFIM
        pn543e4iEca7/7jWQNaeQyzYM6MU8Ip7knr1Aa3Akg==
X-Google-Smtp-Source: ABdhPJxNPmJPCeoEmgPsu36mggSK8hx2xin9EjEtDw5MHmiV7EK2V6BW7g8Ed57UC8b3E0KL3A8ILNTzGZFjYKaptAg=
X-Received: by 2002:ac8:4618:: with SMTP id p24mr3487948qtn.5.1618500975239;
 Thu, 15 Apr 2021 08:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
 <CAPhsuW7YqvSBDhhOxX4oa8-Z0v5DMxtEeEWz4hs5SiNPxWrVmg@mail.gmail.com>
 <CADLTsw1EzpA+sp4kh6u0Z-Uy4v6nxjTQrVE3bot3Apo8hsjF0w@mail.gmail.com>
 <CAPhsuW4hK4nNa0hw=sOWqMmPQvXYFZ1EyeuTrHfzBCPk9QY=HA@mail.gmail.com> <CAPhsuW6V4-ujDZJopCyAfTpLqDuW1bXX+SGgxqwnbFmR3uEWGQ@mail.gmail.com>
In-Reply-To: <CAPhsuW6V4-ujDZJopCyAfTpLqDuW1bXX+SGgxqwnbFmR3uEWGQ@mail.gmail.com>
From:   =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Date:   Thu, 15 Apr 2021 17:35:59 +0200
Message-ID: <CADLTsw3pHkqnykSHRGhdksy8yEpSkoyo4n50cPiV6hFk25Yn7w@mail.gmail.com>
Subject: Re: PROBLEM: double fault in md_end_io
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> Pawel, have you tried to repro with md-next branch?

Yes, and it also crashes:

$ git log --decorate --format=3Doneline
ca882ba4c0478c68f927fa7b622ec17bde9361ce (HEAD -> md-next-pw2) using
slab_pool for md_io_pool
2715e61834586cef8292fcaa457cbf2da955a3b8 (song-md/md-next) md/bitmap:
wait for external bitmap writes to complete during tear down
c84917aa5dfc4c809634120fb429f0ff590a1f75 md: do not return existing
mddevs from mddev_find_or_alloc

<0>[ 2086.596361] traps: PANIC: double fault, error_code: 0x0
<4>[ 2086.596364] double fault: 0000 [#1] SMP NOPTI
<4>[ 2086.596365] CPU: 40 PID: 0 Comm: swapper/40 Tainted: G
OE     5.12.0-rc3-md-next-pw-fix2 #1
<4>[ 2086.596365] Hardware name: empty S8030GM2NE/S8030GM2NE, BIOS
V4.00 03/11/2021
<4>[ 2086.596366] RIP: 0010:__slab_free+0x26/0x380
<4>[ 2086.596367] Code: 1f 44 00 00 0f 1f 44 00 00 55 49 89 ca 45 89
c3 48 89 e5 41 57 41 56 49 89 fe 41 55 41 54 49 89 f4 53 48 83 e4 f0
48 83 ec 70 <48> 89 54 24 28 0f 1f 44 00 00 41 8b 46 28 4d 8b 6c 24 20
49 8b 5c
<4>[ 2086.596368] RSP: 0018:ffff96fa4d1c8f90 EFLAGS: 00010086
<4>[ 2086.596369] RAX: ffff892f4fc35300 RBX: ffff890fdca3ff78 RCX:
ffff890fdca3ff78
<4>[ 2086.596370] RDX: ffff890fdca3ff78 RSI: fffff393c1728fc0 RDI:
ffff892fd3a9b300
<4>[ 2086.596370] RBP: ffff96fa4d1c9030 R08: 0000000000000001 R09:
ffffffffb66500a7
<4>[ 2086.596371] R10: ffff890fdca3ff78 R11: 0000000000000001 R12:
fffff393c1728fc0
<4>[ 2086.596371] R13: fffff393c1728fc0 R14: ffff892fd3a9b300 R15:
0000000000000000
<4>[ 2086.596372] FS:  0000000000000000(0000)
GS:ffff892f4fc00000(0000) knlGS:0000000000000000
<4>[ 2086.596373] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[ 2086.596373] CR2: ffff96fa4d1c8f88 CR3: 00000010c8210000 CR4:
0000000000350ee0
<4>[ 2086.596373] Call Trace:
<4>[ 2086.596374]  <IRQ>
<4>[ 2086.596374]  ? kmem_cache_free+0x3d2/0x420
<4>[ 2086.596374]  ? mempool_free_slab+0x17/0x20
<4>[ 2086.596375]  ? mempool_free_slab+0x17/0x20
<4>[ 2086.596375]  ? mempool_free+0x2f/0x80
<4>[ 2086.596376]  ? md_end_io+0x47/0x60
<4>[ 2086.596376]  ? bio_endio+0xee/0x140
<4>[ 2086.596376]  ? bio_chain_endio+0x2d/0x40
<4>[ 2086.596377]  ? md_end_io+0x59/0x60
<4>[ 2086.596377]  ? bio_endio+0xee/0x140
<4>[ 2086.596378]  ? bio_chain_endio+0x2d/0x40
...
<4>[ 2086.596485] Lost 340 message(s)!

Dumping last: `watch -n0.1 ...`:

stat 451 0 13738 76 67823521 0 17162428974 801228700 351 1886784
801228776 0 0 0 0 0 0
inflight 0 354

md_io/aliases 4
md_io/align 8
md_io/cache_dma 0
md_io/cpu_partial 30
md_io/cpu_slabs 1235 N0=3D288 N1=3D239 N2=3D463 N3=3D245
md_io/destroy_by_rcu 0
md_io/hwcache_align 0
md_io/min_partial 5
md_io/objects 126582 N0=3D26928 N1=3D28254 N2=3D44064 N3=3D27336
md_io/object_size 40
md_io/objects_partial 0
md_io/objs_per_slab 102
md_io/order 0
md_io/partial 8 N2=3D4 N3=3D4
md_io/poison 0
md_io/reclaim_account 0
md_io/red_zone 0
md_io/remote_node_defrag_ratio 100
md_io/sanity_checks 0
md_io/slabs 1249 N0=3D264 N1=3D277 N2=3D436 N3=3D272
md_io/slabs_cpu_partial 1172(1172) C0=3D14(14) C1=3D17(17) C2=3D17(17)
C3=3D17(17) C4=3D18(18) C5=3D17(17) C6=3D18(18) C7=3D17(17) C8=3D21(21) C9=
=3D4(4)
C10=3D21(21) C11=3D22(22) C12=3D21(21) C13=3D25(25) C14=3D15(15) C15
=3D19(19) C16=3D24(24) C17=3D19(19) C18=3D22(22) C19=3D15(15) C20=3D28(28)
C21=3D18(18) C22=3D18(18) C23=3D24(24) C24=3D17(17) C25=3D27(27) C26=3D8(8)
C27=3D18(18) C28=3D17(17) C29=3D18(18) C30=3D21(21) C31=3D21(21) C32=3D9(9)
C33=3D9(9) C34=3D24(24) C35=3D11(11) C36=3D19(19) C37=3D14(14) C38=3D18(18)
C39=3D4(4) C40=3D23(23) C41=3D20(20) C42=3D18(18) C43=3D22(22) C44=3D21(21)
C45=3D24(24) C46=3D20(20) C47=3D15(15) C48=3D17(17) C49=3D15(15) C50=3D16(1
6) C51=3D26(26) C52=3D21(21) C53=3D19(19) C54=3D16(16) C55=3D18(18) C56=3D2=
6(26)
C57=3D14(14) C58=3D18(18) C59=3D23(23) C60=3D18(18) C61=3D20(20) C62=3D19(1=
9)
C63=3D17(17)
md_io/slab_size 40
md_io/store_user 0
md_io/total_objects 127398 N0=3D26928 N1=3D28254 N2=3D44472 N3=3D27744
md_io/trace 0
md_io/usersize 0

> I am not able to reproduce the issue [...]

It crashes on two different machines. Next week I'm going to upgrade a
distro on an older machine (with Intel NVMe disks, different
motherboard and Xeon instead of EPYC 2 CPU) running currently
linux-5.4 without this issue. So I will let you know if switching to a
newer kernel with "improved io stats accounting" makes it unstable or
not.

Best regards,
Pawel Wiejacha.

On Thu, 15 Apr 2021 at 08:35, Song Liu <song@kernel.org> wrote:
>
> On Wed, Apr 14, 2021 at 5:36 PM Song Liu <song@kernel.org> wrote:
> >
> > On Tue, Apr 13, 2021 at 5:05 AM Pawe=C5=82 Wiejacha
> > <pawel.wiejacha@rtbhouse.com> wrote:
> > >
> > > Hello Song,
> > >
> > > That code does not compile, but I guess that what you meant was
> > > something like this:
> >
> > Yeah.. I am really sorry for the noise.
> >
> > >
> > > diff --git drivers/md/md.c drivers/md/md.c
> > > index 04384452a..cbc97a96b 100644
> > > --- drivers/md/md.c
> > > +++ drivers/md/md.c
> > > @@ -78,6 +78,7 @@ static DEFINE_SPINLOCK(pers_lock);
> > >
> > >  static struct kobj_type md_ktype;
> > >
> > > +struct kmem_cache *md_io_cache;
> > >  struct md_cluster_operations *md_cluster_ops;
> > >  EXPORT_SYMBOL(md_cluster_ops);
> > >  static struct module *md_cluster_mod;
> > > @@ -5701,8 +5702,8 @@ static int md_alloc(dev_t dev, char *name)
> > >          */
> > >         mddev->hold_active =3D UNTIL_STOP;
> > >
> > > -   error =3D mempool_init_kmalloc_pool(&mddev->md_io_pool, BIO_POOL_=
SIZE,
> > > -                     sizeof(struct md_io));
> > > +   error =3D mempool_init_slab_pool(&mddev->md_io_pool, BIO_POOL_SIZ=
E,
> > > +                     md_io_cache);
> > >     if (error)
> > >         goto abort;
> > >
> > > @@ -9542,6 +9543,10 @@ static int __init md_init(void)
> > >  {
> > >     int ret =3D -ENOMEM;
> > >
> > > +   md_io_cache =3D KMEM_CACHE(md_io, 0);
> > > +   if (!md_io_cache)
> > > +       goto err_md_io_cache;
> > > +
> > >     md_wq =3D alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
> > >     if (!md_wq)
> > >         goto err_wq;
> > > @@ -9578,6 +9583,8 @@ static int __init md_init(void)
> > >  err_misc_wq:
> > >     destroy_workqueue(md_wq);
> > >  err_wq:
> > > +   kmem_cache_destroy(md_io_cache);
> > > +err_md_io_cache:
> > >     return ret;
> > >  }
> > >
> > > @@ -9863,6 +9870,7 @@ static __exit void md_exit(void)
> > >     destroy_workqueue(md_rdev_misc_wq);
> > >     destroy_workqueue(md_misc_wq);
> > >     destroy_workqueue(md_wq);
> > > +   kmem_cache_destroy(md_io_cache);
> > >  }
> > >
> > >  subsys_initcall(md_init);
> >
> > [...]
> >
> > >
> > > $ watch -n0.2 'cat /proc/meminfo | paste - - | tee -a ~/meminfo'
> > > MemTotal:       528235648 kB    MemFree:        20002732 kB
> > > MemAvailable:   483890268 kB    Buffers:            7356 kB
> > > Cached:         495416180 kB    SwapCached:            0 kB
> > > Active:         96396800 kB     Inactive:       399891308 kB
> > > Active(anon):      10976 kB     Inactive(anon):   890908 kB
> > > Active(file):   96385824 kB     Inactive(file): 399000400 kB
> > > Unevictable:       78768 kB     Mlocked:           78768 kB
> > > SwapTotal:             0 kB     SwapFree:              0 kB
> > > Dirty:          88422072 kB     Writeback:        948756 kB
> > > AnonPages:        945772 kB     Mapped:            57300 kB
> > > Shmem:             26300 kB     KReclaimable:    7248160 kB
> > > Slab:            7962748 kB     SReclaimable:    7248160 kB
> > > SUnreclaim:       714588 kB     KernelStack:       18288 kB
> > > PageTables:        10796 kB     NFS_Unstable:          0 kB
> > > Bounce:                0 kB     WritebackTmp:          0 kB
> > > CommitLimit:    264117824 kB    Committed_AS:   21816824 kB
> > > VmallocTotal:   34359738367 kB  VmallocUsed:      561588 kB
> > > VmallocChunk:          0 kB     Percpu:            65792 kB
> > > HardwareCorrupted:     0 kB     AnonHugePages:         0 kB
> > > ShmemHugePages:        0 kB     ShmemPmdMapped:        0 kB
> > > FileHugePages:         0 kB     FilePmdMapped:         0 kB
> > > HugePages_Total:       0        HugePages_Free:        0
> > > HugePages_Rsvd:        0        HugePages_Surp:        0
> > > Hugepagesize:       2048 kB     Hugetlb:               0 kB
> > > DirectMap4k:      541000 kB     DirectMap2M:    11907072 kB
> > > DirectMap1G:    525336576 kB
> > >
> >
> > And thanks for these information.
> >
> > I have set up a system to run the test, the code I am using is the top =
of the
> > md-next branch. I will update later tonight on the status.
>
> I am not able to reproduce the issue after 6 hours. Maybe it is because I=
 run
> tests on 3 partitions of the same nvme SSD. I will try on a different hos=
t with
> multiple SSDs.
>
> Pawel, have you tried to repro with md-next branch?
>
> Thanks,
> Song
