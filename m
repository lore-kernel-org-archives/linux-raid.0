From: Emanuel Domingos <emanuelsdrock@gmail.com>
Subject: Re: Recovery Raid6 Degraded
Date: Tue, 14 Apr 2015 09:58:35 -0300
Message-ID: <CACsoFmjG5UMd3Qv2Z82qmfTQkNRa+66McVN3p=Tsei4T1HZ1ig@mail.gmail.com>
References: <CACsoFmjWW7mqSA8OKZZEPhpFidf-exSMm771ZOp0TssSYydcrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsoFmjWW7mqSA8OKZZEPhpFidf-exSMm771ZOp0TssSYydcrw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, Mikael, hi guys!


=46ollow the errors found after building the new version of mdadm:

#mdadm --stop /dev/md/ubuntu\:md-raid6_primary

#mdadm --assemble --force /dev/md/ubuntu\:md-raid6_primary /dev/sdaa
/dev/sdac /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdz

mdadm: device /dev/md/ubuntu:md-raid6_primary exists but is not an md a=
rray.


DMESG

[661924.167503] md: md123 stopped.
[661924.167513] md: unbind<sdi>
[661924.184248] md: export_rdev(sdi)
[661924.184259] md: unbind<sdj>
[661924.184324] md: export_rdev(sdj)
[661924.184335] md: unbind<sdg>
[661924.188227] md: export_rdev(sdg)
[661924.188248] md: unbind<sdh>
[661924.192285] md: export_rdev(sdh)
[661924.192296] md: unbind<sdf>
[661924.192364] md: export_rdev(sdf)
[661924.192375] md: unbind<sdz>
[661924.264120] md: export_rdev(sdz)
[661924.264133] md: unbind<sdaa>
[661924.264456] md: export_rdev(sdaa)
[661924.264467] md: unbind<sdac>
[661924.272138] md: export_rdev(sdac)

2015-04-13 16:59 GMT-03:00 Emanuel Domingos <emanuelsdrock@gmail.com>:
> guys, following guidelines on wiki, before to try recreate my array
> I'm sending this mail to listen the experts.
>
> I would like to aid as a problem in my raid arrays after a crash in
> which I had to restart the server.
>
> After the restart, the situation was as follows:
>
> # ls -lh /dev/md/
>
> lrwxrwxrwx 1 root root  8 Apr  6 17:35 ubuntu:md-flash -> ../md125
> lrwxrwxrwx 1 root root 10 Apr  6 17:34 ubuntu:md-raid6_2 -> /dev/md12=
7
> lrwxrwxrwx 1 root root  8 Apr  6 17:35 ubuntu:md-raid6-bacula -> ../m=
d126
> lrwxrwxrwx 1 root root 10 Apr  6 17:34 ubuntu:md-raid6_primary -> /de=
v/md124
>
> # cat /proc/mdstat
>
> md124 : inactive sdh[2] sdf[0] sdg[1]
>       5860540680 blocks super 1.2
>
> md125 : active (auto-read-only) raid1 sdag[1]
>       97684688 blocks super 1.2 [2/1] [_U]
>
> md126 : active (auto-read-only) raid6 sdad[1] sdv[2] sdy[5] sdw[3] sd=
x[4]
>       7814051840 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [6/5] [_UUUUU]
>
> md127 : inactive sdd[13] sdc[15] sde[14] sda[10] sdb[11] sdt[4] sdr[2=
]
> sdq[1] sdm[7] sdk[5] sdo[9] sdn[8]
>       23442162720 blocks super 1.2
>
>
> Did anyone some tip for me? My focus is to restore 'primary' raid fow=
 now.
