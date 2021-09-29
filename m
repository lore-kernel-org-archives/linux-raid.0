Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1C8C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 29 Sep 2021 01:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 839FA613DA
	for <linux-raid@archiver.kernel.org>; Wed, 29 Sep 2021 01:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhI2Bbq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Sep 2021 21:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhI2Bbq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 28 Sep 2021 21:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B334613E6
        for <linux-raid@vger.kernel.org>; Wed, 29 Sep 2021 01:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632879006;
        bh=KzszZ+yDg4X9lzBW9uPVJJ879t7BvG6pple/wbCBV+w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NyvO00YnNdTpVvjZcy959aUqNLW1otDqgF2Qta05PP+cP/IQUDiwlRVZyZP4Fhk69
         YvhmLHHs4H2lvJ9HugGFm/OOtWe0gb24ZsTeOtPFN+1y1EGA8QfJAtaQzg3Lfk+xbI
         dFp6KUNVu6s8YgwqZPs2M+ZJS3DGEPpU/zrO/vlmIfh6NQTtyouDuXOWPDlfTohMy0
         C0Lb0jjUbJV1sqtP27QZXv1qGrK1cJtsriOsFIISYTL4VlULSGxUUY5HqsPvfl/2FI
         LIyLOtpTXxdn6IROHzGm6aQTMFBdDd2uhsYCr8lcne6Ei3MnU76RC2uENZS/45990H
         IGEdZ5ehhVvFQ==
Received: by mail-lf1-f53.google.com with SMTP id m3so3915468lfu.2
        for <linux-raid@vger.kernel.org>; Tue, 28 Sep 2021 18:30:06 -0700 (PDT)
X-Gm-Message-State: AOAM532Rt+LoZ4GhJZh+cJxQGbPK1xDGcBHSOSOJplLfhFJlDW9P9bWW
        hOHt1+s+fnp7VQ00MIpHZVDlbjsl5hSzv4pwXU0=
X-Google-Smtp-Source: ABdhPJyNITKTGnOidMZ00zkoqZDkCCExujXkgfV6RlN6RfGE+JtLFM2SgX8BQVc/IZ/eQmyW4s2WSqXWf67kjG7effM=
X-Received: by 2002:ac2:5617:: with SMTP id v23mr8685061lfd.114.1632879004541;
 Tue, 28 Sep 2021 18:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com>
 <20210917153452.5593-2-mariusz.tkaczyk@linux.intel.com> <CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com>
 <CAPhsuW4HZFaPgKx68mDeWE0F7SAjpnXmHL0TzN1SuZD6_Kds-w@mail.gmail.com>
 <83f06776-891f-dffa-7449-4128c419ada9@linux.intel.com> <CAPhsuW7mi9KZBVH8YuUvvbCv8k-82tb=jJnkxU0RJXhj+OxXjg@mail.gmail.com>
 <d41df432-e4e1-9567-b0e6-14736407d808@linux.intel.com> <5fc3bc1c-8e12-8d85-64c2-81cd44016073@linux.intel.com>
In-Reply-To: <5fc3bc1c-8e12-8d85-64c2-81cd44016073@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 28 Sep 2021 18:29:53 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6PNfCXzYYpPLv3R8LOoK2n+v3u_XDg1sXOpaOONnPU4Q@mail.gmail.com>
Message-ID: <CAPhsuW6PNfCXzYYpPLv3R8LOoK2n+v3u_XDg1sXOpaOONnPU4Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] md, raid1, raid10: Set MD_BROKEN for RAID1 and RAID10
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 28, 2021 at 12:55 AM Tkaczyk, Mariusz
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On 28.09.2021 09:33, Tkaczyk, Mariusz wrote:
> > Hi Song,
> >
> > On 28.09.2021 00:59, Song Liu wrote:
> >>>>>> +               if (!test_bit(Faulty, &rdev->flags) &&
> >>>>>> +                    !test_bit(MD_BROKEN, &mddev->flags) &&
> >>>>>> +                    (bio->bi_opf & MD_FAILFAST)) {
> >>>>>
> >>>>> So with MD_BROKEN, we will not try to update the SB?
> >>> Array is dead, is there added value in writing failed state?
> >>
> >> I think there is still value to remember this. Say a raid1 with 2 drives,
> >> A and B. If B is unpluged from the system, we would like to update SB
> >> on A to remember that. Otherwise, if B is pluged back later (maybe after
> >> system reset), we won't tell which one has the latest data.
> >>
> >> Does this make sense?
> >
> > Removing one drive from raid1 array doesn't cause raid failure.
> > So, removing B will be recorded on A.
> > Raid1 is not good example because to fail array we need to remove
> > all members, so MD_BROKEN doesn't matter because
> > !test_bit(Faulty, &rdev->flags) is true.
> is false.
>
> Oh, I messed it up. There is no faulty flag in this case, we cannot remove
> last drive. Since member is (physically) gone then there is no change to
> update metadata, even if it is requested.
>
> >
> > Let say that we have raid10 with member A, B, C, D. Member A is removed,
> > and it is recorded correctly (we are degraded now). Next, member B is
> > removed which causes array failure.
> > W/ my patch:
> > member B failure is not saved on members C and D. Raid is failed but
> > it is not recorded in metadata.
> > w/o my patch:
> > member B failure is saved on C and D, and metadata is in failed state.
> >>>>>
> >>>>>>                           set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> >>>>>>                           set_bit(LastDev, &rdev->flags);
> >>>>>>                   }
> >>>>>> @@ -2979,7 +2980,8 @@ state_store(struct md_rdev *rdev, const char *buf,
> >>>>>> size_t len)
> >>>>>>           int err = -EINVAL;
> >>>>>>           if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
> >>>>>>                   md_error(rdev->mddev, rdev);
> >>>>>> -               if (test_bit(Faulty, &rdev->flags))
> >>>>>> +
> >>>>>> +               if (!test_bit(MD_BROKEN, &rdev->mddev->flags))
> >>>>>
> >>>>> I don't think this makes much sense. EBUSY for already failed array
> >>>>> sounds weird.
> >>>>> Also, shall we also set MD_BROKEN here?
> >>>>>
> >>>> Actually, we just called md_error above, so we don't need to set MD_BROKEN
> >>>> here.
> >>>> But we shouldn't return EBUSY in such cases, right?
> >>>>
> >>> About EBUSY:
> >>> This is how it is implemented in mdadm, we are expecting it in
> >>> case of failure. See my fix[2].
> >>> I agree that it can be confusing, but this is how it is working.
> >>> Do you want to change it across mdadm and md?
> >>> This will break compatibility.
> >>>
> >>> About MD_BROKEN:
> >>> As you see we are determining failure by checking rdev state, if "Faulty"
> >>> in flags after md_error() is not set, then it assumes that array is
> >>> failed and EBUSY is returned to userspace.
> >>
> >> This changed the behavior for raid0, no?
> >>
> >> W/o the change mdadm --fail on raid0 will get EBUSY. W/ this change,
> >> it will get 0, and the device is NOT marked as faulty, right?
> >>
> > See commit mentioned in description. MD_BROKEN is used for raid0,
> > so EBUSY is returned, same as w/o patch.

Hmm... I am still confused. In state_store(), md_error is a no-op for raid0,
which will not set Faulty or MD_BROKEN. So we will get -EBUSY w/o
the patch and 0 w/ the patch, no? It is probably not a serious issue though.

Thanks,
Song
