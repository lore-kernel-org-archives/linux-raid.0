From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH V2] MD: fix info output for journal disk
Date: Wed, 14 Oct 2015 07:50:22 +1100
Message-ID: <87bnc2ze5t.fsf@notabene.neil.brown.name>
References: <6e6d9cd5bc79883cfb22a62b9bdc98b161aad301.1444694209.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6e6d9cd5bc79883cfb22a62b9bdc98b161aad301.1444694209.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> journal disk can be faulty. The Journal and Faulty aren't exclusive with
> each other.
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0729cc7..f1114a6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5857,7 +5857,8 @@ static int get_disk_info(struct mddev *mddev, void =
__user * arg)
>  		else if (test_bit(In_sync, &rdev->flags)) {
>  			info.state |=3D (1<<MD_DISK_ACTIVE);
>  			info.state |=3D (1<<MD_DISK_SYNC);
> -		} else if (test_bit(Journal, &rdev->flags))
> +		}
> +		if (test_bit(Journal, &rdev->flags))
>  			info.state |=3D (1<<MD_DISK_JOURNAL);
>  		if (test_bit(WriteMostly, &rdev->flags))
>  			info.state |=3D (1<<MD_DISK_WRITEMOSTLY);
> @@ -7339,14 +7340,12 @@ static int md_seq_show(struct seq_file *seq, void=
 *v)
>  				bdevname(rdev->bdev,b), rdev->desc_nr);
>  			if (test_bit(WriteMostly, &rdev->flags))
>  				seq_printf(seq, "(W)");
> +			if (test_bit(Journal, &rdev->flags))
> +				seq_printf(seq, "(J)");
>  			if (test_bit(Faulty, &rdev->flags)) {
>  				seq_printf(seq, "(F)");
>  				continue;
>  			}
> -			if (test_bit(Journal, &rdev->flags)) {
> -				seq_printf(seq, "(J)");
> -				continue;
> -			}
>  			if (rdev->raid_disk < 0)
>  				seq_printf(seq, "(S)"); /* spare */
>  			if (test_bit(Replacement, &rdev->flags))
> --=20
> 2.4.6

Applied, thanks.
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWHW6OAAoJEDnsnt1WYoG5HSUQAKWvt5XYUKnmhjSvMf1sZn6Z
21dJoL54dSGBgrr1coOI9t4malSW+/Ohqi2b4UE1BuSl+3QWUrzSfN7OCvr0Z88q
bh7wujsSeTv2lXcrzGNKYMRJ5JNC++FTs9Et2252aRUcQKpJrRf1CG5oJG38LUQF
duTjnFNp7gSbxb1QB1zHxGvljotZuuV9N3XczevMwqsUfv6LwHX1wM8MiH5PPE/e
XESGbL35BEPbEPixjvj145ll8pG+aS4v+7uq5b6Lrj0lwb8kgH3tn2FpdgoFWv1S
CIEirVfNgR+C9vZ4mG3Ato61PwzaptfG4/UEqLVkxN4gaSiPJD5GTfW8YcQTNx/F
9xwuxbdvu1/WLWFLGER+OJZuD5kXrSNFzFt2Un1va6wheJnKv1lHzHHc5hui+dO5
7wmom6bh0Q0TxJUSXLHKCkmEx95uLY2stgJvpo7JLxVAGPguJLGz8sWoOG7U3DDe
1AluaRB4NYWXuzoqILe+Mz2CkNgLPawjbC0qdCh8Oy7BVzBsfPEhEmWhJj+eZWCG
+gPXpMbn/9eamJgrJKNug+usMVz/s59Ecja3OP/ckBzC4fNdpk1t/c2TzX7H/UEf
G+uq9WLSMEVf3O+7SgZQ6n/0iDeIIb82HrrcKuxWdIfnR/+/YydsukAHFKjz741G
hAmyER1scW2i1V51Ilj1
=kaEW
-----END PGP SIGNATURE-----
--=-=-=--
