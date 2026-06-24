Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF3A3A9624
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782288761; cv=none; b=YPHZTnqAxM1YB5reF0c7470Xa9ETuGbTKJ4CVQwFjapLkpBHaLuZPylLnJjdodMDQDkFB+L9fIrYJDZGodmJbv7VvX6raDvwvFAIyrJbvGSsk7rsXSpE0jdjMj1fciR3RdnACXu0hZatKVPTlTHGDEVWeiIHIHFhHwT2dX6pad0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782288761; c=relaxed/simple;
	bh=kDceYG3/TLAjXyKwcJpP88lKt6M1l3v2ftJZp66lxzI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=m12IQFCw07xoKuLeLsW+bc7l5ZpDDasiXroRFXFPHAzkM/FENiEiP8RrBF6+jiULiRrMkluzCTMwbFmWyUt6UuOqkcZPwl7AHSKUKA1z18iTO1aRJ/mHqTWgF7fwe9ecBj7ItYy3ZH+YEl0sHHH7oxiN9GO17+jEa4R8icfgjqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6mFlVNx; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6mFlVNx"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-461edb387ddso828190f8f.3
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 01:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782288757; x=1782893557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mrhljFF96ju8Gx+nYRs6h2vCz/Hl+SeggodLEe08vOA=;
        b=f6mFlVNxa8qfs7mjutCiXjJL/FLUoei6uM5XqFmtlbHR1FzNHljPzs9OSZnY0bobrQ
         h3iQS8IhE7OWVndMahsVQ7fw6QnIxiFpK+VC4Nz1iXUB6E3J97v8IdCMBLM9m+T3+PFs
         RzdcK0CPxxyubG7WDSCMLuaw+IdZLwJjO4LLpfwMW7yj/MpzFUy3vikw+r4Y1wSkPzj9
         6KTIXCeFVibHzawn8sX/aAAujQVd91HOzyUVt0S8Et+/QNILnu7r5mF+sKe71aFPWsgE
         4KN/jD3J/ZlZD77+w/+UPGq7GZ6eK+YcYClOwnlqI36LicH+c9H/RInnv6+ShH/I3eF5
         ecCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782288757; x=1782893557;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mrhljFF96ju8Gx+nYRs6h2vCz/Hl+SeggodLEe08vOA=;
        b=iBG7wHEsmhhD7wYEuKOI03JPnKl4RfKpCH4pfLwAqRtmNy0p4B3ueFtyQDlje7Ifzc
         wo7qgZ2Ed7Pt3cRmIwg1Ecg0A/xpxaEKp0IR0n87f0YWAk1YB4ArKOLlyT+Dr2QHcK1g
         yuJDOYhjQOkaYS7iyWFD/iUa0XOZOvYvYYUhvsUMjc8fjq/CpRni1j+S5+slmK2ruFea
         O3bmPvS0PhRon4VF0PA4d6XkvnJ7xZm/glyEqFyig6UasFiWe4U13I9DQ8zBUN6fMOub
         cj2MczTk3Ms7fhoXSLM1Ub7n3jxGLVhB3uWVgFly7wk10NW/s7f+8bO7cdgdTVhDIxLN
         /zVg==
X-Gm-Message-State: AOJu0Yxl57mpk1vpeD/Li/SWB555uPDFF1xza7i4M2s9gybsYgnlUGyd
	u7w0Glp+a+rQ9zVvVPvdXwU/TdRbkFSZ42GhBFSrcyWxtf5iEoOTdubE
X-Gm-Gg: AfdE7ckcdS03M9KDO2GKTZLlnacBUJi77lklk1VsbMHL0p2Nx3Gt/JCph0qIDsTGtH0
	fWXJg9FYUsBSIiPE4Xc9NAk4lWP6KRPRHvdZIOpm2npCGFHkD0Dkw2sBnupxyLd6frk/mBeVjcA
	ZEyTLbx2Py7WGwhu0YHHsQ6TbJ5sJ+AazvSlbOy4qqZ2Ozb7HKp8DORgNyRR8DPRRxwuODzT8rh
	eMQu7vblKDG3X2q1qp5CguHBrSBuoJ3CdOOBwEr2PgJ6ITW/70R136LZB0k8W8oQ9Mh4r3qozru
	8iwE221vFpyF7SlVL+QhRJcRqPQjd4wY+3W6Vp6Ajpe5H/m25DhxifvwESNeQpf7hh6oRBEXMx1
	AZYKYCWukfQ1B2TkRCwCCic8qRlwVj7DT/y2DWuNOdkb/nP3givdcfpAG4AtjdRRvS7RponlHxv
	lRzFjEI2FsXw0m0xoeTU4UIucaXNU1sY5JRdGZU5jMvWaf5Q==
X-Received: by 2002:adf:f246:0:b0:461:cd9e:2366 with SMTP id ffacd0b85a97d-46c099f5b3dmr3072524f8f.13.1782288757055;
        Wed, 24 Jun 2026 01:12:37 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1e840f80sm5209933f8f.6.2026.06.24.01.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 01:12:36 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, song@kernel.org, magiclinan@didiglobal.com,
 xiao@kernel.org, axboe@kernel.dk, john.g.garry@oracle.com,
 martin.petersen@oracle.com, yukuai@fygo.io
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] md/raid10: raid10_write_request() drops the barrier
 before calling
In-Reply-To: <7239c50c-b257-4179-827a-9facd48e75e1@fygo.io>
References: <20260623072456.333437-1-abd.masalkhi@gmail.com>
 <20260623072456.333437-5-abd.masalkhi@gmail.com>
 <7239c50c-b257-4179-827a-9facd48e75e1@fygo.io>
Date: Wed, 24 Jun 2026 10:12:35 +0200
Message-ID: <m2cxxg1hn0.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kaui,

On Wed, Jun 24, 2026 at 15:23 +0800, yu kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/6/23 15:24, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> bio_submit_split_bioset() and reacquires it afterwards. This is
>> unnecessary because bio_submit_split_bioset() does not require
>> releasing the barrier protection.
>
> Why is this safe?
>
> It's possible plug is not enabled in this context, and the allocated new
> aplit bio will be submitted and enter wait_barrier() again. wait_barrier()
> is not supposed to be called recursively. Otherwise deadlock can happend:
>
> t1: sync_thread grab barrier and waiting for nr_pending to be 0 from rais=
e_barrier()
> t2: wait_barrier() first inc nr_pending, then recursive wait_barrier() wa=
iting
> for barrier to be released.
>

raid10_write_request() is only called from the bio submission path and
not from raid10d thread, so we do not re-enter it while already holding
barrier. Therefore, the split bio submitted by bio_submit_split_bioset()
cannot recurse back into wait_barrier() from the same execution path.

The situation is different for reads, where raid10_read_request() will
be called both from the submission path and from raid10d. There,
dropping and reacquiring the barrier protection remains necessary.

>>
>> Remove the redundant allow_barrier()/wait_barrier() pair around
>> bio_submit_split_bioset().
>>
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>>   drivers/md/raid10.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 840f0446c231..4bc1d5553ec7 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1493,10 +1493,8 @@ static bool raid10_write_request(struct mddev *md=
dev, struct bio *bio,
>>   		if (atomic)
>>   			goto err_handle;
>>=20=20=20
>> -		allow_barrier(conf);
>>   		bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
>>   					      &conf->bio_split);
>> -		wait_barrier(conf, false);
>>   		if (!bio) {
>>   			set_bit(R10BIO_Returned, &r10_bio->state);
>>   			goto err_handle;
>
> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
