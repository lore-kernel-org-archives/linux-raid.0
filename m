Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EB428DCF
	for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 23:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1VvX+o4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D138FC433CC;
	Mon, 27 Nov 2023 23:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701127992;
	bh=NryLZbe6Lp7RD7isdki+30wx/vixOOf5cwgMUYqIx2c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E1VvX+o4MBGKqx+f+qkKVpL+f42O3k/P1cw0pwpefp1TjPbf79swyB2/x4/ByBax/
	 jXRFJR2VCVgmwWjBS6fJy45OVU7fy2tnbDrcgvNbC1p6CEbQYThe8n5YFQUCdpDxOc
	 068/StBFqd8JVivfGp8opXxu1YLYNjjJ4TRMX420Y8DX7aP+q/mtWhcgVAODZkjuoR
	 A58Lf89A53c5sF594AGRBYyk8suSMewOKyWpFcyMT3e/Aj/c5uPLvL7y7YuFdJzvm0
	 qGIMdxWlVLJz3XD8zqMznw5A4hBvMiWxRomMuWEKNUCizVW1BSe5+rI4dVuK6vaZIu
	 id5WlPWdZUmoQ==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-507a29c7eefso6322221e87.1;
        Mon, 27 Nov 2023 15:33:12 -0800 (PST)
X-Gm-Message-State: AOJu0YwcGSIZyWAiWWMfdZWeTboVokT9vrM0lqAfb2+xrwHTi5Q46ItU
	OQCE/nL2YiFtXwK+h7Fb/ghw3XWKU6T9keuuW/0=
X-Google-Smtp-Source: AGHT+IEg7ZPD0hlvY9kurliQ3PMPlplc/M6deVVXCXmfZmSannuI+3zJ7xZoPOMVKAT2kAdjpB7TLvWmEEgNEC97FFw=
X-Received: by 2002:ac2:5dd5:0:b0:503:28cb:c087 with SMTP id
 x21-20020ac25dd5000000b0050328cbc087mr5091467lfq.29.1701127990996; Mon, 27
 Nov 2023 15:33:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231125065419.3518254-1-yukuai1@huaweicloud.com> <CAPhsuW4YsDXdpHMuscQrW4NdXZxhg8-k4J0Xt_47twA8sG_Fmg@mail.gmail.com>
In-Reply-To: <CAPhsuW4YsDXdpHMuscQrW4NdXZxhg8-k4J0Xt_47twA8sG_Fmg@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Mon, 27 Nov 2023 15:32:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW57SuytxCY-fV74qx6B8AYb65nFC_t2VVeTN34Pamp=gQ@mail.gmail.com>
Message-ID: <CAPhsuW57SuytxCY-fV74qx6B8AYb65nFC_t2VVeTN34Pamp=gQ@mail.gmail.com>
Subject: Re: [PATCH -next v2] md: synchronize flush io with array reconfiguration
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: maan@systemlinux.org, neilb@suse.de, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 27, 2023 at 2:16=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Fri, Nov 24, 2023 at 10:54=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >
> > From: Yu Kuai <yukuai3@huawei.com>
> >
> > Currently rcu is used to protect iterating rdev from submit_flushes():
> >
> > submit_flushes                  remove_and_add_spares
> >                                 synchronize_rcu
> >                                 pers->hot_remove_disk()
> >  rcu_read_lock()
> >  rdev_for_each_rcu
> >   if (rdev->raid_disk >=3D 0)
> >                                 rdev->radi_disk =3D -1;
> >    atomic_inc(&rdev->nr_pending)
> >    rcu_read_unlock()
> >    bi =3D bio_alloc_bioset()
> >    bi->bi_end_io =3D md_end_flush
> >    bi->private =3D rdev
> >    submit_bio
> >    // issue io for removed rdev
> >
> > Fix this problem by grabbing 'acive_io' before iterating rdev, make sur=
e
> > that remove_and_add_spares() won't concurrent with submit_flushes().
> >
> > Fixes: a2826aa92e2e ("md: support barrier requests on all personalities=
.")
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > ---
> > Changes v2:
> >  - Add WARN_ON in case md_flush_request() is not called from
> >  md_handle_request() in future.
> >
> >  drivers/md/md.c | 22 ++++++++++++++++------
> >  1 file changed, 16 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 86efc9c2ae56..2ffedc39edd6 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -538,6 +538,9 @@ static void md_end_flush(struct bio *bio)
> >         rdev_dec_pending(rdev, mddev);
> >
> >         if (atomic_dec_and_test(&mddev->flush_pending)) {
> > +               /* The pair is percpu_ref_tryget() from md_flush_reques=
t() */
> > +               percpu_ref_put(&mddev->active_io);
> > +
> >                 /* The pre-request flush has finished */
> >                 queue_work(md_wq, &mddev->flush_work);
> >         }
> > @@ -557,12 +560,8 @@ static void submit_flushes(struct work_struct *ws)
> >         rdev_for_each_rcu(rdev, mddev)
> >                 if (rdev->raid_disk >=3D 0 &&
> >                     !test_bit(Faulty, &rdev->flags)) {
> > -                       /* Take two references, one is dropped
> > -                        * when request finishes, one after
> > -                        * we reclaim rcu_read_lock
> > -                        */
> >                         struct bio *bi;
> > -                       atomic_inc(&rdev->nr_pending);
> > +
> >                         atomic_inc(&rdev->nr_pending);
> >                         rcu_read_unlock();
> >                         bi =3D bio_alloc_bioset(rdev->bdev, 0,
> > @@ -573,7 +572,6 @@ static void submit_flushes(struct work_struct *ws)
> >                         atomic_inc(&mddev->flush_pending);
> >                         submit_bio(bi);
> >                         rcu_read_lock();
> > -                       rdev_dec_pending(rdev, mddev);
> >                 }
> >         rcu_read_unlock();
> >         if (atomic_dec_and_test(&mddev->flush_pending))
> > @@ -626,6 +624,18 @@ bool md_flush_request(struct mddev *mddev, struct =
bio *bio)
> >         /* new request after previous flush is completed */
> >         if (ktime_after(req_start, mddev->prev_flush_start)) {
> >                 WARN_ON(mddev->flush_bio);
> > +               /*
> > +                * Grab a reference to make sure mddev_suspend() will w=
ait for
> > +                * this flush to be done.
> > +                *
> > +                * md_flush_reqeust() is called under md_handle_request=
() and
> > +                * 'active_io' is already grabbed, hence percpu_ref_try=
get()
> > +                * won't fail, percpu_ref_tryget_live() can't be used b=
ecause
> > +                * percpu_ref_kill() can be called by mddev_suspend()
> > +                * concurrently.
> > +                */
> > +               if (WARN_ON(percpu_ref_tryget(&mddev->active_io)))
>
> This should be "if (!WARN_ON(..))", right?
>
> Song
>
> > +                       percpu_ref_get(&mddev->active_io);

Actually, we can just use percpu_ref_get(), no?

Thanks,
Song
