From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Wed, 24 Oct 2007 12:25:01 -0400
Message-ID: <1193243101.10336.55.camel@firewall.xsintricity.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>
	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
	 <46E4A7C3.1040902@amfes.com>  <471F5542.3020504@amfes.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+HBWj4WvayFXusT5wi9L"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471F5542.3020504@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel L. Miller" <dmiller@amfes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-+HBWj4WvayFXusT5wi9L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 07:22 -0700, Daniel L. Miller wrote:
> Daniel L. Miller wrote:
> > Richard Scobie wrote:
> >> Daniel L. Miller wrote:
> >>
> >>> And you didn't ask, but my mdadm.conf:
> >>> DEVICE partitions
> >>> ARRAY /dev/.static/dev/md0 level=3Draid10 num-devices=3D4=20
> >>> UUID=3D9d94b17b:f5fac31a:577c252b:0d4c4b2a
> >>
> >> Try adding
> >>
> >> auto=3Dpart
> >>
> >> at the end of you mdadm.conf ARRAY line.
> > Thanks - will see what happens on my next reboot.
> >
> Current mdadm.conf:
> DEVICE partitions
> ARRAY /dev/.static/dev/md0 level=3Draid10 num-devices=3D4=20
> UUID=3D9d94b17b:f5fac31a:577c252b:0d4c4b2a auto=3Dpart
>=20
> still have the problem where on boot one drive is not part of the=20
> array.  Is there a log file I can check to find out WHY a drive is not=20
> being added?

It usually means either the device is busy at the time the raid startup
happened, or the device wasn't created by udev yet at the time the
startup happened.  It it failing to start the array properly in the
initrd or is this happening after you've switched to the rootfs and are
running the startup scripts?


> md: md0 stopped.
> md: md0 stopped.
> md: bind<sdc>
> md: bind<sdd>
> md: bind<sdb>

Whole disk raid devices =3D=3D bad.  Lots of stuff can go wrong with that
setup.

> md: md0: raid array is not clean -- starting background reconstruction
> raid10: raid set md0 active with 3 out of 4 devices
> md: couldn't update array info. -22
> md: resync of RAID array md0
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000=20
> KB/sec) for resync.
> md: using 128k window, over a total of 312581632 blocks.
> Filesystem "md0": Disabling barriers, not supported by the underlying dev=
ice
> XFS mounting filesystem md0
> Starting XFS recovery on filesystem: md0 (logdev: internal)
> Ending XFS recovery on filesystem: md0 (logdev: internal)
>=20
>=20
>=20
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-+HBWj4WvayFXusT5wi9L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHH3HdTzP9PM7pjw8RAnraAJ9QMKHPSWJANAuwnaoxutsFAoHyRQCfQjAi
4y6gU3Jah19J7dX8arzfxt8=
=ulTP
-----END PGP SIGNATURE-----

--=-+HBWj4WvayFXusT5wi9L--

