From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID-6 support in kernel?
Date: Wed, 5 Jun 2002 09:57:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020605075701.GD2541@colombina.comedia.it>
References: <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <1023125615.1051.1283.camel@peecee> <20020604222053.C31741@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020604222053.C31741@unthought.net>
To: linux-raid@vger.kernel.org
Cc: Jakob =?iso-8859-1?Q?=D8stergaard?= <jakob@unthought.net>
List-Id: linux-raid.ids

On Tue, Jun 04, 2002 at 10:20:53PM +0200, Jakob =D8stergaard wrote:
> What often happens (in my experience) is, that a number of disks buil=
d up bad
> blocks.  One day, you hit one of those bad blocks, and that one disk =
is kicked
> from the array.
>=20
> When you re-sync, you *will* hit the remaining bad blocks on the othe=
r disks,
> causing the array to fail completely.
>=20
> Using hot-spares will "automate" this failure - meaning that an admin=
istrator
> may not be anywhere near the system when this total failure happens.
>=20
> Not using hot-spares is less "automatic" in the lucky case where ever=
ything
> works, but it also assures that an administrator actually is near the=
 system
> when the total failure is likely to occur.
well, what we could do to prevent this. if you don't have or trust S.M.=
A.R.T.
is having a 'consistency check' function in md, that would read from al=
l disks
and even compare data or calculate parity for raid5, it could be schedu=
led
to run periodically with a very very low priority.

L.

--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
