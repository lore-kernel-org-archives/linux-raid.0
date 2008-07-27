From: Doug Ledford <dledford@redhat.com>
Subject: Re: Problem with mdadm 2.6.7
Date: Sun, 27 Jul 2008 15:31:27 -0400
Message-ID: <1217187087.9041.64.camel@firewall.xsintricity.com>
References: <488C531B.5060005@mandriva.org>  <488C8599.4090503@mandriva.org>
	 <1217171198.9041.62.camel@firewall.xsintricity.com>
	 <488C9328.8010503@mandriva.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PTiBSEX7HERUGJ//3s4h"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <488C9328.8010503@mandriva.org>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Backlund <tmb@mandriva.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-PTiBSEX7HERUGJ//3s4h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-07-27 at 18:24 +0300, Thomas Backlund wrote:
> Doug Ledford skrev:
> > On Sun, 2008-07-27 at 17:26 +0300, Thomas Backlund wrote:
> >> Hi,
> >> (please cc me as I'm not subscribed)
> >>
> >> I have hit a bug with mdadm 2.6.7
> >>
> >> It rebuilds my raid5 array on every boot
> >> (raid0 and raid1 arrays are not affected)
> >>
> >> This didn't happend with 2.6.4
> >>
> >> kernels tested are 2.6.24.7 and 2.6.25.12
> >>
> >> Arch is x86_64
> >> Distro Mandriva 2008.1, but I've tested wich kernel.org kernels and=20
> >> upstream mdadm 2.6.7 and have the same problem
> >>
> >> Now I could try to bisect it, but every raid5 rebuild takes 6-7 hours,=
=20
> >> so I thought about asking for pointers before...
> >>
> >> Any ideas where to start looking ?
> >=20
> > Are you using mkinitrd (or something similar) to start the arrays, or
> > are you using udev rules that call mdadm --incremental --run?  If it's
> > the later, then this is what you get when A) the array is started as
> > soon as there are enough devices to run in degraded mode and B)
> > something writes to the array before the last device gets added and C)
> > you don't have a bitmap to allow the array to keep track of what blocks
> > need resynced and therefore it resynces the entire drive.
> >=20
>=20
> I'm using udev.
>=20
> but looking at the difference between 2.6.4 and 2.6.7:
>=20
> diff -Nurp mdadm-2.6.4/etc/udev/rules.d/70-mdadm.rules=20
> mdadm-2.6.7/etc/udev/rules.d/70-mdadm.rules
> --- mdadm-2.6.4/etc/udev/rules.d/70-mdadm.rules	2008-07-27=20
> 13:14:10.000000000 +0300
> +++ mdadm-2.6.7/etc/udev/rules.d/70-mdadm.rules	2008-07-27=20
> 13:11:13.000000000 +0300
> @@ -3,4 +3,4 @@
>   # See udev(8) for syntax
>=20
>   SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add|change",=20
> ENV{ID_FS_TYPE}=3D=3D"linux_raid*", \
> -	RUN+=3D"/sbin/mdadm --incremental $root/%k"
> +	RUN+=3D"/sbin/mdadm --incremental --run --scan $root/%k"
>=20
>=20
> I see that --incremental was already there in 2.6.4, so I guess the=20
> --run is the one messing with me...

Yep.  That'd be it.
>=20
>=20
>=20
> as for --bitmap, can it be added to an existing array ?
>=20
> What is the better choice, bitmap=3Dinternal or bitmap=3D<some_file> ?
>=20
> I'd hate to have to recreate the array, as I have about 1.2GB of data on=20
> it...

I use bitmap=3Dinternal on my arrays and never have a problem.

> --
> Thomas
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-PTiBSEX7HERUGJ//3s4h
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiMzQ8ACgkQTzP9PM7pjw9KswCfbjQy3y5GmIG/DUDYalYieioL
xkIAn0ElLTBOF/4syBTqlyn39VxZRwxR
=buci
-----END PGP SIGNATURE-----

--=-PTiBSEX7HERUGJ//3s4h--

