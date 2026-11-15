Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794764613;
	b=5NP1lPr8YhZXNqEAaM8ObLwLZzs8IyG0/knci1gydVmFvarIEwYWloPZJlzy0fG3OLVH
	 vEaWfe8TobwJBntnCDRKRXtoW0u9bHuHhc8mXnejwNstjLiglnvdHg3elHnbLw2+XgDx4
	 HqdNQVo1Q46OWgQ0OUBtQv5ID2AylIzESg22JO3TWQ6dFIWBRIb3LZooPu0wAtOmWk0b9
	 F5aIry1f59zaYlwEzZUjX9Xz45WnPboUOQUi+SbNCF9cP48e1LIrjRJciatze3LZqekGp
	 aUfVaPOlORPM/66ZPi93W2Jjzokm7RN6W493eVkrlAKWNXpK3F8s0A5yYEaZ2xeu7fg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794764613;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=l8m1DI5EER6esOn+ArrsUBin4P5lhG5O2vketHHBX+I=;
	b=ytjvoM2W+AKECYsth4ixASmt5er79herASc6W6Z4rKrT/eX722aZ8tTjoSkYO28VIRLB
	 uYZ3dz572i7xsjR/rLqUOnniRF0rTy9d4fV2968p4C+1bGbORsM8kQbe6IhB0vEa7c2fs
	 5M+b4GfmZFh+D9A1VwJpPQMX5rb5McPCj1/C1TQzGdyBGFSk9nuIlPzpydYoH/8rT6mpN
	 nPny1aINlwxQgce8hIraeB3x4TD+q2IhVvFkeFCNBHiaEiypnhb6Q40U0ec2nkttBdZRH
	 cf9eiEBvZIck3sfc7NPmccYtr0YlxlIB/Pqpgsz6AX+uQHRJ77LIxNWHvNTyolFVVtg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hhNNWAQf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC22606A31E
	for <linux-raid@vger.kernel.org>; Sun, 15 Nov 2026 17:43:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CC22606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hhNNWAQf
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c50cc8e0f84so69714266b.1
        for <linux-raid@vger.kernel.org>; Sun, 15 Nov 2026 09:43:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794764612; cv=none;
        d=google.com; s=arc-20260327;
        b=q5w6uK/CV345yspHy3uPguDMxgq9ehf4NxIfWINNz6yuJrwV2OwdkgC0Z6sZ0Ezmzm
         ajkN3yy1hfCzrRv/10U5Rli5rNe1U/wRRJyuMoHt59e8ncHcC9D0THYRUtP+/VNN9wvS
         2QZvMWqoxLjp7piwtkEpKKmqxLJ+LRB2E/7+kEFLJVEHoT3LhfcalUxAQVv+bgBUxye7
         LvDQq2CQXhGMaaFbEakMkvBdUMaOpOhHEGGkVSlTa3dqd1t846Y1pG+ZYo6aGTPwHVxk
         dJRcDujVgIbqCrR9cgw7uYFMjrYn2smIdFYu1FSuS0gb1URgjOuAaqG4lMR0xiXET4eK
         en0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l8m1DI5EER6esOn+ArrsUBin4P5lhG5O2vketHHBX+I=;
        fh=DP8xE/C7gMfUZ8bRoLFh64n5LJUDSzVQy9lKEi3BgQw=;
        b=jwfqqbrgGY4WG+/ehz0b/0oPtq5nU/OfNh04skhDDZrhKEIaTNheYajBQUrb83X8HB
         8y8TJ3tuM95VfT6l8GvHVz30wgKWxHHFozDv6oQBP9DmTQ/K+PiYyvCN01OzqMY4DAre
         tUe0b++zgpGHPX17kyWyYlhOI1M1K+RK341wUURW7tQVDNGDW+ENCphbfhVEnoqkrVnD
         gdpe/DZcnvYtKnZhc2zisCT8YqVlANcn+DUcpxCRgp2ooR1m+UkvlvfV68ztz3pbK2oy
         mAthEepHSnhnqa8+cDNx87WFFgTcsQwLPq7ttkWvAcjmr+xqvT4WBmaptX9Ex+evlr9j
         rVSQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794764612; x=1795369412; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l8m1DI5EER6esOn+ArrsUBin4P5lhG5O2vketHHBX+I=;
        b=hhNNWAQf/JIrCr9UECu0XJL1iBTgKVciK/zdKQMU9W37KvfKSCdZvPhyS5EZUFRdqh
         1EreMhH0wlaNgmSgg1kl3h0F9CeXdjMzDlVuN2TofJ7bikgGEbo10ymONWlY40cJnv+J
         OlxnBaH1vrdqn/1RXLvKvyvxjLIcN8HzcswhTdkeEosvBsP0/magOnm45vpcRq58u1Si
         NKVVIIsuyrQtftNwQxudO0hqp3iVA9NfWPDF+VCWgMCxI7fOSstP8rUeTafT+/81lqID
         I6JGSFVYt5wCqJH85cvxzhPCNhKpY1TMumDuUtspikfXWtxx+8g/9bMTLYTixRQyCNTR
         ajLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794764612; x=1795369412;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l8m1DI5EER6esOn+ArrsUBin4P5lhG5O2vketHHBX+I=;
        b=FQWaQWPychOJkCbQ0QWuEuLxyLHF2xK33m+/4HHjDcIWDJJs8TEInJFoHqnNql9mYi
         fMN6d5rrqFcYJBaxj66k3yu3ciBBMACClJNDrf1vgoK15NhWMS2JhsDBks2qYB6QYil9
         Zx4X+/4ACm2GbeZqVXyP4D7vYihRb9Bo3aVNSZkonoKlPITUkyUo7ql3qvymNeV82C+S
         0i/BiePBzYxIv58H5PgZOrvxwLrnO6pI0663Z6wGI61h7sUKaISLsTkveSinImgyFLUC
         XcazART0RfB89o82BVyhZKV+Vr1oR0OQQzX3RbAr8L0KrhByo6SVZMHkvmbzxr6r9sKZ
         TSSw==
