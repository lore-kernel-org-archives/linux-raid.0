Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794360717;
	b=XbXicVel+syYohuNmWsoff4/gY3pL9WZdYll7MRvscHzdLB2c13pQ0s7Y2YS93Han0cD
	 Loqi2ma2zunexdOS3Yambb9yrkS+nKZmWZ1TioTwZtb9IcZMRjEVtVhm21tudkMGdQX0e
	 IVXMnQw+WkOYQFAeO8ebbzFTcJWTw2SzAMrOG43nbaP23IAxqudUA5s13U8x09otFI5sM
	 b02kxLK/6apFSkcgDvXUpZbKrY0wcxv4gkubjdAoZhmhyUkrnr6DNznoay9xnkgaAC795
	 toH20W9uWpGIOAtMIaH3HlRj7vscDBLHbjHu23RdGmvuDCdguDF2XoNcroc4cfkqZIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794360717;
	h=DMARC-Filter:DKIM-Signature:Date:Message-Id:
	 Content-Transfer-Encoding:X-Lms-Return-Path:Cc:From:Received:
	 X-Original-From:User-Agent:To:Mime-Version:References:Content-Type:
	 Reply-To:Subject:In-Reply-To;
	bh=nosRokf2rzMXQO5aZbNLHOgklK5mj7VQkcm9fnGDXDE=;
	b=h1dVPoP2KENLebrj7cb/bHdN+HatiVbB/xMXkLY1k8sGsPnAezTC8mWo6lWeEyGrdjt7
	 HPbI5LeAIQBdpITgXRBRmd2SS9ihQ+eXGAjdSuFtAKd6RuWfluamEmuYyGufQfljg7PHC
	 Q0+gqn8mmr7tFLYhNBUewkKz4n7Itrwik6PAskBAXyxzTMY08Hvk+dsENIYTo9neSNZ/x
	 XbVrfEosrpHSnY52yxXWKhS8LlP+bC//E04YWqBU2rSnBwdY7oQ//qkOhlpwLEFDeE8QQ
	 mcjesK5zceb2mfR5WaPbLUJAmaMvdqqBLVedU/JjDRoLRCbSIOV9rZt2pcLUNBvcS3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b="nlxO2/KM";
	arc=none smtp.remote-ip=209.127.231.20
Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F8F606A320
	for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2026 01:31:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82F8F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=nlxO2/KM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794360708;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nosRokf2rzMXQO5aZbNLHOgklK5mj7VQkcm9fnGDXDE=;
 b=nlxO2/KMLrCRGNtmeJXMms8xUl4WoMD/BSn1elx6qKv/smPKCvVMPp+N1tXf2ZzpP2jS/A
 D4TMH2aWceLVOo5AjujKRWgGf5LsJ4b45lKsKZU7YEI+lTg2htkwXRCL9LEhm10aouMBBT
 fQ9gTlqITc/8+HXuMAZsviqQpr9kC9LVopJWo6jcoqYP3QfHFjB1xRQn6aFtwooC0VQMrj
 SZQ8rpoJdxnVenbjJpn7pDsdkLOOp2Goi7RYDk9fDHxgUehc+nEKXIGBiYzgboLP6na+YD
 N8qG+ceHzkBRM2WCVJsE3l50c0jELdvEowabq4/ltayazymTEcRHmRa8XkFb9w==
Date: Wed, 11 Nov 2026 09:31:43 +0800
Message-Id: <385681bd-5b0c-409f-a295-4307812d077f@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26af3c584+f67c35+vger.kernel.org+yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+0a8119ab801b078213ea@syzkaller.appspotmail.com>
From: "yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.55]) by smtp.larksuite.com with ESMTPS; Wed, 11 Nov 2026 01:31:47 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
To: "Nguyen Ngoc Thang" <ngocthang2710.1999@gmail.com>, 
	"Song Liu" <song@kernel.org>, "yu kuai" <yukuai@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261108040232.43694-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH] md: don't ignore bd_link_disk_holder() failure in bind_rdev_to_array()
In-Reply-To: <20261108040232.43694-1-ngocthang2710.1999@gmail.com>

=E5=9C=A8 2026/11/8 12:02, Nguyen Ngoc Thang =E5=86=99=E9=81=93:

> bind_rdev_to_array() adds the rdev to mddev->disks and then calls
> bd_link_disk_holder() without checking the result. If the link fails
> (e.g. an allocation failure in the holder or symlink setup), no
> bd_holder_disk is recorded for the member, but the rdev stays bound.
>
> Stopping the array later calls bd_unlink_disk_holder() for every
> member, which finds no holder and warns:
>
>    WARNING: block/holder.c:147 at bd_unlink_disk_holder+0xd8/0x2d4
>    Call trace:
>     bd_unlink_disk_holder+0xd8/0x2d4 block/holder.c:146
>     md_kick_rdev_from_array+0x8c/0x324 drivers/md/md.c:2683
>     export_array drivers/md/md.c:2714 [inline]
>     do_md_stop+0x708/0xe6c drivers/md/md.c:7252
>     md_ioctl+0x14ec/0x23e4 drivers/md/md.c:8462
>
> Link the holder before registering the rdev kobject, fail the bind
> if it cannot be created, and drop it again if kobject_add() fails.
> All callers already export the rdev when binding fails.
>
> Fixes: e09b457bdb7e ("block: simplify holder symlink handling")
> Reported-by:syzbot+0a8119ab801b078213ea@syzkaller.appspotmail.com
> Closes:https://syzkaller.appspot.com/bug?extid=3D0a8119ab801b078213ea
> Signed-off-by: Nguyen Ngoc Thang<ngocthang2710.1999@gmail.com>
> ---
> Tested in QEMU (x86_64, KASAN + lockdep + failslab) with a reproducer
> that sweeps fail-nth over ADD_NEW_DISK on a RAID1 /dev/md0 backed by
> /dev/ram0 and stops the array after each attempt:
>
>    before: ADD_NEW_DISK returns 0 after the holder link fails, and the
>            next STOP_ARRAY hits WARNING at block/holder.c:147
>    after:  ADD_NEW_DISK fails with -ENOMEM instead, no warning, and
>            no KASAN or lockdep reports
>
>   drivers/md/md.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
Applied

--=20
Thanks,
Kuai
