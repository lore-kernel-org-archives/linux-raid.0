Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA0D2309B4;
	Thu, 21 Nov 2024 16:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732206307; cv=none; b=Ke0AaVUKQ8HOg9wW3mGbFQzNsY8RuubLat16n45/QSv4ECqYHYlysDqGmyGlb1FzXUfPkpT8UnlpJZ/rAMezjjBiVrT+fvvbktY4BS1/7kn024ljOomDa0w8mOVCj8LfW7O2z0ij60CVGz2C6d1g2B/BCNj/87WA9GESGulPSfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732206307; c=relaxed/simple;
	bh=QfDiO6HHbgnS2YaC6IjdgIPIrk7akdCBJwlOEasus3U=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=QOXTQbqAVp/ozYaMVTQhkhBhLaP5qIBH+XU/O+MiS+AFkaLxbF1ZqHY01u0h8D7IMf46nksokVDefB3S/vISu0eUY2ukGBjOUGdssZY+Rn4GLTFrhLSiM+kGxiDRj3+C11sQwwl9gqsEXwOxpstKQm6tETc0QndlRnR2vRPuYEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=PLfR/iEl; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="PLfR/iEl"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1732205684;
	bh=QfDiO6HHbgnS2YaC6IjdgIPIrk7akdCBJwlOEasus3U=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=PLfR/iEl92iO7jFFoZrwqwQ5cgZXuBamrxiId+BWfDruR4V0c5MPkRGWFOB62Cdmd
	 fzTKgdjZCjoHtQz9zFXzrvyioVWEyZieDemU/Bq0175aRsQbzNGz6iz5zebrGx2akb
	 jVbPSletBFPjG74+lPAR5IUAU14q3eTcsZ7dPapQ=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <e688ffc6-73ff-ba82-4991-4a072c5bc5fe@huaweicloud.com>
Date: Thu, 21 Nov 2024 17:14:23 +0100
Cc: Jinpu Wang <jinpu.wang@ionos.com>,
 Haris Iqbal <haris.iqbal@ionos.com>,
 linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org,
 song@kernel.org,
 xni@redhat.com,
 yangerkun@huawei.com,
 yi.zhang@huawei.com,
 =?utf-8?Q?Florian-Ewald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D6DF34A-81EF-47EE-B280-6A243A28011D@flyingcircus.io>
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com>
 <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
 <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
 <3038E681-BC24-491B-9AA1-52A4F86E5196@flyingcircus.io>
 <e688ffc6-73ff-ba82-4991-4a072c5bc5fe@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 21. Nov 2024, at 13:37, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
>=20
> I don't know you mean here, this is the only set. If you didn't
> subscribe mail-list and don't know how to find the set:
>=20
> =
https://lore.kernel.org/all/20241118114157.355749-1-yukuai1@huaweicloud.co=
m/

Yes, I saw those and was talking about =
https://lore.kernel.org/all/adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweiclo=
ud.com/

>> Also, which kernel do you want me to test on? 6.12?
>=20
> The branch is from the title, md-6.13. If you don't know:
>=20
> =
https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/log/?h=3Dmd-6.=
13

Ok, I can use that. Had to bail out for today and will try again =
tomorrow.

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

