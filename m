Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC86B182B4
	for <linux-raid@vger.kernel.org>; Mon,  6 Oct 2025 03:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759719789; cv=none; b=mpvz3P8K0kRVFrKTwhHHaCph0h3fTJkzSdW3f3CvfUGXALnvHxu3o4yTIa1IMtwELpbbD2BRiRiqJIvjJsu9AqXcE9STqw1m0j99vjNBeEnwMRsE/WQ9ESS0vrtOKueDhvX7TC1Ym5vGt1KkCtBGMmwEDEFcvm7u3jr0CayDkUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759719789; c=relaxed/simple;
	bh=xTIUgJN3UNnGpcS5vUxm7ugYGG0y9w/D2kcZBpemhRY=;
	h=Content-Disposition:Cc:Message-Id:References:To:From:Content-Type:
	 Subject:Date:Mime-Version:In-Reply-To; b=LUDsqoN8jvOtpwtQU/7S7G55n5HBwGOeB/z3xArQ3zYh4EJQwSCKxJsTRoKlWDvSJsP8QmMoD2TI9AvNitUPeoptEFEXGRrJWAws7guYfPsaScrHggWgjAPd2motoQiN6TUh3Hxjq0GXH3LGrublTnqpM0W/JC6FKjbAwEeb7e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=nCvUlbsT; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="nCvUlbsT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1759718876;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1h0f2ljzmPXGClFw1O+cY2dSpZF+txNUiCBJF5qraUs=;
 b=nCvUlbsT/Ai6T3xDugV0HUiFmrG5stQ7SLOX5wIuToQKeLzoVWgm1ywoh+C9ZrC9/9GQs8
 hBhI3q9z5mDXNUpEpkhyyih4WYsPFdLSnxB9iVmoodUvSHqDwMHublx2suxAWSjbOYyD81
 uIeQIXbRDUIObVmg0VABBVU1uKg8GJY3PXM+/ToySZ+V4uOGMMwsy0BLpusAsmlCuCH0Do
 926uj7N1hKSIdFCtH4EE5uJ1NbetDjaxUHllsbuo2VPfXDhAZeF6SrE6ogPqSmQG/miLFM
 jHkEAJAaMyCsvbiB0uhVwdAFsuGyiI7UT7Q7qrfVbH4cxlFJRvFLWc/3gez0iw==
Content-Disposition: inline
Cc: <linux-raid@vger.kernel.org>
Message-Id: <hsbsklqvuhxrcmjy4ng2xeczir4dxzkexw4tykga3eljipmu2o@rnt2b3djkbx6>
Content-Transfer-Encoding: quoted-printable
References: <20251005162159.25864-1-colyli@fnnas.com> <3bf12e32-db86-4958-a450-4507adc636f0@yukuai.org.cn>
To: "Yu Kuai" <hailan@yukuai.org.cn>
From: "Coly Li" <colyli@fnnas.com>
Received: from studio.lan ([120.245.64.214]) by smtp.feishu.cn with ESMTPS; Mon, 06 Oct 2025 10:47:53 +0800
X-Lms-Return-Path: <lba+268e32dda+0c891b+vger.kernel.org+colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH] md: don't add empty badblocks record table in super_1_load()
Date: Mon, 6 Oct 2025 10:47:52 +0800
X-Original-From: Coly Li <colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <3bf12e32-db86-4958-a450-4507adc636f0@yukuai.org.cn>

On Mon, Oct 06, 2025 at 10:08:09AM +0800, Yu Kuai wrote:
> Hi,
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
>=20
> This problem is from user space tools, the flag MD_FEATURE_BAD_BLCOKS mea=
ns
> that the rdev have badblocks presents, and this flag should not be set in
> the superblock for new disk.
>=20
> Please take a look at following mdadm commit, and see if your problem sti=
ll
> exist.
>=20
> commit 4e2e208c8d3e9ba0fae88136d7c4cd0292af73b0
> Author: Wu Guanghao <wuguanghao3@huawei.com>
> Date:   Tue Mar 11 03:11:55 2025 +0000
>=20
>     super1: Clear extra flags when initializing metadata
>=20
>=20

I feel this patch doesn't go into the debian 12 package.

Yeah, it is also necessary to fix kernel part, in case of old user space
installtion with updated stable kernel.

Thanks for the hint.

Coly Li

>=20
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
> > +			count =3D bb & (0x3ff);
> > +			sector =3D bb >> 10;
> >   			sector <<=3D sb->bblog_shift;
> >   			count <<=3D sb->bblog_shift;
> >   			if (bb + 1 =3D=3D 0)
