From: Jacob Madsen <jacob@mungo.dk>
Subject: Incative RAID5 (it should be active)
Date: Sat, 12 Aug 2006 17:01:57 +0200
Message-ID: <44DDED65.10500@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey

I only have 4 sata slots in my computer and i have a raid5 array of 
partitions on those 4 disks.

Today i needed a free sata slots, so i unplugged one of the disks and 
booted with knoppix. I then did some work, turned of the computer and 
plugged in the disk again.

I should say that i didnt use the array while using knoppix, so 
everything should be intact.

I then expected to be able to hotadd the missing partition and use the 
array as usual. But its inactive:

# mdadm --detail /dev/md8
mdadm: md device /dev/md8 does not appear to be active.

# cat /proc/mdstat
md8 : inactive sda10[1] sdd10[4] sdc10[3] sdb10[2]
      545791744 blocks

I then stopped the array:
# mdadm -S /dev/md8
mdadm: stopped /dev/md8

And tryed to assemble it:
# mdadm --verbose --assemble /dev/md8 /dev/sda10 /dev/sdb10 /dev/sdc10 
/dev/sdd10
mdadm: looking for devices for /dev/md8
mdadm: /dev/sda10 is identified as a member of /dev/md8, slot 1.
mdadm: /dev/sdb10 is identified as a member of /dev/md8, slot 2.
mdadm: /dev/sdc10 is identified as a member of /dev/md8, slot 3.
mdadm: /dev/sdd10 is identified as a member of /dev/md8, slot 4.
mdadm: no uptodate device for slot 0 of /dev/md8
mdadm: added /dev/sdb10 to /dev/md8 as 2
mdadm: added /dev/sdc10 to /dev/md8 as 3
mdadm: added /dev/sdd10 to /dev/md8 as 4
mdadm: added /dev/sda10 to /dev/md8 as 1
mdadm: /dev/md8 assembled from 2 drives and 1 spare - not enough to 
start the array.

The last line indicate something is wrong, but i have no idea what to 
do. (i still expect all the data to be intact)

Any good ideas will be appreciated alot!

/Jacob
