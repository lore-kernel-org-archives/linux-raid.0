From: NeilBrown <neilb@suse.de>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Thu, 9 Oct 2014 20:55:09 +1100
Message-ID: <20141009205509.1da5dbd9@notabene.brown>
References: <53A99B76.3020603@gmail.com>
	<20140625110348.48ab2d7a@notabene.brown>
	<54243ED7.6090904@gmail.com>
	<20140926103348.5f5ea568@notabene.brown>
	<54253E9F.4070505@gmail.com>
	<20140926204445.1ec830b9@notabene.brown>
	<54255A30.9010406@gmail.com>
	<20140929143735.5fa54253@notabene.brown>
	<54291C1D.7010005@gmail.com>
	<20140930075643.34e864fa@notabene.brown>
	<542A5F15.7030100@gmail.com>
	<543390C7.2080104@gmail.com>
	<20141008105425.64cd0fed@notabene.brown>
	<54365809.90406@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+78xz_a6O7xQ7ZmHZYEdg+m"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54365809.90406@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

--Sig_/+78xz_a6O7xQ7ZmHZYEdg+m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 09 Oct 2014 11:40:25 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> On 10/08/2014 01:54 AM, NeilBrown wrote:
> > On Tue, 07 Oct 2014 09:05:43 +0200 Francis Moreau <francis.moro@gmail.c=
om>
> > wrote:
> >=20
> >> Hi Neil,
> >>
> >> On 09/30/2014 09:43 AM, Francis Moreau wrote:
> >>> Hi Neil,
> >>>
> >>> On 09/29/2014 11:56 PM, NeilBrown wrote:
> >>>> On Mon, 29 Sep 2014 10:45:17 +0200 Francis Moreau <francis.moro@gmai=
l.com>
> >>>> wrote:
> >>>>
> >>>>>> So what were pids 930 and 459?
> >>>>>> One was presumably the "mdadm -Ss"  - probably 930.
> >>>>>> Is 459 the "mdadm --monitor" ??  That might be useful hint.
> >>>>>>
> >>>>>
> >>>>> yes.
> >>>>>
> >>>>> [456] is:  /sbin/mdadm --monitor --scan --daemonise --syslog
> >>>>> --pid-file=3D/run/mdadm/mdadm.pid
> >>>>>
> >>>>> and [930] is 'mdamd -Ss'.
> >>>>
> >>>> Good.  Please try the patch below.
> >>>>
> >>>
> >>> After applying your patch, this is what I'm getting in syslog:
> >>>
> >>> Sep 30 03:40:07 localhost kernel: md_open(): md125 opened by mdadm [9=
70]
> >>> Sep 30 03:40:07 localhost kernel: md_release(): md125 released by mda=
dm
> >>> [970]
> >>> Sep 30 03:40:07 localhost kernel: md_open(): md125 opened by mdadm [9=
72]
> >>> Sep 30 03:40:07 localhost kernel: md_open(): md125 opened by mdadm [9=
70]
> >>> Sep 30 03:40:07 localhost kernel: md_release(): md125 released by mda=
dm
> >>> [972]
> >>> Sep 30 03:40:07 localhost kernel: md_open(): md125 opened by
> >>> systemd-udevd [971]
> >>> Sep 30 03:40:07 localhost systemd[1]: Cannot add dependency job for u=
nit
> >>> mdmonitor-takeover.service, ignoring: Invalid argument
> >>> Sep 30 03:40:07 localhost systemd[1]: Started Software RAID monitoring
> >>> and management.
> >>> Sep 30 03:40:07 localhost kernel: md_release(): md125 released by
> >>> systemd-udevd [971]
> >>> Sep 30 03:40:08 localhost mdadm[466]: DeviceDisappeared event detected
> >>> on md device /dev/md125
> >>> Sep 30 03:40:08 localhost mdadm[466]: DeviceDisappeared event detected
> >>> on md device /dev/md126
> >>> Sep 30 03:40:08 localhost mdadm[466]: DeviceDisappeared event detected
> >>> on md device /dev/md127
> >>> Sep 30 03:40:08 localhost kernel: md125: detected capacity change from
> >>> 1863254016 to 0
> >>> Sep 30 03:40:08 localhost kernel: md: md125 stopped.
> >>> Sep 30 03:40:08 localhost kernel: md: unbind<vdc3>
> >>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdc3)
> >>> Sep 30 03:40:08 localhost kernel: md: unbind<vdb3>
> >>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdb3)
> >>> Sep 30 03:40:08 localhost kernel: md_release(): md125 released by mda=
dm
> >>> [970]
> >>> Sep 30 03:40:08 localhost kernel: md_open(): md127 opened by mdadm [4=
66]
> >>> Sep 30 03:40:08 localhost kernel: md_release(): md127 released by mda=
dm
> >>> [466]
> >>> Sep 30 03:40:08 localhost kernel: md_open(): md126 opened by mdadm [4=
66]
> >>> Sep 30 03:40:08 localhost kernel: md_release(): md126 released by mda=
dm
> >>> [466]
> >>> Sep 30 03:40:08 localhost kernel: md_open(): md126 opened by mdadm [9=
70]
> >>> Sep 30 03:40:08 localhost kernel: md_release(): md126 released by mda=
dm
> >>> [970]
> >>> Sep 30 03:40:08 localhost kernel: md_open(): md126 opened by mdadm [9=
70]
> >>> Sep 30 03:40:08 localhost kernel: md126: detected capacity change from
> >>> 67043328 to 0
> >>> Sep 30 03:40:08 localhost kernel: md: md126 stopped.
> >>> Sep 30 03:40:08 localhost kernel: md: unbind<vdc1>
> >>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdc1)
> >>> Sep 30 03:40:08 localhost kernel: md: unbind<vdb1>
> >>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdb1)
> >>> Sep 30 03:40:08 localhost kernel: md_open(): md127 opened by mdadm [4=
66]
> >>> Sep 30 03:40:08 localhost kernel: md_release(): md127 released by mda=
dm
> >>> [466]
> >>> Sep 30 03:40:08 localhost kernel: md_release(): md126 released by mda=
dm
> >>> [970]
> >>> Sep 30 03:40:08 localhost kernel: md_open(): md127 opened by mdadm [9=
70]
> >>> Sep 30 03:40:08 localhost kernel: md_release(): md127 released by mda=
dm
> >>> [970]
> >>> Sep 30 03:40:08 localhost kernel: md_open(): md127 opened by mdadm [9=
70]
> >>> Sep 30 03:40:08 localhost kernel: md127: detected capacity change from
> >>> 214564864 to 0
> >>> Sep 30 03:40:08 localhost kernel: md: md127 stopped.
> >>> Sep 30 03:40:08 localhost kernel: md: unbind<vdc2>
> >>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdc2)
> >>> Sep 30 03:40:08 localhost kernel: md: unbind<vdb2>
> >>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdb2)
> >>> Sep 30 03:40:08 localhost kernel: md_release(): md127 released by mda=
dm
> >>> [970]
> >>>
> >>> The ghost device is no more present so your patch seems to have fixed=
 my
