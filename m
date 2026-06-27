Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6202C21F0
	for <linux-raid@vger.kernel.org>; Sat, 27 Jun 2026 11:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782559549; cv=none; b=qKPMxmgjCFo7PNA7361oICrqJw8fkdDSfYnest77wWe10fEqGliyKbjReb2Zkda0FfYHpwso8SPrDxCaP1k/BesradTCo8OlXTELaRmanXYSykQSOHhE4Z7ATlXoxhyY7NfJ9MmU43ZZOMiKjxLuKRXagRSuutEcve2OULHmQdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782559549; c=relaxed/simple;
	bh=yV0SvxMkq8w1vh3jiv7FYnXkHG1zYg1t4ueqkd4ijnc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Yb7esMbrUslfjOT/cR1lTBBp1TejQfT/7+ikkK3Q4xsDUPYUuOMugH6p2y7oVnKEkZ9Lxs048h1a55TrQEnzrzeKv9cJueWN56y181G0QBpe4uM8bBVAy8y5yKKJQbmNtLRB6aveJJuZuIhtB/TsgLxkKA6UdtH1ZsWNUzKsdzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SD7f7nD+; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SD7f7nD+"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493a287b8c1so831935e9.0
        for <linux-raid@vger.kernel.org>; Sat, 27 Jun 2026 04:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782559545; x=1783164345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yiEQJgz37IF5ItliBSbJ+D+0d4CD8jTL0FdscRFycZ4=;
        b=SD7f7nD+wQOsUAQmeDgp8EX4IKMAb5zzxylhuKoqFcWw0GBYampKQldqn7beji/1If
         qlm+vj239NH03keUtU5NZoBz1TXARkVmQLO8tih68E2zr1z0pOUXnPfmhbvb7ihTSO8F
         sQUgpt4sWf9Z0yYMOknNY3kGVfi6yEX415MjFeyhp15t3SPZmKhLZxuBqaiuln8tOAB2
         1GDF8PuF+ibO+Fg2mZKAgRGOw3HCKGvEuNUjWzEus1HM0IEjT22Wx0YGhIg0YpxMSo77
         +pglX6fvUtGqF/urfYV9F1hVxxTAF3j+r41D4Kvz08luYQVQpFtLdNvKc/e5QYOsd5Zs
         zjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782559545; x=1783164345;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yiEQJgz37IF5ItliBSbJ+D+0d4CD8jTL0FdscRFycZ4=;
        b=EJlNxdsj78hjG52dScGyh54HssZeQW1Erji13iDKtrh8TeC7adtAggVmgVbs/ekmbE
         VJ0su/QjiCDIG+Z0RmjQ7boRB1XvZE/X/3awLCc4upaKXL4e/rJp30j8IqopbQ/pE304
         Afuj2PjCsc4o40LrBslLVolopUhgfyt+4kzvTYg/Stq/KmMLL4FaEmnYDBbvcA7Qgc9Z
         P5qZkPYpJu1PpmmKjXRvwsQLFUzbPch/vIESIvegMcBnfsYFVb3OtKT3dhblZYxPYrjZ
         XZtL8WjfyKDQUigqG97kiQbn/FstCqfIP3b48J1vCnTNnYMBfcCOLNJ577WnrpG7JF2x
         CGKg==
X-Forwarded-Encrypted: i=1; AFNElJ/Ym9+TrdCrnw6wbgD6HtFJkKWLXKOoD8ayr4Rs/xM8vrW7i8qyuf03MsXmWgfuHwHwFbUrRXDqFy5R@vger.kernel.org
X-Gm-Message-State: AOJu0Yy74AIdkBG2uGujDX45GRnCb2wB6T0t33IkEOO3kjRMLAeKzD/x
	P37/j0c/QcS/vFpxT6IHrzUysGGMFgVXywYQtYrtaXIli8cODjr662hC
