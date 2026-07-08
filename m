Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2403943E492
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 12:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783514587; cv=none; b=uvRztFWkzSewgEQa4eZFs03jw03IB52s1EZHnSS/KiP7NUoxhJhjLl1AoXeXaCIKWd4oitdKn501DyKYQXjm3DrCzLsxDspVHODWhZBULlFMDlfhCfSVwlx0t9WsDAvm/XsED3kItMsE1G4Hb6Ggn4D7h6tMWu91TnkR18t9euY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783514587; c=relaxed/simple;
	bh=JEKJH+45M0lAS4e8BrESH2HddDu9m0XdTLvwkxcOCAg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=sSI2yEXnDrMgSbqwRzRasxo6X4Ky8D/3t92kHg4dmHMujzOfvm6VQX7VTwEFmHjKk4K3yJCLUqv/ea0OvWDWv/pwHSUWPsnP4G/65N36rF1SnCDJ6CKGSnfnpqy1Sg0ur/KGXmx+L3LDt5zscmig+j3+IX4rXhB7jM1gG0DDfeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bqQ/0yRJ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqQ/0yRJ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493e4cccd8dso2628785e9.2
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 05:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783514584; x=1784119384; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lXhqjC53+0nMAHnQTmB39qOAgVWgrR2NT4dp6WKReNw=;
        b=bqQ/0yRJMNHS2yNHV9btVyvKz35V3Zt7ngSFxDCe4AZr41/Lt0bWkXzxNJJC/KGaB6
         M4cXfnbgcQop8KtBayhoB41JWdyIOMwEk4NsAvlbSWC3ca9IqaZz3ErxEcPsmmkt2qAi
         t/vDvcEjpwze+pZxy989dRq8frf2KjLovu0IU6DboZkMcK+ucdi2seDQvgA8jUXCwiZS
         2pOBDhgk1iarIVj/TroE2PTTNIIykbhA/9avyRJ9DKcnVT8Hy9koVyNyLrJApRms0wcJ
         oIoZ2drlEFbk05u/udfbjUFsE2UDoPlA2f06B1KArHcj2wIE5DMFdA2uBbbN+O7ZAon7
         OX+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783514584; x=1784119384;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lXhqjC53+0nMAHnQTmB39qOAgVWgrR2NT4dp6WKReNw=;
        b=NeTZXL2FbCqdQDOk5BBnlXxr8WxENLnE8zlXitMpHDz0he7SW2i8sZe4lk+kK0Kddj
         atpsgDJYtM6ASFNZeCHAj6Vq7psXzBlZW8AxeTLfuP0IgKIwn0F9PigYoamRmv16Go6h
         Ch7dhKw5laGoYo3cSaIB8QxJJyUj+7WiXePaWTfLSBb07N8zkCyEm8mr4+lv5PFoUXeb
         kRT73FWKkyTky4VYkgX7wBF7wJHtLKHF1Pht2dNh+66lwFGzf4o2u1UHntH2j1/6fRsr
         agw37TBSYAETxZsmuFLPeYzXXEbPxvKM7bevl4qGP05HZieEsKgtwdD2ijOedQh6T3qF
         PUUg==
X-Forwarded-Encrypted: i=1; AHgh+RphYunYvuMQV0DR4TLzvxhaaBWdvjU9ufE0DdwtQkLDkyrg646AYGv3Z15HkQ8pn318epbEI+B+viJR@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh2ZZ8AyhtE/KgTbxohI5CPKCOvrLvMkoiP58c8ligR3UkX6q+
	Qv+3XjjsNkTf529TR/tX+FkIj87+BdB0ER85G65A6X0CONImHdjHJhjbMfZ5Gw==
X-Gm-Gg: AfdE7cnMWR3jzErIg/nQDf7YqZI1Gi4jdpDDu03bet5umDX0RvQ8HYyY7u+RWz8TZGz
	zg1TofLUePnThmHvRfTmXEgp8pqIdTOxFO1PUDMqurTns22ljmGso9rhJmQ5gEpSmQyeI5C+kM+
	MCHflV6BHRXJ7W5AF0rdGyW8UHC0KDfXafCSjBOpwvE/Ig5asVDccEVdDAGja5bOD6IkoiFGfNt
	4+rEOZdL2hsdKJoI7RNSDgMs498MXkh/frK+Gg+lvLSP3VbJdwO0j+uLxgH5+5XKDTzNC67YVbN
	YIMYzIZSYsRw8aUcm0O8zZnydD9Ick+JJUv38ll4iAY1RBYcW1pCW+nyTRJk3FA3AZSt39ayGrG
	nAxggJAqEwYp9kdmBXCZB9u69XqrK691rELZGWo53KPntjl2ONi77c3xsJNBkAhl3jIX2o+XOq7
	qLaJ+ZDJxmloRG77Iw2D4svysoDE1m48mb7AjSWDAUjU/XZg==
