Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9098174C
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 12:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716468464; cv=none; b=T7x/uMm1JUatElRfsjKZqIQKkzD9R0x7yyF8lEbZUG0dnPf/yaU2chGp6/pHI+vlVnM9OlBb/KvLWoSnOpJNIUszvQ0AWzd7u0RqV/3yH7EBvLtxAFnVs+Iek/+xB1XFBmBXIz0vcUPhVx2NF3LmlipufqE1jn6nXBy9whfZKZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716468464; c=relaxed/simple;
	bh=Z9gUSg05XVWtlZdABzlCBnn93lzLc6NDnnsRn2Q4PUQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSKMalGWvFgYQGzJtDBmSxSyvQxxhlsnzAWOMuqpTTC2MrprOZeLHou5sHiI+S7LyXngXoLDnI/7DbXcVnTTkWpr/t3MfiLx8KqozpMo311eH955ivDL/Im92/msEM+XAvex8/YP3J5rvxjTrCbWRXJN1lPlq19neNddCD4rFak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=radoeka.nl; spf=fail smtp.mailfrom=radoeka.nl; dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b=PQ+V9AWs; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=radoeka.nl
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=radoeka.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kpnmail.nl header.i=@kpnmail.nl header.b="PQ+V9AWs"
X-KPN-MessageId: a0eca7b6-1902-11ef-959b-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id a0eca7b6-1902-11ef-959b-00505699b430;
	Thu, 23 May 2024 14:47:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kpnmail.nl; s=kpnmail01;
	h=content-type:mime-version:message-id:date:subject:to:from;
	bh=Flh1Md1xx3TbMwRGk91HLpKKhocP1jh38Xd7DKRhBD4=;
	b=PQ+V9AWsFuC6G/jbIX4nO0FTlv0Sy+kbUM8LcaOmEpk7cQooEzw1xdsrttauCjGmWEhhZrAZ7W3OB
	 Y517cX5qWbViFjnGZOzGV/+xuv1RCz26bjG4qRHmDpV3YROuSOm6eYAr8gs423EeRCke9MIoZN+gg6
	 w4f1PMcEGxm0edIk=
X-KPN-MID: 33|ZY8ILJ4Jn3Do9bYEMGkW8Cb8TLjaXIVd1xilypGrO2HLtCbnEKSC0a811Jt2/vd
 CzbzIVupDhpejalGOuBEaEfTJopVvokRLH44SeqiwU/w=
X-KPN-VerifiedSender: No
X-CMASSUN: 33|gsBOsrMfiHwft3yjkOt2WiN75lZ4XKeaa7NBZJeQphUMwjMun/+miAlLVweFv4g
 i0bGnGoifD0g0E4POHdUyvQ==
Received: from selene.localnet (80-60-179-152.fixed.kpn.net [80.60.179.152])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id a14e597e-1902-11ef-8b48-00505699b758;
	Thu, 23 May 2024 14:47:35 +0200 (CEST)
From: Richard <richard@radoeka.nl>
To: linux-raid@vger.kernel.org
Subject: Re: RAID-1 not accessible after disk replacement
Date: Thu, 23 May 2024 14:47:35 +0200
Message-ID: <171649809.VBMTVartND@selene>
In-Reply-To: <26966548-7e1e-d187-4694-2056e2ecb04d@huaweicloud.com>
References:
 <1910147.LkxdtWsSYb@selene>
 <26966548-7e1e-d187-4694-2056e2ecb04d@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Hi,

Op donderdag 23 mei 2024 14:20:35 CEST schreef Yu Kuai:
> Hi,
>=20
> =E5=9C=A8 2024/05/23 19:47, Richard =E5=86=99=E9=81=93:
> > Hello,
> >=20
=2E..
> > Information of the involved RAID before the disk replacement:
> >=20
> > /dev/md126:
> >             Version : 1.0
> >      =20
> >       Creation Time : Sat Apr 29 20:30:27 2017
> >      =20
> >          Raid Level : raid1
> >          Array Size : 247464768 (236.00 GiB 253.40 GB)
> >      =20
> >       Used Dev Size : 247464768 (236.00 GiB 253.40 GB)
> >=20
> > I grew (--grow) the RAID to an smaller size as it was complaining about
> > the
> > size (no logging of that).
>=20
> This is insane, there is no way ext4 can mount again. And what's
> worse, looks like you're doing this with ext4 still mounted.

Thanks for the swift answer.  Will try this later.
It's (also) good to know that it may not be possible to fix (as that saves =
time).

(big) If there are still possibilities.... I'll try that.


=2D-=20
Richard


