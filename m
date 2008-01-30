From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 19:00:53 -0600
Message-ID: <479FCC45.7050207@pobox.com>
References: <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <479FBA54.6010009@tmr.com> <20080130002237.GC7975@rap.rap.dk> <479FC5B6.10308@pobox.com> <20080130005311.GA12717@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080130005311.GA12717@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Tue, Jan 29, 2008 at 06:32:54PM -0600, Moshe Yudkowsky wrote:
>>> Hmm, why would you put swap on a raid10? I would in a production
>>> environment always put it on separate swap partitions, possibly a n=
umber,
>>> given that a number of drives are available.
>> In a production server, however, I'd use swap on RAID in order to=20
>> prevent server downtime if a disk fails -- a suddenly bad swap can=20
>> easily (will absolutely?) cause the server to crash (even though you=
 can=20
>> boot the server up again afterwards on the surviving swap partitions=
).
>=20
> I see. Which file system type would be good for this?
> I normally use XFS but maybe other FS is better, given that swap is u=
sed
> very randomly 8read/write).
>=20
> Will a bad swap crash the system?

Well, Peter says it will, and that's good enough for me. :-)

As for which file system: I would use fdisk to partition the md disk an=
d=20
then use mkswap on the partition to make it into a swap partition. It's=
=20
a naive approach but I suspect it's almost certainly the correct one.

--=20
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "There are more ways to skin a cat than nuking it from orbit
     -- but it's the only way to be sure."
     				-- Eliezer Yudkowsky
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
