From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm -add doesn't start rebuilding array
Date: Tue, 21 Aug 2012 18:22:02 +1000
Message-ID: <20120821182202.3ab1b22d@notabene.brown>
References: <5032050A.4000801@supersystem.pl>
	<20120821083040.0d466ceb@notabene.brown>
	<50332E9E.6050108@supersystem.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FJi6VO/hL63P7YLSDLjh5uD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50332E9E.6050108@supersystem.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Sergiusz =?UTF-8?Q?Brzezi=C5=84ski?= <Sergiusz.Brzezinski@supersystem.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FJi6VO/hL63P7YLSDLjh5uD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Aug 2012 08:45:50 +0200 Sergiusz Brzezi=C5=84ski
<Sergiusz.Brzezinski@supersystem.pl> wrote:

>=20
>=20
> W dniu 21.08.2012 00:30, NeilBrown pisze:
> > On Mon, 20 Aug 2012 11:36:10 +0200 Sergiusz Brzezi=C5=84ski
> > <Sergiusz.Brzezinski@supersystem.pl>  wrote:
> >
> >> Hi,
> >>
> >> My system is Ubuntu 12.04, kernel 3.2.0-27. mdadm: 3.2.3
> >>
> >> If I do:
> >>
> >> # mdadm /dev/md0 -a /dev/sdc3
> >>
> >> then nothing happen! No message on command line, no info in logs!
> >>
> >> Man mdadm says:
> >>
> >> -a, --add
> >> hot-add listed devices.  If a device appears to have recently been par=
t of the
> >> array (possibly it failed or was removed) the device is  re-added  as =
 describe
