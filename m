From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: RAID-6 support in kernel?
Date: Tue, 4 Jun 2002 22:20:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020604222053.C31741@unthought.net>
References: <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <1023125615.1051.1283.camel@peecee>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1023125615.1051.1283.camel@peecee>; from gleblanc@linuxweasel.com on Mon, Jun 03, 2002 at 10:33:24AM -0700
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 03, 2002 at 10:33:24AM -0700, Gregory Leblanc wrote:
> On Mon, 2002-06-03 at 02:25, Derek Vadala wrote:
>         On Mon, 3 Jun 2002, Roy Sigurd Karlsbakk wrote:
>        =20
>         > It'll waste 9 drives, giving me a total capacity of 7n inst=
ead of 14n.=20
>         > And, by definition, RAID-6 _can_ withstand _any_ two-drive =
failure.
>        =20
>         This is certainly not true.=20
>        =20
>         Combining N RAID-5 into a stripe wastes on N disks.=20
>=20
> Hot spares are quite a nice way to increase the reliability of your
> arrays, somewhat.  You can still be in trouble if a second disk fails
> before the resync finishes, but at that point you're probably talking
> about something of a more catastrophic failure, perhaps outside of th=
e
> machine itself. =20

What often happens (in my experience) is, that a number of disks build =
up bad
blocks.  One day, you hit one of those bad blocks, and that one disk is=
 kicked
from the array.

When you re-sync, you *will* hit the remaining bad blocks on the other =
disks,
causing the array to fail completely.

Using hot-spares will "automate" this failure - meaning that an adminis=
trator
may not be anywhere near the system when this total failure happens.

Not using hot-spares is less "automatic" in the lucky case where everyt=
hing
works, but it also assures that an administrator actually is near the s=
ystem
when the total failure is likely to occur.

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
