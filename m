Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E9537189C
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 08:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784796241; cv=none; b=I22neKJaiN+xwAzDa1HdhCDBFyEMfaEpO4E1Ju6qqEksfohf00qfhdFt3tD3GBp6DTrP2LuRSbEEeFCJxyXMPf2uTddYfUD3qH3giixT2D+rQqjYyumUB3cQDgOUWhNmCaJTlh7dZXobpQX00TXyTxM6j2cJ3QCK6K6/6I/fAr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784796241; c=relaxed/simple;
	bh=RbE7d6gsctmm21faRui6ZAI00ChVGPRmhZtvFEqAfIs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Fb4WRCD2lVZvJNQzYVmlgc3pTqChQRPk0RX5gyQlpuf6c7G54cFEyh4wMBBceWyXNLUVNG5Kv1n2px9LWbk02YM3ir7YNVpPZUK2i4NE52QzzYcg1IhpVNLyykxIL6pc5JU9nZAQBzC9zHdAwuJhkTltPvHUbXGMjy2tfKJxwBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WzeiBrjH; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WzeiBrjH"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49558ce01afso2629425e9.1
        for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 01:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784796234; x=1785401034; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VBogyPWF3oFXvaSdHD3r/gmjurcyzCvj+SpCnxHnxhA=;
        b=WzeiBrjHbqoGm1QZhJa9n7wocDS6Gi83V7SS7HuywtDlb+a3pbEo4ojEuIrDW8RumU
         HL0I+rKKfFI8cP9I4rLc8zQhGMuGNCatO5tgz5SPxduAxubgUTYtTaOuxFoJI+95BfBU
         KwdTd9e2hG08aksFQYur6A20/Xwk9PcaCNvDQVVEbsyZCgVuHY2F/q0/L2T0me743FRy
         rVo6AzXSwoqkW9AJI0wwgWkLbvZCoyC8a1mm9GyblUcxezWcNSc760EitUr/mKNC11Ub
         brEbyXO67zEoRE7lA0GazvPjYCXm+V4bkogFE2HVAOny5xirUG+Dktxdpq62o4VCOYxo
         CLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784796234; x=1785401034;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VBogyPWF3oFXvaSdHD3r/gmjurcyzCvj+SpCnxHnxhA=;
        b=fii4fXz7Hfi5Xi7GYwCigGpkvHnx8/GCW32krXZaQM0wcD9nMY+sZ1TUqKFu4Dq3cR
         WQ8EaU4Lr4zJxR+tBSRx+ZyMaFn79qwWZyD01dfy9VKah7QLNt4S/pRJ78K5MBlgaR8D
         FpqMnzkqnVJxWeq1WScno48Vw/8VD/aNLERFgBqFtWZBdvBnxLyrOb9apy54Y5ptiiwX
         SwlJ2EW5n8M1FrOWc5MPCLtAdT5pQdmsK8thZhNXoR4bnJH8JI9Ys4yGg0FkEqrNEp8o
         wxSKsDYNENukLkvAeiSZvTd4uhs1q/SZNeSmHIpHAav2qxQZNJSScPr+kThE68+SzjN+
         RNAw==
X-Gm-Message-State: AOJu0YwYjGIrM+4Srevkw8xpNjpawN5IWqpKLywJeszsI7dyjTW5RzUc
	HImEdnJZk/DJOpfdTzHUJGUffZ9AzpucQqOpi41NkqMt2r0y9gB0P5AFYOM8Wg==
X-Gm-Gg: AR+sD10CMdUaMwX2rgBAcUZE/wtDcYqfYT8BPeHVtTlh3YWmK02xi3En42ZC24HA0wl
	0cROH9GUZqJnfvwZ+rS2p1YXiJp5aBXZhia3nap7C0UbD/QqDqAhekKZrhmBdUWURgOhrf3MC2t
	sadWj5q/cLuNnE5UGKKLlBl9yAXrftnl8COe3hBSEbjbAfzTsVoZyQK7xo4F3v+zpexYPRT1Ml1
	I4WadxWw86ftPm1usL+Q2+F2iaVrLWBpI2wUooDTI2+7j4fkndQYu+cliMxpHhG//gva3k1w7I4
	BhLAeNtz3iYEc6PQN0VA+ws6+mG4PPr3XkNSMYNUGuuvI9CAwvZb9/Hxu1iAu90OHPrg6OCprJv
	zfIlYqfhg6IjWx+prqeSEZHHXUR2hq8QyMKgtNckQQSQLG7GTLL46oRRh98JOvEAgqdBFs8hx29
	MqVj/9vnfL8pdFp9/hvTfL2yrNOkCyfLXx/5+6ZqaU1TFO
