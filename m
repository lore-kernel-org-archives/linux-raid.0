From: Michael Ole Olsen <gnu@gmx.net>
Subject: slow mdadm reshape, normal?
Date: Thu, 11 Jun 2009 00:40:55 +0200
Message-ID: <20090610224055.GW30825@rlogin.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eLe8FOcWSbbyMVJD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--eLe8FOcWSbbyMVJD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

is it normal that a raid5 reshape happens at only 7000kB/s on
newer disks? i created the array at 60MB/s stable over the whole array
(accordin to /proc/mdstat), sometimes up to 90MB/s

chunk size is 64kB, disks are 9xst1500 (1.5tb seagate with upgraded=20
firmware CC1H /SD1A)

the hardware is a pci 32bit 4port sata and onboard sata2 (6 port sata - non
ide host board) if that explains it?

modules are sata_nv and sata_sil

I have lvm2 and xfs+2TB data on top of md before the growing of two new=20
disks from 7 to 9.

perhaps this speed is normal?=20

I have tried echoing various things into proc and sys, no luck there

Any ideas?

my apology for the direct mailing, Niel :)
and sorry to everyone for wasting bandwidth with this lengthy mail if its n=
ormal :)


Here is the build+reshape log:
-------------------------------------------

while creating the raid5 as normal (the new disks has not been growed yet)

mfs:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd[7](S) sdb[8](S) sda[0] sdi[9] sdh[5] sdg[4] sdf[3] s=
de[2] sdc[1]
      8790830976 blocks level 5, 64k chunk, algorithm 2 [7/6] [UUUUUU_]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>....]  recovery =3D=
 82.5% (1209205112/1465138496) finish=3D71.5min speed=3D59647K/sec

unused devices: <none>
mfs:~# df
Filesystem           1K-blocks      Used Available Use% Mounted on
cpq:/diskless/mws    284388032 225657236  58730796  80% /
tmpfs                  1817684         0   1817684   0% /lib/init/rw
udev                     10240        84     10156   1% /dev
tmpfs                  1817684         0   1817684   0% /dev/shm
/dev/mapper/st1500-bigdaddy
                     8589803488 2041498436 6548305052  24% /bigdaddy
cpq:/home/diskless/tftp/kernels/src
                     284388096 225657216  58730880  80% /usr/src
mfs:~# umount /bigdaddy/
mfs:~# mdadm --stop /dev/md0
mdadm: fail to stop array /dev/md0: Device or resource busy
mfs:~# mdadm --grow /dev/md0 --raid-devices=3D9
mdadm: Need to backup 1536K of critical section..
mdadm: /dev/md0: failed to find device 6. Array might be degraded.
 --grow aborted