> for now
> My hardware is 2 pci express sata contollers conected each one on tow
> 5x1 sata multiplexer.
>
> Follow detail /dev/md124:
>
> # mdadm --detail /dev/md124
>
>         Version : 1.2
>   Creation Time : Thu Sep 27 11:39:20 2012
>      Raid Level : raid6
>   Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
>    Raid Devices : 8
>   Total Devices : 3
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Apr  6 04:09:06 2015
>           State : active, FAILED, Not Started
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>            Name : ubuntu:md-raid6_primary  (local to host ubuntu)
>            UUID : cee8d180:d6275a41:599064c6:8894819e
>          Events : 1093684
>
>     Number   Major   Minor   RaidDevice State
>        0       8       80        0      active sync   /dev/sdf
>        1       8       96        1      active sync   /dev/sdg
>        2       8      112        2      active sync   /dev/sdh
>        3       0        0        3      removed
>        4       0        0        4      removed
>        5       0        0        5      removed
>        6       0        0        6      removed
>        7       0        0        7      removed
>
>
> I tried to assemble with "mdadm --assemble --force
> /dev/md/ubuntu\:md-raid6_primary /dev/sdaa /dev/sdac /dev/sdf /dev/sd=
g
> /dev/sdh /dev/sdi /dev/sdj /dev/sdz" ('primary' raid) but my result
> was this
>
> cat /proc/mdstat after mdadm --assemble...
>
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md123 : inactive sdi[3](S) sdj[8](S) sdg[1](S) sdh[2](S) sdf[0](S)
> sdz[5](S) sdaa[6](S) sdac[7](S)
>       15628108480 blocks super 1.2
>
> md125 : active (auto-read-only) raid1 sdag[1]
>       97684688 blocks super 1.2 [2/1] [_U]
>
> md126 : active raid6 sdad[1] sdv[2] sdy[5] sdw[3] sdx[4]
>       7814051840 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [6/5] [_UUUUU]
>
> md127 : inactive sdd[13] sdc[15] sde[14] sda[10] sdb[11] sdt[4] sdr[2=
]
> sdq[1] sdm[7] sdk[5] sdo[9] sdn[8]
>       23442162720 blocks super 1.2
>
> unused devices: <none>
>
>
> Detail for /dev/md123
>
> #mdadm --detail /dev/123 shows the output:
>
> mdadm: md device /dev/md123 does not appear to be active.
>
>
> The name change /dev/md124 -> /dev/md123. output ls -lh /dev/md
>
> #ls -lh /dev/md
>
> lrwxrwxrwx 1 root root  8 Apr  6 17:35 ubuntu:md-flash -> ../md125
> lrwxrwxrwx 1 root root 10 Apr  6 17:34 ubuntu:md-raid6_2 -> /dev/md12=
7
> lrwxrwxrwx 1 root root  8 Apr  6 17:35 ubuntu:md-raid6-bacula -> ../m=
d126
> lrwxrwxrwx 1 root root 10 Apr  6 17:34 ubuntu:md-raid6_primary -> /de=
v/md124
>
>
> LIST OF DISKS:
>
> ARRAY PRIMARY (md-raid6_primary)
>
> /dev/sdaa
> /dev/sdac
> /dev/sdf
> /dev/sdg
> /dev/sdh
> /dev/sdi
> /dev/sdj
> /dev/sdz
>
> ARRAY BACULA (md-raid6-bacula)
>
> /dev/sdab
> /dev/sdad
> /dev/sdv
> /dev/sdw
> /dev/sdx
> /dev/sdy
>
> ARRAY FLASH (md-flash)
>
> /dev/sdaf
> /dev/sdag
>
> ARRAY SECONDARY (md-raid6_2)
>
> /dev/sda
> /dev/sdb
> /dev/sdc
> /dev/sdd
> /dev/sde
> /dev/sdk
> /dev/sdl
> /dev/sdm
> /dev/sdn
> /dev/sdo
> /dev/sdp
> /dev/sdq
> /dev/sdr
> /dev/sds
> /dev/sdt
>
> OUTPUT dmesg:
>
> [487229.059007] end_request: I/O error, dev sdae, sector 3560087488
> [487249.705034] end_request: I/O error, dev sdae, sector 3560087488
> [572716.092783] end_request: I/O error, dev sdx, sector 1954527040
> [573492.373689] end_request: I/O error, dev sdae, sector 3560087488
> [573513.171095] end_request: I/O error, dev sdae, sector 3560087488
> [573533.807073] end_request: I/O error, dev sdae, sector 3560087488
> [573556.188797] end_request: I/O error, dev sdae, sector 3560087488
> [573576.996265] end_request: I/O error, dev sdae, sector 3560087488
>
> OUTPUT mdadm -E all_devices:
>
> /dev/sdaa:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cee8d180:d6275a41:599064c6:8894819e
>            Name : ubuntu:md-raid6_primary  (local to host ubuntu)
>   Creation Time : Thu Sep 27 11:39:20 2012
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 23442155520 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : f6227bf3:2f25dbde:db6509e4:57a5dbe2
>
>     Update Time : Mon Apr  6 03:53:41 2015
>        Checksum : ea5c72c1 - correct
>          Events : 1093681
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 6
>    Array State : AAA..AAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdac:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cee8d180:d6275a41:599064c6:8894819e
>            Name : ubuntu:md-raid6_primary  (local to host ubuntu)
>   Creation Time : Thu Sep 27 11:39:20 2012
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 23442155520 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 912783f6:c39a8aad:7fb5018a:d4bdd201
>
>     Update Time : Mon Apr  6 03:53:41 2015
>        Checksum : 81035511 - correct
>          Events : 1093681
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 7
>    Array State : AAA..AAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdf:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cee8d180:d6275a41:599064c6:8894819e
>            Name : ubuntu:md-raid6_primary  (local to host ubuntu)
>   Creation Time : Thu Sep 27 11:39:20 2012
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 23442155520 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : f9131d59:1fa41bca:5df029d1:bd5e0158
>
>     Update Time : Mon Apr  6 04:09:06 2015
>        Checksum : 9d762a2f - correct
>          Events : 1093684
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAA..... ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdg:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cee8d180:d6275a41:599064c6:8894819e
>            Name : ubuntu:md-raid6_primary  (local to host ubuntu)
>   Creation Time : Thu Sep 27 11:39:20 2012
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 23442155520 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 4cfae88d:49377cb6:58042dfb:82fa744e
>
>     Update Time : Mon Apr  6 04:09:06 2015
>        Checksum : df19536d - correct
>          Events : 1093684
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : AAA..... ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdh:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cee8d180:d6275a41:599064c6:8894819e
>            Name : ubuntu:md-raid6_primary  (local to host ubuntu)
>   Creation Time : Thu Sep 27 11:39:20 2012
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 23442155520 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : f6a4ada7:207315c0:96a2f83b:9f0199d4
>
>     Update Time : Mon Apr  6 04:09:06 2015
>        Checksum : c966e242 - correct
>          Events : 1093684
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 2
>    Array State : AAA..... ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdi:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cee8d180:d6275a41:599064c6:8894819e
>            Name : ubuntu:md-raid6_primary  (local to host ubuntu)
>   Creation Time : Thu Sep 27 11:39:20 2012
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 23442155520 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 17f6f6ba:25d71c20:7e945a21:d3432130
>
>     Update Time : Mon Mar 30 20:38:33 2015
>        Checksum : 7dad75f8 - correct
>          Events : 1093684
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 3
>    Array State : AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdj:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cee8d180:d6275a41:599064c6:8894819e
>            Name : ubuntu:md-raid6_primary  (local to host ubuntu)
>   Creation Time : Thu Sep 27 11:39:20 2012
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 23442155520 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : eb58254f:fca9077b:37214548:a828733f
>
>     Update Time : Thu Mar 26 04:33:44 2015
>        Checksum : a2fbf51b - correct
>          Events : 1093684
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 4
>    Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>
>
> /dev/sdz:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : cee8d180:d6275a41:599064c6:8894819e
>            Name : ubuntu:md-raid6_primary  (local to host ubuntu)
>   Creation Time : Thu Sep 27 11:39:20 2012
>      Raid Level : raid6
>    Raid Devices : 8
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 23442155520 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 9a71d9ba:0954c58b:49d41aed:6ad7fa48
>
>     Update Time : Mon Apr  6 03:53:41 2015
>        Checksum : cdd590c1 - correct
>          Events : 1093684
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 5
>    Array State : AAA..AAA ('A' =3D=3D active, '.' =3D=3D missing)
>
>
> ARRAY BACULA
>
> /dev/sdab:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 001f075c:ee06ae37:c0969316:a46c843b
>            Name : ubuntu:md-raid6-bacula  (local to host ubuntu)
>   Creation Time : Thu Sep 27 17:15:15 2012
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : fe51b5fd:941292b0:c66da01b:85e972d5
>
>     Update Time : Tue Dec 30 11:46:29 2014
>        Checksum : 8423da96 - correct
>          Events : 439
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdad:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 001f075c:ee06ae37:c0969316:a46c843b
>            Name : ubuntu:md-raid6-bacula  (local to host ubuntu)
>   Creation Time : Thu Sep 27 17:15:15 2012
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 0a39d4dc:d1834661:72ee59e9:1bcd650b
>
>     Update Time : Mon Apr 13 09:59:52 2015
>        Checksum : 184d5e9a - correct
>          Events : 2082350
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : .AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdv:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 001f075c:ee06ae37:c0969316:a46c843b
>            Name : ubuntu:md-raid6-bacula  (local to host ubuntu)
>   Creation Time : Thu Sep 27 17:15:15 2012
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 42fc3b73:ce28a790:321d18d3:14fd029d
>
>     Update Time : Mon Apr 13 10:00:05 2015
>        Checksum : 597125a8 - correct
>          Events : 2082368
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 2
>    Array State : .AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdw:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 001f075c:ee06ae37:c0969316:a46c843b
>            Name : ubuntu:md-raid6-bacula  (local to host ubuntu)
>   Creation Time : Thu Sep 27 17:15:15 2012
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 7c34659e:5c432ccb:80185072:3146a69a
>
>     Update Time : Mon Apr 13 10:00:05 2015
>        Checksum : 5bfabcdc - correct
>          Events : 2082368
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 3
>    Array State : .AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdx:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 001f075c:ee06ae37:c0969316:a46c843b
>            Name : ubuntu:md-raid6-bacula  (local to host ubuntu)
>   Creation Time : Thu Sep 27 17:15:15 2012
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 8e0d1c2b:9e5e86f4:5121676e:ef6b4951
>
>     Update Time : Mon Apr 13 10:00:05 2015
>        Checksum : c4c5eaff - correct
>          Events : 2082368
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 4
>    Array State : .AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdy:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 001f075c:ee06ae37:c0969316:a46c843b
>            Name : ubuntu:md-raid6-bacula  (local to host ubuntu)
>   Creation Time : Thu Sep 27 17:15:15 2012
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 2c061cce:58eff44d:633cce36:22aebbb4
>
>     Update Time : Mon Apr 13 10:00:05 2015
>        Checksum : ed0dc65d - correct
>          Events : 2082368
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 5
>    Array State : .AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> ARRAY FLASH
>
> /dev/sdaf:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 9ae996a5:b8cef013:6163d4f2:e4fc50e9
>            Name : ubuntu:md-flash  (local to host ubuntu)
>   Creation Time : Thu Sep  4 15:58:58 2014
>      Raid Level : raid1
>    Raid Devices : 2
>
>  Avail Dev Size : 234439600 (111.79 GiB 120.03 GB)
>      Array Size : 195369376 (93.16 GiB 100.03 GB)
>   Used Dev Size : 195369376 (93.16 GiB 100.03 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 8242b575:8a255c04:6a9b17a1:c92a3364
>
>     Update Time : Thu Mar 12 19:18:00 2015
>        Checksum : c89e3c42 - correct
>          Events : 149
>
>    Device Role : Active device 0
>    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
>
> /dev/sdag:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 9ae996a5:b8cef013:6163d4f2:e4fc50e9
>            Name : ubuntu:md-flash  (local to host ubuntu)
>   Creation Time : Thu Sep  4 15:58:58 2014
>      Raid Level : raid1
>    Raid Devices : 2
>
>  Avail Dev Size : 195369520 (93.16 GiB 100.03 GB)
>      Array Size : 195369376 (93.16 GiB 100.03 GB)
>   Used Dev Size : 195369376 (93.16 GiB 100.03 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 7aef1a7d:529d6a8e:5d8df6fe:c621fda7
>
>     Update Time : Mon Apr  6 08:41:23 2015
>        Checksum : f99dc861 - correct
>          Events : 1394745
>
>
>    Device Role : Active device 1
>    Array State : .A ('A' =3D=3D active, '.' =3D=3D missing)
>
> ARRAY SECONDARY (2)
>
> /dev/sda:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 5b5f642d:98b070d8:1db552b3:f2cd400d
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : b853be69 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 10
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdae:
>    MBR Magic : aa55
> Partition[0] :   3907029167 sectors at            1 (type ee)
>
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : c6ea8392:7a154f08:514b5790:225afb6d
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : 8b10e35b - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 11
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 7c612542:eaea873e:70998b44:510981c5
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : 7ca51a93 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 12
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdd:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 81c06400:83b34ee6:4ba3f678:73b6383a
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : 8bce0e54 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 13
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sde:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : dff1662e:f4b3d490:759f1c84:0f25bd77
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : ad0095c2 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 14
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdk:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 4419c60e:832defe9:3608aeb5:0c9ad899
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : 3a27146c - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 5
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdl:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 83b744ab:d39a7fa0:790c4745:1a330f22
>
>     Update Time : Mon Apr  6 03:53:16 2015
>        Checksum : a504b986 - correct
>          Events : 1687615
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 6
>    Array State : .AA.AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdm:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 74a5554b:60bc1caf:0f606353:4cd70807
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : 46c9c493 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 7
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdn:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : e922ebba:63a4fd5f:3cf1ed29:6625c141
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : 78830953 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 8
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdo:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : b866bcbd:5b768cae:f280dfd3:a6fa4bb0
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : e25f8412 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 9
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdp:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : d0435b9e:e3be7bc9:066b5f4a:c1bc1879
>
>     Update Time : Sat Mar 14 13:16:16 2015
>        Checksum : 1d09cb6f - correct
>          Events : 343654
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAA.AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdq:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : b3c0ebc7:608cf642:a714996a:1f6f6a43
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : aad0fc37 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdr:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 2a527d72:0042643b:d86fc040:43763b9c
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : 7cc8a5a4 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 2
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sds:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : a13aed14:981145b2:0bfe76a9:e2d39512
>
>     Update Time : Thu Mar 12 04:01:24 2015
>        Checksum : 74f446c3 - correct
>          Events : 111833
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 3
>    Array State : AAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdt:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0aac0176:0d0bfb36:9d06836e:345e031a
>            Name : ubuntu:md-raid6_2  (local to host ubuntu)
>   Creation Time : Thu Sep 27 10:58:00 2012
>      Raid Level : raid6
>    Raid Devices : 15
>
>  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
>      Array Size : 50791336960 (24219.20 GiB 26005.16 GB)
>   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 8c6f02f3:23411071:3fc98d04:d237ed37
>
>     Update Time : Mon Apr  6 04:09:07 2015
>        Checksum : 9278dd21 - correct
>          Events : 1687638
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 4
>    Array State : .AA.AA.AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missi=
ng)
>
> /dev/sdu:
>    MBR Magic : aa55
> Partition[0] :   3907027120 sectors at         2048 (type 83)
>
>
> OUTPUT lshw:
>
>  *-pci
>           description: Host bridge
>           product: 2nd Generation Core Processor Family DRAM Controll=
er
>           vendor: Intel Corporation
>           physical id: 100
>           bus info: pci@0000:00:00.0
>           version: 09
>           width: 32 bits
>           clock: 33MHz
>           configuration: driver=3Dagpgart-intel
>           resources: irq:0
>         *-pci:0
>              description: PCI bridge
>              product: Xeon E3-1200/2nd Generation Core Processor
> Family PCI Express Root Port
>              vendor: Intel Corporation
>              physical id: 1
>              bus info: pci@0000:00:01.0
>              version: 09
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pm msi pciexpress normal_decode
> bus_master cap_list
>              configuration: driver=3Dpcieport
>              resources: irq:40
>         *-pci:1
>              description: PCI bridge
>              product: Xeon E3-1200/2nd Generation Core Processor
> Family PCI Express Root Port
>              vendor: Intel Corporation
>              physical id: 1.1
>              bus info: pci@0000:00:01.1
>              version: 09
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pm msi pciexpress normal_decode
> bus_master cap_list
>              configuration: driver=3Dpcieport
>              resources: irq:41 ioport:e000(size=3D4096) memory:fbb000=
00-fbbfffff
>            *-storage
>                 description: RAID bus controller
>                 product: SiI 3132 Serial ATA Raid II Controller
>                 vendor: Silicon Image, Inc.
>                 physical id: 0
>                 bus info: pci@0000:02:00.0
>                 logical name: scsi0
>                 logical name: scsi1
>                 version: 01
>                 width: 64 bits
>                 clock: 33MHz
>                 capabilities: storage pm msi pciexpress bus_master
> cap_list rom emulated
>                 configuration: driver=3Dsata_sil24 latency=3D0
>                 resources: irq:17 memory:fbb84000-fbb8407f
> memory:fbb80000-fbb83fff ioport:e000(size=3D128)
> memory:fbb00000-fbb7ffff
>               *-disk:0
>                    description: ATA Disk
>                    product: SAMSUNG HD204UI
>                    physical id: 0
>                    bus info: scsi@0:0.0.0
>                    logical name: /dev/sda
>                    version: 1AQ1
>                    serial: S2N6J50B800969
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D20af5a1=
0
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@0:0.0.0,1
>                       logical name: /dev/sda1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:1
>                    description: ATA Disk
>                    product: SAMSUNG HD204UI
>                    physical id: 1
>                    bus info: scsi@0:1.0.0
>                    logical name: /dev/sdb
>                    version: 1AQ1
>                    serial: S2N6J50B800971
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D822181a=
7
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@0:1.0.0,1
>                       logical name: /dev/sdb1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:2
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 2
>                    bus info: scsi@0:2.0.0
>                    logical name: /dev/sdc
>                    version: ML6O
>                    serial: ML2220F30YLVBE
>                    size: 1863GiB (2TB)
>                    configuration: ansiversion=3D5
>               *-disk:3
>                    description: ATA Disk
>                    product: SAMSUNG HD204UI
>                    physical id: 3
>                    bus info: scsi@0:3.0.0
>                    logical name: /dev/sdd
>                    version: 1AQ1
>                    serial: S2N6J50B800952
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Df6e5951=
b
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@0:3.0.0,1
>                       logical name: /dev/sdd1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:4
>                    description: ATA Disk
>                    product: SAMSUNG HD204UI
>                    physical id: 4
>                    bus info: scsi@0:4.0.0
>                    logical name: /dev/sde
>                    version: 1AQ1
>                    serial: S2N6J50B800950
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D2ecdc2c=
e
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@0:4.0.0,1
>                       logical name: /dev/sde1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:5
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 5
>                    bus info: scsi@1:0.0.0
>                    logical name: /dev/sdf
>                    version: ML6O
>                    serial: ML2220F30V22NE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D3783f5a=
b
>                  *-volume UNCLAIMED
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@1:0.0.0,1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:6
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 6
>                    bus info: scsi@1:1.0.0
>                    logical name: /dev/sdg
>                    version: ML6O
>                    serial: ML2220F32PN2ME
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D3cbd062=
e
>                  *-volume UNCLAIMED
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@1:1.0.0,1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:7
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 7
>                    bus info: scsi@1:2.0.0
>                    logical name: /dev/sdh
>                    version: ML6O
>                    serial: ML2220F32PNAPE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Db6c8334=
2
>                  *-volume UNCLAIMED
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@1:2.0.0,1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:8
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 8
>                    bus info: scsi@1:3.0.0
>                    logical name: /dev/sdi
>                    version: ML6O
>                    serial: ML2220F30WZYHE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D6ef255a=
1
>                  *-volume UNCLAIMED
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@1:3.0.0,1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:9
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 9
>                    bus info: scsi@1:4.0.0
>                    logical name: /dev/sdj
>                    version: ML6O
>                    serial: ML2220F30Z38XE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D099ce3d=
f
>                  *-volume UNCLAIMED
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@1:4.0.0,1
>                       capacity: 1863GiB
>                       capabilities: primary
>
> *-pci:2
>              description: PCI bridge
>              product: 6 Series/C200 Series Chipset Family PCI Express
> Root Port 1
>              vendor: Intel Corporation
>              physical id: 1c
>              bus info: pci@0000:00:1c.0
>              version: b5
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode
> bus_master cap_list
>              configuration: driver=3Dpcieport
>              resources: irq:42 ioport:d000(size=3D4096) memory:fba000=
00-fbafffff
>            *-storage
>                 description: RAID bus controller
>                 product: SiI 3132 Serial ATA Raid II Controller
>                 vendor: Silicon Image, Inc.
>                 physical id: 0
>                 bus info: pci@0000:03:00.0
>                 logical name: scsi2
>                 logical name: scsi3
>                 version: 01
>                 width: 64 bits
>                 clock: 33MHz
>                 capabilities: storage pm msi pciexpress bus_master
> cap_list rom emulated
>                 configuration: driver=3Dsata_sil24 latency=3D0
>                 resources: irq:16 memory:fba84000-fba8407f
> memory:fba80000-fba83fff ioport:d000(size=3D128)
> memory:fba00000-fba7ffff
>               *-disk:0
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 0
>                    bus info: scsi@2:0.0.0
>                    logical name: /dev/sdk
>                    version: ML6O
>                    serial: ML2220F30U13AE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Dc381acb=
8
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@2:0.0.0,1
>                       logical name: /dev/sdk1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:1
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 1
>                    bus info: scsi@2:1.0.0
>                    logical name: /dev/sdl
>                    version: ML6O
>                    serial: ML2220F30YL2NE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D31c44e7=
4
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@2:1.0.0,1
>                       logical name: /dev/sdl1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:2
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 2
>                    bus info: scsi@2:2.0.0
>                    logical name: /dev/sdm
>                    version: ML6O
>                    serial: ML2220F32S2JNE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D8f8c9ee=
b
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@2:2.0.0,1
>                       logical name: /dev/sdm1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:3
>                    description: ATA Disk
>                    product: WDC WD20EARX-00P
>                    vendor: Western Digital
>                    physical id: 3
>                    bus info: scsi@2:3.0.0
>                    logical name: /dev/sdn
>                    version: 51.0
>                    serial: WD-WMAZA9409912
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Df2a3d65=
b
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@2:3.0.0,1
>                       logical name: /dev/sdn1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:4
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 4
>                    bus info: scsi@2:4.0.0
>                    logical name: /dev/sdo
>                    version: ML6O
>                    serial: ML2220F30VS6SE
>                    size: 1863GiB (2TB)
>                    configuration: ansiversion=3D5
>               *-disk:5
>                    description: EXT4 volume
>                    product: Hitachi HDS5C302
>                    vendor: Linux
>                    physical id: 5
>                    bus info: scsi@3:0.0.0
>                    logical name: /dev/sdp
>                    version: 1.0
>                    serial: 3d95991d-d58b-4c49-b22d-620b4a74aa91
>                    size: 1863GiB
>                    capabilities: journaled extended_attributes
> large_files huge_files dir_nlink extents ext4 ext2 initialized
>                    configuration: ansiversion=3D5 created=3D2012-09-0=
5
> 16:45:31 filesystem=3Dext4 lastmountpoint=3D/media/hdd modified=3D201=
2-09-05
> 17:57:47 mounted=3D2012-09-05 17:55:30 state=3Dclean
>               *-disk:6
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 6
>                    bus info: scsi@3:1.0.0
>                    logical name: /dev/sdq
>                    version: ML6O
>                    serial: ML2220F311S72E
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D590f599=
d
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@3:1.0.0,1
>                       logical name: /dev/sdq1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:7
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 7
>                    bus info: scsi@3:2.0.0
>                    logical name: /dev/sdr
>                    version: ML6O
>                    serial: ML2220F30YD74E
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Ddcc1db6=
2
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@3:2.0.0,1
>                       logical name: /dev/sdr1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:8
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 8
>                    bus info: scsi@3:3.0.0
>                    logical name: /dev/sds
>                    version: ML6O
>                    serial: ML2220F30YBPUE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3De9c70fc=
d
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@3:3.0.0,1
>                       logical name: /dev/sds1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:9
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 9
>                    bus info: scsi@3:4.0.0
>                    logical name: /dev/sdt
>                    version: ML6O
>                    serial: ML2220F30R3XYE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D8458157=
f
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@3:4.0.0,1
>                       logical name: /dev/sdt1
>                       capacity: 1863GiB
>                       capabilities: primary
>         *-pci:3
>              description: PCI bridge
>              product: 6 Series/C200 Series Chipset Family PCI Express
> Root Port 2
>              vendor: Intel Corporation
>              physical id: 1c.1
>              bus info: pci@0000:00:1c.1
>              version: b5
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode
> bus_master cap_list
>              configuration: driver=3Dpcieport
>              resources: irq:43 memory:fb900000-fb9fffff
>            *-usb
>                 description: USB controller
>                 product: ASM1042 SuperSpeed USB Host Controller
>                 vendor: ASMedia Technology Inc.
>                 physical id: 0
>                 bus info: pci@0000:04:00.0
>                 version: 00
>                 width: 64 bits
>                 clock: 33MHz
>                 capabilities: msi msix pm pciexpress xhci bus_master =
cap_list
>                 configuration: driver=3Dxhci_hcd latency=3D0
>                 resources: irq:17 memory:fb900000-fb907fff
>         *-pci:4
>              description: PCI bridge
>              product: 6 Series/C200 Series Chipset Family PCI Express
> Root Port 3
>              vendor: Intel Corporation
>              physical id: 1c.2
>              bus info: pci@0000:00:1c.2
>              version: b5
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode
> bus_master cap_list
>              configuration: driver=3Dpcieport
>              resources: irq:44 ioport:c000(size=3D4096) memory:fb8000=
00-fb8fffff
>            *-storage
>                 description: RAID bus controller
>                 product: SiI 3132 Serial ATA Raid II Controller
>                 vendor: Silicon Image, Inc.
>                 physical id: 0
>                 bus info: pci@0000:05:00.0
>                 logical name: scsi4
>                 logical name: scsi5
>                 version: 01
>                 width: 64 bits
>                 clock: 33MHz
>                 capabilities: storage pm msi pciexpress bus_master
> cap_list rom emulated
>                 configuration: driver=3Dsata_sil24 latency=3D0
>                 resources: irq:18 memory:fb884000-fb88407f
> memory:fb880000-fb883fff ioport:c000(size=3D128)
> memory:fb800000-fb87ffff
>               *-disk:0
>                    description: ATA Disk
>                    product: SAMSUNG HD204UI
>                    physical id: 0
>                    bus info: scsi@4:0.0.0
>                    logical name: /dev/sdu
>                    version: 1AQ1
>                    serial: S2N6J50B800957
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D0fca255=
7
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@4:0.0.0,1
>                       logical name: /dev/sdu1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:1
>                    description: ATA Disk
>                    product: SAMSUNG HD204UI
>                    physical id: 1
>                    bus info: scsi@4:1.0.0
>                    logical name: /dev/sdv
>                    version: 1AQ1
>                    serial: S2N6J50B800964
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D9d8ed5a=
5
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@4:1.0.0,1
>                       logical name: /dev/sdv1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:2
>                    description: ATA Disk
>                    product: SAMSUNG HD204UI
>                    physical id: 2
>                    bus info: scsi@4:2.0.0
>                    logical name: /dev/sdw
>                    version: 1AQ1
>                    serial: S2N6J50B800955
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Dab4b523=
a
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@4:2.0.0,1
>                       logical name: /dev/sdw1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:3
>                    description: ATA Disk
>                    product: SAMSUNG HD204UI
>                    physical id: 3
>                    bus info: scsi@4:3.0.0
>                    logical name: /dev/sdx
>                    version: 1AQ1
>                    serial: S2N6J50B800954
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3De69fb7c=
b
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@4:3.0.0,1
>                       logical name: /dev/sdx1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:4
>                    description: ATA Disk
>                    product: SAMSUNG HD204UI
>                    physical id: 4
>                    bus info: scsi@4:4.0.0
>                    logical name: /dev/sdy
>                    version: 1AQ1
>                    serial: S2N6J50B800956
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D195e465=
9
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@4:4.0.0,1
>                       logical name: /dev/sdy1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:5
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 5
>                    bus info: scsi@5:0.0.0
>                    logical name: /dev/sdz
>                    version: ML6O
>                    serial: ML2220F30ZRZ5E
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D222ff77=
a
>                  *-volume UNCLAIMED
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@5:0.0.0,1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:6
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 6
>                    bus info: scsi@5:1.0.0
>                    logical name: /dev/sdaa
>                    version: ML6O
>                    serial: ML2220F30TDYWE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Da4f16c5=
5
>                  *-volume UNCLAIMED
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@5:1.0.0,1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:7
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 7
>                    bus info: scsi@5:2.0.0
>                    logical name: /dev/sdab
>                    version: ML6O
>                    serial: ML2220F31162ZE
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Dc1af612=
f
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@5:2.0.0,1
>                       logical name: /dev/sdab1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:8
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 8
>                    bus info: scsi@5:3.0.0
>                    logical name: /dev/sdac
>                    version: ML6O
>                    serial: ML2220F30XAN6E
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Da2c77b5=
9
>                  *-volume UNCLAIMED
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@5:3.0.0,1
>                       capacity: 1863GiB
>                       capabilities: primary
>               *-disk:9
>                    description: ATA Disk
>                    product: Hitachi HDS5C302
>                    vendor: Hitachi
>                    physical id: 9
>                    bus info: scsi@5:4.0.0
>                    logical name: /dev/sdad
>                    version: ML6O
>                    serial: ML2220F311S91E
>                    size: 1863GiB (2TB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3Dd6aacde=
0
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@5:4.0.0,1
>                       logical name: /dev/sdad1
>                       capacity: 1863GiB
>                       capabilities: primary
>         *-pci:5
>              description: PCI bridge
>              product: 6 Series/C200 Series Chipset Family PCI Express
> Root Port 4
>              vendor: Intel Corporation
>              physical id: 1c.3
>              bus info: pci@0000:00:1c.3
>              version: b5
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode
> bus_master cap_list
>              configuration: driver=3Dpcieport
>              resources: irq:45 ioport:b000(size=3D4096)
> memory:fb700000-fb7fffff ioport:cfa00000(size=3D1048576)
>            *-storage
>                 description: SATA controller
>                 product: JMB362 SATA Controller
>                 vendor: JMicron Technology Corp.
>                 physical id: 0
>                 bus info: pci@0000:06:00.0
>                 version: 10
>                 width: 32 bits
>                 clock: 33MHz
>                 capabilities: storage pm pciexpress ahci_1.0
> bus_master cap_list rom
>                 configuration: driver=3Dahci latency=3D0
>                 resources: irq:19 ioport:b040(size=3D8)
> ioport:b030(size=3D4) ioport:b020(size=3D8) ioport:b010(size=3D4)
> ioport:b000(size=3D16) memory:fb710000-fb7101ff memory:cfa00000-cfa0f=
fff
>         *-pci:6
>              description: PCI bridge
>              product: 6 Series/C200 Series Chipset Family PCI Express
> Root Port 5
>              vendor: Intel Corporation
>              physical id: 1c.4
>              bus info: pci@0000:00:1c.4
>              version: b5
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode
> bus_master cap_list
>              configuration: driver=3Dpcieport
>              resources: irq:46 memory:fb600000-fb6fffff
>            *-usb
>                 description: USB controller
>                 product: ASM1042 SuperSpeed USB Host Controller
>                 vendor: ASMedia Technology Inc.
>                 physical id: 0
>                 bus info: pci@0000:07:00.0
>                 version: 00
>                 width: 64 bits
>                 clock: 33MHz
>                 capabilities: msi msix pm pciexpress xhci bus_master =
cap_list
>                 configuration: driver=3Dxhci_hcd latency=3D0
>                 resources: irq:16 memory:fb600000-fb607fff
>         *-pci:7
>              description: PCI bridge
>              product: 82801 PCI Bridge
>              vendor: Intel Corporation
>              physical id: 1c.6
>              bus info: pci@0000:00:1c.6
>              version: b5
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm subtractive_decode
> bus_master cap_list
>              resources: ioport:a000(size=3D4096) memory:fb500000-fb5f=
ffff
>            *-pci
>                 description: PCI bridge
>                 product: ASM1083/1085 PCIe to PCI Bridge
>                 vendor: ASMedia Technology Inc.
>                 physical id: 0
>                 bus info: pci@0000:08:00.0
>                 version: 01
>                 width: 32 bits
>                 clock: 33MHz
>                 capabilities: pci subtractive_decode bus_master cap_l=
ist
>                 resources: ioport:a000(size=3D4096) memory:fb500000-f=
b5fffff
>               *-firewire
>                    description: FireWire (IEEE 1394)
>                    product: VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Co=
ntroller
>                    vendor: VIA Technologies, Inc.
>                    physical id: 2
>                    bus info: pci@0000:09:02.0
>                    version: c0
>                    width: 32 bits
>                    clock: 33MHz
>                    capabilities: pm ohci bus_master cap_list
>                    configuration: driver=3Dfirewire_ohci latency=3D32=
 maxlatency=3D32
>                    resources: irq:17 memory:fb500000-fb5007ff
> ioport:a000(size=3D128)
>         *-pci:8
>              description: PCI bridge
>              product: 6 Series/C200 Series Chipset Family PCI Express
> Root Port 8
>              vendor: Intel Corporation
>              physical id: 1c.7
>              bus info: pci@0000:00:1c.7
>              version: b5
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode
> bus_master cap_list
>              configuration: driver=3Dpcieport
>              resources: irq:47 ioport:9000(size=3D4096) memory:fb4000=
00-fb4fffff
>            *-storage
>                 description: SATA controller
>                 product: 88SE9172 SATA 6Gb/s Controller
>                 vendor: Marvell Technology Group Ltd.
>                 physical id: 0
>                 bus info: pci@0000:0a:00.0
>                 logical name: scsi14
>                 logical name: scsi15
>                 version: 11
>                 width: 32 bits
>                 clock: 33MHz
>                 capabilities: storage pm msi pciexpress ahci_1.0
> bus_master cap_list rom emulated
>                 configuration: driver=3Dahci latency=3D0
>                 resources: irq:60 ioport:9040(size=3D8)
> ioport:9030(size=3D4) ioport:9020(size=3D8) ioport:9010(size=3D4)
> ioport:9000(size=3D16) memory:fb410000-fb4101ff memory:fb400000-fb40f=
fff
>               *-disk:0
>                    description: ATA Disk
>                    product: Corsair Force 3
>                    physical id: 0
>                    bus info: scsi@14:0.0.0
>                    logical name: /dev/sdaf
>                    version: 1.3.
>                    serial: 11436520000012112929
>                    size: 111GiB (120GB)
>                    capabilities: partitioned partitioned:dos
>                    configuration: ansiversion=3D5 signature=3D447df0c=
7
>                  *-volume
>                       description: Linux filesystem partition
>                       physical id: 1
>                       bus info: scsi@14:0.0.0,1
>                       logical name: /dev/sdaf1
>                       capacity: 111GiB
>                       capabilities: primary
>               *-disk:1
>                    description: ATA Disk
>                    product: KINGSTON SE100S3
>                    physical id: 1
>                    bus info: scsi@15:0.0.0
>                    logical name: /dev/sdag
>                    version: 515A
>                    serial: 50026B723A087F9E
>                    size: 93GiB (100GB)
>                    configuration: ansiversion=3D5
>         *-usb:1
>              description: USB controller
>              product: 6 Series/C200 Series Chipset Family USB Enhance=
d
> Host Controller #1
>              vendor: Intel Corporation
>              physical id: 1d
>              bus info: pci@0000:00:1d.0
>              version: 05
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pm debug ehci bus_master cap_list
>              configuration: driver=3Dehci_hcd latency=3D0
>              resources: irq:23 memory:fbc26000-fbc263ff
>         *-isa
>              description: ISA bridge
>              product: Z68 Express Chipset Family LPC Controller
>              vendor: Intel Corporation
>              physical id: 1f
>              bus info: pci@0000:00:1f.0
>              version: 05
>              width: 32 bits
>              clock: 33MHz
>              capabilities: isa bus_master cap_list
>              configuration: latency=3D0
>         *-storage
>              description: SATA controller
>              product: 6 Series/C200 Series Chipset Family SATA AHCI C=
ontroller
>              vendor: Intel Corporation
>              physical id: 1f.2
>              bus info: pci@0000:00:1f.2
>              logical name: scsi10
>              version: 05
>              width: 32 bits
>              clock: 66MHz
>              capabilities: storage msi pm ahci_1.0 bus_master cap_lis=
t emulated
>              configuration: driver=3Dahci latency=3D0
>              resources: irq:59 ioport:f0d0(size=3D8) ioport:f0c0(size=
=3D4)
> ioport:f0b0(size=3D8) ioport:f0a0(size=3D4) ioport:f060(size=3D32)
> memory:fbc25000-fbc257ff
>            *-disk
>                 description: ATA Disk
>                 product: ST2000DL003-9VT1
>                 vendor: Seagate
>                 physical id: 0.0.0
>                 bus info: scsi@10:0.0.0
>                 logical name: /dev/sdae
>                 version: CC32
>                 serial: 5YD3L8H1
>                 size: 1863GiB (2TB)
>                 capabilities: gpt-1.00 partitioned partitioned:gpt
>                 configuration: ansiversion=3D5
> guid=3Dee69a333-af6d-4738-be13-8f376787e0f5
>               *-volume:0
>                    description: EFI partition
>                    physical id: 1
>                    bus info: scsi@10:0.0.0,1
>                    logical name: /dev/sdae1
>                    serial: 1ba7cdd4-ca07-4cb4-932c-52ef2464d25f
>                    capacity: 976KiB
>               *-volume:1
>                    description: EXT4 volume
>                    vendor: Linux
>                    physical id: 2
>                    bus info: scsi@10:0.0.0,2
>                    logical name: /dev/sdae2
>                    logical name: /
>                    version: 1.0
>                    serial: 582b06ec-89d4-4f54-a537-1f72440b09f1
>                    size: 1855GiB
>                    capabilities: journaled extended_attributes
> large_files huge_files dir_nlink recover extents ext4 ext2 initialize=
d
>                    configuration: created=3D2012-04-04 15:28:10
> filesystem=3Dext4 lastmountpoint=3D/ modified=3D2015-03-03 16:46:29
> mount.fstype=3Dext4
> mount.options=3Drw,relatime,errors=3Dremount-ro,user_xattr,acl,barrie=
r=3D1,data=3Dordered
> mounted=3D2015-04-06 17:35:05 state=3Dmounted
>               *-volume:2
>                    description: Linux swap volume
>                    physical id: 3
>                    bus info: scsi@10:0.0.0,3
>                    logical name: /dev/sdae3
>                    version: 1
>                    serial: 10a1f4e7-ba5f-4319-9f6b-80338ef27594
>                    size: 8097MiB
>                    capacity: 8097MiB
>                    capabilities: nofs swap initialized
>                    configuration: filesystem=3Dswap pagesize=3D4096
>         *-serial UNCLAIMED
>              description: SMBus
>              product: 6 Series/C200 Series Chipset Family SMBus Contr=
oller
>              vendor: Intel Corporation
>              physical id: 1f.3
>              bus info: pci@0000:00:1f.3
>              version: 05
>              width: 64 bits
>              clock: 33MHz
>              configuration: latency=3D0
>              resources: memory:fbc24000-fbc240ff ioport:f040(size=3D3=
2)
>
>
>
>
>
> --
> Emanuel Domingos



--=20
Emanuel Domingos

Cursando Bacharelado em Ci=C3=AAncia da Computa=C3=A7=C3=A3o - IFCE Cam=
pus Maracana=C3=BA
T=C3=A9cnico em Conectividade - IFCE Campus Maracana=C3=BA
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
