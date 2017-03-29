From: NeilBrown <neilb@suse.de>
Subject: Re: Grow set size issue
Date: Thu, 30 Mar 2017 08:34:27 +1100
Message-ID: <87o9wju5r0.fsf@notabene.neil.brown.name>
References: <wrfjlgrodlbj.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjlgrodlbj.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 30 2017, jes.sorensen@gmail.com wrote:

> Hi Neil,
>
> In the below patch you changed the error handling, to make the kernel
> not setting the size of the device being an error. However we still have
> the code in place to handle the error, except it never triggers.

So we do.  I should have removed all of that.
I should have just reverted
Commit: 65a9798b58b4 ("FIX: Detect error and rollback metadata")


>
> Question is do you remember the reason for this change? Old kernels not
> allowing it, are there any legitimate reasons for the kernel to refuse
> the size change?

I needed to go further back to remind myself why we do these size change
at all.
The command being run here is "mdadm --grow /dev/mdX --size=3Dfoo"
which has a primary purpose of changing the component_size of the array.
What can happen is that someone makes all the components bigger
(E.g. with LVM) and then uses this command to set --size=3Dmax, and it
doesn't work.  That is because md doesn't know the devices are bigger.

You can tell md that devices have changes size by writing to the "size"
attribute.
mdadm doesn't have an option for doing that per-device - you need to
poke into sysfs.

To make it a bit easier, when you use "--grow --size=3Dfoo", mdadm will
always write "foo" to the "size" attribute of each device, just incase
that will be helpful. In the case where the device is now bigger, it
will.

In the case where the size of the array is being reduced, it is not
permitted to change the "size" of each device until the "component_size"
of the array has changed, so these attempts to change "size" will fail.
But that isn't a problem.

In short, the attempt to change "size" here is a convenience, and
optimization.  It doesn't matter if it fails.

So please just revert all bits of the above commit that are still
present.

Thanks!
NeilBrown


>
> Cheers,
> Jes
>
> commit b0a658ffbcd2104594e8a7a185fa0fe05127723e
> Author: NeilBrown <neilb@suse.de>
> Date:   Thu May 3 16:18:22 2012 +1000
>
>     Grow: failing the set the per-device size is not an error.
>=20=20=20=20=20
>     Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/Grow.c b/Grow.c
> index 0b0d718..330e719 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1668,7 +1668,9 @@ int Grow_reshape(char *devname, int fd, int quiet, =
char *backup_file,
>                 rv =3D 0;
>                 for (mdi =3D sra->devs; mdi; mdi =3D mdi->next) {
>                         if (sysfs_set_num(sra, mdi, "size", size) < 0) {
> -                               rv =3D 1;
> +                               /* Probably kernel refusing to let us
> +                                * reduce the size - not an error.
> +                                */
>                                 break;
>                         }
>                         if (array.not_persistent =3D=3D 0 &&

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljcKGMACgkQOeye3VZi
gbluNhAAw78rYG+X88pkVg9qswlyhWOjj1cE48/ObF+jumJUsd8kWe3Mt7MKlilt
AODTC38yT+R0UpNesL/sdDqk8ocDW9EjPo+/TONBmkeYQCmvMoiquSHC+vbm6iXL
h3D65i3h2WFeaRBiPGch5CVGcK1USJxq/5PEY5Jg0npHt/RYikRV7SHIocpqmboc
ZeluiWRfMZRQHr8igEkEUpemyypjB4GGMuKjpkvbmCw2w85wu6Hh7llfkTn5C/Hj
gifDjNiaUbRGyUBpFFUFkgEykQeqvdXi6+TqNxcwQm03Ohvz+ZjqaUzz3lq7nr1z
2FIsVSrkktjakD4z6xXj5F3VYO+4svLZ5eqn32zo71iabX+JeTwYpmyAonX/wOQZ
a3a4aYwHx6q9IMNxhRy1CPWyjSnnp6g4JtGju6nQ+qEj6F9sChMSdEJ/QmRbqZ2D
q+VIKpVWfr1j64c3tRAHwFY6MB5tf/APpncyHTe/CjHuGnazp5FdLq3VDMBj948V
oH1JS3tdTxRboi2+NFbywGhXEXAq3WnlbjXjbILiMvWgzAv37FGAYwy6v2aoDv0c
xTbFIfaV0TMefMcpU2lPTM6hPshLGUopzrxH7wO2s0OGWWBTIEZNS+ZMHBVALA8F
qUrLibpT0VpRBMJugqTlPZb3ORMbF9FrqwN59J64wQzc4BuRmGc=
=/CvG
-----END PGP SIGNATURE-----
--=-=-=--
