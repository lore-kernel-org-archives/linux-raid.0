From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 rebuild stuck
Date: Wed, 3 Oct 2012 06:29:07 +1000
Message-ID: <20121003062907.3886b2fd@notabene.brown>
References: <20121001112946.GB27455@nsrc.org>
	<20121002155642.606b2108@notabene.brown>
	<20121002155633.GC30589@nsrc.org>
	<506B45C3.4090902@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+f1FP+j5+cfBm2Xkz5FHVpC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <506B45C3.4090902@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+f1FP+j5+cfBm2Xkz5FHVpC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Oct 2012 20:51:31 +0100 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> On 02/10/2012 16:56, Brian Candler wrote:
> > On Tue, Oct 02, 2012 at 03:56:42PM +1000, NeilBrown wrote:
> >> Lesson: always do a read test as well as a write test!
> >
> > And there was me thinking that drives read back data after writing it -
> > clearly they do not :-)
>=20
> Would it be worth adding a re-read onto the end of the usual read=20
> failure reconstruct-write cycle?

What?  Read twice?

We already read after the write when attempting to fix a failure.
I suspect it doesn't do much good though as the data is in cache in the dri=
ve.

NeilBrown

--Sig_/+f1FP+j5+cfBm2Xkz5FHVpC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGtOkznsnt1WYoG5AQIS3w/9Ezr4oWVSBwLCIEUz+zNovvq/0L/XFLjC
hfqZa9NDr6g2TIMmdLL79k/rcY1qn/dXiBvlhzBMxWIK7atYS45sTKAvuKqtbvTI
45Xlvp1ln/i0AsKBb4HqQJGEszg0wViQvh4rvGD3XMvRoRfr7R/qDUL/UmSyu7oy
mljWopvp58Jy7T+hb2ejmygRTdlEAVZHPfrYVtZZ3rD3a1DdFfrv+v0N7gxrLiGp
3OJ4VoUOLCmE82fBMSR2eR3dbZDGeuQxWgtpK5EhwFfJ9etEmCIVitQBxb67i6oy
IkppwUsB12XXMl+ghEJEmtyNXXovSSL+NylVASO8cosRZBw60i0rFqM7etSc1DDn
O3B10YNjEgyHH+LHH+bqUrG4AZVHH4YJW34CfO2f2RiuHNGmtGEZNeVTVBkf+XGw
H173fjcpVMg7tC0Jf6cCXrlYxf9WC7lGcU4BehFv/VZRtWrSeF0hLx+5/vCgljn5
mcMXpHfWfEt/Um1o/GwW0Rx3zoO72v6XgjgO6j1D7FXImV9utRKGfsKiUVp12W6r
ZFObpmBOYyVp9irNBVNeigAd6YiVOrEirH+yrL8K0Ok4p0ZfkPkc3C/6NG89I1j7
38625VZdUQSjJWtlXrOeWdZbN4kRzivUtuZTIuXUai19CV/Y8gP9vJzyxryevqqY
mkKHIxaJKFs=
=0iHK
-----END PGP SIGNATURE-----

--Sig_/+f1FP+j5+cfBm2Xkz5FHVpC--
