Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A97722370A
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 06:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784442599; cv=none; b=o9/RAhtW81HtYoKvVC/EzgqHzdFrZz26H3Ml9/qz/VbKVyb84pXMXLxXX2caEfHlhLBnYmXE9YUZkkFukDhqV6YOAga+UECQHHa9BwhETKtzkRh2kUMJvDolPkKJx7I2lFaO18V3Xaku9+HA0NcLbzxabnRpc+2ubq/kTn5P5II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784442599; c=relaxed/simple;
	bh=tElvLjH8Lpq8ioT/UTwsQdCCIZv/nMbwqr8KQZ165KY=;
	h=Mime-Version:Subject:Date:Message-Id:To:In-Reply-To:References:Cc:
	 From:Content-Type; b=PwJf3Z5pLc8yL/HHO913L6+jXvuigBqj7GtdgRgLsM0z3+wIxp0DhufyWg9VnFq/Ecc7qt/U5ROkFoU06f7rCWcGwcNkmDgiDMtbLNV/hHU/XAB/pH341/VzYGjX9z9yb8p1agDNUnfalobUzIslB7/dX+aq6gZKfVLy6Q2+jiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=HVyuo3Xa; arc=none smtp.client-ip=209.127.231.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="HVyuo3Xa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784442586;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1jYdcWH5zuPZpWXqFFBCG42D3l/XgPxImBFHmUgDb0c=;
 b=HVyuo3Xa6sitXPUBpdxUn6zPEEvUMvsGoCvK/QZ4Aqc72sP7lhvKqvZNDauNP0dAnztUux
 FS7tfEi4Utu5Y7BjE16/uzpsIggRFZC/t1GBrFhbnk6828ZkZnUh7T3v4HlH2wbh+hDs+1
 v5GwOSAwSRO9NyNck4yoOUDgTCelcT6TBn5Edp//g3GJTRAExirCLsvgmfLuPgEALa+BL7
 TH0wg2efyDp0DIVSVlD4rct36WFTcu6MJOWrIFH7QhyqBh1WFoQ/bPIA7Qglc73tdUOuJR
 ikBhkqJYBvp75vOtY0+GiVNX2lXRAHOgrLkY8p2tVO5nHgs9k4TBrXv8huvGXA==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Reply-To: yukuai@fygo.io
Subject: Re: [PATCHv2] md: clear MD_CLOSING when array_state_store() bails on interrupted lock
Date: Sun, 19 Jul 2026 14:29:41 +0800
Message-Id: <eded31de-2e92-4a3b-9384-03dbebc5e9e7@fygo.io>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
To: "Jack Wang" <jinpu.wang@ionos.com>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>
In-Reply-To: <20260717051233.383373-1-jinpu.wang@ionos.com>
X-Lms-Return-Path: <lba+26a5c6eda+3aa1f7+vger.kernel.org+yukuai@fygo.io>
References: <20260717051233.383373-1-jinpu.wang@ionos.com>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Jack Wang" <jinpu.wang@cloud.ionos.com>
From: "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Sun, 19 Jul 2026 06:29:45 +0000
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/7/17 13:12, Jack Wang =E5=86=99=E9=81=93:
> From: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> Writing "clear", "readonly", "inactive" or "read_auto" to array_state
> calls mddev_set_closing_and_sync_blockdev(), which sets MD_CLOSING so the
> array cannot be reopened while it is being torn down. The flag is only
> cleared again at the tail of array_state_store() (for readonly, read_auto=
,
> inactive, or the failed-clear case).
>
> Between setting the flag and reaching that tail there is an early return:
>
> 	err =3D mddev_lock(mddev);
> 	if (err)
> 		return err;
>
> mddev_lock() is mutex_lock_interruptible() on reconfig_mutex. If the
> writing task is signalled while blocked there - easy to hit when the mute=
x
> is held for a long time by a running resync/recovery or reshape - it
> returns -EINTR and array_state_store() returns with MD_CLOSING still set.
> do_md_stop()/md_set_readonly() never ran, so the array keeps working
> internally, but every subsequent md_open() now returns -ENODEV for all
> callers: the device still shows up in /proc/mdstat and sysfs is fully
> populated, yet it cannot be opened and cannot be recovered without a
> reboot (the remaining clear paths either need the device open or re-enter
> test_and_set_bit(MD_CLOSING) and bail with -EBUSY before the clear).
>
> Route the interrupted-lock exit through a common label so the flag is
> released. Guard the clear with a set_closing flag that records whether
> this write actually set MD_CLOSING: when mddev->pers is already NULL (for
> example a concurrent STOP_ARRAY is mid-teardown) this write skips the
> mddev_set_closing_and_sync_blockdev() call above, so it must not clear a
> MD_CLOSING that the other thread owns - doing so could let the array be
> reopened while it is being destroyed. This also tightens the pre-existing
> tail clear, which had the same unconditional behaviour.
>
> mddev_unlock() is correctly skipped on the goto path since the lock was
> never acquired.
>
> Fixes: 99b902ac1725 ("md: sync blockdev before stopping raid or setting r=
eadonly")
> Assisted-by: Claude:claude-opus-4-8 [Claude Code]
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>   drivers/md/md.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c8..7b7a4d925907 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4649,6 +4649,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>   {
>   	int err =3D 0;
>   	enum array_state st =3D match_word(buf, array_states);
> +	bool set_closing =3D false;
>  =20
>   	/* No lock dependent actions */
>   	switch (st) {
> @@ -4668,6 +4669,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>   		err =3D mddev_set_closing_and_sync_blockdev(mddev, 0);
>   		if (err)
>   			return err;
> +		set_closing =3D true;
>   		break;
>   	default:
>   		break;
> @@ -4696,7 +4698,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>   	}
>   	err =3D mddev_lock(mddev);
>   	if (err)
> -		return err;
> +		goto out_clear_closing;

Can you just clear MD_CLOSING here and still return err directly? I think t=
his is much
simpler.

>  =20
>   	switch (st) {
>   	case inactive:
> @@ -4769,8 +4771,17 @@ array_state_store(struct mddev *mddev, const char =
*buf, size_t len)
>   	}
>   	mddev_unlock(mddev);
>  =20
> -	if (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inactive ||
> -	    (err && st =3D=3D clear))
> +out_clear_closing:
> +	/*
> +	 * Only clear MD_CLOSING if this write actually set it. Otherwise a
> +	 * concurrent teardown (e.g. STOP_ARRAY) may own the flag - this write
> +	 * would have skipped setting it above when mddev->pers was already
> +	 * NULL - and clearing it here would let the array be reopened while it
> +	 * is being destroyed.

I don't think the comment is correct. Only one caller can set MD_CLOSING, c=
oncurrent
teardown can't own the flag since this context already own the flag.

> +	 */
> +	if (set_closing &&
> +	    (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inactive ||
> +	     (err && st =3D=3D clear)))
>   		clear_bit(MD_CLOSING, &mddev->flags);
>  =20
>   	return err ?: len;

--=20
Thanks,
Kuai
