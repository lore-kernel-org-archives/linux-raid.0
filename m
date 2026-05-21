Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1033655F0
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 09:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354888; cv=none; b=g8LaqNcROAGUykea6RbxIW4yqcv6UpKekesrNSDg0fz4R3MgHLXcd7NtOtIpOg1wavGgQf/+4yo2XTDHOqrevBgioAd/LpZj9D2LuDY1VoY3I5PB2KlimIPocIlfh6Sv31V7l8Lnk+CSKNCvM0YYK1Qz5aWRw++16meN2NpGKCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354888; c=relaxed/simple;
	bh=11TOhBThyaFqatFbKkDggL/V/hCy1o9LVQxdy+MS0QY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Kict/psS4CwmoYkv9TDDm07lXy7Weu+zYVC0na99LNatkaI+TYUuoLj5+Rz0GF1TMgtgpPzxNZ18HGznrGfNJGoEyo059ukjHinHHUbTWJe1N+6dXBG5Q/106hRL2/bRvWR9bTtUVANCVGJ7nAtgWNOOhq3SxYG9R4zyTIrXnJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K7sa8heI; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K7sa8heI"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48fe26a177cso43671975e9.1
        for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 02:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779354883; x=1779959683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/oRmnfvuiPx8cdoY/Q+DT96EWfnmml5NIWEe45HHm0g=;
        b=K7sa8heIHdb5shfVezjOVbXbCCdzhLgp8L8XYOczfMeONMeqV/AVZEsJYRU4Gg2ylW
         WsqnT3YqeCAWJJEhYtQncslnx4FywrDrjq7MBsARi2gY/Vx1ZEy1iV3wgnbvjqVJMl6A
         AwrTkwOt3VBxOWv8YRzx/iqurNA8H85dv9p1QdEy83wLwgg8ber5es9zMEmWM0BnO2EL
         Hxd9naedgSsoKFWi1t2r2lEdKY2mwhkKvDFl56oVDbiXP8cHK+U7nvm8tWUA5XkooDGq
         XdCCt4HYfKUzrIgNYVoBxL3yerz8kg3xg+RqOuUdCmZriOULv/e4Igs2lhzoWWV2NgnG
         MVCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779354883; x=1779959683;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/oRmnfvuiPx8cdoY/Q+DT96EWfnmml5NIWEe45HHm0g=;
        b=qZruv62LwnFSKOmqiL7htT+4IiNYmLj9Kz/EBL89SgwwlqOAzBhmQJJIw9x4wsUcrm
         RU6o8s2dSzx6tJGw01mAacqxOIb4b3zR1bDcgv7ln+m8LBEvFJ0pUEPyuxpqBcBqZh+Z
         q/4NHgu61iwLVt2IfqoDjO0VHC4ZcDr/v7SpgW2mALf9qGcWy+/680odLCrwbyJay5FA
         DVnsstFWzHsLCRcnLg0j3PDhoaHGYgupPTFloNfKccC2NDcZrdq4yvF7TWUs0rPVCgy+
         3hA2IdUqPo5LCWSYvZpHR0ImcQQvbrBrIQQWdIBhVZu+Zm1EmxCur8qWCDOURjpNv+Ca
         Ixvw==
X-Forwarded-Encrypted: i=1; AFNElJ+jWOMb5GpnpcGkfVB2heYQvtJVbNuVIeQRovWPxjU4oorJ8QqTg1fKvDwf8wEydDvhRQlom66/rE2+@vger.kernel.org
X-Gm-Message-State: AOJu0YyqnNvYu+mFXVGQNlKqerJMPJha/6WmRSVnVjxEHqmZSmbuiNYs
	F1Zh4UqK+rsb7qJrcRbS4vA4znpzsFX+61jIvXrSuHeFh3Hg0ntIWCRP73uwMQ==
