Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA57305043
	for <linux-raid@vger.kernel.org>; Tue,  4 Nov 2025 07:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762240701; cv=none; b=p5nwE2/dfzog+CiQ+IYOeeKbGbXUCWyKgdYZpg7H/I64y93NTgQjex5iPNiIsXevIhUdiLlCbUh/Iu+6VXn44938ljCUkMfL6A5qu3PNjzahUfFq0aHBzv1THEXrVkiIh4Lakj+n3sl7qh9y0eNsVc6v8il8QQatfr8eRYzBPs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762240701; c=relaxed/simple;
	bh=FEJihQxlnDdgEbfs+h950KC+cNQf1olxV+ZiL4YMXeE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h+/oe/tihx+IIMeDUH0pQl57nE25BX9XiWPxpr2kgvfEcELNp0jV0INb7F612JNahw10+28UzGNzJPWho83keqcaIqb3geRy1qUXcXb3GqSBNE4xG5Z8pdVpixwuxYXXz/0a/omqRp41AwjVsVAp7X+ExE66oHyxCHAn0S0ba2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MJFNxCoR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=c1NB0pPH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJFNxCoR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="c1NB0pPH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762240698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MTzuXIJmP4zZ1Lttp8cwRd37ZWwl4ogSNFFocfQsRMg=;
	b=MJFNxCoRRLpGzY+klljVnUyb1LXtDKDBgcTHeYanlrvHnFvxhBM0tVOu/0atA5+EO7m3iF
	KQc5RQCXe+BTlkcO0cxrYF68w0FTWRvMDC66/nZm3wnKEhYhdLEgItLnDX9RTq4XAADJMN
	c4tkFy66sSAJPrWcKLn/DGR3EaudcgA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-lHH86b_DO0qiqtwF5KMmXQ-1; Tue, 04 Nov 2025 02:18:17 -0500
X-MC-Unique: lHH86b_DO0qiqtwF5KMmXQ-1
X-Mimecast-MFC-AGG-ID: lHH86b_DO0qiqtwF5KMmXQ_1762240690
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59436279838so253051e87.0
        for <linux-raid@vger.kernel.org>; Mon, 03 Nov 2025 23:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762240690; x=1762845490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTzuXIJmP4zZ1Lttp8cwRd37ZWwl4ogSNFFocfQsRMg=;
        b=c1NB0pPHSwMsNUgHPhzPHBEurqvGBVnme3/PY4L1mxawVEoFxXD54konUV600ufRWD
         6MJbjJD9g9wSBJz3Tdp1yskN465kbokynjsm7WaofBZTr9far9lrNBVhij1gPTC9JmHF
         8agXZOqCdHeQKAh5zQq4y35rGQrOvH1PVv8iONiaJ1AitNnmwRnbG2FsAFZCnqZ1FLnl
         UqFdHiTdQkaHwZA587/SmM20r/iKDygIaKhTxyeGFm0AzbMqZSXlyH1nOyw3dj7nxCO+
         YtpeZFaVnsl3UPWD2A1aHe7ldKRIrhPcq/oucTzatyq1Rd+24HU0X5fzrBw1lcdZH91q
         j11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762240690; x=1762845490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MTzuXIJmP4zZ1Lttp8cwRd37ZWwl4ogSNFFocfQsRMg=;
        b=rTAgMl4OiaJ1TAwGtx8z4908ktbSEgpTuRWl91+L/SfJHPdVJOarJBI+B0PmIF/8ym
         7jgqc0xZqTl5jiVYYAn9OhEKMyuf3Os4yjgqBFWv4KaFFuhhpWWGeBDZTashaL9GVmD5
         hhnSaSq+PVBp6miM6AbSiFyJVEYAfMF+4iJIJYC/3NL+6XMgTxiTUWfden1PKA4BNlp7
         s33AAQ3gVdCVYzQN3TPhalmtYFrymEbFvvbCouNPPiab71qTQ3IX6DIL9Vlxe72yzuJV
         /Eja59gijGubmnOWGMOD8L6zotCXsiALYD0buRG2GI0jWCF8jypmg7GbDAsMoVpi+MZw
         Y5tw==
X-Forwarded-Encrypted: i=1; AJvYcCWIwKiIZtJUZANUz2eYmWZp2+hZX8LJMlfFEhYcK7EK9HivL6jRNUJodC6tEghJNBIaUI4GYNzxNDkz@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt3OoRnsmC0/IU4Eb2Y9AABzXwJ9RKRrXbDO5CKZG2pEl7SbTK
	TtZuI0/t74ut+Z51PEiEZN6KWa0g3obFLxMHWA4WXBaKY/DY+N3IIOzUK/TXdQqtVHKcctZTPaz
	hgyhhUnKwZd3c1w27nmYbrGfXaGoRWWhaZHsLzZhDhey11fnqEGmuJDB2qQd58cOjC/pKMTSTju
	Wkblm8hRQDksNvmo1UOHB7HxrENbt4yipL8uKyxA==
X-Gm-Gg: ASbGncvGDF+NtkxOKVzBZdd2g4INbjJlksuMQrLIouwCeQ9ETVq2zHlQ8/lNYYbugzG
	MNOGBkZu+hoskC1YlQeAQWgFvtKAM0q8qKMvw14p6Xig2UwpC1K0t98gIZFL7fNCa8I8ovo9XtI
	vlFjxo9pra92jJtTEmExJotxO7GCVwpBh9a+JVLeVtAKDKqVHWGAXJckKk
