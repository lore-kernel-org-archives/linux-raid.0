Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401E9242D7D
	for <linux-raid@vger.kernel.org>; Thu,  9 Oct 2025 04:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759983677; cv=none; b=kw9FSbwI/fMGw+Hp0X1rQaKEPpNdYppa3N/SGz1M258EI7yoMTAYAXc3PSpyiMue1TFXmSsGBDU5B8Q9FouFSfQiYyNql+3yNyPSz7Tg6jkobU4GNEXdHDPcaQjoAtzGUe0qLx5bCTD9RGEBY/uYUNZ2ML9VQMS8lrD2stJrSjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759983677; c=relaxed/simple;
	bh=v0IynbtQvhj2alMdNzsT91k76OikMt1RjhGtzAP0An0=;
	h=References:Content-Disposition:From:Message-Id:Mime-Version:
	 Content-Type:To:Subject:Date:In-Reply-To:Cc; b=fzgMYlw34/vuxwpILJhsEPil9nO/KJ36SuAKNLbQqXuniGzAHVK0MrdXGRBUH6TyA4b92+QPNMVCLd/ByReYnFezZGzsf0ghttn8l5OAfr2po6xhzodDFcc3qylzliUxVtvA0dblHefb26zYg2HBoBVzZaDA1u+/YiNh9dpXoEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=uLxgxsXq; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="uLxgxsXq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1759983624;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=cM3+t8K52U9QEhn9ttclMU49rDYrCe04xL6wKO4HHcA=;
 b=uLxgxsXq5Vx2UeKvuBrHMKt1TlXfdCxjJFTJOP840dgPQI+wCAJcXYin4ap854+E42Txy2
 oUwPuHiou1UBhvQLyFQff9o1UgtEciEjkZoX73UMNy8aEYuPVpw9wTLBtFVAIXFet4N+Xv
 OmiaTlQxf8tvnGyGnFCASgg+n/K0X/RN2labhn6SosCuobir1lmTuKMfnoH3OQozTZbf8d
 PEiSaG7JmT+Ym04ECEb0HgzoNbl7WyRFL0x+HOQldlKV/uoAZHnQLBVNResO5jIZCJ7uvi
 tkeTI+qu+D6RPvLd5RtiUI9GhpMAxYF4ukvISDU+ZoFZu9cRfQ95sLSgaf/08w==
Content-Transfer-Encoding: quoted-printable
References: <20251005162159.25864-1-colyli@fnnas.com> <8b51544b-8ca0-3879-f878-e8bd42aaa148@huaweicloud.com> <j5b7kihtnmlnvnb3lqv6hcluvfex2ynk5nbnqhrvwu2yag4gbp@y5iaoqx5h2rw> <5223b88d-3003-9e3a-d16d-e1adf89eb421@huaweicloud.com>
Content-Disposition: inline
From: "Coly Li" <colyli@fnnas.com>
Message-Id: <nsxq6ybyefylzlup5oha4qb57smv7is4gckqu6w56fw6idg2ub@2qxrpnrd3lic>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+268e73807+19f410+vger.kernel.org+colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: "Li Nan" <linan666@huaweicloud.com>
Subject: Re: [PATCH] md: don't add empty badblocks record table in super_1_load()
Date: Thu, 9 Oct 2025 12:20:21 +0800
In-Reply-To: <5223b88d-3003-9e3a-d16d-e1adf89eb421@huaweicloud.com>
Received: from studio.lan ([120.245.64.214]) by smtp.feishu.cn with ESMTPS; Thu, 09 Oct 2025 12:20:22 +0800
Cc: <linux-raid@vger.kernel.org>
X-Original-From: Coly Li <colyli@fnnas.com>

On Thu, Oct 09, 2025 at 11:54:50AM +0800, Li Nan wrote:
>=20
>=20
> =E5=9C=A8 2025/10/9 10:59, Coly Li =E5=86=99=E9=81=93:
> > On Thu, Oct 09, 2025 at 10:18:59AM +0800, Li Nan wrote:
> > >=20
> > >=20
> > > =E5=9C=A8 2025/10/6 0:21, colyli@fnnas.com =E5=86=99=E9=81=93:
> > > > From: Coly Li <colyli@fnnas.com>
> > > >=20
> > > > In super_1_load() when badblocks table is loaded from component dis=
k,
> > > > current code adds all records including empty ones into in-memory
> > > > badblocks table. Because empty record's sectors count is 0, calling
> > > > badblocks_set() with parameter sectors=3D0 will return -EINVAL. Thi=
s isn't
> > > > expected behavior and adding a correct component disk into the arra=
y
> > > > will incorrectly fail.
> > > >=20
> > > > This patch fixes the issue by checking the badblock record before c=
all-
> > > > ing badblocks_set(). If this badblock record is empty (bb =3D=3D 0)=
, then
> > > > skip this one and continue to try next bad record.
> > > >=20
> > > > Signed-off-by: Coly Li <colyli@fnnas.com>
> > > > ---
> > > >    drivers/md/md.c | 11 ++++++++---
> > > >    1 file changed, 8 insertions(+), 3 deletions(-)
> > > >=20
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index 41c476b40c7a..b4b5799b4f9f 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -1873,9 +1873,14 @@ static int super_1_load(struct md_rdev *rdev=
, struct md_rdev *refdev, int minor_
> > > >    		bbp =3D (__le64 *)page_address(rdev->bb_page);
> > > >    		rdev->badblocks.shift =3D sb->bblog_shift;
> > > >    		for (i =3D 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
> > > > -			u64 bb =3D le64_to_cpu(*bbp);
> > > > -			int count =3D bb & (0x3ff);
> > > > -			u64 sector =3D bb >> 10;
> > > > +			u64 bb, sector;
> > > > +			int count;
> > > > +
> > > > +			bb =3D le64_to_cpu(*bbp);
> > > > +			if (bb =3D=3D 0)
> > > > +				continue;
> > >=20
> > > Can we just break:
> > >=20
> > >     			if (bb + 1 =3D=3D 0 || bb =3D=3D 0)
> > > 				break;
> > >=20
> >=20
> > I just realized even the badblock feature bit is set, it is also possib=
le to
> > have empty or cleared badblock record in the badblock table. So ignore =
the
> > empty record is necessary.
> >=20
> > An empty record could appear in any location inside the badblock table,=
 ignore
> > it by 'continue' is correct. If there is available badblock record afte=
r this
> > empty record, 'break' will lose the available and non-empty record.
> >=20
>=20
> I'm not sure how an empty record can occur, as the commit log says:
>=20
> > calling badblocks_set() with parameter sectors=3D0 will return -EINVAL
>=20

Yes you are correct. There is no empty record inside the badblocks table. Y=
es,
a break is better. Then even user space is still use old mdadm version, peo=
ple
may still add the disk into array with patched kernel, and the incorrect me=
ta-
data even has no chance to call badblocks_set() and is ignored directly.

Thanks for the comments.

Coly Li
