From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: What the heck happened to my array?
Date: Tue, 05 Apr 2011 08:47:16 +0800
Message-ID: <4D9A6694.4040606@fnarfbargle.com>
References: <4D9876E4.6080501@fnarfbargle.com>	<AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>	<4D995E27.3060800@fnarfbargle.com> <BANLkTi=prv_vzfJr2JJt3LLhdB0GFSMy4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=prv_vzfJr2JJt3LLhdB0GFSMy4w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

On 05/04/11 00:49, Roberto Spadim wrote:
> i don=B4t know but this happened with me on a hp server, with linux
> 2,6,37 i changed kernel to a older release and the problem ended,
> check with neil and others md guys what=B4s the real problem
> maybe realtime module and others changes inside kernel are the
> problem, maybe not...
> just a quick solution idea: try a older kernel
>

Quick precis:
- Started reshape 512k to 64k chunk size.
- sdd got bad sector and was kicked.
- Array froze all IO.
- Reboot required to get system back.
- Restarted reshape with 9 drives.
- sdl suffered IO error and was kicked
- Array froze all IO.
- Reboot required to get system back.
- Array will no longer mount with 8/10 drives.
- Mdadm 3.1.5 segfaults when trying to start reshape.
   Naively tried to run it under gdb to get a backtrace but was unable=20
to stop it forking
- Got array started with mdadm 3.2.1
- Attempted to re-add sdd/sdl (now marked as spares)

root@srv:~/mdadm-3.1.5# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md0 : active raid6 sdl[1](S) sdd[6](S) sdc[0] sdh[9] sda[8] sde[7]=20
sdg[5] sdb[4] sdf[3] sdm[2]
       7814078464 blocks super 1.2 level 6, 512k chunk, algorithm 2=20
[10/8] [U_UUUU_UUU]
       	resync=3DDELAYED

md2 : active raid5 sdi[0] sdk[3] sdj[1]
       1465146368 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3=
]=20
[UUU]

md6 : active raid1 sdo6[0] sdn6[1]
       821539904 blocks [2/2] [UU]

md5 : active raid1 sdo5[0] sdn5[1]
       104864192 blocks [2/2] [UU]

md4 : active raid1 sdo3[0] sdn3[1]
       20980800 blocks [2/2] [UU]

md3 : active (auto-read-only) raid1 sdo2[0] sdn2[1]
       8393856 blocks [2/2] [UU]

md1 : active raid1 sdo1[0] sdn1[1]
       20980736 blocks [2/2] [UU]

unused devices: <none>


[  303.640776] md: bind<sdl>
[  303.677461] md: bind<sdm>
[  303.837358] md: bind<sdf>
[  303.846291] md: bind<sdb>
[  303.851476] md: bind<sdg>
[  303.860725] md: bind<sdd>
[  303.861055] md: bind<sde>
[  303.861982] md: bind<sda>
[  303.862830] md: bind<sdh>
[  303.863128] md: bind<sdc>
[  303.863306] md: kicking non-fresh sdd from array!
[  303.863353] md: unbind<sdd>
[  303.900207] md: export_rdev(sdd)
[  303.900260] md: kicking non-fresh sdl from array!
[  303.900306] md: unbind<sdl>
[  303.940100] md: export_rdev(sdl)
[  303.942181] md/raid:md0: reshape will continue
[  303.942242] md/raid:md0: device sdc operational as raid disk 0
[  303.942285] md/raid:md0: device sdh operational as raid disk 9
[  303.942327] md/raid:md0: device sda operational as raid disk 8
[  303.942368] md/raid:md0: device sde operational as raid disk 7
[  303.942409] md/raid:md0: device sdg operational as raid disk 5
[  303.942449] md/raid:md0: device sdb operational as raid disk 4
[  303.942490] md/raid:md0: device sdf operational as raid disk 3
[  303.942531] md/raid:md0: device sdm operational as raid disk 2
[  303.943733] md/raid:md0: allocated 10572kB
[  303.943866] md/raid:md0: raid level 6 active with 8 out of 10=20
devices, algorithm 2
[  303.943912] RAID conf printout:
[  303.943916]  --- level:6 rd:10 wd:8
[  303.943920]  disk 0, o:1, dev:sdc
[  303.943924]  disk 2, o:1, dev:sdm
[  303.943927]  disk 3, o:1, dev:sdf
[  303.943931]  disk 4, o:1, dev:sdb
[  303.943934]  disk 5, o:1, dev:sdg
[  303.943938]  disk 7, o:1, dev:sde
[  303.943941]  disk 8, o:1, dev:sda
[  303.943945]  disk 9, o:1, dev:sdh
[  303.944061] md0: detected capacity change from 0 to 8001616347136
[  303.944366] md: md0 switched to read-write mode.
[  303.944427] md: reshape of RAID array md0
[  303.944469] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  303.944511] md: using maximum available idle IO bandwidth (but not=20
more than 200000 KB/sec) for reshape.
[  303.944573] md: using 128k window, over a total of 976759808 blocks.
[  304.054875]  md0: unknown partition table
[  304.393245] mdadm[5940]: segfault at 7f2000 ip 00000000004480d2 sp=20
00007fffa04777b8 error 4 in mdadm[400000+64000]


