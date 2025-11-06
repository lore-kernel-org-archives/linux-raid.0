Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A263208
	for <linux-raid@vger.kernel.org>; Thu,  6 Nov 2025 12:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762432557; cv=none; b=bf0h0U5dLzqt49TqgVSCjp+nCMMJrYu6g6brDvCTY13XDLZhBIOwM0WEBdFzwUuFwBm2HDYylIapt0uLvQZ1hrI/OJqegNe8MAjCF4mgkONZ66k3KATm8IN9KCxE8KXk49PD3RvePk8bwbo89dFfCvbTJq0cGJDeSviMLUDQKtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762432557; c=relaxed/simple;
	bh=i+SCMf/yBk90A2KOACbcNy1ORauqmvKcDcu8Y5+nrmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qubIVPf3flDXVVWk/dmnZq/wEwHMopLkvblBn5IfWQ3k1mdhd0menf4WtPcvwJLLlhXuZbRspAnrXpnUCipYOws7Y4UY8/ZqwPmCP/9pbxGalgTMJ1z1ieEjvk/x9MiVkP8++PzRFPilA1l18WV0SQjbs8275HX/l0BgsYnnXYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L/vu4+E+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=my2UgbZb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/vu4+E+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="my2UgbZb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762432553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jmpop8a9VO9H6iCyQ2qGa1F58ZkWSPxPmCzY41bcxvo=;
	b=L/vu4+E+fCLbJ9Nurf7DE02yXpPqCzYHaN8Teq1O6x0ADWrIyKj1UJPrr/V/UBYgIHxbrm
	K6ehoWEa+t1mT+w/jLD85el7ZQ9WfPCHBO4EhXXjc+cBomZiW9nvrYRqwmS/J9EYDYq7Bq
	QHJUetcXVafiuyf8riqKL074W76XG9g=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-LNn4ajDKMYydXUTeadujXw-1; Thu, 06 Nov 2025 07:35:52 -0500
X-MC-Unique: LNn4ajDKMYydXUTeadujXw-1
X-Mimecast-MFC-AGG-ID: LNn4ajDKMYydXUTeadujXw_1762432551
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-585b3594d16so947608e87.0
        for <linux-raid@vger.kernel.org>; Thu, 06 Nov 2025 04:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762432551; x=1763037351; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jmpop8a9VO9H6iCyQ2qGa1F58ZkWSPxPmCzY41bcxvo=;
        b=my2UgbZbLsGPMegFm2eIGaA/p2kYanFxAQTSzy+wkEtnCxCoodtbkPdm+T8NYl/uWj
         5nmk5Wd0Tl9aQVs4jWVQY5mBRNdvTsHA+/V5s4ZbzInJxRaNYx1hyZ/iYeJ3WnFx8ivi
         tuMtDCMSPwTMrqluH2m/Q0QSseWw1YFuLY/kFksP23l/Yp2v0LChaGYGiSsYHxsv0Uyo
         p7qlGpghl5Bgw2bVcyCDypjwYD0Cr6YaT0Z7xHM5KtNeevZtXRmcxv4NwaF9fK4VHt13
         ZaP7VmoIylt5ybjUMkQbch/EdaF0Bl5hUjJJK04oKrv5R1y6i6R/y4I2wG0wO4AquuVP
         GSMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762432551; x=1763037351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jmpop8a9VO9H6iCyQ2qGa1F58ZkWSPxPmCzY41bcxvo=;
        b=uBHSbJvmKjgdhTt5egYrQj9laZbW0oUmNgPhiNX4lr6oX5Dq/s2y99OoX+DUfla3h0
         8qmIl735pR9xhlh9cXKE7L73GhGUa8bRPMgbCElDGkOcK7rpjcB/VaB9dgfeMwkBmjyC
         ob6WTlOqZ7A5DaAGj9ndZ3FnWVsZP1cEEHGOZ3Y994JOHeGMcK8wg6jZLSrX8moppyYm
         lpwEfPLQRfTkIABfJJTWAzLX6TLzxGFSP6XEFBgazhnlMcHhB6ngnqDC/zcrRXESsKDl
         RQQOUt0COXTtO2VW9tMl6FRHKp97SpPD+aUHASv8abwb+MErkm6c1CjFS+AFvJ942k/B
         AjfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEMDg4k0zyFQzCkwGLLheumb2yY869tnYDXAkzK0VXkULr9MgTu+zgsULW2clM+a1UBWHCcKUzaE7r@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzb/Mq5FXxferzQans8qFnMbmi0ibb2ue++pfiTl7zcJSgtLv2
	aqFtXAnLNfxltXx5usSMdGXAF2Zq1feHrWEh50OqwVgWVSnBzH9P03J2VB2Gr1ZVeFzKglVnjLf
	EmNJKExbDGkI7JKUcer7A8v6JWtTW9D2ogSa1Fmuf06fS9JtNw3W58BXynqynwbNIZweusKqrrg
	brZjaadJuX2fZakm2L6V8u3uow82lE1ASTCOc0oA==
