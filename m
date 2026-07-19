Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EC22DA75A
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 10:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784455445; cv=none; b=GS87PTMWTmLo196bR6JPJuMVUNW0ydh32E4omeBw1H6CXskbpB/nB42vjywZeKgNuPd0VXeAlPm04ctc9UOMeTn5CXwvwtUQOUWIsKTwbStMcK1ujg4vXaJq1CfmU53rOQ+6IhudPtWqcH0qle/P/Kp5e0VeSyh2hTuabqRp7VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784455445; c=relaxed/simple;
	bh=1KjDJrHhJRxPKgx/KTcjLUL4eVnoi1/+zQG6G+u/pjY=;
	h=In-Reply-To:To:Cc:Mime-Version:Content-Type:References:Subject:
	 Date:Message-Id:From; b=pvk9wH+Q7g7WbPlsjX2can3sKmI/1sEwEoR/KMBIspXeMdq55h5bZjGsKrD5GycOTlOdfl6YzRdsTHcW09KJNrP7Bb04trWewfVhtqHtmtOzbyfJn9Ep90pFztdleq0rP6bItLtuwVghjnGxCJTnFZr420cbP9AquEVQ245SiZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=okCBDWOI; arc=none smtp.client-ip=209.127.231.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="okCBDWOI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784455437;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=FpT7fms/N/j926/pDOckyTkXL7kyUbk/2ismqnpXOQ4=;
 b=okCBDWOIkduCau2Uat1W/UpmMwXhjpmfb9NyuJG2OI0Xk52YU8ysQJA4IwgIHRa3ECmEN/
 h0AkptiTdwKbTYYJie/u4/2O0zdOuFbBjNZqj5dO0EfHtfQgvObrt1k9iCZX9sjHkM1+nP
 GhoyJ/2ugksj+G+Kgl5KHYljmaxpukufmHmyWx0ScKsR2D4gUQC03A1K6KIeBwERHZl7Y0
 jDSl2GjEw8kZ0awDPGXpyjhocUlqbU0TxVm9mZdgNAgYLWH8Cg/tgSa45TeDcMBcG60bsm
 3MZ7iIOJpvFrQbRRQHNy1yKvlV9MeC6oQlYVJwCWTmTy8zLOu0XcvTJ4ovmC0A==
In-Reply-To: <20260718084218.417895-1-chencheng@fnnas.com>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Cc: <chencheng@fygo.io>, <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a5ca10c+0facaa+vger.kernel.org+yukuai@fygo.io>
References: <20260718084218.417895-1-chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md: scope memalloc_noio to allocation critical sections
Date: Sun, 19 Jul 2026 18:03:52 +0800
Message-Id: <4a684c2f-6e24-4545-8b3d-6aaf7ace3cda@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Sun, 19 Jul 2026 10:03:56 +0000
Reply-To: yukuai@fygo.io

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
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
