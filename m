Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676DA20324
	for <linux-raid@vger.kernel.org>; Mon, 19 Feb 2024 07:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708326640; cv=none; b=LAnaYKnlE0TjLbNbQE2esYDoClBO/3o7lzoqz2+wXFcK8zdMcY+VvhYeYYmUFWYl8Umhtms7QFnDQoSNGpTfnQ8OzC19/LTZiFOzsQGRJgQFbcj14DePxpIA8LnHqu/yt14HXUADlgngIOOsvXgHEGtjxdC1FaAsBvbTAwbJwYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708326640; c=relaxed/simple;
	bh=9xEjE6+llg7FSYZddttTBDyXXvYings1z3vF35XvNY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JPozwPqgUybneltAK/rqPlSSFYGoVBPsxb3jf5N+Za/lbrnkzrqeREr15DfWUIIbieX6AUjcgFyXLgALBoRap/AkVuqvwFQ7l8+AhGkUloOh6+O0waYENcTcHly6jYW6ewoKKuJH+Y/HdJ4bvd42AITf/w0PVKI/HyAYELuBjO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UlYij6RX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UlYij6RX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708326637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09iKyJWFTQqDiDLFZ86MZSdQOAnt2Ii5ujFvuQizOBU=;
	b=UlYij6RX7tURXk4gZzN4oVslcTNsRh/hDW34sj12U//+Oj15BV6VIAKwE6Kki8k/psr5D3
	uLc9NQ38IuAZjltf71ByoabWLohmcrfl/qRPvDRQPX0EtfP7o9J9YKc1/H8YhKoDloRChc
	id6779I2XxJmgKw3+G1tf8crJf1HTAo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-fqP7rJZyMvScmlNsVAUGPA-1; Mon, 19 Feb 2024 02:10:35 -0500
X-MC-Unique: fqP7rJZyMvScmlNsVAUGPA-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-29935047600so2754787a91.0
        for <linux-raid@vger.kernel.org>; Sun, 18 Feb 2024 23:10:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708326635; x=1708931435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=09iKyJWFTQqDiDLFZ86MZSdQOAnt2Ii5ujFvuQizOBU=;
        b=r0JCzlaZpOESk7/4L5+nxRXTgPRWzdcEA3a6GFl9vJeSd1sa5EeFdQcwAarUI0f6CT
         dPeAS0S/ynvCQtjG2iCHSIHn+PCgEoXoS82IZZHDoI3gN0YkbXPwxi85Fozo235z2IHn
         5UfyZ+rMZdErQGmY3hf5/sU8sxlTwsiXz7Stz01veYSjATIInaLYkeMa8KJ0Y423zhpp
         ZbJE5IuNPp68XODgvoOMmJkGbNj7ErWzv9QtqvxtxDA/tTg2TM44UOAPHeMphqppX8MG
         ttZFSlruCA+lnzClnCZM7Ux06mNtOObKTy0/5h/JepAnP80Y1NBCNapeO5g1fKz+5SMy
         VzPg==
X-Forwarded-Encrypted: i=1; AJvYcCUzpFFASD8hrx13FPrSbreh/+6TXKt/nBDk+LAitAcVgkeU5RqqrK6aitxMfnbXBFtt3SPQ9JVHh07i1LLVYN483KRd3u04wc1ixQ==
X-Gm-Message-State: AOJu0YwDi3Qli2abXc/nIzK1XeEwQOr2a1LIdOh8AEfgTwCsV64FPnPk
	mCn8/riBCuCfQBybrcghaA/IcL7I0al6Lb5e/2TwAxSav1I8DwDPYKREWtFBOtYXo/dh1GjBfU8
	HCdQxvF0FKjqNqvOd2H/xOsAX3ICC4beKXTqmAlPc+6Vba94sbLiRFk8jbytwR1VDr31Kg+6sCO
	vGTvzB2PcU2jRi2qNnVwHljcnjFI2TX6rQyg==
X-Received: by 2002:a17:90b:2e45:b0:299:5652:8ad7 with SMTP id sm5-20020a17090b2e4500b0029956528ad7mr3805726pjb.9.1708326634681;
        Sun, 18 Feb 2024 23:10:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnXkpJIWvHveS7qeIJqIwLHIz4Z0ka5mEN4GtpQCg+zvCaVhEQeTIIADA3TqiLibV8FapugKwIlKbWZUzfOAo=
