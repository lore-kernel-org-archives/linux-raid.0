Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E70B79CD
	for <linux-raid@vger.kernel.org>; Mon,  6 Oct 2025 01:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759713533; cv=none; b=SsFe63sPwYzRyAJ7r2wTEwxh6++/27+ZdGQBNNeph+a5HZVChpm7ke/ElAIjq+k3m3SHIh4gP5R8dTKa5t6LccY6wWegqmNB1a1G6W60VcNP/D75b2z2fhMZ5yq3vhNnoKcLsnUS245f0QPxD/jJITqjpS+UGRmsSjHLKlVdCOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759713533; c=relaxed/simple;
	bh=cbyNTgJbmLvWr3dkH7V+/ndup+r/Ez5M1qOD4W5eC8o=;
	h=Content-Disposition:Content-Type:Mime-Version:References:From:
	 Subject:In-Reply-To:To:Cc:Date:Message-Id; b=H7LebJCUzze+TNgytUP6urFa8HheOa5I+i71Tu8CB2WCplJ1C2N/lhnBj3CCR3hSZ2UCc+ut5D//X53Ve2UYN6KQfOhnnW6xcB/lFOsBdgbgJQRKwL75a4mgKSsVVciCNL4PGcAtnfa69s+WQm26LoNNBfeb7fqbNPDvpTAruEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=koJXM/eW; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="koJXM/eW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1759712793;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=gOHsUpVaGpTAXQ5BuMV2uRxGNZrcbMH8/egiYqAoDGU=;
 b=koJXM/eW/bv+uRQACDBu9xVtRsy3Sib0VueVcF6Pl2lIP7F2QXrcmoFuaXUyveb/mA1Op1
 VHJY9ES7MiA49ZaMubPH6Lbs+n+eY9TE2F37NB0gsZPRIQFuuQI6oQnQAh+/ENyaHcIfTx
 D33NEZqGWQ+n5pGBFVRAruhblY8d1Zcig82QyO60s8R0VebghVsP7RycUcL49EHMeVxwNt
 6T0twmlsT6+8QE8VBXsdxQmbAoJXii635a5yJazFsuDD2c4QoaoyAZNzUXAcsuJeqOSN8C
 GiGbTp2PVWF3atljjKkAX8Q3wT6VxExqZ2aG3Snc/jFXHC3OGV/mDeLCVWJWAw==
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+268e31617+cc4f81+vger.kernel.org+colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fnnas.com>
References: <20251005162159.25864-1-colyli@fnnas.com> <ae9a4a36-5dd6-4d66-8b04-8d6f09494b7f@molgen.mpg.de>
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [PATCH] md: don't add empty badblocks record table in super_1_load()
In-Reply-To: <ae9a4a36-5dd6-4d66-8b04-8d6f09494b7f@molgen.mpg.de>
To: "Paul Menzel" <pmenzel@molgen.mpg.de>
Cc: <linux-raid@vger.kernel.org>
Date: Mon, 6 Oct 2025 09:06:30 +0800
Message-Id: <o4jmod6t4v7zwjcbeurjxlx7jgy5zs2qzstz232qmssct362pg@el4w4tnjinx3>
Received: from studio.lan ([120.245.64.214]) by smtp.feishu.cn with ESMTPS; Mon, 06 Oct 2025 09:06:30 +0800

On Sun, Oct 05, 2025 at 07:35:42PM +0800, Paul Menzel wrote:
> Dear Coly,
>=20
>=20
> Thank you for your patch.
>=20
> Am 05.10.25 um 18:21 schrieb colyli@fnnas.com:
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

Hi Paul,

>=20
> It=E2=80=99d be great if you added the commands to reproduce this.
>

It is reported by a online testing system, this is a md raid5 array with
5 disks. What I can observe is, one of the component disks has around 200
badblocks records. If another component disk is failed and removed from
the array, this raid5 array will fail to add another disk to replace the
failed one.

The reason is described in commit log, badblocks_set() refuses to add an
empty record into its badblocks table.

I also tried to write to badblocks sysfs interface e.g.
	/sys/block/md0/md/dev-sdx1/badblocks
but failed to reproduce the observed failed behavior. I guess it was
becasue my operation didn't trigger super_1_sync() to be called.

Why this component disk has so many badblocks record? I don't think this
disk drive is broken, it might be from a previous obsrved incompatible
issue between this hard drive and the mpt3sas driver of the HBA card.

After applying this patch, another disk can replace the failed-and-removed
hard drive. But at this moment I don't reproduce such failure on other
md raid5 array yet.

=20
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
> > +			count =3D bb & (0x3ff);
> > +			sector =3D bb >> 10;
> >   			sector <<=3D sb->bblog_shift;
> >   			count <<=3D sb->bblog_shift;
> >   			if (bb + 1 =3D=3D 0)
>=20
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

Thanks for the review.

Coly Li
