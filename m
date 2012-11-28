From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Checksumming RAID?
Date: Wed, 28 Nov 2012 13:02:47 -0700
Message-ID: <2F243DBA-A790-43EA-AD2F-02140D6C4CD9@colorremedies.com>
References: <31757832.29.1354130295835.JavaMail.root@zimbra>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <31757832.29.1354130295835.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 28, 2012, at 12:18 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> =
wrote:

>>> That doesn't make sense. Nearline and enterprise drives are large
>>> 7k2 drives that come in consumer and enterprise models,
>>=20
>> Nearline drives are in between consumer and enterprise.
>=20
> Well, they are named enterprise=85

Yep it's misleading. SNIA has a slide show describing the differences b=
etween consumer nearline and enterprise.

> 7k2 "nearline" SAS drives exist from several vendors, with SAS interf=
aces without the need for adapters. Also, the interface, wheather SAS o=
r SATA or FC, doesn't really mean much when the drive is the same. SAS =
(and FC?) has better timing and better controllers, but a SAS drive is =
a SAS drive nonetheless if it has a SAS interface.

Nearline SAS is effectively a consumer SATA drive (you don't get the be=
tter mechanics), with a SAS interface.


> Then, if this is true, perhaps they should name their 4TB drives some=
thing else than "enterprise", which they do. Do you have more reference=
s on this part?

Basically you have to look at the specs. Maybe a reasonable rule of thu=
mb is the URE, but even that gets perverted sometimes. < 1 bit in 1E14 =
is consumer, 1E15 is nearline, 1E16 is enterprise.=20

=46or example:
http://www.wdc.com/wdproducts/library/SpecSheet/ENG/2879-771386.pdf

<10 in 10^16 =3D <1 in 10^15, means this is nearline. It's clearly the =
same as the RE SATA in every way (all mechanical specs) except that it'=
s a SAS interface.

Whereas this:
http://www.wdc.com/wdproducts/library/SpecSheet/ENG/2879-771429.pdf

<10 in 10^17 =3D <1 in 10^16 is enterprise.

Notice the size and speed difference, which is where "nearline" is bein=
g used. More capacity and slower than enterprise makes it nearline, mor=
e so than the URE. But URE makes it easier to distinguish between consu=
mer and nearline.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
