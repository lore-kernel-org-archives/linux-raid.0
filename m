Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0665A4A33FD
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 17:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784138031; cv=none; b=Isg0I9E/bpuV/TvENLKczc29n5uBoSA7LKlFq0a4Vj2RGNjbXYuAtUcvm0jEL5dECRpUJs1EFMgbQS9HkfglY72bycoPsSVzowcIA1w+JFjLGgrlQVcZ4A2NFodUeN9prrAHqXleebfMpahER0+7anv4VhtGbXoYgAhkdlzf6cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784138031; c=relaxed/simple;
	bh=m1C3pkILcJOw+EgLvLBtjkWIQDFSl/IIofLGks0KqV4=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZjayR9qz23Ry+bRFvwcULgRVrvs/S6B8xKkjn43ogL5yeByV8xfZxy/ETrIAsvPWRXOuBxu/Rby4N7ZV57z+hKgpO7LbriBCXeH+dAGhc69zET1IVLeijk13GxlD7trhfO+rpBUhUwHnCpHdCHAMy+LfD7A8ZR+lJi79nz7rGeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BIDKEitL; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BIDKEitL"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-697bd21fdc2so1371429a12.1
        for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 10:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784138028; x=1784742828; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m1C3pkILcJOw+EgLvLBtjkWIQDFSl/IIofLGks0KqV4=;
        b=BIDKEitLEvtFok3oafdt70tRjddbHoZshT4LfMJIVszdpsRG4e6Nd3XeNP+SaTa0yL
         1PYNmQDNSmlQDJnm6oYVbKMInzeQinSjlCDgsi2S60+zAiCxkx+iNAkrkhBCEd3Omksr
         8+tfBPgEC1PZxbFicG5jLx4/omAqdlDuijXXdLtJSYJVTTacxe4sEr9o2jpd/1cTir2N
         TiXez+a6u6GKH09XvUl0PCdc01pZEP4J9Ibre/wHvacV1J3omuqMhAoDDHwE4AM99NBl
         704TfirraiqMpnhYeD3R1/n19O3Ustc6d1JNcO+mjsFbhS9SNu2auaPkfOdATm9VGHky
         QrGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784138028; x=1784742828;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m1C3pkILcJOw+EgLvLBtjkWIQDFSl/IIofLGks0KqV4=;
        b=mJ4ngDOTCADObiwVj14JoYuVu7FJYYwibe39d7BM7Fv8tlEhNseDMR8ezjS5dII4d9
         K1SQ93Hn4+aVxiqv9pFqx4tKXGr758i+fucXOuPxOd6AN1n8x0Z21xEUeLW68slYicnk
         jVKyD0hBxrGR9uiCpxM4k2ydNleXm2f0jl8JjuNDum5iLu0bpCIdRMy9kc1j9qWkb9v8
         t5wIdYU3/yA/VMY+jN/ZY6z7PqL6tx40CJ57QROfMDqKbk9YVgOJ50+frvvUVzODY8Ur
         hczjFrhIJt6JTgM3xM4Xus+hM+B38MVQF7I5NDlah4v91IGzk3ficjFvN7SpjmJUu2Kx
         w44w==
X-Forwarded-Encrypted: i=1; AHgh+Rq8BJHdM/AeA1Hql9jod/5OI4m5LzRNV9MSj2we6w5Xo4u7MSvaq0oB8F3W34EfWW0r9PWaL/p+Do2S@vger.kernel.org
X-Gm-Message-State: AOJu0YypIauPI6AjLObX5ayGKT+teZ/2549G4BDJrzDaJQmWiPhN9JIN
	172s30u4pjWbY9yiBR4PWh75RxWxqtMsne/mOgI7iW91vId/q9mUNOP7
X-Gm-Gg: AfdE7cl89Jg84M/Vv68LPjN67sfaVP8eKnFbPwgu7PLWlJlxjgMHfhWUdLE4xtyeEbs
	r9tQV0wjuENNwF4Mg8+GuQh7uj4ykIF3OL/4glUhja0u0/CRzvIEIQelWgvzTvT9C0A1DSDIHDc
	ByzNDRxK0tZob58oSES/vM4JlUlbWekkgugMrglrv78p8YJnvwkoLOa+bFGPY9AOBD2/vT2K4VC
	OszD6lUy4HxbLN/xRJ0marxRUWy8HsyWwXYrOpbBcw2guwY1EeH15pk/MbDqWN8STVfTRl29+gt
	trtFnpHLh0y5yAqWR2v9MYngUPpPgEdIHqvaNLYsibQRf+NOPJaXFPJmPpQtViYOeRLESxzXR7o
	KottRR2TqmmlemS0IatN2J/EvJU90kpfuBLIctKop9YH3DLxBgQ+Lw8a8QjN1YBlpfwxbV2W74a
	pFNGunf5MJAqjR6b6qW6COqG2Hq7/0M3vznLfurtTkqRCkI3u4gaQLOIpgSAagseu2+UD5fpZ0U
	iKPGLp+X4jEGvPtQA5JDuu7
