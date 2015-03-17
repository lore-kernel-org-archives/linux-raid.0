From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] Make bm_blocks to match previous semantic
Date: Wed, 18 Mar 2015 09:57:12 +1100
Message-ID: <20150318095712.1954b958@notabene.brown>
References: <1426560030-16152-1-git-send-email-jgq516@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/T19rusBSDZDie55z1Szw5HJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1426560030-16152-1-git-send-email-jgq516@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jgq516@gmail.com
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--Sig_/T19rusBSDZDie55z1Szw5HJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Mar 2015 10:40:30 +0800 jgq516@gmail.com wrote:

> From: Guoqing Jiang <gqjiang@suse.com>
>=20
> The bm_blocks is modified by commit fe60ce (md/bitmap: use
> sector_div for sector_t divisions), but it makes bm_blocks
> has different value which is changed from like "a/b" to "a%b",
> need to correct this to make sure cluster-md still works.

One of us is confused here.

This code is trying to find the start of the bitmap relevant to this host in
a table of multiple bitmaps.  So it first needs to find out the size of each
bitmap.  It then multiples the size by the index number of this host to get
an offset.

So it take the total number of sectors (resync_max_sectors), divides by the
chunksize (in sectors) to get a number of chunks.  This is the number of bi=
ts.

Then it should div-round-up by 8 to get a number of bytes.
Then div-round-up by 4096 to get number of 4-K blocks, because the bitmaps
are always 4K aligned.

Then this number is multiplied by 8 (or shifted by 3) to get a number of
sectors to add to the start of the table.

So the original code in commit b97e92574c0bf335db1cd2ec491d8ff5cd5d0b49
is wrong because it uses sector_div in a way which destroys
resync_max_sectors.
And is wrong because it multiplies by 8 (<<3) instead of divides by 8 to
convert from bits to bytes.

commit f9209a323547f054c7439a3bf67c45e64a054bd
removes the abuse of sector_div, which is good, but uses a simple "a/b"
division, which isn't allowed in the kernel.

commit fe60ce80488a2a481ac175c4ff98f90df22e1e46
then does the right thing with sector_div, but the "<< 3" is still the wrong
way around.

If you still think your code is correct, please explain in detail why.

Goldwyn: if you agree that "<< 3" should be ">> 3" or even
DIV_ROUND_UP_SECTOR_T( , 8);
please send a patch.  If you don't think so, please explain why.

Thanks,
NeilBrown



>=20
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
> This is against for-next branch.
>=20
>  drivers/md/bitmap.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 501f83f..ea9c685 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -571,11 +571,10 @@ static int bitmap_read_sb(struct bitmap *bitmap)
>  re_read:
>  	/* If cluster_slot is set, the cluster is setup */
>  	if (bitmap->cluster_slot >=3D 0) {
> -		sector_t bm_blocks;
> -		sector_t resync_sectors =3D bitmap->mddev->resync_max_sectors;
> +		sector_t bm_blocks =3D bitmap->mddev->resync_max_sectors;
> =20
> -		bm_blocks =3D sector_div(resync_sectors,
> -				       bitmap->mddev->bitmap_info.chunksize >> 9);
> +		sector_div(bm_blocks,
> +				bitmap->mddev->bitmap_info.chunksize >> 9);
>  		bm_blocks =3D bm_blocks << 3;
>  		bm_blocks =3D DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
>  		bitmap->mddev->bitmap_info.offset +=3D bitmap->cluster_slot * (bm_bloc=
ks << 3);


--Sig_/T19rusBSDZDie55z1Szw5HJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQixSDnsnt1WYoG5AQJ6pA/+OChsZETmIxZqFbQnRUDaxjHJ/aN6t1iO
Ms0+85IHOKhVjQgKij7kgiQqLbOFgzqYlP8kEe2Fz/bsAb7zzbvIqAsbJceCimlB
VuZ1wEPQ4QUYvqTt3Mqm7y28T3sehFOrqWHl+78Epq3CRTpnnRwYbOM97U/e2BwH
faGAkCP48L5YkQP0/CwTCsnziZAzaMgwqVi6ZQf0NYNWHaI83AdgQk3ZlqWTnX+R
ngb/fU4dBneE4DWAl4Mu4mR20WBNOYUI05Cqq6gmWcB4RdPo58IKDiNCWXPsuw7K
NjvZKkSTKP95vwErxVM5bkCGn2xeEYyvB3s402WAz5W21IDlbjNimIY5slcPBxhk
RxBN+92nBRQATPCM3RRuGK8aqUMiyypSfMBzxKW44RhQoZLBbdVapuMAVeWMEwid
EPQA9yFZjNai+uM3VNxWzs+6+Udg2jxrMfPpGjmzRcS53cvRrFrOPt2ezX5VkjXN
Um1R1fhcGXx8AQf9yrLKM4HxjuQqFFP4Gn7UC0RAPWNTB278uxaGQICK+52DeReI
GD5PqUaRFBvx74/5pLetzo4FWPdpan/eDzZGGf1jSft1CNz4ojoVi0VngxhjqI2r
SxJXmQ7mAplug2+xMYAgltVHE2QTcrTE1+0MfprQSIrlSrUYicid/i52B7GUuhWL
j7bmVcOkjcQ=
=eRlK
-----END PGP SIGNATURE-----

--Sig_/T19rusBSDZDie55z1Szw5HJ--
