From: "Jon Sabo" <jonathan.sabo@gmail.com>
Subject: Re: help diagnosing bad disk
Date: Wed, 19 Dec 2007 14:15:49 -0500
Message-ID: <fa2952810712191115k414092cfx1132830fea42f3fb@mail.gmail.com>
References: <fa2952810712191018l76085e90l4eb2c6a81115fa1f@mail.gmail.com>
	 <47696E1E.2060204@tmr.com>
	 <fa2952810712191109n41c95dcfl13496eeb48223a9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa2952810712191109n41c95dcfl13496eeb48223a9f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think I got it now.  Thanks for your help!

root@recoil:/home/illsci# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Mon Jul 30 21:47:14 2007
     Raid Level : raid1
     Array Size : 1951744 (1906.32 MiB 1998.59 MB)
    Device Size : 1951744 (1906.32 MiB 1998.59 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Dec 19 14:15:31 2007
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 157f716c:0e7aebca:c20741f6:bb6099c9
         Events : 0.48

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0        1      removed
root@recoil:/home/illsci# mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90.03
  Creation Time : Mon Jul 30 21:47:47 2007
     Raid Level : raid1
     Array Size : 974808064 (929.65 GiB 998.20 GB)
    Device Size : 974808064 (929.65 GiB 998.20 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Wed Dec 19 14:19:06 2007
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 156a030e:9a6f8eb3:9b0c439e:d718e744
         Events : 0.1498998

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       18        1      active sync   /dev/sdb2
root@recoil:/home/illsci# mdadm /dev/md0 -a /dev/sdb1
mdadm: re-added /dev/sdb1
root@recoil:/home/illsci# mdadm /dev/md1 -a /dev/sda2
mdadm: re-added /dev/sda2
root@recoil:/home/illsci# cat /proc/mdstat
Personalities : [multipath] [raid1]
md1 : active raid1 sda2[2] sdb2[1]
      974808064 blocks [2/1] [_U]
        resync=DELAYED

md0 : active raid1 sdb1[2] sda1[0]
      1951744 blocks [2/1] [U_]
      [=================>...]  recovery = 86.6% (1693504/1951744)
finish=0.0min speed=80643K/sec

unused devices: <none>
root@recoil:/home/illsci# cat /proc/mdstat
Personalities : [multipath] [raid1]
md1 : active raid1 sda2[2] sdb2[1]
      974808064 blocks [2/1] [_U]
      [>....................]  recovery =  0.0% (86848/974808064)
finish=186.9min speed=86848K/sec

md0 : active raid1 sdb1[1] sda1[0]
      1951744 blocks [2/2] [UU]

unused devices: <none>


On Dec 19, 2007 2:09 PM, Jon Sabo <jonathan.sabo@gmail.com> wrote:
> We'll here's the rest of the info I should have sent in the last email:
>
> root@recoil:/home/illsci# cat /proc/mdstat
> Personalities : [multipath] [raid1]
> md1 : active raid1 sdb2[1]
>       974808064 blocks [2/1] [_U]
>
> md0 : active raid1 sda1[0]
>       1951744 blocks [2/1] [U_]
>
> unused devices: <none>
> root@recoil:/home/illsci# dmesg | grep sdb
> sd 1:0:0:0: [sdb] 1953523055 512-byte hardware sectors (1000204 MB)
> sd 1:0:0:0: [sdb] Write Protect is off
> sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 1:0:0:0: [sdb] 1953523055 512-byte hardware sectors (1000204 MB)
> sd 1:0:0:0: [sdb] Write Protect is off
> sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sdb: sdb1 sdb2
> sd 1:0:0:0: [sdb] Attached SCSI disk
> md: bind<sdb1>
> md: kicking non-fresh sdb1 from array!
> md: unbind<sdb1>
> md: export_rdev(sdb1)
> md: bind<sdb2>
> root@recoil:/home/illsci# dmesg | grep sda
> sd 0:0:0:0: [sda] 1953523055 512-byte hardware sectors (1000204 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 0:0:0:0: [sda] 1953523055 512-byte hardware sectors (1000204 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda: sda1 sda2
> sd 0:0:0:0: [sda] Attached SCSI disk
> md: bind<sda1>
> md: bind<sda2>
> md: kicking non-fresh sda2 from array!
> md: unbind<sda2>
> md: export_rdev(sda2)
>
> root@recoil:/home/illsci# smartctl -a /dev/sda
> smartctl version 5.36 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6
> Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
>
> Device: ATA      Hitachi HDS72101 Version: GKAO
> Serial number:       GTJ000PAG2HZUC
> Device type: disk
> Local Time is: Wed Dec 19 14:13:47 2007 EST
> Device does not support SMART
>
> Error Counter logging not supported
>
> [GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S on']
> Device does not support Self Test logging
> root@recoil:/home/illsci# smartctl -a /dev/sdb
> smartctl version 5.36 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6
> Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
>
> Device: ATA      Hitachi HDS72101 Version: GKAO
> Serial number:       GTJ000PAG2K43C
> Device type: disk
> Local Time is: Wed Dec 19 14:13:49 2007 EST
> Device does not support SMART
>
> Error Counter logging not supported
>
> [GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S on']
> Device does not support Self Test logging
>
>
>
>
>
> On Dec 19, 2007 2:16 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> >
> > Jon Sabo wrote:
> > > So I was trying to copy over some Indiana Jones wav files and it
> > > wasn't going my way.  I noticed that my software raid device showed:
> > >
> > > /dev/md1 on / type ext3 (rw,errors=remount-ro)
> > >
> > > Is this saying that it was remounted, read only because it found a
> > > problem with the md1 meta device?  That's what it looks like it's
> > > saying but I can still write to /.
> > >
> > > mdadm --detail showed:
> > >
> > > root@recoil:/home/illsci# mdadm --detail /dev/md0
> > > /dev/md0:
> > >         Version : 00.90.03
> > >   Creation Time : Mon Jul 30 21:47:14 2007
> > >      Raid Level : raid1
> > >      Array Size : 1951744 ( 1906.32 MiB 1998.59 MB)
> > >     Device Size : 1951744 (1906.32 MiB 1998.59 MB)
> > >    Raid Devices : 2
> > >   Total Devices : 1
> > > Preferred Minor : 0
> > >     Persistence : Superblock is persistent
> > >
> > >     Update Time : Wed Dec 19 12:59:56 2007
> > >           State : clean, degraded
> > >  Active Devices : 1
> > > Working Devices : 1
> > >  Failed Devices : 0
> > >   Spare Devices : 0
> > >
> > >            UUID : 157f716c:0e7aebca:c20741f6
> > > :bb6099c9
> > >          Events : 0.28
> > >
> > >      Number   Major   Minor   RaidDevice State
> > >        0       8        1        0      active sync   /dev/sda1
> > >        1       0        0        1      removed
> > >
> > > root@recoil:/home/illsci# mdadm --detail /dev/md1
> > >  /dev/md1:
> > >         Version : 00.90.03
> > >   Creation Time : Mon Jul 30 21:47:47 2007
> > >      Raid Level : raid1
> > >      Array Size : 974808064 (929.65 GiB 998.20 GB)
> > >     Device Size : 974808064 (929.65 GiB 998.20 GB)
> > >     Raid Devices : 2
> > >   Total Devices : 1
> > > Preferred Minor : 1
> > >     Persistence : Superblock is persistent
> > >
> > >     Update Time : Wed Dec 19 13:14:53 2007
> > >           State : clean, degraded
> > >  Active Devices : 1
> > > Working Devices : 1
> > >  Failed Devices : 0
> > >   Spare Devices : 0
> > >
> > >            UUID : 156a030e:9a6f8eb3:9b0c439e:d718e744
> > >          Events : 0.1990
> > >
> > >     Number   Major   Minor   RaidDevice State
> > >        0       8        2        0      active sync   /dev/sda2
> > >        1       0        0        1      removed
> > >
> > >
> > > I have two 1 terabyte sata drives in this box.  From what I was
> > > reading wouldn't it show an F for the failed drive?  I thought I would
> > > see that /dev/sdb1 and /dev/sdb2 were failed and it would show an F.
> > > What is this saying and how do you know that its /dev/sdb and not some
> > > other drive?  It shows removed and that the state is clean, degraded.
> > > Is that something you can recover from with out returning this disk
> > > and putting in a new one to add to the raid1 array?
> > >
> >
> > You can try adding the partitions back to your array, but I suspect
> > something bad has happened to your sdb drive, since it's failed out of
> > both arrays. You can use dmesg to look for any additional information.
> >
> > Justin gave you the rest of the info you need to investigate, I'll not
> > repeat it. ;-)
> >
> > --
> > Bill Davidsen <davidsen@tmr.com>
> >   "Woe unto the statesman who makes war without a reason that will still
> >   be valid when the war is over..." Otto von Bismark
> >
> >
> >
>
