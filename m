Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12231DDC2B
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 07:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779348584; cv=none; b=Mkkmz0cFiqeQy00oXUPIf2n1WWEZAPvcUSeJLrSyEycMKrQCM78SPKi2vtNwBUM4AV7PmvLoJjZyO7nw8rdbWALU3+Vvpvq44J0gt4RFWsNukv7PnwY+7M/xNxCLP9GPl5vqJSdGmasAYsjtp5vC/IePtwtjlInfp7uOLVt5gLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779348584; c=relaxed/simple;
	bh=yreti9aiwsOpjcQkIAhVV2EsUYTWrPlC04EaS8r2CBA=;
	h=Cc:Date:Content-Type:To:Subject:Mime-Version:References:From:
	 Message-Id:In-Reply-To; b=OwiANCvPWJwu1wZ+N8jTWyrtomjryj222f2TKZqSDmzDqE+kAhQ5CUMl07jZjM3CkyFBgC6Xw40yFM3yyRPLoGLjhWQZ+dU+QTZYBwSRyf5NMcQ/HBVDpGsKJPvUZSwJ8d0gwQFjBF7kKYkJvfndZ5IBME2KO4ZnPyJjeeLVbMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=E/PJ2s4C; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="E/PJ2s4C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1779348573;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=i3O/wbGnASKlFPP8GZ8tmJUim8fBQGvRCH4XsBzBqfg=;
 b=E/PJ2s4CEz7DM6HMhnXL4v/caSqN7gDErDK5uUVM4Tc5pcFBePNUMaDlc3LaL+kvwsUF3I
 puy909NYSgheBt1tovmjVZhymMYopoWbhZ60RXAwhNFlEOHy6oODufzYe/jVu+wguCSIPz
 xv5p7yYADJzqvjBFNYlr5qsP73LODWVgzE3THar1HUM5yWesE4thpL28bLjBI9Oxmh+X2G
 kgGS5CA2PCXKxO9TIvSAboiRGj+4moAwJPU6GbARaENgkIOytug11r0sGeU8CxWuCxLqMl
 h6NSQ69ldRvZPNbavEqHuZSIWWovgquVr6dEXeLvTxze8ZBAGrYPNnUoAk+V0w==
Cc: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<xni@redhat.com>, <neilb@suse.com>, <shli@fb.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.larksuite.com with ESMTPS; Thu, 21 May 2026 07:29:31 +0000
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Date: Thu, 21 May 2026 15:29:27 +0800
Content-Type: text/plain; charset=UTF-8
X-Original-From: Yu Kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a0eb45c+de25e9+vger.kernel.org+yukuai@fygo.io>
To: "Xiao Ni" <xiao@kernel.org>
Subject: Re: [PATCH v2 2/3] md/raid1,raid10: fix error-path detection with md_cloned_bio()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
References: <20260501114652.590037-1-abd.masalkhi@gmail.com> <20260501114652.590037-3-abd.masalkhi@gmail.com> <71990de4-1113-4b7d-8a50-ca1d82802a03@fygo.io> <CAF-RUYVK34e4ShHLd4nYGBdB3yxX4BBkS-woxBnmCuj_6vUisg@mail.gmail.com>
From: "Yu Kuai" <yukuai@fygo.io>
Message-Id: <4ff43e8f-6405-4ce8-8cdf-f71e0bce4d3f@fygo.io>
In-Reply-To: <CAF-RUYVK34e4ShHLd4nYGBdB3yxX4BBkS-woxBnmCuj_6vUisg@mail.gmail.com>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/5/21 15:08, Xiao Ni =E5=86=99=E9=81=93:
> On Thu, May 21, 2026 at 9:25=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>> Hi,
>>
>> =E5=9C=A8 2026/5/1 19:46, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>> Detect the error path using md_cloned_bio() instead of relying
>>> on r1_bio in raid1 or r10_bio->read_slot in raid10, which may be
>>> NULL or -1 after splitting and resubmitting a failed bio.
>>>
>>> As a result, the error path may not be recognized and memory
>>> allocations can incorrectly use GFP_NOIO instead of
>>> (GFP_NOIO | __GFP_HIGH), which can lead to a deadlock under
>>> memory pressure.
>> I don't think this patch will fix this problem. Because split bio
>> is a new bio that will be resubmit by md_submit_bio(), such bio is
>> not a md_cloned_bio yet until md_account_bio().
> Hi Kuai
>
>          bio =3D bio_submit_split_bioset(bio, max_sectors,
>                            &conf->bio_split);
> bio_submit_split_bioset returns the split bio and the remainder bio
> will be submitted again which is already a md_cloned_bio.

