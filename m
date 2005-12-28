From: Mitchell Laks <mlaks@verizon.net>
Subject: raid1: All my data completely vanished into the void
Date: Tue, 27 Dec 2005 23:40:48 -0500
Message-ID: <200512272340.48483.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just set up a new server running stable Debian Sarge, fresh install,
mdadm 1.9.0,  linux kernel 2.6.8-2 
and all my (test) data has vanished into the ether. 

What did I do wrong? I don't want this to happen in real life :).

I have 6x 400Gb Western Digital sata drives attached to  sata controllers. One 
pair of channels  is on the motherboard using VIA VT8237 controller 
and 2 highpoint 1520 sata cards give 4 other channels.

/dev/sda
/dev/sdb
/dev/sdc
/dev/sdd
/dev/sde
/dev/sdf

I partioned each hard drive completely as 1 partition, type fd
ie  fdisk then "n p 1 enter t fd w q":

/dev/sda1
/dev/sdb1
/dev/sdc1
/dev/sdd1
/dev/sde1
/dev/sdf1

I then created 3 raid1 arrays
mdadm -Cv -n2 -l1 /dev/md0 /dev/sda1 /dev/sdb1
mdadm -Cv -n2 -l1 /dev/md1 /dev/sdc1 /dev/sdd1
mdadm -Cv -n2 -l1 /dev/md2 /dev/sde1 /dev/sdf1

I then formated
mkfs.ext3 /dev/md0
mkfs.ext3 /dev/md1
mkfs.ext3 /dev/md2

I then mounted
mount /dev/md0 /home/big0
mount /dev/md1 /home/big1
mount /dev/md2 /home/big2

I then waited until all syncing was done.

Then I copied 3 gb of data to the 3 arrays from another machine over the 
network via rsync.


I did df -h and indeed the data was there. I cd into the directories and there 
was data there.

Then I did 
shutdown -h now

however I did not!! (?evil) umount the different devices 
/dev/md0 /dev/md1 /dev/md2 before doing that.

Now I reboot into linux. 

I try to assemble the arrays
mdadm -A /dev/md0 /dev/sda1 /dev/sdb1

mdadm --detail --scan gives me nothing at all.

And I get nothing.
I do fdisk -l

and no trace of any of the partitions. It is as if there are no 
partitions /dev/sdX1, where X is a-f.
I do 
fdisk /dev/sda

I get message:

Device contains neither a valid DOS partition table, nor Sun, SGI or OSF 
disklabel
Building a new DOS disklabel. Changes will remain in memory only,
until you decide to write them. After that, of course, the previous
content won't be recoverable.


The number of cylinders for this disk is set to 48641.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)
Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

p shows nothing!!

??????????????????????????????

Did I screw up everything by not unmounting the devices? What happened?

  
Thanks,
Mitchell Laks
