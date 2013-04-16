From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Use RAID-6!
Date: Tue, 16 Apr 2013 19:25:44 +0200 (CEST)
Message-ID: <16433059.10.1366133144567.JavaMail.root@zimbra>
References: <alpine.DEB.2.00.1304161905150.23668@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1304161905150.23668@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > Also, maybe this should be on an FAQ/RAID tutorial somewhere?
>=20
> Question is, where should it be put so that people read it and
> actually
> understand it.
>=20
> This article is from 2007:
>=20
> <http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/1=
62>
>=20
> I've had people argue with me that the above article is wrong, but I
> never
> udnerstood their logic. To me it makes perfect sense and I always go
> RAID6.
>=20
> I also think the work having more than 2 parity drives was very
> promising.
> I'd rather have a 20 drive volume with 4 parity drives than to LVM
> together two 10 drive RAID6:es (apart from obvious performance
> penalties).

I've been running RAIDz3 for a backup machine (zfs receive from the mai=
n box), and the write performance was rather low. I'd rather use lvm or=
 raid-something over different raid-6 volumes. Spread out the risk fact=
or. With ~8 drives in each raid-6 set, the risk is low enough to allow =
for rather large volumes.

--=20
Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
