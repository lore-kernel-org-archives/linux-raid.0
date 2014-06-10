From: NeilBrown <neilb@suse.de>
Subject: Re: Unable to re-assemble a raid 10 after it has FAILED.
Date: Tue, 10 Jun 2014 21:30:44 +1000
Message-ID: <20140610213044.4b6a7996@notabene.brown>
References: <CAEp9EKjgt1RTkYzhSX-UQN2-WhV3iCKPr_DTnHN_KmorvFNsvg@mail.gmail.com>
	<CAEp9EKg462T+7E35RnarP6y41wGgNv3R_jAXEhxiLBg_vukW3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=WarB1/s/bDAN__bW0_V42H"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEp9EKg462T+7E35RnarP6y41wGgNv3R_jAXEhxiLBg_vukW3g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Morell <amp4tj@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=WarB1/s/bDAN__bW0_V42H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jun 2014 13:04:28 +0200 Alberto Morell <amp4tj@gmail.com> wrote:

> Hi!
>=20
> I have a raid 10 devices with 4 components. I make the raid fails, by
> making two components fail (using "mdadm --set-faulty <device>"). When
> I add the two devices back, they are added as spare devices. Then, I
> can get the raid active again only creating the raid again using
> "mdadm --create --assume-clean...". Re-assembling the device does not
> work with error message:
>=20
> mdadm: failed to RUN_ARRAY /dev/md/hdd: Input/output error
> mdadm: Not enough devices to start the array.
>=20
> I am trying to automate the raid configuration and the "mdadm --create
> ..." option is not convenient as I would have to know all the creation
> parameters.
>=20
> Below is the command sequence.
>=20
> Thanks is advance,
>=20
> Alberto Morell.
>=20
>=20
> [root@os2 raid_tools]# mdadm --version
> mdadm - v3.2.6 - 25th October 2012
>=20
> [root@os2 ~]# mdadm --create /dev/md/hdd --metadata=3D1.0 --auto=3Dmd --n=
ame=3Dhdd \
> --chunk=3D256 --bitmap=3Dinternal --bitmap-chunk=3D65536 --level=3Draid10=
 --run \
> --raid-devices=3D4 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
>=20
> [root@os2 ~]# mdadm --set-faulty /dev/md/hdd /dev/sde1
> mdadm: set /dev/sde1 faulty in /dev/md/hdd
> [root@os2 ~]# mdadm --set-faulty /dev/md/hdd /dev/sdf1
> mdadm: set /dev/sdf1 faulty in /dev/md/hdd

So now your array is dead.  I assume you expected this.

>=20
> [root@os2 ~]# mdadm --remove /dev/md/hdd /dev/sde1
> mdadm: hot removed /dev/sde1 from /dev/md/hdd
> [root@os2 ~]# mdadm --remove /dev/md/hdd /dev/sdf1
> mdadm: hot removed /dev/sdf1 from /dev/md/hdd
> [root@os2 ~]# mdadm --add /dev/md/hdd /dev/sde1
> mdadm: re-added /dev/sde1
> [root@os2 ~]# mdadm --add /dev/md/hdd /dev/sdf1
> mdadm: re-added /dev/sdf1

Adding good things to dead things doesn't make the dead thing undead.
You don't want to do this.

If and array is dead, the best thing to do is to stop it, before trying to
re-add anything, and (after checking the all the devices are really working)
assemble with --force.
That is the best way to breath life into a dead array.

NeilBrown

--Sig_/=WarB1/s/bDAN__bW0_V42H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5bsZDnsnt1WYoG5AQLZrQ//Wz5zkndPNu2MCYYHyqHjrn1VsdwYN/+B
0DlRhGTrxLT9XAUgkoX3TRQQee2DxzOFDbx8Wwf1FZLdT4rrL/9RSM0r30MNKX6D
cNOwQ5lp4u0MwoXB6sV4acRIgD+PqQww5Q7Wws6cumngkB2Be8ERUAYfLq5vmmmq
/p5cLtSfPoNkf23W4cMAvQ1g+UVnJJ+6BC2OOTUAktnYageiRy4DGc+s0tbtCj/P
Um5MSGN4vv8P5qhAzd3rf0pjrQ5p7J2JOBO6ogKv1UHdJCibrNlK5/2g3xvU+hLw
AkhRz4s7ULltLm64Z5keRb5+Ea+aNwOLxm4liRO0EPliOr/LWIB+fXofc+3dhKVK
qDwixvqtrgv9XKgfGFflDSliFs7baLR/muCyATR0e8JfYsiwQ7ymFxcenN1ZQkUt
2IPhS3vYeXEOxZBUGG/2fLYALNvR05a47ZMHaxuoAZu8BgFdStG7bh3pC15p80PZ
yuKsr27phvjzRGDDzrl5yhI+jdp155fnUuCh3edIKq7fQ4I/7+bYL+f1yUc11zHk
PFrR1VZ4qDSkH33nyhXcRotqLCyr2pvGVEviy1GmVQk+PC3WqyyBzrOUWmrU1rRD
KGJqEnknI8HW33MWuGfAlYaQEj5q2YpS8VzqqeSUEeYf7zMiGF6UZDPOWdyOrTjn
V6N7tvIfrg0=
=fxIk
-----END PGP SIGNATURE-----

--Sig_/=WarB1/s/bDAN__bW0_V42H--
