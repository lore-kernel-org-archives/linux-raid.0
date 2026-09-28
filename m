Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17394F7CDA
	for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 20:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790627205; cv=none; b=hsxXqFxaspWa7arOVzfJmO5nPQZD+pkC2T+X7zs5t3oj7dagDi2zbvxRmforG0dREh0XPLgHyoad7+HcON0X0lKfCYgvuD88Sdtp+78i4i9O7OWFPoWdMQOdd2FBDEZiZSnWlXzeoAIIIM87Ww0IKjMKbdZ1fK3+3ZE92kNH/6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790627205; c=relaxed/simple;
	bh=oeAnS1iHS6uEHRUzWTpfPEm3QPJSldsU3klZaBH3EyA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O5EjA1f1f/X7YrACb1ah5Bx1w2AE8vjz68E+acBlLC7VqZbn9mZafktpc80ARVmgbMGA3lJpAp7MfF/vPHVhDEX06af2QRnxvko8r1WPAdaB/PWJ30bPv/MZIrNaQWviOdQ4tiR3MC/ujKAea7G4/gwJUZ1QRY+8XG0MjoVleFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mutMuPgh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mutMuPgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D281F000FF;
	Mon, 28 Sep 2026 20:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790627203;
	bh=hzLmj0MQB5U39/h5t8TPjWfFPs/rSrARNZWWe6FRkMY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mutMuPghJyBsrfu59tYXkYV6ELZAOG/af7rD3h8IeEDTACg3e9z6gGG0wEvzn9+eS
	 ah41NhB2/+HdhenhAWwEhIJcWzYFcaIBk/zyopAqwrqRj3KYRXRvxY8DMBgc/K8sdg
	 wcRy5GdDbF+pbfgHup4uZEMD/F8ki+QaghQ6rdyikLNeqKjt2JKt+8g8a8uXzVM50b
	 Re/Dg7RKCwzSaWEFcL4mNEnfBZOr1lHrkKt61h2JbsFqnoObu5G+t/t8u2vqlWlr6c
	 BguWLluLNWkNP/sOH3Pcg91raebFnlWzzeElqSfj7cRrJOWwJwtUOZGxSBk5P1x4vA
	 iY2oyEYDnFPUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] md: make mddev lookup and ioctl helpers non-static
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260928201224.3602262-2-abd.masalkhi@gmail.com>
References: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
 <20260928201224.3602262-2-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 20:26:43 +0000
Message-Id: <20260928202643.84D281F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] md: generic update_array_info() and set_disk_faulty() lack subsyste=
m prefix
--

commit 471cd6c3e9c36553c5976e00c65220dac80b2aea
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md: make mddev lookup and ioctl helpers non-static

This commit exposes several internal md array lookup and ioctl helper funct=
ions
by removing their static declarations. This change is intended to allow a n=
ew md
misc control device to reuse these helpers without opening the md block dev=
ice.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..b5027d65c6d8d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -8101,7 +8101,7 @@ static void put_cluster_ops(struct mddev *mddev)
>   * Any differences that cannot be handled will cause an error.
>   * Normally, only one change can be managed at a time.
>   */
> -static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
> +int update_array_info(struct mddev *mddev, mdu_array_info_t *info)

[Severity: Low]
By removing the static keyword, update_array_info() is now added to the glo=
bal
kernel namespace. Since this name is quite generic, should it be given an "=
md_"
prefix to avoid potential symbol collisions with other subsystems?

>  {
>  	int rv =3D 0;
>  	int cnt =3D 0;
[ ... ]
> @@ -8227,7 +8227,7 @@ static int update_array_info(struct mddev *mddev, m=
du_array_info_t *info)
>  	return rv;
>  }
> =20
> -static int set_disk_faulty(struct mddev *mddev, dev_t dev)
> +int set_disk_faulty(struct mddev *mddev, dev_t dev)

[Severity: Low]
Similar to update_array_info(), set_disk_faulty() is now globally visible.
Would it be safer to rename this to md_set_disk_faulty() to prevent namespa=
ce
pollution and potential collisions?

>  {
>  	struct md_rdev *rdev;
>  	int err =3D 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928201224.3602=
262-1-abd.masalkhi@gmail.com?part=3D1
