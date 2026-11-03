Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793674845;
	b=Kq7UO/6K+l+DbV51fYd8cs2v5UwRqbakMBG5t3etOA/UM743GFS3Sml6azKfiS4v1slt
	 V3E0qH5MxhEs0Wv05MEJucUu3yfn6tBnPmgP6Xoumydd5fsuqOJFVQ5rj5d/bZrsn4Eia
	 uTYkX3L8LL4nL3uUpVOu6TlnaSGUvVnS/1Zy2CUiiTdA2/w+vgMEWdO7acBc5Y/mxncwQ
	 y6XvhynrNxRkO4bkXYuIglWQwKcmTkOycwS1ZQ/5O9m7Nfz4VYxbR/DBRIFMi+3XL5iIk
	 5SzTjj29XLcv6+xnQIqbl/nTIRUYoZIPdBg+ab8X+9aunQGPS0Nsc2YsYe0OY4f9T7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793674845;
	h=DMARC-Filter:DKIM-Signature:Content-Transfer-Encoding:Reply-To:
	 Subject:Date:Content-Type:User-Agent:Received:In-Reply-To:To:
	 Message-Id:Mime-Version:References:X-Lms-Return-Path:Cc:From:
	 X-Original-From;
	bh=vRI5i2y5I87cckdxctkq1xjIZOtIfuEUygOpiVqLqns=;
	b=R+8fVSwxfvabQrqiJ+2wk3PRJTrEj5qV+0PsgI3yUaWKCRO+FEUJduKnVDGlVjGT4RDz
	 45p/qKBzM9cbp3Zy/7uGx9xooUyr0TxuUcVV/5MRJJlWZwSR0YibLqV735ZsbWi63FlxK
	 InOu+GDMNXb+Dn6gRil33DDSC8by15TcEtfdNnmi+VwFoy8JawKdxtDD4r/Ar9gLlf3Zd
	 vx6MYtFqabm6Xf01dHxtS9aSBEGo6Zoplq79OQn0hhz2J70xqXXW4JoQCrVVmCxRZZEmA
	 CeaD2Q/geTPi/qmgRjxRfwQSX4g4AAuL0CQA46xkYDYL2cBEOv1p429B3h0kL5ENK4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b="QGym7/vd";
	arc=none smtp.remote-ip=209.127.231.47
Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616D0606A327
	for <linux-raid@vger.kernel.org>; Tue,  3 Nov 2026 03:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 616D0606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=QGym7/vd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793674838;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=vRI5i2y5I87cckdxctkq1xjIZOtIfuEUygOpiVqLqns=;
 b=QGym7/vdsBCC2gFRJPPUAIplJ8qWW0V2UYQUEjUYWovDVVvlrhQirKkSVavrSTrqzXtV+A
 4bKqp6HF7ilQQqqm38s8y+uMZv1Oh6mjB54FoUN4iSF1bwMz79BacH7SSlaiCIw6K0JeJQ
 cO9SeymikHhaLLbeZGcHINo0RfjnyMw18MKErjy5Yl8HMmKLnMSAKNpbEOGdab91WySqQX
 JZsInyN1D6rNOjK58OldBx+2v+a/FsgHwhlDeI98SGxImsBnKpsZPX2HriDyiwyzBcENdw
 iZTKBFutQFvDAcmvUGqREZwRDX4Ihs9lBfst4HBJgppJ8iA0G7qZkSL8yPN53g==
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH] md/raid5: Cancel remove instance if adding it fails
Date: Tue, 3 Nov 2026 11:00:33 +0800
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Tue, 03 Nov 2026 03:00:37 +0000
In-Reply-To: <20261030105614.378971-1-eadavis@sina.com>
To: "Edward Adam Davis" <eadavis@sina.com>, 
	<syzbot+08318698e045b4b85f51@syzkaller.appspotmail.com>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <a8734f2f-dd23-4133-ae9e-fd95b90039a2@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <6ae34c61.bc88765f.313a3f.00b3.GAE@google.com> <20261030105614.378971-1-eadavis@sina.com>
X-Lms-Return-Path: <lba+26ae94e56+113e9c+vger.kernel.org+yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>, <peterz@infradead.org>, 
	<syzkaller-bugs@googlegroups.com>, <tglx@kernel.org>, 
	<bigeasy@linutronix.de>, <song@kernel.org>, <magiclinan@didiglobal.com>, 
	<xiao@kernel.org>, <linux-raid@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/10/30 18:56, Edward Adam Davis =E5=86=99=E9=81=93:
> The failure of raid456_cpu_up_prepare() to allocate memory causes
> cpuhp_state_add_instance() to fail; consequently, the corresponding
> instance is not initialized, potentially hitting [1].
>
> Additionally, there is another null-ptr-deref issue: conf->mddev is
> assigned too late, meaning that any error-handling exit occurring before
> this assignment, which jumps to the abort label, potentially hitting [2].
>
> [1]
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> Call Trace:
>   cpuhp_state_remove_instance include/linux/cpuhotplug.h:480 [inline]
>   raid5_free_percpu drivers/md/raid5.c:7541 [inline]
>   free_conf+0x238/0x710 drivers/md/raid5.c:7554
>   setup_conf+0xd80/0x2a20 drivers/md/raid5.c:7885
>   raid5_run+0x1260/0x1670 drivers/md/raid5.c:8129
>
> [2]
> BUG: KASAN: null-ptr-deref in free_conf+0xfd/0x7e0
> Read of size 8 at addr 0000000000000028 by task rp0/9459
> Call Trace:
>   free_conf+0xfd/0x7e0
>   setup_conf.cold+0x6e/0x4a1
>   raid5_run+0x1260/0x1670
>
> Add a check before removing an instance, if the instance was not successf=
ully
> added, skip the removal process. Move the assignment of conf->mddev after=
 the
> memory allocation for conf.
>
> Fixes: 29c6d1bbd7a2 ("md/raid5: Convert to hotplug state machine")
> Reported-by: syzbot+08318698e045b4b85f51@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D08318698e045b4b85f51
> Signed-off-by: Edward Adam Davis <eadavis@sina.com>
> ---
>   drivers/md/raid5.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

Looks like this problem is already fixed

https://patch.msgid.link/20260827080341.112296-2-ghuicao@163.com
https://patch.msgid.link/20260915081731.122933-1-chengzhihao1@huawei.com

>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090d..e1f9ec8f25be 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7538,7 +7538,8 @@ static void raid5_free_percpu(struct r5conf *conf)
>   	if (!conf->percpu)
>   		return;
>  =20
> -	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
> +	if (!hlist_unhashed(&conf->node))
> +		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
>   	free_percpu(conf->percpu);
>   }
>  =20
> @@ -7675,6 +7676,7 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>   	if (conf =3D=3D NULL)
>   		goto abort;
>  =20
> +	conf->mddev =3D mddev;
>   #if PAGE_SIZE !=3D DEFAULT_STRIPE_SIZE
>   	conf->stripe_size =3D DEFAULT_STRIPE_SIZE;
>   	conf->stripe_shift =3D ilog2(DEFAULT_STRIPE_SIZE) - 9;
> @@ -7743,7 +7745,6 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>   	ret =3D bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
>   	if (ret)
>   		goto abort;
> -	conf->mddev =3D mddev;
>  =20
>   	ret =3D -ENOMEM;
>   	conf->stripe_hashtbl =3D kzalloc(PAGE_SIZE, GFP_KERNEL);

--=20
Thanks,
Kuai