X-Received: by 2002:a05:6402:2683:b0:69a:9355:d1c7 with SMTP id 4fb4d7f45d1cf-69c5f24e53amr9043797a12.41.1784138028136;
        Wed, 15 Jul 2026 10:53:48 -0700 (PDT)
Received: from f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box ([2a00:1f:e402:5101:59d6:a58:a64a:b7b4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69cd2922f91sm3441939a12.18.2026.07.15.10.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 10:53:46 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Yu Kuai <yukuai@fnnas.com>, "G.W. Kant - Hunenet B.V."
 <g.w.kant@hunenet.nl>, "linux-raid@vger.kernel.org"
 <linux-raid@vger.kernel.org>, yu kuai <yukuai@fygo.io>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
In-Reply-To: <2718fd27-9453-4dea-9d1d-13cfecef4e6c@fnnas.com>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com>
 <368d1223-1d41-4227-af33-bd6bd00b5c3d@hunenet.nl>
 <2718fd27-9453-4dea-9d1d-13cfecef4e6c@fnnas.com>
Date: Wed, 15 Jul 2026 19:53:44 +0200
Message-ID: <m2h5m0dtqv.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

On Wed, Jul 15, 2026 at 15:27 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/7/15 15:10, G.W. Kant - Hunenet B.V. =E5=86=99=E9=81=93:
>> On 7/15/26 7:27 AM, Abd-Alrhman Masalkhi wrote:
>>>> In other words, the first successfully recovered read request could
>>>> automatically become a repair opportunity. The repair could even be
>>>> scheduled asynchronously, so the successful read is returned immediate=
ly
>>>> while the rewrite is performed in the background. Unlike a periodic
>>>> resync, this repair would be driven by an actual read failure, making =
it
>>>> targeted rather than rewriting the entire mirror.
>>>>
>>> Yes, md has had this for a long time. Look at fix_read_error() in
>>> raid1.c. It is called from handle_read_error() on any failed read. It
>>> reads from a healthy mirror and rewrites the bad region on the failing
>>> device, giving the drive a chance to rewrite or remap the sector. If the
>>> rewrite fails, it records a bad block. md does this synchronously under
>>> a frozen array, so it is not a missing feature.
>>>
>>> The likely reason you didn't see it is that your array was already
>>> degraded, so there was no healthy in-array copy for fix_read_error() to
>>> recover from. In your case, you were likely able to retrieve the data
>>> due to btrfs level redundancy, and md can't repair across arrays.
>>>
>>>> With today's 18=E2=80=9324 TB HDDs and backup/archive workloads, where=
 data may
>>>> remain unchanged for years, latent media degradation seems increasingly
>>>> relevant. A successful read from the alternate mirror may be one of the
>>>> last opportunities to refresh such a sector before it becomes
>>>> permanently unreadable.
>>>>
>>> And Check/Repair is the right defense for cold archival data on large
>>> drives.
>> Thank you. fix_read_error() was exactly the piece I was looking for. I
>> had missed that md already performs read repair when another healthy
>> mirror is available.
>>
>> My situation was indeed different because the array had already lost one
>> member, so the successful read originated from Btrfs redundancy across
>> another md RAID1 rather than from the surviving md mirror.
>>
>> One question remains, though. check/repair periodically reads all
>> sectors, but as far as I understand it, successfully read sectors are
>> not rewritten. From a media aging perspective this is a different
>> problem than recovering from a read error. Have there ever been
>> discussions about a true media refresh pass that rewrites successfully
>> read sectors to refresh long-lived magnetic recordings?
>
> Perhaps this is what you looking for:
>
> [RFC v2 0/5] md/raid1: introduce a new sync action to repair badblocks -=
=20
> Zheng Qixing=20
> <https://lore.kernel.org/all/20260203061259.609206-1-zhengqixing@huaweicl=
oud.com/>
>
> However, AFAIK, Qixing no longer work in this area and there will not be=
=20
> new version.
>

It seems interesting. Do you think it's worth carrying it forward?

>>
>> Best regards,
>> Dion Kant
>
> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
