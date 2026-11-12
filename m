Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794486812;
	b=Ek1tL+rGOCrGGXAD9AWYzzVGeG8WfkjwfDBDWMyBD5+/cGIp30j9MqI3eUAsaYIYML3x
	 OmQmrTYWGvgTDV5qhcIYtAHW5XPmCEf5tmg9olKikQ70Mk9iCFCC46uxb2nuy9eBZFIbn
	 PnERTFKUnsYvss+jTx5qh6sPnLOPmx6MICkTNTEPIm2pPFSdAGGaDhdc76AH9g8Z2bb3M
	 TG0TXjkOMSJBshFZap3/e/qB2XLkoyv7s0YCXVjm510WSOMOaXJ2fmYIbtV8CnwWIzpxa
	 EDgz7K77Q0y5TWn3ZlTVXP67iVW9fQQKcmLGwSlMXpEAmfdOhdbFU719oqnNOYjK6zg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794486812;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=J3TZhCQIYhGC4591WyZya/dZFHVv+pLRhRtDYsixm+Y=;
	b=BzLWovxbklwH34ATAUPaVT1L7nwzOwLHOpQccR7cjT2oKZ7mlZt3tXy3rYlsN/howz6Z
	 ZDEZoEed683bjbOrbainbgN0EahaGOGIqfXh2HY9pfv7i3k+cYh/JmF98YKGbjoVOYGI0
	 02r/jEw/OyEI5kKfQ2z4+LJrxt1lGDWmiKH6SxsvuyMdCqVt8TY7wNKzQIaN9/4SG8UJK
	 YOZIYVOYsVDKpkuYbwUQpBFWmZQxpn00Pci494B0MFMGE/KCZNPr6MgUzhA4EtnlUnDef
	 5QHqLOLKh/W/pgVvF/tHUS8+78glsx7y9Fk1k3pyowg7B8Dl8vT6LsC9VhenBZcIgkw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LX8QNRU5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD255606A321
	for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 12:33:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD255606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LX8QNRU5
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b6e7a05225so5627195a12.0
        for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 04:33:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794486810; cv=none;
        d=google.com; s=arc-20260327;
        b=nUbmU7E4WLAWFQt6kyG6+yyALtSTRcBWXZUvL1sYPT89Evta/+gzf/3hXCFw8PIVXh
         hZzWpQOfvTT5W7KbuvZEpsRmFqKdyxGgTxNqPAyyTTa20poxLg2i9pc44iCwcu3vzqnq
         d5B9YmeYC+03SkQ9emxWPF1aHBCMUif1FWXu882ICEHLK2kOKP1aq9UUcnqYhsCH7frx
         2xdCgaye/g4Uhsw+FHdQEXEqALfZrp1MOvWBE+udltR9lOUgkiIYuA6+UOvm6q77BCjo
         p1kNB/v9E5IMCg2BAkUa+btCDgy91j+1zUe05xxWCoiN+9IP9pBX9iwUazbPb/NKKyMf
         aXwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J3TZhCQIYhGC4591WyZya/dZFHVv+pLRhRtDYsixm+Y=;
        fh=cXz+Ev2IoPtIGhVmtFmxPk7QJjTYBCYlVwx5J3viXC8=;
        b=k7Js/lhOj0iE+p3CoyIOSnRS9UettMlD9Kk1txwZDiVMS2aFuyboDtp/92FXOJ+B4P
         SEoTWwwPzjngdk9kV+FD7vfce9CBs5i89ju5kB/6eikyg8wE7mCiErvyBhFaImqBQGij
         aFLslsdWIbVDgxBe/S2jjy7JeBcvbKQjihNhPgoiiV+wHwyjyAWaSEHXUdvswBdM/j2b
         SoEZX1pWxZWoa4FteUxf/r9eXklZx3GS2Xyp2D7HS0hXGXn4kulnvQHK6QxW/u/RW4q9
         DoqMbaOKsU+zC0xboTkfqSDaciJh4I/XAlyE3eee0c88sbNwuFC5s3eP9p8VARhAtLgZ
         wg6A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794486810; x=1795091610; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J3TZhCQIYhGC4591WyZya/dZFHVv+pLRhRtDYsixm+Y=;
        b=LX8QNRU5+EkJy1xN1BfxESRUZRxdYrEvHOhIj5oXwLpwbbV2NLiEpbHrgRAHHatU9h
         vbTDE33CEfzhAAHQLURfE9xIZ1aHLFIkFqayDylE5bi0lNePtPK7Nq/D4HPvYUzK5sqJ
         n9jolYH3kUXedRfo49UVYL8ZvbGm4ZxtSe50657sU77/k8ODpdlcCgK3sX5SLReJXBd5
         Ea70/uDLW151WDITECef7p7aa30Fw+J9PXOBp/PuatsU1UlSpgIJj3c6NopawuDwr7cY
         S22BO/HIyT4Qbvln6nBnfOQULoK2mge7hhPwcZ3pkeFuP409ajnKW31dcJnpEBO8SFNS
         EwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794486810; x=1795091610;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J3TZhCQIYhGC4591WyZya/dZFHVv+pLRhRtDYsixm+Y=;
        b=Z7auiYaCl7hoIg//+cWsE0AwJPi+0qRxkOkI3TVHgh/DjfRI3lGQdRrAcEppwDp4Sc
         xJcrP60BXuR8T9luk/8DTWlFlk4/Op+ui4+uiZuSmrGn9ShhB4E2ydEliy5vTuQYLol1
         tTEYXXJBPWGw1VDNuCKfr/s3JN1UuXPADFU90YUatTfdJDHENuKxg3E+xg3/n5AjUfvF
         7cUuruwnscKtoS5a6TzPffBWipz8+c7qO8RvqNnQqKQuLopze+4G+v1/pjH9zi+Dnd3K
         3PAhVKqhcQZPzvhVq9uibLR2Aoy8GZNEdYjSVzRDBk6SjPTvdFWugVCDTPaJtNDAu0Tt
         mB3Q==