> >>    in  the  next point.   If  that  fails  or the device was never par=
t of the
> >> array, the device is added as a hot-spare.  If the array is degraded, =
it will
> >> immediately start to rebuild data onto that spare.
> >>
> >> But array doesn't wont to rebuild.
> >>
> >> But not exactly. The bad info is, that sometimes it works and sometime=
s it doesn't.
> >>
> >> And if I restart the system, the array SOMETIMES start rebuilding and =
somethimes
> >> doesn't!
> >>
> >> There is no information what's up (comnand line or logs) so I don't kn=
ow what to do.
> >>
> >>
> >>
> >> I describe bellow the whole procedure:
> >>
> >> 1.
> >> There ist a working Raid1 array:
> >>
> >> # cat /proc/mdstat
> >>
> >> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [=
raid4]
> >> [raid10]
> >> md0 : active raid1 sda3[2] sdb3[3]
> >>         115999672 blocks super 1.0 [2/2] [UU]
> >>         bitmap: 0/1 pages [0KB], 65536KB chunk
> >>
> >> # mdadm --detail /dev/md0
> >>
> >> /dev/md0:
> >>           Version : 1.0
> >>     Creation Time : Wed Aug  1 15:45:56 2012
> >>        Raid Level : raid1
> >>        Array Size : 115999672 (110.63 GiB 118.78 GB)
> >>     Used Dev Size : 115999672 (110.63 GiB 118.78 GB)
> >>      Raid Devices : 2
> >>     Total Devices : 2
> >>       Persistence : Superblock is persistent
> >>
> >>     Intent Bitmap : Internal
> >>
> >>       Update Time : Mon Aug 20 11:10:00 2012
> >>             State : active
> >>    Active Devices : 2
> >> Working Devices : 2
> >>    Failed Devices : 0
> >>     Spare Devices : 0
> >>
> >>              Name : linux:0
> >>              UUID : b7407176:2e88c73d:2c85e940:05ff7e06
> >>            Events : 5897
> >>
> >>       Number   Major   Minor   RaidDevice State
> >>          3       8       19        0      active sync   /dev/sdb3
> >>          2       8        3        1      active sync   /dev/sda3
> >>
> >>
> >> 2.
> >> I remove (phisicaly) the "/dev/sdb" drive of the box (hot-swap)
> >>
> >> # cat /proc/mdstat
> >>
> >> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [=
raid4]
> >> [raid10]
> >> md0 : active raid1 sda3[2] sdb3[3](F)
> >>         115999672 blocks super 1.0 [2/1] [_U]
> >>         bitmap: 1/1 pages [4KB], 65536KB chunk
> >>
> >> # mdadm --detail /dev/md0
> >> /dev/md0:
> >>           Version : 1.0
> >>     Creation Time : Wed Aug  1 15:45:56 2012
> >>        Raid Level : raid1
> >>        Array Size : 115999672 (110.63 GiB 118.78 GB)
> >>     Used Dev Size : 115999672 (110.63 GiB 118.78 GB)
> >>      Raid Devices : 2
> >>     Total Devices : 2
> >>       Persistence : Superblock is persistent
> >>
> >>     Intent Bitmap : Internal
> >>
> >>       Update Time : Mon Aug 20 11:11:58 2012
> >>             State : active, degraded
> >>    Active Devices : 1
> >> Working Devices : 1
> >>    Failed Devices : 1
> >>     Spare Devices : 0
> >>
> >>              Name : linux:0
> >>              UUID : b7407176:2e88c73d:2c85e940:05ff7e06
> >>            Events : 5908
> >>
> >>       Number   Major   Minor   RaidDevice State
> >>          0       0        0        0      removed
> >>          2       8        3        1      active sync   /dev/sda3
> >>
> >>          3       8       19        -      faulty spare
> >>
> >>
> >> 3.
> >> I insert the drive again - it become "/dev/sdc" instead of "/dev/sdb"
> >>
> >> 4.
> >> And now I do the following to rebuild the array:
> >>
> >> # mdadm /dev/md0 -a /dev/sdc3
> >>
> >> mdadm: /dev/sdc3 reports being an active member for /dev/md0, but a --=
re-add fails.
> >> mdadm: not performing --add as that would convert /dev/sdc3 in to a sp=
are.
> >> mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdc3" f=
irst.
> >>
> >> I have never seen this messages before (on another systems). But this =
is not a
> >> problem. I do, what they suggest:
> >>
> >> # mdadm --zero-superblock /dev/sdc3
> >>
> >> # mdadm --examine /dev/sdc3
> >> mdadm: No md superblock detected on /dev/sdc3.
> >>
> >> 5.
> >> And now I try again rebuild the array:
> >>
> >> # mdadm /dev/md0 -a /dev/sdc3
> >>
> >> ... and nothing happen! No message, no info. I repeat some times the c=
ommand.
> >>
> >> I also try this:
> >>
> >> # mdadm /dev/md0 -a -vv --force /dev/sdc3
> >>
> >> ... also nothing. Somethimes, if I repeat the command one by one, in l=
ogs appear
> >> the line:
> >>
> >> Aug 20 11:30:52 serwer-linmot kernel: [ 1978.111282] md: export_rdev(s=
dc3)
> >>
> >> ... and nothing else
> >>
> >>
> >> # mdadm --examine /dev/sdc3
> >> /dev/sdc3:
> >>             Magic : a92b4efc
> >>           Version : 1.0
> >>       Feature Map : 0x1
> >>        Array UUID : b7407176:2e88c73d:2c85e940:05ff7e06
> >>              Name : linux:0
> >>     Creation Time : Wed Aug  1 15:45:56 2012
> >>        Raid Level : raid1
> >>      Raid Devices : 2
> >>
> >>    Avail Dev Size : 231999344 (110.63 GiB 118.78 GB)
> >>        Array Size : 231999344 (110.63 GiB 118.78 GB)
> >>      Super Offset : 231999472 sectors
> >>             State : clean
> >>       Device UUID : f1a1f291:e10d85cc:b574c6d2:45fc0c5d
> >>
> >> Internal Bitmap : -8 sectors from superblock
> >>       Update Time : Mon Aug 20 11:17:07 2012
> >>          Checksum : 71bcac04 - correct
> >>            Events : 0
> >>
> >>
> >>      Device Role : spare
> >>      Array State : .A ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >>
> >> # mdadm --detail /dev/md0
> >>
> >> /dev/md0:
> >>           Version : 1.0
> >>     Creation Time : Wed Aug  1 15:45:56 2012
> >>        Raid Level : raid1
> >>        Array Size : 115999672 (110.63 GiB 118.78 GB)
> >>     Used Dev Size : 115999672 (110.63 GiB 118.78 GB)
> >>      Raid Devices : 2
> >>     Total Devices : 2
> >>       Persistence : Superblock is persistent
> >>
> >>     Intent Bitmap : Internal
> >>
> >>       Update Time : Mon Aug 20 11:18:43 2012
> >>             State : active, degraded
> >>    Active Devices : 1
> >> Working Devices : 1
> >>    Failed Devices : 1
> >>     Spare Devices : 0
> >>
> >>              Name : linux:0
> >>              UUID : b7407176:2e88c73d:2c85e940:05ff7e06
> >>            Events : 5946
> >>
> >>       Number   Major   Minor   RaidDevice State
> >>          0       0        0        0      removed
> >>          2       8        3        1      active sync   /dev/sda3
> >>
> >>          3       8       19        -      faulty spare
> >>
> >>
> >> Can anyone help?
> >>
> >
> > I cannot see why that would happen.
> > It seems to be failing somewhere in bind_rdev_to_array, but I don't know
> > where.
> > Can you run
> >    strace -o /tmp/strace mdadm /dev/md0 --add /dev/sdc3
> > and post the output ... or at last the tail end of the output.  There s=
hould
> > be an ioctl which fails and I need to know what the error was (EEXIST,
> > EINVAL, ENOSPC are the likely ones).  But don't just post that line, in=
clude
> > at least the last 100 lines.
> >
> > NeilBrown
>=20
> Hi,
>=20
> Thank You for help. The complete strace output is in attachement.
>=20
> Sergiusz
>=20
>=20
lseek(4, 118783725568, SEEK_SET)        =3D 118783725568
ioctl(4, BLKSSZGET, 0x7fff73de3fec)     =3D 0
write(4, "bitm\4\0\0\0\267@qv.\210\307=3D,\205\351@\5\377~\6\303-\0\0\0\0\0=
\0"..., 512) =3D -1 EINVAL (Invalid argument)


Oh, I remember now.  That bug.
Fixed by commit 6ef89052d85b8137b8a7100f which is in 3.2.4.

http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3D6ef89052d85b81=
37b8a7100f

NeilBrown



--Sig_/FJi6VO/hL63P7YLSDLjh5uD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDNFMDnsnt1WYoG5AQJvrhAAg+4x/X4EJwKT+NU16SVQJwurpyb+qUYt
j/fzTLXoOyHG7CjN1+XzOKEDR8tgQZIDUOLqugJSxDU9N021ixUjmkK0ITo5RDkm
SnzfPY8+c4Vxv/DSqn3oGCsgqr/vLcsH1cNJZUN5/QbO38v98hOkmH8VOB5qveFU
yXmpA2TZZu7hWnJ91F70U9HYReemM/gtcF3+TTGqLRbK+mV9qPUcXtw8mkyMjErk
KMVXDySU/1OaStyWetIoswuM7WRoAjrPiNXMa2+mWxkCPSKuPnaUUUOpci/iZh24
V/R+zDO/t7T7W419x0lK5pLDUc1KduPfRDWkEr4++Nr1gbhy7VS5ze1RrWamGNPi
fH+JATytwwin3eInNs5S3Qd8GA6Vp+mdKh++xwdp8TZC0FSSqOAMgDimJMKwmKDo
gK7srGHmCxVkJcJF9Dd10q6yKs80Skck41eqOkBVYUm10KxQSAuggMtFNOp3lwT5
yWSURWzpZtROupHwCHVckM6MXx/WAV2rufwKV25CiskYQJ43JGziOZyRY0jknt3v
b1KHWG756GW8iGMawiRm8sJpPsK966Wk5c2nQzwi/TmsUAiNJxNxPnmsgyRiPtzh
iQDIaix7klym0qkqKznSerp9gOWqzFhHZaFqo2rpXMv0aC4rhl7ZTiT0yIsSMyBe
Ie7HjBZq2oU=
=hg2/
-----END PGP SIGNATURE-----

--Sig_/FJi6VO/hL63P7YLSDLjh5uD--
