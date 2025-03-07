Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B7021E0A8
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 19:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375512; cv=none; b=JaESAxQUV2BIwNZnWzOITaohB9QWRrpojZvQRPNmhuM6pHmi5mjSx5QNGJ4L5uCu0ITekorWlTnTutaNwiUhzwK9itP3GXmBPA7C1enEqRVQhWRIarYRgWIA0cJJ1vOkmBujFvca2BcQ49G/5YZ6TrRg7SGV5lpYsGyMJdiZuMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375512; c=relaxed/simple;
	bh=q0ysxbRzl0TyFe3q8IEjMT8kb/2tuutByrzr4zhAGv8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XyCgqBT6OOSTKlORpsu50GMyAJxqv0+6Q8ZN53IZbO2F4Rct+ox/y9/ATgkAhSe82l/R89GmT5qOi60jW7elDmGeMJ0SxxOI/KusDBh/2150JYa3jwJpmkiwufOJqi63pYdf/i4hODNCAUlHzl10Xqy3Vy84FlNSFJLW+kAMu2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=H68u330l; arc=none smtp.client-ip=79.135.106.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="H68u330l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1741375508; x=1741634708;
	bh=9s096z2EjvqFOXpnP3cltj1AaAvd9gnIekKp0vB8qow=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=H68u330lrvxdE52Gg+C3NUptvzQfbMWmLZngazx4oPydcom1rWPc7UPjTw8kF/emo
	 5+lXjC6cD8MSAlrOq38Y0DJWo2YfjAX6Of0KAo/zCnTt//KjbPAZDAnQJz8a88NVpI
	 akclHQvN74A5P/5t0fOe5CxrzZdL9FryPvbvJ7A9Q8C0qDcT9co/vX50lsJmUZxQsL
	 /fdtG+IHYOHpDxQDFD1YoswSxgArY2TaN0NGpYuFSvn5xncfYYPmuLlXrqjtaAe4Eq
	 VjKxqPTYVQp86B4/EeYvtP5kHZuxKECjzf6cUHGVVYnpWpTkyPOWwPYTg+W2qH1RUQ
	 NOBD9RuMotq+g==
Date: Fri, 07 Mar 2025 19:25:03 +0000
To: "rm@romanrm.net" <rm@romanrm.net>
From: David Hajes <d.hajes29a@pm.me>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: RAID 5, 10 modern post 2020 drives, slow speeds
Message-ID: <wbKuA1vBv5kD_KeuudRU95HVHtIXiMs9hvH40_jlVcKTvwOR_4vszdQADWASxjhfBXFS2JkNpQnCnrdaoiombOE6Tof66ktqnXyRnwQXw7o=@pm.me>
In-Reply-To: <20250307234753.473dc4b5@nvm>
References: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me> <20250307234753.473dc4b5@nvm>
Feedback-ID: 111191645:user:proton
X-Pm-Message-ID: c84d101aa77a5d04b690acaf03ce5689f015e962
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Roman,

Thanks for reply.

All drives tourist SATA3 CMR

Link speed for LSI SAS2308 8GTs/8x

Intel C224 chipset SATA controller

Write speed is always same, no matter RAI level, chipset C224 or SAS connec=
tion.

Read test for RAID10 is 414MBs

I was hoping for higher writing speeds. What is interesting RAID5 in defaul=
t setting does 220MBs while RAID10 struggles at 170MBs.

There is something horribly wrong :o)

So bitmap seems to be on. Mdstat says "bitmap: 0/204 pages 65M chunk

--bitmap=3Dnone

Write speed 170MBs on RAID10 with chunk 1MB

Bitmap internal with chunk 128M write speed 170


-------- Original Message --------
On 07/03/2025 19:47, Roman Mamedov <rm@romanrm.net> wrote:

>  Hello,
> =20
>  On Fri, 07 Mar 2025 18:36:13 +0000
>  David Hajes <d.hajes29a@pm.me> wrote:
> =20
>  > I have issues with RAID5 running on post-2020 14TB drives.
>  >
>  > I am getting max writting speeds of 220MBs.
> =20
>  What about read speeds, do you get much more, or clamped in the same bal=
lpark?
> =20
>  To not wait for a full resync just to check this (or various other setti=
ngs),
>  you can create the array with --assume-clean.
> =20
>  In case reads are also limited to the same value, I'd suspect PCIe bandw=
idth
>  issues, such as the HBA getting choked by 2.5 GT/s x1 for whatever reaso=
n.
>  Check the bandwidth in "lspci -vvv".
> =20
>  > I have played with chunk size...default 512k-2MBs...no difference
>  >
>  > "Read-ahead" set for md0 virtual disk
>  >
>  > NCQ disabled - set 1 for all physical drives
>  >
>  > I have basically tried every suggestion on famous ArchWiki.
> =20
>  Do you use the Write-Intent bitmap, and what is its chunk size?
>  Try without one briefly, to see if this was the issue.
>  For production use, increase the bitmap chunk size and see if that helps=
.
> =20
>  > Initial resync drops to 130MBs
> =20
>  Are your drives SMR or CMR? For SMR drives it is common to briefly write
>  quickly and then slow down as they need to do their housekeeping during =
the
>  same time as new writes. SMR are not recommended for RAID.
> =20
>  > Is it possible this weird issue is linked to HDD timeout described the=
re >>> https://archive.kernel.org/oldwiki/raid.wiki.kernel.org/index.php/Ti=
meout_Mismatch.html
> =20
>  No.
> =20
>  --
>  With respect,
>  Roman
>  
