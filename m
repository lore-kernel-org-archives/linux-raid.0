Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929496;
	b=iI4gtPu0Cy4PUoICuuCiNSernrM4oCKVca9vRPAvCQ0Z1sOUF9WpKAW8xXyJURULF6mj
	 AiyGkHq6Qd4wPmfrkOH2X73XoDurpMISwVxguMlHgCgAhgSkysHxsTr4Bo0HBBjL5T0kY
	 46ewKKMJRcJAiy1PXVRJxOswRuruclzjhoYt7tWYqsZgSGpkyLflckcSj6qkT0qNj6T1j
	 z6cbYDhyNke5nGjevFTxXthiQ98ykPHx15cuCSzv9EouqRWRDB04Wyr46KF6DapprxBa0
	 pJ0pnVDfTaruIc3C85n2LgCFw8eFkS7/us1eN4lhTtcCO5z+D28v1Kpe61JqCLy7qeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929496;
	h=DMARC-Filter:DKIM-Signature:Date:Received:X-Original-From:Reply-To:
	 From:User-Agent:References:Cc:Mime-Version:In-Reply-To:To:Subject:
	 Message-Id:Content-Transfer-Encoding:X-Lms-Return-Path:Content-Type;
	bh=o4pPrmBDJiBQchY+eYj3rF3LESB28usD21pFWJiMzzk=;
	b=oUgfCf9kwVpQUiUTy3n/blT1BJBI3d4v/n6croK0DzzfFCodKsar+6Zjc7t3nzI+PFm/
	 f3+Xf7E42uxRBsVqu/H1yGs8frnipmGax+a24j2gw4t/FyU0+QdCBy/3dqgLwFJUy8rn1
	 CxCHt35Fz1iA/R/+floPX+6vmAtHyykoE9T4EfNZsMz46IYv/eD7XO9n+J6fVKnu8cz7E
	 6CqJZ2/sJHDtItunN2beH1Mxvg2kUXRpNiWBnvOvsN3zqM6fkIrmphqs1v56RkvxPQDzs
	 OCgL+tesWJlWyAeKUwVnO+5cvVG5D4SawCwt2QWIA2Bw+CDe3oJVoHV4JCJttZSxWiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=XhWWQRow;
	arc=none smtp.remote-ip=209.127.231.50
Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B8B606A336
	for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2026 01:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08B8B606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=XhWWQRow
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793929491;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=o4pPrmBDJiBQchY+eYj3rF3LESB28usD21pFWJiMzzk=;
 b=XhWWQRowQR2WeJBxcR2Jm1NhRUEgtTDOColGJYyDA4ftvaOfhoby2vEE7rTJtwjtneS7Ox
 e56iMfIS4vIrRGg9/XXDWxya/zqdkHGf+jd5enFlAI671sGA6U/Yi2Zc0QJTAC8Oyv6dvp
 1BCBuFZ2PZLPIJhrVhFSM5BtIx0vWku/vsvT6NbJ30Iz3bu1VA2EAGkAG5QnDtma3+y3dN
 lShUg5On2Pz0se88/4ia3ktRjbxGQvVTT4ptOtjeKG6zdp+oBAGqcz3KxEA/A+Fw0pVZkA
 IdbMOdJrywSMssl30jpves9/Azahqw9qQRS3yAMaSejw6zT0fYWFJDFMG1Wmug==
Date: Fri, 6 Nov 2026 09:44:45 +0800
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Fri, 06 Nov 2026 01:44:49 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
References: <20261028152755.383821-1-gowtham398gs@gmail.com> <20261030044008.34293-1-gowtham398gs@gmail.com>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+fc26c366038b54261e53@syzkaller.appspotmail.com>, 
	<syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
In-Reply-To: <20261030044008.34293-1-gowtham398gs@gmail.com>
To: "Gowtham S Bhushan" <gowtham398gs@gmail.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2] md/raid1: reject out-of-range raid_disks in setup_conf()
Message-Id: <1a298f8e-84ce-4862-866a-b68766e590fb@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26aed3112+c0420e+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/10/30 12:40, Gowtham S Bhushan =E5=86=99=E9=81=93:
> mddev->raid_disks can be set from user space with SET_ARRAY_INFO and
> is not bounded before RUN_ARRAY reaches raid1_run(). With a very large
> value, setup_conf() asks the allocator for more than KMALLOC_MAX_SIZE
> when allocating conf->mirrors, and the allocator warns:
>
>    WARNING: mm/slub.c:5459 at ___kmalloc_large_node
>     setup_conf+0x15d/0x700
>     raid1_run+0x109/0x250
>     md_run+0x6c3/0xec0
>     do_md_run+0x27/0x3b0
>     md_ioctl+0x163f/0x1ca0
>
> The array fails to start, but machines running with panic_on_warn
> crash and syzbot keeps reporting it.
>
> Fail early instead. Version 1.x metadata can describe at most 1920
> devices, so use that as the upper bound, and test the sign before the
> value is used. At that limit the allocations that scale with
> raid_disks (conf->mirrors, the r1bio mempool element and the resync
> buffers) stay well below KMALLOC_MAX_SIZE.
>
> Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D75f49ec552cc74d9d69b
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>
> Signed-off-by: Gowtham S Bhushan <gowtham398gs@gmail.com>
> ---
>   drivers/md/raid1.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f0646fb24371..1cfe983167de 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -48,6 +48,13 @@ static void allow_barrier(struct r1conf *conf, sector_=
t sector_nr);
>   static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
>   static void raid1_free(struct mddev *mddev, void *priv);
>  =20
> +/*
> + * Version 1.x md metadata keeps a 256-byte header and then 2 bytes per
> + * device in a 4096-byte block, so no array described by it can have mor=
e
> + * devices than this. Arrays created through the ioctl alone have no
> + * on-disk limit, so apply the same cap to them.
> + */
> +#define RAID1_MAX_DISKS	((4096 - 256) / 2)
>   #define RAID_1_10_NAME "raid1"
>   #include "raid1-10.c"
>  =20
> @@ -3051,6 +3058,11 @@ static struct r1conf *setup_conf(struct mddev *mdd=
ev)
>   	size_t r1bio_size;
>   	int err =3D -ENOMEM;
>  =20
> +	/* raid_disks comes from user space and sizes the allocations below */
> +
> +	if (mddev->raid_disks <=3D 0 || mddev->raid_disks > RAID1_MAX_DISKS)
> +		return ERR_PTR(-EINVAL);

There is still the same kmalloc in raid1_reshape().

> +
>   	conf =3D kzalloc_obj(struct r1conf);
>   	if (!conf)
>   		goto abort;

--=20
Thanks,
Kuai
