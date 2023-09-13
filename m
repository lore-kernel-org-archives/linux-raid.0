Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455F8EDEC7C
	for <linux-raid@archiver.kernel.org>; Wed, 13 Sep 2023 16:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjIMQXH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Sep 2023 12:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjIMQXG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Sep 2023 12:23:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CAF90
        for <linux-raid@vger.kernel.org>; Wed, 13 Sep 2023 09:23:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362E2C433CA
        for <linux-raid@vger.kernel.org>; Wed, 13 Sep 2023 16:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694622182;
        bh=8q3kZuq5aOAn4PU6i+Px3NSJHn6slJ9ngguBatO/DJY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=S9Oa0K5VR9B24MkIszV3pcrrNsWqmtG07tjSp7pCUJbRx9IlFRPEYoPgPkk07hBfS
         6PTue2dFJW0rDUcLZ8JL7agkmi8IoRuk5MVx9xnyA5bygzugr3W+PeQNVcBig06PNH
         ZddQIUhwT2oZP3aG7KR1e5ijsfUpfWbOTCoIzcraUfqMdU89r8r8ImTXKoWZZuNG7i
         //E9bHueBKYJJLWeVf8kO3GZsbgtAMy88bf+27qG5L3Vxc05yCBzsszjnRi1kkOn7p
         aaZwgrDBFp3Qo1F7DkxkVtdXH3j747LgyQMBk+HD/dyMEemOStG+vGCnXzDe77jEaq
         oPo0e2sq3UqnA==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-501bd6f7d11so11533370e87.1
        for <linux-raid@vger.kernel.org>; Wed, 13 Sep 2023 09:23:02 -0700 (PDT)
X-Gm-Message-State: AOJu0YxJYJRx1bssUC4/UGBaCIar23AkrF5fpPUey2Mv94XMkGnliUMv
        KZmDFLzRXoFaxwysnoqg1DSBOteIU1X71ykXFC4=
X-Google-Smtp-Source: AGHT+IEC97eu+vSsg1IIW6a0jgd8hsIH5kcwif8+c2Wd2hXTCCxGG5hpy84UPbmsJJ1qVBv32z2nF/5ug85gYsWZ2yE=
X-Received: by 2002:ac2:5059:0:b0:502:e2be:54b5 with SMTP id
 a25-20020ac25059000000b00502e2be54b5mr431265lfm.17.1694622180222; Wed, 13 Sep
 2023 09:23:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130124.666-1-mariusz.tkaczyk@linux.intel.com>
 <CAPhsuW5BsMP0vQo1nF44qTEtVoo5PaikfVT3jTDui5r94om2_Q@mail.gmail.com> <20230913102621.00001039@linux.intel.com>
In-Reply-To: <20230913102621.00001039@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 13 Sep 2023 09:22:48 -0700
X-Gmail-Original-Message-ID: <CAPhsuW40KVmPh56fj0HrzSbuJkMdub1bdFSPuMaEHP6cXZznHw@mail.gmail.com>
Message-ID: <CAPhsuW40KVmPh56fj0HrzSbuJkMdub1bdFSPuMaEHP6cXZznHw@mail.gmail.com>
Subject: Re: [PATCH v2] md: do not _put wrong device in md_seq_next
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        AceLan Kao <acelan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 13, 2023 at 1:26=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Tue, 12 Sep 2023 15:49:12 -0700
> Song Liu <song@kernel.org> wrote:
>
> > On Tue, Sep 12, 2023 at 6:02=E2=80=AFAM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > During working on changes proposed by Kuai [1], I determined that
> > > mddev->active is continusly decremented for array marked by MD_CLOSIN=
G.
> > > It brought me to md_seq_next() changed by [2]. I determined the regre=
ssion
> > > here, if mddev_get() fails we updated mddev pointer and as a result w=
e
> > > _put failed device.
> > >
> > > I isolated the change in md_seq_next() and tested it- issue is no lon=
ger
> > > reproducible but I don't see the root cause in this scenario. The bug
> > > is obvious so I proceed with fixing. I will submit MD_CLOSING patches
> > > separatelly.
> > >
> > > Put the device which has been _get with previous md_seq_next() call.
> > > Add guard for inproper mddev_put usage(). It shouldn't be called if
> > > there are less than 1 for mddev->active.
> > >
> > > I didn't convert atomic_t to refcount_t because refcount warns when 0=
 is
> > > achieved which is likely to happen for mddev->active.
> > >
> > > [1]
> > > https://lore.kernel.org/linux-raid/028a21df-4397-80aa-c2a5-7c754560f5=
95@gmail.com/T/#m6a534677d9654a4236623661c10646d45419ee1b
> > > [2] https://bugzilla.kernel.org/show_bug.cgi?id=3D217798
> > >
> > > Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when th=
e disk
> > > is freed") Cc: Yu Kuai <yukuai3@huawei.com>
> > > Cc: AceLan Kao <acelan@gmail.com>
> > > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> > > ---
> > >  drivers/md/md.c | 20 +++++++++++---------
> > >  1 file changed, 11 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 0fe7ab6e8ab9..bb654ff62765 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -618,6 +618,12 @@ static void mddev_delayed_delete(struct work_str=
uct
> > > *ws);
> > >
> > >  void mddev_put(struct mddev *mddev)
> > >  {
> > > +       /* Guard for ambiguous put. */
> > > +       if (unlikely(atomic_read(&mddev->active) < 1)) {
> > > +               pr_warn("%s: active refcount is lower than 1\n",
> > > mdname(mddev));
> > > +               return;
> > > +       }
> > > +
> >
> > Could you please explain why we need this guard? We should probably fix
> > the caller that causes this.
>
> We have an issue, so I added warning to catch similar mistakes. Please
> note that for refcount_t such warning is implemented.
>
> If you don't see it useful I can remove it.

Let's add it (or use refcount_t) in a separate patch.

> >
> > >         if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
> > >                 return;
> > >         if (!mddev->raid_disks && list_empty(&mddev->disks) &&
> > > @@ -8227,19 +8233,16 @@ static void *md_seq_next(struct seq_file *seq=
, void
> > > *v, loff_t *pos) {
> > >         struct list_head *tmp;
> > >         struct mddev *next_mddev, *mddev =3D v;
> > > -       struct mddev *to_put =3D NULL;
> >
> > IIUC, all we need is the following:
> >
> > diff --git i/drivers/md/md.c w/drivers/md/md.c
> > index 73758b754127..a104a025084d 100644
> > --- i/drivers/md/md.c
> > +++ w/drivers/md/md.c
> > @@ -8265,7 +8265,7 @@ static void *md_seq_next(struct seq_file *seq,
> > void *v, loff_t *pos)
> >         spin_unlock(&all_mddevs_lock);
> >
> >         if (to_put)
> > -               mddev_put(mddev);
> > +               mddev_put(to_put);
> >         return next_mddev;
> >
> >  }
> >
> > Is this sufficient? If so, how about we ship this first and refactor
> > the code later
> > in a separate patch?
>
> That is correct it should be sufficient. If you don't want it in one patc=
h I
> will drop refactor because Kuai re-implemented it already.
>
> Anyway, changes I made are simple and tested, I don't see it risk in it.
> Your proposal will make merge conflicts less likely to appear. I that mat=
ters I
> can simplify the patch.

Let's keep the fix as clean as possible. Please test the one line fix and
resubmit the patch.

Thanks,
Song
