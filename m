From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 grow failed
Date: Wed, 28 Mar 2012 19:26:01 +1100
Message-ID: <20120328192601.3db82133@notabene.brown>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
	<CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/evWqoiHxqstYUsghNg0siyy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/evWqoiHxqstYUsghNg0siyy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 03:54:45 -0400 Bryan Bush <bbushvt@gmail.com> wrote:

> On Wed, Mar 28, 2012 at 12:18 AM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 27 Mar 2012 22:44:18 -0400 Bryan Bush <bbushvt@gmail.com> wrote:
> >
> >> I hope this is the right place to ask this question. =A0I have at 8
> >> drive RAID 6 array that I wanted to grow to 13 drives (adding 5 more).
> >> =A0I issued the mdadm command and checked /proc/mdstat and all looked
> >> well. =A0However at some point in time a disk failed and that hung my
> >> system. =A0Upon reboot the array is inactive and I can't get it to
> >> reassemble.
>=20
> > Hmmm... what do you have in /etc/mdadm.conf??
>=20
> root@diamond:~# cat /etc/mdadm/mdadm.conf
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
>=20
> # by default, scan all partitions (/proc/partitions) for MD superblocks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE partitions
>=20
> # auto-create devices with Debian standard permissions
> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>=20
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
>=20
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR root
>=20
> # definitions of existing MD arrays
>=20
> # This file was auto-generated on Fri, 14 Jan 2011 22:22:14 -0500
> # by mkconf $Id$
>=20
> ARRAY /dev/md1 level=3Draid6 num-devices=3D8 metadata=3D01.02 name=3D1
> UUID=3Dfa32e2c5:e7bda20b:32af7c90:c7ee61eb

I think this array now has 13 devices, not 8.  You might want to fix that.
If you do, it might all magically start working.

(also get rid of the metadata=3D or make it metadata=3D1.2)

Or just get rid of the num-devices=3D bit.

> ARRAY /dev/md0 level=3Draid5 num-devices=3D4 metadata=3D00.90
> UUID=3D989c3b8b:bd60d243:683690d9:73a11dfa
>=20
> root@diamond:~#
>=20
> >
> > Though if the names have changed at all it would be safer to do
> >
> > =A0mdadm -Asf /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c7ee61eb
> >
>=20
> root@diamond:~# mdadm -Asf /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c7ee61eb
> mdadm: metadata format 01.02 unknown, ignored.
> mdadm: metadata format 00.90 unknown, ignored.
> mdadm: no devices found for /dev/md1

Odd.  I the above change to mdadm.conf doesn't help, try rerunning this
command with --verbose and report the result.

NeilBrown


> root@diamond:~#
>=20
> Didn't seem to help.
> Any other ideas?
> Thanks
> -Bryan


--Sig_/evWqoiHxqstYUsghNg0siyy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3LLGTnsnt1WYoG5AQKkKA/+JD3QyOqH/ivkLE8ykVJpBGgCWh8Q75ns
VKRdLYgMUhuGEZTfW3mV35tLOIHjFhRElc7btDbbejuwP7dgNw77eNuLqWr9LFT1
F83SmkbqAVUrH9ZUyAolSHYL4Hhw9u1bgb0+sIlGbycX+w0yd1/5uR7LArBfOjb6
cIqJSDTaT/lqM9aU6k8AXqokcm58Ve9ae5HjqvlOQk1xWr+6ti7XNAdyGzN17GmS
VLtcETrfDn44/6Wq6t9Sus4ueht6e+a3DJCrUgQLml67NnmgsFEK6ui2791tjRep
pi4+XDOVE+vxFLiCPXm1KEgL8YSdVxLwWNcaWCUODI2kbCrOuWAycV8lMGdDe3wW
F6jpxkQOmSI9nOnZM81He38yCnWqizIU7l6CwH7m9cK6kjBNGtyT3CjwU4My4MGB
7RmCoZWHMJkLcbJ6BGTF0Vn+eEBUOsCYITeA8Y1sz6hb1LejxA8GFATRQ1rZAzcN
SlMynqc5/XKUwjHvou4p+LPZjWcpSRDrRGSx85zoSJksy/VYxO2kP/dJFw2eoob+
eOUD/OgoA0syJsCz/Qyr5IKNIJmDoR2LWFi5bSadDS9DHdqK0sx4/Xh7gxpzuin8
a+CaxCrNt4G/845PJr76lVuwGEM5gI6kZqrVLj8akIWFOi4TsF6P0JrcQI1+tNn8
paNC5aWDP0Q=
=ePD/
-----END PGP SIGNATURE-----

--Sig_/evWqoiHxqstYUsghNg0siyy--
