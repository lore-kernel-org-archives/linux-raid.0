From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD RAID10: Fix oops when creating RAID10 arrays via
 dm-raid.c
Date: Mon, 29 Oct 2012 09:40:46 +1100
Message-ID: <20121029094046.04090cbe@notabene.brown>
References: <1351145870.20327.2.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/S3pYRu+gBh_Wt_Tqq_tw06s"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1351145870.20327.2.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/S3pYRu+gBh_Wt_Tqq_tw06s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Oct 2012 01:17:50 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Commit 2863b9eb didn't take into account the changes to add TRIM support =
to
> RAID10 (commit 532a2a3fb).  That is, when using dm-raid.c to create the
> RAID10 arrays, there is no mddev->gendisk or mddev->queue.  The code added
> to support TRIM simply assumes that mddev->queue is available without
> checking.  The result is an oops any time dm-raid.c attempts to create a
> RAID10 device.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/raid10.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/raid10.c
> +++ linux-upstream/drivers/md/raid10.c
> @@ -1783,7 +1783,7 @@ static int raid10_add_disk(struct mddev
>  		clear_bit(Unmerged, &rdev->flags);
>  	}
>  	md_integrity_add_rdev(rdev, mddev);
> -	if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
> +	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
>  		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
> =20
>  	print_conf(conf);
> @@ -3613,11 +3613,14 @@ static int run(struct mddev *mddev)
>  			discard_supported =3D true;
>  	}
> =20
> -	if (discard_supported)
> -		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
> -	else
> -		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
> -
> +	if (mddev->queue) {
> +		if (discard_supported)
> +			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
> +						mddev->queue);
> +		else
> +			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD,
> +						  mddev->queue);
> +	}
>  	/* need to check that every block has at least one working mirror */
>  	if (!enough(conf, -1)) {
>  		printk(KERN_ERR "md/raid10:%s: not enough operational mirrors.\n",
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied, thanks.

NeilBrown

--Sig_/S3pYRu+gBh_Wt_Tqq_tw06s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI20bjnsnt1WYoG5AQLTQxAAmRlKeTMDuxm7TiccYlqdgM56IyHsyPsb
zujkAEAdvaPQMMwk8NUG2EJu2wk1yp0UyhXmoQngAiRoCmH0BvM7lkys5mCSsIWu
mhXASYQ7PRymHSt4W02XQ6uMAglUK7Zcbg+0GaHSUEAkkDi2Y4aKoxMoon99lPhp
gsFJexLdv90KUCwJ4elVLjyqfJPliDXmRwaHAnaP9F5Xvuz9rP6fy9ra+GTAzv+O
euMgaobykX6vor9oLA2ZVyM5MMffMYRqdGTCTFtaYoO/ycXU3Bl0qhRJeyTrZMJO
wMtydzL29zFxryAeXz74ypEk/dHOpDhAzKcV0/idiNNtrVjEzNiyV86xVAhZ2f+H
jx0Yva+WNiYbKPDapOsdOJi5llNPIivZkql6kSIwAsCUhc2gw+U4mvauwvfq1H54
jcaJhSIaLEKbV4fLXaZEUh928cLBSSzlweFA8CLPmUl4IFnEvKWhrKLMm53yPZuH
usnO9MzQQvf3Y+fkLFkLTnDcCf2tbze7wZfWEenolPrDVTTTF5LaFs9lbPys3foe
51YKa/VSLWKROtfBvOBDnjaDikFi4w8FUwrRbdqf3FtyFRGZUuTgwnmf4pYVq3vX
O1N1QM2cou3heawA2G83BP1mB2tVGZuwOQ+r70jGheBAO6jyDW8f01ik7KFRagjH
cRZYrRlQ9s0=
=btj+
-----END PGP SIGNATURE-----

--Sig_/S3pYRu+gBh_Wt_Tqq_tw06s--