> >>> issue. But I must admit I don't really understand what's going on :-/
> >>>
> >>
> >> Since those 'ghost' devices are expected from the MD implementation
> >> point of view, I'm wondering how am I supposed to detect them or maybe
> >> how an application is supposed to recognized online arrays.
> >=20
> > If your application is looking in /proc/mdstat, then the "ghost" device=
s will
> > be either "inactive" or not present at all.
> > If your application is looking in /sys/block/md*, then the "ghost" devi=
ces
> > will have "clear" or "inactive" in /sys/block/mdXX/md/array_state.
> >=20
> > If you use the new "CREATE names=3Dyes" line in mdadm.conf (mdadm 3.3 or
> > later), and use kernel 3.17 or later, and use names rather than numbers=
 to
> > identify your arrays (/dev/md/home, /dev/md_root), then the "ghost" pro=
blem
> > will be gone, and names in /proc/mdstat will be e.g. "md_home", or "md_=
root"
> > rather than "md4" or "md127".
> >=20
> >>
> >> My application uses udev to detect et to get information about new
> >> devices. I don't think the information exported by udev is enough to
> >> figure this out. Also please note that since I rely on udev, I can't
> >> really read information on /sys since this information may be out of
> >> sync with the one returned by udev.
> >=20
> > If udev reports that an array exists, then it really did exist when ude=
v got
> > the message.  By the time your program gets run by udev, it might not e=
xist
> > any more. i.e. udev is always racy.
>=20
> Yes, but reading sysfs is also racy. I was thinking that the advantage
> of using udev is that it gives me a *consistent* (perhaps outdated)
> snapshot of the device state.
>=20

In what sense do you think sysfs is racy?  What exactly do you want to do
with the udev event?

The event from the kernel to udev only contains the identity of the device
and the type of event (add,change,remove).

Some drivers add extra 'environment' information.
 - 'dm' adds a 'cookie'.
 - bcache add a 'CACHED_UUID' and 'CACHED_LABEL'
 - libata-acpi adds a 'BAY_EVENT'

but in general there is nothing extra.

If udev adds stuff (which is probably does), it is just as racy as anything
that you might determine and add yourself.

NeilBrown

--Sig_/+78xz_a6O7xQ7ZmHZYEdg+m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDZbfjnsnt1WYoG5AQKsThAAkoQxMs4YDuQRbD3a/0mQFcLCnIl/9p0p
9IEKDxE9vsbBw88VA5e/6rJY/xYdjrHsf0O5XSsLHrln4RTnzpNb3zFCznG0EyS0
qruk304T7C9JcDfs3PZeP6x0V85l4oA5v6qKI2QgdIiN4XVGQFL+vsbNO9qu1lyo
tOjmUsf6YY7Wn5TKNCcVmU34LXoXDPIhNr4jMnIeue4kkZbewpXCVHZMDtuB1MGL
69RHoH7HaKUdcz5fqNNKm/w+KC+RPFyhQay56eWOrAZrCXtyhiSvmMyRqMrsrFHn
oas8rgKYAEyf33VNv7FMW3M3ZP3y5kXqfjwFaczsJ1SYNT5KBzeboSNm0XZFxBp4
rWDHmnc/AuQv/nMUFNg4qJlnJ/CjMsNq/Z8h6LdC7UXMPDDEXgd0+Kr5Q4vAVpGQ
hjutc6JWJtY5TKvKvmxIhjsPzhOde0Hezpi2+vqKk17peV5h5e/BfYbDxfUrmb1z
9JGrVgnTs1uO9/BQOIZS4xBX+MCIYhbLt2W1ITIH3ox7pV10BmiC0dYgVRCOUF6n
ayZgZoj976pXdikp0GHRR1/v/IxCYiJtXGWUcp3TmcSR5uluBHpDCl7rmkg9Wrla
SN1BsPImO7+x+vKdC0e11r64IYxa/66JbhpiRoeUuelHq46cLiX4h4W2T0dpB0GZ
2iBYc32GrrI=
=hvnh
-----END PGP SIGNATURE-----

--Sig_/+78xz_a6O7xQ7ZmHZYEdg+m--
