From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: 3ware 7500-8 confusion
Date: 22 Feb 2003 22:03:39 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1045980219.2132.16.camel@gregdell>
References: <Pine.LNX.3.96.1030222210002.29904A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ClRkIcTjIvMu1tzHaAeD"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1030222210002.29904A-100000@Maggie.Linux-Consulting.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-ClRkIcTjIvMu1tzHaAeD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2003-02-22 at 21:08, Alvin Oga wrote:
> hi ya Raiders
>=20
> okay... i confess ... i'm lost and confused ...
>=20
> we have a dual amd mb + 9 drive bays w/ 200GB drives
>=20
> the drives are connected to a 3ware 7500-8
> and the drives is recognized during bios bootup and linux-2.4.19/20
> bootup recognized the controller too
>=20
> the 3ware bios created the raid array out of the 8 drives
> ( supposedly .. waited a long time for it to finish )
>=20
> 3dm was installed from the cdrom that came w/ the controller
>=20
> http://localhost:1080
> 	- shows the list of drives in the raid
> 	- shows the other info abut the 3ware card

Sounds like you've got things set up correctly.

> but now that i wanna use the hw raid, and want to do:
> 	fdisk /dev/md0
> 	mke2fsc -j -m 1 /dev/md0
> 	mount /dev/md0 /Raid
>=20
> but there is no such thing as /dev/md0 ... *pout*

Err, right, there isn't.  /dev/md? is only for software RAID devices.=20
If you've got the 3ware kernel modules loaded, then your 3ware RAID
device should show up as /dev/sd?  dmesg should have more info, or
/proc/scsi.

> what is the name of the device ( /dev/xxx ) that 3ware built ??
> 	- went digging/googling around but didnt find my answer yet
>=20
> 	for freebsd ... i think its /dev/twed
>=20
> -- if its supposed to be /dev/md0 ... guess some step along the
>    way is missing in the steps i did to configure the 3ware 7500-8 card
>=20
> 	-- ie .. i dont see the 3ware bios section that allows
> 	a JBOD vs raid5 either... so its defaulted to raid5 for now

There is a way to configure the 3ware card to just work as JBOD.  I
don't recall what it is offhand (I've got an older card with only 4
ports as well).  It doesn't seem to make much sense to buy a pretty nice
RAID card like this one and then not use it's RAID features, though.=20
HTH,
	Greg

--=-ClRkIcTjIvMu1tzHaAeD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+WGQ6nAkVXO6fw4sRAlR1AJ9ZJEH/Hl+zn19jq0xQ+SGSgHyOXACdENV4
TYkBbL5+Uqw3aPzT+QFZQjY=
=F4Nq
-----END PGP SIGNATURE-----

--=-ClRkIcTjIvMu1tzHaAeD--

