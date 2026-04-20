Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38382765D7
	for <linux-raid@vger.kernel.org>; Mon, 20 Apr 2026 07:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776670241; cv=none; b=VtDZL8vZMK/CnaFSwsfnwHkWnK+H9HjPVNaUWTF4qn9wMLDFeU0aJ6Z1kNhPlC8gDsMEjvlLs56tn2knhXfiffh4M1ZskebHSaNwrcGdZ/J88UyaAVRb6pfog0/UHFRF8q6vBmcSJnQvFypKKjELGm3kS64Ia70t+39Doulj5iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776670241; c=relaxed/simple;
	bh=grwtKCTakBM00kDIGK1Lcx//hvk4FsvFJV1aMUIxteE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ksY+pf3L4wHi+VVbV3kz1jlczNpMrfp6OpZKFZIXs8qcMuCJirsPyFo/yFF8u7nw7R4E+s4NSMU/Rh1F3y2QVCsFzY8yP6UpOHFmWsAAp82jkhsvFNNznP8wmVMekYKW9OC0u+4WsbQ5y+NZRzbRFH9J5g58n+5WHBKiyegLyaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pDjJLc1P; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pDjJLc1P"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48374014a77so34654065e9.3
        for <linux-raid@vger.kernel.org>; Mon, 20 Apr 2026 00:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776670238; x=1777275038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U1IhwiWTj3YaB7i7Ax53dVeRVBbaQpy4wbPSfm0lknk=;
        b=pDjJLc1PVaiN1TyBHFbJtXhnDQI5j+KOUbmCHtMGseK3pn0N2dDcvYcVQXnYXRNrao
         7nHIctlpUYSfJexTLgqlWsyj3wfGikMyUOUQXlvz5CROrXuGEPoFgzGjmfZbEZUw+tEl
         X8AL/6cMg7LdQ4iOxTbfJ9fU+LDFOEq5na5iPU6O3mCMNrDZJBqpCjgDmQUYXl+Odu3R
         prnHUvhGWsZ/nuV9VOO3widO7TJO3S4tgrxx8eiv5pIkwI9/kmWMD2El8oLgntCKmYIn
         B9oDG0/4vHxIQ/3nh+89EBWT++Jcab2oQiP18SqaGVyV6dtKKzkRmKEWbHcQsxbJR4kt
         BviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776670238; x=1777275038;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U1IhwiWTj3YaB7i7Ax53dVeRVBbaQpy4wbPSfm0lknk=;
        b=FYW+qMlWtyTXZIF7VjN6S/OsOg54r7l6eWwyOdVdg0gi1wwxt56/uWP1734SoML7z2
         Gvn2iWso1Jw/ypVNxwUrSv2x5L/zVqrO/V7LO30wqua6IJpXMwqKk8lSltFSQrPJaZ4D
         uRy+fHpTAvmr+cjTuEuxsM7wXCd+hfoyKLIiOjEOjPIku91dwZv0Nyf7LhfnTbiqVVZW
         6rNbRPiwrBpT6gmLWAjjQSEmUIIYsZ9IkY8/HmzLEIiuekSH5v+aBZWpgzfhVYGpJe7o
         mHKhUC/MHF42qZybDq1hBJKkbGaaIFY0y6LhzmH0iu+JdTi/R2m81wflcBUFZjzqkVJR
         Rdvw==
X-Gm-Message-State: AOJu0YzTslSTY6SqZAwbAWnAjczwHPhJfv+tAgHuDCKaCvEHVacTT1WG
	LGyYH1ccyOAEFDJQASqCsHcTxZVJrdFjz6hfZvIPMBbfnMUD9HRbyNzr
X-Gm-Gg: AeBDieu0tiH16Kvj21Rnog57k4FrrKuEIsa0o4NKkTnlQln3ZlJTJGO5IVamcCGDZqW
	+glBbnwyiiTv5aDlUY9P2iELyX//7OtE5O+wexIjiiC4acisA4FrU7TPrKM5PTRVw9+/SoNhIh6
	wzxLXMG2DQv9X67OBiZF8D6cEiY16hbOLXyyskvVNj06bKWnAI2GMSFzaU9GYEwdDxkinni9BqQ
	kVDI8tjeJlyUfpBYCaz1Iee2B1IhQ/hzzf5ZdjuYGIt0FrAvVZSv+gAEsC+gO/I7DWKaz0zNfob
	aITycCAUvr1eZplWBfFB5l/4h5DWTLTxM3DNga8fXbr6yB7vYMpMdSLYvDlNZDYJQGaoySeRX+d
	e1lrrqKesBmcbvdHoWH+lT0YXz/Juyfyv88XuLuU+g2SF+5pwO5dYIL1SeHKbU1jMyeNht94iSx
	u9yWZeI4hbxyyUeC3Ui8txAgN9CGeKpnGA0uoTfJQ6TMbv/ICjPEwSK2sOUdIHcZ1FHHmNGmGAR
	0c=
