Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7135143F08E
	for <linux-raid@vger.kernel.org>; Mon, 20 Jul 2026 01:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784512512; cv=none; b=nBuskOofTVdJonEPU0FfXse36oucbz6C1BoPE2x+qGFEQVngCFWIm3tzzzpa314MBpywkh1jhixb16RFuZ3IxrqsSv2Gi1WUhH4r/MgDLTXWfXJvP8iRdGhM5y6CDpJ72TOddFnSxUCFjRX/IQOCQYWS682kXSzNeswm8ovML20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784512512; c=relaxed/simple;
	bh=wm6vsqiF4Ss9fbh4k02X7o96s1TxhVf4xk/+qHf55k4=;
	h=Cc:Subject:Message-Id:Mime-Version:In-Reply-To:To:Date:References:
	 From:Content-Type; b=QAsfPmyPq4cE2HPMqtpstyAYd5qpFqtM1gP/BfWjGzyovyjlDBlgLyLFBM1MWwgJeaZ4iB5fZaO/gJOAjWnZPJOEhojESRbeH5tS2wS8qwDnX0fmo1DQoq2wAq5TF4Q0CPz6mABpICGecFWDwejx/+daQKLzJA0tO+yf+7C5GfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=nld/pizE; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="nld/pizE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784512495;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=iDf28J912wX7QDORooDDXfhqW+8ZXpVd5MKnwrDp1L8=;
 b=nld/pizEMVEhbvYfOFFWo3I7jrACCt8xi5r2Jhhy6ShBBDpgKVZJYivOqpjbaftElIOWEq
 /exKuDEki5mAIo4GjunRXSCa1HTl3aAXQLa9Anzx2bmyNGz74i0Wwlm5u6djJzWaBbVXJn
 OHwJS4RCxb3egenEaOodG4qodLM+1GD+v+CnoFPpxkIluMSA7EUTZs1fg9O/ZVe1M6HFps
 5ohK66XyoXDZFO6zllDMivilRZarwG+W/nBeqNAMj7JohlS/xclydro2OOMPRyhlb7qxl9
 iJ0z7iZSOke+kGsgEUHT9p9DVlNEOWs8ax0/17WKt7yJ8K9k4VMcahccz0sOIw==
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] md/md-bitmap: mask sb->state on load to drop runtime-only bits
Message-Id: <60d2ad98-193c-4319-85ba-057466171bc5@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a5d7fee+e76d46+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
In-Reply-To: <20260719144409.940492-2-mykola@meshstor.io>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Mon, 20 Jul 2026 01:54:54 +0000
Content-Transfer-Encoding: quoted-printable
To: "Mykola Marzhan" <mykola@meshstor.io>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>
Date: Mon, 20 Jul 2026 09:54:50 +0800
References: <20260719144409.940492-1-mykola@meshstor.io> <20260719144409.940492-2-mykola@meshstor.io>
User-Agent: Mozilla Thunderbird
From: "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/7/19 22:44, Mykola Marzhan =E5=86=99=E9=81=93:
> md_bitmap_read_sb() does `bitmap->flags |=3D le32_to_cpu(sb->state)`
> with no mask, so any bit set in the on-disk state field becomes a
> runtime flag.  With BITMAP_WRITE_ERROR (bit 2) set on disk,
> md_bitmap_create() fails with -EIO and the array refuses to assemble
> until the bitmap superblock is rewritten externally.
>
> That bit can genuinely be on disk: kernels before v4.15 wrote
> sb->state unmasked -- commit 97f0eb9f0fec ("md/bitmap: clear
> BITMAP_WRITE_ERROR bit before writing it to sb") added the
> write-side clear -- so an array that hit a transient bitmap write
> error under an older kernel carries the bit forever.  On-disk
> corruption or an external write plants it today.
>
> The write side has masked WRITE_ERROR out since v4.15; the load side
> is the missing half.  Mask the loaded state to BITMAP_STALE, the
> only bit this loader consumes: WRITE_ERROR and DAEMON_BUSY are
> kernel-runtime signals, FIRST_USE and CLEAN are used only by the
> llbitmap loader (a superblock this loader accepts cannot carry
> them, since versions above BITMAP_MAJOR_CLUSTERED are rejected),
> and HOSTENDIAN is derived from sb->version, not sb->state.
>
> Reproducer: write 0x04 into byte offset 48 (the state field) of the
> bitmap superblock on every member (a single forged member can be
> masked by another member's clean copy), then assemble: RUN_ARRAY
> fails with -EIO.  With this fix the array starts and sb->events
> advances normally.

This is not a reproducer, BITMAP_WRITE_ERROR indicate that bitmap to all me=
mber disks
failed, and bitmap no longer works for the array, so it's not safe to assem=
ble with this
bitmap.

I think it's reasonable to assemble this array with bitmap=3Dnone.

>
> Fixes: 32a7627cf3a3 ("[PATCH] md: optimised resync using Bitmap based int=
ent logging")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude-Code:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
> ---
>   drivers/md/md-bitmap.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 0f02e2956398..4dd3fc2a9e15 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -931,8 +931,13 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   		}
>   	}
>  =20
> -	/* assign fields using values from superblock */
> -	bitmap->flags |=3D le32_to_cpu(sb->state);
> +	/*
> +	 * Only BITMAP_STALE is meaningful to this loader from sb->state:
> +	 * WRITE_ERROR and DAEMON_BUSY are kernel-runtime signals (kernels
> +	 * before v4.15 persisted WRITE_ERROR), FIRST_USE/CLEAN are
> +	 * llbitmap-only, and HOSTENDIAN is derived from sb->version below.
> +	 */
> +	bitmap->flags |=3D le32_to_cpu(sb->state) & BIT(BITMAP_STALE);
>   	if (le32_to_cpu(sb->version) =3D=3D BITMAP_MAJOR_HOSTENDIAN)
>   		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
>   	bitmap->events_cleared =3D le64_to_cpu(sb->events_cleared);

--=20
Thanks,
Kuai
