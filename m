Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AFE4207A
	for <linux-raid@vger.kernel.org>; Thu,  6 Nov 2025 13:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762434938; cv=none; b=maDa5k3PrjxEJ05g121zhsMn4sFvXblxMKJ39KLZXLDsJryVfptntKV4WWVc/kh8xhwQEv6OnnvRZA9e3ixPcRAf5fRn1P63oBisO0IDzvZRN5kG18oNkGZOjCYMKiZD4tCoJSHFMz8g1ItL0I5I4HluCJY67sUSW4nrHajr9Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762434938; c=relaxed/simple;
	bh=BiZqzMBevU8msCFO5nB5qb+GqBePwXQWkozVPa9VEkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=APsmgza+kADw9nFRiQMdfWcxlRKBvGbNULhTOFXA6tMZcn7IfCbcElIZXcWCy3gjepSqX5hGj/7QaPPPCclAcVRLo20EVbJKAG2cBwhSgs0nAGQOmH3TVChGNmCuGA28ZWJtng8hz/+45vX4o/lBaaGsLI+GLVSNwwAk9xICtHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZpjrzR5S; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=R/7tQpoR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZpjrzR5S";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="R/7tQpoR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762434935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vOTU/WjqME9wpuzOdb6Og4gQN4XcI7w/UopK/h4SWBU=;
	b=ZpjrzR5Slig9CyD5kk3QdpiuJS3qWNl3GVzKfjFtD87d3CV410EgndIUPlUOZOnUjpx/7J
	0vE971yp9KvVMlJUWCc0rGKu1H8KXQEDoiFhOLBm4l2J9ZD387lIhxoswmN0d4JQ8wOrnK
	OdpXDgm9tmvzRas+iQCFAD/GIQVv1tw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-W80Lj6r5NCCY6q1VnxXLMg-1; Thu, 06 Nov 2025 08:15:34 -0500
X-MC-Unique: W80Lj6r5NCCY6q1VnxXLMg-1
X-Mimecast-MFC-AGG-ID: W80Lj6r5NCCY6q1VnxXLMg_1762434934
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-78378ec9d66so5093407b3.3
        for <linux-raid@vger.kernel.org>; Thu, 06 Nov 2025 05:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762434934; x=1763039734; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vOTU/WjqME9wpuzOdb6Og4gQN4XcI7w/UopK/h4SWBU=;
        b=R/7tQpoRdalaxJHic+tTdDRLnm4xJVwI2Xo87yrRipRGRyojjxkA8WrQpGA0zP+EAf
         dKk/RqWqXck/IwTO2JOQsVCDznxUOAfudsAtNj5XDKrJfrfXxBmZiZK42kcQhoAeDF5T
         8r2ri9o6NNIlNuj4b6qtWVzbb9crfN2m2epGC9ZDngI5e4Ah1+6xYDxUfZerM6lsO1yB
         3wjCGgFuzJUw5HUR2c5ez3G0OljbWijnvGDAgKThhZX9aDESdLZke38MPgYiKtt0vWoa
         V69B2+O2aoRrkWidZBlujjxl5nI8ZT812yejkzhDK1O6A1QoSlGhxZraOH+4+o4bxvfv
         KT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762434934; x=1763039734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOTU/WjqME9wpuzOdb6Og4gQN4XcI7w/UopK/h4SWBU=;
        b=uELCwJqfuS3h3mHpASLQyQR0TNJDZ1JGwctMnjEVMS+wwk+hwKhQI2Y00Wur5CX/gQ
         SZH3e5dkVetNE1HMo7vpDIxNCux0e6/xeKem5e5zBIRn4cguyk7Dk7VG9UTYyUWljwh3
         yhVSyZzT5soIvAQPtTPRqkw5MmIf3abXcKFtvqwZrW1DiqXvkZuo0pefm7NJupLQTmNq
         wIedCqrhMNWgTT4HplIjLJK921qtYljK40x+1IPGhjPdqDD1zE6jf8z+Rhl9dPmmW2ZE
         YiBd7wF5XZstixGhRy8mL0flImZjIv9Di4X6fUTph/My4E8CKw6nAqaGmpvwA66nhwWy
         QisA==
X-Forwarded-Encrypted: i=1; AJvYcCU2wO62glL47JFtg6L4Cm4XjZ/1fiE7WY6eYXGXp/yVCUIfoFQ4dwTKnyhPlnwPdoZEaFEJ2ZMNVUaP@vger.kernel.org
X-Gm-Message-State: AOJu0YzQbTcb7Sl9JUmVgdc57GAmOq1+SqzzKBv80h6kCHfJDhoRfnAj
	NQSy7s1o9QzpxCQtcGRShcLlI0UsSSI2Q41jBAxPLyNTlQHL/9NG/Zpkmg4SZjQnxagqNK8pKIi
	oYPEAos1jBVgLhbIcE1Zo0Hc8VX29YH9j6jlFWMbmX18GSYLreZeVS5YrPznj2lebHUjKImrsqn
	tT0qlz4rby/9xLbC/JA3SYR/LdZGB/5JFgyPcLqg==
