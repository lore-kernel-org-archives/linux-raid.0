Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2502A27A916
	for <linux-raid@vger.kernel.org>; Mon, 20 Jul 2026 02:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784512982; cv=none; b=chlwyf36aVBtImCf+mpA51Gt2YAwuDH+HvGgKDdmdzmev+qxIZdJU8NEIA9xkQlZ2WzzIf4KK9q6y/7Dg/So7s2VTl6l0cbgnLmfFFRO4mDMDrwvZw5uTucNmOncueoFMlXXAls3rTy58qq1ZaJ88tLGDP/tr3yqL0u3N3uB3as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784512982; c=relaxed/simple;
	bh=2vhdK8SV5JqfvqQVNWm4NB1R9TrHHENqvnh86PrVRaQ=;
	h=Cc:Subject:In-Reply-To:Message-Id:Content-Type:Mime-Version:
	 References:To:From:Date; b=NDQf1VvVQMNYRrWxEhteSznHKYgdVgppiafaZF3QlP3m7fxSnEZW9CXipdfLpf438FeopP4PuC/umTxenxayyx3IXFRiUEA2qo5c1f1Lria2H8HDMSnVUGYcFRNEeodD+7SDCYHzw+WHsHRx5OVpslhI+vBT/NtI9quKLB/KrOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=fBeCgYmU; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="fBeCgYmU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784512852;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Pkg7lQdXfFXPqIgzbfDB7s7eqwINU6zVilzTRpl4bnI=;
 b=fBeCgYmUO39vqDk8nuV4h/FTzDC7UbAr6BIsBzf3OQu7in1DqdTdevEkNvrn8/krJrBsdh
 q0z2F9qJ1aHoZ+zOTPzZGQloYGR+SLSw98hl6r2ODG8sOxCVb6EeFAoH0yWaBuv58EtL/+
 9TS9rnAy3Ency1WiUVRdaKwX4QXCuq1R2mXxpWzAfLZqgbfdXw4cftDs2GdQLBtNaXekxS
 gA6ZwmqiYlWQnCll8KKntgaZM9PkIfGylKlbaeM+LWV9WKuk+wqdRM6KOqv4XuAN2H3/7E
 naz7ah7r2it2Zi8jqXIRRr8TCQFQb0hs7Ba8GoJnsDcG7lWGvMUlYHMAIGLk1Q==
Content-Transfer-Encoding: quoted-printable
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] md/md-llbitmap: mask sb->state on load to drop runtime-only bits
X-Lms-Return-Path: <lba+26a5d8153+474c33+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
In-Reply-To: <20260719144409.940492-3-mykola@meshstor.io>
User-Agent: Mozilla Thunderbird
Message-Id: <235ba45b-3f68-4f08-8955-ca79959a5b1c@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Mon, 20 Jul 2026 02:00:50 +0000
References: <20260719144409.940492-1-mykola@meshstor.io> <20260719144409.940492-3-mykola@meshstor.io>
To: "Mykola Marzhan" <mykola@meshstor.io>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Date: Mon, 20 Jul 2026 10:00:46 +0800

Hi,

=E5=9C=A8 2026/7/19 22:44, Mykola Marzhan =E5=86=99=E9=81=93:
> llbitmap_read_sb() copies sb->state straight into llbitmap->flags
> with no mask, so any bit set in the on-disk state field becomes a
> runtime flag.  With BITMAP_WRITE_ERROR (bit 2) on disk,
> llbitmap_enabled() returns false for the array's entire lifetime:
> llbitmap_update_sb() early-returns, the state machine returns
> BitNone, the bits attribute reports "bitmap io error", and on-disk
> sb->events stops advancing.  The bitmap is silently disabled with no
> log line attributing the cause, and the next clean reassemble forces
> a full resync because sb->events is stale.

For llbitmap, it's using md_write_metadata(), if it's failed for one rdev,
md_error() is called directly for this rdev. So if BITMAP_WRITE_ERROR exist=
,
the array is already broken. And in this case, if array can still reassembl=
e,
a full resync is the expected behavior.

>
> Runtime bits do reach disk: llbitmap_update_sb() writes the raw
> flags word, so BITMAP_DAEMON_BUSY is persisted whenever a superblock
> update coincides with a daemon-period overrun -- the condition that
> logs "daemon_work not finished".  WRITE_ERROR itself has no
> reachable write-side path today (its only setter is update_sb's own
> read-failure branch, which returns before writing), but on-disk
> corruption or an external write plants it all the same.
>
> Mask the loaded state to the bits this loader consumes (STALE,
> FIRST_USE and CLEAN), as the previous patch did for the classic
> loader.  Masking at load neutralises whatever is on disk and is the
> minimal backportable fix; masking the write side is left as a
> follow-up cleanup.
>
> Reproducer: write 0x04 into byte offset 48 (the state field) of the
> llbitmap superblock on every member (a forge on a single member can
> be masked by another member's clean copy), then assemble.  Without this
> fix the bits attribute reports "bitmap io error" and sb->events is
> frozen; with it the bitmap is alive and sb->events advances
> normally.
>
> Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
> Cc: stable@vger.kernel.org # v6.18+
> Assisted-by: Claude-Code:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
> ---
>   drivers/md/md-llbitmap.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index e8f853e8461d..0b591124dc63 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -981,7 +981,15 @@ static int llbitmap_read_sb(struct llbitmap *llbitma=
p)
>   		else
>   			mddev->bitmap_info.space =3D mddev->bitmap_info.default_space;
>   	}
> -	llbitmap->flags =3D le32_to_cpu(sb->state);
> +	/*
> +	 * Mask the loaded state to the bits this loader consumes.
> +	 * WRITE_ERROR and DAEMON_BUSY are kernel-runtime signals; a stray
> +	 * WRITE_ERROR trusted from disk silently disables the bitmap for
> +	 * the array's entire lifetime.
> +	 */
> +	llbitmap->flags =3D le32_to_cpu(sb->state) &
> +			  (BIT(BITMAP_STALE) | BIT(BITMAP_FIRST_USE) |
> +			   BIT(BITMAP_CLEAN));
>   	if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
>   		ret =3D llbitmap_init(llbitmap);
>   		goto out_put_page;

--=20
Thanks,
Kuai