X-Gm-Gg: ASbGncsN4ZAuBWZ7Uj2LxsWusM657F4wE2rR/GpC0YMVXRQ5IIh+odolGdTShjPUq3L
	yEuVAe1VxmiV8jCJ9jl6dBfBe7jDh8mCwwRbiuaAE3Yo6eOgMx0Xgz12BgKkJYZWkPYXRllXn40
	Yyu8SaB5+iywDAKCYzlQUZ6JjfvYCNkNR1L2yzy0qZiQjNLoGksvhvVfln
X-Received: by 2002:a05:6512:2390:b0:594:2d64:bcef with SMTP id 2adb3069b0e04-5943d55dbeemr2652136e87.3.1762432550862;
        Thu, 06 Nov 2025 04:35:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5zMwl504DegKQir6DedKv5U+7RO8JHrxD5MZPXgS6HJUP3XYHPj6qtAI6QT1cwmiHnXcrIMLdbMxHzXgMB9s=
X-Received: by 2002:a05:6512:2390:b0:594:2d64:bcef with SMTP id
 2adb3069b0e04-5943d55dbeemr2652122e87.3.1762432550368; Thu, 06 Nov 2025
 04:35:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
 <20251103125757.1405796-5-linan666@huaweicloud.com> <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
 <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com> <CALTww29v7kKgDyWqUZnteNqHDEH9_KBRY+HtSMJoquMv0sTwkg@mail.gmail.com>
 <2c1ab8fc-99ac-44fd-892c-2eeedb9581f4@fnnas.com>