X-Received: by 2002:a05:600c:5657:b0:493:dcad:84da with SMTP id 5b1f17b1804b1-49573cb9344mr14293155e9.1.1784796234031;
        Thu, 23 Jul 2026 01:43:54 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:60f:13ba:30c7:a701:6d69:5fe1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956b01a758sm121394035e9.4.2026.07.23.01.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 01:43:53 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, song@kernel.org, magiclinan@didiglobal.com,
 xiao@kernel.org, axboe@kernel.dk, vverma@digitalocean.com,
 john.g.garry@oracle.com, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, yu kuai <yukuai@fygo.io>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 7/7] md/raid10: simplify read request error handling
In-Reply-To: <feae08aa-7ce3-4375-91d0-42d501627908@fygo.io>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
 <20260710101521.1714-8-abd.masalkhi@gmail.com>
 <feae08aa-7ce3-4375-91d0-42d501627908@fygo.io>
Date: Thu, 23 Jul 2026 10:43:48 +0200
Message-ID: <m2a4ridrjv.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

Thanks for the feedback.

On Thu, Jul 16, 2026 at 17:52 +0800, yu kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/7/10 18:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> raid10_read_request() currently handles bio completion, barrier
>> handling, and r10_bio lifetime management in several different error
>> paths. This results in duplicated cleanup logic and increases the risk
>> of introducing bugs in future modifications.
>>
>> Make raid10_read_request() return a status to its callers, consolidate
>> the read error paths, and free r10_bio from a single location in the
>> callers. Since the callers allocate r10_bio, they should also be
>> responsible for freeing it when the request fails.
>>
>> This makes the read path follow the same ownership model as the write
>> path and simplifies the error handling flow.
>>
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>> Changes in v4:
>>   - No changes.
>>   - Link to v3: https://lore.kernel.org/linux-raid/20260708101341.473750=
-8-abd.masalkhi@gmail.com/
>>
>> Changes in v3:
>>   - No changes.
>>   - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.105102=
7-8-abd.masalkhi@gmail.com/
>>
>> Changes in v2:
>>   - Fix a compilation error (bi -> bio).
>>   - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437=
-8-abd.masalkhi@gmail.com/
>> ---
>>   drivers/md/raid10.c | 45 +++++++++++++++++++++++++--------------------
>>   1 file changed, 25 insertions(+), 20 deletions(-)
>
> I don't think patch 6 and 7 are actually simplifications, and 7 in partic=
ular introduces
> a fragile dependency I'd rather not take as-is. The diff lines also said =
this and I'd
> rather not take as-is.
>

I see your point about the fragile dependency, especially in
handle_read_error(). I'll drop those patchs from this series and revisit
the cleanup in a future submission if I can find a better approach that
doesn't introduce that dependency.

