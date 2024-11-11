Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2664B19D8A9
	for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 13:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731331786; cv=none; b=LY1k+K5dRdXkGGsD7FnvKVbk0PbTNk+wGTvHtdCcy8mry35RSXOmeFk91r50HoWmhsjUt8F/mdjiGikXz6p4OrazMMCETDj76vgh3/VzPWKJAJxHGU3T/FRX1ENZZonORzduM2AXnM/MdIaVEopx9tLn1MJi/OzcACoznDAo+hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731331786; c=relaxed/simple;
	bh=x7uQlQGvuX6CzS3U8W5Kl3MX39nCsWVzN3Jb0IyEvjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZYHYU/wFy7oCHVA109/gHILSH+mbUCACOrUgxyFDMXsYNsTHmk6GhskUQ+vevtrMVjCHpJMzd2KoYQ93auCOv3BjS51xbtaOpYWfnzOzCpfqB06F6z61v4hSjZOBvi6939L65F7FJ6dmhy4Dt0ylnH6Dpy+fSCwkWinzuTvXMik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=H50RIl6o; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="H50RIl6o"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb5111747cso38027691fa.2
        for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 05:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1731331781; x=1731936581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6RhIKas8/K2qysEru2Hx6mQHHFDFZZXjQYHOVng3xlA=;
        b=H50RIl6o3WqsmnURq2SlnC9D8TXBwPD2HQ0kqovLPuAfDF4Zd0CR5ttrEJJV9KVByy
         KfIxbFyys7q9/FckgjveRcYmnpCiQFPYKcD8y46ZQmp9T7mhjE/NcHu4z1Xw/+ysMpQs
         PmkIeocIWYQtuYvdhNCeH0aAGJQ0xetTaRRKkPT1teUJOKkjVA97iJIlUsAyBr9Y3Ja8
         yUScZR9FBBHPPx79w5zYm+7t1wpZCPgMlu04ou2cnb1iECHo+Wl3HYi3jTK3mAONptK9
         B/BU7M5IWxo0akq0AuIzu7D1IyVD889mtONeLqbjCgRVzEfVMIn5XRjPC/Uh36gopz+Q
         loxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731331781; x=1731936581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6RhIKas8/K2qysEru2Hx6mQHHFDFZZXjQYHOVng3xlA=;
        b=Ck7w05IuFE5z3PI7kRBmnM0LdrTw8hOA9H3RXRmUaDUrPpJau++cZQCFrQxOpmONzu
         4wFGNV4+wfJTvGUJ/lJTWyr9j86I9dFGuAiNYJDH0uhkQMkQ/UXJh8PtwHypv2KCrbk2
         CkhwScnBBBCqkngJ/m9+DikpVZG9jqC+ZeM7X+5hLJOay10HVMFfcs4lwuBQ38EE+has
         hsxNMg8DGZ8fFg55PYE4HBUMn9FdfkqBXRuNGYLvcUfmJlvOFLKZCSNvraLZcEPxMEO6
         XEz30dL/YbC7Y8F7LZP9TGrtq+UyB5IwhpL3fUXH5BvO6oqROO/xd+z9gteBgAJ5SP68
         tToQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMSyAEx64UxqlQgkD4ZKyeXomGjAeUXmZj2J3lsQVeerTO9mW3L6+6E5Tl46pG5pYCVJ7bSHPz1ojI@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Fs1yXrN8LF0NrwuaunxChowhSU5Z7SufWSnlOn5ZSy1lMX0Q
	hvyePwSFvJKSbtebSfwzbTAZn8rWWWheAGFl8Qngk20Pmdlw+hZhXDcRxWOSukZHvRZwwuXHjD3
	53CCv35F1L6esxLiLnNWYQhDniNrj79Hq+Ltt+Q==
