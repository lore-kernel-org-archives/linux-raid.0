From: Phil Turmel <philip@turmel.org>
Subject: Re: mdsadm -A won't assemble my array
Date: Mon, 09 Feb 2015 21:04:26 -0500
Message-ID: <54D9672A.7040104@turmel.org>
References: <CANjusZesi-8zxpZ9rCOEToSXwFoiApeN-ivO51qY=80R6_xb_g@mail.gmail.com>	<CANjusZcnX=BArJJLMiBN4hfzRRLdUtD6mSq-mDZ6OhPB=KMX3w@mail.gmail.com>	<54D94D3C.3060808@turmel.org> <CANjusZdgzDxN4ZxsXFc20OU1Y9_LoScYQcZmffyRGHWYUviY0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANjusZdgzDxN4ZxsXFc20OU1Y9_LoScYQcZmffyRGHWYUviY0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "G. Michael Carter" <mikey@carterfamily.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Michael,

On 02/09/2015 08:36 PM, G. Michael Carter wrote:
> Was actually dreading the complete info question, as the machine has
> no CD/DVD, it is my netboot station and holds all my ISO mirrors.  But
> turns out starting it's network interface from the emergency shell was
> easier than I thought.

Almost all good livecds can be put on a thumb drive to boot from,
instead of using a real CD.  I highly recommend sysrescuecd.org, FWIW.

> ---- uname
> Linux andromeda 3.16.6-203.fc20.x86_64 #1 SMP Sat Oct 25 12:44:32 UTC
> 2014 x86_64 x86_64 x86_64 GNU/Linux

Not too old, good.  There been a steady stream of small bugfixes since
3.16.  I'm not sure what fedora's been backporting.

> ---- mdadm -V
> mdadm - v3.3 - 3rd September 2013

Bugfixes to this, too.

> ---- disk-by-id

> lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST4000DM000-1F2168_W3009GE3
> -> ../../sdp
> lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST4000DM000-1F2168_W300E08A
> -> ../../sdk
> lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST4000DM000-1F2168_Z300PYF2
> -> ../../sdb
> lrwxrwxrwx 1 root root  9 Feb  9 20:16 ata-ST4000DM000-1F2168_Z300Q4YS
> -> ../../sdo

I think you missed the 'excerpt' part, but no harm done.  Anyways, if I
recall Seagate model numbering (past misery), these are green drives.
Very bad for raid service.  After we revive your array, you'll want to
do some reading on 'timeout mismatch'.[1] (You are dangerously close to
option "D" there, and option "C" is your only choice w/ green drives.)

> ---- mdadm -E
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ce6de916:62aeda9c:b5688f54:f5a9249d
>            Name : andromeda:3  (local to host andromeda)
>   Creation Time : Tue Jul 22 16:02:30 2014
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 11720661504 (11177.69 GiB 12001.96 GB)
>   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>     Data Offset : 259072 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=258984 sectors, after=3760 sectors
>           State : clean
>     Device UUID : e9e7af60:e1bc1c7f:107157b4:4099c48a
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Mon Feb  9 05:13:20 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 57eaf19 - correct
>          Events : 158964
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>    Device Role : Active device 0
>    Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdk:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ce6de916:62aeda9c:b5688f54:f5a9249d
>            Name : andromeda:3  (local to host andromeda)
>   Creation Time : Tue Jul 22 16:02:30 2014
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 11720661504 (11177.69 GiB 12001.96 GB)
>   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>     Data Offset : 259072 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=258984 sectors, after=3760 sectors
>           State : active
>     Device UUID : ed09357e:36655c6d:b7430500:63d5e540
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Mon Feb  9 05:10:53 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 131587ad - correct
>          Events : 158964

matching events.

>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>    Device Role : Active device 1
>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdo:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ce6de916:62aeda9c:b5688f54:f5a9249d
>            Name : andromeda:3  (local to host andromeda)
>   Creation Time : Tue Jul 22 16:02:30 2014
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 11720661504 (11177.69 GiB 12001.96 GB)
>   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>     Data Offset : 259072 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=258984 sectors, after=3760 sectors
>           State : clean
>     Device UUID : de849807:80d7f071:9909f3f2:78022d94
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Mon Feb  9 05:11:55 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : e73f681f - correct
>          Events : 158962

