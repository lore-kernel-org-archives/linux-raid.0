Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26813B71DD
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 21:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782682512; cv=none; b=bkDvrHX2i8k6vPz2id7uLLBn4iXF7PpzOgLbM50Dv7Vidh5aE7LEMP8g+G8Qmjq/EVLAkFAIEKt5QgQ/gO7nr894Rt/IOAdSiHwgrAkQHeG/1tz2nxUvdtSeeQxCsatRfXZ4bkMStyPg/37R4GmnIeBJn7J2x+Ofa9Nh2KHdCck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782682512; c=relaxed/simple;
	bh=g0M6Gwoyc38onI+2UIz19L5eRvWvC+eUuXD2IhLd5rI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=d44n8u+zMXOQXx+InGMihbg5nYDQTv2jJoDD4pQGWKRmrsrnPCtjZdDjQ2k4S9OxQwGqIYsIDV0yH9vEzXjsjByD9AJz/eCeivoh1QYTO/QPg/ZlbxU2uoqATMIybzE9N+XuRyktgeJH0JTB2qjqZmeaZIXar+3jCZoExB/bCMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BtFBfgn6; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtFBfgn6"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47362928f65so326260f8f.2
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782682506; x=1783287306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9LXqxr2JxWOgeCvYiMaDiXo7ssMBku/dDXWkHsZyng=;
        b=BtFBfgn6NUmhQH6RQLVaniJr/sZqJ0fwdXH+5MiJwrSr1hgYksk0/lsYbvAjcFGS+R
         uvDRKxQk9HEUXUydGLW8VeA5bBpM6D0uXDpvlUsSsAW1Ig6+rcbfpo7LGwYg8JLS6neN
         abcQLT5L/13Jo2lizmhU2+nnCumDUBbdcRe05+Vk+5lotRjsveYZnPxppaGUjRpLcGai
         T2LMTbvGX+WlW4/V1bnR7VMV/v4B5ZzRbI9MdIzDxQzqXg/sGJS6F8iYxJMC4aX6zc4b
         8rGo317QhL023qhS+cnu0OS8JfIWIMaAEU3OWI6lenGqpKPKPYF3M2EyBlxyzaHPp380
         8suw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782682506; x=1783287306;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C9LXqxr2JxWOgeCvYiMaDiXo7ssMBku/dDXWkHsZyng=;
        b=qgmc/AmJOcV7/+85hc9DgjG/FlQvwSPBOPZ3KDuzJ+e8QrnG8pTUvb+IobkzEmxx31
         3X5Fqn53pFvBKtuqXnna5GFHt06sszCznQ0iGyiMYypNhfuBjH19qTMDYEeWoe3ylc4m
         XtCjOJeHWA9qtMEdXpgbyGk6blVkzR5GccSvgRNa6sxEH/HogWTEhJaUEYgBGAMQ7jUt
         iWmgG5FPC2siVCzeldTnTxPrXPKdXhJxP3fofxUskKnZpeNbAkG9zkbKR9J/LygTbCAN
         DM9W3E7MbUl5cpgfbdnnQzPHfpakaLztHvV1+13NT5UbtLgUan/9lQoTdqburLcLSNtd
         iQWA==
X-Gm-Message-State: AOJu0YxUAN63xnXzxnCoqXm+m/UmkjyEEt6s2oiO0m0BHUTCK2fCsN5u
	HAIVYED/FflZy0hvER0Y4O6r/GRE1316xrqnEEhjvgNWelHbGe1a+zgO
X-Gm-Gg: AfdE7cnNAEozhQUQYmKAacpmCuoSY9ND9aOTlAz8uuAPfPPgDxqoPAeqAYUFOQfaMUc
	7Jbq+oCVxQgb6e/PvHRIfP1cr8OGHSHEEPIe3FDuB2vVM2OfvjQpfp9YuLv12V9TDnJ0cZU7AtD
	yXnEk/4dkcI/kwcxSM8nCExowlwQVy3Qc/SBfPwYS2IvgOFLFmm/NiRVnZsxjbwwNzvmSRmXACx
	0XKKHPqaOJNBxpscy1rN1Yz00GIuoCI52ZAshDxJXr6N3carMo9LfyxpLLBOLuME777lcYHaPKY
	dKn/2m8OStYQL2TDtslOA4Z9VGFnDuRWhDIJ/Mm/M/SZoR/evEGh39627HAi8WM++4kkFoREgvy
	lxW1LXdbE4QJty1BUHHpEjtHQuyGcl8qjEaSngXYUU8WzSFb1We/dw6PQbX/swli5/POJJHYAyx
	p4bPX8mTReP0SRjvrkiAXIiWMbUPtNFzUFZyuW2BI1v6YzwW2Sdwce9mTElnubJTIk