X-Forwarded-Encrypted: i=1; AL+hErG9dk0uqTQsUU6UDxoyxvF6OHLjV7fcdFZ3uDESG8yAyaqXTFcYlczrVPrFuSHmmCvpdAzAVaGwwtmi@vger.kernel.org
X-Gm-Message-State: APuU4Z8rbGcuBRwvsi73NoYZCsBHUVKXezfMvYpOY/8egFKdcJE2OsJO
	baU1KXPScBsSjvxrcr6zN43an14v1JeFFFZOjzryD+2sZIZ2lLBgJRcp9HMax1aAqhfldHKYvgn
	LN2dBT6g+l6m8eqsbXcZ6ZXFsT/4JYOo=
X-Gm-Gg: AYBFou3sXwBvilHVSWjQNMK+P0zup+IOg+sQiu/2rGeQMAxbRi1iPOrjdEvCV6vi+fK
	v3I/OVFz6mB4YieOIX//eAEAltPjvoU4Ou3eWuymk66Yv1oLApgwfjXw2Y2VL9VT/u8KSZF1+TM
	8FvF9zmrc/FhnJyfvXipGEA4ownWny9ONzJNJeQC7PQLLKEg/28AjehSbkdK7tjA3EwDDj1R88O
	hPV0zPNA2FThNtNZUDlg4tKWZQsZSsWVct/8QcKm3Edm9Z/aFqg9H8ot7sGEGMe4Xa34W1evC5n
	IBa4cYmfeot3TgTNJn5vfgjccbjTV1jiRAtrRajilXBbfRLm5OEY0XJXbigq7o8dSFLjkkEqoQg
	2SrAbBlEm42oJN9qfJLAB1AhuQNBfRbeXi8pjfA==
X-Received: by 2002:a05:6402:2745:b0:6b7:675e:7a2f with SMTP id
 4fb4d7f45d1cf-6b77733a486mr4265671a12.1.1794486809988; Thu, 12 Nov 2026
 04:33:29 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109030805.25709-1-mc@raidlab.org> <20261112122127.190285-2-mc@raidlab.org>
In-Reply-To: <20261112122127.190285-2-mc@raidlab.org>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Thu, 12 Nov 2026 14:33:18 +0200
X-Gm-Features: AclHuK_MbQjLj10xCrM2NNFFkxEiEBFEpCNPgaDm5f2N80NILNDb9-2TU7lmKic
Message-ID: <CAAiJnjqrRo-75jg_Jrr0x2r85kY2g6_ZSH+8ukyJJ5UXyMb6pA@mail.gmail.com>
Subject: Re: [PATCH] raid6: use normal stores in the x86 x4 xor_syndrome functions
To: Miroslav Cimerman <mc@raidlab.org>
Cc: song@kernel.org, yukuai@fygo.io, akpm@linux-foundation.org, 
	ardb@kernel.org, ebiggers@kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, magiclinan@didiglobal.com, xiao@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Anton Gavriliuk <antosha20xx@gmail.com>

=D1=87=D1=82, 12 =D0=BD=D0=BE=D1=8F=D0=B1. 2026=E2=80=AF=D0=B3. =D0=B2 14:2=
3, Miroslav Cimerman <mc@raidlab.org>:
>
> Anton Gavriliuk tested the patch on Zen 5 (thread "xor_gen() md-raid6
> performance improvement"):
>
> HPE DL345 Gen11, AMD EPYC 9455, 6x PCIe 5.0 NVMe (CM7-V 3.2 TB),
> Fedora 45 config, v7.4-rc2 with and without the patch, both kernels
> select avx512x4. RAID-6 4+2, chunk 512K, no bitmap, rmw_level=3D2,
> fio 4k randwrite, O_DIRECT, io_uring, 60 s, 3 runs per kernel:
>
>   md defaults, 1 job x QD64:
>     without  127k / 122k / 125k IOPS  (mean 124.7k)
>     with     132k / 139k / 137k IOPS  (mean 136.0k)    +9.1%
>     (a repeat run a day later: 127k without, 135k with)
>
>   group_thread_cnt=3D8, stripe_cache_size=3D32768, 16 jobs x QD64:
>     without  467k / 468k / 470k IOPS  (mean 468.3k)
>     with     473k / 471k / 471k IOPS  (mean 471.7k)    +0.7%
>
> With md's defaults one md thread does the stripe work for all writes
> and is busy most of the time (about 80% in top), so a cheaper
> xor_syndrome() shows up in IOPS. With 8 workers per node the limit is
> lock contention in md instead (on my machine most of the time goes to
> spinning on device_lock), so the saving hardly shows.
>
> Miroslav
