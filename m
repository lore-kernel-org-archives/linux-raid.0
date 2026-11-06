Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793946909;
	b=fZrSRBZV8vGKh9kN7/OWNsZ5fXGabdOz6NZMbWmUuERIhClZPZakfLs/xk8of64lDNPa
	 GaeLojhaZclY+nnIbFiZaD59CWN7GtsKqB8gFjdI7Ul5qAI0/d5uIBb6DabCuiNFgX429
	 kj2weuDYOeMLnZJI7WHvmbTSgbTF8s4JXmnicb20bB9SCn4h7zyJYlOFQAgt37a9+ZJg4
	 oYCFsEk9p4dfvJ398Xvs9LOOeaSzZPMWSJ9/skwtOBYET/4M5oLO2FHYuKuoTQoRx4I+O
	 mVUKge22VwekDnqH/Q2d25Mxz8qerR9LxPMAFSmIJXOgyFoTWDNfaae4yjymBAyiT7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946909;
	h=DMARC-Filter:DKIM-Signature:From:Message-Id:Mime-Version:
	 Content-Type:Reply-To:Date:Received:X-Lms-Return-Path:X-Original-From:
	 Content-Transfer-Encoding:To:Cc:Subject:User-Agent:References:
	 In-Reply-To;
	bh=6pxqqWwqCMBNjMrohGkp19CQsBRYc3520S8CYGPY6s0=;
	b=gUQmLutVww9e+eoiZcs3DG7GrEyWQAmCvjl0yWyB9wDG0LWV22BeO6pEDKa1DFwwr0Jl
	 nCrXUhuckOkY+FhU8L9z0aVKhYwe4U/IXX595ECdHb5ryEy970F0vZixiKz3l/oP26+X+
	 CAaxIIrRCOY+n7jGx8FkDSl51JjiQszYf6+uSlH/3BiEo6VUkWiKmUZ6t214nDOZZf4lz
	 jTzsYpXT/lBO7JYsz3TRWx3F/FHLPV89xe1i2fwRxg82GyaMo6l9f7v1O0qgDZ8Z2vR24
	 SJ7lme6IdnHQvfOpMBGDzhWWSt+hvNpA8kFEFuKd/ogK++J+tMxjBcPo43p/p9uP9eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=EOpl5MrY;
	arc=none smtp.remote-ip=209.127.231.45
Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABF9606A326
	for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2026 06:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ABF9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=EOpl5MrY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793946900;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=6pxqqWwqCMBNjMrohGkp19CQsBRYc3520S8CYGPY6s0=;
 b=EOpl5MrYGjW7qy/J3V5VUo+NGhB3jGeEdB6yMhrgDkZ6e7t5ClgLRX1WxEoY6AoBcRTohW
 ph0lbbfIbTtW/61XT3qIdPIjNajFWhgH6cTRRz/SZDTbiewEp+ZWL11DghtF18k7ijvQWD
 sLhLxne9K6xztc6wMj5AxWdXSayWr6wAslQgJzMRJME/zCKP3TecY3oLbLzSrEKGPtlwvv
 oAG3AtvH2pgN3uFWw8Yzo5AH5Bv49C5S8RTmFp/OJEbT9w7xdQGtgBuDwobUhZfOt0HaVI
 seXLESbZkaaxZU6UciGYr7168K5hqCU4/ePEulN7KIS4Gt6f6FutRcQlNYlgNw==
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <bc03d165-55fa-4029-b653-eb5359a2816c@fygo.io>
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
Reply-To: yukuai@fygo.io
Date: Fri, 6 Nov 2026 14:34:54 +0800
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Fri, 06 Nov 2026 06:34:58 +0000
X-Lms-Return-Path: <lba+26aed7513+be8761+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
To: "Zizhi Wo" <wozizhi@huaweicloud.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<chengzhihao1@huawei.com>, <wozizhi@huawei.com>
Subject: Re: [PATCH V3 1/3] md/raid0: reject a takeover whose zones cannot cover the array
User-Agent: Mozilla Thunderbird
References: <20261102083815.127751-1-wozizhi@huaweicloud.com> <20261102083815.127751-2-wozizhi@huaweicloud.com>
In-Reply-To: <20261102083815.127751-2-wozizhi@huaweicloud.com>

Hi,

