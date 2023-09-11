Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791A3CA0EC7
	for <linux-raid@archiver.kernel.org>; Mon, 11 Sep 2023 22:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243899AbjIKV7M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbjIKJty (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 11 Sep 2023 05:49:54 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88D1ED;
        Mon, 11 Sep 2023 02:49:50 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 80CBA1C0006; Mon, 11 Sep 2023 11:49:49 +0200 (CEST)
Date:   Mon, 11 Sep 2023 11:49:49 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>,
        Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 2/3] md: raid1: fix potential OOB in
 raid1_remove_disk()
Message-ID: <ZP7ivTQR0bjM6WU/@duo.ucw.cz>
References: <20230908193656.3464052-1-sashal@kernel.org>
 <20230908193656.3464052-2-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OGjEqHIQQgjcf3XB"
Content-Disposition: inline
In-Reply-To: <20230908193656.3464052-2-sashal@kernel.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--OGjEqHIQQgjcf3XB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Zhang Shurong <zhang_shurong@foxmail.com>
>=20
> [ Upstream commit 8b0472b50bcf0f19a5119b00a53b63579c8e1e4d ]
>=20
> If rddev->raid_disk is greater than mddev->raid_disks, there will be
> an out-of-bounds in raid1_remove_disk(). We have already found
> similar reports as follows:
>=20
> 1) commit d17f744e883b ("md-raid10: fix KASAN warning")
> 2) commit 1ebc2cec0b7d ("dm raid: fix KASAN warning in raid5_remove_disk")
>=20
> Fix this bug by checking whether the "number" variable is
> valid.

> +++ b/drivers/md/raid1.c
> @@ -1775,6 +1775,10 @@ static int raid1_remove_disk(struct mddev *mddev, =
struct md_rdev *rdev)
>  	struct r1conf *conf =3D mddev->private;
>  	int err =3D 0;
>  	int number =3D rdev->raid_disk;
> +
> +	if (unlikely(number >=3D conf->raid_disks))
> +		goto abort;
> +
>  	struct raid1_info *p =3D conf->mirrors + number;
> =20
>  	if (rdev !=3D p->rdev)

Wow. Mixing declarations and code. I'm pretty sure that's not ok
according to our coding style, and I'd be actually surprised if all
our compiler configurations allowed this.

Best regards,
								Pavel=09
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--OGjEqHIQQgjcf3XB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZP7ivQAKCRAw5/Bqldv6
8le7AKCgrKgcgGkSi2I67IFDj1QPs5ZO5gCeMTHbL+GKcdVrmS8czxZCE2n+SaI=
=Qad9
-----END PGP SIGNATURE-----

--OGjEqHIQQgjcf3XB--