root@srv:~# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
      Array Size : 7814078464 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
    Raid Devices : 10
   Total Devices : 10
     Persistence : Superblock is persistent

     Update Time : Tue Apr  5 07:54:30 2011
           State : active, degraded
  Active Devices : 8
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric
      Chunk Size : 512K

   New Chunksize : 64K

            Name : srv:server  (local to host srv)
            UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
          Events : 633835

     Number   Major   Minor   RaidDevice State
        0       8       32        0      active sync   /dev/sdc
        1       0        0        1      removed
        2       8      192        2      active sync   /dev/sdm
        3       8       80        3      active sync   /dev/sdf
        4       8       16        4      active sync   /dev/sdb
        5       8       96        5      active sync   /dev/sdg
        6       0        0        6      removed
        7       8       64        7      active sync   /dev/sde
        8       8        0        8      active sync   /dev/sda
        9       8      112        9      active sync   /dev/sdh

        1       8      176        -      spare   /dev/sdl
        6       8       48        -      spare   /dev/sdd

root@srv:~# for i in /dev/sd? ; do mdadm --examine $i ; done
/dev/sda:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 9beb9a0f:2a73328c:f0c17909:89da70fd

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : c58ed095 - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 8
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 75d997f8:d9372d90:c068755b:81c8206b

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : 72321703 - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 5738a232:85f23a16:0c7a9454:d770199c

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : 5c61ea2e - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 83a2c731:ba2846d0:2ce97d83:de624339

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : e1a5ebbc - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : f1e3c1d3:ea9dc52e:a4e6b70e:e25a0321

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : 551997d7 - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 7
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : c32dff71:0b8c165c:9f589b0f:bcbc82da

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : db0aa39b - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdg:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 194bc75c:97d3f507:4915b73a:51a50172

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : 344cadbe - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 5
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdh:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 1326457e:4fc0a6be:0073ccae:398d5c7f

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : 8debbb14 - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 9
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdi:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : e39d73c3:75be3b52:44d195da:b240c146
            Name : srv:2  (local to host srv)
   Creation Time : Sat Jul 10 21:14:29 2010
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 1465147120 (698.64 GiB 750.16 GB)
      Array Size : 2930292736 (1397.27 GiB 1500.31 GB)
   Used Dev Size : 1465146368 (698.64 GiB 750.15 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : b577b308:56f2e4c9:c78175f4:cf10c77f

     Update Time : Tue Apr  5 07:46:18 2011
        Checksum : 57ee683f - correct
          Events : 455775

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 0
    Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : e39d73c3:75be3b52:44d195da:b240c146
            Name : srv:2  (local to host srv)
   Creation Time : Sat Jul 10 21:14:29 2010
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 1465147120 (698.64 GiB 750.16 GB)
      Array Size : 2930292736 (1397.27 GiB 1500.31 GB)
   Used Dev Size : 1465146368 (698.64 GiB 750.15 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : b127f002:a4aa8800:735ef8d7:6018564e

     Update Time : Tue Apr  5 07:46:18 2011
        Checksum : 3ae0b4c6 - correct
          Events : 455775

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 1
    Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdk:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : e39d73c3:75be3b52:44d195da:b240c146
            Name : srv:2  (local to host srv)
   Creation Time : Sat Jul 10 21:14:29 2010
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 1465147120 (698.64 GiB 750.16 GB)
      Array Size : 2930292736 (1397.27 GiB 1500.31 GB)
   Used Dev Size : 1465146368 (698.64 GiB 750.15 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 90fddf63:03d5dba4:3fcdc476:9ce3c44c

     Update Time : Tue Apr  5 07:46:18 2011
        Checksum : dd5eef0e - correct
          Events : 455775

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 2
    Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdl:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 769940af:66733069:37cea27d:7fb28a23

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : dc756202 - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdm:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
            Name : srv:server  (local to host srv)
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
    Raid Devices : 10

  Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
      Array Size : 15628156928 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 7e564e2c:7f21125b:c3b1907a:b640178f

   Reshape pos'n : 3437035520 (3277.81 GiB 3519.52 GB)
   New Chunksize : 64K

     Update Time : Tue Apr  5 07:54:30 2011
        Checksum : b3df3ee7 - correct
          Events : 633835

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : A.AAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)

root@srv:~/mdadm-3.1.5# ./mdadm --version
mdadm - v3.1.5 - 23rd March 2011

root@srv:~/mdadm-3.1.5# uname -a
Linux srv 2.6.38 #19 SMP Wed Mar 23 09:57:05 WST 2011 x86_64 GNU/Linux

Now. The array restarted with mdadm 3.2.1, but of course its now=20
reshaping 8 out of 10 disks, has no redundancy and is going at 600k/s=20
which will take over 10 days. Is there anything I can do to give it som=
e=20
redundancy while it completes or am I better to copy the data off, blow=
=20
it away and start again? All the important stuff is backed up anyway, I=
=20
just wanted to avoid restoring 8TB from backup if I could.

Regards,
Brad
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
