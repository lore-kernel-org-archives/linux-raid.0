From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: Add ability for disable bad block management
Date: Thu, 8 Dec 2011 15:02:22 +1100
Message-ID: <20111208150222.2ce2ac16@notabene.brown>
References: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
	<20111130111403.7efd3875@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A054C28@IRSMSX101.ger.corp.intel.com>
	<20111206170525.1f4e32ab@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A055919@IRSMSX101.ger.corp.intel.com>
	<20111207125255.51382e59@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A055D88@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mvqUougFmUL4lSREJWlDZKC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A055D88@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/mvqUougFmUL4lSREJWlDZKC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Dec 2011 11:10:06 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]

> > I cannot reproduce this.
> > I didn't physically remove devices, but I used
> >    echo 1 > /sys/block/sdc/device/delete
> > which should be nearly identical from the perspective of md and mdadm.
>=20
> I've checked that when I'm deleting device using sysfs  everything works =
perfect.=20
> When when device is pulled out, reshape stops in md/mdstat.
>=20
> > If you could give me the exact set of steps that you follow to produce =
the
> > problem that would help - maybe a script?  Just a description is OK.
>=20
>=20
> #used disks sdb, sdc, sdd, sde
> export IMSM_NO_PLATFORM=3D1
> #create container
> mdadm -C /dev/md/imsm0 -amd -e imsm -n 3 /dev/sdb /dev/sdc /dev/sde -R
> #create vol
> mdadm -C /dev/md/raid5vol_0 -amd -l 5 --chunk 32 --size 104850 -n 3 /dev/=
sdb /dev/sdc /dev/sde -R
> #add spare
> mdadm --add /dev/md/imsm0 /dev/sdd
> #run OLCE
> mdadm --grow /dev/md/imsm0 --raid-devices 4
> #when reshape starts, I'm (physically) pulling device out
>=20
> > Also you say it is blocking in md_do_sync.  Is that at the
> >=20
> > 	wait_event(mddev->recovery_wait, !atomic_read(&mddev-
> > >recovery_active));
> >=20
> > call just after the "out:" label?
>=20
> None of those 2 places.
> It enters sync_request() function. Md_error() is called.=20
> More is visible on thread stack information below (md_wait_for_blocked_rd=
ev()).
>=20
>=20
> >=20
> > What is the raid thread doing at this point?
> >    cat /proc/PID/stack
> > might help.
>=20
> [md126_raid5]
> [<ffffffff8121d843>] md_wait_for_blocked_rdev+0xbc/0x10f
> [<ffffffffa01d87ce>] handle_stripe+0x1c5c/0x2c99 [raid456]
> [<ffffffffa01d9d0d>] raid5d+0x502/0x564 [raid456]
> [<ffffffff8121eca5>] md_thread+0x101/0x11f
> [<ffffffff81049e0e>] kthread+0x81/0x89
> [<ffffffff812cc4f4>] kernel_thread_helper+0x4/0x10
> [<ffffffffffffffff>] 0xffffffffffffffff
>=20
> [md126_reshape]
> [<ffffffffa02455a2>] sync_request+0x90a/0xbfb [raid456]
> [<ffffffff8121e151>] md_do_sync+0x7aa/0xc40
> [<ffffffff8121ecb3>] md_thread+0x101/0x11f
> [<ffffffff81049e0e>] kthread+0x81/0x89
> [<ffffffff812cc4f4>] kernel_thread_helper+0x4/0x10
> [<ffffffffffffffff>] 0xffffffffffffffff
>=20
> >=20
> > What are the contents of all the sysfs files?
> >    grep . /sys/block/mdXXX/md/*
> array_state		->active
> degraded		->1
> max_read_errors	->20
> reshape_position	->12288
> resync_start		->none
> sync_completed	->4096 / 209664
>=20
>=20
> >    grep . /sys/block/mdXXX/md/dev-*/*
>=20
> When removed is sdd   /sys/block/mdXXX/md/dev-sdd/*
> bad_blocks		->4096 512
> 			->4608 128
> 			->4736 384
> block			->MISSING link is not valid
> errors			->0
> offset			->0
> recovery_start		->4096
> size			->104832
> slot			->3
> state			->faulty,write_error
> unacknowledged_bad_blocks	->4096 512
> 				->4608 128
> 				->4736 384
>=20
> I hope this helps.

Yes it does, thanks.

Can you try with this patch as well please.

Thanks,
NeilBrown


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ea6dce9..6cf0f6a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3175,6 +3175,8 @@ static void analyse_stripe(struct stripe_head *sh, st=
ruct stripe_head_state *s)
 			rdev =3D rcu_dereference(conf->disks[i].rdev);
 			clear_bit(R5_ReadRepl, &dev->flags);
 		}
+		if (rdev && test_bit(Faulty, &rdev->flags))
+			rdev =3D NULL;
 		if (rdev) {
 			is_bad =3D is_badblock(rdev, sh->sector, STRIPE_SECTORS,
 					     &first_bad, &bad_sectors);


--Sig_/mvqUougFmUL4lSREJWlDZKC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuA2zjnsnt1WYoG5AQJPKA/9FqHnGaJZZvHXQ8L54P6Gy4BIRzmWLuO5
s3NtGcZ5UB06aO9U4gqankdXWnM32Syo+rIIMKT9tsH5P59BSiPqszm0qcXqPVJX
nQ+vL7LFyKoF52zkaFK4IvXKXES+h9n8ASNDFFUAnAozWJ5ZW7eqALXGXJQpDZKX
aYrEpD1r+6LfkqtQadhriY/T8knaswV5LEld2vV/4/BJ2nJyvtFwhm3M0Jokm/Er
2uEbZ/05OffA2C3Q14zbNc6kjwWMK0ncOfrJBj0dCD40PafM/9oqU4ZbIHTSJ1qW
Olq8fcVxmtjk8QcOSZPl3ZC4I2P8rtUson5kCIigQ7rN8NyjD+XQO1gHV7YwZjM8
Q18HBFQToVEd3Uo5xi6WRRXJRuwI/NQD7UqEy7aaovrffapxIxUzErdos9I2LWls
VHN4CPP7itk0Ksc+QqCyzLpBLP+hEcdHD5E4h6FKsNp9Fy2JizfRqScvrpzy5JyM
GDdjgiJKiNLaRY7Bmiact+Q42OdSbb52WUDEQiVOsK0r78TsJw+1vFSkZoKdPKN1
dox9sTAzIPOVen16Ttdib8e7Eo/MQ2qsS6wbJ/+KNzhsWFXz1aYYlKwkPBZsCLPS
XQ4KSdZVDgRAUtWJC7ODPeDYryV7yxqZ/Ym/IsC9hK7R0GrI+DqdeA9O0rKu/CWX
+yKB5ASllkE=
=u9ik
-----END PGP SIGNATURE-----

--Sig_/mvqUougFmUL4lSREJWlDZKC--
