From: Ronny Plattner <ronny_p@gmx.net>
Subject: Re: sw_raid5-failed_disc(s)-2
Date: Sat, 12 Mar 2005 19:53:47 +0100
Message-ID: <d0vdln$h8s$1@sea.gmane.org>
References: <d0ur31$ud$1@sea.gmane.org> <200503121749.j2CHnT529953@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
In-Reply-To: <200503121749.j2CHnT529953@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi !

Guy schrieb:
> It seems like a trick question! :)
> You don't use "missing" on assemble, it is a keyword for the create c=
ommand.

Oh!

> For assemble. just don't list that device.
> mdadm --assemble --run --force /dev/md2 /dev/hdi1 /dev/hdk1 /dev/hdo1
>=20
> mdadm will know which disk is which.

OKay, thank you

-snip-
server:~# cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hdg2[1] hde2[0]
      75709248 blocks [2/2] [UU]

md0 : active raid1 hdg1[1] hde1[0]
      2441280 blocks [2/2] [UU]

unused devices: <none>
server:~# mdadm  --assemble --run --force /dev/md2 /dev/hdi1 /dev/hdk1
/dev/hdo1
mdadm: failed to RUN_ARRAY /dev/md2: Invalid argument
server:~# cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hdg2[1] hde2[0]
      75709248 blocks [2/2] [UU]

md2 : inactive hdk1[1] hdi1[4] hdo1[3]
      735334848 blocks
md0 : active raid1 hdg1[1] hde1[0]
      2441280 blocks [2/2] [UU]

unused devices: <none>
-snap-


and


-snip-
server:~# mdadm  --detail /dev/md2
/dev/md2:
        Version : 00.90.01
  Creation Time : Mon Jun 14 18:43:20 2004
     Raid Level : raid5
    Device Size : 245111616 (233.76 GiB 250.99 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sun Mar  6 16:40:29 2005
          State : active, degraded
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 72c49e3a:de37c4f8:00a6d8a2:e8fddb2c
         Events : 0.60470022

    Number   Major   Minor   RaidDevice State
       0       0        0        -      removed
       1      57        1        1      active sync   /dev/hdk1
       2       0        0        -      removed
       3      89        1        3      active sync   /dev/hdo1

       4      56        1        -      spare   /dev/hdi1
server:~#
-snap-


Why is hdi1 (the drive which was built out and after troubles with hdm
again built back in the server) a spare device?
Why isn=B4t it marked as active device?
Is it hopeless to get the raid working?

Not much information in the logfile (/var/log/messages)...


-snip-
Mar 12 19:33:57 server kernel: md: md2 stopped.
Mar 12 19:33:57 server kernel: md: bind<hdo1>
Mar 12 19:33:57 server kernel: md: bind<hdi1>
Mar 12 19:33:57 server kernel: md: bind<hdk1>
Mar 12 19:33:57 server kernel: raid5: device hdk1 operational as raid d=
isk 1
Mar 12 19:33:57 server kernel: raid5: device hdo1 operational as raid d=
isk 3
Mar 12 19:33:57 server kernel: RAID5 conf printout:
Mar 12 19:33:57 server kernel:  --- rd:4 wd:2 fd:2
Mar 12 19:33:57 server kernel:  disk 1, o:1, dev:hdk1
Mar 12 19:33:57 server kernel:  disk 3, o:1, dev:hdo1
-snap-


So, looks bad.


-snip-
server:~# mdadm --detail --scan
ARRAY /dev/md1 level=3Draid1 num-devices=3D2
UUID=3D83effa33:2b40093b:84150bda:54575d43
   devices=3D/dev/hde2,/dev/hdg2
ARRAY /dev/md2 level=3Draid5 num-devices=3D4 spares=3D1
UUID=3D72c49e3a:de37c4f8:00a6d8a2:e8fddb2c
   devices=3D/dev/hdk1,/dev/hdo1,/dev/hdi1
ARRAY /dev/md0 level=3Draid1 num-devices=3D2
UUID=3D7131d3b3:6e026b72:52e66138:1401e760
   devices=3D/dev/hde1,/dev/hdg1
-snap-


Is there a way to get the raid working?

Regards
Ronny

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