X-Gm-Gg: ASbGnctba+pvGuwCwcw4pLUQI65PGuzGhrsxDQRBM83XFfCwnQt9ShvCwBHeKOi/ccR
	FoKmStZbVN3KXiGhOmx3A8eRrGuUFmJcKIH9aucHX0uZIyrROQ2cPd7fZ5TVcO4mIwzanOW+JHV
	hgM5z0l5pOzmEmCP8k0mMYg5+pEXgPdGGBFpvjAmPzHEpr2gZUWRDk2TaI
X-Received: by 2002:a05:690c:2c03:b0:784:a2f3:85bf with SMTP id 00721157ae682-786a41ea673mr70789527b3.58.1762434933666;
        Thu, 06 Nov 2025 05:15:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGVo4Oz4xoqitm3NbY8Hy/MkEeK7IYUW5ZGbL0j9AkgtFVqIj4TVyFclW/ZdGgUeRRe6jeLpUZIJklp01doVpQ=
X-Received: by 2002:a05:690c:2c03:b0:784:a2f3:85bf with SMTP id
 00721157ae682-786a41ea673mr70789237b3.58.1762434933106; Thu, 06 Nov 2025
 05:15:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
 <20251103125757.1405796-5-linan666@huaweicloud.com> <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
 <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com> <CALTww29v7kKgDyWqUZnteNqHDEH9_KBRY+HtSMJoquMv0sTwkg@mail.gmail.com>
 <2c1ab8fc-99ac-44fd-892c-2eeedb9581f4@fnnas.com> <CALTww289ZzZP5TmD5qezaYZV0Mnb90abqMqR=OnAzRz3NkmhQQ@mail.gmail.com>
 <5396ce6f-ba67-4f5e-86dc-3c9aebb6dc20@fnnas.com>
