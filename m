Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FC61D14EC
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 10:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730802953; cv=none; b=M2sWlLHXiPvSe9cb6tiBisYlImOvERfoXC40o6r2myqUBZiigrqvKDDPBmW7akjo+ImcCxAD0kCWjdX9nfKVCDDySyMs9WyNfdm7ixaTfh9PabPWkmq2r0oOddVTWrO2X5KH5Swzyl/7WOIfZrWOXc1U+238ytVR2omXx5NUQDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730802953; c=relaxed/simple;
	bh=GvVDoOMJu/WH4yDPEtUDr/vhkk7Yh/HkRBKdzSW3+Aw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q14J55tut+WZQvSKM9TsxHa7NEgOKTZ/Dxuc4+kixRg5qg9gPhYOW7o/THgH0GzK+BjEaoyW+n/tET5gY25AqSM5kTo0ze2qdXhxUQmt0VOq/50nPvJYk1cifLJohMinu0biQG3b71c3NJ/z2RVhoFsBUoxTQOQMvQwta9kG5l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VWxTYddn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWxTYddn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730802950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ommT+16Q4V9qojgbQBXESZI5Wmo3+B9Pi5m6iTZ2O4w=;
	b=VWxTYddnJROeQ1jWN2hly7agMu+51O55HlAP9kZCxUZPxMi01XghP8sS3RoVWOlEzdmKkO
	bzFu3D+dmJpDj3PIbWcGwHvt+/n458p8+yVPh54clI5CknaQPmhGrP1g+9jPutlsl27g5G
	1ridw/6bnvsk9LogUI6Not7hTHRiBSQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-OWX-vl-ePoGRaTuBtqQ3Mw-1; Tue, 05 Nov 2024 05:35:48 -0500
X-MC-Unique: OWX-vl-ePoGRaTuBtqQ3Mw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-539e4cd976dso3230989e87.0
        for <linux-raid@vger.kernel.org>; Tue, 05 Nov 2024 02:35:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730802947; x=1731407747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ommT+16Q4V9qojgbQBXESZI5Wmo3+B9Pi5m6iTZ2O4w=;
        b=vmbgfcwZGFenXKbq2r/dWY1eaiJnQqSGeWUoztOa6Eax1pLP1ZmgfGhlVn6/VnGZUS
         SWoeDq7i03B1YJ1LanE90sFsPxVfnmnLQDApAUO4mM4wi4pyX5SYmMkRHSXqghhVIUYw
         JQl8yCnbpZmfVftiXQSoe4NHI1g+X1PlMxhXs8vzJ14cclHVjVssZIKEUzx8i6U3Zt0u
         ysnbGT2fIa9mVRhCexDN2JDxN/kTmo0VzJk1LAGBBXYQi7pwZ60JDDFwp8A6UrhjsNgb
         ebyczJsNajao8yPbr+UYFr/SLdPxdKsYzV+jj20FC6UXgv4Jj2ElRnkQEzctqWyBPOdM
         BrVg==
X-Forwarded-Encrypted: i=1; AJvYcCUFZnQ6tOEroP0j3uTL21xVnK4jgzPkdbbj7z+oXy1mgA0Uk9W5pxniQozrw9Jc5NBhphmAvtF1GpZZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyUHtP/LuumFW3hn1s+VzeuuHAzm1tjFcHY3sE10fPaHS3REF+C
	1A+AG2DlhV4yqK7ZfvCsw7ZvBpW/tNZR4Q6XaSVJ4V86xEx+uIzi/IAHVg82OhoCcXA13XGsy+Y
	1Xlt2rw0P8d2i48PKG0INrpX4MJbDuyedJXzxgiFbMbj3AK8ATQ3eXKC8y2GGDN+0uLF7MMwCW1
	szJyPmQZzmnD7rHeNHDzCst6twCkF4Sis9CTpr+qOnveYl
X-Received: by 2002:ac2:5de8:0:b0:53d:6b50:f5eb with SMTP id 2adb3069b0e04-53d6b50f7fbmr3713037e87.28.1730802946750;
        Tue, 05 Nov 2024 02:35:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlY/Ea0rmczU5wOGllHS1vyzeIwicsXxvhc9TXN806qbANnvgi77JekV5W6NgVi0Rri9MmLaX6Vx8T1rvUCKc=
