Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794106426;
	b=Ik3+TCNeqwaFescPyCUY9F5DWuVzJ3qft6RL0UVW4WSm8nSx+j5oPpnrAwqib7urRkRR
	 5r6oYh8wBaG3TyERQKbMmJR8RN0C7u8PYBjYfPHGcACUTdm9O5D1Ca8EZ02475l0qQKGj
	 gnxOT5gqmWREqCPrsgXCy9tfR9Fzb8a5wHN28GEPeA6gdvc3ur7Sh3+VQ401rMIh7eKGO
	 /7ORY+MzIlTro6MtMRic11SvAI90gM5AZe5lWtPy3YCD23yANFDjW4aN3GrPonq5SyyYr
	 MYerwRFcOBCAcW9XjeH/SnYjdF3+VfxbQPrD8esxQ8PDCXyK7fnU52W3mBJxS2csOqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794106426;
	h=DMARC-Filter:DKIM-Signature:Reply-To:References:Mime-Version:
	 X-Original-From:In-Reply-To:To:Cc:From:Date:Message-Id:User-Agent:
	 Subject:Content-Transfer-Encoding:Received:X-Lms-Return-Path:
	 Content-Type;
	bh=OAPucYpgXG2xo4vS8Z+D1qUkG4tTQvNSHJYxe3X/qoI=;
	b=ozwEARrxAYSQGXud9W+N/4uiRBl46Efm8cuiH4fuXB95TChKWKFKbenBtwtNdjQX3Zv7
	 x+L/a3wKzLhCC5pqYHWgyZjFkReFxKRdX+GN0MvDw3v96e2HwtAC2WsE0qmBIwvKLOH90
	 3GNqJN189MfhTb1Qmu/M2GsoxvTGoSdzjCluL/cLOFWPaotNO38x0eUC+NPGEE+W//ELm
	 fOTN+1t0mSm/eB9OCP+1mXpf5vDU/HxlNaFaiLpBQsU1mIIdKM2ODp+im4moDiQ2IthlB
	 nYX5z7ugyB/JWR/LkDYKk1hebg8SuYvwe+vp2FF+HetKn6kilBPkLJWVGXoNJiZ9g8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=IS9aeIYu;
	arc=none smtp.remote-ip=209.127.231.16
Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677CE606A31A
	for <linux-raid@vger.kernel.org>; Sun,  8 Nov 2026 02:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 677CE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=IS9aeIYu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794106417;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=OAPucYpgXG2xo4vS8Z+D1qUkG4tTQvNSHJYxe3X/qoI=;
 b=IS9aeIYuoQSpdJ2t1T63uD6Kl4Yx3cL9yxDheMovoeg4VuDJ6ko+CvYKwATfPY3Lf0tOvl
 0F4Y7wuCDu/0mlEGgX87NNKkfWPUAzhXVqzuFPB/8JhvMtRhzmfJiAq0NcUhltMDU30nYa
 Ow7f2lTaG92HmA6zAXcg/ykwPe9YpuoXv0M/3yRhf48wMExMCfvh2Cd2URd3DEh1kl/nAx
 W5+MMWqNPoN+LBQLyIeJntVs0374GqGaHLSMeutXc14eGKeOld6tRBo58iLDrj7qSqP6pc
 SKDnwLpiYADVz3bLtibYT7Vw4/X9j+1+UNUy+wqtcMxf07ARNl6y9onUMPND2A==
Reply-To: yukuai@fygo.io
References: <20261106-md-auto-read-only-sb-warn-v1-1-5bfde3559841@incharilla.site>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20261106-md-auto-read-only-sb-warn-v1-1-5bfde3559841@incharilla.site>
To: <incharilla@incharilla.site>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Yu Kuai" <yukuai@fnnas.com>, "Corey Hickey" <bugfood-c@fatooh.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 8 Nov 2026 10:53:33 +0800
Message-Id: <2bea7aea-774f-443d-8228-e1c68f7d5bd0@fygo.io>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: dont warn about sb update on auto read only arrays
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.55]) by smtp.larksuite.com with ESMTPS; Sun, 08 Nov 2026 02:53:36 +0000
X-Lms-Return-Path: <lba+26aefe431+7ffc18+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/11/7 2:20, incharilla via B4 Relay =E5=86=99=E9=81=93:

> From: incharilla<incharilla@incharilla.site>
>
> Commit 8c9e376b9d1a ("md: warn about updating super block failure") added
> an error when md_update_sb is called on a read only array to help debug i=
o
> hangs.
>
> An array that is started auto read only prints this error for no reason.
> This happens when it is assembled with start_ro set or when a degraded
> array is created with start_ro set. md_update_sb already defers the
> update by setting MD_SB_CHANGE_DEVS and the sb is written as soon as the
> first write makes the array read write. No io can hang on an array that
> has not been written to yet.
>
> Skip the message for MD_AUTO_READ the same way dm raid is already skipped=
.
> It is still printed for arrays that are really read only.
>
> Tested in qemu on loop devices with raid1 and raid5 and raid10. Before
> this patch assembling a clean array with start_ro set prints the error
> for all three levels. Creating a degraded array with start_ro set prints
> it in 5 of 10 tries for raid1 and 8 of 10 for raid5 and 4 of 10 for
> raid10. After this patch none of these print it. On raid1 the first write
> still makes the array read write and the sb events go from 17 to 19.
> Assembling with mdadm --readonly still prints the error.
>
> The fix and the qemu test were made with help from Claude Code.
>
> Fixes: 8c9e376b9d1a ("md: warn about updating super block failure")
> Reported-by: Corey Hickey<bugfood-c@fatooh.org>
> Closes:https://bugzilla.kernel.org/show_bug.cgi?id=3D222162
> Signed-off-by: incharilla<incharilla@incharilla.site>
> ---
> Found from bugzilla 222162. The qemu test script used is a busybox
> initramfs that creates raid1 and raid5 and raid10 arrays on loop devices
> with start_ro set and counts the message in dmesg.
> ---
>   drivers/md/md.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
Applied

--=20
Thanks,
Kuai