Events off by two.  Pretty minor.

>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>    Device Role : Active device 3
>    Array State : A.AA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdp:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ce6de916:62aeda9c:b5688f54:f5a9249d
>            Name : andromeda:3  (local to host andromeda)
>   Creation Time : Tue Jul 22 16:02:30 2014
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 11720661504 (11177.69 GiB 12001.96 GB)
>   Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>     Data Offset : 259072 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=258984 sectors, after=3760 sectors
>           State : clean
>     Device UUID : 67fcd9a9:432b0c8b:178cc556:67b003b3
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Mon Feb  9 05:11:55 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 254563d8 - correct
>          Events : 158962

Also off by two.  Again, minor.

>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>    Device Role : Active device 2
>    Array State : A.AA ('A' == active, '.' == missing, 'R' == replacing)

> ---- dmesg
> [  576.890380] md: md3 stopped.
> [  576.891629] md: unbind<sdb>
> [  576.900841] md: export_rdev(sdb)
> [  576.902147] md: unbind<sdo>
> [  576.906824] md: export_rdev(sdo)
> [  576.908029] md: unbind<sdk>
> [  576.911845] md: export_rdev(sdk)
> [  576.913030] md: unbind<sdp>
> [  576.916862] md: export_rdev(sdp)
> [  585.164936] md: md3 stopped.
> [  585.360571] md: bind<sdk>
> [  585.360833] md: bind<sdp>
> [  585.361050] md: bind<sdo>
> [  585.361261] md: bind<sdb>
> [  585.361294] md: md3 stopped.
> [  585.361298] md: unbind<sdb>
> [  585.386616] md: export_rdev(sdb)
> [  585.387767] md: unbind<sdo>
> [  585.398644] md: export_rdev(sdo)
> [  585.399633] md: unbind<sdp>
> [  585.404662] md: export_rdev(sdp)
> [  585.405681] md: unbind<sdk>
> [  585.410647] md: export_rdev(sdk)

> ---- mdadm -A output
> mdadm: looking for devices for /dev/md3
> mdadm: /dev/sdb is identified as a member of /dev/md3, slot 0.
> mdadm: /dev/sdk is identified as a member of /dev/md3, slot 1.
> mdadm: /dev/sdo is identified as a member of /dev/md3, slot 3.
> mdadm: /dev/sdp is identified as a member of /dev/md3, slot 2.
> mdadm: added /dev/sdk to /dev/md3 as 1
> mdadm: added /dev/sdp to /dev/md3 as 2 (possibly out of date)
> mdadm: added /dev/sdo to /dev/md3 as 3 (possibly out of date)
> mdadm: added /dev/sdb to /dev/md3 as 0
> mdadm: /dev/md3 assembled from 2 drives - not enough to start the array.

Please redo this with an explicit command line so we can see what's
going on:

mdadm --assemble --force --verbose /dev/md3 /dev/sd[bkop]

> ---- /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1]
> md1 : active raid1 sda[0] sde[1]
>       1953383488 blocks super 1.2 [2/2] [UU]
>       bitmap: 0/15 pages [0KB], 65536KB chunk
> 
> md0 : active raid5 sdl[0] sdn[3] sdd[5] sdm[1]
>       8790405120 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
>       bitmap: 0/22 pages [0KB], 65536KB chunk
> 
> md2 : active raid6 sdj[0] sdi[1] sdg[3] sdh[2]
>       5860270080 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
>       bitmap: 0/22 pages [0KB], 65536KB chunk
> 
> unused devices: <none>
> 
> ** md3 is shutdown which is why I'm assuming it's not there.

Yup.  If --assemble --force doesn't work with your installed OS,
temporarily boot from a recent system rescue cd and do the above over
again (especially the /dev/disk/by-id excerpt).

Phil

[1] http://marc.info/?l=linux-raid&m=135811522817345&w=1

More history:

http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=135863964624202&w=2
http://marc.info/?l=linux-raid&m=139050322510249&w=2

You might want to read more from those threads than just the mails I've
pointed out...
