From: NeilBrown <neilb@suse.de>
Subject: Re: Cannot auto assemble a raid1 array on boot
Date: Wed, 24 Oct 2012 12:33:30 +1100
Message-ID: <20121024123330.3084e7b3@notabene.brown>
References: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com>
	<507F7428.6030003@websitemanagers.com.au>
	<CAG9W8wCH9bfHou72_+t+JoCS3EA96opcpTOTzkc2E0oFkbX8zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RGR2LNbMN05L2ZouuwRj5oV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG9W8wCH9bfHou72_+t+JoCS3EA96opcpTOTzkc2E0oFkbX8zg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jivko Sabev <jsabev@nicmus.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/RGR2LNbMN05L2ZouuwRj5oV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Oct 2012 09:19:58 -0600 Jivko Sabev <jsabev@nicmus.com> wrote:

> Hi,
>=20
> The mdadm.conf in the initrd image contains the correct devices. I.e.
> the contents of mdadm.conf in initrd are the output of
>=20
> mdadm --detail --scan
>=20
> ARRAY /dev/md0 metadata=3D1.2 name=3Dmercury:0
> UUID=3D60ea870e:029dcf99:eaae356e:f1c12085
> ARRAY /dev/md1 metadata=3D1.2 name=3Dmercury:1
> UUID=3Dd89a52ed:0247f2e8:5edf5d09:21e7fa48
>=20
> However, the problem remains. That is when booting, the system dumps
> into initramfs shell with the raid array in an inactive state. I have
> to manually stop the array and then reassemble.
>=20
> mdadm --manage --stop /dev/md1
> mdadm --assemble /dev/md1 /dev/sde1 /dev/md0
>=20
>=20
> At the point, I am able to continue booting and everything is fine after.
>=20
> Here are the contents of /proc/mdstat from the initrd shell before
> reassembling the array.
>=20
> md1 : inactive sde1[2](S)
>       976639672 blocks super 1.2
>=20
> md0 : active linear sdb1[0] sdc1[1]
>       976770537 blocks super 1.2 0k rounding

There are two problems here.

Firstly, the fact that the array doesn't assemble completely should not cau=
se
the boot to fail.  A degraded raid1 is perfectly sufficient for booting.

What is happening is that the initrd is relying on udev to assemble the arr=
ay
by passing each new device to "mdadm --incremental $DEVNAME".
This will assemble the array as soon as all devices are present, but not
before.   If a device failed before shutdown that will be recorded in the
metadata and "mdadm --incremental" will not wait for it.  If it disappears
during reboot, mdadm will still expect it.

To deal with this issue, the initrd should run
  mdadm --incremental --scan --run

which means "look for all arrays that are being incrementally assembled, and
start them".
This should be called after running "udevadm settle" and before mounting the
root filesystem.

However fixing this won't fix your problem, it will just change it.

The udev rules files which is calling "mdadm --incremental" does so
on /dev/sdb1 /dev/sdc1 and /dev/sde1, but apparently not on /dev/md0.

If at the initrd shell prompt you run
  mdadm -I /dev/md0

it should finish assembling md1 for you.  For some reason udev isn't doing
that.

Have a look in /lib/udev/rules.d or /etc/udev/rules.d for a file that runs
"mdadm --incremental" or "mdadm -I" and see how it works.
Maybe post it.

BTW what distro are you using?

NeilBrown


--Sig_/RGR2LNbMN05L2ZouuwRj5oV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIdFajnsnt1WYoG5AQLuRQ//RqHw99Vjx87781xNjrPiYYgAxe0Fd1ii
FJcPO6EUUxsisLIII+QA7EM8eB7Y/6T/E8jFj/VuFC1xnjJfw5Djx8Bxcljd0Fbk
GsbrU8AbOEU5MguRr3RO6/l1DX6XwJDW6TOQckSqihbVwcOwa9TfNzzkrD2JfI2i
f7OCo5m5gZg+XQNASk8tWgD78IrPcumumUuTCRfTVTSTJrIarKOIZ7fR60aZHMRH
Vst6FQuz/E82lE7Wuu3hRT8uteVLrzsMPq2R+u92Q9zbXPR+Ln8DsrdEPPURGh2b
pEJMGBwXpqvGua6ts+kPuenlRwKsWrtiiRrOlbSb+n4SAlq804ucIbL0au3PmYIh
gvNWI6YdHSgKOsUyo5X3nTaLZdt+Rx/bhytUmJf6C9alZXVZiVYWd4GNjL1EVthj
+Rc7zh76MJzu8FwTaRNZIclWTWnomCRxMa5aN4pzcsTsXKBBEWQXg0uJ5sNq62+N
TuPmNk4TEcgR8G8XtuaIcz/0mtoOqL5OQmxM1ZDQdHl8oKr6BePnJDvbG70kHf44
sCDj7/obin+2Q2WbrEzS/QwBE6+KHw5flX1pb9VTKa2P82Yav/8qWFmJcYANShYH
PJt0BV7PTyMq3DM3r4/PD+RGjom9RuvFq7K5QGMn79/Aup400dJYp33IYk7Al2N4
qlteZfNrErU=
=lkM3
-----END PGP SIGNATURE-----

--Sig_/RGR2LNbMN05L2ZouuwRj5oV--
