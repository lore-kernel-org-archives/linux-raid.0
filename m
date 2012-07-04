From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3 v3] raid1: prevent merging too large request
Date: Wed, 4 Jul 2012 15:59:07 +1000
Message-ID: <20120704155907.560607d4@notabene.brown>
References: <20120702010840.197370335@kernel.org>
	<20120702011037.466764171@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+F1+KqgjjFzgeu.eY.vHetX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702011037.466764171@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/+F1+KqgjjFzgeu.eY.vHetX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Jul 2012 09:08:43 +0800 Shaohua Li <shli@kernel.org> wrote:

> For SSD, if request size exceeds specific value (optimal io size), reques=
t size
> isn't important for bandwidth. In such condition, if making request size =
bigger
> will cause some disks idle, the total throughput will actually drop. A go=
od
> example is doing a readahead in a two-disk raid1 setup.
>=20
> So when we should split big request? We absolutly don't want to split big
> request to very small requests. Even in SSD, big request transfer is more
> efficient. Below patch only consider request with size above optimal io s=
ize.
>=20
> If all disks are busy, is it worthy to do split? Say optimal io size is 1=
6k,
> two requests 32k and two disks. We can let each disk run one 32k request,=
 or
> split the requests to 4 16k requests and each disk runs two. It's hard to=
 say
> which case is better, depending on hardware.
>=20
> So only consider case where there are idle disks. For readahead, split is
> always better in this case. And in my test, below patch can improve > 30%
> thoughput. Hmm, not 100%, because disk isn't 100% busy.
>=20
> Such case can happen not just in readahead, for example, in directio. But=
 I
> suppose directio usually will have bigger IO depth and make all disks bus=
y, so
> I ignored it.
>=20
> Note: if the raid uses any hard disk, we don't prevent merging. That will=
 make
> performace worse.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid1.c |   46 ++++++++++++++++++++++++++++++++++++++--------
>  drivers/md/raid1.h |    1 +
>  2 files changed, 39 insertions(+), 8 deletions(-)
>=20
> Index: linux/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid1.c	2012-06-29 15:17:09.160691540 +0800
> +++ linux/drivers/md/raid1.c	2012-06-29 15:57:54.993943576 +0800
> @@ -489,6 +489,7 @@ static int read_balance(struct r1conf *c
>  	unsigned int min_pending;
>  	struct md_rdev *rdev;
>  	int choose_first;
> +	int choose_idle;
> =20
>  	rcu_read_lock();
>  	/*
> @@ -502,6 +503,7 @@ static int read_balance(struct r1conf *c
>  	best_dist =3D MaxSector;
>  	min_pending =3D -1;
>  	best_good_sectors =3D 0;
> +	choose_idle =3D 0;
> =20
>  	if (conf->mddev->recovery_cp < MaxSector &&
>  	    (this_sector + sectors >=3D conf->next_resync))
> @@ -580,16 +582,35 @@ static int read_balance(struct r1conf *c
>  		nonrot =3D blk_queue_nonrot(bdev_get_queue(rdev->bdev));
>  		pending =3D atomic_read(&rdev->nr_pending);
>  		dist =3D abs(this_sector - conf->mirrors[disk].head_position);
> -		if (choose_first
> -		    /* Don't change to another disk for sequential reads */
> -		    || conf->mirrors[disk].next_seq_sect =3D=3D this_sector
> -		    || dist =3D=3D 0
> -		    /* If device is idle, use it */
> -		    || pending =3D=3D 0) {
> -			best_disk =3D disk;
> -			break;
> +		if (choose_first)
> +			goto done;
> +		/* Don't change to another disk for sequential reads */
> +		if (conf->mirrors[disk].next_seq_sect =3D=3D this_sector
> +		    || dist =3D=3D 0) {
> +			int opt_iosize =3D bdev_io_opt(rdev->bdev) >> 9;
> +			struct mirror_info *mirror =3D &conf->mirrors[disk];
> +
> +			/*
> +			 * If buffered sequential IO size exceeds optimal
> +			 * iosize and there is idle disk, choose idle disk
> +			 */
> +			if (nonrot && opt_iosize > 0 && choose_idle =3D=3D 0 &&
> +			    mirror->seq_start !=3D MaxSector &&
> +			    mirror->next_seq_sect > opt_iosize &&
> +			    mirror->next_seq_sect - opt_iosize >=3D
> +			    mirror->seq_start) {
> +				choose_idle =3D 1;
> +				best_disk =3D disk;
> +				continue;
> +			}
> +			goto done;
>  		}
> +		/* If device is idle, use it */
> +		if (pending =3D=3D 0 && (!choose_idle || nonrot))
> +			goto done;

That doesn't make sense to me.
Ignoring the nonrot bit, it says:
   if (this device is idle, and we haven't decided to choose an idle device)
        then choose this device

which is wrong.

Also, what about the case where an idle device is found before we we find a
device that the sequentially-previous read was from.  Will that still do the
right thing?  It isn't clear.


And I don't really like the "goto done".  Just have
        best_disk =3D disk;
        break;

it isn't that much more code.


Thanks,
NeilBrown


> =20

--Sig_/+F1+KqgjjFzgeu.eY.vHetX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/Pbqznsnt1WYoG5AQKIXxAAliWXozWmPqW+wNv2WHlrC5g6mOPsGoO/
jOORgd0VfWtPtbmfE2ld36c0Ngo+8w9U3iY7HLcLLjLDAMgafKiENYA9SY4CGcX/
wdavmEagtscr6eXQaHjXU5e4RJb+o35VoKL9MKg1mVRBQV5Niqh4Sm5+MAX0lp7L
A7ABj99HVpM8kOUBc1x+4pEqkA34nqWT+6eGCLylNjBdNsqf1nxuqr3asiyIDR1H
mmaQn83eZ+KMtvsdEq3DDy5Vrlnih/TQvnQ4Sq832Q640s0T8JCL+p87I/HLAiXe
sINWsKOofjwAHtbmLbQgG36esaEepS7NWfFz+7alMzEqJzjll8D1GOrv+70LkRxZ
JPDzEyji3R3jw+fXiu642doxJUz2pjn2oCABE6NPO+eYJ6NhXIBp8boTL6ASpG6k
d95tUcl6sUwRuVKyNn8GKKduqFvFABe27bocfafnXj2ulL0939JjeBdWCQZv4FJq
0Q+ReDX1B8rDTXEZlNWPTevCGfXxv+5gog72EhYV3daT9Hth0OeBFiNVU6KergfT
dWUyn6IkJ2k3/pV8E8zlgbwX47Q34UiW088nDURJgW5ZrBJpFvV+V99pargpbKHL
FxbepdvxwmzkAZd7X0+80fm1bzTLEH7keoABYf2F1Em8ZgRyBq1Uijk2m5YfpXOz
Cyxg+90qDyg=
=rf+n
-----END PGP SIGNATURE-----

--Sig_/+F1+KqgjjFzgeu.eY.vHetX--
