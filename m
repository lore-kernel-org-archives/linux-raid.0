From: Neil Brown <neilb@suse.de>
Subject: Re: power outage while raid5->raid6 was in progress
Date: Thu, 8 Jul 2010 11:21:44 +1000
Message-ID: <20100708112144.1b70d6da@notabene.brown>
References: <20100707204110.GB1207@earth.universe>
	<20100708084450.7abb19d8@notabene.brown>
	<20100707231316.GA6496@earth.universe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100707231316.GA6496@earth.universe>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Reichel <elektranox@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 8 Jul 2010 01:13:16 +0200
Sebastian Reichel <elektranox@gmail.com> wrote:

> On Thu, Jul 08, 2010 at 08:44:50AM +1000, Neil Brown wrote:
> > On Wed, 7 Jul 2010 22:41:10 +0200
> > Sebastian Reichel <elektranox@gmail.com> wrote:
> > 
> > > Hi,
> > > 
> > > I have some problems with my raid. I tried updating from 5 disks raid5 to 8 disks
> > > raid6 as described on http://neil.brown.name/blog/20090817000931#2. The command I
> > > used was: mdadm --grow /dev/md0 --level=6 --raid-disk=8
> > > 
> > > While the rebuild was in progress my system hung, so I had to force power down it.
> > > After rebooting the system I reassembled the raid. You can see the resulting mess
> > > below. How can I recover from this state?
> > 
> > Please report the output of
> > 
> >   mdadm -E /dev/sd[efghijkl]1
> > 
> > then I'll see what can be done.
> 
> thank you for having a look at it :)


It appears that the RAID5 -> RAID6 conversion (which is instantaneous, but
results in a non-standard RAID6 parity layout) happened, but the 
6disk -> 8disk reshape which would have been combined with producing a
more standard RAID6 parity layout did not even begin.
I don't know why that would be.  Do you remember seeing the reshape being
under-way in /proc/mdstat at all??
If you didn't them I am very confused and the following is not at all
reliable.  If you didn't and you only assumed a reshape was happening, then
read on.

So it appear you have an active (dirty), degraded RAID6 array with 3 spares.
md will not normally start such arrays as they could potentially contain
corruption (the so-called RAID5 write hole), though the chance is rather
small.
You need to explicitly request that the array be started anyway using
"--force" to --assemble.
However you have done this and it doesn't seem to have worked.  I cannot
work out why.  There is clear evidence that you tried this as sdk1 has a
status of 'clean' rather than 'active', and the kernel log showed it being
added to the array last, so (as the event counts are all equal) its 'clean'
status will have over-ruled.
However it seems (again from the kernel logs) that raid5 still thinks the
array is dirty and so will not start it.

You can over-ride this with 
  echo 1 > /sys/module/md_mod/parameters/start_dirty_degraded 

that tells raid5 to start a degraded array even if it is dirty (i.e. active). 
You should probably also
  echo 1 >  /sys/module/md_mod/parameters/start_ro
so that the array is started read-only, and doesn't immediately try a resync.

Then you can "fsck -n" the array to make sure your data looks safe.
If it doesn't stop the array immediately and we will have to go over the
details again.
If it does look good, you can try the reshape again:

  mdadm -G /dev/md0 -n 8 --layout normalise

and hope it works this time.

It might be best to convert it back to RAID5 first
  mdadm -G /dev/md0 --level raid5
then repeat the command you started with (after making sure all the spares
are attached).

But if you are sure the reshape actually started the first time, don't do
any of this.  Rather try to find some earlier kernel logs that show the
reshape starting, and maybe show what caused the crash.

good luck,

NeilBrown

