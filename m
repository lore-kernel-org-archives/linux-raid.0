Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794105310;
	b=sSxI/jk7v7FP5bdwcyByQcpY8U4SPxG6xGMCofd6e92qwrUdZZfi8fJ03xi4kzC2IL+7
	 bNZNdqonCK9AA4d52uFUpgrOPpqDXRwGDPoUrM99Hg4IXC3lAwY217DaXYbwB4tmn1T81
	 c/hacVw/72eJ7MX7ZdLV0LJDPAe0/++I69Vpb+Xr2ibW1yFQBx2AiUQn9hwnH1dTeZ0qt
	 AKcAv7PYHys8jZJRlvJUGCZgFjLj2RRXWLWG0GwZL5QgBTT6Dg8EKiOHuZN5MsEuFk2pl
	 bb+08g3G21gt4v/6fjLJbjlKvSTY8Ooc42g2LU2TRpvJfkk3FKiW80/m99YIrLkS9jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794105310;
	h=DMARC-Filter:DKIM-Signature:References:Reply-To:Cc:User-Agent:
	 Received:Content-Type:From:Subject:Mime-Version:In-Reply-To:Date:
	 Message-Id:Content-Transfer-Encoding:X-Lms-Return-Path:To:
	 X-Original-From;
	bh=dIGQ7eFrFlqilOLIYga1HIT7xjtRLeM8O7PmQE2HBkE=;
	b=d5zbUyUsil2u9yONNHTxwLtJIudCmFDWKu08G9z68KDiIZm1IQAxpLi8WeVq2YIZcT6w
	 IdHTbrsDz5l5MeedwjViAmd+Gj4PGArnrY2ae15JcPIzKeu0hPTqkfVlht5TKekw9s0Wu
	 I044wxc6Zdid4RzRgvABfSK0UQxAMF7CFRQvG+K5RbfwTFsxv06vy0RHBDsMrVHukoAJz
	 WMLHtUI5pDJgILRV1yY9rA5GYL5qAh1mRnhunqe7vTRo0tCvbMvbIgiEWw4U7sSEaXkH7
	 cw90a2+kz/BP/4dqehYduHS1yyEV687H/SEh+WHh1FhnUM9ZDI55XGJsXjnf3yl8uYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=D1oNLB7h;
	arc=none smtp.remote-ip=209.127.231.42
Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF2E606A31C
	for <linux-raid@vger.kernel.org>; Sun,  8 Nov 2026 02:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECF2E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=D1oNLB7h
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794105301;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=dIGQ7eFrFlqilOLIYga1HIT7xjtRLeM8O7PmQE2HBkE=;
 b=D1oNLB7hcmv9zuQ5nejNyeJb49LJFqdSDnfqv/EGezidyfuw3hn3VeDuWXnpnaLgW52GWb
 WpKqi17vIsA7+Qrr9/hc1fmfwBGaPkb332zCmBIYoomoY+cv9nb7NkpQpARmN3EJpoPmNq
 VuJnQig+vYO9At8FMitB2t/jZeWOg50JWH4///XuX6quBYkdLq7/8o8oK8AUJca0XO2WSG
 GHwbpiQe8JtVYbOdO2bH73g/31HZKfaL43zcwOsvqlCgdOM+gmsfrZfLAMfpH4WE90thjf
 +KXMybxUAc4JSN9VnuIPIFoPoGAJTQiBww7S1pTslWQCH59ULMkdj3oNZpEQsw==
