From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: remove unused variables
Date: Tue, 17 Apr 2012 16:36:21 +1000
Message-ID: <20120417163621.62c413e4@notabene.brown>
References: <4F8CFB06.4090908@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jiDH1LuMWbAfIBHv/dGg35q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8CFB06.4090908@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/jiDH1LuMWbAfIBHv/dGg35q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Apr 2012 13:09:26 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> The two variables are useless.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>   drivers/md/raid5.c |    4 ----
>   1 file changed, 4 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-04-17 11:56:16.606009690 +0800
> +++ linux/drivers/md/raid5.c	2012-04-17 11:57:47.026009295 +0800
> @@ -3953,12 +3953,10 @@ static void make_request(struct mddev *m
>   	plugged =3D mddev_check_plugged(mddev);
>   	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS=
) {
>   		DEFINE_WAIT(w);
> -		int disks, data_disks;
>   		int previous;
>=20
>   	retry:
>   		previous =3D 0;
> -		disks =3D conf->raid_disks;
>   		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
>   		if (unlikely(conf->reshape_progress !=3D MaxSector)) {
>   			/* spinlock is needed as reshape_progress may be
> @@ -3973,7 +3971,6 @@ static void make_request(struct mddev *m
>   			if (mddev->delta_disks < 0
>   			    ? logical_sector < conf->reshape_progress
>   			    : logical_sector >=3D conf->reshape_progress) {
> -				disks =3D conf->previous_raid_disks;
>   				previous =3D 1;
>   			} else {
>   				if (mddev->delta_disks < 0
> @@ -3986,7 +3983,6 @@ static void make_request(struct mddev *m
>   			}
>   			spin_unlock_irq(&conf->device_lock);
>   		}
> -		data_disks =3D disks - conf->max_degraded;
>=20
>   		new_sector =3D raid5_compute_sector(conf, logical_sector,
>   						  previous,


applied, thanks.

NeilBrown

--Sig_/jiDH1LuMWbAfIBHv/dGg35q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT40PZTnsnt1WYoG5AQIapw/9HhwXJJ+KBDr1j3rndjxZYyu0Awk516/r
DVx4SnkFAlrsjVBUeOQWg40DH/GmDlSnOog61nQc/yCp0P88EIFEHwEngPqQZ4Gn
JW7ZDb6GUCZfMkREMpnu+6PCqxap9h+MLTlbZ4g3M8ubYILjkfxxzVvlBKiGNN5k
jR/jA7IsLT6MIYaCIyMaYDIGxdov30HQ7R0m9GqVVLGUYN/YgZFSCnnDk3HVqO/k
31UCiEVDhaoEVHyrFg8nTTAarx21m1c/lZ/SkWhEI/HBAf5OVeDobCFNTBpmXtzH
38nP4ilvln6HbsnBsco7OnZdMYFNxLStDzWqHN3NHmQ17O1RmYr2CldCGCf8L3Tc
kX2bGMKU2cTYAIBJA22H9DrYUb0sqHHm+fe9ANWCtdFnTegHelx1i1EtbvoIAdBc
4vFcpp9NVY8bAzGP5zo4vFOFvQn/yDd1zGFuEinI5z6VLpZ+UtvQo4evfIbJEnEm
E8E4I2bdwcZYTyE3p/ofmzc/uYWsJqxrd/iZcipT22baT4MofZcLuuB1SPLJISac
t1AQQkSOrUWTZw7WUXuBLPywMY3ydWMAEfu9d+czUM+P1GCIWHQOPpmnfcno0jV6
BBGXVA5TdL6TApcdusnDmkFES2qOEf7F9tvJlECX4Q4wzV9Ju+smyrZXJYNJfAO5
+ruBiyHfcoc=
=tuZb
-----END PGP SIGNATURE-----

--Sig_/jiDH1LuMWbAfIBHv/dGg35q--
