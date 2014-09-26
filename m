From: NeilBrown <neilb@suse.de>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Fri, 26 Sep 2014 10:33:48 +1000
Message-ID: <20140926103348.5f5ea568@notabene.brown>
References: <53A99B76.3020603@gmail.com>
	<20140625110348.48ab2d7a@notabene.brown>
	<54243ED7.6090904@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/nVNXU8cCb96IW1ue4Z2uUpR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54243ED7.6090904@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

--Sig_/nVNXU8cCb96IW1ue4Z2uUpR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Sep 2014 18:12:07 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello,
>=20
> On 06/25/2014 03:03 AM, NeilBrown wrote:
> > On Tue, 24 Jun 2014 17:38:30 +0200 Francis Moreau <francis.moro@gmail.c=
om>
> > wrote:
> >=20
> >> Hello,
> >>
> >> I'm having the folloing behaviour with kernel 3.14.5 and mdadm v3.3.1.
> >>
> >> After stopping all arrays, I still can see one of them in /sys/block/:
> >>
> >> # cat /proc/mdstat
> >> Personalities : [raid1]
> >> md125 : active raid1 sdb3[1] sda3[0]
> >>       483688448 blocks super 1.2 [2/2] [UU]
> >>       [=3D=3D=3D=3D=3D=3D>..............]  resync =3D 34.9% (169161280=
/483688448)
> >> finish=3D44.0min speed=3D118852K/sec
> >>       bitmap: 3/4 pages [12KB], 65536KB chunk
> >>
> >> md126 : active raid1 sdb2[1] sda2[0]
> >>       4038656 blocks super 1.2 [2/2] [UU]
> >>
> >> md127 : active raid1 sdb1[1] sda1[0]
> >>       524224 blocks super 1.0 [2/2] [UU]
> >>
> >> unused devices: <none>
> >>
> >> # mdadm --stop /dev/md12[567]
> >> mdadm: stopped /dev/md125
> >> mdadm: stopped /dev/md126
> >> mdadm: stopped /dev/md127
> >>
> >> # cat /proc/mdstat
> >> Personalities : [raid1]
> >> unused devices: <none>
> >>
> >> # ls /sys/block/
> >> md126  sda  sdb  sdc  sr0
> >>
> >> # ls /sys/block/md126/md/
> >> array_size  array_state  bitmap  chunk_size  component_size  layout
> >> level  max_read_errors  metadata_version  new_dev  raid_disks
> >> reshape_direction  reshape_position  resync_start  safe_mode_delay
> >>
> >> # dmesg
> >> ....
> >> [ 1573.715476] md125: detected capacity change from 495296970752 to 0
> >> [ 1573.715626] md: md125 stopped.
> >> [ 1573.715633] md: unbind<sdb3>
> >> [ 1573.740681] md: export_rdev(sdb3)
> >> [ 1573.740694] md: unbind<sda3>
> >> [ 1573.754008] md: export_rdev(sda3)
> >> [ 1573.773398] md126: detected capacity change from 4135583744 to 0
> >> [ 1573.773403] md: md126 stopped.
> >> [ 1573.773410] md: unbind<sdb2>
> >> [ 1573.820652] md: export_rdev(sdb2)
> >> [ 1573.820664] md: unbind<sda2>
> >> [ 1573.873974] md: export_rdev(sda2)
> >> [ 1573.889904] md127: detected capacity change from 536805376 to 0
> >> [ 1573.889910] md: md127 stopped.
> >> [ 1573.889917] md: unbind<sdb1>
> >> [ 1573.913978] md: export_rdev(sdb1)
> >> [ 1573.914033] md: unbind<sda1>
> >> [ 1573.940627] md: export_rdev(sda1)
> >>
> >> After waiting a couple of min, stopping again md126 worked:
> >>
> >> [ 1835.755661] md: md126 stopped.
> >>
> >> Is this expected ?
> >=20
> > No overly surprising.
> >=20
> > This is probably caused by udev, or something udev runs, opening /dev/m=
d126
> > after it has been stopped.  This has the effect of creating an empty in=
active
> > array.
> > e.g.
> >=20
>=20
> Sorry for resurecting this again, but I'm still seeing this.
>=20
> Sebastian saw the same behaviour with udev 215 and it appeared that this
> specific version introduced a regression which resulted in the same
> behavior I described initialy.
>=20
> But in my case, the version of udev used is older (204).
>=20
> I tried to find out what could have opened the md device by using fuser,
> but fuser reports no users.

It is probably a transient open/close.

>=20
> I took a look to the udev rules which are the one shipped by mdadm 3.3.2
> but nothing keep the device opened during the remove event.
>=20
> Could you give me some hints here to debug this ?

Modify md_open in drivers/md/md.c to add
   printk("Opened by %s\n", current->comm);

and build a new kernel.  That will tell you the name of the process which
opened the device.

NeilBrown

>=20
> Thanks
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/nVNXU8cCb96IW1ue4Z2uUpR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCS0bDnsnt1WYoG5AQK4KBAAkg/SwQmdi4dwEXqddTEl0cfpPjauK70x
ywYwrAYQ2kV1IP3XgBpYnf/c6uWX7bql+bp9GPAl/0CDr+ceLzttHoNmy0B00PCh
ALeMnxscAtaoFvJhno6aR395tVMEsezhQTJuaN5HPK0z0FQJsjXRQ3BsF/PJ7M2g
vW+SelNz2U0gcFTYGSD7XhlzXAj7XMPodCA/S50cthK/NYkzqQAGeih3gDb/cSan
iwSqGxasAvh47cckFn0QuXdHkQk77ry3sW/ifSCsbePcCcYrLsk5cJ8kwTM53q4Y
LwGfPvxAHab0dLBp3SKpIzv4na064Smz0PO3AgF4109VPVhsicG9u5F4ABueS2UK
A6pruSCOttlWYka1T+eR/hx7zdYzR4zEEXDcBxM0mQqCM4PjilT8lifNneSFMklI
INkch6f7ViQ60CYi1iiJ/Clc2+sQsMBcquu8xqRaC9IDRSN2tTBccivxS7U+PaZw
R/iCEE04i4kXzi65ud7xkqH3kxBMyjMshcvqnNxNh1iXOLiHDlImp2tuyiVrocgU
sbvNvIm2DDgzwS3uoKXXXn/R5d4s09HT9tN8eJzJU7XpcH+9UktYOvRaPaInnexT
dtl5J3RpN8CybmjiOjorZh1LKnEiOiboAZXXUUA+d06knbVga8SpYi9JLoMEkZRb
Qi0G2vcph9A=
=J6e9
-----END PGP SIGNATURE-----

--Sig_/nVNXU8cCb96IW1ue4Z2uUpR--
