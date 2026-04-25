Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFCF22538F
	for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 11:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777117607; cv=pass; b=EWEI9xjrvlbbVrc8DQPzodNzrZVi9PkfKmYVc1HdrkW4Kt4YaxQvnmkmiJLruugTuDckX5I04iq5bFGhJwVNaTv8sfzYh2EoaAkl9ki+9GP9uqUVqyVlFRJklBItdsUAbHzu03E4p2oiKwK5h29E1zPPySdYSt9VjRXWctrNO58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777117607; c=relaxed/simple;
	bh=3dkh1EFFPOoHTF0hrtz2IDP6/Ng4A279gAaN+ttFAaY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IasQeDkXJQwjl8SspqzvAmv/AzEO7LwMYtKXzbq8vfBj9zhOWlRMqa7WXRBRsEW7H9MYiV3PI0gnDRKzXtACeVegZpQMZ/ts7zfy2RNWfDm7zYETFiF9tu0zu955w5MjGJIO+PB5+4U2uybm3lXEQFvnnUvo3kznYGoNcOb88w8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A2WryALJ; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2WryALJ"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43d77f6092eso6010983f8f.2
        for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 04:46:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777117604; cv=none;
        d=google.com; s=arc-20240605;
        b=RsAx8Ff8Y2aN3AhEdPSm8+h/nzfEp9uKAH0RhaBsXhpbEZ4n6CXdtOdp5EEmrtQDs5
         rmLyg2PVLbU/Zz/j5n9SqgGNl1xUtS/UYdmLi/9oj9dgtgy/hVxX4aNmJQ5vkV5o07Xw
         WDwpR149lkqvC3R/o+YzpTrBUXKD1WoWhFXAgwrq3+OLKK/o5R0f5T86qFrjMjCPsqYb
         0p+o6iQ7wuaB8ZXJOU3qZiENzr+MCzA/MsN+lCfB9NVkinJhY/cujaKcWliwHH6nvg68
         t8nAxLDODOuA5j6tUDjj5dUKVwYQvmPA8TPQR+IYUu8D7m4AXu4dE8cxGdItL7Z9dNn8
         /qCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8FUrLXSCZqPqxFHXgAkOgwEVVen4UoluY1xOumnyhwo=;
        fh=XVx51kCZWuc5DBvXTwhPvSf+YKDrHVFiOPuv/K0QVkY=;
        b=NwVOOOCHS9SWHFEjYFWhr6xOCfsEO1yzQrWBCKl+KdRDjyC3OB6qhbLDLfDuA9KcoH
         nwq9UaRck1C0JhBLU0eLy0nK0UfMktAf1OFtgREyU9Df7skphuwaxuaHD8M+Pzr7lF3D
         YohBCjLRqH/aRBa8HhYalU9mMlNefOt6JkiPL70wWSqK0c+aO1uzVCdzxnbYHkfpY2wy
         A3V2LZhVcuJB1+0thp9coBfIFHFq6JM7RSeXUb6mOoiBYjeBQczOXSM40gCg0TB/vstL
         ktCxouH4uTijOUw11lJJZJQ1y0AncqCW+82amOo9rm0cyz7eyfZNfTE1LVu9Iiq2ScLv
         2fiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777117604; x=1777722404; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8FUrLXSCZqPqxFHXgAkOgwEVVen4UoluY1xOumnyhwo=;
        b=A2WryALJRhuvUEWbr6+nW2xVrv9XUXWGqMX9AVeEGSiEBUCwKFgVYnfebckyQV1aZc
         FdaA+CZtfC0THIxawZezDl0D15oaid2LssoReoF8Xsoq7o0Mfzk97GUTNRfh3qM7YTWY
         /ejngYPXQCHQu93lqLlGMGPp2KYZdRq5uceReEltTVZ/GB+AoRwagZjgiUkfNeVQx7MU
         hejgrZsBVcJDFe79WczpNMD6DC+ft8uaOLtDPPXrvakz2JY8+DAO/yQBCJcVJ2ylY9yr
         qqcdSdgutlaZg2Kyxk9JiK0qM098gOyIN1QCHrCmLX15xBFqUitCdJ9QNn89PGnpfTOk
         dNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777117604; x=1777722404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8FUrLXSCZqPqxFHXgAkOgwEVVen4UoluY1xOumnyhwo=;
        b=ZxC5P0SozPe/fS4PS8+WobPHPUsW2L+nGRjfYp7AbFd6LkdHdmWZIlQTqe2/s57r6G
         v8ENfnLN1j7NnUVh3H8xq5GX5u8q0TJl3g7kUtm0MPmF65LbornqESUVWwf7Upv2OWTo
         5mHHADa5v29Ro0DDKwXe07JkZBKu9fpoNw+sP8VLwFEQxtJO4lCDOgTLookq4bszLDun
         A9eUbI5P+QJOi9k95YuUaEfvAHJ7GC++/zUgZAi3+6cuz8xZEfJKEJupT/P6BY1WzuQT
         Mu7tMzUSvGvcuWmRGwOOAqYBI41DIyBSwUqQloIBoRSU0iaIqtTTdygo3zm2UgEJQ9rU
         qYWQ==
