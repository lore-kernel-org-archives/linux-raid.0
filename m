Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792821950;
	b=LGgVqDEP5CxwPMWwJUhaAtF2tNF2XTehIcv0jgKea1RNdZVMPQTS9a0Bl7hkxUkPts3D
	 3aFQLF8x2SJTk/SwEdvUlpRWbwBCARXmycTAwS9+goqqfQkeLjwbvGf9wDKLbPFme7bCD
	 /1nSC5UH8jC660aZoq+fMANT0O5Pa6mB4dPQ7RHbbkUt/JCVoP/B2FKDAnUxzYoLRD/Yb
	 HTcpSNvwLw3yzp1IrWd0OvgzQ4JHgpIf2d4kkeprLbVO2R1Gq1F5mP9Imj/jgTeI90R4P
	 xRnHhSeKTtYmZ6fvVTGenooW0IxuRVqSdaGPwHWcj/PiVu55ytDtpWzE28giJuZu7Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792821950;
	h=DMARC-Filter:DKIM-Signature:In-Reply-To:Received:From:Date:
	 Message-Id:Mime-Version:X-Lms-Return-Path:References:User-Agent:
	 Content-Type:X-Original-From:Reply-To:To:Cc:Subject:
	 Content-Transfer-Encoding;
	bh=ZG+iexJUa6s5gxuQi2MmuGOOwAlj/REWt6XK+ey3uk4=;
	b=sRFlQOs/JG4uMVRduNUP4P1Q2TCCh8MoDzjkhIEBzFRQhGiRYLAFaCywA/LctLxhz2qY
	 DexTbstw3EDMnhFBrdDAvgLVD4q1loo6VaqSRlHdThHovvUeSnrLTemIW9w/hudLMO2Tx
	 87N3EMhVkLQzPeD/bcFU8xlYHFuxv7/ZKpbHl2NGawzHNuJLxY3T0zWg0tKOxHg4p4Gfc
	 3cRNUeCkMYJujLHxVt5LlbnttyAzcg1zDiOOldcxvQqUIlUuUrl6gQGu5vRnNLkDekzVb
	 DaACy0gJHFkI9Df6SHpDR12qPneeyYOe3QGPAKN52plW3x8wSEZBxFt+q/Znun0IQtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=onWJb4Nd;
	arc=none smtp.remote-ip=209.127.231.56
Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9F1606A31B
	for <linux-raid@vger.kernel.org>; Sat, 24 Oct 2026 06:05:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E9F1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=onWJb4Nd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1792821945;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZG+iexJUa6s5gxuQi2MmuGOOwAlj/REWt6XK+ey3uk4=;
 b=onWJb4NdPENRkWvXPICHiK522ktj5WPoxOiiiXKUAkXuhoGiEA70N2ukMJzEMS5/KWoHWM
 0YICv1uIoRr5OJTKlrrFybjtxBbYhQYTkjNs85QcUWcXFYRkBuwctCukObkSUbeoyBv5kS
 0N+JIyyv6qE34aLdD7vbyCDRRTstUHbw29XpG8sK67GUF5YHRcWrifxyblsNuJUmTXKO9F
 qY0HnkZmNhv8K2eJBXHUSHCn+wJjRzswOSmEx/0Pt3tYrlmK3BhUafePOB7lf65fHulqE4
 xatXwuwRv5FlXHyD2Ld5+6WP/N/YvmQs095CzXcBGTbDQSHRghuIl/jLjLKLyw==
In-Reply-To: <20261014115334.619923-1-jinpu.wang@ionos.com>
Received: from [192.168.1.104] ([39.182.0.21]) by smtp.larksuite.com with ESMTPS; Sat, 24 Oct 2026 06:05:44 +0000
From: "yu kuai" <yukuai@fygo.io>
Date: Sat, 24 Oct 2026 14:05:40 +0800
Message-Id: <ee303663-1b09-4e88-a129-d91e046b296b@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26adc4ab9+0f5650+vger.kernel.org+yukuai@fygo.io>
References: <20261014115334.619923-1-jinpu.wang@ionos.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Jack Wang" <jinpu.wang@ionos.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Jack Wang" <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH v2] md: clear MD_CLOSING when array_state_store() bails on interrupted lock
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/10/14 19:53, Jack Wang =E5=86=99=E9=81=93:
> From: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> Writing "clear", "readonly", "inactive" or "read_auto" to array_state
> calls mddev_set_closing_and_sync_blockdev(), which sets MD_CLOSING to
> keep the array from being reopened while it is torn down. The flag is
> only cleared again at the tail of array_state_store() (for readonly /
> read_auto / inactive, or the failed-clear case).
>
> Between setting the flag and reaching that tail there is an early return:
>
> 	err =3D mddev_lock(mddev);
> 	if (err)
> 		return err;
>
> mddev_lock() is mutex_lock_interruptible() on reconfig_mutex. If the
> writing task catches a signal while blocked there, it returns -EINTR and
> MD_CLOSING is left set on a still-running array. do_md_stop() /
> md_set_readonly() never ran, so the array keeps working internally, but
> every subsequent md_open() now returns -ENODEV for all callers - the
> device shows up in /proc/mdstat and sysfs is fully populated, yet cannot
> be opened, and cannot be recovered without a reboot (all clear paths
> either need the device open or re-enter test_and_set_bit(MD_CLOSING) and
> bail with -EBUSY before the clear).
>
> The window is easy to hit on a busy host: reconfig_mutex is held for long
> stretches by a running resync/recovery, widening the interruptible wait,
> and a userspace helper writing to array_state and then being killed or
> timed out is enough to leak the flag.
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
> v2: resend, rebased on md-7.4-20261013 (md/md-7.4), no code changes.
>   drivers/md/md.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)

Looks like this is just a resend, while I already replied to previous v2=20
patch:

Re: [PATCHv2] md: clear MD_CLOSING when array_state_store() bails on=20
interrupted lock - yu kuai <https://lore.kernel.org/all/eded31de-2e92-4a3b-=
9384-03dbebc5e9e7@fygo.io/>


>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a802..f6dfd5d76199 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4671,6 +4671,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>   {
>   	int err =3D 0;
>   	enum array_state st =3D match_word(buf, array_states);
> +	bool set_closing =3D false;
>  =20
>   	/* No lock dependent actions */
>   	switch (st) {
> @@ -4691,6 +4692,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>   		err =3D mddev_set_closing_and_sync_blockdev(mddev, 0);
>   		if (err)
>   			return err;
> +		set_closing =3D true;
>   		break;
>   	default:
>   		break;
> @@ -4719,7 +4721,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>   	}
>   	err =3D mddev_lock(mddev);
>   	if (err)
> -		return err;
> +		goto out_clear_closing;
>  =20
>   	switch (st) {
>   	case inactive:
> @@ -4792,8 +4794,17 @@ array_state_store(struct mddev *mddev, const char =
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
