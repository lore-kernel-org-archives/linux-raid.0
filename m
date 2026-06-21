Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B871244665
	for <linux-raid@vger.kernel.org>; Sun, 21 Jun 2026 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782065344; cv=none; b=dMY69hIYWBX4ew89WMD9eIvfEeZ3EfcBuOsebp20WB68aD9SZcWAJMP+Pls4cTGRMumSYKRuZKPpQL8j5T6NRkkAHlTVrt7WSJHrT62HysoiAB7fFGOT9zFFWXbo0dfCo2Q2srz+q8OoUABVAJcbLVcY4964x9+h6Qr0Ym2nyUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782065344; c=relaxed/simple;
	bh=fNbB198fflPdJnpxSSpG2Ox0FfkOAWfP5knojsgqn2M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OKzmjme5WvRKl6kP2Pyxsn90OOjdbg8TOw4/EyUp1WC/JKqyZpXCfguuleEVprcRhChvUkpMrQbqZr0+KabN8p0wFtfvt2sDnbelVb6d4oalV+ApsbGhBG2GQheMbd4K4HuzOLtpdeYSnX8KIg4zRdJ1ErkMivkrNtKx2gIwcX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZFrfuDm; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZFrfuDm"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490b7866869so35874335e9.2
        for <linux-raid@vger.kernel.org>; Sun, 21 Jun 2026 11:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782065341; x=1782670141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2vX7UxoAyHR0nEsmAp/8SWI4koDkM6uFZgYkxJ5oXk=;
        b=cZFrfuDmZ2BN0o/YXIErg6UEIeQ2gUv22WfDzdbI1zoda7TBNf5ASXbCUDTk2GoyrT
         NXpJtJkJ2nFHziEpte4EK1OF8/RidGC3CED7Fy5bgd9CdYbjnv6TSunvGux7D7riI9eh
         XAzRQZKhLS4VdHlIxeZKRJmYAmwG57Cwz0U5eN8Yy98PH6F0CoVzDGTZe+cqSG4FaPI5
         3OeXQ/tjlDYF0frzAckMpiwYb0G1SipgZdzjjCULirBFhZcNSjv9Y0Ytn+0yhWmdJeQW
         mmGFzvDUWZ+wsPp82h9WfbZWhR0A4I7wLbcNAxcUBu1vXBZNtZYXIHkyDxoQjDXyl1Ad
         W06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782065341; x=1782670141;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n2vX7UxoAyHR0nEsmAp/8SWI4koDkM6uFZgYkxJ5oXk=;
        b=mkbgWeANFGfiBlMwpbA/1MSlMgdkgFwj4rGcRP5z9i01D3SMhk+F//9wX2X548Clg6
         KHlhie5NBPKRu4Ls9slHkIEXi+uQbVDMy6KnlYpwrN21dPiCqVtvT6eTSUHPhAxL/Ui1
         sqksE2Qd8FdOPxafFBw6zRHM9K1gRJtOJDObDPyJw4ACUeWmgBoSYxGfbAOw+mzKHWz7
         DWkf6Ipf3C30XkqXzKeqno6v88sUBkH61HpnqapgFWRorMuamq0TxZiq9ecidf73eyJC
         PvO5J0ZmXGBcGno3M2LdsC+fFvsK5yYST4nBHxuaPCb3mD06s0natjOeQHJyFCr5kgWz
         f4Nw==
X-Gm-Message-State: AOJu0YzrrwIpenocJHQWveUaxw4Kn0auVC81voVfYPfQqnZHyBk0qq7E
	TbqURs93LMqwfBVf5END61zrs/pNsfyDPr9BnSA6KFboghSDywMM4QRN
X-Gm-Gg: AfdE7ckdl7wH3rLolST/Gk+piDe/VwjPj25hpCVtv+BkTimC69vETECDMtU+f1hQ4c8
	gUU/H1PSdGXXzSw9zBQvs1cosBRC5oiTboGie45IZ9fNduIt+T7sZZ2ax9uL0EBo0t8u+vTA+wC
	P0KkMMxYNVLHQ7RAXgPfNkFgqx7FdJ4OkZe8EcKXtd0QbruQENXusdEauFhi4sZLvxuQAhqJbjQ
	FHTSIiT+tjnsZ8I/WQrFnXMWF/d1/1flY0932LqmTHDa3aIuoeXWIsSQXPQvLXGnnO1oNjuL9mv
	ynfvS6wHkom7/mTuHromdTvRFblMXKdz8TvcTG68W/iag6Ywx8f7GLHJ57f9khs2xUIUvu4cdq3
	zXl3oFPp+WxmjFZtcR0RnIrp5U5DKoze0D1Vt3YncGAdvvg3XOOI+8GjUZTF1mnwUKlo+lz/Qcg
	Zm/jTbdRQsyLpF+cKPpUJ1NEWygvxAGq1ccxUEZbe7CaWYcUu6NuMA
