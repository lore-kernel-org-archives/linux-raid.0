From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: write performance of HW RAID VS MD RAID
Date: Thu, 11 Jun 2015 09:34:48 +1000
Message-ID: <21405395.SSfhQRvNar@dell15>
References: <CAF1ivSa644NVVd5R=2g8rvbZ-FK5cgXy_U1XJjYwMf+TJdftCw@mail.gmail.com> <20150611090054.18daac07@home.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8909423.TiEC06zGZC"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150611090054.18daac07@home.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart8909423.TiEC06zGZC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Thu, 11 Jun 2015 09:00:54 AM Neil Brown wrote:
> On Wed, 10 Jun 2015 15:27:07 -0700
>=20
> Ming Lin <mlin@kernel.org> wrote:
> > Hi NeilBrown,
> >=20
> > As you may already see, I run a lot of tests with 10 HDDs for the p=
atchset
> > "simplify block layer based on immutable biovecs"
> >=20
> > Here is the summary.
> > http://minggr.net/pub/20150608/fio_results/summary.log
> >=20
> > MD RAID6 read performance is OK.
> > But write performance is much lower than HW RAID6.
> >=20
> > Is it a known issue?
>=20
> It is not unexpected.
> There are two likely reasons.
> One is that HW RAID cards often have on-board NVRAM which is used as =
a
> write-behind cache.  This allows better throughput by hiding latency =
and
> more often gathering full-stripe writes.  HW RAID cards may also have=

> accelerators for the parity calculations, but that is not likely to m=
ake a
> big difference. What sort of RAID6 controller do you have?
>=20
> The other is that it is not easy for MD/RAID6 to schedule writes stri=
pes
> optimally.  It doesn't really know if more writes are coming, so it s=
hould
> wait, or if it already has everything - so it should get to work stra=
ight
> away. It is possible that it could reply to writes as soon as they ar=
e in
> the (volatile) cache and only force things to storage when a REQ_FUA =
or
> REQ_FLUSH arrives.  That might help ... or it might corrupt filesyste=
ms :-(

And this here is the problem. Any conceptual changes that risk filesyst=
em and=20
therefore data integrity are bad. For something as simple as benchmarks=
 it=20
isn't really worth the risk of losing data integrity.

In a hardware card setup, one would hope that the write cache is batter=
y=20
backed - or flash - or something that won't lose data if the power goes=
 out.=20
When you're running this in software, you can't magically keep data if =
you=20
lose power - so the longer something is not flushed to disk, the longer=
 the=20
risk period for a write.

If you want to extend this concept - then you're not safe from writes b=
etween=20
the write buffer in the kernel and the (hopefully) battery backed RAM o=
n the=20
hardware card if power is lost. You're also not safe when the card is w=
riting=20
to the physical disk - modern hard drives have massive caches! If the d=
rive=20
has the write in its cache and loses power, is the data gone?

Guaranteed data integrity these days is a difficult subject. The kernel=
 may say=20
the data is written properly - but is it? The HW RAID card may say the =
data is=20
written properly - but is it? Or is it still in cache? Or has it just h=
it the=20
HDD cache?

What we currently have is a slight tradeoff in performance for a minima=
lisation=20
of risk (as far as practical anyway) - and I'm ok with this.

=2D-=20
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
--nextPart8909423.TiEC06zGZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeMmYAAoJEEGvNdV6fTHcuC0P/0xFemfykn9oOx05mR0GxkBz
nXPBlxrU5P/8abINDu7lenfahfw8BGcUPbdfKH/TTnT0TqnEoLsLdV1P2QtQK5qD
w7O5ZRbLDGrjlI+rlY7TKI6O4+Nj/vifv7MitvJvEr4N5XLOI0kGstasJyferA80
kwoxnCrlbdko40Xta7Jjgl50QOQ+aDwLOtD5fvWKSSWIN2EV0hpNs5hJv1mrtus6
ZJS0CqapQvZfu7TnMkd7qPdrh+nYFzJXts/5jclbku9MgXjpwWtnMakmpdy+SYEc
OmtiH+ky6v195EC68zLnxgG2ecQcm+iNb7o8j48xZ5XdQhazh1tQ6VWgnvejhYjd
IercNOE4lg3epyT7izVBZ3uUWELq4xXKAvVjRpwXbtSVwHl5DYLWttGTGE3FGqjf
YxVpV6mqP47arO0Aiwj5CDCRyiv/VK+eK1qHyV6J406/y+/otmYX8sJXiA+Rcibp
d+Nlny7QfBUgQC8BGH/nlAEnugnpLtZXChUPCt+6gn38RCjOMNEgRoN0bWRWTo4s
LlfUSYBqyTRjLvF/ZYfQFnxiCxEa8s2nM+Cwyw7GyOFMO+dvf+xS4fBqsoa8Prt7
dTRSpOA1JpDGq+MU13bHTe9dx7DkYPLOmLc4eELxzBrfgpTGwvZNzqPBybUTAROg
iZqyly7wpvV13nUbJJIZ
=GGNs
-----END PGP SIGNATURE-----

--nextPart8909423.TiEC06zGZC--

