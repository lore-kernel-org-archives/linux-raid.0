From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: Kernel 2.4.x / RAID1 / RAID5 and swap partition?
Date: Sat, 22 May 2004 21:45:26 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-c8ohlm$jpk$1@cartman.spoiled.org>
References: <Pine.LNX.4.33.0405211416350.5629-100000@lw2.cc-computer.de>
Reply-To: Juri Haberland <juri@koschikode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Martin K=F6hling <mk423@lw1.cc-computer.de> wrote:

> Now I want to convert the rest of the system to RAID1, which should b=
e no
> problem either, except perhaps swap space?
>=20
> I found several RAID docs/HowTos that warn of possible problems, in
> particular this German page:
>=20
> http://www.resultings.de/linux/de-software-raid-howto/de-software-rai=
d-howto.html
>=20
> which claims that resync/hotadd on an active swap device can cause
> an internally inconsistent array (because the resync process uses the
> buffer cache, and the swap code doesn't).
> Bad news if, e.g., an automatic resync happens after a power failure.
>=20
> However, that HowTo is over two years old.
>=20
> Perhaps this problem has long been fixed?

It was true for 2.2 kernels but was resolved with the 2.4 series. I'm
running three systems with swap on RAID1 and never experienced any
problem.

Cheers,
Juri

--=20
Juri Haberland  <juri@koschikode.com>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
