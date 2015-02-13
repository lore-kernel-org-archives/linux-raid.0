From: gary <gary.mdjiang@gmail.com>
Subject: mdadm failed to remove internal bitmap
Date: Fri, 13 Feb 2015 17:46:46 +0800
Message-ID: <54DDC806.5010803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I used v3.3.1 mdadm to do some test for bitmap, but when switch bitmap from
internal to none, the output shows fail info about remove internal 
bitmap, is it
just a warning? Since the bitmap seems to be cleared, and it doesn't 
show with
v3.2.6 mdadm with the same steps.

linux:~ # mdadm --create md0 --raid-devices=2 --level=mirror 
--assume-clean /dev/vdb /dev/vdc
mdadm: Note: this array has metadata at the start and
     may not be suitable as a boot device.  If you plan to
     store '/boot' on this device please ensure that
     your boot-loader understands md/v1.x metadata, or use
     --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/md0 started.
linux:~ # cat /proc/mdstat
Personalities : [raid1]
md127 : active raid1 vdc[1] vdb[0]
       523712 blocks super 1.2 [2/2] [UU]

unused devices: <none>
linux:~ # mdadm --grow --bitmap=internal /dev/md127
linux:~ # cat /proc/mdstat
Personalities : [raid1]
md127 : active raid1 vdc[1] vdb[0]
       523712 blocks super 1.2 [2/2] [UU]
       bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>
linux:~ # mdadm --grow --bitmap=none /dev/md127
mdadm: failed to remove internal bitmap.
linux:~ # cat /proc/mdstat
Personalities : [raid1]
md127 : active raid1 vdc[1] vdb[0]
       523712 blocks super 1.2 [2/2] [UU]

unused devices: <none>

Thanks,
Gary
