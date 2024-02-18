Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9B61C32
	for <linux-raid@vger.kernel.org>; Sun, 18 Feb 2024 05:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708232872; cv=none; b=AABlmrMmIGR7/f3cpJQj3wohgTgjfjqByAMRsvM4roMGWQeieCLdacXElWDACYPAGka4HpUX96hvhpkBKTwybyYwLiEm95NtuahQNrMbb1rKDfmoLBHl0MtiB6Sn7zegqWTX9fEk+wejclmq4Lze+lS5RAYU01hUaSGQJjvesHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708232872; c=relaxed/simple;
	bh=HZJ3U0g4wRuZo2pg0bTw3VaU/bIeCw89iQoFwZuF4Gk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sZlh/hc23IrzD2aCxM8BiwtnfjJx5G8K6XK63hEYeYQvP209d3LV7BmGWPLNmXOlg/cu0/HTj4k/YjKJhY9KEaf6W9k2TPEUttCB8e8XhCT/r1NbuIjlREekINnW00jFm2C3M/2Un5ksuHlRsmo23y/xzueR/NYotunBluBsnTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZMYW1zyo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZMYW1zyo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708232869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kJ111bQjIWllvC1+z6kOv3m0B4nYnfXeoU1iuZax3jk=;
	b=ZMYW1zyoeWm4mo2U4bKM/NFRFFrZCilqkRVj86AuM4PCTg6gFcx3k8907U6kA6VUji62V3
	S+pJ9Hz47PKvFbMT5VawEMtzCYyerwpvCn7E7Qhk/OaDgjiLgDSZ2EA+oulYJF4TmE6DGI
	DqGw1ZXCL6zYeNyVAWo2nQ2ELC4Na0Q=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-BZtFP524NISKZuWM0hDsaA-1; Sun, 18 Feb 2024 00:07:46 -0500
X-MC-Unique: BZtFP524NISKZuWM0hDsaA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1d45d23910aso41810495ad.1
        for <linux-raid@vger.kernel.org>; Sat, 17 Feb 2024 21:07:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708232865; x=1708837665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJ111bQjIWllvC1+z6kOv3m0B4nYnfXeoU1iuZax3jk=;
        b=Aguw/TnSY915AA3fvX+Dv8UgPIGzXD7nU6XbJ5GsV7irLFh2jMtll31g3WWsRtKT5C
         PETnYnmOsXnwOzEeHwaIYWfhdowhDv1N8Wm0MvoAKy5Wo6mtvG4gfn9bSoGwUc9WK33a
         XeO6pQbE0MPEn2hlP7wYqUYQXq/PCxeH11KNqJP9QQrUHGU6qQGh8+KYBsT8fU3NjEs8
         /7hf+F2DxkLzBrWBoFbtrgsXgq7yEglpWm4STwQjHC1CeGxDeAm8YeNTmEgtytN7s+H5
         B+GwsvdeA/DHc8c+U+g4yDxEyZ7QJ3DMuc8pQPV9OCZkeaVKRKPRg8e2PqPu7dUr/cRI
         YPtA==
X-Forwarded-Encrypted: i=1; AJvYcCVPi0qtJSf+45Nmjk0HiIAw1rBfX5jsEPdMu7ZsW6d9vrUNWzc8TYu0fO7uUMzhja+xAF5OqllcbmsDP6gEQz3Eb3281eaHSLNjVg==
X-Gm-Message-State: AOJu0YwlkS8n0rGyfal4BcBxwyX1tyHihC5L9QUoqAe9ZsaYXdtXCWJl
	IVeSuGUklKBMWAdeDyZsQ67cUpLDgCNkm/ZFrUT9E+Ulw3iU0DnwfaV8CObpwLxyybQ9dD1MPXP
	p0xvMhnbz10+BqQiF/I6T5rxvEzvCIutw727BLf43tMUCBCY6pbXua0gfT9rFLITrzM5tPnB/M1
	j1ei5eyKccf9Uab9jnHf2LfRAxsDxxLNpgMw==
X-Received: by 2002:a05:6a21:670b:b0:19c:9b7b:66a with SMTP id wh11-20020a056a21670b00b0019c9b7b066amr8922779pzb.49.1708232865696;
        Sat, 17 Feb 2024 21:07:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHafX1sQI6ruA1HkPRzewVQrJ+P3ZuePIevyyS/GYEBtEXqzHPbF8lZ65hk0HbjSN5VjFlH2Hxcn/VWxQ1PP6M=
X-Received: by 2002:a05:6a21:670b:b0:19c:9b7b:66a with SMTP id
 wh11-20020a056a21670b00b0019c9b7b066amr8922771pzb.49.1708232865367; Sat, 17
 Feb 2024 21:07:45 -0800 (PST)
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
 <2fa01c30-2ee7-7c01-6833-bf74142e6d7c@huaweicloud.com>
