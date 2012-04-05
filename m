From: NeilBrown <neilb@suse.de>
Subject: Re: doubt in chunk_aligned_read()
Date: Thu, 5 Apr 2012 11:38:00 +1000
Message-ID: <20120405113800.4a1da21e@notabene.brown>
References: <CANSbrrp_LByxog3q265ruHxJxxJRhE2SfvPgzx8EK4FyL-7KOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GbMf62lu/7W455rwILggDl8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANSbrrp_LByxog3q265ruHxJxxJRhE2SfvPgzx8EK4FyL-7KOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anuj Goel <talk2anuj@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/GbMf62lu/7W455rwILggDl8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Apr 2012 21:25:53 -0400 Anuj Goel <talk2anuj@gmail.com> wrote:

> HI Guys,
>=20
> Why is the below call needed in the function  chunk_aligned_read()
>=20
> 	align_bi =3D bio_clone_mddev(raid_bio, GFP_NOIO, mddev);
>=20
> Why do we need to create a clone of the bio passed to
> chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio) ??

Think about what happens if the read fails.

NeilBrown


>=20
> --
> Best Regards,
> Anuj Goel
> Experimental Computer Science Lab
> Stony Brook University.
> Cell: +1-801-209-5873
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/GbMf62lu/7W455rwILggDl8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3z3eDnsnt1WYoG5AQJ+lw//Va9rT7YJYLd6MXTsb2NQrZlVAACADVqC
kHw5qKlSmcw2rGQ55cMyGdFpkQrkAy3apgRdnl7EfGi47LU7Mgn7r43hsBd2wK+i
sD0I0tS987qKLZjTFCc9Q+y94EMO1YC3w32Zgb3bsXwzMZwI600DOJnzFPxYz3IG
kQel63PZtFCy+PCyeaMx+B4CLKj62n0UOOiJzI1MPH5SN3JnNZW2X1/PgomZvrDO
yhY+F4sFAZtRTD7isq3whn8l0lJvmiFAMhLeaoDlYdq9D3geLoPFV/ROx20mrGNO
xbDIgoGwjGsS9JTfKE1IuZXs6lI6mVJrcBL56ybEak4DENefBeIOaG9BaGUhZZYM
M1yTZyDHwsaTe1b5XTzbSgyg5mzO2Qu+2cij66aVYy6rS86T7cJ9JHRC0UxuyaA8
/eBvKuybZeDaCabk3KEnUbOrEHqfUqEkQyVUdYGUntrkigxCZ9TQH0/yfu7+t4y4
0vqX+EsIpyc93nYuGq7AsPtngkvkg3dYujFbsUsVFIclqkahYygQdUuRpZgL0bWp
LJDUoBqEG11OUaRzL1zhQMdYUYdafFWpc4qdRcZDwOoc0VkaNWmsVbvfvnoqcuMV
UFFVLUwZmra0K9ELFvAopbB5kUQy4rLB3lgGvpemQh4QYfpZs+32I+cr2qPfH8XN
iVza5lQ5U5Q=
=Y9mj
-----END PGP SIGNATURE-----

--Sig_/GbMf62lu/7W455rwILggDl8--