X-Received: by 2002:a05:600c:c0c8:b0:487:21c7:2885 with SMTP id 5b1f17b1804b1-488fb73d9ffmr136487665e9.5.1776670237946;
        Mon, 20 Apr 2026 00:30:37 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:609:eca:2198:a7d3:5d4c:1f21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f8188sm284625935e9.2.2026.04.20.00.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 00:30:37 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai@fnnas.com
Subject: Re: [PATCH] md: factor out cloned bio cleanup into md_free_bio()
In-Reply-To: <b33f52c1-0f10-4ac0-8792-4387848e40d4@fnnas.com>
References: <20260414103813.307601-1-abd.masalkhi@gmail.com>
 <b33f52c1-0f10-4ac0-8792-4387848e40d4@fnnas.com>
Date: Mon, 20 Apr 2026 09:30:34 +0200
Message-ID: <m2mryyks11.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 12:48 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/4/14 18:38, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> Refactor duplicated cloned bio completion and cleanup logic into
>> a new helper, md_free_bio().
>>
>> md_end_clone_io() and md_free_cloned_bio() previously shared nearly
>> identical teardown code, differing only in whether the original
>> bio=E2=80=99s endio callback was invoked. Introduce a boolean parameter
>> orig_endio to control this behavior and consolidate the logic.
>>
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>>   drivers/md/md.c | 26 +++++++++-----------------
>>   1 file changed, 9 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index ac71640ff3a8..707d605fee61 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9208,7 +9208,7 @@ static void md_bitmap_end(struct mddev *mddev, str=
uct md_io_clone *md_io_clone)
>>   	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
>>   }
>>=20=20=20
>> -static void md_end_clone_io(struct bio *bio)
>> +static void md_free_bio(struct bio *bio, bool orig_endio)
>>   {
>>   	struct md_io_clone *md_io_clone =3D bio->bi_private;
>>   	struct bio *orig_bio =3D md_io_clone->orig_bio;
>> @@ -9224,10 +9224,16 @@ static void md_end_clone_io(struct bio *bio)
>>   		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>>=20=20=20
>>   	bio_put(bio);
>> -	bio_endio(orig_bio);
>> +	if (orig_endio)
>> +		bio_endio(orig_bio);
>>   	percpu_ref_put(&mddev->active_io);
>>   }
>>=20=20=20
>> +static void md_end_clone_io(struct bio *bio)
>> +{
>> +	md_free_bio(bio, true);
>> +}
>> +
>>   static void md_clone_bio(struct mddev *mddev, struct bio **bio)
>>   {
>>   	struct block_device *bdev =3D (*bio)->bi_bdev;
>> @@ -9262,21 +9268,7 @@ EXPORT_SYMBOL_GPL(md_account_bio);
>>=20=20=20
>>   void md_free_cloned_bio(struct bio *bio)
>>   {
>> -	struct md_io_clone *md_io_clone =3D bio->bi_private;
>> -	struct bio *orig_bio =3D md_io_clone->orig_bio;
>> -	struct mddev *mddev =3D md_io_clone->mddev;
>> -
>> -	if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mddev, fa=
lse))
>> -		md_bitmap_end(mddev, md_io_clone);
>> -
>> -	if (bio->bi_status && !orig_bio->bi_status)
>> -		orig_bio->bi_status =3D bio->bi_status;
>> -
>> -	if (md_io_clone->start_time)
>> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>> -
>> -	bio_put(bio);
>> -	percpu_ref_put(&mddev->active_io);
>> +	md_free_bio(bio, false);
>>   }
>>   EXPORT_SYMBOL_GPL(md_free_cloned_bio);
>
> This patch is no longer needed after following patch:
> https://lore.kernel.org/r/20260408043548.1695157-1-bmarzins@redhat.com

Thanks, I'll drop this patch.

>
>>=20=20=20
>
> --=20
> Thansk,
> Kuai

--=20
Best Regards,
Abd-Alrhman
