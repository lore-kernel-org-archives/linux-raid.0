From: Wes Armour <wes.armour@physics.org>
Subject: Rebuilding a RAID 5 array
Date: Tue, 8 Oct 2002 11:14:11 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210081114.11952.wes.armour@physics.org>
Reply-To: wes.armour@physics.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

We are having some problems with our RAID 5 array.
We have a PC using the Promise ATA133 controller running a 4 x 160Gb disk RAID 
5 array. The promise bios is set to striping and our raidtab file looks like:

# raiddev configuration file
raiddev /dev/md0
        raid-level              5
        nr-raid-disks           4
        nr-spare-disks          0
        persistent-superblock   1
        chunk-size              16K             
        parity-algorithm        left-symmetric
         
        device                  /dev/sda
        raid-disk               0
        device                  /dev/sdb
        raid-disk               1
        device                  /dev/sdc
        raid-disk               2
        device                  /dev/sdd
        raid-disk               3

Before we use the system to store real data we would like to test it and 
ensure that we can rebuild the array if a disk fails.
To simulate disk failure we shut the machine down and then unplug one of the 
160 Gb drives, we then reboot the machine and the array come back up with 3 
out of the four disks working, great!, but we cannot add a new disk into the 
array (This is the unplugged disk re-formated with an fd file system). We 
have tried using 

mkraid --upgrade --configfile raid.promise /dev/md0 

and then,

raidhotadd --configfile raid.promise /dev/md0 /dev/sda,

but it does not work. Could we be having problems because we are using 
striping in the promise bios?

Thanks,

Wes.