X-Received: by 2002:a17:90b:2e45:b0:299:5652:8ad7 with SMTP id
 sm5-20020a17090b2e4500b0029956528ad7mr3805665pjb.9.1708326632883; Sun, 18 Feb
 2024 23:10:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240201092559.910982-1-yukuai1@huaweicloud.com>
 <20240201092559.910982-2-yukuai1@huaweicloud.com> <CALTww2-ZhRBJOD3jXs=xKFaD=iR=dtoC9h2rUQi5Stpi+tJ9Bw@mail.gmail.com>
 <64d27757-9387-09dc-48e8-a9eedd67f075@huaweicloud.com> <CALTww28E=k6fXJURG77KwHb7M2OByLrcE8g7GNkQDTtcOV48hQ@mail.gmail.com>
 <d4a2689e-b5cc-f268-9fb2-84c10e5eb0f4@huaweicloud.com> <CALTww28bUzmQASme3XOz0CY=o86f1EUU23ENmnf42UVyuGzQ4Q@mail.gmail.com>
 <c1195efd-dd83-317e-3067-cd4891ae013e@huaweicloud.com> <CALTww2-7tTMdf_XZ60pNKH_QCq3OUX2P==VPXZo3f-dHzVhmnw@mail.gmail.com>
 <2fa01c30-2ee7-7c01-6833-bf74142e6d7c@huaweicloud.com> <CALTww2-HngEJ9z9cYZ0=kcfuKMpziH3utSgk_8u3dxc553ZNeg@mail.gmail.com>
 <5480b350-efe3-2be7-cf3b-3a62bb0e012b@huaweicloud.com> <CALTww2-_uvkB7M=_J_6DgW1kfzW2rpQgp0vyKt7EYvON41adGw@mail.gmail.com>
 <ed1fc73d-57f8-6862-76f4-2e6ff0cd5fc8@huaweicloud.com>
In-Reply-To: <ed1fc73d-57f8-6862-76f4-2e6ff0cd5fc8@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 19 Feb 2024 15:10:21 +0800
Message-ID: <CALTww28cvDpLxUGinFOz=wJJBo7BOT8D9VBLEiQ8L+Kwka7d2Q@mail.gmail.com>
Subject: Re: [PATCH v5 01/14] md: don't ignore suspended array in md_check_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, blazej.kucman@linux.intel.com, 
	agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org, 
	neilb@suse.de, shli@fb.com, akpm@osdl.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	Jonathan Brassow <jbrassow@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 18, 2024 at 4:48=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/18 16:07, Xiao Ni =E5=86=99=E9=81=93:
> > On Sun, Feb 18, 2024 at 2:22=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/02/18 13:07, Xiao Ni =E5=86=99=E9=81=93:
> >>> On Sun, Feb 18, 2024 at 11:24=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud=
.com> wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> =E5=9C=A8 2024/02/18 11:15, Xiao Ni =E5=86=99=E9=81=93:
> >>>>> On Sun, Feb 18, 2024 at 10:34=E2=80=AFAM Yu Kuai <yukuai1@huaweiclo=
ud.com> wrote:
> >>>>>>
> >>>>>> Hi,
> >>>>>>
> >>>>>> =E5=9C=A8 2024/02/18 10:27, Xiao Ni =E5=86=99=E9=81=93:
> >>>>>>> On Sun, Feb 18, 2024 at 9:46=E2=80=AFAM Yu Kuai <yukuai1@huaweicl=
oud.com> wrote:
> >>>>>>>>
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> =E5=9C=A8 2024/02/18 9:33, Xiao Ni =E5=86=99=E9=81=93:
> >>>>>>>>> The deadlock problem mentioned in this patch should not be righ=
t?
> >>>>>>>>
> >>>>>>>> No, I think it's right. Looks like you are expecting other probl=
ems,
> >>>>>>>> like mentioned in patch 6, to be fixed by this patch.
> >>>>>>>
> >>>>>>> Hi Kuai
> >>>>>>>
> >>>>>>> Could you explain why step1 and step2 from this comment can happe=
n
> >>>>>>> simultaneously? From the log, the process should be
> >>>>>>> The process is :
> >>>>>>> dev_remove->dm_destroy->__dm_destroy->dm_table_postsuspend_target=
s(raid_postsuspend)
> >>>>>>> -> dm_table_destroy(raid_dtr).
> >>>>>>> After suspending the array, it calls raid_dtr. So these two funct=
ions
> >>>>>>> can't happen simultaneously.
> >>>>>>
> >>>>>> You're removing the target directly, however, dm can suspend the d=
isk
> >>>>>> directly, you can simplily:
> >>>>>>
> >>>>>> 1) dmsetup suspend xxx
> >>>>>> 2) dmsetup remove xxx
> >>>>>
> >>>>> For dm-raid, the design of suspend stops sync thread first and then=
 it
