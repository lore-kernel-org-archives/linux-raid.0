From: Christian Deufel <christian.deufel@inview.de>
Subject: Re: Reassembling Raid5 in degraded state
Date: Tue, 14 Jan 2020 12:28:06 +0100
Message-ID: <13b11d17-a23a-3063-70cb-de63d9fa7d09@inview.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Wols Lists <antlists@youngman.org.uk>
List-Id: linux-raid.ids

Hey Wol

 > My plan now would be to run mdadm --assemble --force /dev/md3 with 3
 > disk, to get the Raid going in a degraded state.

 >Yup, this would almost certainly work. I would recommend overlays and
 >running a fsck just to check it's all okay before actually doing it on
 >the actual disks. The event counts say to me that you'll probably lose
 >little to nothing.

So as I was trying to reassemble my Raid it crashed again. But this time 
sdc vanished.

I get the following output:

[root@dirvish ~]# mdadm --stop /dev/md3
mdadm: stopped /dev/md3
[root@dirvish ~]# mdadm --assemble --force /dev/md3 /dev/sdc1 /dev/sdd1 
/dev/sdf            1
mdadm: forcing event count in /dev/sdc1(2) from 5995154 upto 5995162
mdadm: clearing FAULTY flag for device 0 in /dev/md3 for /dev/sdc1
mdadm: failed to add /dev/sdc1 to /dev/md3: Invalid argument
mdadm: /dev/md3 assembled from 2 drives - not enough to start the array.

and when I checked with fdisk sdc wasn't there anymore.

[root@dirvish ~]# fdisk -l

Disk /dev/sda: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          13      104391   fd  Linux raid 
autodetect
/dev/sda2              14         535     4192965   fd  Linux raid 
autodetect
/dev/sda3             536       30401   239898645   fd  Linux raid 
autodetect

Disk /dev/sdb: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1          13      104391   fd  Linux raid 
autodetect
/dev/sdb2              14         535     4192965   fd  Linux raid 
autodetect
/dev/sdb3             536       30401   239898645   fd  Linux raid 
autodetect

Disk /dev/sdd: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdd1   *           1      243201  1953512001   fd  Linux raid 
autodetect

Disk /dev/sde: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sde1   *           1      243201  1953512001   fd  Linux raid 
autodetect

Disk /dev/sdf: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1      243201  1953512001   83  Linux

...

After a reboot of the system sdc was back again but vanished again after 
I retried the assembly.

Would the assembly also work with my 4th HDD, sde1 although in the mdadm 
--eaxmine it is labeld as spare?

Greetings

Christian
