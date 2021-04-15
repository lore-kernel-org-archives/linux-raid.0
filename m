Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D357DC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 06:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CF22610E6
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 06:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhDOGgS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Apr 2021 02:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhDOGgR (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 15 Apr 2021 02:36:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E953861139
        for <linux-raid@vger.kernel.org>; Thu, 15 Apr 2021 06:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618468554;
        bh=VGF2I9Ixva5lLX93YQZhDRFurZos1p9Ccm/uxAF5rUA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MGBhAz9eha1BuNEaRWUVVA2MrIlyphQFTwe2JXlTPJmnUmf2krz5/Q2M/w7dcDiH3
         r05hJxjc8lLh25X7zwPfoPiwD7mCycDT/bJUbF364DDk7qMr5WVnYS1XJlB+Yieyd1
         Pbalg9n7N9PctZsqTyq2MXWvIMxQ0F02qZq0X8V9Ly8V5t4BsiLdMdFqfgEKDnq5JE
         GGvkDqQvhSQ36ZrvYOufG1XtmIouleG0wHSwE0V57dU5Oo2y/CuLhmrDWJ/odleepU
         YAfTq74Ci0yxkj0f6NckXbWdqQWtfNhOrVJ7693as1Vmw1W1hzCe0J+Z7RE9Nh3cgo
         R8ky4PsMzeWeg==
Received: by mail-lf1-f49.google.com with SMTP id x20so7096479lfu.6
        for <linux-raid@vger.kernel.org>; Wed, 14 Apr 2021 23:35:54 -0700 (PDT)
X-Gm-Message-State: AOAM532HIGFhz/62WQgE7lxlkxXTSmZ4Chu8wubLwycUI6UHK/vP/k+q
        o+zz4IjRoIMYv7kg00tId+mJH3rFx2G4GLTn8GA=
X-Google-Smtp-Source: ABdhPJxUS7/Is3RH2AW5Zlua5wfH6gJC+SJ1Et9zgVSEBnOwwbGKRoEQHbBBtGtzgNOg7KLPiKflOWuO8mLsNwq0v+I=
X-Received: by 2002:ac2:523c:: with SMTP id i28mr1415381lfl.438.1618468553329;
 Wed, 14 Apr 2021 23:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
 <CAPhsuW7YqvSBDhhOxX4oa8-Z0v5DMxtEeEWz4hs5SiNPxWrVmg@mail.gmail.com>
 <CADLTsw1EzpA+sp4kh6u0Z-Uy4v6nxjTQrVE3bot3Apo8hsjF0w@mail.gmail.com> <CAPhsuW4hK4nNa0hw=sOWqMmPQvXYFZ1EyeuTrHfzBCPk9QY=HA@mail.gmail.com>
In-Reply-To: <CAPhsuW4hK4nNa0hw=sOWqMmPQvXYFZ1EyeuTrHfzBCPk9QY=HA@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 14 Apr 2021 23:35:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6V4-ujDZJopCyAfTpLqDuW1bXX+SGgxqwnbFmR3uEWGQ@mail.gmail.com>
Message-ID: <CAPhsuW6V4-ujDZJopCyAfTpLqDuW1bXX+SGgxqwnbFmR3uEWGQ@mail.gmail.com>
Subject: Re: PROBLEM: double fault in md_end_io
To:     =?UTF-8?Q?Pawe=C5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Apr 14, 2021 at 5:36 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Apr 13, 2021 at 5:05 AM Pawe=C5=82 Wiejacha
> <pawel.wiejacha@rtbhouse.com> wrote:
> >
> > Hello Song,
> >
> > That code does not compile, but I guess that what you meant was
> > something like this:
>
> Yeah.. I am really sorry for the noise.
>
> >
> > diff --git drivers/md/md.c drivers/md/md.c
> > index 04384452a..cbc97a96b 100644
> > --- drivers/md/md.c
> > +++ drivers/md/md.c
> > @@ -78,6 +78,7 @@ static DEFINE_SPINLOCK(pers_lock);
> >
> >  static struct kobj_type md_ktype;
> >
> > +struct kmem_cache *md_io_cache;
> >  struct md_cluster_operations *md_cluster_ops;
> >  EXPORT_SYMBOL(md_cluster_ops);
> >  static struct module *md_cluster_mod;
> > @@ -5701,8 +5702,8 @@ static int md_alloc(dev_t dev, char *name)
> >          */
> >         mddev->hold_active =3D UNTIL_STOP;
> >
> > -   error =3D mempool_init_kmalloc_pool(&mddev->md_io_pool, BIO_POOL_SI=
ZE,
> > -                     sizeof(struct md_io));
> > +   error =3D mempool_init_slab_pool(&mddev->md_io_pool, BIO_POOL_SIZE,
> > +                     md_io_cache);
> >     if (error)
> >         goto abort;
> >
> > @@ -9542,6 +9543,10 @@ static int __init md_init(void)
> >  {
> >     int ret =3D -ENOMEM;
> >
> > +   md_io_cache =3D KMEM_CACHE(md_io, 0);
> > +   if (!md_io_cache)
> > +       goto err_md_io_cache;
> > +
> >     md_wq =3D alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
> >     if (!md_wq)
> >         goto err_wq;
> > @@ -9578,6 +9583,8 @@ static int __init md_init(void)
> >  err_misc_wq:
> >     destroy_workqueue(md_wq);
> >  err_wq:
> > +   kmem_cache_destroy(md_io_cache);
> > +err_md_io_cache:
> >     return ret;
> >  }
> >
> > @@ -9863,6 +9870,7 @@ static __exit void md_exit(void)
> >     destroy_workqueue(md_rdev_misc_wq);
> >     destroy_workqueue(md_misc_wq);
> >     destroy_workqueue(md_wq);
> > +   kmem_cache_destroy(md_io_cache);
> >  }
> >
> >  subsys_initcall(md_init);
>
> [...]
>
> >
> > $ watch -n0.2 'cat /proc/meminfo | paste - - | tee -a ~/meminfo'
> > MemTotal:       528235648 kB    MemFree:        20002732 kB
> > MemAvailable:   483890268 kB    Buffers:            7356 kB
> > Cached:         495416180 kB    SwapCached:            0 kB
> > Active:         96396800 kB     Inactive:       399891308 kB
> > Active(anon):      10976 kB     Inactive(anon):   890908 kB
> > Active(file):   96385824 kB     Inactive(file): 399000400 kB
> > Unevictable:       78768 kB     Mlocked:           78768 kB
> > SwapTotal:             0 kB     SwapFree:              0 kB
> > Dirty:          88422072 kB     Writeback:        948756 kB
> > AnonPages:        945772 kB     Mapped:            57300 kB
> > Shmem:             26300 kB     KReclaimable:    7248160 kB
> > Slab:            7962748 kB     SReclaimable:    7248160 kB
> > SUnreclaim:       714588 kB     KernelStack:       18288 kB
> > PageTables:        10796 kB     NFS_Unstable:          0 kB
> > Bounce:                0 kB     WritebackTmp:          0 kB
> > CommitLimit:    264117824 kB    Committed_AS:   21816824 kB
> > VmallocTotal:   34359738367 kB  VmallocUsed:      561588 kB
> > VmallocChunk:          0 kB     Percpu:            65792 kB
> > HardwareCorrupted:     0 kB     AnonHugePages:         0 kB
> > ShmemHugePages:        0 kB     ShmemPmdMapped:        0 kB
> > FileHugePages:         0 kB     FilePmdMapped:         0 kB
> > HugePages_Total:       0        HugePages_Free:        0
> > HugePages_Rsvd:        0        HugePages_Surp:        0
> > Hugepagesize:       2048 kB     Hugetlb:               0 kB
> > DirectMap4k:      541000 kB     DirectMap2M:    11907072 kB
> > DirectMap1G:    525336576 kB
> >
>
> And thanks for these information.
>
> I have set up a system to run the test, the code I am using is the top of=
 the
> md-next branch. I will update later tonight on the status.

I am not able to reproduce the issue after 6 hours. Maybe it is because I r=
un
tests on 3 partitions of the same nvme SSD. I will try on a different host =
with
multiple SSDs.

Pawel, have you tried to repro with md-next branch?

Thanks,
Song