X-Gm-Gg: Acq92OFLtOj1sB0aMjKUsaN0w979Gzr463rOoX4r3dOL+rtT/8Zzv7kKN4NKUnnWPED
	qcgdshaQnF9ML4M63Gz02oJL9uChC58zEEZqeIBABZiblaeUv8oHD4mZnsHosrMtanjk19U1sO6
	weE4hcshVf0KCJj9Zs41Gqof25lxqySbmdgigFv7Q7NFWqjuv2Pua+dUfpLJHNNHXljtP7qq/Tm
	KwTbVjrtwk0J37Yc4abBZ64brNA3Y4q79R/DavWw15ArEivObtI4M57iHOR8F+Wmmx0EQSf3TMQ
	S/TCEbxxpC9RdKgvc9WHslxTR7yz8eniDw3/Cu7/NeJ3eo3ZoA9+YmRu7ZhjozvWgnvtmUmzOL4
	O8dKpeddIwt9E2ltrUzFR6qkOmBIlbENfheBVJeG7GSClCxw0nJb7uplB63VZm6dzBo74vD1KQM
	F25BiCu4hVK32L1O5orcMLxV70ya2juk0bJjYHrOXKUZ3Vhs1rIeiX24fmRJEUd1VLPpno9N4XP
	ulmjlX8TRE7aw==
X-Received: by 2002:a05:600c:450c:b0:490:320:949 with SMTP id 5b1f17b1804b1-490360e3332mr24941675e9.27.1779354883020;
        Thu, 21 May 2026 02:14:43 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:623:1f9e:495:7d00:e34a:1c98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4903c995f13sm12648805e9.3.2026.05.21.02.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 02:14:42 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Yu Kuai <yukuai@fygo.io>, Xiao Ni <xiao@kernel.org>
Cc: song@kernel.org, xni@redhat.com, neilb@suse.com, shli@fb.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai@fygo.io
Subject: Re: [PATCH v2 2/3] md/raid1,raid10: fix error-path detection with
 md_cloned_bio()
In-Reply-To: <4ff43e8f-6405-4ce8-8cdf-f71e0bce4d3f@fygo.io>
References: <20260501114652.590037-1-abd.masalkhi@gmail.com>
 <20260501114652.590037-3-abd.masalkhi@gmail.com>
 <71990de4-1113-4b7d-8a50-ca1d82802a03@fygo.io>
 <CAF-RUYVK34e4ShHLd4nYGBdB3yxX4BBkS-woxBnmCuj_6vUisg@mail.gmail.com>
 <4ff43e8f-6405-4ce8-8cdf-f71e0bce4d3f@fygo.io>
Date: Thu, 21 May 2026 11:14:36 +0200
Message-ID: <m2pl2pkttv.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai

On Thu, May 21, 2026 at 15:29 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/5/21 15:08, Xiao Ni =E5=86=99=E9=81=93:
>> On Thu, May 21, 2026 at 9:25=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>>> Hi,
>>>
>>> =E5=9C=A8 2026/5/1 19:46, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>>> Detect the error path using md_cloned_bio() instead of relying
>>>> on r1_bio in raid1 or r10_bio->read_slot in raid10, which may be
>>>> NULL or -1 after splitting and resubmitting a failed bio.
>>>>
>>>> As a result, the error path may not be recognized and memory
>>>> allocations can incorrectly use GFP_NOIO instead of
>>>> (GFP_NOIO | __GFP_HIGH), which can lead to a deadlock under
>>>> memory pressure.
>>> I don't think this patch will fix this problem. Because split bio
>>> is a new bio that will be resubmit by md_submit_bio(), such bio is
>>> not a md_cloned_bio yet until md_account_bio().
>> Hi Kuai
>>
>>          bio =3D bio_submit_split_bioset(bio, max_sectors,
>>                            &conf->bio_split);
>> bio_submit_split_bioset returns the split bio and the remainder bio
>> will be submitted again which is already a md_cloned_bio.
>
> Okay, I understand now this is a special case that current->bio_list is
> NULL. However, the problem still exist in the case original IO split again
> while resubmitting, and in this case current->bio_list will be set so new
> split io will be resubmit by md_submit_bio(). Which means patch 1 can't
> fix this case as well.

