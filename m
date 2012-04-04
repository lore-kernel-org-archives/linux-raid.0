From: NeilBrown <neilb@suse.de>
Subject: Re: Help to assemble raid5 - no superblock!
Date: Wed, 4 Apr 2012 21:47:49 +1000
Message-ID: <20120404214749.0988c792@notabene.brown>
References: <CAGmni9oPLr6xg07gn0kVpKM2ysOzM5x+Dx-kBTz2ZDdqV0-VOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/utNiRlnqxI1MJ9mblod7XOm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9oPLr6xg07gn0kVpKM2ysOzM5x+Dx-kBTz2ZDdqV0-VOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/utNiRlnqxI1MJ9mblod7XOm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Apr 2012 08:15:57 -0300 Salatiel Filho <salatiel.filho@gmail.com>
wrote:

> I am having a big problem trying to assemble my raid.
> I can assemble just fine in the old machine (LINUX ARM) where i built
> the raid in the first place, but i am just unable to do in other
> machine (Linux mips). I have no mdadm.conf in both machines.
> I got the following error:
>=20
> # mdadm  -A /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2
> mdadm: no recogniseable superblock on /dev/sda2
> mdadm: /dev/sda2 has no superblock - assembly aborted
>=20
> # cat /var/log/messages | tail
>=20
> Apr  4 08:08:32 (none) kernel: [ 8577.010000] scsi_verify_blk_ioctl: 4
> callbacks suppressed
> Apr  4 08:08:32 (none) kernel: [ 8577.020000] mdadm: sending ioctl
> 400c0910 to a partition!
> Apr  4 08:08:32 (none) kernel: [ 8577.020000] mdadm: sending ioctl
> 400c0910 to a partition!
> Apr  4 08:08:32 (none) kernel: [ 8577.030000] mdadm: sending ioctl
> 20001261 to a partition!
> Apr  4 08:08:32 (none) kernel: [ 8577.040000] mdadm: sending ioctl
> 20001261 to a partition!
> Apr  4 08:08:32 (none) kernel: [ 8577.050000] mdadm: sending ioctl
> 20001261 to a partition!
> Apr  4 08:08:32 (none) kernel: [ 8577.050000] mdadm: sending ioctl
> 20001261 to a partition!
> Apr  4 08:08:32 (none) kernel: [ 8577.270000] mdadm: sending ioctl
> 20001261 to a partition!
> Apr  4 08:08:32 (none) kernel: [ 8577.280000] mdadm: sending ioctl
> 20001261 to a partition!
> Apr  4 08:08:33 (none) kernel: [ 8577.290000] mdadm: sending ioctl
> 20001261 to a partition!
> Apr  4 08:08:33 (none) kernel: [ 8577.290000] mdadm: sending ioctl
> 20001261 to a partition!
>=20
> # fdisk -l  /dev/sda
>=20
> Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
> 255 heads, 63 sectors/track, 182401 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>=20
>    Device Boot      Start         End      Blocks  Id System
> /dev/sda1               1       13055   104857600  83 Linux
> /dev/sda2           13055      182402  1360279960  fd Linux raid autodete=
ct
>=20
>=20
> # fdisk -l  /dev/sdb
>=20
> Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
> 255 heads, 63 sectors/track, 182401 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>=20
>    Device Boot      Start         End      Blocks  Id System
> /dev/sdb1               1       13055   104857600  83 Linux
> Partition 1 does not end on cylinder boundary
> /dev/sdb2           13055      182402  1360279960  fd Linux raid autodete=
ct
> Partition 2 does not end on cylinder boundary
>=20
> # fdisk -l /dev/sdc
>=20
> Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes
> 255 heads, 63 sectors/track, 182401 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>=20
>    Device Boot      Start         End      Blocks  Id System
> /dev/sdc1               1       13055   104857600  83 Linux
> /dev/sdc2           13055      182402  1360279960  fd Linux raid autodete=
ct
>=20
>=20
> # cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> unused devices: <none>
>=20
>=20
>=20
> # lsmod | grep -i 'md\|raid'
> raid456                47584  0
> async_raid6_recov        896  1 raid456
> async_pq                1536  1 raid456
> raid6_pq               74752  2 async_raid6_recov,async_pq
> async_xor                976  2 raid456,async_pq
> async_memcpy             560  1 raid456
> async_tx                 832  5
> raid456,async_raid6_recov,async_pq,async_xor,async_memcpy
> raid1                  24304  0
> md_mod                 88816  2 raid456,raid1
> md5                     1424  0
> crypto_hash             7888  3 dm_crypt,sha1_generic,md5
>=20
>=20
>=20
> # uname -a
>=20
> Linux router 3.2.9 #16 Sun Mar 25 16:31:49 BRT 2012 mips GNU/Linux
>=20
>=20
> Any help ?

ARM is little-endian
MIPS ?? is that bigendian?

What does
   mdadm -E --metadata=3D0.swap /dev/sda2
report?


If it is something useful, then try adding
   --update=3Dbyteorder
to the "mdadm -A" command.

NeilBrown


--Sig_/utNiRlnqxI1MJ9mblod7XOm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3w05Tnsnt1WYoG5AQJIkg/9Es7eMSrm+qevTtPc8+LERPyfTKpUtTxu
HcAg1CONZYosVaj67IHKx30QuDKCTXfIWnMmX09SnPhyPFwKWmh9TAEYpXkYvU/8
x7No2/Akzo5bQLZPc0vADfdyYxNYtAGbbn343snHWgFc1hBcHZXJKsdWPxUgvDDM
2axeFy29iCdTLqhJ17UnR8+Q1u0dAaLDvzTJtKUZ9T6t7QD21UuAiSMHrKP2P7zg
YAhUmGE87sHVo1V06xaiZafqMl3Hd5oeTfxRJ9fIMNX2Yd1P7g7UASjTH2ansU5q
s9dTC+FIp/1qPoND+cRnChym43mlJe73qCKQaOiXfeYWnIc9Ugh7hS0YImB+MHF3
NV9QvzK0+F8l2hqHm7MnPWg32R6nBqO7E54qvCRfOhMH6bwozKs+of7aI0Y13nsT
yf0UpyyfbacGHdJStEBo5RW/q35GnlegsmGXds9gZL39yDsJ7TSlIm4O9287gsGs
CKXyDF4l2OOse5+5XZ2AIwv8Kz/0EGpq5IvMEEiwT9/k595t9KYeYzHJU1i8HtBC
5byQzutLJp2vapvzmKPpwCfbdEuTuUL5WZxo4VImkGF10drCYhdId5goDY/SdhnU
UE4BHlQkKlOdWi4HY70UJOqN6Tjy+pqan+6PHHVd1s7l/IBLJwextBUmbxlvCV+6
vn32ngEf+qo=
=W+Ka
-----END PGP SIGNATURE-----

--Sig_/utNiRlnqxI1MJ9mblod7XOm--
