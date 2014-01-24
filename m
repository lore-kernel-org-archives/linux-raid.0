From: NeilBrown <neilb@suse.de>
Subject: Re: Very long raid5 init/rebuild times
Date: Fri, 24 Jan 2014 14:07:29 +1100
Message-ID: <20140124140729.6cf73745@notabene.brown>
References: <20140121073540.GF10140@merlins.org>
	<20140121163755.GG10140@merlins.org>
	<52DF7976.6070808@hardwarefreak.com>
	<20140122174854.GF26014@merlins.org>
	<52E051A3.3050103@hardwarefreak.com>
	<21217.9977.5869.747472@quad.stoffel.home>
	<52E1BB9D.5000204@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d=n+IB+YHx5Qrgclxzxi79p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E1BB9D.5000204@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: John Stoffel <john@stoffel.org>, Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/d=n+IB+YHx5Qrgclxzxi79p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jan 2014 19:02:21 -0600 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 1/23/2014 8:28 AM, John Stoffel wrote:
>=20
> > But more importantly, maybe it would make sense to have this number
> > automatically scale with memory size?  If you only have 1gig stay at
> > 256, but then jump more aggresively to 1024, 2048, 4196 and 8192 and
> > then (for now) capping at 8192. =20
>=20
> Setting the default based strictly on memory capacity won't work.  See
> this discussion for background.
>=20
> http://www.spinics.net/lists/raid/msg45364.html
>=20

I would like to see the stripe cache grow on demand, shrink when idle, and
use the "shrinker" interface to shrink even when not idle if there is memory
pressure.
So if someone wants a project....

NeilBrown

--Sig_/d=n+IB+YHx5Qrgclxzxi79p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUuHY8Tnsnt1WYoG5AQJL1hAAqHB4fGSO92yaFjs5GwsCs2vVisAmF3AL
OBHUXQyUd3jDZtegdpRF/8Y33mKFcjSNYBRb+5QcV4o3Tl4XSdyrCX+l8ETpF//Q
GUc/Q6HxtL63IMkv4KZnCESTmRwoyAq+VlXNLwvwFqEf9YFel6z4sP8XcCU26vSS
hS/Z7eQGh6lqTCu+OC66V/ZtrGQ2lAhcVqY19Cn+dTl692ctVCaCX/Z5US5FvE4m
Gr5I4yiFHar9TzXSK7ObjblJJd7fsSx4XSLCzsNzBWcPwd89mrr42ybcPre/FE6A
oueaan/7cYWyxumJGbuhK3aqwl1bIs5hx5UeGIN5Ug/ZBNUIX6wrm+DxhmyZH48d
b3bFW0p1vQUyIfdZu7Id+idiD5URpVg+guQh5HbYW3fyeMZnbXXNjUTWUz3qRSVd
3HwST+GNS5E38jC6TwnqjXlFJdcXxiYxgL0romEOmBH5bdk0cy8TYFDayflraVxK
VnrVxbpN5hOwJsqx52IeYJDjpxwpm0kE8GT4jnxRYiqQh4wDLjecJFSKb/MmyKet
DW7UzY/VZDl5+zjT/lOycX2BRCGy0O1hq/Le14fNLLQ6ASK0OBkAlnpijz0oAMzn
vVn+mSg2YQ9S3IHz/OYTY8rOZC3zvXWbxvc0bI1FWyYMufy/izOcY3CqU1bZsT1J
FxhjbXIS1B0=
=IEGN
-----END PGP SIGNATURE-----

--Sig_/d=n+IB+YHx5Qrgclxzxi79p--