In-Reply-To: <5396ce6f-ba67-4f5e-86dc-3c9aebb6dc20@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 6 Nov 2025 21:15:20 +0800
X-Gm-Features: AWmQ_bnRuB74FXKgXzaMZD2Cc5BM10Be30QDd4KNaH4-k9UIl2C0Xd4nmwtnZsY
Message-ID: <CALTww2_MHcXCOjeOPha0+LHNiu8O_9P4jVYP=K5-ea951omfMw@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
To: yukuai@fnnas.com
Cc: Li Nan <linan666@huaweicloud.com>, corbet@lwn.net, song@kernel.org, hare@suse.de, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 8:49=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2025/11/6 20:35, Xiao Ni =E5=86=99=E9=81=93:
> > On Thu, Nov 6, 2025 at 11:45=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrot=
e:
> >> Hi,
> >>
> >> =E5=9C=A8 2025/11/4 15:17, Xiao Ni =E5=86=99=E9=81=93:
> >>> On Tue, Nov 4, 2025 at 10:52=E2=80=AFAM Li Nan <linan666@huaweicloud.=
com> wrote:
> >>>>
> >>>> =E5=9C=A8 2025/11/4 9:47, Xiao Ni =E5=86=99=E9=81=93:
> >>>>> On Mon, Nov 3, 2025 at 9:06=E2=80=AFPM <linan666@huaweicloud.com> w=
rote:
> >>>>>> From: Li Nan <linan122@huawei.com>
> >>>>>>
> >>>>>> Raid checks if pad3 is zero when loading superblock from disk. Arr=
ays
> >>>>>> created with new features may fail to assemble on old kernels as p=
ad3
> >>>>>> is used.
> >>>>>>
> >>>>>> Add module parameter check_new_feature to bypass this check.
> >>>>>>
> >>>>>> Signed-off-by: Li Nan <linan122@huawei.com>
> >>>>>> ---
> >>>>>>     drivers/md/md.c | 12 +++++++++---
> >>>>>>     1 file changed, 9 insertions(+), 3 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>>>>> index dffc6a482181..5921fb245bfa 100644
> >>>>>> --- a/drivers/md/md.c
> >>>>>> +++ b/drivers/md/md.c
> >>>>>> @@ -339,6 +339,7 @@ static int start_readonly;
> >>>>>>      */
> >>>>>>     static bool create_on_open =3D true;
> >>>>>>     static bool legacy_async_del_gendisk =3D true;
> >>>>>> +static bool check_new_feature =3D true;
> >>>>>>
> >>>>>>     /*
> >>>>>>      * We have a system wide 'event count' that is incremented
> >>>>>> @@ -1850,9 +1851,13 @@ static int super_1_load(struct md_rdev *rde=
v, struct md_rdev *refdev, int minor_
> >>>>>>            }
> >>>>>>            if (sb->pad0 ||
> >>>>>>                sb->pad3[0] ||
> >>>>>> -           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof=
(sb->pad3[1])))
> >>>>>> -               /* Some padding is non-zero, might be a new featur=
e */
> >>>>>> -               return -EINVAL;
> >>>>>> +           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof=
(sb->pad3[1]))) {
> >>>>>> +               pr_warn("Some padding is non-zero on %pg, might be=
 a new feature\n",
> >>>>>> +                       rdev->bdev);
> >>>>>> +               if (check_new_feature)
> >>>>>> +                       return -EINVAL;
> >>>>>> +               pr_warn("check_new_feature is disabled, data corru=
ption possible\n");
> >>>>>> +       }
> >>>>>>
> >>>>>>            rdev->preferred_minor =3D 0xffff;
> >>>>>>            rdev->data_offset =3D le64_to_cpu(sb->data_offset);
> >>>>>> @@ -10704,6 +10709,7 @@ module_param(start_dirty_degraded, int, S_=
IRUGO|S_IWUSR);
> >>>>>>     module_param_call(new_array, add_named_array, NULL, NULL, S_IW=
USR);
> >>>>>>     module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
> >>>>>>     module_param(legacy_async_del_gendisk, bool, 0600);
> >>>>>> +module_param(check_new_feature, bool, 0600);
> >>>>>>
> >>>>>>     MODULE_LICENSE("GPL");
> >>>>>>     MODULE_DESCRIPTION("MD RAID framework");
> >>>>>> --
> >>>>>> 2.39.2
> >>>>>>
> >>>>> Hi
> >>>>>
> >>>>> Thanks for finding this problem in time. The default of this kernel
> >>>>> module is true. I don't think people can check new kernel modules
> >>>>> after updating to a new kernel. They will find the array can't
> >>>>> assemble and report bugs. You already use pad3, is it good to remov=
e
> >>>>> the check about pad3 directly here?
> >>>>>
> >>>>> By the way, have you run the regression tests?
> >>>>>
> >>>>> Regards
> >>>>> Xiao
> >>>>>
> >>>>>
> >>>>> .
> >>>> Hi Xiao.
> >>>>
> >>>> Thanks for your review.
> >>>>
> >>>> Deleting this check directly is risky. For example, in configurable =
LBS:
> >>>> if user sets LBS to 4K, the LBS of a RAID array assembled on old ker=
nel
> >>>> becomes 512. Forcing use of this array then risks data loss -- the
> >>>> original issue this feature want to solve.
> >>> You're right, we can't delete the check.
> >>> For the old kernel, the array which has specified logical size can't
> >>> be assembled. This patch still can't fix this problem, because it is
> >>> an old kernel and this patch is for a new kernel, right?
> >>> For existing arrays, they don't have such problems. They can be
> >>> assembled after updating to a new kernel.
> >>> So, do we need this patch?
> >> There is a use case for us that user may create the array with old ker=
nel, and
> >> then if something bad happened in the system(may not be related to the=
 array),
> >> user may update to mainline releases and later switch back to our rele=
ase. We
> >> want a solution that user can still use the array in this case.
> > Hi all
> >
> > Let me check if I understand right:
> > 1. a machine with an old kernel has problems
> > 2. update to new kernel which has new feature
> > 3. create an array with new kernel
> > 4. switch back to the old kernel, so assemble fails because sb->pad3
> > is used and not zero.
> >
> > The old kernel is right to do so. This should be expected, right?
>
> Not quite what I mean, for example
> 1. old kernel create an array md0;
> 2. something bad happened(not related to md0), for example, file system f=
rom other device crashed, or another array can't assembled;
> 3. user might update to new kernel and try to copy data, however, md0 wil=
l be assembled and sb->pad3 will be set;
> 4. user switch back to old kernel, the md0 assemble failed and can't not =
be used in old kernel anymore.

In patch05, the commit says this:

Future mdadm should support setting LBS via metadata field during RAID
creation and the new sysfs. Though the kernel allows runtime LBS changes,
users should avoid modifying it after creating partitions or filesystems
to prevent compatibility issues.

So it only can specify logical block size when creating an array. In
the case you mentioned above, in step3, the array will be assembled in
new kernel and the sb->pad3 will not be set, right?

Regards
Xiao

>
> >
> >>>> Future features may also have similar risks, so instead of deleting =
this
> >>>> check directly, I chose to add a module parameter to give users a ch=
oice.
> >>>> What do you think?
> >>> Maybe we can add a feature bit to avoid the kernel parameter. This
> >>> feature bit can be set when specifying logical block size.
> >> The situation still stand, for unknown feature bit, we'd better to for=
bid
> >> assembling the array to prevent data loss by default.
> > If I understand correctly, the old kernel already refuses to assemble i=
t.
>
> The problem is that if array is created from old kernel, and user still
> want to use it in the old kernel, then the user can't assemble this array
> in new kernel. However, this is real use case for us :(
>
> > Regards
> > Xiao
> >
> >> Thanks,
> >> Kuai
> >>
> >>> Regards
> >>> Xiao
> >>>> --
> >>>> Thanks,
> >>>> Nan
> >>>>
>