X-Received: by 2002:a05:600c:4ec6:b0:490:b8c0:d470 with SMTP id 5b1f17b1804b1-492425706acmr173891275e9.19.1782065340512;
        Sun, 21 Jun 2026 11:09:00 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:615:2c89:4a:a3f7:13b1:5df6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46666c57a0esm17566975f8f.27.2026.06.21.11.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 11:08:59 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, vverma@digitalocean.com,
 axboe@kernel.dk
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai@fygo.io
Subject: Re: [PATCH] md/raid1: honor REQ_NOWAIT when waiting for behind writes
In-Reply-To: <61361f20-f81c-46c3-bdd2-3de24e90a0aa@fnnas.com>
References: <20260611083514.754922-1-abd.masalkhi@gmail.com>
 <61361f20-f81c-46c3-bdd2-3de24e90a0aa@fnnas.com>
Date: Sun, 21 Jun 2026 20:08:58 +0200
Message-ID: <m2y0g722bp.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

On Sun, Jun 21, 2026 at 04:18 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/6/11 16:35, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> raid1 supports REQ_NOWAIT reads by avoiding waits in the barrier path
>> through wait_read_barrier(). However, a read can still block on a
>> WriteMostly device when the array uses a bitmap and there are
>> outstanding behind writes.
>>
>> In that case raid1 unconditionally calls wait_behind_writes(), which
>> may sleep until all behind writes complete. As a result, a REQ_NOWAIT
>> read can block despite the caller explicitly requesting non-blocking
>> behavior.
>>
>> This ensures that raid1 consistently honors REQ_NOWAIT reads across all
>> paths that may otherwise wait for behind writes.
>>
>> Fixes: 5aa705039c4f ("md: raid1 add nowait support")
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>>   drivers/md/md-bitmap.c   |  9 +++++++--
>>   drivers/md/md-bitmap.h   |  2 +-
>>   drivers/md/md-llbitmap.c | 13 ++++++++-----
>>   drivers/md/md.c          |  2 +-
>>   drivers/md/raid1.c       | 10 +++++++---
>>   5 files changed, 24 insertions(+), 12 deletions(-)
>
> Applied to md-7.2.
>
> One note, remove nowait support is already in my to-do lists. There is a =
case
> that can't be handled for now, for example:
>
> 2 disk raid1, issue no wait write IO, rdev1 succeed while rdev2 failed. I=
n this
> case, we don't know if rdev2 failed issue because nowait or disk really h=
ave
> badblocks. So we can't either record badblocks or issue again without now=
ait,
> for consequence, rdev1 and rdev2 will end up with different data.
>
> I think the best solution is to remove nowait support for mdraid. Feel fr=
ee
> to cook a patch or if you have something else in mind.
>

What if on a partial nowait failure we just end the master bio as
success, but set NEEDED on that chunk's bitmap counter and start_sync()
picks it up for resync? That way we don't have to decide why rdev2
failed at all, resync just copies from rdev1 to rdev2 without nowait,
so if it's a real bad block, end_sync_write() records it then.

We kinda have the idea of ending the bio before the write lands on all
mirrors in write-behind already, though it's not quite the same, there
the deferred write still lands, here we ACK after it already failed and
lean on resync to redo it.

My worry is the loaded case: AGAIN under queue pressure isn't that rare,
so we might end up triggering resync frequently. Do you think that's
acceptable, or is dropping nowait better? Happy to prototype either way.

>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 028b9ca8ce52..1206e31f323a 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -2063,18 +2063,23 @@ static void bitmap_end_behind_write(struct mddev=
 *mddev)