In-Reply-To: <2c1ab8fc-99ac-44fd-892c-2eeedb9581f4@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 6 Nov 2025 20:35:38 +0800
X-Gm-Features: AWmQ_blp62dKYFna8dJShjcW_iuwYFNvZw6cjJczWmf99698ZthRtzAA2SZuj2o
Message-ID: <CALTww289ZzZP5TmD5qezaYZV0Mnb90abqMqR=OnAzRz3NkmhQQ@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
To: yukuai@fnnas.com
Cc: Li Nan <linan666@huaweicloud.com>, corbet@lwn.net, song@kernel.org, hare@suse.de, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 11:45=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2025/11/4 15:17, Xiao Ni =E5=86=99=E9=81=93:
> > On Tue, Nov 4, 2025 at 10:52=E2=80=AFAM Li Nan <linan666@huaweicloud.co=
m> wrote:
> >>
> >>
> >> =E5=9C=A8 2025/11/4 9:47, Xiao Ni =E5=86=99=E9=81=93:
> >>> On Mon, Nov 3, 2025 at 9:06=E2=80=AFPM <linan666@huaweicloud.com> wro=
te:
> >>>> From: Li Nan <linan122@huawei.com>
> >>>>
> >>>> Raid checks if pad3 is zero when loading superblock from disk. Array=
s
> >>>> created with new features may fail to assemble on old kernels as pad=
3
> >>>> is used.
> >>>>
> >>>> Add module parameter check_new_feature to bypass this check.
> >>>>
> >>>> Signed-off-by: Li Nan <linan122@huawei.com>
> >>>> ---
> >>>>    drivers/md/md.c | 12 +++++++++---
> >>>>    1 file changed, 9 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>>> index dffc6a482181..5921fb245bfa 100644
> >>>> --- a/drivers/md/md.c
> >>>> +++ b/drivers/md/md.c
> >>>> @@ -339,6 +339,7 @@ static int start_readonly;
> >>>>     */
> >>>>    static bool create_on_open =3D true;
> >>>>    static bool legacy_async_del_gendisk =3D true;
> >>>> +static bool check_new_feature =3D true;
> >>>>
> >>>>    /*
> >>>>     * We have a system wide 'event count' that is incremented
> >>>> @@ -1850,9 +1851,13 @@ static int super_1_load(struct md_rdev *rdev,=
 struct md_rdev *refdev, int minor_
> >>>>           }
> >>>>           if (sb->pad0 ||
> >>>>               sb->pad3[0] ||
> >>>> -           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(s=
b->pad3[1])))
> >>>> -               /* Some padding is non-zero, might be a new feature =
*/
> >>>> -               return -EINVAL;
> >>>> +           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(s=
b->pad3[1]))) {
> >>>> +               pr_warn("Some padding is non-zero on %pg, might be a=
 new feature\n",
> >>>> +                       rdev->bdev);
> >>>> +               if (check_new_feature)
> >>>> +                       return -EINVAL;
> >>>> +               pr_warn("check_new_feature is disabled, data corrupt=
ion possible\n");
> >>>> +       }
> >>>>
> >>>>           rdev->preferred_minor =3D 0xffff;
> >>>>           rdev->data_offset =3D le64_to_cpu(sb->data_offset);
> >>>> @@ -10704,6 +10709,7 @@ module_param(start_dirty_degraded, int, S_IR=
UGO|S_IWUSR);
> >>>>    module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR=
);
> >>>>    module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
> >>>>    module_param(legacy_async_del_gendisk, bool, 0600);
> >>>> +module_param(check_new_feature, bool, 0600);
> >>>>
> >>>>    MODULE_LICENSE("GPL");
> >>>>    MODULE_DESCRIPTION("MD RAID framework");
> >>>> --
> >>>> 2.39.2
> >>>>
> >>> Hi
> >>>
> >>> Thanks for finding this problem in time. The default of this kernel
> >>> module is true. I don't think people can check new kernel modules
> >>> after updating to a new kernel. They will find the array can't
> >>> assemble and report bugs. You already use pad3, is it good to remove
> >>> the check about pad3 directly here?
> >>>
> >>> By the way, have you run the regression tests?
> >>>
> >>> Regards
> >>> Xiao
> >>>
> >>>
> >>> .
> >> Hi Xiao.
> >>
> >> Thanks for your review.
> >>
> >> Deleting this check directly is risky. For example, in configurable LB=
S:
> >> if user sets LBS to 4K, the LBS of a RAID array assembled on old kerne=
l
> >> becomes 512. Forcing use of this array then risks data loss -- the
> >> original issue this feature want to solve.
> > You're right, we can't delete the check.
> > For the old kernel, the array which has specified logical size can't
> > be assembled. This patch still can't fix this problem, because it is
> > an old kernel and this patch is for a new kernel, right?
> > For existing arrays, they don't have such problems. They can be
> > assembled after updating to a new kernel.
> > So, do we need this patch?
>
> There is a use case for us that user may create the array with old kernel=
, and
> then if something bad happened in the system(may not be related to the ar=
ray),
> user may update to mainline releases and later switch back to our release=
. We
> want a solution that user can still use the array in this case.

Hi all

Let me check if I understand right:
1. a machine with an old kernel has problems
2. update to new kernel which has new feature
3. create an array with new kernel
4. switch back to the old kernel, so assemble fails because sb->pad3
is used and not zero.

The old kernel is right to do so. This should be expected, right?

>
> >
> >> Future features may also have similar risks, so instead of deleting th=
is
> >> check directly, I chose to add a module parameter to give users a choi=
ce.
> >> What do you think?
> > Maybe we can add a feature bit to avoid the kernel parameter. This
> > feature bit can be set when specifying logical block size.
>
> The situation still stand, for unknown feature bit, we'd better to forbid
> assembling the array to prevent data loss by default.

If I understand correctly, the old kernel already refuses to assemble it.

Regards
Xiao

>
> Thanks,
> Kuai
>
> >
> > Regards
> > Xiao
> >> --
> >> Thanks,
> >> Nan
> >>
>

