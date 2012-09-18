From: NeilBrown <neilb@suse.de>
Subject: Re: MD device always starting as /dev/md127
Date: Wed, 19 Sep 2012 09:44:32 +1000
Message-ID: <20120919094432.040013d4@notabene.brown>
References: <CAJ72viOHn_TxQ_gB7mp9Nu1ac+VBR96tCecOeOYJoXEfNvEw+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+Zst5L21olJOd3UW1Z5S.xx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viOHn_TxQ_gB7mp9Nu1ac+VBR96tCecOeOYJoXEfNvEw+g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+Zst5L21olJOd3UW1Z5S.xx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Sep 2012 19:19:53 -0400 Bryan Bush <bbushvt@gmail.com> wrote:

> I've moved the drives from one system to another and when the array
> starts up its always /dev/md127.
> /etc/mdadm/mdadm.conf has:
>=20
>=20
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
>=20
> # by default (built-in), scan all partitions (/proc/partitions) and all
> # containers for MD superblocks. alternatively, specify devices to scan, =
using
> # wildcards if desired.
> DEVICE partitions containers
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
> ARRAY /dev/md1 level=3Draid6 metadata=3D1.2 num-devices=3D13
> UUID=3Dfa32e2c5:e7bda20b:32af7c90:c7ee61eb
>=20
>=20
> mdadm --detail gives me
>=20
>=20
>=20
> /dev/md127:
>         Version : 1.2
>   Creation Time : Sat Sep 18 17:05:52 2010
>      Raid Level : raid6
>      Array Size : 21488647488 (20493.17 GiB 22004.38 GB)
>   Used Dev Size : 1953513408 (1863.02 GiB 2000.40 GB)
>    Raid Devices : 13
>   Total Devices : 13
>     Persistence : Superblock is persistent
>=20
>     Update Time : Tue Sep 18 17:40:47 2012
>           State : clean
>  Active Devices : 13
> Working Devices : 13
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            Name : 1
>            UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
>          Events : 56603
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8      177        0      active sync   /dev/sdl1
>       14       8      161        1      active sync   /dev/sdk1
>        2       8       81        2      active sync   /dev/sdf1
>        3       8      145        3      active sync   /dev/sdj1
>        4       8      209        4      active sync   /dev/sdn1
>        8       8       65        5      active sync   /dev/sde1
>        6       8       49        6      active sync   /dev/sdd1
>        7       8       33        7      active sync   /dev/sdc1
>       13       8      225        8      active sync   /dev/sdo1
>       15      65       17        9      active sync   /dev/sdr1
>       11      65        1       10      active sync   /dev/sdq1
>       10       8      241       11      active sync   /dev/sdp1
>        9       8      193       12      active sync   /dev/sdm1
>=20
>=20
> If I do
> mdadm --stop /dev/md127
> then
> mdadm --assemble --scan
> It starts the array at /dev/md1
>=20
> Any idea why it always starts as md127?
>

My guess is that it is being started while the initrd is running, and the
initrd doesn't have that mdadm.conf.
So mdadm doesn't know what number to associated with the uuid, and so choos=
es
an unused one.

The metadata does say "Name : 1", but that isn't trusted unless there is so=
me
reason to believe that the array belongs to "this" host.

If you:
  mdadm -S /dev/md127
  mdadm -A /dev/md1 --update=3Dname /dev/sd[lkfjnedcorqpm]1
then it should update the metadata so that it is known to belong to "this"
host.  Then providing that the hostname is set during the initrd, it should
get the right name.
Or maybe arrange for the ARRAY entry to appear in the mdadm.conf in the
initrd.

NeilBrown


--Sig_/+Zst5L21olJOd3UW1Z5S.xx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFkHYDnsnt1WYoG5AQLemw/+O3BNyJBow/BvGSED26SFnRtpfnhN4J78
jNy52SCZt5pVqQfLAFnCjdd2VJ/eR+BpXcoemwLhjiFLNRpEV63HtW34N3ye14sg
wPE/5+KStImlZz4M+UR9jadAZ9Keo5PB0ZctW1rTmU/f1XKKASzNivBJYD6PZF5K
cg1Q+QR+vlzuqhHjM1gAn32jNMmfCWxVtuonheofK7GRQdbvu0aWHNQHLAmpLOVF
30bnXbsNEIab6DHas2XCaPZXL3kQ8NgS1LRNVD4E49ZAV2+pRv7r7dMGicf2J/RY
ykLW34WHLzyBsjrYL5zzPHRMSnGsQN/voIpkWXOgoBiw3ZJPd4xNnF3IcibWdd5s
UUXxThkly3YMJk9K8+u4C1PGv25IWi7yDcpx5ZzP4VR3EA8bEq0s0dti5Z3R0io5
DE5Vui1oALk1gJv9deqSGabqx4ynOf+IqB7EN8SLvPgBRKzWUcrMuR4mO2B0qLKY
Pzvh2b8G2eq1cDPfKqCqKIAZKELWMo41n74J7F046/nqlNc2zcc4bBQ5DbiZ4GN+
byj2LedjR+S71B5PA4Q9Bh4EcSpcbtJ1t+XGadnE57rJHPuA9qwyVksqz5Z9bOld
uWuiIsms85TMWlAoNCD82W8vC9onon38mtFJaxH+epvf8XMx8cSn8nK990iG/93O
QKqVnRNBMNQ=
=ganx
-----END PGP SIGNATURE-----

--Sig_/+Zst5L21olJOd3UW1Z5S.xx--