X-Received: by 2002:a05:6000:200c:b0:474:fb6:b049 with SMTP id ffacd0b85a97d-4740fb6b245mr501849f8f.38.1782682506187;
        Sun, 28 Jun 2026 14:35:06 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:668:70cd:15f7:baa:434f:df10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d93eesm42647287f8f.20.2026.06.28.14.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 14:35:04 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Subject: Re: [PATCH v2 3/7] md/raid10: consistently fail atomic writes that
 require splitting
In-Reply-To: <20260628143620.64A6C1F000E9@smtp.kernel.org>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-4-abd.masalkhi@gmail.com>
 <20260628143620.64A6C1F000E9@smtp.kernel.org>
Date: Sun, 28 Jun 2026 23:35:02 +0200
Message-ID: <m2v7b2z6ux.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

On Sun, Jun 28, 2026 at 14:36 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] The `err_dec_pending` (formerly `err_handle`) cleanup path in `r=
aid10_write_request` can trigger a NULL pointer dereference when a replacem=
ent device is promoted concurrently.
> --
>
> commit bc9d81fdb2c33f8c55baad27ab1eedf427ae25ed
> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>
> md/raid10: consistently fail atomic writes that require splitting
>
> RAID10 handles one badblock path explicitly by failing atomic writes with
> EIO, but another path can also reduce the writable range and force the bio
> through bio_submit_split_bioset(), completing it with EINVAL. This commit
> centralizes the check to fail all atomic writes requiring splitting with
> EIO.
>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index bd322eccdc3ff..3480fc7907f01 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
> [ ... ]
>> @@ -1493,6 +1484,9 @@ static bool raid10_write_request(struct mddev *mdd=
ev, struct bio *bio,
>>  		r10_bio->sectors =3D max_sectors;
>>=20=20
>>  	if (r10_bio->sectors < bio_sectors(bio)) {
>> +		if (atomic)
>> +			goto err_handle;
>> +
>
> [Severity: High]
> This is a pre-existing issue, but can this jump to the error handler caus=
e a
> null pointer dereference if a replacement device is concurrently promoted?
>
> In the error handler path, the code fetches the replacement device without
> checking for null or falling back to the primary slot:
>
> err_handle:
> 	for (k =3D 0;  k < i; k++) {
> 		int d =3D r10_bio->devs[k].devnum;
> 		struct md_rdev *rrdev =3D conf->mirrors[d].replacement;
> 		...
> 		if (r10_bio->devs[k].repl_bio) {
> 			rdev_dec_pending(rrdev, mddev);
> 			r10_bio->devs[k].repl_bio =3D NULL;
> 		}
> 	}
>
> If raid10_remove_disk() runs concurrently, it can promote the replacement=
 to
> the primary slot and clear conf->mirrors[d].replacement:
>
> raid10_remove_disk() {
> 	...
> 	WRITE_ONCE(*rdevp, NULL);
> 	if (p->replacement) {
> 		WRITE_ONCE(p->rdev, p->replacement);
> 		clear_bit(Replacement, &p->replacement->flags);
> 		WRITE_ONCE(p->replacement, NULL);
> 	}
> 	...
> }
>
At first look this looks unreachable, because raid10_remove_disk()
should only run while the array is suspended, which would drain the
in-flight write before any promotion. But that assumption does not hold
on the md_start_sync() path. The suspend there is gated on a lock-free
check of md_spares_need_change() taken once at function entry; we only
suspend if it returns true. We then call remove_spares()
unconditionally, regardless of that earlier decision, and
remove_spares() re-evaluates rdev_removeable() independently under the
lock.

So the suspend decision and the actual removal are sampled at different
times with nothing held across them. A primary that was In_sync at the
entry check (suspend skipped) but fails afterward becomes removeable by
the time remove_spares() runs, and raid10_remove_disk() then promotes
the replacement and clears the slot with no suspend in effect. Meanwhile
an in-flight raid10_write_request() that referenced only the replacement
(because the primary was already Faulty when it ran) can be sitting in
err_handle, and it reads conf->mirrors[d].replacement as NULL.

It seems real. I'll submit a fix addressing this issue.

> If this concurrent promotion happens, will rrdev be null here? It looks l=
ike
> other paths such as raid10_end_write_request() safely handle this exact
> race by falling back to rdev when replacement is null, but this cleanup
> path does not.
>
>>  		allow_barrier(conf);
>>  		bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
>>  					      &conf->bio_split);
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260628142420.10=
51027-1-abd.masalkhi@gmail.com?part=3D3

--=20
Best Regards,
Abd-Alrhman
