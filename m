Received: from sg-1-13.ptr.blmpb.com (sg-1-13.ptr.blmpb.com [118.26.132.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC371EF36B
	for <linux-raid@vger.kernel.org>; Thu,  9 Oct 2025 02:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759978772; cv=none; b=n4xpNQvKLWHirmPGcqQ5A/E8RjzvxxrfGQBacHy1r6U0taiBdhJy/cB75a9PZ7UUEpKX50XgQxLNzMsy0EdJbvRlz5+FGu2J+rBPS8fyBjB828q8Rc3hxGzUqFxpzCvTRUQYv0Apxcq0FF1biPNGk8LAMgl8bERVeZ6QIOnII4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759978772; c=relaxed/simple;
	bh=/+A4qBiQilxLWzFoajVeMQhOZQVPBZGfCjUvHzsqvis=;
	h=Content-Type:In-Reply-To:From:Content-Disposition:Cc:Subject:
	 Mime-Version:References:To:Message-Id:Date; b=G/vCDmOfwT38vh/L0WWbbedIUUcxc6iGjmoJjOR+ogxaLqEeeor9P/sX2u+3e9UbX5GKkNok2WgfMv0OMkxt8Vt5Ha8EuAbz9M1mR13K38wb6Qe4QeHtn3u7bMeiicqcYxb+7uTSjx9F61SmJaChBeT+AKO7bsuRtGUILKhIoWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=gwQY+CpP; arc=none smtp.client-ip=118.26.132.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="gwQY+CpP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1759978756;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bbHPjIq8/V0ZLJWl9XOfA5GQwZZ5jD1667EzsLK1sJ0=;
 b=gwQY+CpPw9eJPrut1vcXH+UOvUsEyWS6VOiRXnEdnJe/YTQ5iacNwrdY2Z5FyFQtXbcib5
 W8yfTFLaoIkba4PzVMvALcfaXFUS7gUuxgduw+LGV8noNj4YxXgAlYsTgsGyxpvV9IX9DH
 nWxmShy8uFxEsF0wiSjTXiT+prDeAS//aw1wloui1EoahE1RWlvd37yiaPDwqgqGEpd6wP
 D3yeiWN0sHoploTeqSYSs9+2tU2lKDTIgIcGBPsEPON6C7hOfGTZzcf/svJ+m1kR0O9a3m
 Fcfg4E8KselH6yptPmjupsllRq1o+V1RKJf2tqo4dhyEtINx8N54IKHmmBzbaw==
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <8b51544b-8ca0-3879-f878-e8bd42aaa148@huaweicloud.com>
From: "Coly Li" <colyli@fnnas.com>
X-Lms-Return-Path: <lba+268e72502+da2dad+vger.kernel.org+colyli@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Received: from studio.local ([120.245.64.214]) by smtp.feishu.cn with ESMTPS; Thu, 09 Oct 2025 10:59:13 +0800
Cc: <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] md: don't add empty badblocks record table in super_1_load()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251005162159.25864-1-colyli@fnnas.com> <8b51544b-8ca0-3879-f878-e8bd42aaa148@huaweicloud.com>
X-Original-From: Coly Li <colyli@fnnas.com>
To: "Li Nan" <linan666@huaweicloud.com>
Message-Id: <j5b7kihtnmlnvnb3lqv6hcluvfex2ynk5nbnqhrvwu2yag4gbp@y5iaoqx5h2rw>
Date: Thu, 9 Oct 2025 10:59:12 +0800

On Thu, Oct 09, 2025 at 10:18:59AM +0800, Li Nan wrote:
>=20
>=20
> =E5=9C=A8 2025/10/6 0:21, colyli@fnnas.com =E5=86=99=E9=81=93:
> > From: Coly Li <colyli@fnnas.com>
> >=20
> > In super_1_load() when badblocks table is loaded from component disk,
> > current code adds all records including empty ones into in-memory
> > badblocks table. Because empty record's sectors count is 0, calling
> > badblocks_set() with parameter sectors=3D0 will return -EINVAL. This is=
n't
> > expected behavior and adding a correct component disk into the array
> > will incorrectly fail.
> >=20
> > This patch fixes the issue by checking the badblock record before call-
> > ing badblocks_set(). If this badblock record is empty (bb =3D=3D 0), th=
en
> > skip this one and continue to try next bad record.
> >=20
> > Signed-off-by: Coly Li <colyli@fnnas.com>
> > ---
> >   drivers/md/md.c | 11 ++++++++---
> >   1 file changed, 8 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 41c476b40c7a..b4b5799b4f9f 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -1873,9 +1873,14 @@ static int super_1_load(struct md_rdev *rdev, st=
ruct md_rdev *refdev, int minor_
> >   		bbp =3D (__le64 *)page_address(rdev->bb_page);
> >   		rdev->badblocks.shift =3D sb->bblog_shift;
> >   		for (i =3D 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
> > -			u64 bb =3D le64_to_cpu(*bbp);
> > -			int count =3D bb & (0x3ff);
> > -			u64 sector =3D bb >> 10;
> > +			u64 bb, sector;
> > +			int count;
> > +
> > +			bb =3D le64_to_cpu(*bbp);
> > +			if (bb =3D=3D 0)
> > +				continue;
>=20
> Can we just break:
>=20
>    			if (bb + 1 =3D=3D 0 || bb =3D=3D 0)
> 				break;
>=20

I just realized even the badblock feature bit is set, it is also possible t=
o
have empty or cleared badblock record in the badblock table. So ignore the
empty record is necessary.

An empty record could appear in any location inside the badblock table, ign=
ore
it by 'continue' is correct. If there is available badblock record after th=
is
empty record, 'break' will lose the available and non-empty record.

> Otherwise LGTM.

Thanks for the review.
>=20
> > +			count =3D bb & (0x3ff);
> > +			sector =3D bb >> 10;
> >   			sector <<=3D sb->bblog_shift;
> >   			count <<=3D sb->bblog_shift;
> >   			if (bb + 1 =3D=3D 0)

Coly Li
