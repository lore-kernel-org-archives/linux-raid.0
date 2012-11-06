From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md:Avoid write invalid address if read_seqretry
 returned true.
Date: Tue, 6 Nov 2012 22:01:14 +1100
Message-ID: <20121106220114.40b8fbc2@notabene.brown>
References: <201211061712569914353@gmail.com>
	<20121106211455.417b35f1@notabene.brown>
	<201211061836292577626@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vxOZOGmzXPKyVG4tnhrvBtm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201211061836292577626@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, zhuwenfeng <zhuwenfeng@kedacom.com>
List-Id: linux-raid.ids

--Sig_/vxOZOGmzXPKyVG4tnhrvBtm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Nov 2012 18:36:33 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >On Tue, 6 Nov 2012 17:13:00 +0800 majianpeng <majianpeng@gmail.com> wrot=
e:
> >
> >> If read_seqretry returned true and bbp was changed, it will write
> >> invalid address which can cause some serious problem.
> >>=20
> >> This bug was introduced by commit v3.0-rc7-130-g2699b67.
> >> So fix is suitable for 3.0.y thru 3.6.y.
> >>=20
> >> Reported-by: zhuwenfeng@kedacom.com
> >> Tested-by: zhuwenfeng@kedacom.com
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/md.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>=20
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 9ab768a..d63aa78 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -1805,15 +1805,15 @@ static void super_1_sync(struct mddev *mddev, =
struct md_rdev *rdev)
> >>  		md_error(mddev, rdev);
> >>  	else {
> >>  		struct badblocks *bb =3D &rdev->badblocks;
> >> -		u64 *bbp =3D (u64 *)page_address(rdev->bb_page);
> >>  		u64 *p =3D bb->page;
> >>  		sb->feature_map |=3D cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
> >>  		if (bb->changed) {
> >>  			unsigned seq;
> >> +			u64 *bbp;
> >> =20
> >>  retry:
> >> +			bbp =3D (u64 *)page_address(rdev->bb_page);
> >>  			seq =3D read_seqbegin(&bb->lock);
> >> -
> >>  			memset(bbp, 0xff, PAGE_SIZE);
> >> =20
> >>  			for (i =3D 0 ; i < bb->count ; i++) {
> >
> >
> >No.
> >The contents of the page might change, but it is always the same page, s=
o it
> >always has the same address, so "bbp" is guaranteed to be stable.
> >
> >NeilBrown
> >
> Is my understand wrong?
> >u64 *bbp =3D (u64 *)page_address(rdev->bb_page);
> >		u64 *p =3D bb->page;
> >		sb->feature_map |=3D cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
> >		if (bb->changed) {
> >			unsigned seq;
>=20
> >retry:
> >			seq =3D read_seqbegin(&bb->lock);
>=20
> >			memset(bbp, 0xff, PAGE_SIZE);
>=20
> >			for (i =3D 0 ; i < bb->count ; i++) {
> >				u64 internal_bb =3D *p++;
> >				u64 store_bb =3D ((BB_OFFSET(internal_bb) << 10)
> >						| BB_LEN(internal_bb));
> >				*bbp++ =3D cpu_to_le64(store_bb);
> I think bbp will be changed. Is ok?


Ahh yes, I see now.

Applied, thanks.

NeilBrown


> >			}
> >			bb->changed =3D 0;
> >			if (read_seqretry(&bb->lock, seq))
> >				goto retry;
>=20
> =09

--Sig_/vxOZOGmzXPKyVG4tnhrvBtm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJjt+jnsnt1WYoG5AQKPLw/+O77Epl77fzEXhbivTK8HJCNq9Sg5iupS
VSn4wXGCdFbHOlIywuC7QuQIl6rylzgGzsaNxBnFujreoeB9fF01FYONhw17kF5x
KzYE6sG4KxZp2pMGiGdq0gRC7i4gTeI2NM1tzqU2rA286diqbS6Xhaa2olCSYXAD
69b71hdDVFs8BdpOAs7wmteM2AF51kcUiuXh1dw8bHPasyv3Cpy3WOQYrlrE2xIG
NjCPiDpXhRwp71zKIcTrrz4WDj8AqunE1XEHXt44pC5l/ned3Q3TXdCBh8j1P7ff
bG5VLJOgHk8CQ3NsDL3P1GrUqaV/wEJGtXgKRwqMEu0VUqcLsBOFl9YQGPnwHdZN
Oy6TC/ZPryfdEQXxy8iFV42oQDRCefzCRNd///gq2fumsognZw2E6o3xNyMG7KCs
w6ikIRsp6mifZTJAOGzkRJwUDhrtQXpMI9eR8T9geEvfH4jRHodcARUAfKWcITRt
XbEWORL3IYxv/HVJjSCvrbnqIo0HEodaB42ibGEs7BRrqN8qha2FWBg9WD2jZQlr
XEoDxoVNa8hjJe9Kc2bin3XFzcTrF5WKVI1WXQWmHx+WlXyU2XbsRH2vdQ4cxxX5
M4y8DcjK5l9MWBcQ9Uy9EyLcNL8O636Nhpr8Wg3WxKUrVeDpc8q0HuSqV61ZK0AR
me18apRdELo=
=Mo/C
-----END PGP SIGNATURE-----

--Sig_/vxOZOGmzXPKyVG4tnhrvBtm--
