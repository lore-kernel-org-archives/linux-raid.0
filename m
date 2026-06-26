Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F5E2D7393
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 09:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782466564; cv=none; b=vGmKfuIEbP6KgRencFuk+y4ZjvZ3z39YCscv0cb1ZrKoahW6mJsGvLebG0tIKw8Ubv2ymOC+Zq2NtVXFFzndkB+Ro+MkrSk6hEzfZzMWR49uDg8jk6AsGk3m7SqhYwUcfQtcVsdTtAaDGYMClFC5ZH+RlUrPHs8BQPjKX20W7wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782466564; c=relaxed/simple;
	bh=BrMd2r1//CdBzorRKMZmhZod4lpS+Btb21odTuXfvt0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pCG9LpXnp+vNGT+FpbpzgRKRn0igtaOLfU0nsAf5fw/asTGBQhg55hkZTS5DJexNVxxEFh0KqxME8CqEVa09tsC74dy6yg0+IsOU+Y7sZcDWdjD7wyc6rR4V6AbFzxWPmiuK3zVBRx3U7U5E53DSgF3Fn4D4a3jeHj0d+dr+3nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cs5DbtYA; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cs5DbtYA"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4926d6b177eso1514285e9.1
        for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 02:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782466562; x=1783071362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2QrRtslok8RyYJ6MbOn3soQpg68BNlnF1V0N+/oIKVs=;
        b=Cs5DbtYAs4e+aDQMazdnQfpES/lCu1WLCW5wfcUTHG50Ift75LFSodKJvKJdifRT6Y
         8b1wpMu0eJ3H+VXmy+bHZlzYBGYrLqxqrYpkRpjCCDqawnOqql0x2E2i6T+Tye3ucjAz
         jpktHnj3OSOapwDfcllLUdMoxEEVV6QWO3tjzsf6ktKnZzYxvCPk4u0oZ31quW14RURT
         5D0YutlUJ39ZZT8mUV9J7QjLr4pLqZ1hZkdkqvhCLOiW7GjsvuSFJA0yZXAQf0ShsJU0
         tjGdI4BIx/i7SoyyBIMVplJq6+ddd6qc/+9osyMtn6V6BoDhcPCV+ZUs4J1IHSVB+NN5
         Ww6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782466562; x=1783071362;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2QrRtslok8RyYJ6MbOn3soQpg68BNlnF1V0N+/oIKVs=;
        b=EOGNmtysFlBPF5fQplSJvaxfnIv1g5TmKeZ7FF6OeN81otY1yTkjtSQUfGIWUCsnhW
         vW3XUU4QQMNV6gFb6FySOySFW9yCdzgRfeHCSjWSWI10/UtfsJhPRsBB+S4EZ+hRpf5a
         PYwQfNUC4HFjRFnbmr0ak34hrEiKFJlMWWizTmKmV0KXBhenvPautQHDH5BJyTfDDEjm
         E+D3gHt/mX14FKgUr76VHO4zciUHNXgnxoX4kD7YB6L6gizPRtC0SVzU5SfEhGvh69F9
         RpdQD3ykMFlWsUdgD4+oZeWTR/8gCewRYwhQ/NDcNLbePH2whJskNeCWH2VwyVUr/3G/
         bfhg==
X-Gm-Message-State: AOJu0YxjBeLVkN6hvapf0MG8VexzAW27vQZ7JM4Vo8zIcdM9F777VPZ7
	xw9matmuRUUl6AA78WJtFrAIh2IAO9dxDqJh3awaPrUpYp3QDd7txNEq
X-Gm-Gg: AfdE7clQFZEs0esInDnot99uY6FtyGis+f/Jn8LNSUH10t1Of8fEu//7fe7fjfh3J3v
	LiD7Au0QNBOJsKzdsa8oaTBdfCoWI2aOF11D+KnAkeXj0gNZ5lsfQDYQP+l+DfA+olzhjpg8wdz
	85a/PYchnJRgklM4H7yy4pFb0MjaMhr3ToGX6lluoY7/v+FFbK12szQpA3FoFUrXJLPDWBj79dl
	MlJlknLZXCQ3xyJvW0MlgeHfxd/Y9CSG6Abf9cFPHNuCmt/Wl+sro/tDV4lDLWKhx1E/l0w/+r+
	vtGWPeJDAjEZfIfVLsjZKx2sp9XSg+KFdtty9W4LIoa0BKooygXXboYXTta+5BstjUjxPZCdBud
	GUlBtS3rKDZWrTYHuAkgxNOtrIQOYUMjWF1B4kpwwhXvna2HiTGA42bQwCEwdMrme1BK7v+659j
	Lbc82bzZ1sF9NfXDfXIWYih73St55YXJCzHBTtyiElmRfXIA==