X-Forwarded-Encrypted: i=1; AL+hErFpRpzDyBDCJcB3/AB3/hCH+xhCeQDsI5wd5vexno+AsYU9vvwidQi2p1bsZPipg5P/hcv/dYWGpMBf@vger.kernel.org
X-Gm-Message-State: APuU4Z9V2tkEWL6PWABhqSJU3p95hQGrmZdNjwyctU4STTdWEGEIVy+t
	WerA271VD12uXs1G6TrCgXF4lqoJhhUQq5YsMaA26yRk1hsrY/1X4NLVdh6TDZzzTnWTlZBECaF
	8O11DLLR5Owh3oTjFlTBPcYrnU3xsq88=
X-Gm-Gg: AYBFou3nOQ35hq741mIJzDXwRT8UxC7UMBanYuiLCotPfJRWi54mkWElIviFJy4tMR2
	3PRsX2Zq3I+Dc6PLIAl0fDSWQka50yItbfs9SSpooeYProKC5t3jCfpuk1/P3JkXYGiqbXiTSg5
	cWz06wxfZQTqkjD4/ceghAh8Hljjwz+IS5FtdtEV4tVENTfPW7nmWNxW/HG615fah4G9zDSjDrS
	z33sN+OkGmMNQEYRE+HKbuytRKBXySJCCF4dX0dwFUS6BeP6+uOPwqv0p2PULv68/OMrJLdthHf
	4Qq+v/9vg1txpXn986Mv99+1XvCZ8a2w/Ly4dl8VpjWLUZWEtiI3P+dvvimhlUXodbVLVo7yaMF
	6nZYHUsUBjGOtpLNivBlB1/exZkhzqwdIaSQEsQ==
X-Received: by 2002:aa7:c1d1:0:b0:6b6:4dcd:9677 with SMTP id
 4fb4d7f45d1cf-6b7c0957768mr4340738a12.14.1794764611546; Sun, 15 Nov 2026
 09:43:31 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114224636.34362-1-mc@raidlab.org> <20261115125515.56112-1-mc@raidlab.org>
In-Reply-To: <20261115125515.56112-1-mc@raidlab.org>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Sun, 15 Nov 2026 19:43:20 +0200
X-Gm-Features: AclHuK_5e2lmB46bNVTzg6mCOVxTXXudn0oK0q_D37MwkgbB9Zl7L48-wnQHpY8
Message-ID: <CAAiJnjo=UW4kdcMqU62JChytMg6rOLOKvxJYDD2wy6eRK-m8QA@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: fix write stalls when a write is queued during
 a drain
To: Miroslav Cimerman <mc@raidlab.org>
Cc: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com, 
	xiao@kernel.org, neil@brown.name, tj@kernel.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Anton Gavriliuk <antosha20xx@gmail.com>


=D0=B2=D1=81, 15 =D0=BD=D0=BE=D1=8F=D0=B1. 2026=E2=80=AF=D0=B3. =D0=B2 14:5=
5, Miroslav Cimerman <mc@raidlab.org>:
>
> Anton Gavriliuk tested the patch on the same machine as the raid6
> store patch: HPE DL345 Gen11, AMD EPYC 9455, 6x PCIe 5.0 NVMe, RAID-6
> 4+2, chunk 512K, no bitmap, rmw_level=3D2, v7.4-rc2 with and without
> the patch, fio 4k randwrite, O_DIRECT, io_uring, 60 s, 2 runs per
> kernel. Slowest write and IOPS:
>
>   md defaults, 1 job x QD64:
>     without  max 59.3 s / 45.1 s    128k / 124k IOPS
>     with     max 2.9 ms / 2.9 ms    129k / 126k IOPS
>
>   group_thread_cnt=3D8, stripe_cache_size=3D32768, 16 jobs x QD64:
>     without  max 56.4 s / 57.5 s    472k / 474k IOPS
>     with     max 9.2 ms / 11.2 ms   483k / 479k IOPS
>
> Without the patch the slowest write of every run took 45-59 s of the
> 60 s. With the patch a few milliseconds. IOPS stayed the same or went
> up a bit.
>
> Miroslav