In-Reply-To: <2fa01c30-2ee7-7c01-6833-bf74142e6d7c@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 18 Feb 2024 13:07:34 +0800
Message-ID: <CALTww2-HngEJ9z9cYZ0=kcfuKMpziH3utSgk_8u3dxc553ZNeg@mail.gmail.com>
Subject: Re: [PATCH v5 01/14] md: don't ignore suspended array in md_check_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, blazej.kucman@linux.intel.com, 
	agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org, 
	jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com, akpm@osdl.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 18, 2024 at 11:24=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2024/02/18 11:15, Xiao Ni =E5=86=99=E9=81=93:
> > On Sun, Feb 18, 2024 at 10:34=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/02/18 10:27, Xiao Ni =E5=86=99=E9=81=93:
> >>> On Sun, Feb 18, 2024 at 9:46=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.=
com> wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> =E5=9C=A8 2024/02/18 9:33, Xiao Ni =E5=86=99=E9=81=93:
> >>>>> The deadlock problem mentioned in this patch should not be right?
> >>>>
> >>>> No, I think it's right. Looks like you are expecting other problems,
> >>>> like mentioned in patch 6, to be fixed by this patch.
> >>>
> >>> Hi Kuai
> >>>
> >>> Could you explain why step1 and step2 from this comment can happen
> >>> simultaneously? From the log, the process should be
> >>> The process is :
> >>> dev_remove->dm_destroy->__dm_destroy->dm_table_postsuspend_targets(ra=
id_postsuspend)
> >>> -> dm_table_destroy(raid_dtr).
> >>> After suspending the array, it calls raid_dtr. So these two functions
> >>> can't happen simultaneously.
> >>
> >> You're removing the target directly, however, dm can suspend the disk
> >> directly, you can simplily:
> >>
> >> 1) dmsetup suspend xxx
> >> 2) dmsetup remove xxx
> >
> > For dm-raid, the design of suspend stops sync thread first and then it
> > calls mddev_suspend to suspend array. So I'm curious why the sync
> > thread can still exit when array is suspended. I know the reason now.
> > Because before f52f5c71f (md: fix stopping sync thread), the process
> > is raid_postsuspend->md_stop_writes->__md_stop_writes
> > (__md_stop_writes sets MD_RECOVERY_FROZEN). In patch f52f5c71f, it
> > doesn't set MD_RECOVERY_FROZEN in __md_stop_writes anymore.
> >
> > The process changes to
> > 1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_thread
> > (wait until MD_RECOVERY_RUNNING clears)
> > 2. md thread -> md_check_recovery -> unregister_sync_thread ->
> > md_reap_sync_thread (clears MD_RECOVERY_RUNNING, stop_sync_thread
> > returns, md_reap_sync_thread sets MD_RECOVERY_NEEDED)
> > 3. raid_postsuspend->mddev_suspend
> > 4. md sync thread starts again because __md_stop_writes doesn't set
> > MD_RECOVERY_FROZEN.
> > It's the reason why we can see sync thread still happens when raid is s=
uspended.
> >
> > So the patch fix this problem should:
>
> As I said, this is really a different problem from this patch, and it is
> fixed seperately by patch 9. Please take a look at that patch.

I think we're talking about the same problem. In patch07 it has a new
api md_frozen_sync_thread. It sets MD_RECOVERY_FROZEN before
stop_sync_thread. This is right. If we use this api in
raid_postsuspend, sync thread can't restart. So the deadlock can't
happen anymore?

And patch01 is breaking one logic which seems right:

commit 68866e425be2ef2664aa5c691bb3ab789736acf5
Author: Jonathan Brassow <jbrassow@f14.redhat.com>
Date:   Wed Jun 8 15:10:08 2011 +1000

    MD: no sync IO while suspended

    Disallow resync I/O while the RAID array is suspended.

We're trying to fix deadlock problems. But it's not good to fix a
problem by breaking an existing rule.

Regards
Xiao


>
> Thanks,
> Kuai
>
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 9e41a9aaba8b..666761466f02 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -6315,6 +6315,7 @@ static void md_clean(struct mddev *mddev)
> >
> >   static void __md_stop_writes(struct mddev *mddev)
> >   {
> > +       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> >          stop_sync_thread(mddev, true, false);
> >          del_timer_sync(&mddev->safemode_timer);
> >
> > Like other places which call stop_sync_thread, it needs to set the
> > MD_RECOVERY_FROZEN bit.
> >
> > Regards
> > Xiao
> >
> >>
> >> Please also take a look at other patches, why step 1) can't stop sync
> >> thread.
> >>
> >> Thanks,
> >> Kuai
> >>
> >>>
> >>>
> >>>>
> >>>> Noted that this patch just fix one case that MD_RECOVERY_RUNNING can=
't
> >>>> be cleared, I you are testing this patch alone, please make sure tha=
t
> >>>> you still triggered the exactly same case:
> >>>>
> >>>> - MD_RCOVERY_RUNNING can't be cleared while array is suspended.
> >>>
> >>> I'm not testing this patch. I want to understand the patch well. So I
> >>> need to understand the issue first. I can't understand how this
> >>> deadlock (step1,step2) happens.
> >>>
> >>> Regards
> >>> Xiao
> >>>>
> >>>> Thanks,
> >>>> Kuai
> >>>>
> >>>
> >>> .
> >>>
> >>
> >
> > .
> >
>

