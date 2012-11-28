From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Checksumming RAID?
Date: Wed, 28 Nov 2012 20:18:15 +0100 (CET)
Message-ID: <31757832.29.1354130295835.JavaMail.root@zimbra>
References: <952F7343-6478-417E-BA06-D1B0E36519E0@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <952F7343-6478-417E-BA06-D1B0E36519E0@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > That doesn't make sense. Nearline and enterprise drives are large
> > 7k2 drives that come in consumer and enterprise models,
>=20
> Nearline drives are in between consumer and enterprise.

Well, they are named enterprise=E2=80=A6

> > Comparing "nearline" and "enterprise" like done here, is merely a
> > comparison of small and large drives, where it's well known that th=
e
> > smaller (less dense) drives have less errors.
>=20
> The paper I cited doesn't support this. The nearline SATA with
> hardware adapters to convert the interface to fibre channel. The
> enterprise drives were already fibre channel. The paper discusses the
> contribution of the adapter to checksum mismatches, but this alone
> doesn't account for all of the higher rate of error in nearline SATA.

7k2 "nearline" SAS drives exist from several vendors, with SAS interfac=
es without the need for adapters. Also, the interface, wheather SAS or =
SATA or FC, doesn't really mean much when the drive is the same. SAS (a=
nd FC?) has better timing and better controllers, but a SAS drive is a =
SAS drive nonetheless if it has a SAS interface.

> Further, the paper says "There is no clear indication that disk size
> affects the probability of developing checksum mis- matches."
>=20
> At least when it comes to URE (which is not SDC), we note that the
> manufacturer specs are the same for a model regardless of disk size.

Then, if this is true, perhaps they should name their 4TB drives someth=
ing else than "enterprise", which they do. Do you have more references =
on this part?

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