> 
> root@mars ~ # mdadm -E /dev/sd[efghijkl]1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
>   Creation Time : Fri Apr  9 19:24:51 2010
>      Raid Level : raid6
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 6
>   Total Devices : 8
> Preferred Minor : 0
> 
>     Update Time : Wed Jul  7 00:21:00 2010
>           State : active
>  Active Devices : 5
> Working Devices : 8
>  Failed Devices : 1
>   Spare Devices : 3
>        Checksum : 4439feb9 - correct
>          Events : 991519
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     1       8       65        1      active sync   /dev/sde1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       65        1      active sync   /dev/sde1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8      145        3      active sync   /dev/sdj1
>    4     4       8      129        4      active sync   /dev/sdi1
>    5     5       0        0        5      faulty removed
>    6     6       8       81        6      spare   /dev/sdf1
>    7     7       8       97        7      spare   /dev/sdg1
>    8     8       8      113        8      spare   /dev/sdh1
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
>   Creation Time : Fri Apr  9 19:24:51 2010
>      Raid Level : raid6
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 6
>   Total Devices : 8
> Preferred Minor : 0
> 
>     Update Time : Wed Jul  7 00:21:00 2010
>           State : active
>  Active Devices : 5
> Working Devices : 8
>  Failed Devices : 1
>   Spare Devices : 3
>        Checksum : 4439fecd - correct
>          Events : 991519
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     6       8       81        6      spare   /dev/sdf1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       65        1      active sync   /dev/sde1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8      145        3      active sync   /dev/sdj1
>    4     4       8      129        4      active sync   /dev/sdi1
>    5     5       0        0        5      faulty removed
>    6     6       8       81        6      spare   /dev/sdf1
>    7     7       8       97        7      spare   /dev/sdg1
>    8     8       8      113        8      spare   /dev/sdh1
> /dev/sdg1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
>   Creation Time : Fri Apr  9 19:24:51 2010
>      Raid Level : raid6
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 6
>   Total Devices : 8
> Preferred Minor : 0
> 
>     Update Time : Wed Jul  7 00:21:00 2010
>           State : active
>  Active Devices : 5
> Working Devices : 8
>  Failed Devices : 1
>   Spare Devices : 3
>        Checksum : 4439fedf - correct
>          Events : 991519
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     7       8       97        7      spare   /dev/sdg1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       65        1      active sync   /dev/sde1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8      145        3      active sync   /dev/sdj1
>    4     4       8      129        4      active sync   /dev/sdi1
>    5     5       0        0        5      faulty removed
>    6     6       8       81        6      spare   /dev/sdf1
>    7     7       8       97        7      spare   /dev/sdg1
>    8     8       8      113        8      spare   /dev/sdh1
> /dev/sdh1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
>   Creation Time : Fri Apr  9 19:24:51 2010
>      Raid Level : raid6
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 6
>   Total Devices : 8
> Preferred Minor : 0
> 
>     Update Time : Wed Jul  7 00:21:00 2010
>           State : active
>  Active Devices : 5
> Working Devices : 8
>  Failed Devices : 1
>   Spare Devices : 3
>        Checksum : 4439fef1 - correct
>          Events : 991519
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     8       8      113        8      spare   /dev/sdh1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       65        1      active sync   /dev/sde1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8      145        3      active sync   /dev/sdj1
>    4     4       8      129        4      active sync   /dev/sdi1
>    5     5       0        0        5      faulty removed
>    6     6       8       81        6      spare   /dev/sdf1
>    7     7       8       97        7      spare   /dev/sdg1
>    8     8       8      113        8      spare   /dev/sdh1
> /dev/sdi1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
>   Creation Time : Fri Apr  9 19:24:51 2010
>      Raid Level : raid6
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 6
>   Total Devices : 8
> Preferred Minor : 0
> 
>     Update Time : Wed Jul  7 00:21:00 2010
>           State : active
>  Active Devices : 5
> Working Devices : 8
>  Failed Devices : 1
>   Spare Devices : 3
>        Checksum : 4439feff - correct
>          Events : 991519
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     4       8      129        4      active sync   /dev/sdi1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       65        1      active sync   /dev/sde1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8      145        3      active sync   /dev/sdj1
>    4     4       8      129        4      active sync   /dev/sdi1
>    5     5       0        0        5      faulty removed
>    6     6       8       81        6      spare   /dev/sdf1
>    7     7       8       97        7      spare   /dev/sdg1
>    8     8       8      113        8      spare   /dev/sdh1
> /dev/sdj1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
>   Creation Time : Fri Apr  9 19:24:51 2010
>      Raid Level : raid6
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 6
>   Total Devices : 8
> Preferred Minor : 0
> 
>     Update Time : Wed Jul  7 00:21:00 2010
>           State : active
>  Active Devices : 5
> Working Devices : 8
>  Failed Devices : 1
>   Spare Devices : 3
>        Checksum : 4439ff0d - correct
>          Events : 991519
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     3       8      145        3      active sync   /dev/sdj1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       65        1      active sync   /dev/sde1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8      145        3      active sync   /dev/sdj1
>    4     4       8      129        4      active sync   /dev/sdi1
>    5     5       0        0        5      faulty removed
>    6     6       8       81        6      spare   /dev/sdf1
>    7     7       8       97        7      spare   /dev/sdg1
>    8     8       8      113        8      spare   /dev/sdh1
> /dev/sdk1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
>   Creation Time : Fri Apr  9 19:24:51 2010
>      Raid Level : raid6
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 6
>   Total Devices : 8
> Preferred Minor : 0
> 
>     Update Time : Tue Jul  6 23:37:42 2010
>           State : clean
>  Active Devices : 5
> Working Devices : 8
>  Failed Devices : 1
>   Spare Devices : 3
>        Checksum : 4449160f - correct
>          Events : 991518
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8      161        0      active sync   /dev/sdk1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       65        1      active sync   /dev/sde1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8      145        3      active sync   /dev/sdj1
>    4     4       8      129        4      active sync   /dev/sdi1
>    5     5       0        0        5      faulty removed
>    6     6       8       81        6      spare   /dev/sdf1
>    7     7       8       97        7      spare   /dev/sdg1
>    8     8       8      113        8      spare   /dev/sdh1
> /dev/sdl1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
>   Creation Time : Fri Apr  9 19:24:51 2010
>      Raid Level : raid6
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 6
>   Total Devices : 8
> Preferred Minor : 0
> 
>     Update Time : Wed Jul  7 00:21:00 2010
>           State : active
>  Active Devices : 5
> Working Devices : 8
>  Failed Devices : 1
>   Spare Devices : 3
>        Checksum : 4439ff2b - correct
>          Events : 991519
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8      177        2      active sync   /dev/sdl1
> 
>    0     0       8      161        0      active sync   /dev/sdk1
>    1     1       8       65        1      active sync   /dev/sde1
>    2     2       8      177        2      active sync   /dev/sdl1
>    3     3       8      145        3      active sync   /dev/sdj1
>    4     4       8      129        4      active sync   /dev/sdi1
>    5     5       0        0        5      faulty removed
>    6     6       8       81        6      spare   /dev/sdf1
>    7     7       8       97        7      spare   /dev/sdg1
>    8     8       8      113        8      spare   /dev/sdh1

