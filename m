From: Ron Leach <ronleach@tesco.net>
Subject: If separate md for /boot, OS, and /srv, must 'create' on disks with
 3 partns?
Date: Sun, 19 Jan 2014 18:39:41 +0000
Message-ID: <52DC1BED.7070901@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

List, may I ask a query about partitions?

Our objective is to run a Debian Wheezy system as a data server using 
an LVM on top of 2 x 3TB discs in RAID-1 configuration.  A first 
attempt had the whole discs used for the data filesystem, using a 
single /dev/md(n), on whole unpartitioned disks.  We've dismantled 
that because of filesystem size problems (it had used only 2TB disks) 
and will make a second attempt and additionally, this time, we want to 
use the array for 3 purposes:

(a) Boot with Grub
(b) Hold the OS
(c) Use the remainder of the disk for the data server, on which we'll 
install an LVM and later grow that with another 2 x 3TB disks.

Assuming I am correct in needing something such as:

/dev/md0 for Grub, (and copied to both physical disks of the RAID-1)
/dev/md1 for the OS, and
/dev/md2 for the data files (on which we'll install the LVM)

then I think we need to partition our disks before creating the array. 
  Is that correct?

The wiki ( https://raid.wiki.kernel.org/index.php/Partition_Types , 
and https://raid.wiki.kernel.org/index.php/RAID_setup#General_setup ) 
is relatively silent on the 'numbers' of partitions that could or 
should be used, if creating a raid on new discs in the circumstances 
where boot 'partitions' and separate OS 'partitions' might be needed. 
  I couldn't see anything in man mdadm to guide me, either, but I 
could have missed something and apologies if I have.

Should I proceed to partition the disks, and then create 3 RAID-1 
arrays (one on each partition-pair), or should I use a different 
technique/layout to hold Grub, the OS, and an expandable LV for the 
datafiles?

I had always assumed that /dev/md(x) always mapped to /dev/sda(y), but 
I have a faint recollection that a discussion on the list a year or so 
ago had suggested that that mapping was not cast in stone, and 
multiple partitions on the physical devices were neither necessary nor 
desirable.  Grateful for any comment,  Ron