>>   		 bitmap->mddev->bitmap_info.max_write_behind);
>>   }
>>=20=20=20
>> -static void bitmap_wait_behind_writes(struct mddev *mddev)
>> +static bool bitmap_wait_behind_writes(struct mddev *mddev, bool nowait)
>>   {
>>   	struct bitmap *bitmap =3D mddev->bitmap;
>>=20=20=20
>>   	/* wait for behind writes to complete */
>>   	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
>> +		if (nowait)
>> +			return false;
>> +
>>   		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
>>   			 mdname(mddev));
>>   		/* need to kick something here to make sure I/O goes? */
>>   		wait_event(bitmap->behind_wait,
>>   			   atomic_read(&bitmap->behind_writes) =3D=3D 0);
>>   	}
>> +
>> +	return true;
>>   }
>>=20=20=20
>>   static void bitmap_destroy(struct mddev *mddev)
>> @@ -2084,7 +2089,7 @@ static void bitmap_destroy(struct mddev *mddev)
>>   	if (!bitmap) /* there was no bitmap */
>>   		return;
>>=20=20=20
>> -	bitmap_wait_behind_writes(mddev);
>> +	bitmap_wait_behind_writes(mddev, false);
>>   	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
>>   		mddev_destroy_serial_pool(mddev, NULL);
>>=20=20=20
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index 214f623c7e79..f46674bdfeb9 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -98,7 +98,7 @@ struct bitmap_operations {
>>=20=20=20
>>   	void (*start_behind_write)(struct mddev *mddev);
>>   	void (*end_behind_write)(struct mddev *mddev);
>> -	void (*wait_behind_writes)(struct mddev *mddev);
>> +	bool (*wait_behind_writes)(struct mddev *mddev, bool nowait);
>>=20=20=20
>>   	md_bitmap_fn *start_write;
>>   	md_bitmap_fn *end_write;
>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>> index 1adc5b117821..5a4e2abaa757 100644
>> --- a/drivers/md/md-llbitmap.c
>> +++ b/drivers/md/md-llbitmap.c
>> @@ -1574,16 +1574,19 @@ static void llbitmap_end_behind_write(struct mdd=
ev *mddev)
>>   		wake_up(&llbitmap->behind_wait);
>>   }
>>=20=20=20
>> -static void llbitmap_wait_behind_writes(struct mddev *mddev)
>> +static bool llbitmap_wait_behind_writes(struct mddev *mddev, bool nowai=
t)
>>   {
>>   	struct llbitmap *llbitmap =3D mddev->bitmap;
>>=20=20=20
>> -	if (!llbitmap)
>> -		return;
>> +	if (llbitmap && atomic_read(&llbitmap->behind_writes) > 0) {
>> +		if (nowait)
>> +			return false;
>>=20=20=20
>> -	wait_event(llbitmap->behind_wait,
>> -		   atomic_read(&llbitmap->behind_writes) =3D=3D 0);
>> +		wait_event(llbitmap->behind_wait,
>> +			   atomic_read(&llbitmap->behind_writes) =3D=3D 0);
>> +	}
>>=20=20=20
>> +	return true;
>>   }
>>=20=20=20
>>   static ssize_t bits_show(struct mddev *mddev, char *page)
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 096bb64e87bd..d1465bcd86c8 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -7050,7 +7050,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
>>   static void mddev_detach(struct mddev *mddev)
>>   {
>>   	if (md_bitmap_enabled(mddev, false))
>> -		mddev->bitmap_ops->wait_behind_writes(mddev);
>> +		mddev->bitmap_ops->wait_behind_writes(mddev, false);
>>   	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
>>   		mddev->pers->quiesce(mddev, 1);
>>   		mddev->pers->quiesce(mddev, 0);
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index b1ed4cc6ade4..b2d7c13b64bd 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1341,6 +1341,7 @@ static void raid1_read_request(struct mddev *mddev=
, struct bio *bio,
>>   	int max_sectors;
>>   	int rdisk;
>>   	bool r1bio_existed =3D !!r1_bio;
>> +	bool nowait =3D bio->bi_opf & REQ_NOWAIT;
>>=20=20=20
>>   	/*
>>   	 * An md cloned bio indicates we are in the error path.
>> @@ -1360,8 +1361,7 @@ static void raid1_read_request(struct mddev *mddev=
, struct bio *bio,
>>   	 * Still need barrier for READ in case that whole
>>   	 * array is frozen.
>>   	 */
>> -	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
>> -				bio->bi_opf & REQ_NOWAIT)) {
>> +	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
>>   		bio_wouldblock_error(bio);
>>   		return;
>>   	}
>> @@ -1402,7 +1402,11 @@ static void raid1_read_request(struct mddev *mdde=
v, struct bio *bio,
>>   		 * over-take any writes that are 'behind'
>>   		 */
>>   		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
>> -		mddev->bitmap_ops->wait_behind_writes(mddev);
>> +		if (!mddev->bitmap_ops->wait_behind_writes(mddev, nowait)) {
>> +			bio_wouldblock_error(bio);
>> +			set_bit(R1BIO_Returned, &r1_bio->state);
>> +			goto err_handle;
>> +		}
>>   	}
>>=20=20=20
>>   	if (max_sectors < bio_sectors(bio)) {
>
> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
