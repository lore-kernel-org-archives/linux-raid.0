Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E725A35B62F
	for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 05:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785475864; cv=none; b=OV7x5vsI1VOPhZFkFIvA3m9OZ92lhZnpHIzp4noSPZTOpAtBNOhu4cwJlq39HJHGnPN3beRYPOzR1dFK9RK04pXU68MIWHcVaQoV2qUf7WjKsNukt0r1uE9QtaaLiremhXrNlrIOOqkXHOaiLQ9pKK07FADuVq3R3qu8dkiBLz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785475864; c=relaxed/simple;
	bh=eOrHq11a48qmUnZFBDNaj7bN2G4ToppeMo1rz7wqyUg=;
	h=From:Subject:Mime-Version:In-Reply-To:Message-Id:Content-Type:
	 References:To:Cc:Date; b=eqXvlmEMSQHjys5gmpw3FTO5HJA2uxVkimT7BDMG7HJj4jha3XSJUlilBdhHnNlJS7KLbFYF8vtsNMtFUwOlgbfMMDOz0AMwwRuB0CQc4maOBxdrv2N6K/5WZgNDij9Pou36TmMTL2QBFdIN3SEm9NhG14kOC45/goVphm6vKYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=McEg1Db2; arc=none smtp.client-ip=209.127.231.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="McEg1Db2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785475851;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1hMBNbcnpYgwZE7jSiqctKsKm5oC6V3k6SCyd0cpa1s=;
 b=McEg1Db2dmfJnkBHAnbdj7q9xdKvtpyZlMNUF1UcHMvcScLYiCS2xpSYusvBgSFq7EdL8N
 RAAvFmLnCoOoo8iUD5goaIAZ4J+Hsta74lswAj0MvDW4fMsJoZSkHryGc/wj8cXujkeQ8F
 U0z2e0PN1ZrgYu91Bm9VW9rLmwnWClIbtXqBzZH13TpYmxAu2C6oB9/zKdTkHzsueYbjOS
 89YGldrY5XdAzxvmceDmvYaww9Vzm7Ei2J4s9Z1XL8YxP9fLEfXiZNQv6/9aZRZQI7NTJj
 GP8T7XplMj2q/8ZV5Awj4PKXxNfZeTPublPMAOYgAa2775iCX8K/RXcAzxop8g==
X-Lms-Return-Path: <lba+26a6c330a+afd38b+vger.kernel.org+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2] md: scope memalloc_noio to allocation critical sections
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260718084218.417895-1-chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
Message-Id: <6b215e37-dfde-498d-be17-4a1c571ce1cf@fygo.io>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Fri, 31 Jul 2026 05:30:50 +0000
References: <20260718084218.417895-1-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: <chencheng@fygo.io>, <linux-kernel@vger.kernel.org>
Date: Fri, 31 Jul 2026 13:30:47 +0800

=E5=9C=A8 2026/7/18 16:42, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> Save token as mddev-scoped in mddev->noio_flags cause PF_MEMALLOC_NOIO
> leak into task A, while task B restores a token that it never saved.
>
> scenario:
>
> task A                          mddev                       task B
> =3D=3D=3D=3D=3D=3D                          =3D=3D=3D=3D=3D=3D=3D        =
             =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> write suspend_lo
> mddev_suspend()
>                                  suspended =3D=3D 0
>                                  drain active_io
>                                  suspended =3D 1
> A: noio_A =3D memalloc_noio_save()
> A returns with PF_MEMALLOC_NOIO set
>
>                                                              write suspen=
d_hi
>                                                              mddev_suspen=
d()
>                                  suspended =3D=3D 1
>                                  suspended =3D 2
>                                                              B returns
>                                                              (no save)
>
> mddev_resume()
>                                  suspended =3D 1
>                                  not last resume
> A returns
> A still has PF_MEMALLOC_NOIO   <-- leaked
>
>                                                              mddev_resume=
()
>                                  suspended =3D 0
>                                                              memalloc_noi=
o_restore(noio_A)
>                                                              (restores A'=
s token in B)
>
> Fixed by:
> call flags =3D memalloc_noio_save() directly in mdraid, where:
> 	1) after array suspend succeed;
> 	2) before allocating memory
>
> Validation:
> repeatedly updates the array's suspend_lo and suspend_hi sysfs from many
> concurrent userspace workers. That makes multiple tasks to call
> mddev_suspend()/mddev_resume() concurrently.
>
> Each worker:
>    - reads its initial /proc/self/stat flags and verifies that PF_MEMALLO=
C_NOIO is not already
>      set
>    - writes 0 to either suspend_lo or suspend_hi
>    - immediately reads its own task flags again
>    - reports success if flags & PF_MEMALLOC_NOIO is true after the write =
returns
>
> Link:https://github.com/chencheng-fnnas/reproducer/blob/main/repro-md-noi=
o-token-leak.sh
> Fixes: 78f57ef9d50a ("md: use memalloc scope APIs in mddev_suspend()/mdde=
v_resume()")
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>
> rfc -> v1:
>          - dm-raid side just bypass because suspend and resume not in the
>            same task context..
>
> v1 -> v2:
>          - just call flags =3D memalloc_noio_save() directly in mdraid
>                  (suggest by Yu Kuai)
> ---
>   drivers/md/md-bitmap.c |  3 +++
>   drivers/md/md.c        | 52 ++++++++++++++++++++++++++++--------------
>   drivers/md/md.h        |  1 -
>   drivers/md/raid5.c     | 14 ++++++++----
>   4 files changed, 47 insertions(+), 23 deletions(-)
Rebase and applied to md-7.3

--=20
Thanks,
Kuai
