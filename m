Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5195C3F167C
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 11:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777377232; cv=none; b=Fr6Mypp6N3wy2bks2eBH26+4TfReOXp2AHY/TxOJYJGRHB92qreHFKn7f5diUv42+q2uS0JzorpAUt7haJN94bGHWp1r2ps8sjttfbdLg9IpyMfVHbyTztQXtz9CGimwNTe88unQoR8JlbjtH2lUVkrJxncP8ML7oSr2sAwM4nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777377232; c=relaxed/simple;
	bh=HIeNz2q2rXQmvQzkjlBgBFTIjw/kD0Nh0R8BzB2/NFg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=n5i/kW6ToRNtuC+Lz1fmB6QEgP20hwyCU07jW/LUX3wnT2Tdi0PlSKt1XcJtUcq87sYNJIFtiVz7tCJfjTJVoxO8g1mQXcKXN5y8n7d5zweFomtBzFK3GDcLhGfj290xpk4bOzxwpOENyU7BgekIzfTOGSNfp/QmKmLqYfKXgCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IK43YmCO; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IK43YmCO"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43fe62837baso6585947f8f.3
        for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 04:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777377229; x=1777982029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h0g3fA6xiRCKrQErw65n6LndHkYc6MlHfp13kk54514=;
        b=IK43YmCOUkXKnCDN8FrRHjoIF+igedDawSn7w/sp7g1jo5lPvNbjmeFu+D+F/0iAw6
         80q8gMkEmpTpNNmTyS3wj6VW9K9JRY2kqNn77BTMUvj+fhEKk252zPgaPHzPbR3CSlDg
         RM9/+UUFMQi1OStSDO/fwroeEz5oYicnkLWrck9d4SpFyo/49kqfNkcD6rSzzfum4Leq
         9luwSC7vBRD8GpHM9DjZRaf/X0I4986GzmnQkUZhiEOEmLfC1MGAzVDXJmIL89WXw1FP
         q7INwMsdJmVXR8PN2NmhpKaw9mopUXjKL38WO3TTAEEq/dOr34fQHleMBxA8PHsiTjY/
         SaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777377229; x=1777982029;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h0g3fA6xiRCKrQErw65n6LndHkYc6MlHfp13kk54514=;
        b=nW7kfnHiJ/fz4qWNCuoSNI9az9cNouK27b6/KvAmvCitI4hgSI6QJZkTnh83dYW7LM
         DsBW/vh5UpcsN16WmdHrzrIwYyAbZ0LSi0QeLbgdVeUCB2Xmrv09x4NoIyiyL92UbjMj
         qCPL9hY51XkjwJCVKcTrxH6Lj9YccV+aBse+YwdvCRHr+G+FB6fIB7hAEyXSFS7Qx8/1
         3XYQfziFYeiq0F8GMZPYbi4NYwMiM0Sfv2ZUico6VnEjNb8mSpx1RwCv2PdaaFKnKJ8m
         5KKOyX9WgxUoO8F5GcFv2NVA7JPSyCWvq41q+k8VJN1+TWMwH5XHdWbSImMdhuKKGJT/
         YngA==
X-Gm-Message-State: AOJu0YzHH4jg26u8tcniIahTC7YHwkHsIYZATBIkhrqj0vjIBO4ODd4e
	02NbXdFlwGohpRwaBOEhUEWowsmRCB397KVsrnEX23h1MvA2u+8sRn6DDR+FwA==
X-Gm-Gg: AeBDietiVtfkTQT4YFnflbw+hp5Yi49cJo1yUZGMEK2dPWliwlKvHv1taQkWHwW3wFM
	nZdNP55Sz4XlWDhGEpE9gXijy2xxR36ehR9KYQDOOzjjpCgJFA8npfl+5q3V35oM/9oZvKJ4CAo
	JlaGAVwq3o2lko7s3bErrGh28ebEVcDHoFm3AJ/bV0ZkkU6SSAx/A89F927vbcIZl6mH5GDgQL1
	Mwr4fT6aW/fzcQZOTpJ2tycux/sqy2TUAcNGeZvabk6D2WM701VQHk0WeJpDwuZMkljXMejZxRs
	r/td7hxVQNW5+HsAI9tOEru1DKIPq2PiYZsbVETsVPQX0Nq3LyJGDuASBPcCl6w255Ep1AlpHU2
	uxaBKxPHEgH4LIpbjlsplnk8j6nlYQknUAz74QyzwOAV+HpEQmOeESwivAH618wmtmc/6BKfXWr
	NLyLX2hCZLC4zyRFC0gGeZxaKj5hDIGehoIyTlgIFv+7DCdAAbQdbzRY043vI2p4Uaw0OFdkPRj
	XY=
X-Received: by 2002:a05:6000:2f85:b0:43b:8f38:3b88 with SMTP id ffacd0b85a97d-446494ea255mr5380262f8f.25.1777377229214;
        Tue, 28 Apr 2026 04:53:49 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:60f:89ae:9923:b51e:6a1:7be2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463ff5a1acsm5655356f8f.33.2026.04.28.04.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 04:53:48 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org,
 paul.e.luse@linux.intel.com, xni@redhat.com, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid1: fix len reuse across rdevs in
 choose_first_rdev()
In-Reply-To: <5c71cb6b-d860-4bcb-a900-a27544be7a17@fnnas.com>
References: <20260426093506.14316-1-abd.masalkhi@gmail.com>
 <5c71cb6b-d860-4bcb-a900-a27544be7a17@fnnas.com>
Date: Tue, 28 Apr 2026 13:53:45 +0200
Message-ID: <m2fr4f47xy.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kaui,

On Tue, Apr 28, 2026 at 16:23 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/4/26 17:35, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> choose_first_rdev() initializes the variable len before iterating over
>> all rdevs, but passes it by reference to raid1_check_read_range(), which
>> it might update *len and return 0 depending on the layout of the bad
>> block region. As a result, 'len' can be modified during the first
>> iteration and reused for subsequent rdevs, causing later devices to be
>> evaluated with an incorrect length value.
>>
>> Fixes: 31a73331752d3 ("md/raid1: factor out read_first_rdev() from read_=
balance()")
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>>   drivers/md/raid1.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index b549be9174bb..5f5dbf79c903 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -591,12 +591,12 @@ static int choose_first_rdev(struct r1conf *conf, =
struct r1bio *r1_bio,
>>   			     int *max_sectors)
>>   {
>>   	sector_t this_sector =3D r1_bio->sector;
>> -	int len =3D r1_bio->sectors;
>>   	int disk;
>>=20=20=20
>>   	for (disk =3D 0 ; disk < conf->raid_disks * 2 ; disk++) {
>>   		struct md_rdev *rdev;
>>   		int read_len;
>> +		int len =3D r1_bio->sectors;
>>=20=20=20
>>   		if (r1_bio->bios[disk] =3D=3D IO_BLOCKED)
>>   			continue;
>
> This patch is wrong, choose_first_rdev() is used when raid1_should_read_f=
irst() is true,
> meaning the read overlaps an unsynced/resyncing area. Reset len can cause=
 the problem that
> reading the same area can return different data.
>

Thank you for the detailed explanation. After carefully re-reading the
code and your feedback, I understand why the patch is wrong.

> --=20
> Thansk,
> Kuai

--=20
Best Regards,
Abd-Alrhman
