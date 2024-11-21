Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546721369AA;
	Thu, 21 Nov 2024 12:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732191713; cv=none; b=bzshBGy+wGdyD3rlG6rxnvSfvxNggCGTqJ9Qw0BsbOhZrhqnNfpAsuL+xTRq5/8dT91g0q/z7ibcZ91maTdyOwCF8MIM6Xw9Ytt1b0MIFLBuTJyj1FUtYlQrr1OdwvirxX9Mu4d/iWGb/IkTGsKRyNzotxSBkp2YsJMchVqkxPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732191713; c=relaxed/simple;
	bh=PgtR1jUgXopDXEzbJEVTpWqQ2KIpOdwZ9QSzjF24OKE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Gwbk5RYnUhj3YIaMSQ45RP133pPCUV2WBQwW8Klp8GB3gBJkvo0d5WN5SF9Jx1y5H23PFqvB3CaqbNnEF2rbcxL+CkAtDLPU5h/qriva7VowTYg3M2Q6gH5n1ta1UFx9vHyjEKSf+2wuk89Zao+StLPqwtLlHJCzOkxuWcm0XgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=H8ALMUtr; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="H8ALMUtr"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1732191707;
	bh=PgtR1jUgXopDXEzbJEVTpWqQ2KIpOdwZ9QSzjF24OKE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=H8ALMUtr1/YkUAzJcwZcbqJxu9caDEyZdQN2H4jviOMWhOsMktSaserRjxzbowWie
	 sL/kNyKEwzvRBKwEt0kI/zDwj/r1JxbPrYg3RzD/bvwrrArpKMrrssVpzHgmk1z8YQ
	 NeYdmtc7EQStK45yB7uMKwqwmjwKfKcM4vbGsru4=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
Date: Thu, 21 Nov 2024 13:21:26 +0100
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
Message-Id: <3038E681-BC24-491B-9AA1-52A4F86E5196@flyingcircus.io>
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com>
 <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
 <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 21. Nov 2024, at 09:33, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Thanks for the test! And just to be sure, the BUG_ON() problem in the
> other thread is not triggered as well, right?
>=20
> +CC Christian
>=20
> Are you able to test this set for lastest kernel?

Reading through the list - I=E2=80=99m confused. You posted a patchset =
on 2024-11-18@12:48. There was discussion later around an adjustment but =
I=E2=80=99m not seeing the adjusted patchset.

Also, which kernel do you want me to test on? 6.12?

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

