Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2767928E7
	for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 09:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737970547; cv=none; b=hrK0SCfqBudAfyXfNMAut99lJe/bHOjUBW4IY26Q6xLX1rLlFYqdtRm7jNnMAIv/mQjjfT3AAs8jS0hBSyyl6OTtGw8wOukTW6lqAosW9PWLbsglzG5DofyRXizp7fhRgdb6ozPbwfgqY8wHoieeDVUNNgi0I3vazGC8xRkX9Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737970547; c=relaxed/simple;
	bh=jiajcP8vudPsh9i+RdR+gzlUvlo6mLC8h75cb7vvfF8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lsr9ev40PCytjSEh2JlehY7WtGggk4Nim2LvZrGSelq49RLOGQKw1494YPVUyrRZvxPXpSakzv+2irBhozAjvFiEzYkAHfdoRJXNImjOEUMWQ9Ka17r+jTxvLXRuRTvDtYl6lEXrhfaZg4Jvw7KcoI8rs7bgoUjNiFA9iCuVH8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 8F554C4CED2;
	Mon, 27 Jan 2025 09:35:44 +0000 (UTC)
Date: Mon, 27 Jan 2025 10:35:40 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] mdadm: fix --grow with --add for linear
Message-ID: <20250127103540.2352ae17@mtkaczyk-private-dev>
In-Reply-To: <825cd5bf-9e3c-61c1-0cf0-3b46cfb21d53@huaweicloud.com>
References: <20241227060702.730184-1-yukuai1@huaweicloud.com>
	<20241231094952.1fad40bb@mtkaczyk-private-dev>
	<825cd5bf-9e3c-61c1-0cf0-3b46cfb21d53@huaweicloud.com>
Organization: Linux development
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Jan 2025 16:22:58 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> =E5=9C=A8 2024/12/31 16:49, Mariusz Tkaczyk =E5=86=99=E9=81=93:
> > On Fri, 27 Dec 2024 14:07:02 +0800
> > Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >  =20
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> For the case mdadm --grow with --add, the s.btype should not be
> >> initialized yet, hence BitmapUnknown should be checked instead of
> >> BitmapNone. =20
> >=20
> > Hi Kuai,
> >=20
> > For commit extra clarity it would be nice to include command you are
> > executing.
> >=20
> > What if someone will do (not tested):
> > #mdadm --grow /dev/md0 --add /dev/sdx --bitmap=3Dnone
> >=20
> > I think that it is perfectly valid, now it may work but I expect
> > your change to broke it. =20
>=20
> Hi,
>=20
> Sorry for the late reply, I forgot about this patch somehow :(
>=20
> Changes from commit 581ba1341017:
>=20
> @@ -1634,7 +1625,7 @@ int main(int argc, char *argv[])
>                  if (devs_found > 1 && s.raiddisks =3D=3D 0 && s.level =
=3D=3D=20
> UnSet) {
>                          /* must be '-a'. */
>                          if (s.size > 0 || s.chunk ||
> -                           s.layout_str || s.bitmap_file) {
> +                           s.layout_str || s.btype !=3D BitmapNone) {
>                                  pr_err("--add cannot be used with
> other geometry changes in --grow mode\n");
>                                  rv =3D 1;
>                                  break;
>=20
>=20
> Hence before the commit, bitmap=3Dnone is not valid in this case as
> well, because s.bitmap_file will set to "none" in this case.
>=20
> Thanks,
> Kuai
>=20

OK, ack from my side then.
If there will be no more comments we can merge it. I opened
PR to test it:
https://github.com/md-raid-utilities/mdadm/pull/145

Thanks,
Mariusz
