Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3824207A
	for <linux-raid@vger.kernel.org>; Sun,  5 Jul 2026 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783281505; cv=none; b=JlN5VFTrt/JMg97f7pXRpcasTtgOe8Q60lnNtT+DJ9Yy3NxpedWyD0APGyBqr9jfOwViOBLhcHMDFFitIijjXN4HPwlcv4c83j/Z0vv/nPGppcCb2TdKwqYaC8PUXUU/2GNv9/Fc1FFW9yHFreb97UTFwBM0EFqa4yTy3OdiPho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783281505; c=relaxed/simple;
	bh=hehu7c3ydBHEFX5B7Vu11/GHt2p0iOqoZhhIaXw57GU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=U8RASsGAGTUOy/Qp6s7NNMqtxFAn4J0SmzKl/v+7YVJWy/u6YVryBDR8kHraeCYGRPJYB6DX7WA4kR2S+8AliVa2wA14qrIlGBoCZJgES+OAgLvj4L2EIO2sr1RDadRpbB3hzi0RiAqADfMFPYaI4X15yVNoGR9JaNfDyH6rNb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXJDn7rA; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXJDn7rA"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4629051c9d1so1021566f8f.2
        for <linux-raid@vger.kernel.org>; Sun, 05 Jul 2026 12:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783281502; x=1783886302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=phsHTmLYUt1OkY46dIqbxDNcV7vGCBX/5xtjGDtARYk=;
        b=nXJDn7rArluRE93+m2Z4qXGHh0HmcESp4SWoP8NVmdyCXfA0HsUIIdqrjHL2tGqpIc
         eFlUXlNujk3g/H6A9Kd/jrltH89XsVLso6saRSHmtdz1WP2GhIRJy5fS488lJCz5FEIV
         EWPZfkX1/HYRLc8QJoPhAy8FyN+Rfvm39VLSEIBtwa1uu1kF8gJCDlfvfq4vJtnt4blh
         F2/JcHf8KNBt/PHbZqTio4/E1lVdcO/MkiI4K9rnbIIgAuxhNjdbK2EnexG8bid+Top2
         S9TKLHAU3GgMYqrKq4O1USbM08Zu+55qNwiCwGZR726gHZFiy6cip/Ky3ldyasr9M5+F
         zEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783281502; x=1783886302;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=phsHTmLYUt1OkY46dIqbxDNcV7vGCBX/5xtjGDtARYk=;
        b=HZ5h7dFvr3NlL5oKZlKt9egjvOVOV2nh3/tOjsUcG5JB8US/c2qhulqz7ujrBANbDG
         hr4l8c14jv5XAloMcv20eh5vRu6u5jY/50pdL4llfipUvbCgg+NhcE6vXmZg2WFIobTA
         rg5EDYM/3RKMCnYGoIpkaD+YXZ6jjpC9r5boLXPlr4VG89PxtlJxbiT3MsUK6ks1Vy0b
         F/53UhMOkIJKNQL8BDlPLWlaVpCCy4Il9JLLmh4eSEM+o05GXXZgYpRZLse4rjtlM8nc
         UAE0PmzVWSdd5d8l1n6tS+nZrUIH4dfFFyl1ejXC7umqO+atTAFCqSbSG66TmrVBj28G
         eXIw==
X-Gm-Message-State: AOJu0YxqH4GaU8OdOzNvRNJIOv+EHniTJ6qv5Q1bKLEzp1R3Bfu9VQDq
	k1d7oEFfTkim+zuEV4gRAKmLWQCaePO2GGp0HaPfUxUW6f4VTHq4dBxS
X-Gm-Gg: AfdE7cmOyIx/OXZFYDZW2oI0cbTOyr9cPu/sJvHoaIPpR2kXUSEgPYIunVGYWYKgsFp
	sCJrEivYtA1nwggE+AXHw9qWFrl9Y2cVSJTVsXUgvjlAcCUW1U88+kvoqbKonrsZ06l1uyEF5jQ
	JHjV6M1pZ7kIRMcjOmUavX5HBDXcGL+HOHJ9cwfkMrqQrwsa/lej7/P91AXYNgM8NpCuQiRhiXd
	WxWkriNUzBEIXDIogw5L6Nw5/gDAAyITPckkHl7Hq9SWouSCkr329eQy6p9akERmOSRnVc+SXlw
	y+AugFLY7z4ArqiWnQwig0IeoEKlfayvJRNYW7C0x55qg1w3PNgoSLWgwdtXTDjTWIWdw5bKqMF
	XTf2Np3M+MhzrinQ5M+VWdqxPWBfiBe8wKrKF4tUwJsfOHx6RsPQUcNCg5om9l6L/oglUjsbK0W
	KhPjQWwlgHAKPbG8blQ43ROr5/b1SPAasQ0vni4nKNf/ST5KrWyZdH7CY=
X-Received: by 2002:a05:6000:2408:b0:45e:eaed:afd2 with SMTP id ffacd0b85a97d-47aa7ca8972mr9165414f8f.0.1783281502441;
        Sun, 05 Jul 2026 12:58:22 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:663:8ce9:99fa:f98b:4367:d5f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039ad21sm18380105f8f.20.2026.07.05.12.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 12:58:21 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, song@kernel.org, magiclinan@didiglobal.com,
 xiao@kernel.org, yukuai@fygo.io
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, sashiko-bot
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH] md: avoid modifying spares while the array is not
 suspended
