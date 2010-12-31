From: Mark Knecht <markknecht@gmail.com>
Subject: Why does md3 persist after deleting and recreating the partitions?
Date: Thu, 30 Dec 2010 16:10:53 -0800
Message-ID: <AANLkTik9quhP_h-vWji8nex8QT6X+_Ss2_KQiVSr5AK6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   What am I forgetting to do? I had a RAID1 using sd{a,b,c}3. I
stopped md3, removed the md3 line in /etc/mdadm.conf, deleted the
partitions using fdisk, and then created 5 new partitions using
sd{a,b,c,d,e}3 to get ready to do a 5 disk RAID6. The new partitions
are the same size as the old ones and located at the same sector
addresses.

   After rebooting, but before creating the new RAID6, I still see md3:

mark@c2stable ~ $ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md6 : active raid1 sdb6[1] sdc6[2] sda6[0]
      247416933 blocks super 1.1 [3/3] [UUU]

md3 : active raid1 sdc3[2] sdb3[1] sda3[0]
      52436096 blocks [3/3] [UUU]

md5 : active raid1 sdc5[2] sdb5[1] sda5[0]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
mark@c2stable ~ $


   What am I doing wrong or forgetting? I would like md3 to be totally
gone before I create a new md3 in it's place.

Thanks,
Mark
