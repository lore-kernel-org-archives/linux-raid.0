Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB4A3E559B
	for <linux-raid@vger.kernel.org>; Tue,  7 Jul 2026 10:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783420515; cv=none; b=IHyFBXYWdVHGY28oS9eBO0faroxnRU6WKL4uthJXiWYXfrpbAPY50ZmaUuQ6coZ5BR8LePK3f4spB3QX02z6+QdIxk+BydIhugaMzUtH0mBm6nJf3Gto65zu6SZJtTS6ybbC/V04RO+0n9sPbj5flBuaaE0Zir89gG9cY9h/DhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783420515; c=relaxed/simple;
	bh=uTcTJtQiQq9rjhO/KJFkg+mOFmnaKsZjnWAeZcl5Y3s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qvOcOKlv2prRY2GpEI3wHS/OT3H/LTB3Ka1/zl+V6WfwUxfjkIRkCOcAdHLhwKYFQbmkCqgOjU0YNPQnwNhX34N2Vy9xN2AcBaKVkuX4u1TdUYoVhoZXP1jMpLM9a5sy8MO7Z3YTu3eSenKa2f2JKxnk0BLgEBL98npKKp/5zhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7J6DJIE; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7J6DJIE"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so38441845e9.1
        for <linux-raid@vger.kernel.org>; Tue, 07 Jul 2026 03:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783420513; x=1784025313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uTcTJtQiQq9rjhO/KJFkg+mOFmnaKsZjnWAeZcl5Y3s=;
        b=D7J6DJIEC4jw+dmDd9JGNZ6FhlLXZR2x5H1FMZwucQLbq9IlJxgBQW+iwmRvx53tlR
         1XlIQ9R/ROCWViN/97Gn4zk4Zt6CE1TGL2E0pfHdwCGVSnv5xmauQ8t+IC6JHIoZJpE5
         1yCt4hqXlVap4fVzSX6V6BwxxR/Rfci3K7ZTjpXY/c7ZxahI7HIv6f5CSopGMG5FWTf+
         Ud1aoBuq9VdPOqK8dWTf/cspv1+/PweCNbMpAvJelWLeY/YdZ5lZOdYbQREVYpnAare2
         K7DAqBqJ+Cj5NOUUM6ntklpdohX+NMesn2jiXpmihtDgXnphXgf/Q7zylwAmRgQ7dq86
         u11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783420513; x=1784025313;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uTcTJtQiQq9rjhO/KJFkg+mOFmnaKsZjnWAeZcl5Y3s=;
        b=kTvITVqbY3kQ7yMWo78SdWNJFXMkAfoz3XQmnHdRn7lbgDhjBtK+3roSA41aGT2/xG
         1YJrCJlB/rYDmdOGJI7FFolLgn67BruQkJ2+XncgxG3iX8BncUfVjth4FQ2n7snlbKNX
         9FCR8jY4g048ig8I/h/C6O1ZohR8tWK6eQgSQwBOrwmGwpuWn9Tz5+//RAvO83VJNYFB
         0nnew0taZlyXe5ijIQ1sSZ6vwQtddxbdPfGBMIqOczOSex3qS85lvcWf4lXwALccjJCZ
         s0hXuuM2Rmtxuk1zywWsM6WNdDsRNVTdm3ODo7UwJaAaCZ7jxfQcGgcC33ZWts56wKrh
         kNLA==
X-Gm-Message-State: AOJu0YxYZJ8AkBP0gwuNfBpYFPv6A0Kg4dXR03YPqsZpwRiOTXFg2/Uc
	gcqJ5sEZF4nrbSLHjbCMUq1sHMdojfhu+jBGweWf1imDgrVMebxRKOi028A5lQ==
X-Gm-Gg: AfdE7clBviteQZoJZekHp3+nfvMC5YCObobplNcoEmvtosF0GoMJt9qVKAmiUoGTErC
	Cmw8Zf0p4NGOy21QoCpFyCF6iq6B214XeeVntGmIw/ZpbpFahy0oiRaBbWN+4DNTQ8uqyZ0I1ZX
	BvuNuLzsZ8Bys/BWLOjxu5KdO7FM3NT3fz0csrfeHLvAgcHtFpnSpC/TyH7JpV9LVBo592LGqI1
	qooBwzowAYITzQ20Kn8Shsf0rnsJl72hjkhJBZNLhTJqb/h6SW/Z1YHTZ25W7/R3xn+Kv72t9WY
	jpQzE64HjtDQCwtZJ9Ml36562PQ2q3nwW7v1P2/efiLAn30F90kYf8sM0JYFgPIJl3g7db66pQr
	9lnNgi3HUGhFUKuYMQDh52jylVwuRlKctL/2VfZlFCnuWAq9SKiqE66ebzgtjA+aT+Wwl9r8xSz
	W4pTRvrvTytXoEl3AkClAeCFCeR9LpdFZSKDqPVNsxz6eCVw==
X-Received: by 2002:a05:600c:6994:b0:490:9588:bdb6 with SMTP id 5b1f17b1804b1-493df09a21dmr48212065e9.33.1783420512704;
        Tue, 07 Jul 2026 03:35:12 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([195.72.110.68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d7801sm33321623f8f.16.2026.07.07.03.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 03:35:12 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, yu kuai <yukuai@fygo.io>, song@kernel.org,
 magiclinan@didiglobal.com, xiao@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, sashiko-bot
 <sashiko-bot@kernel.org>
Subject: Re: [PATCH] md: avoid modifying spares while the array is not
 suspended
In-Reply-To: <4f0b2516-65bd-41fa-abc3-3cd76951ec46@fygo.io>
References: <20260630075640.1081634-1-abd.masalkhi@gmail.com>
 <0a7dc7e2-30af-44de-8c29-b6e27a62fa55@fygo.io> <m2se5x6wff.fsf@gmail.com>
 <4f0b2516-65bd-41fa-abc3-3cd76951ec46@fygo.io>
Date: Tue, 07 Jul 2026 12:35:10 +0200
Message-ID: <m2mrw36qap.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

On Tue, Jul 07, 2026 at 09:12 +0800, yu kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/7/6 3:58, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>> The problem looks real, however, I think this will cause a change that =
user will be awared,
>>> if there are really spares that can be removed from conf, but array is =
not suspended here,
>>> user will still expect rdev will be removed from conf automatically.
>>>
>>> In md_start_sync, if suspend is false, can we check again after mddev_l=
ock? If suspend is
>>> supposed to be true, we can release the lock and retry with suspend =3D=
 true.
>>>
>> Yes, I see, and your approach is much better. But what do you think
>> about taking the lock first and then checking only once?
>
> I don't get what you mean. If we take the lock and then check that array =
should
> suspend, we still have to release the lock before we suspend the array.
>

Sorry, I was not clear. I meant, do we need to check twice, once before
taking the lock and once after? It seems that the check before taking the
lock is redundant. since the result would need to be checked again after
taking the lock anyway.

Could we drop the check before taking the lock and only check whether
suspension is needed once while holding it? If suspension is needed, we
would release the lock, suspend the array, and then reacquire the lock.

> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
