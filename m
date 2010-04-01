From: Doug Ledford <dledford@redhat.com>
Subject: Re: Problems with RAID 6 across 15 disks
Date: Thu, 01 Apr 2010 09:49:21 -0400
Message-ID: <4BB4A461.5030704@redhat.com>
References: <4BB49E4D.1090809@maxeaves.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0A57F928027CB3F871942191"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB49E4D.1090809@maxeaves.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: max@maxeaves.co.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0A57F928027CB3F871942191
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/01/2010 09:23 AM, Max Eaves wrote:
> Hi there,
>=20
> I hope this gets through....my first posting on this dist.list.
>=20
> I am running Centos 5.4 with a 2.6.18-164.15.1.el5 kernel (x86_64)
> kernel using a rather "homebrew" backblaze system
> (http://blog.backblaze.com/) system.
>=20
> The mdadm version is: mdadm - v2.6.9 - 10th March 2009
>=20
> It uses a number of Silicon Image 3124 (sIL 3124) cards and a number of=

> multiplier port cards (sIL3132) to read a large number of disks.
>=20
> I have 45 disks arranged into 3 mdadm raid sets of 15 disks.  These 15
> disks are raided using RAID6.
>=20
> The problem I have is this:
>=20
> At random times, the RAID decides that it needs to resynchronise
> /dev/md10 /dev/md11 and /dev/md12.  There is no error or log event in
> /var/log/messages, but the first thing I notice is that the performance=

> of the RAID array drops, and checking out "cat /proc/mdadm" shows all
> three RAID re synchronising themselves.
>=20
> ARRAY /dev/md0 level=3Draid1 num-devices=3D2
> uuid=3D7d7b19e6:56cc90cc:3cb166bd:b8086f29 (system boot) (not a problem=
)
> ARRAY /dev/md1 level=3Draid1 num-devices=3D2
> uuid=3D3782d93d:a491ffd4:f32c1014:94a2b3f7 (system LVM) (not a problem)=

> ARRAY /dev/md10 level=3Draid6 num-devices=3D15
> uuid=3D5ca86e2a-3b86-4c0b-9a7a-59143bdcd0f1 (partition 1) (problem)
> ARRAY /dev/md11 level=3Draid6 num-devices=3D15
> uuid=3D61188c90-4825-44c5-8fac-9bc82a5799fe (partition 2) (problem)
> ARRAY /dev/md12 level=3Draid6 num-devices=3D15
> uuid=3Dfa939816-1d0f-4eaa-98dd-c131449c3921 (partition 3) (problem)
>=20
> These re-synchronisation events take about a week to complete (the RAID=

> is 18TB a pop)
>=20
> I know that the performance of this system is not great, but I wonder i=
f
> this resynchronisation is occurring because of some I/O time-out.
>=20
> Oddly enough, a restart of the server fixes the problem for a couple of=

> days, and then problem occurs again (humm - not good).
>=20
> I'm happy to post logs etc....just let me know what you need.

Disable /etc/cron.weekly/99-raid-check.  They aren't resyncronizing,
they are actually just checking themselves for consistency, but because
the 2.6.18 kernel didn't have a different word for it in the output of
/proc/mdstat it just looks that way.  I can't remember if the version of
mdadm in centos 5.4 has the /etc/sysconfig/raid-check config file, but
if it does, it's easy to disable the weekly check there.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig0A57F928027CB3F871942191
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku0pGEACgkQg6WylM+/8ZTtlwCeOb0o5paqHNfw4f2sT546D4xQ
GB8AoIwZXUO40irX8C4jheuroqU+OKlY
=Mfjr
-----END PGP SIGNATURE-----

--------------enig0A57F928027CB3F871942191--
