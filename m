Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E4AC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 24 Sep 2021 21:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9C056140A
	for <linux-raid@archiver.kernel.org>; Fri, 24 Sep 2021 21:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbhIXVRb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Sep 2021 17:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233640AbhIXVRb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 24 Sep 2021 17:17:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C225A6140A
        for <linux-raid@vger.kernel.org>; Fri, 24 Sep 2021 21:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632518157;
        bh=fN3jwFHSad3Dedo+PElgo1I8YLdZ58EBlAJxUGHFI+c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HSP8FvurpUL3cS+ygo85vD/9IPZUEuW3fKg6tdn+dOiU+5KBnK911FUbrSpZtD4it
         ogx+4SeTMC9J1lWTmS2wcmrb3b5erRKXxXfG4tsjr8AIVXYCm5qZ09fO4VoDBd2szZ
         CPkuM80wvNTCmyXxyca+Ku+3e8xlW94gajXB6HyH4s2IMONGz1a36dRnC1rN3ZA2Fr
         1ZZam3aMqqyPs0jyVgsGNkVPsMo0xgXx8mL69n3an92ZXdSeKb4UXPZ7ABAMshXYer
         DegULJSxg7aH9hED1Dlm4lMa0WoxbpBBGnq7hMNmWUUHQJURNZaQRs6O6P44kjUHx8
         KxOlV55if9heQ==
Received: by mail-lf1-f42.google.com with SMTP id u8so44734530lff.9
        for <linux-raid@vger.kernel.org>; Fri, 24 Sep 2021 14:15:57 -0700 (PDT)
X-Gm-Message-State: AOAM530wl1ywOy8m1erMoOOcMgG4Xk+zF+1ZbztLVGyH//baoaK692uU
        HgoBUciHKuvuDbvFfxhKxIutk1Ch66L+ap7N1gY=
X-Google-Smtp-Source: ABdhPJyyft7H4AHf9nLZmZszQZ6eOUaIUzs/mNKb3Y/DbY+vqjT3Y1K+n2F+ZXpZ2ByQfu+PWunne/2VTBWpfeW6vJk=
X-Received: by 2002:a05:6512:1052:: with SMTP id c18mr11016574lfb.223.1632518156119;
 Fri, 24 Sep 2021 14:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com>
 <20210917153452.5593-2-mariusz.tkaczyk@linux.intel.com> <CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com>
In-Reply-To: <CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 24 Sep 2021 14:15:45 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4HZFaPgKx68mDeWE0F7SAjpnXmHL0TzN1SuZD6_Kds-w@mail.gmail.com>
Message-ID: <CAPhsuW4HZFaPgKx68mDeWE0F7SAjpnXmHL0TzN1SuZD6_Kds-w@mail.gmail.com>
Subject: Re: [PATCH 1/2] md, raid1, raid10: Set MD_BROKEN for RAID1 and RAID10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Sep 24, 2021 at 2:09 PM Song Liu <song@kernel.org> wrote:
>
> On Fri, Sep 17, 2021 at 8:35 AM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > The idea of stopping all writes if devices is failed, introduced by
> > 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and fail BIOs if
> > a member is gone") seems to be reasonable so use MD_BROKEN for RAID1 and
> > RAID10. Support in RAID456 is added in next commit.
> > If userspace (mdadm) forces md to fail the device (Failure state
> > written via sysfs), then EBUSY is expected if array will become failed.
> > To achieve that, check for MD_BROKEN and if is set, then return EBUSY to
> > be complaint with userspace.
> > For faulty state, handled via ioctl, let the error_handler to decide.
> >
> > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>
> Thanks for the patch and sorry for the late reply.
>
> > ---
> >  drivers/md/md.c     | 16 ++++++++++------
> >  drivers/md/md.h     |  4 ++--
> >  drivers/md/raid1.c  |  1 +
> >  drivers/md/raid10.c |  1 +
> >  4 files changed, 14 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index c322841d4edc..ac20eb2ddff7 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -926,8 +926,9 @@ static void super_written(struct bio *bio)
> >                 pr_err("md: %s gets error=%d\n", __func__,
> >                        blk_status_to_errno(bio->bi_status));
> >                 md_error(mddev, rdev);
> > -               if (!test_bit(Faulty, &rdev->flags)
> > -                   && (bio->bi_opf & MD_FAILFAST)) {
> > +               if (!test_bit(Faulty, &rdev->flags) &&
> > +                    !test_bit(MD_BROKEN, &mddev->flags) &&
> > +                    (bio->bi_opf & MD_FAILFAST)) {
>
> So with MD_BROKEN, we will not try to update the SB?
>
> >                         set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> >                         set_bit(LastDev, &rdev->flags);
> >                 }
> > @@ -2979,7 +2980,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
> >         int err = -EINVAL;
> >         if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
> >                 md_error(rdev->mddev, rdev);
> > -               if (test_bit(Faulty, &rdev->flags))
> > +
> > +               if (!test_bit(MD_BROKEN, &rdev->mddev->flags))
>
> I don't think this makes much sense. EBUSY for already failed array
> sounds weird.
> Also, shall we also set MD_BROKEN here?
>
Actually, we just called md_error above, so we don't need to set MD_BROKEN here.
But we shouldn't return EBUSY in such cases, right?
