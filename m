From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: my io testing scripts
Date: Mon, 11 Feb 2008 18:25:36 +0100
Message-ID: <20080211172536.GA26017@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here are my testing scripts used in the performance howto:
http://linux-raid.osdl.org/index.php/Home_grown_testing_methods

=Hard disk performance scripts=
Here are the scripts that I used for my performance measuring. Use at your own risk.
They destroy the contents of the partitions involved. The /dev/md raid needs to
be stopped before initiating the test.

Copyright Keld Simonsen, keld@dkuug.dk 2008. Licensed under the GPL.

iotest:
   
   #!/bin/sh
   # invoked by
   # iotest "mdadm -R -C /dev/md1 --chunk=256 -l 10 -n 2 -p f2 "  /dev/md1 /mnt/md1 ext3 " /dev/hdb5 /dev/hdd5 "
   echo "\n" $1 $5 "\n" >> /tmp/results
   echo $1 $5
   $1 $5
   mkfs -t $4 $2
   mkdir $3
   mount $2 $3
   cd $3
   echo "\nmakefiles\n" >> /tmp/results
   mkfiles 200
   echo "\n remakefiles \n" >>/tmp/results
   mkfiles 200
   echo "\n catall \n" >>/tmp/results
   cat * >/dev/null
   echo "\n catnull \n" >>/tmp/results
   catnull
   cd
   umount $2
   mdadm -S $2
   echo "\n finish " $1 " " $5 "\n"  >> /tmp/results
   
Be careful with this script, and remember to change the ordinary test to only one partition
   
iorun:   
   #!/bin/sh
   # set up ram disk
   DISKS="/dev/sda2 /dev/sdb2"
   iostat -k 10 > /tmp/results &
   iotest " "                                                   /dev/sda2 /mnt/sda2 ext3 " "
   iotest "mdadm -C /dev/md1 --chunk=256 -R -l  0 -n 2      " /dev/md1 /mnt/md1 ext3 "$DISKS"
   iotest "mdadm -C /dev/md1 --chunk=256 -R -l  1 -n 2      " /dev/md1 /mnt/md1 ext3 "$DISKS"
   iotest "mdadm -C /dev/md1 --chunk=256 -R -l 10 -n 2      " /dev/md1 /mnt/md1 ext3 "$DISKS"
   iotest "mdadm -C /dev/md1 --chunk=256 -R -l 10 -n 2 -p f2 " /dev/md1 /mnt/md1 ext3 "$DISKS"
   # iotest     "mdadm -C /dev/md1 --chunk=256 -R -l 10 -n 2 -p o2 " /dev/md1 /mnt/md1 ext3 "$DISKS"
   
mkfiles:   
   #!/bin/sh
   for (( i = 1; i < $1 ; i++ )) ; do dd if=/dev/hda1 of=$i bs=1MB count=40 ; done
   for (( i = 1; i < $1 ; i++ )) ; do dd if=/dev/hda1 of=$i bs=1MB count=40 & ; done
   
catnull:   
   #!/bin/tcsh
   foreach i ( * ) 
        cat $i >/dev/null &
   end
   wait