=E5=9C=A8 2026/11/2 16:38, Zizhi Wo =E5=86=99=E9=81=93:
> From: Zizhi Wo <wozizhi@huawei.com>
>
> If a raid0 takeover builds strip zones that cover less than the advertise=
d
> array size, the block layer still accepts I/O for the whole size.
> raid0_make_request() hands any request past the zones to the mapping code=
,
> which fails to map it and triggers a BUG_ON.
>
> The zones are built from the member sizes in rdev->sectors, which may not
> match the size the array already advertises, so the zones can come out
> covering less than it. The extreme case is a member with no size recorded
> at all: an array created without metadata imports its devices through
> md_import_device(dev, -1, -1), which never sets rdev->sectors, and
> bind_rdev_to_array() does not reject such a member either, because its
> check that mddev->dev_sectors fits inside a member is skipped when
> rdev->sectors is zero.
>
> Refuse a raid0 takeover when its zones cannot cover the size the gendisk
> advertises. This prevents the takeover from silently shrinking the array,
> mirroring the rule raid5_start_reshape() and raid10_start_reshape() apply
> to a reshape.
>
> The check iterates the same devices and uses the same rounding as
> create_strip_zones(). It does not skip devices with rdev->raid_disk < 0:
> such devices cannot be raid0 members, so counting them only overestimates
> the coverage and, if present, the takeover fails later in
> create_strip_zones() anyway.
>
> Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 =
takeover")
> Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>   drivers/md/raid0.c | 37 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 37 insertions(+)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 35e103f0c2c3..fccc62a5fecc 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -643,6 +643,34 @@ static void raid0_error(struct mddev *mddev, struct =
md_rdev *rdev)
>   	}
>   }
>  =20
> +/*
> + * Refuse a takeover whose strip zones cannot cover the capacity the gen=
disk
> + * advertises: raid0 derives those zones from the sizes of its members, =
so
> + * find_zone() cannot map I/O that falls beyond them.
> + */
> +static int raid0_takeover_check(struct mddev *mddev, int chunk)
> +{
> +	sector_t capacity =3D get_capacity(mddev->gendisk);
> +	sector_t coverage =3D 0;
> +	struct md_rdev *rdev;
> +
> +	rdev_for_each(rdev, mddev) {
> +		sector_t sectors =3D rdev->sectors;
> +
> +		sector_div(sectors, chunk);
> +		coverage +=3D sectors * chunk;
> +	}
> +
> +	if (coverage < capacity) {
> +		pr_warn("md/raid0:%s: refusing takeover, zones cover only %llu of %llu=
 sectors\n",
> +			mdname(mddev), (unsigned long long)coverage,
> +			(unsigned long long)capacity);

Other than raid1, other levels already have mddev->chunk_secotrs set, and r=
aid456/raid10 already
have a full functional raid0, their takeover can not fail.

Noted normally mdadm will set rdev->sectors and 1.x metadata will reject ze=
ro rdev->sectors in super_1_load.
However, it's still possible raid1 can be created with rdev->sectors be zer=
o, this is the root cause of the
problem syzbot reported.

Although raid0_takeover_raid1() already calculate chunksect by mddev->array=
_sectors, which is exactly the
real rdev->sectors for raid1, and it should be guaranteed such takeover can=
 succeed. However, as it's legacy
usage that rdev->sectors can be zero, I'll suggest just checking rdev->sect=
ors in raid0_takeover_raid1() and
reject if it's 0.

> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>   static void *raid0_takeover_raid45(struct mddev *mddev)
>   {
>   	struct md_rdev *rdev;
> @@ -665,6 +693,9 @@ static void *raid0_takeover_raid45(struct mddev *mdde=
v)
>   		rdev->sectors =3D mddev->dev_sectors;
>   	}
>  =20
> +	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
> +		return ERR_PTR(-EINVAL);
> +
>   	/* Set new parameters */
>   	mddev->new_level =3D 0;
>   	mddev->new_layout =3D 0;
> @@ -707,6 +738,9 @@ static void *raid0_takeover_raid10(struct mddev *mdde=
v)
>   		return ERR_PTR(-EINVAL);
>   	}
>  =20
> +	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
> +		return ERR_PTR(-EINVAL);
> +
>   	/* Set new parameters */
>   	mddev->new_level =3D 0;
>   	mddev->new_layout =3D 0;
> @@ -750,6 +784,9 @@ static void *raid0_takeover_raid1(struct mddev *mddev=
)
>   		/* array size does not allow a suitable chunk size */
>   		return ERR_PTR(-EINVAL);
>  =20
> +	if (raid0_takeover_check(mddev, chunksect))
> +		return ERR_PTR(-EINVAL);
> +
>   	/* Set new parameters */
>   	mddev->new_level =3D 0;
>   	mddev->new_layout =3D 0;

--=20
Thanks,
Kuai
