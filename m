From: Andread Mayrhoff <repro@spoilbase.eu>
Subject: Help needed: array inactive after grow attempt
Date: Thu, 28 Apr 2016 21:27:53 +0200
Message-ID: <1d5a8c36a6802a9e7e32eb056165f200@spoilbase.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I believe I need some help from an mdadm expert.

I tried to add a disk to an existing RAID5-array (/dev/md127) that 
consisted of 5 disks: /dev/sd[bcdef]1
The system is a 4.5.2-2-kernel, x86_64-architecture, mdadm 3.3.1.
I attempted to add partition /dev/sdg1 to that array, in an attempt to 
create a 6-disk-RAID5-array.
To achieve that goal, I typed "mdadm --add /dev/md127 /dev/sdg1".
As I found that working, I attempted to grow the array by typing "mdadm 
--grow /dev/md127 --raid-devices=6".

I left my machine, and when I returned, I found it had been switched off 
by my... ahem, anyway, it had been switched off.

I powered it on again, "cat /proc/mdstat" returned

>> 
Personalities : [raid6] [raid5] [raid4]
md127 : inactive sdg1[9](S) sdf1[8](S) sdc1[5](S) sdb1[6](S) sde1[4](S) 
sdd1[7](S)
       17578345656 blocks super 1.0

unused devices: <none>
<<

mdadm --detail /dev/md127 returns

>> 
/dev/md127:
         Version : 1.0
      Raid Level : raid0
   Total Devices : 6
     Persistence : Superblock is persistent

           State : inactive

   Delta Devices : 1, (-1->0)
       New Level : raid5
      New Layout : left-symmetric
   New Chunksize : 128K

            Name : n54l:raid5.11111111.eu
            UUID : b120f4d9:d1ba5648:e1359c5d:7a36372e
          Events : 60868

     Number   Major   Minor   RaidDevice

        -       8       17        -        /dev/sdb1
        -       8       33        -        /dev/sdc1
        -       8       49        -        /dev/sdd1
        -       8       65        -        /dev/sde1
        -       8       81        -        /dev/sdf1
        -       8       97        -        /dev/sdg1
<<

Now, before I do anything extreme like unplugging that disk again or 
forcing a recreate, could an expert suggest the next logical step I 
should do. I know this sounds pretty defensive, but rather than playing 
"Raid-hero with an erased set of disks" I'd go along with "Raid-idiot 
that needed experts' advice which is why he still's got all his data".

Thanks for your advice!



