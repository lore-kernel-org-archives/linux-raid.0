From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] Avoid OOPS when reshaping raid1 to raid0
Date: Mon, 26 Mar 2012 09:29:05 +1100
Message-ID: <20120326092905.27147102@notabene.brown>
References: <1332432953-30091-1-git-send-email-Jes.Sorensen@redhat.com>
	<1332432953-30091-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QYSh8z_M_THJzvFpRmBxoZX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332432953-30091-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QYSh8z_M_THJzvFpRmBxoZX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Mar 2012 17:15:53 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> raid1 arrays do not have the notion of chunk size. Set the existing
> chunk size of the new raid0 to the same as the proposed new chunk size
> to avoid a divide by zero OOPS when aligning the size of the new array
> to that of the chunk size.

This oops happens in create_strip_zones at

		sector_div(sectors, mddev->chunk_sectors);

correct?

>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/md/raid0.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 6f31f55..dff8d6b 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -639,6 +639,14 @@ static void *raid0_takeover_raid1(struct mddev *mdde=
v)
>  	mddev->new_level =3D 0;
>  	mddev->new_layout =3D 0;
>  	mddev->new_chunk_sectors =3D 128; /* by default set chunk size to 64k */
> +	mddev->chunk_sectors =3D 128;	/*
> +					 * a raid1 one doesn't have the
> +					 * notion of chunk size, so set
> +					 * existing chunk_sector to match the
> +					 * new size to avoid divide by zero
> +					 * when aligning the size of the new
> +					 * raid0 to the existing chunk size.
> +					 */

But what if the RAID1 is not a multiple of 64K ?  Then you will lose
data.

We probably want the same thing we have in RAID5:



	chunksect =3D 64*2; /* 64K by default */

	/* The array must be an exact multiple of chunksize */
	while (chunksect && (mddev->array_sectors & (chunksect-1)))
		chunksect >>=3D 1;

	if ((chunksect<<9) < STRIPE_SIZE)
		/* array size does not allow a suitable chunk size */
		return ERR_PTR(-EINVAL);


??

Do you want to make a patch, or shall I?

Ofcouse, RAID0 have have non-power-of-2 chunk sizes, so we could just hunt
for a small factor... probably not worth it though.


Thanks,
NeilBrown

--Sig_/QYSh8z_M_THJzvFpRmBxoZX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2+cMTnsnt1WYoG5AQKOPA//Vl9gjHaZ1iy5hLL+y7QGKLDwBVPWQ24Z
6uhPgnqVdjFzNFviuj/kjWYb11Ofp9DSbOEGbxQv+/jtKhF/k7vp8EdhSV5VotdA
bg9YTT16T45vtEbG9xZW4/M3lt7chYGMv6xoyFIRam1BpjiCDPq2eV6BqNZkVhkx
7WPpszw0Z5jqv8vDfTdjdKLMF/ers+lKpE1IPUNQrI3Q+7hWbDQcz0sn7yQOQqf+
KO/ss5yl494Tq+rYk5pBPfWQIPK0ABEtrJLer3SRGChhdugrMyKwQAmBP4uAHJdu
AOpd7lxd6G3bMuoJiZ9YMoQEYNy1sOTWTYwCA0CX6ZQULo2RWpi1/xoU6AA7O8JN
cB2l21fWLYzcY6g7pQYcrL/7jcmFbI8RhU/qMgowg2l9PR+U0mYvGMDGCi8UVRAk
bV/YGyPMLWEzY8YDOj+wcV5fclQs9wfnOeHzGILDN3by5EPeaaaRcLjFeGUxZW+N
kOi6R3CTp9pe4m0tuwpnxiZbS0q6izpfMDPRcyJ4XuWxpCr9F2xOzB4tcc3UYKHs
zMLy0q9dTLF7xVhtiHQeIZYtabmlqg/qw0b2Dv23GbfJbNGot5lvqSsg9fsfOUzz
q8nCEcYTC2SFq9nLm6r2+6pqGPT4v2ZI9f9jEu3Cd6fkxDsf/iU9kfjYngXiC5yi
4haaOvp4/sQ=
=I6Gx
-----END PGP SIGNATURE-----

--Sig_/QYSh8z_M_THJzvFpRmBxoZX--