In-Reply-To: <0a7dc7e2-30af-44de-8c29-b6e27a62fa55@fygo.io>
References: <20260630075640.1081634-1-abd.masalkhi@gmail.com>
 <0a7dc7e2-30af-44de-8c29-b6e27a62fa55@fygo.io>
Date: Sun, 05 Jul 2026 21:58:12 +0200
Message-ID: <m2se5x6wff.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

On Mon, Jul 06, 2026 at 00:16 +0800, yu kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/6/30 15:56, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> remove_spares() and remove_and_add_spares() modify the array's rdev
>> configuration. These operations are only safe after the array has been
>> suspended.
>>
>> Today, md_start_sync() can call md_choose_sync_action() even when the
>> array has not been suspended. As a result, md_choose_sync_action() may
>> remove or replace rdevs while normal I/O is still accessing them.
>>
>> The race can occur as follows:
>>
>> raid10d          Worker                      Normal IO
>> ____________     _______________________     ______________________
>>
>>                                               raid10_write_request()
>>                                               wait_blocked_dev()
>> set Blocked
>> set Faulty
>>                                               Skip Faulty rdev
>>                                               rrdev->nr_pending++
>>                                               .repl_bio =3D bio
>>                   removeable_rdev =3D false     .
>>                   array not suspended         .
>> lock mddev                                   goto err_handle
>>                   lock mddev (wait)
>>                   .
>> update sb        .
>> clear Blocked    .
>>                   .
>> unlock mddev     .
>>                   lock mddev (acquires)
>>                   remove_spares()
>>                   removeable_rdev =3D true
>>
>>                   raid10_remove_disk()
>>                   rdev =3D replacement
>>                   replacement =3D NULL
>>                                               rdev_dec_pending(NULL)
>>                   unlock mddev                (NULL)->nr_pending--
>>
>> In this case, rdev_dec_pending() is called with a NULL pointer,
>> resulting in a NULL pointer dereference when attempting to decrement
>> nr_pending.
>>
>> Fix this by ensuring that remove_spares() and remove_and_add_spares()
>> are only called after the array has been suspended, preventing
>> concurrent rdev configuration changes while normal I/O is in progress.
>>
>> Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need=
 reconfiguration")
>> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
>> Closes: https://sashiko.dev/#/patchset/20260628142420.1051027-1-abd.masa=
lkhi@gmail.com?part=3D3
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>>   drivers/md/md.c | 18 +++++++++++++-----
>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 66a41d482e59..c85ebb59535b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -10116,7 +10116,8 @@ static int remove_and_add_spares(struct mddev *m=
ddev,
>>   	return spares;
>>   }
>>=20=20=20
>> -static bool md_choose_sync_action(struct mddev *mddev, int *spares)
>> +static bool md_choose_sync_action(struct mddev *mddev, int *spares,
>> +				  bool array_suspended)
>>   {
>>   	/* Check if reshape is in progress first. */
>>   	if (mddev->reshape_position !=3D MaxSector) {
>> @@ -10132,7 +10133,9 @@ static bool md_choose_sync_action(struct mddev *=
mddev, int *spares)
>>=20=20=20
>>   	/* Check if resync is in progress. */
>>   	if (mddev->resync_offset < MaxSector) {
>> -		remove_spares(mddev, NULL);
>> +		if (array_suspended)
>> +			remove_spares(mddev, NULL);
>
> The problem looks real, however, I think this will cause a change that us=
er will be awared,
> if there are really spares that can be removed from conf, but array is no=
t suspended here,
> user will still expect rdev will be removed from conf automatically.
>
> In md_start_sync, if suspend is false, can we check again after mddev_loc=
k? If suspend is
> supposed to be true, we can release the lock and retry with suspend =3D t=
rue.
>
Yes, I see, and your approach is much better. But what do you think
about taking the lock first and then checking only once?

>> +
>>   		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>>   		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>>   		clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
>> @@ -10144,7 +10147,11 @@ static bool md_choose_sync_action(struct mddev =
*mddev, int *spares)
>>   	 * also removed and re-added, to allow the personality to fail the
>>   	 * re-add.
>>   	 */
>> -	*spares =3D remove_and_add_spares(mddev, NULL);
>> +	if (array_suspended)
>> +		*spares =3D remove_and_add_spares(mddev, NULL);
>> +	else
>> +		*spares =3D 0;
>> +
>>   	if (*spares || test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery)) {
>>   		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>>   		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>> @@ -10189,11 +10196,12 @@ static void md_start_sync(struct work_struct *=
ws)
>>   		 * As we only add devices that are already in-sync, we can
>>   		 * activate the spares immediately.
>>   		 */
>> -		remove_and_add_spares(mddev, NULL);
>> +		if (suspend)
>> +			remove_and_add_spares(mddev, NULL);
>>   		goto not_running;
>>   	}
>>=20=20=20
>> -	if (!md_choose_sync_action(mddev, &spares))
>> +	if (!md_choose_sync_action(mddev, &spares, suspend))
>>   		goto not_running;
>>=20=20=20
>>   	if (!mddev->pers->sync_request)
>
> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
