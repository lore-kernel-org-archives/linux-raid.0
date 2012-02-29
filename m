From: NeilBrown <neilb@suse.de>
Subject: Re: migrating from metadata 0.9 to 1.0 before growing?
Date: Wed, 29 Feb 2012 12:29:06 +1100
Message-ID: <20120229122906.76d08488@notabene.brown>
References: <20120224113821.c2b14f48bcf7e6809b2cd3a6@bbaw.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oFFC9kwXj1W6tPcXIBR/9Rj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120224113821.c2b14f48bcf7e6809b2cd3a6@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/oFFC9kwXj1W6tPcXIBR/9Rj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Feb 2012 11:38:21 +0100 Lars T=C3=A4uber <taeuber@bbaw.de> wrote:

> Hi there.
>=20
> I have a RAID6 using disks in an external SATA enclosure.
> Now I started to exchange the disks with others twice as big as the ones =
the
> RAID was originally created with.
> The RAID uses metadata version 0.9.
>=20
> Now I'm thinking about switching to format 1.0 this way:
>=20
> * exchange all disks with the bigger ones piece by piece
>   (-f old -r old -a new)
> * wait for rebuild of last disk
> * recreate RAID with --assume-clean and --metadata 1.0 and the same disks=
 in
>   the correct order
>=20
> The --grow shouldn't be necessary this way.
> Then I grow the filesystem.
>=20
> Is this precedure possible without data loss?
> Or is there a way a metadata version migration could be done more easily?

Yes, this should work.  There is no better way.

NeilBrown

--Sig_/oFFC9kwXj1W6tPcXIBR/9Rj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT01/Yjnsnt1WYoG5AQLvEA/8D3jpRsPcOonROm5vxdfUnGRRurQs+d2+
3aQ6RCQhrrwIaoe24Eiae33IZW4oxgI1Eje6buEgUebLVWLQclY7dP5nbKNv8trK
+i5nckjYtJfMcgIOPePsR9EhwY9/yg7Mj03GYBCiUrQWVPWGU1L/FdXDbNmApch7
dcLEXo+ua+lbw8Rj9+CehAQFdwAUWuqL4owkRrlAKrWOpJGyzbB5V3FSr7r8Cs++
prR6po/MD13iocZV7A/GcT6VmnCiUgTTUWEMRayY/bG7BP/jycURgPP6k4J/+xxX
73WQzxZgqndAQsBFv4rr6RCeKXdkYBKbhCjwZ1jgo9Ammmgrb+SsgouUYEtU+Vqz
y+FBY4Pli26zFLFcscxvG9VTli6k4FMvQ3AJDlg0cvb8YEOYJqyp0MDjSj4+iePI
Cix/FCpQybtf2VO8YZ0VujUFUevUKlCxcEw0lisWMH/PbsEPQr29bwrRvUjxZ1K2
cIXAgA47WCn2Gma7rGLvaZC1sxjrnQYwWW9kLMpYdXeByJ8HjaPKiEH1MZtc9knU
9hB2Vrmk8HM7hIuIgUE3gZrqCyHT24ojx+omyM+Fm+Nq4SKfnMSS55RhH8CalnTY
am0S6pA3xi8YTH+WoufwkI9oF7SneBCIT5sdLHQ+wBrUV3Qt8U5FEuouKsSJej4q
ZQyIjbUIoEA=
=InHQ
-----END PGP SIGNATURE-----

--Sig_/oFFC9kwXj1W6tPcXIBR/9Rj--