> >>>>> calls mddev_suspend to suspend array. So I'm curious why the sync
> >>>>> thread can still exit when array is suspended. I know the reason no=
w.
> >>>>> Because before f52f5c71f (md: fix stopping sync thread), the proces=
s
> >>>>> is raid_postsuspend->md_stop_writes->__md_stop_writes
> >>>>> (__md_stop_writes sets MD_RECOVERY_FROZEN). In patch f52f5c71f, it
> >>>>> doesn't set MD_RECOVERY_FROZEN in __md_stop_writes anymore.
> >>>>>
> >>>>> The process changes to
> >>>>> 1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_th=
read
> >>>>> (wait until MD_RECOVERY_RUNNING clears)
> >>>>> 2. md thread -> md_check_recovery -> unregister_sync_thread ->
> >>>>> md_reap_sync_thread (clears MD_RECOVERY_RUNNING, stop_sync_thread
> >>>>> returns, md_reap_sync_thread sets MD_RECOVERY_NEEDED)
> >>>>> 3. raid_postsuspend->mddev_suspend
> >>>>> 4. md sync thread starts again because __md_stop_writes doesn't set
> >>>>> MD_RECOVERY_FROZEN.
> >>>>> It's the reason why we can see sync thread still happens when raid =
is suspended.
> >>>>>
> >>>>> So the patch fix this problem should:
> >>>>
> >>>> As I said, this is really a different problem from this patch, and i=
t is
> >>>> fixed seperately by patch 9. Please take a look at that patch.
> >>>
> >>> I think we're talking about the same problem. In patch07 it has a new
> >>> api md_frozen_sync_thread. It sets MD_RECOVERY_FROZEN before
> >>> stop_sync_thread. This is right. If we use this api in
> >>> raid_postsuspend, sync thread can't restart. So the deadlock can't
> >>> happen anymore?
> >>
> >> We are not talking about the same problem at all. This patch just fix =
a
> >> simple problem in md/raid(not dm-raid). And the deadlock can also be
> >> triggered for md/raid the same.
> >>
> >> - mddev_suspend() doesn't handle sync_thread at all;
> >> - md_check_recovery() ignore suspended array;
> >>
> >> Please keep in mind this patch just fix the above case. The deadlock i=
n
> >> dm-raid is just an example of problems caused by this. Fix the deadloc=
k
> >> other way doesn't mean this case is fine.
> >
> > Because this patch set is used to fix dm raid deadlocks. But this
> > patch changes logic, it looks like more a feature - "we can start/stop
> > sync thread when array is suspended". Because this patch is added many
> > years ago and dm raid works well. If we change this, there is
> > possibilities to introduce new problems. Now we should try to walk
> > slowly.
>
> This patch itself really is quite simple, it fixes problems for md/raid,
> and can be triggered by dm-raid as well. This patch will be needed
> regardless of dm-raid, and it's absolutely not a feature.

Hi Kuai

Yes, this patch is simple. But it changes the original logic. Do we
really need to do this? And as the title of the patch set, it's used
to fix regression problems. We need to avoid much changes, find out
the root cause and fix them. It's better to use another patch set to
do more jobs. For example, allow sync request when array is suspended
(But I don't want to do this change).
>
> For dm-raid, there is no doubt that sync_thread should be stopped before
> suspend, and keep frozen until resume, and this behaviour is not changed

Agree with this
> at all and will never change. Other patches actually tries to gurantee

In fact, we only need to use one line code to do this. We don't need
so many patches. It only needs to set MD_RECOVERY_FROZEN before stop
sync thread.

        set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
        __md_stop_writes(mddev);

> this. If you think this patch can introduce new problems for dm-raid,
> please be more specific.
>
> The problem in dm-raid is that it relies on __md_stop_writes() to stop
> and frozen sync_thread, while it also relies that MD_RECOVERY_FROZEN is
> not set, and this is abuse of MD_RECOVERY_FROZEN. And if you still think
> there are problems with considering of the entire patchset, feel free to
> discuss. :)

In fact, dmraid sets MD_RECOVERY_FROZEN before f52f5c71f3d4 (md: fix
stopping sync thread).  It calls __md_stop_writes and this function
sets MD_RECOVERY_FROZEN. Thanks for your patience :)

Regards
Xiao
>
> Thanks,
> Kuai
>