X-Received: by 2002:a05:600c:8716:b0:490:bc46:1a58 with SMTP id 5b1f17b1804b1-49266880f2cmr88340965e9.18.1782466561400;
        Fri, 26 Jun 2026 02:36:01 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.190])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49269002511sm64340415e9.8.2026.06.26.02.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 02:36:00 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, song@kernel.org, magiclinan@didiglobal.com,
 xiao@kernel.org, axboe@kernel.dk, john.g.garry@oracle.com,
 martin.petersen@oracle.com, yukuai@fygo.io
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] md/raid10: raid10_write_request() drops the barrier
 before calling
In-Reply-To: <draft-m2h5ms1i5p.fsf@gmail.com>
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
 <20260623072456.333437-5-abd.masalkhi@gmail.com>
 <7239c50c-b257-4179-827a-9facd48e75e1@fygo.io>
 <draft-m2h5ms1i5p.fsf@gmail.com>
Date: Fri, 26 Jun 2026 11:35:58 +0200
Message-ID: <m28q811w5d.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

On Wed, Jun 24, 2026 at 10:01 +0200, Abd-Alrhman Masalkhi wrote:
> On Wed, Jun 24, 2026 at 15:23 +0800, yu kuai wrote:
>> Hi,
>>
>> =E5=9C=A8 2026/6/23 15:24, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>> bio_submit_split_bioset() and reacquires it afterwards. This is
>>> unnecessary because bio_submit_split_bioset() does not require
>>> releasing the barrier protection.
>>
>> Why is this safe?
>>
>> It's possible plug is not enabled in this context, and the allocated new
>> aplit bio will be submitted and enter wait_barrier() again. wait_barrier=
()
>> is not supposed to be called recursively. Otherwise deadlock can happend:
>>
>> t1: sync_thread grab barrier and waiting for nr_pending to be 0 from rai=
se_barrier()
>> t2: wait_barrier() first inc nr_pending, then recursive wait_barrier() w=
aiting
>> for barrier to be released.
>>
>
> raid10_write_request() is only called from the bio submission path and
> not from raid10d thread, so we do not re-enter it while already holding
> barrier. Therefore, the split bio submitted by bio_submit_split_bioset()
> cannot recurse back into wait_barrier() from the same execution path.

I looked at commit e820d55cb99d. At the time, it addressed this issue
because submit_flushes() called md_handle_request() directly. Since
v5.2, submit_flushes() has gone through submit_bio() instead before
submit_flushes() was eventually removed.

Today, md_handle_request() is called from md_submit_bio() and dm-raid.
I don't have much experience with dm, but at first glance it seems safe
to remove these calls. However, if md_handle_request() were ever invoked
from a worker thread or kthread, we could run into the same kind of
issues, not only for RAID10, but also for RAID1.

What do you think? Should I drop this patch and guard RAID1 as well, or
is it safe to assume that dm-raid cannot hit this path from a kthread
or a workqueue worker?

>
> The situation is different for reads, where raid10_read_request() will
> be called both from the submission path and from raid10d. There,
> dropping and reacquiring the barrier protection remains necessary.
>
>>>
>>> Remove the redundant allow_barrier()/wait_barrier() pair around
>>> bio_submit_split_bioset().
>>>
>>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>>> ---
>>>   drivers/md/raid10.c | 2 --
>>>   1 file changed, 2 deletions(-)
>>>
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index 840f0446c231..4bc1d5553ec7 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -1493,10 +1493,8 @@ static bool raid10_write_request(struct mddev *m=
ddev, struct bio *bio,
>>>   		if (atomic)
>>>   			goto err_handle;
>>>=20=20=20
>>> -		allow_barrier(conf);
>>>   		bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
>>>   					      &conf->bio_split);
>>> -		wait_barrier(conf, false);
>>>   		if (!bio) {
>>>   			set_bit(R10BIO_Returned, &r10_bio->state);
>>>   			goto err_handle;
>>
>> --=20
>> Thanks,
>> Kuai
>
> --=20
> Best Regards,
> Abd-Alrhman

--=20
Best Regards,
Abd-Alrhman