References: <20261102083815.127751-1-wozizhi@huaweicloud.com> <20261102083815.127751-2-wozizhi@huaweicloud.com> <bc03d165-55fa-4029-b653-eb5359a2816c@fygo.io> <ecaeda04-e90b-450b-a591-3cc3cc85fb5f@huaweicloud.com>
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<chengzhihao1@huawei.com>, <wozizhi@huawei.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.55]) by smtp.larksuite.com with ESMTPS; Sun, 08 Nov 2026 02:34:59 +0000
Content-Type: text/plain; charset=UTF-8
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH V3 1/3] md/raid0: reject a takeover whose zones cannot cover the array
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
In-Reply-To: <ecaeda04-e90b-450b-a591-3cc3cc85fb5f@huaweicloud.com>
Date: Sun, 8 Nov 2026 10:34:56 +0800
Message-Id: <f3d1b920-9e57-479d-8169-25e68bfe8bac@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26aefdfd4+c95376+vger.kernel.org+yukuai@fygo.io>
To: "Zizhi Wo" <wozizhi@huaweicloud.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/11/6 16:20, Zizhi Wo =E5=86=99=E9=81=93:
> Hi=EF=BC=8Cyukuai
>
> =E5=9C=A8 2026/11/6 14:34, yu kuai =E5=86=99=E9=81=93:
>> Hi,
>>
>> =E5=9C=A8 2026/11/2 16:38, Zizhi Wo =E5=86=99=E9=81=93:
>>> From: Zizhi Wo <wozizhi@huawei.com>
>>>
>>> If a raid0 takeover builds strip zones that cover less than the=20
>>> advertised
>>> array size, the block layer still accepts I/O for the whole size.
>>> raid0_make_request() hands any request past the zones to the mapping=20
>>> code,
>>> which fails to map it and triggers a BUG_ON.
>>>
>>> The zones are built from the member sizes in rdev->sectors, which=20
>>> may not
>>> match the size the array already advertises, so the zones can come out
>>> covering less than it. The extreme case is a member with no size=20
>>> recorded
>>> at all: an array created without metadata imports its devices through
>>> md_import_device(dev, -1, -1), which never sets rdev->sectors, and
>>> bind_rdev_to_array() does not reject such a member either, because its
>>> check that mddev->dev_sectors fits inside a member is skipped when
>>> rdev->sectors is zero.
>>>
>>> Refuse a raid0 takeover when its zones cannot cover the size the=20
>>> gendisk
>>> advertises. This prevents the takeover from silently shrinking the=20
>>> array,
>>> mirroring the rule raid5_start_reshape() and raid10_start_reshape()=20
>>> apply
>>> to a reshape.
>>>
>>> The check iterates the same devices and uses the same rounding as
>>> create_strip_zones(). It does not skip devices with rdev->raid_disk=20
>>> < 0:
>>> such devices cannot be raid0 members, so counting them only=20
>>> overestimates
>>> the coverage and, if present, the takeover fails later in
>>> create_strip_zones() anyway.
>>>
>>> Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and=20
>>> Raid10->Raid0 takeover")
>>> Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
>>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>>> ---
>>> =C2=A0=C2=A0 drivers/md/raid0.c | 37 ++++++++++++++++++++++++++++++++++=
+++
>>> =C2=A0=C2=A0 1 file changed, 37 insertions(+)
>>>
>>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>>> index 35e103f0c2c3..fccc62a5fecc 100644
>>> --- a/drivers/md/raid0.c
>>> +++ b/drivers/md/raid0.c
>>> @@ -643,6 +643,34 @@ static void raid0_error(struct mddev *mddev,=20
>>> struct md_rdev *rdev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0 }
>>> =C2=A0=C2=A0 +/*
>>> + * Refuse a takeover whose strip zones cannot cover the capacity=20
>>> the gendisk
>>> + * advertises: raid0 derives those zones from the sizes of its=20
>>> members, so
>>> + * find_zone() cannot map I/O that falls beyond them.
>>> + */
>>> +static int raid0_takeover_check(struct mddev *mddev, int chunk)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 sector_t capacity =3D get_capacity(mddev->gendisk);
>>> +=C2=A0=C2=A0=C2=A0 sector_t coverage =3D 0;
>>> +=C2=A0=C2=A0=C2=A0 struct md_rdev *rdev;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 rdev_for_each(rdev, mddev) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sector_t sectors =3D rdev->=
sectors;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sector_div(sectors, chunk);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 coverage +=3D sectors * chu=
nk;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (coverage < capacity) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_warn("md/raid0:%s: refus=
ing takeover, zones cover only=20
>>> %llu of %llu sectors\n",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdn=
ame(mddev), (unsigned long long)coverage,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (un=
signed long long)capacity);
>>
>> Other than raid1, other levels already have mddev->chunk_secotrs set,=20
>> and raid456/raid10 already
>> have a full functional raid0, their takeover can not fail.
>>
>> Noted normally mdadm will set rdev->sectors and 1.x metadata will=20
>> reject zero rdev->sectors in super_1_load.
>> However, it's still possible raid1 can be created with rdev->sectors=20
>> be zero, this is the root cause of the
>> problem syzbot reported.
>>
>
> Please consider the following two cases, both of which reproduce the
> same BUG_ON locally for me:
>
> 1. An array created without metadata leaves rdev->sectors at 0. This
> isn't raid1-specific =E2=80=94 raid10 hits the same BUG_ON too. raid45 on=
ly
> escapes because raid0_takeover_raid45() overwrites rdev->sectors with
> mddev->dev_sectors first; raid0_takeover_raid10() doesn't.

