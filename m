From: SoulBlazer <soul@lamp-post.net>
Subject: Re: 2 HBA's and Multipath.
Date: Tue, 23 Apr 2002 17:45:35 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020423214812Z315350-22651+15329@vger.kernel.org>
References: <20020408190441Z313735-22651+2113@vger.kernel.org> <20020419162031Z312453-22651+11469@vger.kernel.org> <20020419215843.GB21753@colombina.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020419215843.GB21753@colombina.comedia.it>
To: bluca@comedia.it
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca, 

Here are the results the modifications you suggested :

# : mdadm -D /dev/md/0
/dev/md/0:
        Version : 00.90.00
  Creation Time : Tue Apr 23 15:55:33 2002
     Raid Level : multipath
     Array Size : 17688448 (16.86 GiB 18.11 GB)
   Raid Devices : 1
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Apr 23 16:00:31 2002
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1


    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   
/dev/scsi/host2/bus0/target0/lun0/part1
       1      65       97        1      active   
/dev/scsi/host3/bus0/target0/lun0/part1
           UUID : b0191dc2:e89b155f:66c3e4e4:fa925d37

# : cat /proc/mdstat
md0 : active multipath scsi/host3/bus0/target0/lun0/part1[1] 
scsi/host2/bus0/target0/lun0/part1[0]
      17688448 blocks [1/2] [U]

Again only one HBA is utilized, which is verified via the previous testing I 
had run.  I believe that even after we hack the code to set all disks to 
'active', the raid code will still only use the first drive it finds that is 
not a spare.

--Snippit-- (multipath.c)
  * Mark all disks as spare to start with, then pick our
  * active disk.  If we have a disk that is marked active
  * in the sb, then use it, else use the first rdev.  
--Snippit--

Additionally I have noticed the following in my syslog on the mkraid of the 
multipath device.

--Snippit--
[events: 00000002]
[events: 00000002]
md: autorun ...
md: considering scsi/host3/bus0/target0/lun0/part1 ...
md:  adding scsi/host3/bus0/target0/lun0/part1 ...
md:  adding scsi/host2/bus0/target0/lun0/part1 ...
md: created md0
md: bind<scsi/host2/bus0/target0/lun0/part1,1>
md: bind<scsi/host3/bus0/target0/lun0/part1,2>
md: running: 
<scsi/host3/bus0/target0/lun0/part1><scsi/host2/bus0/target0/lun0/part1>
md: scsi/host3/bus0/target0/lun0/part1's event counter: 00000002
md: scsi/host2/bus0/target0/lun0/part1's event counter: 00000002
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
multipath: making IO path scsi/host3/bus0/target0/lun0/part1 a spare path 
(not in sync)
multipath: device scsi/host3/bus0/target0/lun0/part1 operational as IO path 1
multipath: device scsi/host2/bus0/target0/lun0/part1 operational as IO path 0
(checking disk 0)
(checking disk 1)
multipath: array md0 active with 1 out of 1 IO paths (1 spare IO paths)
md: updating md0 RAID superblock on device
md: (skipping alias scsi/host3/bus0/target0/lun0/part1 )
md: scsi/host2/bus0/target0/lun0/part1 [events: 00000003]<6>(write) 
scsi/host2/bus0/target0/lun0/part1's sb offset: 17688448

--Snippit--

Please note the comment about host3 being marked a spare path (not in sync).



Any comments as always, are welcome.


On April 19, 2002 05:58 pm, Luca Berra wrote:

> Oops,
> seems i forgot about spares :(
>
> multipath.c sets all disks as spares to start with.
> a dirty hack could be:
>
> look for:
>         /*
>          * Mark all disks as spare to start with, then pick our
>          * active disk.  If we have a disk that is marked active
>          * in the sb, then use it, else use the first rdev.
>          */
>
> below you will find:
>        if (disk_active(desc)) {
>             if(!conf->working_disks) { //remove this line
>                 printk(OPERATIONAL, partition_name(rdev->dev),
>                     desc->raid_disk);
>                 disk->operational = 1;
>                 disk->spare = 0;
>                 conf->working_disks++;
>                 def_rdev = rdev;
>             } else { //remove this line
>                 mark_disk_spare(desc); //remove this line
>             } //remove this line
>         } else
>             mark_disk_spare(desc);
>
> remove the lines i market with //remove this line
> and it should activate the disks
>
> i wont have a system at hand to test this, so please let me know
> if it works
>
> we then need to clean up the logic for initialization
> since is nonsense to set a disk as spare then reset it back
> again as operational, but this could work for a start
>
> good luck
>
> L.
