From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 008 of 29] md: Close race in md_probe
Date: Fri, 27 Jun 2008 14:21:53 +0200
Message-ID: <20080627122153.GE4981@skl-net.de>
References: <20080627164503.9671.patches@notabene> <1080627065010.10418@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1080627065010.10418@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16:50, NeilBrown wrote:
>=20
> There is a possible race in md_probe.  If two threads call md_probe
> for the same device, then one could exit (having checked that
> ->gendisk exists) before the other has called kobject_init_and_add,
> thus returning an incomplete kobj which will cause problems when
> we try to add children to it.
>=20
> So extend the range of protection of disks_mutex slightly to
> avoid this possibility.
>=20
> Signed-off-by: Neil Brown <neilb@suse.de>
>=20
> ### Diffstat output
>  ./drivers/md/md.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff .prev/drivers/md/md.c ./drivers/md/md.c
> --- .prev/drivers/md/md.c	2008-06-27 15:31:27.000000000 +1000
> +++ ./drivers/md/md.c	2008-06-27 15:31:35.000000000 +1000
> @@ -3359,9 +3359,9 @@ static struct kobject *md_probe(dev_t de
>  	disk->queue =3D mddev->queue;
>  	add_disk(disk);
>  	mddev->gendisk =3D disk;
> -	mutex_unlock(&disks_mutex);
>  	error =3D kobject_init_and_add(&mddev->kobj, &md_ktype, &disk->dev.kobj,
>  				     "%s", "md");
> +	mutex_unlock(&disks_mutex);
>  	if (error)
>  		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
>  		       disk->disk_name);

Even with this patch, md_probe() calls mddev_find() without holding
the disks_mutex. Is this OK? If it isn't, something like the patch
below might be necessary.

Andre
---

=46rom: Andre Noll <maan@systemlinux.org>

Fix possible race in md_probe().

The current code calls mddev_find() without any locks held.  It might
happen that mddev_find() succeeds but the returned mddev pointer
becomes stale just before the disks_mutex is aquired.

So close the race by calling mddev_find() with the disks mutex held.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 647395b..6cb8773 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3184,17 +3184,20 @@ static int mdp_major;
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
 {
 	static DEFINE_MUTEX(disks_mutex);
-	mddev_t *mddev =3D mddev_find(dev);
+	mddev_t *mddev;
 	struct gendisk *disk;
 	int partitioned =3D (MAJOR(dev) !=3D MD_MAJOR);
 	int shift =3D partitioned ? MdpMinorShift : 0;
 	int unit =3D MINOR(dev) >> shift;
 	int error;
=20
-	if (!mddev)
-		return NULL;
=20
 	mutex_lock(&disks_mutex);
+	mddev =3D mddev_find(dev);
+	if (!mddev) {
+		mutex_unlock(&disks_mutex);
+		return NULL;
+	}
 	if (mddev->gendisk) {
 		mutex_unlock(&disks_mutex);
 		mddev_put(mddev);

--=20
The only person who always got his work done by Friday was Robinson Crusoe

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIZNthWto1QDEAkw8RAqv6AKCOwjmbFN+XXnLpD1KwTVsPjIBC1ACdGfDE
SF/X6Eje6x+Diuh2Z1R1mN8=
=+kWj
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
