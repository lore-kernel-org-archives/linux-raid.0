From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Reduce number of active RAID1 devices
Date: Mon, 30 Jan 2012 19:40:01 +0100
Message-ID: <4F26E401.6000205@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have a 4-device RAID1 set (with one device missing), which I want to 
bring down to two active devices and a spare.

When I try to do so with the latest mdadm on my current kernel, it fails 
simply with "mdadm: failed to set raid disks".

root@zotac:~# mdadm /dev/md0 --grow --raid-devices=2
mdadm: failed to set raid disks
root@zotac:~# mdadm /dev/md0 --grow --raid-devices=2 -x 1
mdadm: option -x not valid in grow mode
root@zotac:~# mdadm -V
mdadm - v3.2.3 - 23rd December 2011
root@zotac:~# uname -a
Linux zotac 2.6.35-32-generic #64-Ubuntu SMP Tue Jan 3 00:47:07 UTC 2012 
x86_64 GNU/Linux
root@zotac:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md1 : active raid1 sdb3[3] sde2[2] sdd2[0]
       487861824 blocks [4/3] [U_UU]

md0 : active raid1 sdb2[3] sde1[2] sdd1[0]
       521984 blocks [4/3] [U_UU]

unused devices: <none>


Is it possible to do this without taking the array offline?

Thank you.