This is still legacy usage, and root cause is still that rdev->sectors be 0=
.

>
> 2. Even with valid non-zero rdev->sectors, growing the chunk of a
> running raid45 can make the post-takeover coverage smaller than the
> previously advertised gendisk capacity. E.g. create a raid5 with
> component_size=3D8K, chunk=3D4K, run it, then change chunk to 16K and run
> raid0_takeover_raid45().

How can chunksize grow to 16k in this case?

>
> So I think the real root cause is that the size changes across the
> takeover, and rdev->sectors =3D=3D 0 is just one special case of it. That=
's
> why the patch compares coverage against the gendisk capacity on every
> takeover path.
>
> For case 2, the problem exists even without a takeover: if the chunk
> change shrinks the usable size, I/O from the upper filesystem will break
> just the same. So I'm now inclined to reject a chunk change in raid5/10
> when it would shrink the usable array size, and additionally check rdev-
> >sectors for raid1/10 at the takeover path. What do you think?

There is always a top rule that running array can be mounted, hence any
changes should not introduce data lost.

>
> Thanks,
> Zizhi Wo
>
>> Although raid0_takeover_raid1() already calculate chunksect by=20
>> mddev->array_sectors, which is exactly the
>> real rdev->sectors for raid1, and it should be guaranteed such=20
>> takeover can succeed. However, as it's legacy
>> usage that rdev->sectors can be zero, I'll suggest just checking=20
>> rdev->sectors in raid0_takeover_raid1() and
>> reject if it's 0.
>>
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return 0;
>>> +}
>>> +
>>> =C2=A0=C2=A0 static void *raid0_takeover_raid45(struct mddev *mddev)
>>> =C2=A0=C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct md_rdev *rdev;
>>> @@ -665,6 +693,9 @@ static void *raid0_takeover_raid45(struct mddev=20
>>> *mddev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev->sect=
ors =3D mddev->dev_sectors;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 if (raid0_takeover_check(mddev, mddev-=
>chunk_sectors))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(-EINVAL);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Set new parameters */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->new_level =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->new_layout =3D 0;
>>> @@ -707,6 +738,9 @@ static void *raid0_takeover_raid10(struct mddev=20
>>> *mddev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR=
_PTR(-EINVAL);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 if (raid0_takeover_check(mddev, mddev-=
>chunk_sectors))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(-EINVAL);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Set new parameters */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->new_level =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->new_layout =3D 0;
>>> @@ -750,6 +784,9 @@ static void *raid0_takeover_raid1(struct mddev=20
>>> *mddev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* array s=
ize does not allow a suitable chunk size */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR=
_PTR(-EINVAL);
>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 if (raid0_takeover_check(mddev, chunks=
ect))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(-EINVAL);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Set new parameters */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->new_level =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->new_layout =3D 0;
>>
>
--=20
Thanks,
Kuai
