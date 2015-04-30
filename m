From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 09/10] mdadm: change the num of cluster node
Date: Thu, 30 Apr 2015 16:47:42 +1000
Message-ID: <20150430164742.6cf78f6c@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-10-git-send-email-gqjiang@suse.com>
	<20150429115151.0763e980@notabene.brown>
	<5541A2AD.3030506@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/B..ahvl4oOkcR_Cwgo0LeOz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5541A2AD.3030506@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <jgq516@gmail.com>
Cc: gqjiang@suse.com, linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_/B..ahvl4oOkcR_Cwgo0LeOz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Apr 2015 11:34:05 +0800 Guoqing Jiang <jgq516@gmail.com> wrote:

> NeilBrown wrote:
> > On Fri, 24 Apr 2015 15:30:40 +0800 gqjiang@suse.com wrote:
> >
> >  =20
> >> From: Guoqing Jiang <gqjiang@suse.com>
> >>
> >> This extends nodes option for assemble mode, make the num of
> >> cluster node could be change by user.
> >>
> >> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >> ---
> >>  Assemble.c | 4 ++++
> >>  ReadMe.c   | 2 +-
> >>  mdadm.c    | 3 +++
> >>  mdadm.h    | 1 +
> >>  super1.c   | 6 ++++++
> >>  5 files changed, 15 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/Assemble.c b/Assemble.c
> >> index e1b846c..22042a9 100644
> >> --- a/Assemble.c
> >> +++ b/Assemble.c
> >> @@ -649,6 +649,10 @@ static int load_devices(struct devs *devices, cha=
r *devmap,
> >>  							    devname, 0, 0, c->homecluster);
> >>  				tst->ss->write_bitmap(tst, dfd, NameUpdate);
> >>  			}
> >> +			if (strcmp(c->update, "nodes") =3D=3D 0) {
> >> +				tst->nodes =3D c->nodes;
> >> +				tst->ss->write_bitmap(tst, dfd, NodeNumUpdate);
> >> +			}
> >>    =20
> >
> > Doesn't there need to be some test that there is enough free space on a=
ll
> > devices to store the extra bitmaps (when nodes is increasing)??
> >
> >  =20
> Agree, could you pls elaborate more about the test? I guess the test
> need to be run
> before write_bitmap1call the awrite(&afd, buf, n).

Normally we don't increase the size of a bitmap while it is alive.
When an array is reshaped, bitmap_resize in the kernel actually changes the
bitmap chunk size if necessary so that the bitmap will fit in the available
space.=20
To make the bitmap larger, the only current approach is to delete the bitmap
and add a new one.  This is handled by add_internal_bitmap1 in mdadm.
So make the bitmap bigger you will need to perform similar calculations taht
add_internal_bitmap1 performs, though instead of choosing a size or
chunksize, you see need to check if the space is sufficient.

Hope that helps,
NeilBrown

--Sig_/B..ahvl4oOkcR_Cwgo0LeOz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUHQDznsnt1WYoG5AQLwLQ//Se1K8CCnuKD8qT900T7ydjGIaTaRKrXP
Ax5WXGKHdKqJgCsHFZsoFbTxwo8pMwAJuqujA+R8vYc1CdB/Z8lTWsXgAbYZeRwA
PqPr9N1xIFKze3XL+KomU2DsIcKnl7AcykfXlcdfiB1jBsC5kWHQQxtHKvLFP4E7
cfLYZSRIw/aIOUIBZkl8cuG013Wjn63MmYJPqt64mN6kLxFLLIZdziFg21KdIdrs
sqUgrEEfz5BWm3l6D3aRWW03iqbsy/oO1AyzSMkyJwglyKacjMHwi4Jxc5OEwFmR
pgxUisYvxmgnn0vYB1jmWUSIangfF58zOz4huXYehOk3gW1Z/hPfArFLcoBN96Ff
pq0zEB202p/pcc/jGe1RsWgIVBjuG52BVMr1S4dZ79X9XLmLhonUrmXUFzUEiL+Z
IBGrUpqFIEphw44VA1jZMRVhZxHWSILO+AojN2jPHNUD0wuQJD+CP/TRcsNeK1Kl
ns0Z+/XZLBo13jPBr0ZbsjUkHhVw1xDDVLa9n0KIj/D2fvQ0/BCrjSCUIC08NsLH
RCLkfDLB92u0mCRvgXh+CqwaCvHYb8fQt3s1gWmDfv2HDY5V6FjRr9v8RoxU9ExF
Q+PNngG8gqQARM2N3LvXwWguOpHAAQjhP55G54G80ungoXtvp9tOMjQ16FQH0b3w
+HCKc/CSBaQ=
=L+Nb
-----END PGP SIGNATURE-----

--Sig_/B..ahvl4oOkcR_Cwgo0LeOz--
