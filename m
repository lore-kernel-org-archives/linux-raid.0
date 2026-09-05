Received: from lf-2-18.ptr.blmpb.com (lf-2-18.ptr.blmpb.com [101.36.218.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7575B233947
	for <linux-raid@vger.kernel.org>; Sat,  5 Sep 2026 02:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788573668; cv=none; b=b6mliV3ksAlr5LqGFsCEzJmEMAuz60hyMvtPMcwl6NNgJSsuLSgEJHNDMxa6mt5GG47qDHEz8OwOd6OEaTWJPb0LrNd0mLuPMZK3j66XY+CfvMZYW0RtntmzXR0jb90QfdkyfzN5lV2fxgPB7uf2Iy2ANQ8uOVy0m7p0X+g5bNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788573668; c=relaxed/simple;
	bh=DIC96otagZtJuR2uB89/SIte/P56JphTotHcrN06TQc=;
	h=To:Message-Id:Cc:From:Mime-Version:References:In-Reply-To:Subject:
	 Date:Content-Type; b=iuIi6x/hJA8hLi3eb5FTS/xxd6L/d6Ll0vEw+o6XW/9m0hY4opEA8QVZ8W5fpqE2KY/FbKjHz9jnVn4VRJy03oAnfOPZ5HK3Pu36r6L1uq3LxGRz6LlHdtf0JwBT5SYPv+IBwGj9zFwRCk1tTLzOqIaVfXFKsdfkFjk0Oz00vgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=amWgXvIo; arc=none smtp.client-ip=101.36.218.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="amWgXvIo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788573578;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ejr5y86eKNB893asXhaPTaG0CMPbNRB19MDb2BfT7R0=;
 b=amWgXvIoZKI7rG907ra1HFujDtGTDIiWgAuTavVTsa6YIZTKdUqZ2s135FqwHEloXqMNI3
 fr98sGOrQpiiPJwqAZd6G0xjHbtY+3Cz1Y+47d80PtoHvSHfAGWC9HB9OjL0FNUmM5siXc
 hAYKsHWPvnKLYy7Fnk2f3oBns4sTWYJdfquRoCcyfUzX00dznBRpMaz3tksEXd5B8nXD5h
 JYAGkIuhOYimKVHkbGhG8Of7XsbAvcgcChjesbfj74IxLQF0/92xbqWOQKqEybnAplK8tA
 jHbcQ8JSnvR5vR77TGszyKpAoCoZzWFxN+KlxTezjCj4nhON74FPyQN/f0oDmQ==
Reply-To: yukuai@fygo.io
To: =?utf-8?q?J=C3=A9r=C3=A9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>, 
	<song@kernel.org>, "yu kuai" <yukuai@fygo.io>
Message-Id: <9f3f3606-6e9b-4bd4-9c9d-be4f202b1222@fygo.io>
User-Agent: Mozilla Thunderbird
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260820210703.3035608-2-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260820210703.3035608-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Original-From: yu kuai <yukuai@fygo.io>
Subject: Re: [PATCH] md: reject v0.90 arrays with too many devices
Date: Sat, 5 Sep 2026 09:59:33 +0800
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.178]) by smtp.larksuite.com with ESMTPS; Sat, 05 Sep 2026 01:59:37 +0000
X-Lms-Return-Path: <lba+26a9b7789+7d0aa1+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/8/21 5:07, J=C3=A9r=C3=A9my Jean =E5=86=99=E9=81=93:

> The v0.90 superblock has room for MD_SB_DISKS device descriptors, but
> super_90_load() only rejects nonpositive raid_disks values. A crafted
> superblock can therefore copy a larger value into mddev->raid_disks. When
> metadata is next updated, super_90_sync() walks sb->disks[] up to that
> count and reads and writes beyond the 4 KiB superblock buffer.
>
> A checksum-valid RAID1 member advertising 64 devices can be assembled by
> mdadm --incremental --run. The first write to the array then produces
> out-of-bounds writes from super_90_sync() under KASAN.
>
> Reject device counts that cannot be represented by the v0.90 format while
> loading the superblock.
>
> Assisted-by: Codex:gpt-5
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>   drivers/md/md.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

This is a long term problem, applied to md-7.3 with fix tag:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c8..873a0e5fce7d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1398,7 +1398,7 @@ static int super_90_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor
>   		goto abort;
>   	}
>  =20
> -	if (sb->raid_disks <=3D 0)
> +	if (sb->raid_disks <=3D 0 || sb->raid_disks > MD_SB_DISKS)
>   		goto abort;
>  =20
>   	if (md_csum_fold(calc_sb_csum(sb)) !=3D md_csum_fold(sb->sb_csum)) {

--=20
Thanks,
Kuai
