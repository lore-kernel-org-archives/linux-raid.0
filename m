Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C201154BFF;
	Thu, 21 Nov 2024 09:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732181446; cv=none; b=DIG7D50ZHEBrOxz1Asz1WOsu4eGOqldDw3KDVR1pdC+5cCrCkXxXrcnPhsSam/8eE9h9n/S7uWYW2iQ9gNn+ighg84nPB3ukFh3GyfMEHNa6GNBjaaqxL+w9oTWRVuIf5ntgQfZdVBPhpQAw8dme9sxByfpqsi8+3bG/2qKYDgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732181446; c=relaxed/simple;
	bh=kY6ATH4jDYJl+37Zh0x1guou/Yjv6FBOF7eBV4sdsCE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=MVxdABSgg+HZJnfCcKbKFrttenGnfQPfQXU6tBCW0XS25AMnPqWdXvFkzo4clSrT8j7R9KTS7dWN3JYomgyvF2jGfXarLHwBaCxBohAoU3+X4+VFPejwTsrN0UzCK1JAmVyvRgbKxXy2yK/8Vz8xNX6Y9kqPDPPKhOOx7rvOfuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=BcJ0f6/J; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="BcJ0f6/J"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1732181434;
	bh=kY6ATH4jDYJl+37Zh0x1guou/Yjv6FBOF7eBV4sdsCE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=BcJ0f6/J+1pW7RwIGqCAAaqMH4Rtw5RB9VY102dzq+f6kYMfyb1FKnETiV3m9ErcE
	 QAfHtFDhbrMpey4196AdXTiM3G4aZCESnQnvap78V72Gunr8JNHcP7Rjfq+ad9mIBi
	 6xP6xRoWypzFzy7EVubB4bYr+EXIanJRHrusfHBI=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
Date: Thu, 21 Nov 2024 10:30:13 +0100
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
Message-Id: <DFAA8E00-E2CD-4BD0-99E5-FD879A6B2057@flyingcircus.io>
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com>
 <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
 <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 21. Nov 2024, at 09:33, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2024/11/21 16:10, Jinpu Wang =E5=86=99=E9=81=93:
>> On Tue, Nov 19, 2024 at 4:29=E2=80=AFPM Jack Wang =
<jinpu.wang@ionos.com> wrote:
>>>=20
>>> Hi Kuai,
>>>=20
>>> We will test on our side and report back.
>> Hi Kuai,
>> Haris tested the new patchset, and it works fine.
>> Thanks for the work.
>=20
> Thanks for the test! And just to be sure, the BUG_ON() problem in the
> other thread is not triggered as well, right?
>=20
> +CC Christian
>=20
> Are you able to test this set for lastest kernel?

I have scheduled testing for later today. My current plan was to try =
Xiao Ni=E2=80=99s fix on 6.6 as that did fix it on 6.11 for me.

Which way forward makes more sense now? Are those two patches =
independent or amalgamated or might they be stepping on each others=E2=80=99=
 toes?

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

