From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH] raid1: reset 'bi_next' before reuse the bio
Date: Wed, 05 Apr 2017 08:17:52 +1000
Message-ID: <87shlnizqn.fsf@notabene.neil.brown.name>
References: <dcd33b53-5c6f-3ebc-8c07-04f0c0372796@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dcd33b53-5c6f-3ebc-8c07-04f0c0372796@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>, linux-raid@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04 2017, Michael Wang wrote:

> During the testing we found the sync read bio can go through
> path:
>
>   md_do_sync()
>     sync_request()
>       generic_make_request()
>         blk_queue_bio()
>           blk_attempt_plug_merge()
>             bio->bi_next CHAINED HERE
>
>   ...
>
>   raid1d()
>     sync_request_write()
>       fix_sync_read_error()
>         if FailFast && Faulty
>           bio->bi_end_io =3D end_sync_write
>       generic_make_request()
>         BUG_ON(bio->bi_next)
>
> This need to meet the conditions:
>   * bio once merged
>   * read disk have FailFast enabled
>   * read disk is Faulty
>
> And since the block layer won't reset the 'bi_next' after bio
> is done inside request, we hit the BUG like that.
>
> This patch simply reset the bi_next before we reuse it.
>
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
> ---
>  drivers/md/raid1.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7d67235..0554110 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1986,11 +1986,13 @@ static int fix_sync_read_error(struct r1bio *r1_b=
io)
>  		/* Don't try recovering from here - just fail it
>  		 * ... unless it is the last working device of course */
>  		md_error(mddev, rdev);
> -		if (test_bit(Faulty, &rdev->flags))
> +		if (test_bit(Faulty, &rdev->flags)) {
>  			/* Don't try to read from here, but make sure
>  			 * put_buf does it's thing
>  			 */
>  			bio->bi_end_io =3D end_sync_write;
> +			bio->bi_next =3D NULL;
> +		}
>  	}
>=20=20
>  	while(sectors) {


Ah - I see what is happening now.  I was looking at the vanilla 4.4
code, which doesn't have the failfast changes.

I don't think your patch is correct though.  We really shouldn't be
re-using that bio, and setting bi_next to NULL just hides the bug.  It
doesn't fix it.
As the rdev is now Faulty, it doesn't make sense for
sync_request_write() to submit a write request to it.

Can you confirm that this works please.

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d2d8b8a5bd56..219f1e1f1d1d 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2180,6 +2180,8 @@ static void sync_request_write(struct mddev *mddev, s=
truct r1bio *r1_bio)
 		     (i =3D=3D r1_bio->read_disk ||
 		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
 			continue;
+		if (test_bit(Faulty, &conf->mirrors[i].rdev->flags))
+			continue;
=20
 		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
 		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags))


Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljkG5AACgkQOeye3VZi
gblpqhAAuEg7Ry99BVulP7lPvjA8Au8GG7oF13wnKVjCVf9p1swFoOErOZheeHWT
3w96x6cYZJUmug46zj5GDBTPSAXwQ4yh3oAJ6PHlfFvk3a4v7ytnMgdE6WBDFwgs
pcL2jfnPYq4o2f4RByH02PNGzzBsyWvycfkG+z4Yhcq8zgRnZDVRNdmKzOrWuD2M
LambiNgdqJ/xtqu2VQIUV+elyfha9L0HvbqZR/tlt3lpxRFK7dR9adA8vcfuR+rf
Mn9vdLdBBJBv7vEqP9lpjO8VaPItWx8adzM1nsWnB8gPnZlkuCZw0fGsSqg1Hdka
C86H3pcu9gkVTYZjdOD9KpTGqyOlsFXuWgL1HRUjGjcNjDE+SlRHA6exa1SsN0yD
fAmw95VY3N+fA1ytE4G9xDrxgebibxn2dtD8lJWxqTU8MT2/aRdmbLGuyoCSEJC1
esRbcz8CWF+8bG0DNumzB1x4MI72EZQ+Y10rAbM1R3IT4ZiadHEzkWGyndaj4YL5
vM751AwOETBNuL95+zJv9Ozm09571Hl1xP8xYcfBLy3Si9DLpGQ2CDEVboh/KmXA
6qQ4d91ZCRCEetdbx7UwXwD7cd07wUCjSBQKax9HvxP0okKrHi1S+XUSMDybMOnN
KXBUZZHqyH2Ac5uPGQKF3z7BiXmt0mTWn+VHeyax+F7MKWN9qT8=
=oazj
-----END PGP SIGNATURE-----
--=-=-=--