X-Gm-Gg: AfdE7cmt7WxYYDGO3JIAP7GOcLoqevsK0JuMzUGtKkNzdbHnFH7e8I0iU2975pAq5I2
	cI6EQBnyStTCuSlYSEEiZ3ldhSUwOwXEC0MCAB0Je3xW3Q6mBjlhmA6zncSxxpZEqzTq5ol9THw
	vkT0EF4btImXpin/wiXl0+XHQIxGaA2XDvyqvoStJ98+KZSwKb1T25xxJy0ZUCQUFqhlK/uPFvb
	1+I5DEimjlqvz2/Z0Gy9LJpecOgNWY7UE5L/K8qaXMpcfARnhxWy8sZcm06uYpg3/z+N7LSGWnQ
	GmeRcB2erMalFpgRUM33zKWC6hru3LZ2P9mldoPZOOhoDmALr6oMzwfVoDJpM6sQ4gsKaDDnun9
	8xYTsiyIEKtT0Hn9/C70RLDmzZbs4pbD/kyezj1XOUSmk2VwjtVT0IB0DmYTS9Ut8A/MZW2cDX7
	g5vXm3d4gpphRpDrDX8v5ztRzb5iEMm8IpFJDdMy56/9IyxcxVZzX8JGDo
X-Received: by 2002:a05:600c:3552:b0:492:700b:deea with SMTP id 5b1f17b1804b1-492700bdef5mr68021295e9.13.1782559544578;
        Sat, 27 Jun 2026 04:25:44 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.129])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49269071c9esm150040755e9.9.2026.06.27.04.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 04:25:43 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Chen Cheng <chenchneg33@gmail.com>, Chen Cheng <chencheng@fnnas.com>,
 linux-raid@vger.kernel.org, yukuai@fygo.io
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: protect read mddev->recovery in md_sync_action()
In-Reply-To: <da95c106-6416-4abd-8fef-3b71986c17f8@gmail.com>
References: <20260627102909.141036-1-chencheng@fnnas.com>
 <m25x341cro.fsf@gmail.com>
 <da95c106-6416-4abd-8fef-3b71986c17f8@gmail.com>
Date: Sat, 27 Jun 2026 13:25:42 +0200
Message-ID: <m2y0g0z0ll.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Chen,

On Sat, Jun 27, 2026 at 18:52 +0800, Chen Cheng wrote:
> =E5=9C=A8 2026/6/27 18:46, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> On Sat, Jun 27, 2026 at 18:29 +0800, Chen Cheng wrote:
>>> From: Chen Cheng <chencheng@fnnas.com>
>>>
>>> md_sync_action() read mddev->recovery in lockless path, use READ_ONCE()
>>> instead of u64 plain read.
>>>
>> unisgned long is not always u64...
>> I can not see what it fixes, is this just to silence KCSAN? If so,
>> please say so in the commit message.
>
> I need to find KCSAN report , I lost this one, but I think it's easy to=20
> find locklessly path to call md_sync_action(), so. READ_ONCE is need.
>
Thanks. Adding the KCSAN report would be helpful.

>>=20
>>> Fixes: e792a4c2156a3 ("md: add new helpers for sync_action")
>>>
>>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>>> ---
>>>   drivers/md/md.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index c5c50640b684..f4415c1a79d9 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -5074,11 +5074,11 @@ static enum sync_action md_get_active_sync_acti=
on(struct mddev *mddev)
>>>   	return is_recover ? ACTION_RECOVER : ACTION_IDLE;
>>>   }
>>>=20=20=20
>>>   enum sync_action md_sync_action(struct mddev *mddev)
>>>   {
>>> -	unsigned long recovery =3D mddev->recovery;
>>> +	unsigned long recovery =3D READ_ONCE(mddev->recovery);
>>>   	enum sync_action active_action;
>>>=20=20=20
>>>   	/*
>>>   	 * frozen has the highest priority, means running sync_thread will be
>>>   	 * stopped immediately, and no new sync_thread can start.
>>> --=20
>>> 2.54.0
>>>
>>=20
>

--=20
Best Regards,
Abd-Alrhman
