Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A2AC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 27 Sep 2021 22:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E3560F4F
	for <linux-raid@archiver.kernel.org>; Mon, 27 Sep 2021 22:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbhI0XBC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Sep 2021 19:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237780AbhI0XBB (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 27 Sep 2021 19:01:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 653D561058
        for <linux-raid@vger.kernel.org>; Mon, 27 Sep 2021 22:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632783563;
        bh=nUwijAHpe0XlHUkWm21FXPsO14Qh0oKSosMNS14zQFU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EtGgiZkbOaQN7cZAVgPSnNhvUyYVCNyp/53Jq6m65qMgtsyWcjZhp95ev5G73iGXy
         DQFReF8hc2XyXccztSXhbXFhXB3WMw9k8IXhLMsEzfSS+V5aUr+fqmdSeoL5Rv18Cl
         wM1Rzr6i/1IUwhXZ26MDs8xBznFSk+Ip5K4zKrbZz9d5vwavPfojYv99kUeKq7+TpU
         av5HSaQiPP00Vpv8RG1XDSei6q2i/A3ZCHo0S2yme0tsSEWMdafVJDLSYkqCEVD8o8
         QXnY3w8lGBNpYV8J72i6pUBQ5UYKpyteDPXfhZSu27tXyxk8R31KX/oqxpOrvQ/j0+
         OWNjx3Oy9XZvg==
Received: by mail-lf1-f52.google.com with SMTP id g41so84031592lfv.1
        for <linux-raid@vger.kernel.org>; Mon, 27 Sep 2021 15:59:23 -0700 (PDT)
X-Gm-Message-State: AOAM532iRiZ8sAZLE4dwVbs8PcnHvHN4u4aVE32Q8GcsAN5qOGr4Plcq
        2Y9CXyggEFSoVTxSkuhulfpEmJuqphIrbiYJpmA=
X-Google-Smtp-Source: ABdhPJyI9SQwLImbMMIeBM4aRc8PIxOuSADLClLZMgZvqdniEtusxlDQmfxfn29IFHjiUsheNst/d6yN3C5IL0u3xRQ=
X-Received: by 2002:a2e:5442:: with SMTP id y2mr2563140ljd.436.1632783561741;
 Mon, 27 Sep 2021 15:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com>
 <20210917153452.5593-2-mariusz.tkaczyk@linux.intel.com> <CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com>
 <CAPhsuW4HZFaPgKx68mDeWE0F7SAjpnXmHL0TzN1SuZD6_Kds-w@mail.gmail.com> <83f06776-891f-dffa-7449-4128c419ada9@linux.intel.com>
In-Reply-To: <83f06776-891f-dffa-7449-4128c419ada9@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Sep 2021 15:59:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7mi9KZBVH8YuUvvbCv8k-82tb=jJnkxU0RJXhj+OxXjg@mail.gmail.com>
Message-ID: <CAPhsuW7mi9KZBVH8YuUvvbCv8k-82tb=jJnkxU0RJXhj+OxXjg@mail.gmail.com>
Subject: Re: [PATCH 1/2] md, raid1, raid10: Set MD_BROKEN for RAID1 and RAID10
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 27, 2021 at 7:54 AM Tkaczyk, Mariusz
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Song,
> Thank for review.
>
> On 24.09.2021 23:15, Song Liu wrote:
> >>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>> index c322841d4edc..ac20eb2ddff7 100644
> >>> --- a/drivers/md/md.c
> >>> +++ b/drivers/md/md.c
> >>> @@ -926,8 +926,9 @@ static void super_written(struct bio *bio)
> >>>                  pr_err("md: %s gets error=%d\n", __func__,
> >>>                         blk_status_to_errno(bio->bi_status));
> >>>                  md_error(mddev, rdev);
> >>> -               if (!test_bit(Faulty, &rdev->flags)
> >>> -                   && (bio->bi_opf & MD_FAILFAST)) {
> >>> +               if (!test_bit(Faulty, &rdev->flags) &&
> >>> +                    !test_bit(MD_BROKEN, &mddev->flags) &&
> >>> +                    (bio->bi_opf & MD_FAILFAST)) {
> >>
> >> So with MD_BROKEN, we will not try to update the SB?
> Array is dead, is there added value in writing failed state?

I think there is still value to remember this. Say a raid1 with 2 drives,
A and B. If B is unpluged from the system, we would like to update SB
on A to remember that. Otherwise, if B is pluged back later (maybe after
system reset), we won't tell which one has the latest data.

Does this make sense?

>
> For external arrays failed state is not written, because drive is
> not removed from MD device and metadata manager cannot detect array
> failure. This is how it was originally implemented (expect raid5 but I
> aligned it around two years ago[1]). I tried to make it consistent for
> everyone but I failed. Second patch restores possibility to remove
> drive by kernel for raid5 so failed state will be detected (for external)
> again.
> So, maybe I should drop this change for native. What do you think?
>
> >>
> >>>                          set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> >>>                          set_bit(LastDev, &rdev->flags);
> >>>                  }
> >>> @@ -2979,7 +2980,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
> >>>          int err = -EINVAL;
> >>>          if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
> >>>                  md_error(rdev->mddev, rdev);
> >>> -               if (test_bit(Faulty, &rdev->flags))
> >>> +
> >>> +               if (!test_bit(MD_BROKEN, &rdev->mddev->flags))
> >>
> >> I don't think this makes much sense. EBUSY for already failed array
> >> sounds weird.
> >> Also, shall we also set MD_BROKEN here?
> >>
> > Actually, we just called md_error above, so we don't need to set MD_BROKEN here.
> > But we shouldn't return EBUSY in such cases, right?
> >
> About EBUSY:
> This is how it is implemented in mdadm, we are expecting it in
> case of failure. See my fix[2].
> I agree that it can be confusing, but this is how it is working.
> Do you want to change it across mdadm and md?
> This will break compatibility.
>
> About MD_BROKEN:
> As you see we are determining failure by checking rdev state, if "Faulty"
> in flags after md_error() is not set, then it assumes that array is
> failed and EBUSY is returned to userspace.

This changed the behavior for raid0, no?

W/o the change mdadm --fail on raid0 will get EBUSY. W/ this change,
it will get 0, and the device is NOT marked as faulty, right?

Song
