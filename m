From: Dietrich Heise <dh@dhde.de>
Subject: Re: RAID5 faild while in degraded mode, need help
Date: Mon, 9 Jul 2012 13:02:04 +0200
Message-ID: <CACMY3vDNoZN4tt4TRoE=49q9hkrFZ+7NRKgHHQXKe1_=wi8byw@mail.gmail.com>
References: <CACMY3vC=iAbKCssHH8CQ=msqNtmE1zF1muoZTusfRd989HvD_w@mail.gmail.com>
	<20120709101208.49528808@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120709101208.49528808@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

thanks for the hint.

I do a backup with dd before that, I hope I can get back the data of the raid.

The following is in the syslog:

Jul  8 19:21:15 p3 kernel: Buffer I/O error on device dm-1, logical
block 365625856
Jul  8 19:21:15 p3 kernel: Buffer I/O error on device dm-1, logical
block 365625856
Jul  8 19:21:15 p3 kernel: lost page write due to I/O error on dm-1
Jul  8 19:21:15 p3 kernel: lost page write due to I/O error on dm-1
Jul  8 19:21:15 p3 kernel: JBD: I/O error detected when updating
journal superblock for dm-1.
Jul  8 19:21:15 p3 kernel: JBD: I/O error detected when updating
journal superblock for dm-1.
Jul  8 19:21:15 p3 kernel: RAID conf printout:
Jul  8 19:21:15 p3 kernel: RAID conf printout:
Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
Jul  8 19:21:15 p3 kernel: disk 3, o:0, dev:sdd1
Jul  8 19:21:15 p3 kernel: disk 3, o:0, dev:sdd1
Jul  8 19:21:15 p3 kernel: RAID conf printout:
Jul  8 19:21:15 p3 kernel: RAID conf printout:
Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
Jul  8 19:21:15 p3 kernel: --- level:5 rd:4 wd:2
Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
Jul  8 19:21:15 p3 kernel: disk 0, o:1, dev:sdf1
Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
Jul  8 19:21:15 p3 kernel: disk 1, o:1, dev:sde1
Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
Jul  8 19:21:15 p3 kernel: disk 2, o:1, dev:sdc1
Jul  8 19:21:15 p3 kernel: md: recovery of RAID array md0
Jul  8 19:21:15 p3 kernel: md: recovery of RAID array md0
Jul  8 19:21:15 p3 kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Jul  8 19:21:15 p3 kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Jul  8 19:21:15 p3 kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for recovery.
Jul  8 19:21:15 p3 kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for recovery.
Jul  8 19:21:15 p3 kernel: md: using 128k window, over a total of 1465126400k.
Jul  8 19:21:15 p3 kernel: md: using 128k window, over a total of 1465126400k.
Jul  8 19:21:15 p3 kernel: md: resuming recovery of md0 from checkpoint.
Jul  8 19:21:15 p3 kernel: md: resuming recovery of md0 from checkpoint.

I think the right order is sdf1 sde1 sdc1 sdd1, I am right?

So I have to do:

mdadm -C /dev/md1 -l5 -n4 -e 1.2 -c 512 /dev/sdf1 /dev/sde1 missing /dev/sdd1

The question is: sould I also add --assume-clean

Thanks!
Dietrich

