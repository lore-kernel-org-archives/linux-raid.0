Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4343A3A3808
	for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 07:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776239330; cv=none; b=IpIEcgFOI03xXMufG9WPbI1EEafxyPTwDjFnW3BkIDKTYaFAlOpyeYzXeviQfAu/OWOkY76Lid1tre4gqFQYfBbKb2yYC6BDcfSI5RtuNvEZEMtYdQpg/Sq2S4ApjmNrgHKEX/iMuX+l80B3FgTymV2R6cpO9axIUW8g2mjaVkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776239330; c=relaxed/simple;
	bh=AHl3i5lAE16wEMLq+a84egHULuMLNrx+RuYdGWRxxUE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XgKTaOrndqYktCYqbV8lqO8IzR3A/uUbelZwvews4wI7wnsD0mTIj48qtPrq6ix21A9usn4FWhiOHHmo+pYLlwXQOp2ItqDY1odbLJNPF9YNWF/ZXuc0GrmWQFR0efJfFLDYwMP/mK0mK+WyRO1nwRbCydVJBwQ9kYJxdZOaeHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DOv6h5+s; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DOv6h5+s"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d74086e5bso2414973f8f.0
        for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 00:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776239327; x=1776844127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E86111XbbQiuQhcyZQu/EixDJipeJz0WecwL0lwQrR0=;
        b=DOv6h5+s7Ki8RXfZarJvENKaued3X/O1tED8/v3ftYSgvasW4GI9NuvM5gSRI4Q5YL
         Uhl1+nDgWt+xCJMovzll7IRD/HqxFrX6kPmFreBADelW1zD5UtDmIaNvV3wFnaxxe00x
         r/i9din2ZlNSPe9xYnJZewYHPOrvhS8Jk1as4ddiCEf924MjV6zYFiMFU7TnyYX1uhtM
         9IsSoaY+gjx0Ut5FvAT24RekKFDJTnr+n35/Jl3Nq8Rd2MrN5YIq0jsBJv483LfBbXP4
         +HEOs4gz9+66ivpm5t1UxiftYPgpbeRAFVW8/G3IfzhjgiQ4sjkAV7e05f64j7s68z74
         ABDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776239327; x=1776844127;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E86111XbbQiuQhcyZQu/EixDJipeJz0WecwL0lwQrR0=;
        b=OplKIvHlW25a4DvzBcXQn3PfqJDEnsnbZLF35AWwpgvDAINdIS5Snv7/d9E4kveYfr
         aOXGdQ/ue+sd7DPUZ4JUt4EOTOgvsaSsqs9T/ioEvlEdXf/iqgPHefUy7RdW32UV9VHL
         10mEosn9h/H5fJpyohMhsRpWsOuhM20FNkwuXjO/jdNFJamv/T4LOeQRfGhmMHIR06+d
         saNFFSOItlY6zqBZC1C+0FWCFM6T2CtDknLY/AhvrbMgTtQD/3nWOq3GmC3gsDgIW3za
         c13dfnUKp0ZzdaGa6zYjZbrFbFrQhOghFVOeGKQreJiavQH8JqQsqXXdIiatmWYv+vz4
         W4SQ==
X-Gm-Message-State: AOJu0YzR8eYedbudo9deBMOHPJ1lPNL3NpnHiRWA5Sec3tOIeq5DhY29
	Pj/HhxRjxJ+01elwCXm/cm1JSIf8CzVfM8O6czwDTXITAI+3MK8Ea9pY
X-Gm-Gg: AeBDieuL/K17g/8CJQHvQJsrV1DNJaoCLzonmZRHWqhKtAbb3KEaWaBf//VEQt4QJUc
	YnvBQW0GUM6mFuVoJL21wLZuqzQ0o12HtFRSoMa/Wx1hQY01ZythOTvpPfIlDnsNy5POLQvEZwS
	qYCfBFPQAvp/xYBozxoNcl7rKxJXR17WKlD3MSHxj8g8mSwI0LshxoD+eDAxDxxFjOaFovM2kiE
	ZAUx7ZjCSaHNyVEqQK9mlCIHEM0NA7yyETMTio+jPjAtrdn7dM7Z/48oS32rMg1Yiqn2baviTPC
	iqKl3U+N9MK0J2c/K5G+OoBKNeVjM4TOq1y7nrLrlO1Ke1EKpDFloplPhnpqVUJDOjgqHSehZy/
	sf7McPbwAgqfPyZiDV2FTwpWAz7vt2EY8qY9eNPxPfbaF5RiNQI3lHTQOKwMrN5vg9tiLar98W1
	LUNsgMAk3ubU+31pH1sR/pKw3s5n7uq4gktvbFODWz9J5qrmCTrBQdICoeSgiPb4/izu+6Vnekj
	lz5
X-Received: by 2002:a05:6000:144b:b0:43d:7531:5ca7 with SMTP id ffacd0b85a97d-43d75315de3mr19143430f8f.38.1776239327345;
        Wed, 15 Apr 2026 00:48:47 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:600:3ec1:b04f:4d07:b14b:1337])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3dfff3sm2582349f8f.26.2026.04.15.00.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 00:48:46 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Li Nan <linan666@huaweicloud.com>, song@kernel.org, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
Subject: Re: [PATCH] md: factor out cloned bio cleanup into md_free_bio()
In-Reply-To: <3785a0dd-a673-2551-1fdd-523ff4aca512@huaweicloud.com>
References: <20260414103813.307601-1-abd.masalkhi@gmail.com>
 <3785a0dd-a673-2551-1fdd-523ff4aca512@huaweicloud.com>
Date: Wed, 15 Apr 2026 09:48:42 +0200
Message-ID: <m2bjfk3bqd.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 10:27 +0800, Li Nan wrote:
> =E5=9C=A8 2026/4/14 18:38, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> Refactor duplicated cloned bio completion and cleanup logic into
>> a new helper, md_free_bio().
>>=20
>> md_end_clone_io() and md_free_cloned_bio() previously shared nearly
>> identical teardown code, differing only in whether the original
>> bio=E2=80=99s endio callback was invoked. Introduce a boolean parameter
>> orig_endio to control this behavior and consolidate the logic.
>>=20
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>>   drivers/md/md.c | 26 +++++++++-----------------
>>   1 file changed, 9 insertions(+), 17 deletions(-)
>>=20
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
>>=20=20=20
>
> md_free_bio() is redundant. Can md_end_clone_io() directly call
> md_free_cloned_bio()?
>
> We do not need to consider the compatibility of the EXPORT_SYMBOL in
> mainline.
>
Thanks for the feedback!

You're right, this can be simplified. I'll send a v2 shortly.
> --=20
> Thanks,
> Nan
>

--=20
Best Regards,
Abd-Alrhman
