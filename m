Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D851A682F
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 04:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784088562; cv=none; b=Ic1Q1ROU6oL03hXYnLMchOSIloZivIngI2ozEAekxHgkR2ZB1+EbcqWEMObvp46azbpexYjs803398fSyZ17+NNCJuO1zTsaTru9i2NOZchcAIDMNxMv0XRaBzwn2BZhtIwcmv6GdHaT8lfeuIl9l3VQg14il4VzuEKswjyBAsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784088562; c=relaxed/simple;
	bh=PfxuvytKd3AQpkOKpwAXTAJDWyCfJiYv1MPQXZZgnfI=;
	h=From:Subject:Mime-Version:References:In-Reply-To:Date:Message-Id:
	 Content-Type:Cc:To; b=L70cboufZiSfBANScRC0ryk5EkiX3uHZ+a83p52pSASWRH/lhcDPomlmX7aPfrcCeaT50tCrC5/N9s7cMkPdlJlt/EkYVlTCpFYriAOf0JB4E6LwTCmHeLwvXT/rq5D0Z3QDcn5MhurOjdaHux+/IWOPDWY2CLS1kaDBiHYToZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Ed/jk/tz; arc=none smtp.client-ip=209.127.231.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Ed/jk/tz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784088548;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=lGJSdpC4Rm1+xZDy0+VyvCS8oj2pYOSIOeyS519WQJ8=;
 b=Ed/jk/tzDY6WQhbYHDCAWa6UEy9W/j8jtm2MauakP4KsFRk/C2bijGCWHZxB/al73EVCNF
 xmSYifSV2RIVYXfYFd3GN4hs/WGyephORQXP5sbs39D5AmtYQfTpBqSJiQblwc5sgKfHVO
 lHHRkprU5AT3gpAs/Gba0QMOcq7PU7oM266wIb+TlnDvgu/LPSbam5y+bRH9YH8M9sr7vf
 ACc5VUyN8q1qfHrYDuahgs2cCZ/GwC2prdbufotsAhrGkN5pUxw2hFkmnSqb2z7NuVZs1y
 MbtD9CAf5fs4dK5ArlwSI3JaSj0S6RuoyLBgWZf3dEIG64rOS0FDMZmxblVNHA==
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: fix lockless max_nr_stripes reads
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a5707e4+5dd604+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
References: <20260624024042.2561803-1-chencheng@fnnas.com>
In-Reply-To: <20260624024042.2561803-1-chencheng@fnnas.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Date: Wed, 15 Jul 2026 12:09:04 +0800
Message-Id: <47c04531-8c6d-47e1-b761-25228ddaee6f@fygo.io>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-kernel@vger.kernel.org>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Wed, 15 Jul 2026 04:09:07 +0000
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>

=E5=9C=A8 2026/6/24 10:40, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> max_nr_stripes is updated under cache_size_mutex in the stripe cache
> grow/shrink paths, while is_inactive_blocked() and
> raid5_end_read_request() read it without that lock.
>
> Use READ_ONCE() for those reads in lockless path to match the WRITE_ONCE(=
)
> updates and avoid KCSAN data race reports.
>
> A similar issue was previously fixed in commit-id:
> 	dfd2bf436709b2bccb78c2dda550dde93700efa7.
>
> Fixes: 0009fad033370 ("raid5 improve too many read errors msg by adding l=
imits")
> Fixes: 3514da58be9c4 ("md/raid5: Make is_inactive_blocked() helper")
>
> KCSAN report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> BUG: KCSAN: data-race in grow_one_stripe / is_inactive_blocked
>
> write (marked) to 0xffff8f01f0b5a268 of 4 bytes by task 12616 on cpu 9:
>   grow_one_stripe+0x2d8/0x320
>   raid5d+0xb57/0xba0
>   md_thread+0x15a/0x2d0
>   [..........]
>
> read to 0xffff8f01f0b5a268 of 4 bytes by task 12670 on cpu 11:
>   is_inactive_blocked+0x97/0xc0
>   raid5_get_active_stripe+0x2fd/0xa70
>   raid5_make_request+0x4aa/0x2940
>   [..........]
>
> value changed: 0x000003b9 -> 0x000003ba
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
