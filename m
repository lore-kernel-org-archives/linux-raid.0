From: =?ISO-8859-1?Q?Jean-Yves_Mert=E8s?= <jym@skynet.be>
Subject: mdadm problem
Date: Mon, 06 Dec 2004 10:37:52 +0100
Message-ID: <41B42870.7050207@skynet.be>
Reply-To: jym@skynet.be
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I do not know if I may receive any support about mdadm through this 
e-mail address. If not, please, could you forward this message to the 
appropriate box if one exists.

I am currently trying to migrate a Linux partition (Mandrake 10) to RAID 
1. To this purpose I have installed mdadm V1.8.1. The first attempt was 
to configure an equally-sized partition of my second disk (/dev/hdb) as 
part of a degraded RAID 1 device. Unfortunately, starting the array 
fails. The following shows pieces of information that should help  
understanding the case:

The command I use is:
mdadm -C /dev/md0 --metadata=1 --level=raid1 --raid-devices=2 missing 
/dev/hdb5 -v

To which mdadm answers:
mdadm: /dev/hdb5 appears to contain an ext2fs file system
    size=4843912K  mtime=Thu Dec  2 17:11:54 2004
mdadm: /dev/hdb5 appears to be part of a raid array:
    level=1 devices=2 ctime=Sat Dec  4 18:28:46 2004
mdadm: size set to 4843904K
Continue creating array? y
VERS = 9000
mdadm: ADD_NEW_DISK for /dev/hdb5 failed: Invalid argument

Running cat /proc/mdstat, it appears that the array has not been 
started, despite it (and the corresponding superblock) seems having been 
created:
/dev/hdb5:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 67458b6bc6:237b3269:983c6473:483366
           Name :
  Creation Time : Sat Dec  4 18:45:49 2004
     Raid Level : raid1
   Raid Devices : 2

    Device Size : 9687808 (4.62 GiB 4.96 GB)
   Super Offset : 9687808 sectors
    Device UUID : 67458b6bc6:237b3269:983c6473:483366
    Update Time : Sat Dec  4 18:45:49 2004
       Checksum : b1fb29ae - correct
         Events : 1


   Array State : _U 383 spares


Checking the log files, here is what I found:
Dec  4 18:45:49 localhost kernel: md: invalid raid superblock magic on hdb5
Dec  4 18:45:49 localhost kernel: md: hdb5 has invalid sb, not importing!
Dec  4 18:45:49 localhost kernel: md: md_import_device returned -22

So I tried to start the array by means of the -A switch together with an 
/etc/mdadm.conf file I filled in manually:
mdadm -A -s /dev/md0 -v

Here is the result:
mdadm: looking for devices for /dev/md0
Segmentation fault

A look at the log files gives:
Dec  4 19:01:41 localhost kernel: md: md0 stopped.

This log appears very strange to me since the array was not running ;-)

I have not succeeded in finding some directions to understand the 
problem. I hope someone could help me.

Best regards.

Jean-Yves MERTES
