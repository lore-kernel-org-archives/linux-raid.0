Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929351;
	b=PVa/ysoYvAtqY8yGzGjt7BLU4VNJEnRQetWiCEUyM/LW6bb0cA40cfUUKJbV+u6qEYG6
	 rFOYemb2sUGKRPjLkHrpg+K+HtNZLoV/2De4a6sufqFxfdtHgB1wRQiRdhHddqNQiuSUx
	 uw7LcLP8uIQQD2MnzNjuCvAF5R1gcqWhZ7xrGNwskn5wo6qCmGp6ruFO4u4MKDMvmBx5p
	 rtvJeV6hVdHSA9O4Gqcel9w4SKireVRYpcm/pxbp9rRzAZm43IvE1xeoGdXEM07DBXXAj
	 RqiAmbWJP0hcVXxBWMOEFBxm+c4ja3bgn9ORVG8CUXDq1KBoI//KMDzTNZHNpggzlQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929351;
	h=DMARC-Filter:DKIM-Signature:Date:Content-Type:In-Reply-To:User-Agent:
	 Content-Transfer-Encoding:X-Original-From:Cc:From:Subject:
	 X-Lms-Return-Path:Reply-To:Message-Id:Mime-Version:References:
	 Received:To;
	bh=LVYOg5a0/eInBQvhoEnLTAhJV0x1AY9I/LvPOnR6dYw=;
	b=NGQLoZJVf2oTHUwIGGV1MNi+LgW4eciN5Gze3YEQZvOwvxXVZ5kDdkQR1rdB4KyssxQt
	 0Twqblce9Wkl6pEM3Qe+HQf8ywooNcvw5tEssO9qwGddzzl/XudpGEfiB4cFudyQdvVlC
	 2Jpsaw3rIdZ5DwkkNK2NGSPz3KndvfSlCRmNle+2QpMIn9v+dKpLWl7y8b3ZPfjprDycO
	 0WN+gntfprJdNn1r/8QLDfjeNhs5Ip8AODMfWcL8lfWtcnLbxkKew1r1ffp83Cx/Vg50Y
	 5rTIQFKeF7ilxkft2zTgFyl4i7ycOuvHTQlzCnGnoxkDm+udJ6fAOnxo9krIdZ9Bqbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b="kLlUZ/Lf";
	arc=none smtp.remote-ip=209.127.231.19
Received: from va-2-19.ptr.blmpb.com (va-2-19.ptr.blmpb.com [209.127.231.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C960606A31B
	for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2026 01:42:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C960606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=kLlUZ/Lf
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793929343;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=LVYOg5a0/eInBQvhoEnLTAhJV0x1AY9I/LvPOnR6dYw=;
 b=kLlUZ/Lf7BhYf3Hg1XZcRRqx6WgB8qE2oTqBUFnmjit3OdnrsjnkuRD4k0u/Y1KCc20tCJ
 JVZvOXfwYzTgikNRSgxrDUJ1spLke9ae14/uOOxvnjMgs6EslmrnjKlAMeS3MjDS1YTq8P
 JYLm/ZlSPTfyq+X2HFWt3MXX07+iO7z8TpEegzcSmmE8m1oFHVFFU7JeawosJeKR4Oh8aM
 eRPcImOX+auA5uMkN/LeCmSnmiON9m3JLc8Gb5vNj8m2hfEKnzC4Vndjzibyow4mWjmlgC
 qp+sCz7ZbLAByCPfOtY2R0eya6bucJnvY6s1zcTLw15zdktIWhkcXbEnCF6ADA==
Date: Fri, 6 Nov 2026 09:42:18 +0800
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20261102073555.53941-1-jinpu.wang@ionos.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Jack Wang" <jinpu.wang@cloud.ionos.com>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v3] md: clear MD_CLOSING when array_state_store() bails on interrupted lock
X-Lms-Return-Path: <lba+26aed307e+5cdfe5+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Message-Id: <54d9c6e7-7467-4c68-b34f-4a984f7fb318@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <eded31de-2e92-4a3b-9384-03dbebc5e9e7@fygo.io> <20261102073555.53941-1-jinpu.wang@ionos.com>
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Fri, 06 Nov 2026 01:42:22 +0000
To: "Jack Wang" <jinpu.wang@ionos.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/11/2 15:35, Jack Wang =E5=86=99=E9=81=93:
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
> Clear the flag directly in the interrupted-lock exit. Guard the clear
> with a set_closing flag that records whether this write actually set
> MD_CLOSING: the set call is skipped when the array is not running
> read-write (or mddev->pers is NULL), and in that case this write must
> not clear a MD_CLOSING it never set. This also tightens the pre-existing
> tail clear, which had the same unconditional behaviour.
>
> Fixes: 99b902ac1725 ("md: sync blockdev before stopping raid or setting r=
eadonly")
> Assisted-by: Claude:claude-opus-4-8 [Claude Code]

checkpatch reprot error with this tag.

> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
> v3: (Kuai) clear MD_CLOSING directly at the mddev_lock() failure and
>      return, drop the out_clear_closing label; reword the commit message.
>      Keep the set_closing guard: the set call is skipped when the array
>      is not rdwr or mddev->pers is NULL, so this write may not own the
>      flag. Rebased on v7.4-rc1.
> v2: guard the clear with set_closing.
>
>   drivers/md/md.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a802..f14a31387990 100644
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
> @@ -4718,8 +4720,12 @@ array_state_store(struct mddev *mddev, const char =
*buf, size_t len)
>   		return err ?: len;
>   	}
>   	err =3D mddev_lock(mddev);
> -	if (err)
> +	if (err) {
> +		/* Interrupted before any teardown ran, don't leak MD_CLOSING */
> +		if (set_closing)
> +			clear_bit(MD_CLOSING, &mddev->flags);
>   		return err;
> +	}
>  =20
>   	switch (st) {
>   	case inactive:
> @@ -4792,8 +4798,9 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>   	}
>   	mddev_unlock(mddev);
>  =20
> -	if (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inactive ||
> -	    (err && st =3D=3D clear))
> +	if (set_closing &&
> +	    (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inactive ||
> +	     (err && st =3D=3D clear)))

Just keep the checking of set_closing should be enough.

>   		clear_bit(MD_CLOSING, &mddev->flags);
>  =20
>   	return err ?: len;

--=20
Thanks,
Kuai