>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index d94c1f28a6f6..01162c483644 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1143,7 +1143,7 @@ static bool regular_request_wait(struct mddev *mdd=
ev, struct r10conf *conf,
>>   	return true;
>>   }
>>=20=20=20
>> -static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>> +static bool raid10_read_request(struct mddev *mddev, struct bio *bio,
>>   				struct r10bio *r10_bio)
>>   {
>>   	struct r10conf *conf =3D mddev->private;
>> @@ -1191,8 +1191,7 @@ static void raid10_read_request(struct mddev *mdde=
v, struct bio *bio,
>>=20=20=20
>>   	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
>>   		bio_wouldblock_error(bio);
>> -		free_r10bio(r10_bio);
>> -		return;
>> +		return false;
>>   	}
>>=20=20=20
>>   	rdev =3D read_balance(conf, r10_bio, &max_sectors);
>> @@ -1202,8 +1201,8 @@ static void raid10_read_request(struct mddev *mdde=
v, struct bio *bio,
>>   					    mdname(mddev), b,
>>   					    (unsigned long long)r10_bio->sector);
>>   		}
>> -		raid_end_bio_io(r10_bio);
>> -		return;
>> +		bio_io_error(bio);
>> +		goto err_allow_barrier;
>>   	}
>>   	if (err_rdev)
>>   		pr_err_ratelimited("md/raid10:%s: %pg: redirecting sector %llu to an=
other mirror\n",
>> @@ -1215,10 +1214,8 @@ static void raid10_read_request(struct mddev *mdd=
ev, struct bio *bio,
>>   		bio =3D bio_submit_split_bioset(bio, max_sectors,
>>   					      &conf->bio_split);
>>   		wait_barrier(conf, false);
>> -		if (!bio) {
>> -			set_bit(R10BIO_Returned, &r10_bio->state);
>> -			goto err_handle;
>> -		}
>> +		if (!bio)
>> +			goto err_dec_pending;
>>=20=20=20
>>   		r10_bio->master_bio =3D bio;
>>   		r10_bio->sectors =3D max_sectors;
>> @@ -1244,10 +1241,16 @@ static void raid10_read_request(struct mddev *md=
dev, struct bio *bio,
>>   	read_bio->bi_private =3D r10_bio;
>>   	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
>>   	submit_bio_noacct(read_bio);
>> -	return;
>> -err_handle:
>> +
>> +	return true;
>> +
>> +err_dec_pending:
>>   	atomic_dec(&rdev->nr_pending);
>> -	raid_end_bio_io(r10_bio);
>> +
>> +err_allow_barrier:
>> +	allow_barrier(conf);
>> +
>> +	return false;
>>   }
>>=20=20=20
>>   static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *=
r10_bio,
>> @@ -1538,14 +1541,13 @@ static bool __make_request(struct mddev *mddev, =
struct bio *bio, int sectors)
>>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
>>   			conf->geo.raid_disks);
>>=20=20=20
>> -	ret =3D true;
>>   	if (bio_data_dir(bio) =3D=3D READ)
>> -		raid10_read_request(mddev, bio, r10_bio);
>> -	else {
>> +		ret =3D raid10_read_request(mddev, bio, r10_bio);
>> +	else
>>   		ret =3D raid10_write_request(mddev, bio, r10_bio);
>> -		if (!ret)
>> -			free_r10bio(r10_bio);
>> -	}
>> +
>> +	if (!ret)
>> +		free_r10bio(r10_bio);
>>=20=20=20
>>   	return ret;
>>   }
>> @@ -1875,6 +1877,7 @@ static bool raid10_make_request(struct mddev *mdde=
v, struct bio *bio)
>>   	sector_t chunk_mask =3D (conf->geo.chunk_mask & conf->prev.chunk_mask=
);
>>   	int chunk_sects =3D chunk_mask + 1;
>>   	int sectors =3D bio_sectors(bio);
>> +	bool write =3D bio_data_dir(bio) =3D=3D WRITE;
>>=20=20=20
>>   	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
>>   	    && md_flush_request(mddev, bio))
>> @@ -1898,7 +1901,7 @@ static bool raid10_make_request(struct mddev *mdde=
v, struct bio *bio)
>>   		sectors =3D chunk_sects -
>>   			(bio->bi_iter.bi_sector &
>>   			 (chunk_sects - 1));
>> -	if (!__make_request(mddev, bio, sectors))
>> +	if (!__make_request(mddev, bio, sectors) && write)
>>   		md_write_end(mddev);
>>=20=20=20
>>   	/* In case raid10d snuck in to freeze_array */
>> @@ -2866,7 +2869,9 @@ static void handle_read_error(struct mddev *mddev,=
 struct r10bio *r10_bio)
>>=20=20=20
>>   	rdev_dec_pending(rdev, mddev);
>>   	r10_bio->state =3D 0;
>> -	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
>> +	if (!raid10_read_request(mddev, r10_bio->master_bio, r10_bio))
>> +		free_r10bio(r10_bio);
>> +
>>   	/*
>>   	 * allow_barrier after re-submit to ensure no sync io
>>   	 * can be issued while regular io pending.
>
> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
