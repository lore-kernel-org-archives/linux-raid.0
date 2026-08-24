Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D60B405C35
	for <linux-raid@vger.kernel.org>; Mon, 24 Aug 2026 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787586114; cv=none; b=hcUwfoudBu278BPUT8SOe1AdnIArHMbyKEMjDsjlIKROg+GjGgEESCQHADKj02dUbs+KkPhfAGhp34UZWJJNs9YOzg5I/wXVk/rPZhHDnyY8JeLyK2rOh1NX90Wwj5Rgk9FJ8EjMAwzGCD+KWAeF/E6pKVka+SKWYg/eGRKP3JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787586114; c=relaxed/simple;
	bh=j0TXrlr0yHdK7aAJgUmjiZ9ea37Y9P0GaNcMq6048ps=;
	h=Subject:From:Mime-Version:References:In-Reply-To:Content-Type:
	 Date:Message-Id:To; b=ZbJ2smKxppoRdHBzLGK7GAonovaYv3Av5bnGm9RtT0KXGmUsJkJjV4dLNL9ZbPIZRxHdZg8DVgSjMi+tZuWhG4bv0Nz7sIONtwxG1gEMtE0hMzwTMYIjbj3O6WKtvvR3Tw+FK0gSV16D0slsOPVfu9ky3hk7WmSKBBNCmI7DynA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Nx7Ioros; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Nx7Ioros"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787586090;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=j0TXrlr0yHdK7aAJgUmjiZ9ea37Y9P0GaNcMq6048ps=;
 b=Nx7Ioros1YLjaxOI/gWzuTI5sZO8Xu0nm4E1avD1X06yLjLwKX0CVJCcZR5quNhL626osS
 yJVKclwf428yi46IxM9bJiz1iDtpYCbK9MF/vg7Gk7EOvYkVq0wf3u5nYLtz7uriMqTYGp
 Q3Ip3RT8XqqpBfcDLMVpqs/BGwOkG5L8qv3436THI0JEpkzgdAWM4tCb8yuWhkkrug83A2
 vnCGBIgy3FRd83q/P2tQamHuKMqgbPSJPuemCDVNFe4JjfN3pwRNZ71Ne5z1p3Pt8Y5L7E
 Db3j5cIwkI+j5MoSqdGlEfR9jZawOMv6fRRJykD3qvj8f7o1IY7EPZjEzUrn3Q==
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.larksuite.com with ESMTPS; Mon, 24 Aug 2026 15:41:28 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/md-bitmap: bitmap pages leaked after recovery
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <e86f6b88-ea4f-425a-880d-a3622f3f458a@redhat.com>
X-Lms-Return-Path: <lba+26a8c6629+ea2057+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e86f6b88-ea4f-425a-880d-a3622f3f458a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Date: Mon, 24 Aug 2026 23:41:25 +0800
Message-Id: <b6242e9a-7d41-4989-9481-f922a22375b8@fygo.io>
To: "Nigel Croxon" <ncroxon@redhat.com>, <song@kernel.org>, 
	<yukuai@kernel.org>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/8/8 2:55, Nigel Croxon =E5=86=99=E9=81=93:
> The bitmap pages leaked after recovery if successful writes occur
> concurrently during array degradation/recovery.
>
> We performed write I/Os to an MD RAID1 array while it was in a degraded
> state or actively undergoing recovery. Even after the array recovery
> successfully reached 100%, the disk status returned to normal ([UU]),
> and all I/Os completely stopped, the number of bitmap pages
> (bitmap: n/N pages in /proc/mdstat) never dropped back to 0, resulting
> in a persistent memory leak of bitmap pages.
>
> Bitmap pages remain permanently allocated in the kernel memory even after
> the array has fully returned to a healthy state, leading to a kernel
> memory leak.
>
> When a disk is re-added and recovery starts, MD_RECOVERY_RUNNING is set
> in mddev->recovery.=C2=A0 The else if condition evaluates to false for no=
rmal
> concurrent writes during recovery. NEEDED_MASK is never applied to these
> blocks.
>
> Fixes: 4f0e7d0e03b7
> md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
> This is becauses removing success caused bitmap_endwrite()
> to treat mddev->degraded as a blanket trigger for NEEDED_MASK.
>
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
> =C2=A0drivers/md/md-bitmap.c | 9 ++++++++-
> =C2=A01 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 1d4a050dab3a..b8be0d079780 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1756,7 +1756,14 @@ static void bitmap_end_write(struct mddev=20
> *mddev, sector_t offset,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sysfs_notif=
y_dirent_safe(
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0bitmap->sysfs_can_clear);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (!NEEDED(*bmc)) {
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Do not set NEEDED_MASK if recovery i=
s actively running.
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Writes completing during recovery/re=
sync are already=20
> covered by
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* the recovery thread and setting NEED=
ED_MASK will cause=20
> orphaned
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* bitmap flags and memory leaks after =
recovery finishes.
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (!test_bit(MD_RECOVERY_RUNNING,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &bitmap->mddev->=
recovery) && !NEEDED(*bmc)) {

This looks incorrect, MD_RECOVERY_RUNNING doesn't represent recovery is run=
ning.

And I'll prefer to add the success parameter back, and check it before sett=
ing
NEEDED_MASK, since this case is missing in the original patch.

BTW, no patch can be applied until the next merge window, I'm waiting for J=
ens
to create the block-7.3 branch.

> =C2=A0 =C2=A0 =C2=A0*bmc |=3D NEEDED_MASK;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
--=20
Thanks,
Kuai
