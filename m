Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737F23DBD79
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 09:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777370168; cv=none; b=KW6vjNgtCbk2UUJJg3dtIlLQODFYUEzK7efrPEG9FzA4+RbhU3v9VsbX2KLmoGqspN3DOAB0y+TbjS8rLhEt+LKzhEqSsYb4BPu6JvNxdmFPrLdqdNC3ecDvxIRzFxLfJe6WA0uX8ZHha3AW8Ldg8mn+nSaz4f5nkOi5EgSeC2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777370168; c=relaxed/simple;
	bh=aYzx85ABRgSSWR+e7JI4yOkjH2DfkKmKBFeG6gJiyeQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=e7c2aaBpnkKa+Do4OmGNbB+PleSKcKCOc3nSQt0fIW0JGZZpATjt0gEYQe8cbfvFPHw31+ZqhBM0PMCKN30zE+0w5HLGZtrurwFg9xG0xZ9Bqq7hiIkdYVp810E9WFgu8a3LX+2OWLPVrgK23iq9V9tUZW5KYY/HXvla0DZlGNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iojHVcxS; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iojHVcxS"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so95853115e9.2
        for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 02:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777370165; x=1777974965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DDmRuryL0az6H6BjGlgdTK5jjjtEkzbzFLNWK2PRayI=;
        b=iojHVcxSB4viCIrA73IB1mj5mAGCRdcTtf3T78Cl03zs5Xjsl1u67Wer3pVjJ7ZWvG
         nzG1g1oZVXhqYYutMAxXo0YTQ6IWFUT0dik1K5ntaeJfxdKMXwHJBufR4SY4bDp3HxTj
         gzc5mJL4hcDuteCVYJ7lTUluGbZp94n1GzxKZcunJaxenHyPpmUCku1kQbOmotNZmcrm
         CZ4bk7h/Elhczxm+MXvgkAW0fcpq943b2YEN6bYXs6VIeZ+ODCqv3z3rXeNvpqjoTywo
         6F9XR1zdjdLTo8OWgUmoLlid8JOzS1R+oSi6b2CAtdnlp0MQKEEYJSv9kvgOvoYFJvih
         C7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777370165; x=1777974965;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DDmRuryL0az6H6BjGlgdTK5jjjtEkzbzFLNWK2PRayI=;
        b=p7VM7b/sKRBUQsHSsQ5VKhDX/LCmBQOkWUcflbZO6Xx7NskaxGLq3z0aOKCUM8OSSb
         MbmRQZEV7LwPS39Cg/9FlagIk7V82bKmxshrlzJ2+CJlTV3RHiw+JLhYwUsmi3aNg17T
         lprjtZXPHJwU6fsJjWGmwgPGsk8ekaWb9UEQHzzCK6gc6zPXgkCZ5ajOv5DunxBJsFzY
         Zvldx6mBZXD0mJ/Eyk/N8rXKIU9et6mw16BP9nRQ04QvXgWm70/6muc+/JWZ4yr5Cwbj
         GYlxCOS0YMo8v8XNkbASm0jRFgyGUjPpl8vMrtY8+pdc/GJDWjU8KgskCZoL6MkbzXYO
         jWqw==
X-Gm-Message-State: AOJu0Ywe1ZexLs3Xru9zQY2mI6sEsVxqzoNaTTNLHhiF7hzzOMnjXJwJ
	iqM+Tq2lRdAs5LdvARiqdDt1rGX7DFoAjaumwnpIK48drYtlT8bH2Ab1
X-Gm-Gg: AeBDiev2rd4HrpymL/q2vEwoYWyw1AcnS9GeWllMcyOjF0gy+v9YnxYTGAuwXcrtAw6
	pB+dv/823r0ii5j7ICgfVpf+cUZKmJEYYsnsTWjDBE2RXGiUwndDyMSHaUXbyfNOvaan8m3SefT
	99AVPbCNHVtrq/Ywk5VILlUDcBzQihinl1s4teJSnlzCtxYhRyNlWk06kl2sEFs1h/5ocXyqFLd
	qOIthfwzm6x4BBC4EpSBI6JH3rboaYwbQibHX/w0cZbzjHTggDk4dDkcDQl1dSTurwlr+5HRY1V
	nSOHD4Ei2yEQy173VDTQNhFOoniCvg3FT/1biW+N2Y3i5r9brIeLcPIdQumiYUgHL3s+fZGwoy5
	Sv5s2zlneGzXFPxGVKOwEXCWB6CKTTIXfqkYdsHuv0L3kjnbhlktcPA1otm+lNbCGIFleHCZJuF
	uSuOJhlFWc3aOj/SiJyoXE3JgOc8s2he7ILCFrgY11poKAlXJx7WOZcPHP6EMNjhixjQdYXZBPm
	kA=
X-Received: by 2002:a05:600c:1f92:b0:48a:5821:5ffc with SMTP id 5b1f17b1804b1-48a77ae0329mr37034855e9.2.1777370164737;
        Tue, 28 Apr 2026 02:56:04 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:60f:89ae:9995:66df:f74:57a3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a77b29487sm42186485e9.13.2026.04.28.02.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 02:56:04 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai@fnnas.com
Subject: Re: [PATCH] md: skip redundant raid_disks update when value is
 unchanged
In-Reply-To: <9748ccf8-7d4f-495f-8083-eb640008f073@fnnas.com>
References: <20260425085843.3725-1-abd.masalkhi@gmail.com>
 <9748ccf8-7d4f-495f-8083-eb640008f073@fnnas.com>
Date: Tue, 28 Apr 2026 11:56:02 +0200
Message-ID: <m2ik9b4de5.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2026 at 16:25 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/4/25 16:58, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> Calling update_raid_disks() with the same value as the current one
>> can trigger unnecessary work. For example, RAID1 will reallocate
>> resources such as the mempool for r1bio.
>>
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>> It returns -EINVAL for the same value. If silent success is preferred
>> instead, please let me know so I adjust its behavior.
>> ---
>>   drivers/md/md.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 0e55639211f2..cb66c4ebbafa 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4409,9 +4409,12 @@ raid_disks_store(struct mddev *mddev, const char =
*buf, size_t len)
>>   	err =3D mddev_suspend_and_lock(mddev);
>>   	if (err)
>>   		return err;
>> -	if (mddev->pers)
>> -		err =3D update_raid_disks(mddev, n);
>> -	else if (mddev->reshape_position !=3D MaxSector) {
>> +	if (mddev->pers) {
>> +		if (n !=3D mddev->raid_disks)
>> +			err =3D update_raid_disks(mddev, n);
>> +		else
>> +			err =3D -EINVAL;
>
> Changing return value in this case is not expected, especially from
> success to failure.
>

I=E2=80=99ll adjust the behavior to return success instead.

>> +	} else if (mddev->reshape_position !=3D MaxSector) {
>>   		struct md_rdev *rdev;
>>   		int olddisks =3D mddev->raid_disks - mddev->delta_disks;
>>=20=20=20
>
> --=20
> Thansk,
> Kuai

--=20
Best Regards,
Abd-Alrhman
