From: Jay Roberts <roberts@oddpost.com>
Subject: New RAID array syncs very slow
Date: Tue, 23 Mar 2004 07:21:59 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40602BE7.8080705@oddpost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just set up a new Raid5 array using 4 200GB disks on 2 controllers. I 
created the array, and it begins to sync up, but it will not sync at 
over 600Kb. It has been over 12 hours now, and the sync is only 7% done. 
From reading, I know that sync should only take a few hours, but at the 
current rate mine will take 91 hours which seems like an insane amount 
of time. I am looking for any advice on this.  Details follow:

Hardware:
Disks: 4 Seagate 200GB 7200 RPM ST3200822A
Controllers: 2 Promise Ultra133 TX2 IDE controllers, one disk on each 
channel, Ultra133 cables.
CPU: PIII - 450 Mhz.
MB: Abit BE-6II (intel 440 bx)
512MB Ram.
OS boots and runs off a Atlas 10k SCSI drive attached to an Adaptec 
U19160 scsi card.

Software:
Debian Testing, kernel 2.6.3, mdadm -- whatever came with apt-get

I created the array using
#mdadm --create /dev/md0 --verbose --chunk=128 --level=5 
--parity=left-symmetric --raid-devices=4 --spare-devices=0

I also tried bumping up /proc/sys/dev/raid/speed_limit_min to 100000

Output of #cat /proc/mdstat

Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
md0 : active raid5 hdk[3] hdi[2] hdg[1] hde[0]
      586082688 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]
      [=>...................]  resync =  8.0% (15647744/195360896) 
finish=5491.2min speed=543K/sec
unused devices: <none>

Output of #mdadm --detail /dev/md0

        Version : 00.90.01
  Creation Time : Mon Mar 22 00:18:13 2004
     Raid Level : raid5
     Array Size : 586082688 (558.93 GiB 600.15 GB)
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Mar 22 00:18:13 2004
          State : clean, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0      33        0        0      active sync   /dev/hde
       1      34        0        1      active sync   /dev/hdg
       2      56        0        2      active sync   /dev/hdi
       3      57        0        3      active sync   /dev/hdk
           UUID : 5152287c:34d31d31:19a993d7:946f87c9
         Events : 0.2

After this, I moved all the hardware to an Asus A7V MB, with a 1.3 
Duron, and ran a stock Sarge install. I got Faster results, but still it 
is going to take about 18 hours to sync the set of disks. Now after 
about 5 hours in the new rig i Get:

debian:~# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 ide/host4/bus1/target0/lun0/disc[3] 
ide/host4/bus0/target0/lun0/disc[2] ide/host2/bus1/target0/lun0/disc[1] 
ide/host2/bus0/target0/lun0/disc[0]
      586082688 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]
      [======>..............]  resync = 30.2% (59040244/195360896) 
finish=781.7min speed=2904K/sec
unused devices: <none>


Based on things I have read this seems way too long. I must be screwing 
up some where I can't see.

Any help at all is appreciated. Quite a few hours of googling has 
yielded little.