X-Received: by 2002:ac2:5de8:0:b0:53d:6b50:f5eb with SMTP id
 2adb3069b0e04-53d6b50f7fbmr3713015e87.28.1730802946257; Tue, 05 Nov 2024
 02:35:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105075733.66101-1-xni@redhat.com> <20241105091601.00001267@linux.intel.com>
 <08186a07-57b4-9e8f-d088-0e009ebe8fa5@huaweicloud.com> <CALTww2_PV8=1G1TUasA=nwXgE2+jRWcVtQpVxmB35xSAQ1ea2Q@mail.gmail.com>
 <14d9288b-6ac6-6573-5d3c-5667becff0aa@huaweicloud.com>
In-Reply-To: <14d9288b-6ac6-6573-5d3c-5667becff0aa@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 5 Nov 2024 18:35:33 +0800
Message-ID: <CALTww2_FFUdPSNhJW7dMrdzf6uiH-4x5tzKsyatjC2ynNsvgjw@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] md: Use pers->quiesce in mddev_suspend
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org, 
	linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 5:22=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2024/11/05 17:01, Xiao Ni =E5=86=99=E9=81=93:
> > On Tue, Nov 5, 2024 at 4:29=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/11/05 16:16, Mariusz Tkaczyk =E5=86=99=E9=81=93:
> >>> On Tue,  5 Nov 2024 15:57:33 +0800
> >>> Xiao Ni <xni@redhat.com> wrote:
> >>>
> >>>> One customer reports a bug: raid5 is hung when changing thread cnt
> >>>> while resync is running. The stripes are all in conf->handle_list
> >>>> and new threads can't handle them.
> >>>
> >>> Is issue fixed with this patch? Is is missing here :)
> >>>>
> >>>> Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
> >>>> pers->quiesce from mddev_suspend/resume, then we can't guarantee syn=
c
> >>>> requests finish in suspend operation. One personality knows itself t=
he
> >>>> best. So pers->quiesce is a proper way to let personality quiesce.
> >>>
> >>>>
> >>>> Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
> >>>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>>> ---
> >>>>    drivers/md/md.c | 6 ++++++
> >>>>    1 file changed, 6 insertions(+)
> >>>>
> >>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>>> index 67108c397c5a..7409ecb2df68 100644
> >>>> --- a/drivers/md/md.c
> >>>> +++ b/drivers/md/md.c
> >>>> @@ -482,6 +482,9 @@ int mddev_suspend(struct mddev *mddev, bool inte=
rruptible)
> >>>>               return err;
> >>>>       }
> >>>>
> >>>> +    if (mddev->pers)
> >>>> +            mddev->pers->quiesce(mddev, 1);
> >>>> +
> >>>
> >>> Shouldn't it be implemented as below? According to b39f35ebe86d, some=
 levels are
> >>> not implementing this?
> >>>
> >>> +     if (mddev->pers && mddev->pers->quiesce)
> >>> +             mddev->pers->quiesce(mddev, 1);
> >>
> >> It's fine, the fops is never NULL, just some levels points to an empty
> >> function.
> >>
> >> The tricky part here is that accessing "mddev->pers" is not safe here,
> >> 'reconfig_mutex' is not held in mddev_suspend(), and can concurrent
> >> with, for example, change levels. :(
> >
> > Hi Kuai
> >
> > Now mddev->suspended is protected by mddev->suspend_mutex. It should
> > can avoid the problem you mentioned above? level_store calls
> > mddev_suspend and mddev->suspended is set to mddev->suspended+1. So
> > other paths will return because mddev->suspended is not 0.
>
> Yeah, level store is just an wrong example, key point here is that
> mddev->pers is not protected by 'suspend_mutex'. Other places are
> md_run() and md_stop(), these path doesn't hold 'suspend_mutex' right?
> And they look like can concurrent with suspend, for example,
> suspend_lo_store()

Yes, thanks for pointing out this. I need to think more about this.

>
> Did you consider just fail raid5_store_group_thread_cnt() if sync_thread
> is active?

It's one method, but not a good one.

>
> Or call ->quiesce() directly here with 'reconfig_mutex' held before
> suspend?

I'll think this way. Thanks!

Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Regards
> > Xiao
> >>
> >> Thanks,
> >> Kuai
> >>
> >>>
> >>> Is it reproducible with upstream kernel?
> >>>
> >>> Thanks,
> >>> Mariusz
> >>>
> >>> .
> >>>
> >>
> >
> >
> > .
> >
>

