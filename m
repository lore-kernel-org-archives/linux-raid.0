Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3413C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 15:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 836E4615A2
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 15:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347341AbhI3P64 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Sep 2021 11:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347542AbhI3P6z (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 30 Sep 2021 11:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DB7F615A2
        for <linux-raid@vger.kernel.org>; Thu, 30 Sep 2021 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633017432;
        bh=9B06MHt1+vAWfttckmKffWxJpaAnUppwc5bYjJqpdhM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J9aydjg8WX4lIfBpg4rig6oxpKm6w0tOutXVLhd815eMQZBfu3XQeDken5jyRcHiP
         QpuLrZJfBNI85QngBlh1X+kui90m4gQoo7mFE6mf6fhKtmSZFH9sHyk4IwvXb95GAf
         Idk2bt3Gy7xMA6lbGYgNq/taq9UpyWAkJtjdlXDlDaOS1K4nswD5bkGYxCC37Ptpg4
         3xHNdFqq6lVAtXsRh8Lc1cnOTe3GGgytf93KsYEHxNk9p1T0TAKhuaEEd0EZJkt+aX
         QSn4ALA6NE/iADwN4owaEVOOo2Lp9cCZQi0zFwXfqeGIUpu4datXa94deBPZDp4nZ6
         t+fcMq+38WTsw==
Received: by mail-lf1-f45.google.com with SMTP id i25so27266124lfg.6
        for <linux-raid@vger.kernel.org>; Thu, 30 Sep 2021 08:57:12 -0700 (PDT)
X-Gm-Message-State: AOAM533WpbTPZ5Fco66jFhoxXgPXk4YDrtDrbk3YaBqtcOCHGr+ZFcrz
        vIKPIsAZT0TKkyqduwghevKy1tpDOYfk6TrNeL0=
X-Google-Smtp-Source: ABdhPJxuzVONgdWxZmiG+3JJRHsBsPGlh+RQLkePWakct66TDcw7nbI2SH81/jQ3BXQ6szB5xLG4dVOUFsKznOPxPOc=
X-Received: by 2002:a05:6512:3048:: with SMTP id b8mr6478511lfb.650.1633017430353;
 Thu, 30 Sep 2021 08:57:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com>
 <20210917153452.5593-2-mariusz.tkaczyk@linux.intel.com> <CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com>
 <CAPhsuW4HZFaPgKx68mDeWE0F7SAjpnXmHL0TzN1SuZD6_Kds-w@mail.gmail.com>
 <83f06776-891f-dffa-7449-4128c419ada9@linux.intel.com> <CAPhsuW7mi9KZBVH8YuUvvbCv8k-82tb=jJnkxU0RJXhj+OxXjg@mail.gmail.com>
 <d41df432-e4e1-9567-b0e6-14736407d808@linux.intel.com> <5fc3bc1c-8e12-8d85-64c2-81cd44016073@linux.intel.com>
 <CAPhsuW6PNfCXzYYpPLv3R8LOoK2n+v3u_XDg1sXOpaOONnPU4Q@mail.gmail.com> <b42f86e1-f81d-4579-c5f5-443a3386ca63@linux.intel.com>
In-Reply-To: <b42f86e1-f81d-4579-c5f5-443a3386ca63@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 30 Sep 2021 08:56:59 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4X94eJ8aG6i7F0zCmgjuWHSRWuBH2gOJjTe5uWg_rMvQ@mail.gmail.com>
Message-ID: <CAPhsuW4X94eJ8aG6i7F0zCmgjuWHSRWuBH2gOJjTe5uWg_rMvQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] md, raid1, raid10: Set MD_BROKEN for RAID1 and RAID10
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 30, 2021 at 4:23 AM Tkaczyk, Mariusz
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Song,
> On 29.09.2021 03:29, Song Liu wrote:
> >>>>>>>
> >>>>>>>>                            set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> >>>>>>>>                            set_bit(LastDev, &rdev->flags);
> >>>>>>>>                    }
> >>>>>>>> @@ -2979,7 +2980,8 @@ state_store(struct md_rdev *rdev, const char *buf,
> >>>>>>>> size_t len)
> >>>>>>>>            int err = -EINVAL;
> >>>>>>>>            if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
> >>>>>>>>                    md_error(rdev->mddev, rdev);
> >>>>>>>> -               if (test_bit(Faulty, &rdev->flags))
> >>>>>>>> +
> >>>>>>>> +               if (!test_bit(MD_BROKEN, &rdev->mddev->flags))
> >>>>>>>
> >>>>>>> I don't think this makes much sense. EBUSY for already failed array
> >>>>>>> sounds weird.
> >>>>>>> Also, shall we also set MD_BROKEN here?
> >>>>>>>
> >>>>>> Actually, we just called md_error above, so we don't need to set MD_BROKEN
> >>>>>> here.
> >>>>>> But we shouldn't return EBUSY in such cases, right?
> >>>>>>
> >>>>> About EBUSY:
> >>>>> This is how it is implemented in mdadm, we are expecting it in
> >>>>> case of failure. See my fix[2].
> >>>>> I agree that it can be confusing, but this is how it is working.
> >>>>> Do you want to change it across mdadm and md?
> >>>>> This will break compatibility.
> >>>>>
> >>>>> About MD_BROKEN:
> >>>>> As you see we are determining failure by checking rdev state, if "Faulty"
> >>>>> in flags after md_error() is not set, then it assumes that array is
> >>>>> failed and EBUSY is returned to userspace.
> >>>>
> >>>> This changed the behavior for raid0, no?
> >>>>
> >>>> W/o the change mdadm --fail on raid0 will get EBUSY. W/ this change,
> >>>> it will get 0, and the device is NOT marked as faulty, right?
> >>>>
> >>> See commit mentioned in description. MD_BROKEN is used for raid0,
> >>> so EBUSY is returned, same as w/o patch.
> >
> > Hmm... I am still confused. In state_store(), md_error is a no-op for raid0,
> > which will not set Faulty or MD_BROKEN. So we will get -EBUSY w/o
> > the patch and 0 w/ the patch, no? It is probably not a serious issue though.
> >
> >
> Yeah, you are right. There is no error_handler. I missed that.
> Now, I reviewed raid0 again.
>
> With my change result won't be clear for raid0, it is correlated with IO.
> When drive disappears and there is IO, then it could return -EBUSY,
> raid0_make_request() may set MD_BROKEN first.
> In there is no IO then 0 will be returned. I need to close this gap.
> Thanks for your curiosity.
>
> So, please tell me, are you ok with idea of this patch? I will send
> requested details with v2 but I want to know if I choose good way to close
> raid5 issue, which is a main problem.

I think the idea is good. Maybe we can just add an error_hander for raid0 so
it is more consistent?

Besides that, please also add more explanations about MD_BROKEN in the
next version.

Thanks,
Song