X-Received: by 2002:ac2:4c4f:0:b0:57e:c1e6:ba8 with SMTP id 2adb3069b0e04-5941d50dcbcmr4947731e87.12.1762240690111;
        Mon, 03 Nov 2025 23:18:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFa6LnqZyINfI1b6s+9A/MlotDy35EIE1oPO8bxAz3Ccj1BadfcUSCe6jPWhqctv6leB+d0rvY5OjB+9YI3eak=
X-Received: by 2002:ac2:4c4f:0:b0:57e:c1e6:ba8 with SMTP id
 2adb3069b0e04-5941d50dcbcmr4947721e87.12.1762240689606; Mon, 03 Nov 2025
 23:18:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
 <20251103125757.1405796-5-linan666@huaweicloud.com> <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
 <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com>
In-Reply-To: <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Nov 2025 15:17:56 +0800
X-Gm-Features: AWmQ_bn4wssZ7JMXroEdNiwVdeEmp206W4p2YKP5GrtWM-x5aZ6_txv7RtiB-oE
Message-ID: <CALTww29v7kKgDyWqUZnteNqHDEH9_KBRY+HtSMJoquMv0sTwkg@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
To: Li Nan <linan666@huaweicloud.com>
Cc: corbet@lwn.net, song@kernel.org, yukuai@fnnas.com, hare@suse.de, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 10:52=E2=80=AFAM Li Nan <linan666@huaweicloud.com> w=
rote:
>
>
>
> =E5=9C=A8 2025/11/4 9:47, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, Nov 3, 2025 at 9:06=E2=80=AFPM <linan666@huaweicloud.com> wrote=
:
> >>
> >> From: Li Nan <linan122@huawei.com>
> >>
> >> Raid checks if pad3 is zero when loading superblock from disk. Arrays
> >> created with new features may fail to assemble on old kernels as pad3
> >> is used.
> >>
> >> Add module parameter check_new_feature to bypass this check.
> >>
> >> Signed-off-by: Li Nan <linan122@huawei.com>
> >> ---
> >>   drivers/md/md.c | 12 +++++++++---
> >>   1 file changed, 9 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index dffc6a482181..5921fb245bfa 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -339,6 +339,7 @@ static int start_readonly;
> >>    */
> >>   static bool create_on_open =3D true;
> >>   static bool legacy_async_del_gendisk =3D true;
> >> +static bool check_new_feature =3D true;
> >>
> >>   /*
> >>    * We have a system wide 'event count' that is incremented
> >> @@ -1850,9 +1851,13 @@ static int super_1_load(struct md_rdev *rdev, s=
truct md_rdev *refdev, int minor_
> >>          }
> >>          if (sb->pad0 ||
> >>              sb->pad3[0] ||
> >> -           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb-=
>pad3[1])))
> >> -               /* Some padding is non-zero, might be a new feature */
> >> -               return -EINVAL;
> >> +           memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb-=
>pad3[1]))) {
> >> +               pr_warn("Some padding is non-zero on %pg, might be a n=
ew feature\n",
> >> +                       rdev->bdev);
> >> +               if (check_new_feature)
> >> +                       return -EINVAL;
> >> +               pr_warn("check_new_feature is disabled, data corruptio=
n possible\n");
> >> +       }
> >>
> >>          rdev->preferred_minor =3D 0xffff;
> >>          rdev->data_offset =3D le64_to_cpu(sb->data_offset);
> >> @@ -10704,6 +10709,7 @@ module_param(start_dirty_degraded, int, S_IRUG=
O|S_IWUSR);
> >>   module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
> >>   module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
> >>   module_param(legacy_async_del_gendisk, bool, 0600);
> >> +module_param(check_new_feature, bool, 0600);
> >>
> >>   MODULE_LICENSE("GPL");
> >>   MODULE_DESCRIPTION("MD RAID framework");
> >> --
> >> 2.39.2
> >>
> >
> > Hi
> >
> > Thanks for finding this problem in time. The default of this kernel
> > module is true. I don't think people can check new kernel modules
> > after updating to a new kernel. They will find the array can't
> > assemble and report bugs. You already use pad3, is it good to remove
> > the check about pad3 directly here?
> >
> > By the way, have you run the regression tests?
> >
> > Regards
> > Xiao
> >
> >
> > .
>
> Hi Xiao.
>
> Thanks for your review.
>
> Deleting this check directly is risky. For example, in configurable LBS:
> if user sets LBS to 4K, the LBS of a RAID array assembled on old kernel
> becomes 512. Forcing use of this array then risks data loss -- the
> original issue this feature want to solve.

You're right, we can't delete the check.
For the old kernel, the array which has specified logical size can't
be assembled. This patch still can't fix this problem, because it is
an old kernel and this patch is for a new kernel, right?
For existing arrays, they don't have such problems. They can be
assembled after updating to a new kernel.
So, do we need this patch?

>
> Future features may also have similar risks, so instead of deleting this
> check directly, I chose to add a module parameter to give users a choice.
> What do you think?

Maybe we can add a feature bit to avoid the kernel parameter. This
feature bit can be set when specifying logical block size.

Regards
Xiao
>
> --
> Thanks,
> Nan
>

