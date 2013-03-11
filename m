From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Prevent sysfs operations on uninitialized kobjects
Date: Mon, 11 Mar 2013 11:35:22 +1100
Message-ID: <20130311113522.71dd6435@notabene.brown>
References: <1362695066.28152.7.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/x.Ekv1de=1DVpJdsZc/VXaR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362695066.28152.7.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/x.Ekv1de=1DVpJdsZc/VXaR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Mar 2013 16:24:26 -0600 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> MD: Prevent sysfs operations on uninitialized kobjects
>=20
> Device-mapper does not use sysfs; but when device-mapper is leveraging
> MD's RAID personalities, MD sometimes attempts to update sysfs.  This
> patch adds checks for 'mddev-kobj.sd' in sysfs_[un]link_rdev to ensure
> it is about to operate on something valid.  This patch also checks for
> 'mddev->kobj.sd' before calling 'sysfs_notify' in 'remove_and_add_spares'.
> Although 'sysfs_notify' already makes this check, doing so in
> 'remove_and_add_spares' prevents an additional mutex operation.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/md.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/md.h
> +++ linux-upstream/drivers/md/md.h
> @@ -506,7 +506,7 @@ static inline char * mdname (struct mdde
>  static inline int sysfs_link_rdev(struct mddev *mddev, struct md_rdev *r=
dev)
>  {
>  	char nm[20];
> -	if (!test_bit(Replacement, &rdev->flags)) {
> +	if (!test_bit(Replacement, &rdev->flags) && mddev->kobj.sd) {
>  		sprintf(nm, "rd%d", rdev->raid_disk);
>  		return sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
>  	} else
> @@ -516,7 +516,7 @@ static inline int sysfs_link_rdev(struct
>  static inline void sysfs_unlink_rdev(struct mddev *mddev, struct md_rdev=
 *rdev)
>  {
>  	char nm[20];
> -	if (!test_bit(Replacement, &rdev->flags)) {
> +	if (!test_bit(Replacement, &rdev->flags) && mddev->kobj.sd) {
>  		sprintf(nm, "rd%d", rdev->raid_disk);
>  		sysfs_remove_link(&mddev->kobj, nm);
>  	}
> Index: linux-upstream/drivers/md/md.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/md.c
> +++ linux-upstream/drivers/md/md.c
> @@ -7646,10 +7646,8 @@ static int remove_and_add_spares(struct
>  				removed++;
>  			}
>  		}
> -	if (removed)
> -		sysfs_notify(&mddev->kobj, NULL,
> -			     "degraded");
> -
> +	if (removed && mddev->kobj.sd)
> +		sysfs_notify(&mddev->kobj, NULL, "degraded");
> =20
>  	rdev_for_each(rdev, mddev) {
>  		if (rdev->raid_disk >=3D 0 &&
>=20


Applied, thanks.

NeilBrown

--Sig_/x.Ekv1de=1DVpJdsZc/VXaR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT0myjnsnt1WYoG5AQL7CBAAt3xEsDwKvzinlchfojhjjIJZueNuqNUp
cpGFrXv0iUExj9aoP7K2JAosjYO1Vc33d2JMqfusUq7B0h7R6DO5EBhR/vhUDIIK
8G/t4Y9joX4tthbyJZOxBva3Nw7o4sXl0Emjsozq33he3KLErhHs//v/IKIYwcYq
QuG9bkVyMvmDg4s1GrmzTNtSvU27VfHKAuEX4qxjJdRzeB+R+Y7TSOXeypcoj0Df
hz2hME3fL2B0d1U6gCxbHx5PkFf1Ac5PXJkW/jGMp512BozZSm3BeDq6/lGMJc2I
+Ls81rHA9iz00L+BsZpWejhd2YWjv/zokuuHHmETBk8CNe/jUjy5NVwO4ibKeczb
XHY657jKzNdMKqv5iti1Z/jQaMwrC2btkr6Ar9qroNznmi1OgsbpoDmpn7+0+5/U
y5Jsu5Lhw1OHzSMg062qX47LJZppSuflKRdHGXG7XkhfbsMF3ASVoG/MO4e8Rrv0
0nHeBhClTXss8bOJwDWoYy9gTkDJRR2kV1YGKXu71hC0YTBG6CrlErnnUTRhrzRA
ldnaSiWQABX3lFFo4Nh42uounNrnjXGJzGeUGIcCVkyjVcpitTw7wdom5kQZ9nC5
MQUrjzkzRQMsxoZyrjAF4N+JYaKm7ve/B6fToOPQxg8n4kREJNNhIkEQe73stceq
L7vHavUS9Ho=
=HC2T
-----END PGP SIGNATURE-----

--Sig_/x.Ekv1de=1DVpJdsZc/VXaR--
