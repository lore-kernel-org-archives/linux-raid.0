From: drtebi@drtebi.com
Subject: RAID1 always resyncs at boot???
Date: Thu, 27 Nov 2003 07:13:41 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <hp0nmt.3pm23q@mail.drtebi.com>
Reply-To: drtebi@drtebi.com
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have browsed numerous threads and got my RAID 1 to work just fine. However,
there is one strange problem I have that I couldn't get an answer to:

After booting, my /proc/mdstat looked like this:

Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 ide/host0/bus0/target0/lun0/part1[0]
ide/host0/bus1/target0/lun0/part1[1]
      120053632 blocks [2/2] [UU]
      [>....................]  resync =  1.3% (1601708/120053632)
finish=164.9min speed=11969K/sec
unused devices: <none>

OK, so I figured the RAID is being built (synced), and waited until it was
done. Then the same command showed everything was fine and running:

Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 ide/host0/bus0/target0/lun0/part1[0]
ide/host0/bus1/target0/lun0/part1[1]
      120053632 blocks [2/2] [UU]

unused devices: <none>

However, the problem is if I reboot, it starts all over again with the resync,
(from 0), every time! Here is what I get from dmesg:
--- snip ---
md: raid1 personality registered as nr 3
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
 [events: 00000010]
 [events: 00000010]
md: autorun ...
md: considering ide/host0/bus1/target0/lun0/part1 ...
md:  adding ide/host0/bus1/target0/lun0/part1 ...
md:  adding ide/host0/bus0/target0/lun0/part1 ...
md: created md0
md: bind<ide/host0/bus0/target0/lun0/part1,1>
md: bind<ide/host0/bus1/target0/lun0/part1,2>
md: running:
<ide/host0/bus1/target0/lun0/part1><ide/host0/bus0/target0/lun0/part1>
md: ide/host0/bus1/target0/lun0/part1's event counter: 00000010
md: ide/host0/bus0/target0/lun0/part1's event counter: 00000010
md: md0: raid array is not clean -- starting background reconstruction
md: RAID level 1 does not need chunksize! Continuing anyway.
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device ide/host0/bus1/target0/lun0/part1 operational as mirror 1
raid1: device ide/host0/bus0/target0/lun0/part1 operational as mirror 0
raid1: raid set md0 not clean; reconstructing mirrors
raid1: raid set md0 active with 2 out of 2 mirrors
md: updating md0 RAID superblock on device
md: ide/host0/bus1/target0/lun0/part1 [events: 00000011]<6>(write)
ide/host0/bus1/target0/lun0/part1's sb offset: 120053632
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000 KB/sec)
for reconstruction.
md: using 124k window, over a total of 120053632 blocks.
md: ide/host0/bus0/target0/lun0/part1 [events: 00000011]<6>(write)
ide/host0/bus0/target0/lun0/part1's sb offset: 120053632
md: ... autorun DONE.
--- snip ---

Everything like reading and writing to the md0 works just fine, and still does
now, except the resync starts again at every boot! 
What is wrong, or what is it that I don't understand? Is it supposed to resync
at every boot?
I checked my kernel messages, there was nothing indicating that any of the
drives are bad. I am not using the RAID as a boot drive, simply as a storage.


----------------- Details about my install --------------
My system:
400 MgHz Pentium III
SuperMicro P6SBS
256MB SDRAM (Crucial)
Quantum Viking II 4.5 GB SCSI Disk (holds the Gentoo OS)
2 x Maxtor Diamond 9 120 GB disk (for the RAID1)
3COM NIC

I used Gentoo's LiveCD "x86-basic-1.4-20030911.iso", which is using Kernel
2.4.20, and installed everything from scratch, with RAID support:

[*] Multiple devices driver support (RAID and LVM)
<*>  RAID support
< >   Linear (append) mode
< >   RAID-0 (striping) mode
<*>   RAID-1 (mirroring) mode
< >   RAID-4/RAID-5 mode
< >   Multipath I/O support
< >  Logical volume manager (LVM) support

To create the RAID, I used cfdisk to create one primary partion, so about
114GB, on each drive. I set the partion type to FD.
I rebooted to see if the system read the partions correctly. Then I created
the RAID 1 with mdadm:

mdadm --create /dev/md0 --chunk=128 --level=1 raid-devices=2 /dev/hd[ac]1

This command also starts the RAID. So all that was left to do is create a file
system on the disks and start using them. I chose XFS:

mkfs.xfs -d agcount=64 -l size=32m /dev/md0

This is my /etc/mdadm.conf:

DEVICE /dev/hda1 /dev/hdc1
ARRAY /dev/md0 devices=/dev/hda1,/dev/hdc1

and this my /etc/fstab:

# <fs>               <mountpoint>   <type>      <opts>            <dump/pass>
/dev/sda1            /boot          ext2        noauto,noatime    1 1
/dev/sda5            /              xfs         noatime           0 0
/dev/dsa2            none           swap        sw                0 0
/dev/md0             /raid          xfs         noatime           0 0
/dev/cdroms/cdrom0   /mnt/cdrom     iso9660     noauto,ro         0 0
proc                 /proc          proc        defaults          0 0
tmpfs                /dev/shm       tmpfs       defaults          0 0

...please help/explain what the problem is.


