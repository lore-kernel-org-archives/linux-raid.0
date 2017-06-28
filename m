From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: Disk Monitoring
Date: Wed, 28 Jun 2017 12:45:46 +0200
Message-ID: <20170628104545.z7anvliygsjrhqax@vault.lan>
References: <CAJH6TXgvrVckHDmh1oiN9mupLrsS2NP3J44bG1_wE9Nnx4=yHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v4xfsutwbhk3vzra"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJH6TXgvrVckHDmh1oiN9mupLrsS2NP3J44bG1_wE9Nnx4=yHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--v4xfsutwbhk3vzra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gandalf,

On Wed, Jun 28, 2017 at 12:25:55PM +0200, Gandalf Corvotempesta wrote:
> Hi to all
> I always used hardwre raid but with my next server I would like to use md=
adm.
>=20
> Some questions:
>=20
> 1) all raid controllers have proactive monitoring features, like
> patrol read, consistency check and (more or less) some SMART
> integration.
> Any counterpart in mdadm?

mdmon(8) is what you seek. Also, monitoring the kernel debug ringbuffer I c=
an
highly recommend.


> 2) thanks to this features, raid controller are usually able to detect
> disk issues before they cause data-loss. what about mdadm ?
>=20
> How and when do you replace disks ? Based on which params? Do you
> always wait for a total failure before replacing the disk?
>=20
> Is mdadm able to notify some possible bad-things before they happens ?

md doesn't do low-level management of block devices/disks; that's the job of
other parts of the kernel. The block layer will report errors that you may
want to act upon before md itself complains and/or the disk gets kicked from
its array (which renders your array degraded, but otherwise operational), b=
ut
that's usually not necessary.

There's generally no need to replace a disk without any indication of serio=
us
problems (like it getting booted from the array due to I/O timeouts, for
instance).


> Many times in the past our raid controllers forced a bad sector
> reallocation during proactive tasks like patrol read. This saved me
> many times before. I've tried to not replace a disks when this
> reallocation was made (it was a test server) and after some weeks the
> disk failed totally.

You can initiate the resilvering of array data via sysfs; check md(4) for
details.


--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   https://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp:  johannes@truschnigg.info

Please do not bother me with HTML-email or attachments. Thank you.

--v4xfsutwbhk3vzra
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEGu9IhkI+7/aKLUWF95W3jMsYfLUFAllTiNkACgkQ95W3jMsY
fLX1JA//WceCgH5c6fckVHHyjvz9RGwdMAHZOObIN4vQvRQK8XkhcthTd3U8xTQe
N3WM9QrYH04HSNwDskzzaW/R8Rbs30QyPQVp5JcO9YxbikFBzeRuqygtDlfsmaNs
afE2ixke0/ONBf+o14M1Ky/i9TSXPgp9lM1n3uYY9B1dCjKErglAz3broeLhWEmP
kIim9fCg4LdFx2ntQSO8afQDh31g0zP60OWhykhD7ubZ7Jv2TZpB6/PAsh++0lIf
itrxfzhucunP42VNCMH3nkXiOwAN0h8TT7+NJkWEUZHbEdcuQ4olL0Vuo4dbMwGu
lNbu+l4qlWLlO/0y4cTe3OHB87WhbBH6jylKZDe34eBq4rI9MhwpPrsjWS5geCSb
jjLWvhHYaNWUbClHySv7IbTkpPsk18Jr8W9+Guj1ZzwPnle9/lOQ+il+vA2c4PrP
5eZiUMFe48KRCsKsOJLXOGIYFyGKtMe4HVkmzaD0w8MjNJ0oSn/ktwgW7o5MSxkE
Ng4fFhoxyfRw8pFhk0qM5PA8ic/cWBL0guAhlZkJ5+wrUBBTvX8BduW7zyQFvjNk
ZamLglXbh0dP0/kksCsoG/ln9hP9Pv1ZdAX2V4QNs6FTrgR8SD4R+WeLncnfHX09
0i0KwYShpoO+ISJpiRIkb0lYY6+lFX92lnPfgxeoK4QVielyZHw=
=X1MR
-----END PGP SIGNATURE-----

--v4xfsutwbhk3vzra--