Am 09.07.2012 02:12 schrieb "NeilBrown" <neilb@suse.de>:
>
> On Sun, 8 Jul 2012 21:05:02 +0200 Dietrich Heise <dh@dhde.de> wrote:
>
> > Hi,
> >
> > the following Problem,
> > One of four drives has S.M.A.R.T. errors, so I removed it and
> > replaced, with a new one.
> >
> > In the time the drive was rebuilding, one of the three left devices
> > has an I/O error (sdd1) (sdc1 was the replaced drive an was syncing).
> >
> > Now the following happends (two drives are spare drives :( )
>
> It looks like you tried to --add /dev/sdd1 back in after it failed, and mdadm
> let new.  Newer versions of mdadm will refuse as that is not a good thing to
> do but it shouldn't stop you getting your data back.
>
> First thing to realise is that you could have data corruption.  There is at
> least one block in the array which cannot be recovered, possibly more.  i.e.
> any block on sdd1 which is bad, and any block at the same offset in sdc1.
> These blocks may not be in files which would be lucky, or they may contain
> important metadata which might mean you've lost lots of files.
>
> If you hadn't tried to --add /dev/sdd1 you could just force-assemble the
> array back to degraded mode (without sdc1) and back up any critical data.
> As sdd1 now thinks it is a spare you need to re-create the array instead:
>
>  mdadm -S /dev/md1
>  mdadm -C /dev/md1 -l5 -n4 -e 1.2 -c 512 /dev/sdf1 /dev/sde1 /dev/sdd1 missing
> or
>  mdadm -C /dev/md1 -l5 -n4 -e 1.2 -c 512 /dev/sdf1 /dev/sde1 missing /dev/sdd1
>
> depending on whether sdd1 as the 3rd or 4th device in the array - I cannot
> tell from the output here.
>
> You should then be able to mount the array and backup stuff.
>
> You then want to use 'ddrescue' to copy sdd1 onto a device with no bad
> blocks, and assemble  the array using the device instead of sdd1.
>
> Finally, you can add the new spare (sdc1) to the array and it should rebuild
> successfully - providing there are no bad blocks on sdf1 or sde1.
>
> I hope that makes sense.  Do ask if anything is unclear.
>
> NeilBrown
>
>
> >
> > p3 disks # mdadm -D /dev/md1
> > /dev/md1:
> >         Version : 1.2
> >   Creation Time : Mon Feb 28 19:57:56 2011
> >      Raid Level : raid5
> >   Used Dev Size : 1465126400 (1397.25 GiB 1500.29 GB)
> >    Raid Devices : 4
> >   Total Devices : 4
> >     Persistence : Superblock is persistent
> >
> >     Update Time : Sun Jul  8 20:37:12 2012
> >           State : active, FAILED, Not Started
> >  Active Devices : 2
> > Working Devices : 4
> >  Failed Devices : 0
> >   Spare Devices : 2
> >
> >          Layout : left-symmetric
> >      Chunk Size : 512K
> >
> >            Name : p3:0  (local to host p3)
> >            UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
> >          Events : 121205
> >
> >     Number   Major   Minor   RaidDevice State
> >        0       8       81        0      active sync   /dev/sdf1
> >        1       8       65        1      active sync   /dev/sde1
> >        2       0        0        2      removed
> >        3       0        0        3      removed
> >
> >        4       8       49        -      spare   /dev/sdd1
> >        5       8       33        -      spare   /dev/sdc1
> >
> > here is more information:
> >
> > p3 disks # mdadm -E /dev/sdc1
> > /dev/sdc1:
> >           Magic : a92b4efc
> >         Version : 1.2
> >     Feature Map : 0x0
> >      Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
> >            Name : p3:0  (local to host p3)
> >   Creation Time : Mon Feb 28 19:57:56 2011
> >      Raid Level : raid5
> >    Raid Devices : 4
> >
> >  Avail Dev Size : 2930275057 (1397.26 GiB 1500.30 GB)
> >      Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
> >   Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
> >     Data Offset : 2048 sectors
> >    Super Offset : 8 sectors
> >           State : active
> >     Device UUID : caefb029:526187ef:2051f578:db2b82b7
> >
> >     Update Time : Sun Jul  8 20:37:12 2012
> >        Checksum : 18e2bfe1 - correct
> >          Events : 121205
> >
> >          Layout : left-symmetric
> >      Chunk Size : 512K
> >
> >    Device Role : spare
> >    Array State : AA.. ('A' == active, '.' == missing)
> > p3 disks # mdadm -E /dev/sdd1
> > /dev/sdd1:
> >           Magic : a92b4efc
> >         Version : 1.2
> >     Feature Map : 0x0
> >      Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
> >            Name : p3:0  (local to host p3)
> >   Creation Time : Mon Feb 28 19:57:56 2011
> >      Raid Level : raid5
> >    Raid Devices : 4
> >
> >  Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
> >      Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
> >   Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
> >     Data Offset : 2048 sectors
> >    Super Offset : 8 sectors
> >           State : active
> >     Device UUID : 4231e244:60e27ed4:eff405d0:2e615493
> >
> >     Update Time : Sun Jul  8 20:37:12 2012
> >        Checksum : 4bec6e25 - correct
> >          Events : 0
> >
> >          Layout : left-symmetric
> >      Chunk Size : 512K
> >
> >    Device Role : spare
> >    Array State : AA.. ('A' == active, '.' == missing)
> > p3 disks # mdadm -E /dev/sde1
> > /dev/sde1:
> >           Magic : a92b4efc
> >         Version : 1.2
> >     Feature Map : 0x0
> >      Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
> >            Name : p3:0  (local to host p3)
> >   Creation Time : Mon Feb 28 19:57:56 2011
> >      Raid Level : raid5
> >    Raid Devices : 4
> >
> >  Avail Dev Size : 2930253889 (1397.25 GiB 1500.29 GB)
> >      Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
> >   Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
> >     Data Offset : 2048 sectors
> >    Super Offset : 8 sectors
> >           State : active
> >     Device UUID : 28b08f44:4cc24663:84d39337:94c35d67
> >
> >     Update Time : Sun Jul  8 20:37:12 2012
> >        Checksum : 15faa8a1 - correct
> >          Events : 121205
> >
> >          Layout : left-symmetric
> >      Chunk Size : 512K
> >
> >    Device Role : Active device 1
> >    Array State : AA.. ('A' == active, '.' == missing)
> > p3 disks # mdadm -E /dev/sdf1
> > /dev/sdf1:
> >           Magic : a92b4efc
> >         Version : 1.2
> >     Feature Map : 0x0
> >      Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
> >            Name : p3:0  (local to host p3)
> >   Creation Time : Mon Feb 28 19:57:56 2011
> >      Raid Level : raid5
> >    Raid Devices : 4
> >
> >  Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
> >      Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
> >   Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
> >     Data Offset : 2048 sectors
> >    Super Offset : 8 sectors
> >           State : active
> >     Device UUID : 78d5600a:91927758:f78a1cea:3bfa3f5b
> >
> >     Update Time : Sun Jul  8 20:37:12 2012
> >        Checksum : 7767cb10 - correct
> >          Events : 121205
> >
> >          Layout : left-symmetric
> >      Chunk Size : 512K
> >
> >    Device Role : Active device 0
> >    Array State : AA.. ('A' == active, '.' == missing)
> >
> > Is there a way to repair the raid?
> >
> > thanks!
> > Dietrich
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
