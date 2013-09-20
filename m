From: John <linux_mailing@internode.on.net>
Subject: Raid 5 Array 3/4 Drives non-fresh
Date: Fri, 20 Sep 2013 22:36:21 +1000
Message-ID: <523C4145.7000502@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Plugged in some buggy usb hardware and it did bad things to my kernel
INFO: task khubd:27 blocked for more than 120 seconds.
After reset realized all 3 of my md arrays got a bit upset by my usb 
device! :-(

1 rebuilt, the other is  rebuilding now (they only lost 1 disk each)
The third one below is a bit beyond my limited skills! I think I need to 
re-create the array but would like some help in doing so.. as I really 
don't want to trash it through incompetence..

  md: kicking non-fresh sdj from array!
  md: unbind<sdj>
  md: export_rdev(sdj)
  md: kicking non-fresh sdh from array!
  md: unbind<sdh>
  md: export_rdev(sdh)
  md: kicking non-fresh sdk from array!
  md: unbind<sdk>
  md: export_rdev(sdk)
  md/raid:md2: device sdi operational as raid disk 1
  md/raid:md2: allocated 4280kB
  md/raid:md2: not enough operational devices (3/4 failed)
  RAID conf printout:
  --- level:5 rd:4 wd:1
   disk 1, o:1, dev:sdi
  md/raid:md2: failed to run raid set.
  md: pers->run() failed ...


Tried
mdadm --assemble /dev/md2 --scan

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
[raid1] [raid10]
md2 : inactive sdi[6](S) sdk[4](S) sdj[5](S) sdh[0](S)
       7814054240 blocks super 1.2

md0 : active raid5 sdn[2] sdo[1] sdm[4] sdf[5]
       2197720128 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] 
[UUUU]

md1 : active raid5 sdb[5] sdc[1] sdd[4] sda[2]
       2930284224 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/3] 
[_UUU]
       [=======>.............]  recovery = 35.8% (350218368/976761408) 
finish=200.6min speed=52048K/sec

then

mdadm --assemble /dev/md2 --scan --force

All members came up as spares

mdadm --stop /dev/md2

ARRAY /dev/md2 metadata=1.2 name=storagepc:raid-2tb 
UUID=73ea3bd2:50b609a1:768a7e19:ca3ef9f0
/dev/sdh Active Device 0 AA.. Event 203528
/dev/sdi Active device 1 .A.. Event 203552
/dev/sdj Active device 2 AAAA Event 203522
/dev/sdk Active device 3 AAAA Event 203522

I am running
dd if=/dev/xxx of=/dev/null bs=1M
across all the /dev/md2 drives in case there is something more than the 
just the kernel hang that caused this

The entire array is one lvm volume.. would appreciate any help to 
reassemble!


Kind Regards,

John