X-Google-Smtp-Source: AGHT+IFQ+QuuNPUiCW8ab8GDoPwk+OfkprA243KrlW8slXrgzPwQbaixjY71UFrP1V/ZzqFHZJDj1y3vPzbk3uRrKt8=
X-Received: by 2002:a2e:bc81:0:b0:2f7:6653:8046 with SMTP id
 38308e7fff4ca-2ff202e1942mr68857841fa.25.1731331781044; Mon, 11 Nov 2024
 05:29:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
 <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com> <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
In-Reply-To: <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Mon, 11 Nov 2024 14:29:29 +0100
Message-ID: <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yukuai (C)" <yukuai3@huawei.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>, 
	David Jeffery <djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 9, 2024 at 12:43=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> On Thu, Nov 7, 2024 at 9:22=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
> >
> > Hi,
> >
> > =E5=9C=A8 2024/11/05 23:34, Haris Iqbal =E5=86=99=E9=81=93:
> > > On Tue, Nov 5, 2024 at 3:04=E2=80=AFPM Dragan Milivojevi=C4=87 <galil=
eo@pkm-inc.com> wrote:
> > >>
> > >> On Tue, 5 Nov 2024 at 10:58, Haris Iqbal <haris.iqbal@ionos.com> wro=
te:
> > >>>
> > >>> Hi,
> > >>>
> > >>> I am running fio over a RDMA block device. The server side of this
> > >>> mapping is an md-raid0 device, created over 3 md-raid5 devices.
> > >>> The md-raid5 devices each are created over 8 block devices. Below i=
s
> > >>> how the raid configuration looks (md400, md300, md301 and md302 are
> > >>> relevant for this discussion here).
> > >>
> > >> Try disabling the bitmap as a quick "fix" and see if that helps.
> > >
> > > Yes. Disabling bitmap does seem to prevent the hang completely. I ran
> > > fio for 10 minutes and no hang.
> > > Triggered the hang in 10 seconds after reverting back to internal bit=
map.
> > >
> >
> > Can you give the following patch a test? It's based on v6.11.
> >
> > Thanks,
> > Kuai
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index d3a837506a36..5e1a82b79e41 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -8753,6 +8753,30 @@ void md_submit_discard_bio(struct mddev *mddev,
> > struct md_rdev *rdev,
> >   }
> >   EXPORT_SYMBOL_GPL(md_submit_discard_bio);
> >
> > +static bool is_raid456(struct mddev *mddev)
> > +{
> > +       return mddev->pers->level =3D=3D 4 || mddev->pers->level =3D=3D=
 5 ||
> > +              mddev->pers->level =3D=3D 6;
> > +}
> > +
> > +static void bitmap_startwrite(struct mddev *mddev, struct bio *bio)
> > +{
> > +       if (!is_raid456(mddev) || !mddev->bitmap)
> > +               return;
> > +
> > +       md_bitmap_startwrite(mddev->bitmap, bio_offset(bio),
> > bio_sectors(bio),
> > +                            0);
> > +}
> > +
> > +static void bitmap_endwrite(struct mddev *mddev, struct bio *bio,
> > sector_t sectors)
> > +{
> > +       if (!is_raid456(mddev) || !mddev->bitmap)
> > +               return;
> > +
> > +       md_bitmap_endwrite(mddev->bitmap, bio_offset(bio), sectors,o
> > +                          bio->bi_status =3D=3D BLK_STS_OK, 0);
> > +}
> > +
> >   static void md_end_clone_io(struct bio *bio)
> >   {
> >          struct md_io_clone *md_io_clone =3D bio->bi_private;
> > @@ -8765,6 +8789,7 @@ static void md_end_clone_io(struct bio *bio)
> >          if (md_io_clone->start_time)
> >                  bio_end_io_acct(orig_bio, md_io_clone->start_time);
> >
> > +       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
> >          bio_put(bio);
> >          bio_endio(orig_bio);
> >          percpu_ref_put(&mddev->active_io);
> > @@ -8778,6 +8803,7 @@ static void md_clone_bio(struct mddev *mddev,
> > struct bio **bio)
> >                  bio_alloc_clone(bdev, *bio, GFP_NOIO,
> > &mddev->io_clone_set);
> >
> >          md_io_clone =3D container_of(clone, struct md_io_clone, bio_cl=
one);
> > +       md_io_clone->sectors =3D bio_sectors(*bio);
> >          md_io_clone->orig_bio =3D *bio;
> >          md_io_clone->mddev =3D mddev;
> >          if (blk_queue_io_stat(bdev->bd_disk->queue))
> > @@ -8790,6 +8816,7 @@ static void md_clone_bio(struct mddev *mddev,
> > struct bio **bio)
> >
> >   void md_account_bio(struct mddev *mddev, struct bio **bio)
> >   {
> > +       bitmap_startwrite(mddev, *bio);
> >          percpu_ref_get(&mddev->active_io);
> >          md_clone_bio(mddev, bio);
> >   }
> > @@ -8807,6 +8834,8 @@ void md_free_cloned_bio(struct bio *bio)
> >          if (md_io_clone->start_time)
> >                  bio_end_io_acct(orig_bio, md_io_clone->start_time);
> >
> > +       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
> > +
> >          bio_put(bio);
> >          percpu_ref_put(&mddev->active_io);
> >   }
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index a0d6827dced9..0c2794230e0a 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -837,6 +837,7 @@ struct md_io_clone {
> >          struct mddev    *mddev;
> >          struct bio      *orig_bio;
> >          unsigned long   start_time;
> > +       sector_t        sectors;
> >          struct bio      bio_clone;
> >   };
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index c14cf2410365..4f009e32f68a 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -3561,12 +3561,6 @@ static void __add_stripe_bio(struct stripe_head
> > *sh, struct bio *bi,
> >                   * is added to a batch, STRIPE_BIT_DELAY cannot be cha=
nged
> >                   * any more.
> >                   */
> > -               set_bit(STRIPE_BITMAP_PENDING, &sh->state);
> > -               spin_unlock_irq(&sh->stripe_lock);
> > -               md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
> > -                                    RAID5_STRIPE_SECTORS(conf), 0);
> > -               spin_lock_irq(&sh->stripe_lock);
> > -               clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
> >                  if (!sh->batch_head) {
> >                          sh->bm_seq =3D conf->seq_flush+1;
> >                          set_bit(STRIPE_BIT_DELAY, &sh->state);
> > @@ -3621,7 +3615,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> > stripe_head *sh,
> >          BUG_ON(sh->batch_head);
> >          for (i =3D disks; i--; ) {
> >                  struct bio *bi;
> > -               int bitmap_end =3D 0;
> >
> >                  if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
> >                          struct md_rdev *rdev =3D conf->disks[i].rdev;
> > @@ -3646,8 +3639,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> > stripe_head *sh,
> >                  sh->dev[i].towrite =3D NULL;
> >                  sh->overwrite_disks =3D 0;
> >                  spin_unlock_irq(&sh->stripe_lock);
> > -               if (bi)
> > -                       bitmap_end =3D 1;
> >
> >                  log_stripe_write_finished(sh);
> > @@ -3662,10 +3653,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> > stripe_head *sh,
> >                          bio_io_error(bi);
> >                          bi =3D nextbi;
> >                  }
> > -               if (bitmap_end)
> > -                       md_bitmap_endwrite(conf->mddev->bitmap, sh->sec=
tor,
> > -                                          RAID5_STRIPE_SECTORS(conf),
> > 0, 0);
> > -               bitmap_end =3D 0;
> >                  /* and fail all 'written' */
> >                  bi =3D sh->dev[i].written;
> >                  sh->dev[i].written =3D NULL;
> > @@ -3674,7 +3661,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> > stripe_head *sh,
> >                          sh->dev[i].page =3D sh->dev[i].orig_page;
> >                  }
> >
> > -               if (bi) bitmap_end =3D 1;
> >                  while (bi && bi->bi_iter.bi_sector <
> >                         sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf))=
 {
> >                          struct bio *bi2 =3D r5_next_bio(conf, bi,
> > sh->dev[i].sector);
> > @@ -3708,9 +3694,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> > stripe_head *sh,
> >                                  bi =3D nextbi;
> >                          }
> >                  }
> > -               if (bitmap_end)
> > -                       md_bitmap_endwrite(conf->mddev->bitmap, sh->sec=
tor,
> > -                                          RAID5_STRIPE_SECTORS(conf),
> > 0, 0);
> >                  /* If we were in the middle of a write the parity bloc=
k
> > might
> >                   * still be locked - so just clear all R5_LOCKED flags
> >                   */
> > @@ -4059,10 +4042,6 @@ static void handle_stripe_clean_event(struct
> > r5conf *conf,
> >                                          bio_endio(wbi);
> >                                          wbi =3D wbi2;
> >                                  }
> > -                               md_bitmap_endwrite(conf->mddev->bitmap,
> > sh->sector,
> > - RAID5_STRIPE_SECTORS(conf),
> > - !test_bit(STRIPE_DEGRADED, &sh->state),
> > -                                                  0);
> >                                  if (head_sh->batch_head) {
> >                                          sh =3D
> > list_first_entry(&sh->batch_list,
> >                                                                struct
> > stripe_head,
> > @@ -5788,13 +5767,6 @@ static void make_discard_request(struct mddev
> > *mddev, struct bio *bi)
> >                  }
> >                  spin_unlock_irq(&sh->stripe_lock);
> >                  if (conf->mddev->bitmap) {
> > -                       for (d =3D 0;
> > -                            d < conf->raid_disks - conf->max_degraded;
> > -                            d++)
> > -                               md_bitmap_startwrite(mddev->bitmap,
> > -                                                    sh->sector,
> > - RAID5_STRIPE_SECTORS(conf),
> > -                                                    0);
> >                          sh->bm_seq =3D conf->seq_flush + 1;
> >                          set_bit(STRIPE_BIT_DELAY, &sh->state);
> >                  }
> > > .
> > >
> >
> >
>
> Hi all
>
> I just replied against one raid5 stuck problem. This one looks like a
> similar one. We have a customer who reports one similar problem. David
> has a patch that can work. I place it in the attachment. Can you have
> a try also? The patch can be applied cleanly on 6.11-rc6
>
> Regards
> Xiao

Hello,

I gave both the patches a try, and here are my findings.

With the first patch by Yu, I did not see any hang or errors. I tried
a number of bitmap chunk sizes, and ran fio for few hours, and there
was no hang.

With the second patch Xiao, I hit the following BUG_ON on the first
minute of my fio run.

[  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
loaded Not tainted 6.11.5-storage
#6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
[  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/2021
[  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
[  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
[  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 01 89
45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff e9 31
ff ff ff <0f
[  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
[  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX: 00000000000=
00001
[  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI: 00000000000=
00000
[  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09: 00000000000=
00160
[  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12: ffff991d085=
4b800
[  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15: 00000000000=
00001
[  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(0000)
knlGS:0000000000000000
[  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4: 00000000001=
706f0
[  113.910034] Call Trace:
[  113.910181]  <TASK
[  113.910304]  ? die+0x36/0x90
[  113.910478]  ? do_trap+0xdd/0x100
[  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
[  113.910979]  ? do_error_trap+0x65/0x80
[  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
[  113.911503]  ? exc_invalid_op+0x50/0x70
[  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
[  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
[  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
[  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
[  113.912896]  ? submit_bio_noacct+0x47/0x4c0
[  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
[  113.913430]  ? bio_split_rw+0x143/0x290
[  113.913659]  md_handle_request+0x156/0x270
[  113.913905]  __submit_bio+0x15c/0x1f0
[  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
[  113.914412]  ? submit_bio_noacct+0x47/0x4c0
[  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
[  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
[  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
[  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]
