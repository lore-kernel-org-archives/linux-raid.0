Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4D7CA5505
	for <linux-raid@archiver.kernel.org>; Wed, 13 Sep 2023 08:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbjIMI0j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Sep 2023 04:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238877AbjIMI0f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Sep 2023 04:26:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFA4198E
        for <linux-raid@vger.kernel.org>; Wed, 13 Sep 2023 01:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694593590; x=1726129590;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b44SZgHE+yR7WcjC/aLtDP1gELX2EIgzn9157n2Cqeg=;
  b=fBHrMryRMWT2voSp6/kNMJNJEZL0hK9GHIkdz15wmuAAbF9yxizSwdkX
   yF/SatVF8xsvRboQjW2oVOTeN+++hD4QTxyJc3CG4QDlJHB4ZLy1OCeUP
   7Pkk74ec3fO9q/iOa09/QvnvFIfK5hRMcclR3tSp3d6M4dxeHxgww/tSq
   g9L0+an9QeK3jFV7PyPAWUz/br00r74IWg8TbNeBuFrJmjCccMPQNaAN1
   Geky/FdDeP13YTbFDHbFrho7KZrNWYO6S09CC4JezyUvFPzezeVHV7FyJ
   coV9HeNDiKgO8sHHGpWKSdC9lAzR5KRNIh0nb1b1VWl5XfDOm0PWy8aG4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="442629756"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="442629756"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 01:26:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="747215529"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="747215529"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.145.205])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 01:26:26 -0700
Date:   Wed, 13 Sep 2023 10:26:21 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        AceLan Kao <acelan@gmail.com>
Subject: Re: [PATCH v2] md: do not _put wrong device in md_seq_next
Message-ID: <20230913102621.00001039@linux.intel.com>
In-Reply-To: <CAPhsuW5BsMP0vQo1nF44qTEtVoo5PaikfVT3jTDui5r94om2_Q@mail.gmail.com>
References: <20230912130124.666-1-mariusz.tkaczyk@linux.intel.com>
        <CAPhsuW5BsMP0vQo1nF44qTEtVoo5PaikfVT3jTDui5r94om2_Q@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 12 Sep 2023 15:49:12 -0700
Song Liu <song@kernel.org> wrote:

> On Tue, Sep 12, 2023 at 6:02=E2=80=AFAM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > During working on changes proposed by Kuai [1], I determined that
> > mddev->active is continusly decremented for array marked by MD_CLOSING.
> > It brought me to md_seq_next() changed by [2]. I determined the regress=
ion
> > here, if mddev_get() fails we updated mddev pointer and as a result we
> > _put failed device.
> >
> > I isolated the change in md_seq_next() and tested it- issue is no longer
> > reproducible but I don't see the root cause in this scenario. The bug
> > is obvious so I proceed with fixing. I will submit MD_CLOSING patches
> > separatelly.
> >
> > Put the device which has been _get with previous md_seq_next() call.
> > Add guard for inproper mddev_put usage(). It shouldn't be called if
> > there are less than 1 for mddev->active.
> >
> > I didn't convert atomic_t to refcount_t because refcount warns when 0 is
> > achieved which is likely to happen for mddev->active.
> >
> > [1]
> > https://lore.kernel.org/linux-raid/028a21df-4397-80aa-c2a5-7c754560f595=
@gmail.com/T/#m6a534677d9654a4236623661c10646d45419ee1b
> > [2] https://bugzilla.kernel.org/show_bug.cgi?id=3D217798
> >
> > Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the =
disk
> > is freed") Cc: Yu Kuai <yukuai3@huawei.com>
> > Cc: AceLan Kao <acelan@gmail.com>
> > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> > ---
> >  drivers/md/md.c | 20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 0fe7ab6e8ab9..bb654ff62765 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -618,6 +618,12 @@ static void mddev_delayed_delete(struct work_struct
> > *ws);
> >
> >  void mddev_put(struct mddev *mddev)
> >  {
> > +       /* Guard for ambiguous put. */
> > +       if (unlikely(atomic_read(&mddev->active) < 1)) {
> > +               pr_warn("%s: active refcount is lower than 1\n",
> > mdname(mddev));
> > +               return;
> > +       }
> > + =20
>=20
> Could you please explain why we need this guard? We should probably fix
> the caller that causes this.

We have an issue, so I added warning to catch similar mistakes. Please
note that for refcount_t such warning is implemented.
=20
If you don't see it useful I can remove it.

>=20
> >         if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
> >                 return;
> >         if (!mddev->raid_disks && list_empty(&mddev->disks) &&
> > @@ -8227,19 +8233,16 @@ static void *md_seq_next(struct seq_file *seq, =
void
> > *v, loff_t *pos) {
> >         struct list_head *tmp;
> >         struct mddev *next_mddev, *mddev =3D v;
> > -       struct mddev *to_put =3D NULL; =20
>=20
> IIUC, all we need is the following:
>=20
> diff --git i/drivers/md/md.c w/drivers/md/md.c
> index 73758b754127..a104a025084d 100644
> --- i/drivers/md/md.c
> +++ w/drivers/md/md.c
> @@ -8265,7 +8265,7 @@ static void *md_seq_next(struct seq_file *seq,
> void *v, loff_t *pos)
>         spin_unlock(&all_mddevs_lock);
>=20
>         if (to_put)
> -               mddev_put(mddev);
> +               mddev_put(to_put);
>         return next_mddev;
>=20
>  }
>=20
> Is this sufficient? If so, how about we ship this first and refactor
> the code later
> in a separate patch?

That is correct it should be sufficient. If you don't want it in one patch I
will drop refactor because Kuai re-implemented it already.

Anyway, changes I made are simple and tested, I don't see it risk in it.
Your proposal will make merge conflicts less likely to appear. I that matte=
rs I
can simplify the patch.

Please let me know what you think, then I will send v3.

Thanks,
Mariusz