Okay, I understand now this is a special case that current->bio_list is
NULL. However, the problem still exist in the case original IO split again
while resubmitting, and in this case current->bio_list will be set so new
split io will be resubmit by md_submit_bio(). Which means patch 1 can't
fix this case as well.

Perhaps it's better to check task_struct instead of bio_set.

>
> Regards
> Xiao
>>> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
>>> Fixes: 545250f24809 ("md/raid10: simplify handle_read_error()")
>>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>>> ---
>>> This patch depends on patch 1.
>>>
>>> Changes in v2:
>>>    - New patch.
>>> ---
>>>    drivers/md/raid1.c  | 13 ++++++++++---
>>>    drivers/md/raid10.c | 20 ++++++++++++++------
>>>    2 files changed, 24 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index cc9914bd15c1..c52ecd38c163 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -1321,11 +1321,18 @@ static void raid1_read_request(struct mddev *md=
dev, struct bio *bio,
>>>        bool r1bio_existed =3D !!r1_bio;
>>>
>>>        /*
>>> -      * If r1_bio is set, we are blocking the raid1d thread
>>> -      * so there is a tiny risk of deadlock.  So ask for
>>> +      * An md cloned bio indicates we are in the error path.
>>> +      * This is more reliable than checking r1_bio, which might
>>> +      * be NULL even in the error path if a failed bio was split.
>>> +      */
>>> +     bool err_path =3D md_cloned_bio(mddev, bio);
>>> +
>>> +     /*
>>> +      * If we are in the error path, we are blocking the raid1d
>>> +      * thread so there is a tiny risk of deadlock.  So ask for
>>>         * emergency memory if needed.
>>>         */
>>> -     gfp_t gfp =3D r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
>>> +     gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
>>>
>>>        /*
>>>         * Still need barrier for READ in case that whole
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index 3a591e60a144..8c6fc398260e 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -1155,7 +1155,20 @@ static void raid10_read_request(struct mddev *md=
dev, struct bio *bio,
>>>        char b[BDEVNAME_SIZE];
>>>        int slot =3D r10_bio->read_slot;
>>>        struct md_rdev *err_rdev =3D NULL;
>>> -     gfp_t gfp =3D GFP_NOIO;
>>> +
>>> +     /*
>>> +      * An md cloned bio indicates we are in the error path.
>>> +      * This is more reliable than checking slot, which might
>>> +      * be -1 even in the error path if a failed bio was split.
>>> +      */
>>> +     bool err_path =3D md_cloned_bio(mddev, bio);
>>> +
>>> +     /*
>>> +      * If we are in the error path, we are blocking the raid10d
>>> +      * thread so there is a tiny risk of deadlock.  So ask for
>>> +      * emergency memory if needed.
>>> +      */
>>> +     gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
>>>
>>>        if (slot >=3D 0 && r10_bio->devs[slot].rdev) {
>>>                /*
>>> @@ -1166,11 +1179,6 @@ static void raid10_read_request(struct mddev *md=
dev, struct bio *bio,
>>>                 * we lose the device name in error messages.
>>>                 */
>>>                int disk;
>>> -             /*
>>> -              * As we are blocking raid10, it is a little safer to
>>> -              * use __GFP_HIGH.
>>> -              */
>>> -             gfp =3D GFP_NOIO | __GFP_HIGH;
>>>
>>>                disk =3D r10_bio->devs[slot].devnum;
>>>                err_rdev =3D conf->mirrors[disk].rdev;
>> --
>> Thansk,
>> Kuai
>>
--=20
Thansk,
Kuai