X-Forwarded-Encrypted: i=1; AFNElJ8nvogwAsubULs5YHTQ9iECeIjY82mbh0IaOggDkS4gImpS1cisYXJx2JY20xAZn/bV+S8CXbATCIFc@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7CdkCmsa6bJVxJ0UXBTdKyb32Hwo6aE0Lq7Cv9H2rdrNHUcMb
	jh/6me3iGaT7cUeSt08rbRJ57x8kbVG0JbQlecjZafzEJJWHrsMLFopbvD1Lp1eeYD8hPMcEUts
	KE4pvJSymrxXEfTWqHB6ktLp7enHvM/o=
X-Gm-Gg: AeBDieuGuXTX/gz1lLlLTHhbfsRAUgNxuVEVov/yXa0nBmE/PV5md+XP64vNur9H4/d
	LRJZ8sijukCpYsyVdEt4VUnueMLsWHUppMqj++cCwdX0YaeflXudkJfBdwE85J/3QFa8pGsg7im
	eTwz3CmiCd9+/2gLdRPbVzHlKIm1vHK+GLQbkdOKsOLsDEjidjMqCYOFzbBQ/7nNxB41MSa136f
	3h6prHUbfgEF78BgefIo+ykQ3Ym3AUeHj0WFrgJzWKoy0EBorzTkcW9QlJYt/SnZFCI0rN8M6vJ
	e6OCGySUr9JZIzev
X-Received: by 2002:a05:6000:24c3:b0:43d:7868:21db with SMTP id
 ffacd0b85a97d-43fe3dcc11amr55562078f8f.18.1777117603839; Sat, 25 Apr 2026
 04:46:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <acJhCCPfVxjFUZ5R@J2N7QTR9R3> <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
 <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com> <20260331063659.GA2061@lst.de>
 <CAOLeWCtnZz=kHGk4C2f9Mbfi3tEBE100iCkMBhcG47dmR9eDWw@mail.gmail.com>
 <CAOLeWCtxPk7q_bVvrcKaipSKr+_=57Auobcj0cFRvXxXMdH58g@mail.gmail.com>
 <5158e4e0-3275-4c29-a8fc-2dfabc13a69d@app.fastmail.com> <CAOLeWCtf2rZyPeJH-LuZ2A+c7mC9M2r-Ya0VjyOJFpun3TFMnw@mail.gmail.com>
 <8db4defe-8b5e-4cc3-880b-72d46510b034@arm.com> <c9362db6-1fef-4e70-9525-29b2936f4887@app.fastmail.com>
 <2c2eb793-c0a4-4b65-93f1-0ece5cf820d7@sirena.org.uk>
In-Reply-To: <2c2eb793-c0a4-4b65-93f1-0ece5cf820d7@sirena.org.uk>
From: Demian Shulhan <demyansh@gmail.com>
Date: Sat, 25 Apr 2026 14:46:31 +0300
X-Gm-Features: AQROBzCGKHu6guzCM7pwEyGOZ2XR-XPK9d42N7x5GVU_IgEZfJxb13D1ue9-s_0
Message-ID: <CAOLeWCv56Zz9Ns8APm+Q6+gpGPqni7GWvAfVYnvrYjRU0EZHfg@mail.gmail.com>
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
To: Mark Brown <broonie@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Christoph Hellwig <hch@lst.de>, Mark Rutland <mark.rutland@arm.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fnnas.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all!

In the future I will try to look at optimisation of current algorithms
instead of SVE realisation, looks like there are few interesting
cases, I will share details in future changes.

Thanks all for the discussion!

=D0=BF=D1=82, 17 =D0=BA=D0=B2=D1=96=D1=82. 2026=E2=80=AF=D1=80. =D0=BE 18:3=
6 Mark Brown <broonie@kernel.org> =D0=BF=D0=B8=D1=88=D0=B5:
>
> On Fri, Apr 17, 2026 at 04:43:06PM +0200, Ard Biesheuvel wrote:
>
> > On arm64, kernel mode NEON is mostly used to gain access to AES and SHA
> > instructions, and only to a lesser degree to speed up ordinary
> > arithmetic, and so XOR is somewhat of an outlier here.
>
> > Given that Neoverse V1 apparently already carves up ordinary arithmetic
> > performed on 256-bit vectors and operates on 128 bits at a time, I am
> > rather skeptical that we're likely to see any SVE implementations of th=
e
> > crypto extensions soon that are meaningfully faster, given that these
> > are presumably much costlier to implement in terms of gate count, and
> > therefore likely to be split up even on SVE implementations that can
> > perform ordinary arithmetic on 256+ bit vectors in a single cycle. Note
> > that even the arm64 SIMD accelerated CRC implementations rely heavily o=
n
> > 64x64->128 polynomial multiplication.
>
> I'd not be surprised to see something that delivers useful benefits
> using SVE at some point.
>
> > IOW, before we consider kernel mode SVE, I'd like to see some benchmark=
s
> > for other algorithms too.
>
> Definitely, it needs a solid win to merge anything.  I do want to get
> back to the situation where we've got out of tree infrastructure patches
> so that people working on algorithms have something to base their work
> on (and see the overheads using SVE incurs) but unless theres's a
> practical user they should stay out of tree.
