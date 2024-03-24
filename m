Received: from bsmtp.bon.at (bsmtp.bon.at [213.33.87.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B905E168B9
	for <linux-raid@vger.kernel.org>; Sun, 24 Mar 2024 11:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.33.87.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711278355; cv=none; b=o07+fINOI3w6U+SbuOUXg6bRyaxfGRM0icsGQDpRKFcYib/LAlxaRicEvUmLJJpa0LtN0smOlKy6PD9e50pm7OMH9BxXp7tCHPPWW+/0cDgwczeD4oLqLmIOHJ2h/ZECMJwa41JKzHqFTSrvQlDaVvXMm3FOM3kZ3Tow9wAjpBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711278355; c=relaxed/simple;
	bh=43+jsDfLjTHrqvPd6EVVuzeu42EXESeiED67AVjzBps=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jc1Utzh2eaSGUfBgUHzxPiHaHJ85CAEDmxBqoiHILs+PR8pG2YMXHDqm5ynyA6Osl5hDPsltp/F0bIMWYrN9B+veTbr/AUjK7zLJVNBpqm4cigMSNEW8WDwrFe6aXpdDn90FjTQUJEImXpRQCqiGTPmdPGdNTdyh38fbyqfTfYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=reinelt.co.at; spf=pass smtp.mailfrom=reinelt.co.at; arc=none smtp.client-ip=213.33.87.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=reinelt.co.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=reinelt.co.at
Received: from artus.reinelt.local (unknown [91.113.221.42])
	by bsmtp.bon.at (Postfix) with ESMTPSA id 4V2YBx5z7hzRnQm
	for <linux-raid@vger.kernel.org>; Sun, 24 Mar 2024 12:05:45 +0100 (CET)
Message-ID: <0d94a5c7ab218c65ca9d2f7838be5a9a268a09ce.camel@reinelt.co.at>
Subject: Re: heavy IO on nearly idle RAID1
From: Michael Reinelt <michael@reinelt.co.at>
To: linux-raid@vger.kernel.org
Date: Sun, 24 Mar 2024 12:05:45 +0100
In-Reply-To: <9bbb9664-f42b-48cf-933e-cde0a588843e@molgen.mpg.de>
References: <a0b4ad1c053bd2be00a962ff769955ac6c3da6cd.camel@reinelt.co.at>
	 <abae1cb3-2ab1-d6cb-5c31-3714f81ef930@huaweicloud.com>
	 <d26f7e96192abbbebd39448afe9a45e2fdd63d21.camel@reinelt.co.at>
	 <ae0328a65c8a8df66dee1779036a941d2efd8902.camel@reinelt.co.at>
	 <CAAMCDecDjUyLJi7QP9cmxOQfnsJdzbYDv70Ed0uB8uuf2Ry6-Q@mail.gmail.com>
	 <58c66b62d0da6e5173d7f313aca27cd325aa0afb.camel@reinelt.co.at>
	 <9bbb9664-f42b-48cf-933e-cde0a588843e@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Am Dienstag, dem 19.03.2024 um 18:48 +0100 schrieb Paul Menzel:

> As you can reproduce this, and it works with an earlier version, the
> fastest way to resolve the issue is unfortunately to bisect the issue to=
=20
> find the commit causing the regression.

I agree, but bisecting between kernel 6.1.76 and 6.6.13 sounds like a bit o=
f work, doesn't it? :-(

As this happens on my computer that I need for work every day (and night :-=
), it makes it even more
complicated. I could try to set up another system (hardware available, but =
I'd have to buy a SSD for
it), but this will take some time...


Am Dienstag, dem 19.03.2024 um 23:05 +0500 schrieb Roman Mamedov:

> I think it might be related to discard or write zeroes support on 6.6. I =
had
> some issues enabling USB TRIM on kernel 6.6, compared to 6.1.
>=20
> What do you get for "lsblk -D" on both kernels and both storage drivers o=
n 6.6,
> are there any differences?

I tried 6.1 and 6.6 both with UAS enabled/disabled, and I get identical res=
ults:

NAME        DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
sda                0      512B       2G         0
=E2=94=9C=E2=94=80sda1             0      512B       2G         0
=E2=94=82 =E2=94=94=E2=94=80md0            0      512B       2G         0
=E2=94=94=E2=94=80sda2             0      512B       2G         0
  =E2=94=94=E2=94=80md1            0      512B       2G         0
sdb                0        0B       0B         0
=E2=94=9C=E2=94=80sdb1             0        0B       0B         0
=E2=94=82 =E2=94=94=E2=94=80md0            0      512B       2G         0
=E2=94=94=E2=94=80sdb2             0        0B       0B         0
  =E2=94=94=E2=94=80md1            0      512B       2G         0
sdc                0        0B       0B         0
nvme0n1            0      512B       2T         0
=E2=94=9C=E2=94=80nvme0n1p1        0      512B       2T         0
=E2=94=9C=E2=94=80nvme0n1p2        0      512B       2T         0
=E2=94=9C=E2=94=80nvme0n1p3        0      512B       2T         0
=E2=94=82 =E2=94=94=E2=94=80md0            0      512B       2G         0
=E2=94=94=E2=94=80nvme0n1p4        0      512B       2T         0


> Aside from that, trying "blktrace" was a good suggestion to figure out th=
e
> process writing or even the content of what is being written.

I tried to understand blktrace, but failed :-) I've never worked with this =
tool...

Can someone give me advices how to use it, and which results you are intere=
sted in?


greetings, Michael

--=20
Michael Reinelt <michael@reinelt.co.at>
Ringsiedlung 75
A-8111 Gratwein-Stra=C3=9Fengel
+43 676 3079941