(reverse-i-search)`for': vi /home/michael/.forward
mfs:~# for i in a b c d e f g h i; do echo sd$i;dd if=3D/dev/sd$i of=3D/dev=
/null bs=3D1M count=3D200;done
sda
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 2,46597 s, 85,0 MB/s
sdb
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 1,66641 s, 126 MB/s
sdc
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 2,51205 s, 83,5 MB/s
sdd
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 2,33702 s, 89,7 MB/s
sde
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 1,62686 s, 129 MB/s
sdf
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 1,66326 s, 126 MB/s
sdg
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 1,59947 s, 131 MB/s
sdh
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 1,66347 s, 126 MB/s
sdi
200+0 records in
200+0 records out
209715200 bytes (210 MB) copied, 1,6167 s, 130 MB/s

mfs:/usr/share/doc/mdadm# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.91
  Creation Time : Tue Jun  9 21:56:04 2009
     Raid Level : raid5
     Array Size : 8790830976 (8383.59 GiB 9001.81 GB)
  Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jun 11 00:26:26 2009
          State : clean, recovering
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Reshape Status : 13% complete
  Delta Devices : 2, (7->9)

           UUID : 5f206395:a6c11495:9091a83d:f5070ca0 (local to host mfs)
         Events : 0.139246

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       32        1      active sync   /dev/sdc
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf
       4       8       96        4      active sync   /dev/sdg
       5       8      112        5      active sync   /dev/sdh
       6       8      128        6      active sync   /dev/sdi
       7       8       48        7      active sync   /dev/sdd
       8       8       16        8      active sync   /dev/sdb


reshaping (used --grow with two new disks and 9 total)

mfs:/usr/share/doc/mdadm# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd[7] sdb[8] sda[0] sdi[6] sdh[5] sdg[4] sdf[3] sde[2] =
sdc[1]
      8790830976 blocks super 0.91 level 5, 64k chunk, algorithm 2 [9/9] [U=
UUUUUUUU]
      [>....................]  reshape =3D  0.4% (6599364/1465138496) finis=
h=3D3009.7min speed=3D8074K/sec

unused devices: <none>
mfs:/usr/share/doc/mdadm# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd[7] sdb[8] sda[0] sdi[6] sdh[5] sdg[4] sdf[3] sde[2] =
sdc[1]
      8790830976 blocks super 0.91 level 5, 64k chunk, algorithm 2 [9/9] [U=
UUUUUUUU]
      [>....................]  reshape =3D  0.4% (6611448/1465138496) finis=
h=3D3057.7min speed=3D7947K/sec

unused devices: <none>

mfs:/usr/share/doc/mdadm# echo 20000 > /proc/sys/dev/raid/speed_limit_min

mfs:/usr/share/doc/mdadm# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd[7] sdb[8] sda[0] sdi[6] sdh[5] sdg[4] sdf[3] sde[2] =
sdc[1]
      8790830976 blocks super 0.91 level 5, 64k chunk, algorithm 2 [9/9] [U=
UUUUUUUU]
      [>....................]  reshape =3D  0.6% (9161780/1465138496) finis=
h=3D3611.7min speed=3D6717K/sec

unused devices: <none>
mfs:/usr/share/doc/mdadm# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid5 sdd[7] sdb[8] sda[0] sdi[6] sdh[5] sdg[4] sdf[3] sde[2] =
sdc[1]
      8790830976 blocks super 0.91 level 5, 64k chunk, algorithm 2 [9/9] [U=
UUUUUUUU]
      [>....................]  reshape =3D  2.8% (41790784/1465138496) fini=
sh=3D3786.7min speed=3D6261K/sec


unused devices: <none>

mfs:/usr/share/doc/mdadm# echo 25000 > /proc/sys/dev/raid/speed_limit_min
mfs:/usr/share/doc/mdadm# echo 400000 >/proc/sys/dev/raid/speed_limit_max

mfs:/usr/share/doc/mdadm# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid5 sdd[7] sdb[8] sda[0] sdi[6] sdh[5] sdg[4] sdf[3] sde[2] =
sdc[1]
      8790830976 blocks super 0.91 level 5, 64k chunk, algorithm 2 [9/9] [U=
UUUUUUUU]
      [=3D=3D>..................]  reshape =3D 13.6% (200267648/1465138496)=
 finish=3D3044.2min speed=3D6922K/sec

mfs:/usr/share/doc/mdadm# lsmod
Module                  Size  Used by
ext3                  106356  0=20
jbd                    40164  1 ext3
mbcache                 6872  1 ext3
ipv6                  198960  26=20
xfs                   435712  0=20
exportfs                3628  1 xfs
raid456               116508  1=20
async_xor               1936  1 raid456
async_memcpy            1408  1 raid456
async_tx                2396  3 raid456,async_xor,async_memcpy
xor                    13936  2 raid456,async_xor
md_mod                 72944  2 raid456
dm_mod                 45188  4=20
sd_mod                 20916  9=20
sata_sil                8180  3=20
sata_nv                19468  6=20
ehci_hcd               28944  0=20
ohci_hcd               19464  0=20
libata                148672  2 sata_sil,sata_nv
i2c_nforce2             5804  0=20
scsi_mod               91884  2 sd_mod,libata
usbcore               106508  2 ehci_hcd,ohci_hcd
i2c_core               20640  1 i2c_nforce2

mfs:/usr/share/doc/mdadm# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   1980   648 ?        Ss   Jun10   0:00 init [2]  =
  =20
root         2  0.0  0.0      0     0 ?        S<   Jun10   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S<   Jun10   0:00 [migration=
/0]
root         4  0.0  0.0      0     0 ?        S<   Jun10   0:00 [ksoftirqd=
/0]
root         5  0.0  0.0      0     0 ?        S<   Jun10   0:00 [migration=
/1]
root         6  0.0  0.0      0     0 ?        S<   Jun10   0:00 [ksoftirqd=
/1]
root         7  0.0  0.0      0     0 ?        S<   Jun10   0:00 [events/0]
root         8  0.0  0.0      0     0 ?        S<   Jun10   0:00 [events/1]
root         9  0.0  0.0      0     0 ?        S<   Jun10   0:00 [work_on_c=
pu/0]
root        10  0.0  0.0      0     0 ?        S<   Jun10   0:00 [work_on_c=
pu/1]
root        11  0.0  0.0      0     0 ?        S<   Jun10   0:00 [khelper]
root        76  0.0  0.0      0     0 ?        S<   Jun10   0:32 [kblockd/0]
root        77  0.0  0.0      0     0 ?        S<   Jun10   0:01 [kblockd/1]
root        78  0.0  0.0      0     0 ?        S<   Jun10   0:00 [kacpid]
root        79  0.0  0.0      0     0 ?        S<   Jun10   0:00 [kacpi_not=
ify]
root       187  0.0  0.0      0     0 ?        S<   Jun10   0:00 [kseriod]
root       236  1.5  0.0      0     0 ?        S<   Jun10  22:28 [kswapd0]
root       278  0.0  0.0      0     0 ?        S<   Jun10   0:00 [aio/0]
root       279  0.0  0.0      0     0 ?        S<   Jun10   0:00 [aio/1]
root       283  0.0  0.0      0     0 ?        S<   Jun10   0:00 [nfsiod]
root       998  0.0  0.0      0     0 ?        S<   Jun10   0:01 [rpciod/0]
root       999  0.0  0.0      0     0 ?        S<   Jun10   0:00 [rpciod/1]
root      1087  0.0  0.0   2144   764 ?        S<s  Jun10   0:00 udevd --da=
emon
root      2041  0.0  0.0      0     0 ?        S<   Jun10   0:00 [ksuspend_=
usbd]
root      2045  0.0  0.0      0     0 ?        S<   Jun10   0:00 [khubd]
root      2091  0.0  0.0      0     0 ?        S<   Jun10   0:00 [ata/0]
root      2092  0.0  0.0      0     0 ?        S<   Jun10   0:00 [ata/1]
root      2093  0.0  0.0      0     0 ?        S<   Jun10   0:00 [ata_aux]
root      2106  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_0]
root      2107  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_1]
root      2108  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_2]
root      2109  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_3]
root      2116  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_4]
root      2117  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_5]
root      2190  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_6]
root      2191  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_7]
root      2194  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_8]
root      2195  0.0  0.0      0     0 ?        S<   Jun10   0:00 [scsi_eh_9]
root      2420  0.0  0.0      0     0 ?        S<   Jun10   0:00 [kstriped]
root      2460 18.6  0.0      0     0 ?        S<   Jun10 271:03 [md0_raid5]
root      2482  0.0  0.0      0     0 ?        S<   Jun10   0:00 [kdmflush]
root      2518  0.0  0.0      0     0 ?        S<   Jun10   0:00 [xfs_mru_c=
ache]
root      2522  0.0  0.0      0     0 ?        S<   Jun10   0:03 [xfslogd/0]
root      2523  0.0  0.0      0     0 ?        S<   Jun10   0:00 [xfslogd/1]
root      2524  0.4  0.0      0     0 ?        S<   Jun10   6:45 [xfsdatad/=
0]
root      2525  0.0  0.0      0     0 ?        S<   Jun10   0:23 [xfsdatad/=
1]
daemon    2581  0.0  0.0   1764   444 ?        Ss   Jun10   0:00 /sbin/port=
map
statd     2592  0.0  0.0   1824   624 ?        Ss   Jun10   0:00 /sbin/rpc.=
statd
root      2747  0.0  0.0   5272   916 ?        Ss   Jun10   0:00 /usr/sbin/=
sshd
root      3025  0.0  0.0   3080   600 ?        S    Jun10   0:00 /usr/sbin/=
smartd --pidfile /var/run/smartd.pid --interval=3D1800
ntp       3038  0.0  0.0   4132  1044 ?        Ss   Jun10   0:00 /usr/sbin/=
ntpd -p /var/run/ntpd.pid -u 105:105 -g
root      3048  0.0  0.0   2012   572 ?        Ss   Jun10   0:00 /sbin/mdad=
m --monitor --pid-file /var/run/mdadm/monitor.pid --daemonise --scan --sysl=
og
root      3060  0.0  0.0      0     0 ?        S<   Jun10   0:00 [lockd]
root      3064  0.0  0.0   1644   504 tty1     Ss+  Jun10   0:00 /sbin/gett=
y 38400 tty1
root      3067  0.0  0.0   1644   496 tty2     Ss+  Jun10   0:00 /sbin/gett=
y 38400 tty2
root      3074  0.0  0.0   7992  1336 ?        Ss   Jun10   0:00 sshd: mich=
ael [priv]
michael   3076  0.0  0.0   7992  1084 ?        S    Jun10   0:00 sshd: mich=
ael@pts/0
michael   3077  0.0  0.0   4620  1904 pts/0    Ss   Jun10   0:00 -bash
root      3084  0.0  0.0   3636   972 pts/0    S    Jun10   0:00 su
root      3085  0.0  0.0   4132  1740 pts/0    S+   Jun10   0:00 bash
root      3147  0.0  0.0   7992  1336 ?        Ss   Jun10   0:00 sshd: mich=
ael [priv]
michael   3149  0.0  0.0   8140  1068 ?        S    Jun10   0:06 sshd: mich=
ael@pts/1
michael   3150  0.0  0.0   4632  1924 pts/1    Ss   Jun10   0:00 -bash
root      3283  0.0  0.0   3636   976 pts/1    S    Jun10   0:00 su
root      3284  0.0  0.0   4160  1776 pts/1    S    Jun10   0:00 bash
root      3474  0.0  0.0   7924  1316 ?        Ss   Jun10   0:00 /usr/sbin/=
nmbd -D
root      3476  0.0  0.0  13388  2116 ?        Ss   Jun10   0:00 /usr/sbin/=
smbd -D
root      3478  0.0  0.0  13388   892 ?        S    Jun10   0:00 /usr/sbin/=
smbd -D
106       4608  0.0  0.0   6132   924 ?        Ss   Jun10   0:00 /usr/sbin/=
exim4 -bd -q30m
root      4702  0.2  0.0      0     0 ?        S    Jun10   2:35 [pdflush]
root      4707  0.2  0.0      0     0 ?        S    Jun10   2:09 [pdflush]
root      4870  0.0  0.0      0     0 ?        S<   Jun10   0:00 [kdmflush]
root      4966  3.4  0.0      0     0 ?        D<   Jun10  16:12 [md0_resha=
pe]
root      5338  0.0  0.0   3580  1012 pts/1    R+   00:25   0:00 ps aux

mfs:/usr/share/doc/mdadm# w
 00:25:16 up 1 day, 12 min,  2 users,  load average: 1,38, 1,30, 1,27
USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
michael  pts/0    cpq              Wed00    1:06m  0.17s  0.03s sshd: micha=
el [priv]
michael  pts/1    cpq              Wed00    0.00s  0.40s  0.07s sshd: micha=
el [priv]


--eLe8FOcWSbbyMVJD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJKMDZ2AAoJECXlragqp/ZIj08P/1MUthXbMQ990fZpC6jvVUI/
yc/G83FawNZ45UE+Yqh/3I8CTB5CKWEInJLXxgH5iXJKPAMQl7V9Dyz738IG0xuh
Umh0/BCjA2zZcJ60zqHBFxPXRkcs41g6lAbTIuSjGAHfWurB0xNY3ElBDD6JddA7
maW7/1ItB12x28GquKwIYTjLGQH1Xz/UndPN8li4CQ2+SwQz6drSQYyHn6gNjEuL
5jRhyCAmVGUDbnUzaFf1VTIXplCYh5syqeoWFRMWiReAOUFucAOUQz5YsCm74PnP
jLk84P2GzWkQU/lGuFR48SEjebadA2duXh1TL92e0G3Np8gu5TlvB+Oqp2AHM0Zz
Z4X2FblEd3LGAtL6dUOqKlMqBhXbT4/gKtr7AQTgU2ap5fdwhWT625M/IS6lC40r
9BdAJdK4v/aFPcLxotLXEn/JW9759E7kds/cLGXI6d7l8eLFs+1y2HTyFuiyQ1a6
8K3H6Ws8xZZ9/LEohmGa7libM2YcW944buv/vdvGRGq3naf1j4AX92LPAJ2+sTvN
D4QvZNmlzUYfU/4CBfOutoOUqrcAVl1U+EEJNzcGX2XK53n5+KLDubTJ97cSgEFW
hmEY3WCoyp5e3xonUR/J1/RBJBgQZwhpfF+uRXe+Yv3DTueu4KIQVbGBCZ9Mz0MN
qlF38y65ot7mg0S3wEuk
=9eZ8
-----END PGP SIGNATURE-----

--eLe8FOcWSbbyMVJD--