X-Received: by 2002:a05:600c:4e48:b0:493:e6f7:ad9d with SMTP id 5b1f17b1804b1-493e6f7af7emr18974405e9.35.1783514584282;
        Wed, 08 Jul 2026 05:43:04 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0fbd355sm128111035e9.13.2026.07.08.05.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 05:43:03 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
Subject: Re: [PATCH v2] md: recheck spare changes before starting sync
In-Reply-To: <20260708113713.B77311F00ACF@smtp.kernel.org>
References: <20260708112003.474537-1-abd.masalkhi@gmail.com>
 <20260708113713.B77311F00ACF@smtp.kernel.org>
Date: Wed, 08 Jul 2026 14:42:55 +0200
Message-ID: <m2echdlkj4.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

On Wed, Jul 08, 2026 at 11:37 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Incomplete fix for a TOCTOU race condition causing a NULL pointe=
r dereference when modifying the spare configuration without suspending the=
 array.
> --
>
> --- Patch [1]: [PATCH v2] md: recheck spare changes before starting sync =
---
> commit 0ddb3cd53c96b4255d51183f6d5da4fcd8b938bf
> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>
> md: recheck spare changes before starting sync
>
> This patch aims to fix a race condition where spare configurations are
> modified without suspending the array. It adds a recheck for spare
> configuration changes after acquiring the reconfig_mutex to avoid operati=
ng
> on stale states.
>
> Link: https://lore.kernel.org/linux-raid/20260630075640.1081634-1-abd.mas=
alkhi@gmail.com/
>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -10181,13 +10181,25 @@ static void md_start_sync(struct work_struct *=
ws)
>
> [ ... ]
>
>>  	mddev_lock_nointr(mddev);
>> +
>> +	/*
>> +	 * The spare configuration can change before reconfig_mutex is acquire=
d.
>> +	 * Recheck while holding the lock and suspend if needed.
>> +	 */
>> +	if (!suspend && (mddev->reshape_position =3D=3D MaxSector || !md_is_rd=
wr(mddev)) &&
>> +	    md_spares_need_change(mddev)) {
>> +		mddev_unlock(mddev);
>> +		mddev_suspend_and_lock_nointr(mddev);
>> +		suspend =3D true;
>> +	}
>> +
>
> [Severity: High]
> This is a pre-existing issue, but does this recheck completely close the =
race
> window?
>
> If a faulty drive has pending I/O, md_spares_need_change() will evaluate
> rdev_removeable(), which checks atomic_read(&rdev->nr_pending). If that is
> greater than zero, md_spares_need_change() returns false. This causes both
> the initial check and this new recheck to bypass suspension.
>
> If an asynchronous I/O completion happens immediately after this recheck,
> nr_pending can decrement to 0. When md_start_sync() continues and eventua=
lly
> calls remove_spares(), it will re-evaluate rdev_removeable(), find
> nr_pending =3D=3D 0, and remove the disk. This nullifies the disk pointer.
>

Shouldn't the Blocked flag guard against this case? It is set before the
Faulty bit and before nr_pending is decremented, and it should only be
cleared while holding reconfig_mutex, or am I missing something?

> Because the array was never suspended, couldn't concurrent I/O re-read the
> nullified pointer and crash? For example, in drivers/md/raid10.c:
>
> err_handle() {
>     ...
>     struct md_rdev *rrdev =3D conf->mirrors[d].replacement;
>     ...
>     if (r10_bio->devs[k].repl_bio) {
>         rdev_dec_pending(rrdev, mddev);
>         r10_bio->devs[k].repl_bio =3D NULL;
>     }
> }
>
> If rrdev is fetched as NULL due to the concurrent removal, rdev_dec_pendi=
ng()
> will dereference it.
>
> Could remove_spares() be restricted to only remove drives if the array is
> actually suspended, or should suspension be enforced earlier regardless of
> nr_pending?
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708112003.47=
4537-1-abd.masalkhi@gmail.com?part=3D1

--=20
Best Regards,
Abd-Alrhman
