From: Doug Ledford <dledford@redhat.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Wed, 31 Oct 2007 13:38:08 -0400
Message-ID: <1193852288.10336.590.camel@firewall.xsintricity.com>
References: <20071030210721.386ca2fa@absurd>
	 <1193781699.10336.585.camel@firewall.xsintricity.com>
	 <20071031160152.764e2a45@absurd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HlI2PPfigk2rrdcsLO84"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071031160152.764e2a45@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-HlI2PPfigk2rrdcsLO84
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-31 at 16:01 +0100, Janek Kozicki wrote:
> And now I have a full RAID1 array. Now just two questions:
>=20
> 1. when I `shutdown -r now` I see a worrying message at the end:
>=20
>     Stopping array md2 .... done (stopped)
>     Stopping array md1 .... done (stopped)
>     Stopping array md0 .... failed (busy)
>     Will now reboot
>     md: Stopping all md devices
>     md: md0 still in use
>  =20
>     <reboots>
>=20
>    Is that ok ?

Yes.  That's typical for the root device because root is never unmounted
prior to shutdown.  The messages are probably more worrying than they
need to be.  The system should have successfully switched the array to
read only mode at the first attempt to stop the array.  Neil, any chance
on getting the messages for the / device to be less worrisome?

> 2. Will grub update all drives automatically, for instance when I will
>    upgrade kernel by 'aptitude upgrade'? Or do I need to repeat your
>    grub instructions each time a new kernel is installed?

Now that grub's installed, you won't have to do anything manual again.
The only time you might have to repeat that grub install procedure is if
you loose a drive and need to add a new one back in, then the new one
will need it.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-HlI2PPfigk2rrdcsLO84
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHKL2ATzP9PM7pjw8RAoMdAJoDI7/Tp4ZMr9sYQftCR5btm3TWTACdEdJG
XwK+YpAh56XDGIL7dtbwQek=
=DmaF
-----END PGP SIGNATURE-----

--=-HlI2PPfigk2rrdcsLO84--

