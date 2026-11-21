Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795233598;
	b=FYWI45Oa9rPVTOaAcfpK8fmZOX2HQYAqJauCiDhlbL9fyrfp2a+TvfSvkAbYaJLmlw3e
	 LBuPNC5O5Gau6zlGOJJljzt0sFj3eA5FNc1FuayGF+EK53drcLlxL5y3pehZMbLHcTgIs
	 CtHJEMU5oD/laUgCcDbXiS5bl8o6ZfoxLKnuEp+pc4JjAwm1P+QQ3oS/qwIfOMqz/qf6x
	 OmwqcXecQaluJ6a5xBwG9N+AWLIqVGKqcgOX7MV45yL1GbZxRqch/QhDS/Ew8g4sBvXxz
	 3eoKKL8IOQGFa+h0wEfixyspBjQ1CE3fe47v7O+PpeT78VY1wdW7T6d5LldpGApXj0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795233598;
	h=DMARC-Filter:DKIM-Signature:Reply-To:From:Subject:User-Agent:
	 References:Content-Transfer-Encoding:To:Cc:Mime-Version:Content-Type:
	 X-Lms-Return-Path:Message-Id:X-Original-From:Received:Date:
	 In-Reply-To;
	bh=uYJ3B2L2D69v88OInfKX1L2DKQpoFs57gobURfPgMOE=;
	b=YHMU7vy1wyMGpwRDjv07Y2NJUHiuwayy1hS4bAzq5SdlLmFT3zdkUfzFrV/pSynK4I6K
	 Q8Yck32F3+tYeUQakGh59CDzO7p7CB2i1hHJRO2G2qDGffZLmgZpc68dLvIueENneEIOV
	 +vcxlaeNrZpZcGKAxLDHvNc2GUZH0MXcUa6Crcvd4m7w5h/u5OVn1jrhnhH6wqOVnXFHf
	 7YhMpHal2WRYqFMTcTKAG8+LIhxwcshehF+4mZJw9a413oOerCmTwEaRSoMIZdCI5lyal
	 7nf0wTJaGAjMFV7b2AzKI0eoFvYSHynbJqbbWPkofPoNEactwdXHZjIkOkcmGIxLfaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=PRCyG509;
	arc=none smtp.remote-ip=209.127.231.50
Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88C3606A6A6
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 03:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C88C3606A6A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=PRCyG509
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795233588;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uYJ3B2L2D69v88OInfKX1L2DKQpoFs57gobURfPgMOE=;
 b=PRCyG509YldO6fnfrde4SCr5aadRI2vnxABn9f2/Gi99sZE2ofnieLTSUKXl/jGral1w60
 KHB83oOlmC/ojmTMWSVefPSPpnG0nSI2WKF+bIkZ1Ywctm+/q7ifPWbIHS/444xnwrpwfm
 n3hl7mCzNyYU4OF2jSqeNrpR0lnVAsooe7xrz1RcgLlaV+Aw7q2uholCXkE3O/6FA5+doa
 /4zrntgmBxDVMc0q5qJvuTeyiQ6il0gqRD6RhNOGqGQADBDYsJQ+SkOnXZM56lqZHTDo+Z
 xYKu21kyn9N7BosqlOGCZm8SX/b+H0l2vwHUjUE0jUb21IuV0mV/QtMPDdjlTw==
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v4] md: don't leak MD_CLOSING when array_state write is interrupted
User-Agent: Mozilla Thunderbird
References: <20261112091533.145342-1-jinpu.wang@cloud.ionos.com>
Content-Transfer-Encoding: quoted-printable
To: "Jack Wang" <jinpu.wang@cloud.ionos.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26b011733+d45e67+vger.kernel.org+yukuai@fygo.io>
Message-Id: <6f7562f8-4d04-4818-aea0-40cf0710840f@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Sat, 21 Nov 2026 03:59:47 +0000
Date: Sat, 21 Nov 2026 11:59:43 +0800
In-Reply-To: <20261112091533.145342-1-jinpu.wang@cloud.ionos.com>

=E5=9C=A8 2026/11/12 17:15, Jack Wang =E5=86=99=E9=81=93:

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
> Signed-off-by: Jack Wang<jinpu.wang@cloud.ionos.com>
> ---
> v4: (Kuai) drop the Assisted-by tag, checkpatch does not accept it.
>      Keep the set_closing guard at the tail clear but still skip it after=
 a
>      successful clear: md_clean() keeps MD_CLOSING set (except for legacy
>      async del_gendisk with hold_active), so clearing it here would let t=
he
>      stopped array be reopened.
> v3: (Kuai) clear MD_CLOSING directly at the mddev_lock() failure and
>      return, drop the out_clear_closing label; reword the commit message.
>      Keep the set_closing guard: the set call is skipped when the array
>      is not rdwr or mddev->pers is NULL, so this write may not own the
>      flag. Rebased on v7.4-rc1.
> v2: guard the clear with set_closing.
>
>   drivers/md/md.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
Applied

--=20
Thanks,
Kuai
