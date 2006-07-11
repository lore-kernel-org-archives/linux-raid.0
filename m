From: Vladimir Strycek <vladoportos@vladoportos.sk>
Subject: Problem with 3xRAID1 to RAID 0
Date: Tue, 11 Jul 2006 09:41:31 +0200
Message-ID: <44B3562B.7040801@vladoportos.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I created to 3 x /dev/md1 to /dev/md3  which consist of six identical 
200GB hdd

my mdadm --detail --scan looks like

Proteus:/home/vladoportos# mdadm --detail --scan
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=d1fadb29:cc004047:aabf2f31:3f044905
   devices=/dev/sdb,/dev/sda
ARRAY /dev/md2 level=raid1 num-devices=2 UUID=38babb4d:92129d4a:94d659f1:3b238c53
   devices=/dev/sdc,/dev/sdd
ARRAY /dev/md3 level=raid1 num-devices=2 UUID=a0406e29:c1f586be:6b3381cf:086be0c2
   devices=/dev/sde,/dev/sdf
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=c04441d4:e15d900e:57903584:9eb5fea6
   devices=/dev/hdc1,/dev/hdd1


and mdadm.conf

DEVICE partitions
ARRAY /dev/md4 level=raid0 num-devices=3 UUID=1c8291ba:2d83cf54:2698ce30:e49b1e6c
   devices=/dev/md1,/dev/md2,/dev/md3
ARRAY /dev/md3 level=raid1 num-devices=2 UUID=a0406e29:c1f586be:6b3381cf:086be0c2
   devices=/dev/sde,/dev/sdf
ARRAY /dev/md2 level=raid1 num-devices=2 UUID=38babb4d:92129d4a:94d659f1:3b238c53
   devices=/dev/sdc,/dev/sdd
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=d1fadb29:cc004047:aabf2f31:3f044905
   devices=/dev/sda,/dev/sdb
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=c04441d4:e15d900e:57903584:9eb5fea6
   devices=/dev/hdc1,/dev/hdd1



as you can see i created than from md1-3 RAID0 - md4 its works fine... 
but i cant get it again after reboot i need to create it again...

I dont get it why it wont creat at boot...  any body had similar problem ?

Thanks for help and best regard
Vladimir