The original bio resubmitted via bio_list is not executing in the raid1d
thread context, so blocking on is_suspended() is correct and will not
cause a deadlock. The suspension deadlock risk only exists for
md_cloned_bio executing in the raid1d thread context in the error path.
And in this case it is always true that if we are executing in the
raid1d thread context the bio will already be a md_cloned_bio on entry
to md_handle_request(), even if current->bio_list was set, because (and as
@Xiao has mentioned) every time we split a bio in the error path we are
resubmitting the md_cloned_bio remainder, never the original bio.

>
> Perhaps it's better to check task_struct instead of bio_set.
>
>>
>> Regards
>> Xiao
>>>> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
>>>> Fixes: 545250f24809 ("md/raid10: simplify handle_read_error()")
>>>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>>>> ---
>>>> This patch depends on patch 1.
>>>>
>>>> Changes in v2:
>>>>    - New patch.
>>>> ---
>>>>    drivers/md/raid1.c  | 13 ++++++++++---
>>>>    drivers/md/raid10.c | 20 ++++++++++++++------
>>>>    2 files changed, 24 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>> index cc9914bd15c1..c52ecd38c163 100644
>>>> --- a/drivers/md/raid1.c
>>>> +++ b/drivers/md/raid1.c
>>>> @@ -1321,11 +1321,18 @@ static void raid1_read_request(struct mddev *m=
ddev, struct bio *bio,
>>>>        bool r1bio_existed =3D !!r1_bio;
>>>>
>>>>        /*
>>>> -      * If r1_bio is set, we are blocking the raid1d thread
>>>> -      * so there is a tiny risk of deadlock.  So ask for
>>>> +      * An md cloned bio indicates we are in the error path.
>>>> +      * This is more reliable than checking r1_bio, which might
>>>> +      * be NULL even in the error path if a failed bio was split.
>>>> +      */
>>>> +     bool err_path =3D md_cloned_bio(mddev, bio);
>>>> +
>>>> +     /*
>>>> +      * If we are in the error path, we are blocking the raid1d
>>>> +      * thread so there is a tiny risk of deadlock.  So ask for
>>>>         * emergency memory if needed.
>>>>         */
>>>> -     gfp_t gfp =3D r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
>>>> +     gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
>>>>
>>>>        /*
>>>>         * Still need barrier for READ in case that whole
>>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>>> index 3a591e60a144..8c6fc398260e 100644
>>>> --- a/drivers/md/raid10.c
>>>> +++ b/drivers/md/raid10.c
>>>> @@ -1155,7 +1155,20 @@ static void raid10_read_request(struct mddev *m=
ddev, struct bio *bio,
>>>>        char b[BDEVNAME_SIZE];
>>>>        int slot =3D r10_bio->read_slot;
>>>>        struct md_rdev *err_rdev =3D NULL;
>>>> -     gfp_t gfp =3D GFP_NOIO;
>>>> +
>>>> +     /*
>>>> +      * An md cloned bio indicates we are in the error path.
>>>> +      * This is more reliable than checking slot, which might
>>>> +      * be -1 even in the error path if a failed bio was split.
>>>> +      */
>>>> +     bool err_path =3D md_cloned_bio(mddev, bio);
>>>> +
>>>> +     /*
>>>> +      * If we are in the error path, we are blocking the raid10d
>>>> +      * thread so there is a tiny risk of deadlock.  So ask for
>>>> +      * emergency memory if needed.
>>>> +      */
>>>> +     gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
>>>>
>>>>        if (slot >=3D 0 && r10_bio->devs[slot].rdev) {
>>>>                /*
>>>> @@ -1166,11 +1179,6 @@ static void raid10_read_request(struct mddev *m=
ddev, struct bio *bio,
>>>>                 * we lose the device name in error messages.
>>>>                 */
>>>>                int disk;
>>>> -             /*
>>>> -              * As we are blocking raid10, it is a little safer to
>>>> -              * use __GFP_HIGH.
>>>> -              */
>>>> -             gfp =3D GFP_NOIO | __GFP_HIGH;
>>>>
>>>>                disk =3D r10_bio->devs[slot].devnum;
>>>>                err_rdev =3D conf->mirrors[disk].rdev;
>>> --
>>> Thansk,
>>> Kuai
>>>
> --=20
> Thansk,
> Kuai

--=20
Best Regards,
Abd-Alrhman
