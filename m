From: Melinda Taylor <melinda@phys.unsw.edu.au>
Subject: Degraded raid5 returns mdadm: /dev/hdc5 has no superblock - assembly
 aborted
Date: Fri, 08 Jul 2005 12:26:20 +1000
Message-ID: <42CDE44C.9020804@phys.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello :)

We have a computer based at the South Pole which has a degraded raid 5 
array across 4 disks. One of the 4 HDD's mechanically failed but we have 
bought the majority of the system back online except for the raid5 
array. I am pretty sure that data on the remaining 3 partitions that 
made up the raid5 array is intact - just confused. The reason I know 
this is that just before we took the system down, the raid5 array 
(mounted as /home) was still readable and writable even though 
/proc/mdstat said:

*md2 : active raid5 hdd5[3] hdb5[2](F) hdc5[1] hda5[0](F)
     844809600 blocks level 5, 128k chunk, algorithm 2 [4/2] [_U_U] *

When I tried to turn on the raid5 set /dev/md2 after replacing the 
failed disk I saw the following errors:

Jul  8 12:35:28 planet kernel:  [events: 0000003b]
Jul  8 12:35:28 planet kernel:  [events: 00000000]
Jul  8 12:35:28 planet kernel: md: invalid raid superblock magic on hdc5
Jul  8 12:35:28 planet kernel: md: hdc5 has invalid sb, not importing!
Jul  8 12:35:28 planet kernel: md: could not import hdc5, trying to run 
array nevertheless.
Jul  8 12:35:28 planet kernel:  [events: 00000039]
Jul  8 12:35:28 planet kernel:  [events: 0000003b]
Jul  8 12:35:28 planet kernel: md: autorun ...
Jul  8 12:35:28 planet kernel: md: considering hdd5 ...
Jul  8 12:35:28 planet kernel: md:  adding hdd5 ...
Jul  8 12:35:28 planet kernel: md:  adding hdb5 ...
Jul  8 12:35:28 planet kernel: md:  adding hda5 ...
Jul  8 12:35:28 planet kernel: md: created md2
Jul  8 12:35:28 planet kernel: md: bind<hda5,1>
Jul  8 12:35:28 planet kernel: md: bind<hdb5,2>
Jul  8 12:35:28 planet kernel: md: bind<hdd5,3>
Jul  8 12:35:28 planet kernel: md: running: <hdd5><hdb5><hda5>
Jul  8 12:35:28 planet kernel: md: hdd5's event counter: 0000003b
Jul  8 12:35:28 planet kernel: md: hdb5's event counter: 00000039
Jul  8 12:35:28 planet kernel: md: hda5's event counter: 0000003b
Jul  8 12:35:28 planet kernel: md: superblock update time inconsistency 
-- using the most recent one
*Jul  8 12:35:28 planet kernel: md: freshest: hdd5*
Jul  8 12:35:28 planet kernel: md: kicking non-fresh hdb5 from array!
Jul  8 12:35:28 planet kernel: md: unbind<hdb5,2>
Jul  8 12:35:28 planet kernel: md: export_rdev(hdb5)
Jul  8 12:35:28 planet kernel: md: device name has changed from hdc5 to 
hda5 since last import!
Jul  8 12:35:28 planet kernel: md2: removing former faulty hda5!
Jul  8 12:35:28 planet kernel: md2: removing former faulty hdb5!
Jul  8 12:35:28 planet kernel: md: md2: raid array is not clean -- 
starting background reconstruction
Jul  8 12:35:28 planet kernel: md2: max total readahead window set to 1536k
Jul  8 12:35:28 planet kernel: md2: 3 data-disks, max readahead per 
data-disk: 512k
Jul  8 12:35:28 planet kernel: raid5: device hdd5 operational as raid disk 3
Jul  8 12:35:28 planet kernel: raid5: device hda5 operational as raid disk 1
*Jul  8 12:35:28 planet kernel: raid5: not enough operational devices 
for md2 (2/4 failed)*
Jul  8 12:35:28 planet kernel: RAID5 conf printout:
Jul  8 12:35:28 planet kernel:  --- rd:4 wd:2 fd:2
Jul  8 12:35:28 planet kernel:  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 
00:00]
Jul  8 12:35:28 planet kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hda5
Jul  8 12:35:28 planet kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 
00:00]
Jul  8 12:35:28 planet kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdd5
Jul  8 12:35:28 planet kernel: raid5: failed to run raid set md2
Jul  8 12:35:28 planet kernel: md: pers->run() failed ...
Jul  8 12:35:28 planet kernel: md :do_md_run() returned -22
Jul  8 12:35:28 planet kernel: md: md2 stopped.
Jul  8 12:35:28 planet kernel: md: unbind<hdd5,1>
Jul  8 12:35:28 planet kernel: md: export_rdev(hdd5)
Jul  8 12:35:28 planet kernel: md: unbind<hda5,0>
Jul  8 12:35:28 planet kernel: md: export_rdev(hda5)
Jul  8 12:35:28 planet kernel: md: ... autorun DONE.

I was googling for solutions and found the mdadm package and installed 
it and tried:

/*[root@planet mdadm-1.12.0]# mdadm --assemble --force /dev/md2 
/dev/hdd5 /dev/hda5 /dev/hdb5 /dev/hdc5
mdadm: no RAID superblock on /dev/hdc5
mdadm: /dev/hdc5 has no superblock - assembly aborted

*//dev/hdc is the new disk I have just installed to replace the failed 
one (/dev/hda). I have parititioned it correctly and in fact one 
partition on /dev/hdc1 is now happily part of another raid1 set on the 
system so I know all is good with /dev/hdc

My current  /proc/mdstat file looks like this (ie missing the raid5 set):
*
Personalities : [raid1] [raid5]
read_ahead 1024 sectors
md1 : active raid1 hdc2[0] hda2[1]
      10241344 blocks [2/2] [UU]
     
md0 : active raid1 hdc1[0] hda1[1]
      104320 blocks [2/2] [UU]
     
unused devices: <none>
*

Can anyone offer any suggestions as to how to get past the /*/dev/hdc5 
has no superblock */message?

The data has all been backed up so as a last resort I will rebuild the 
raid5 array from scratch but it would be nice to just reassemble it with 
data intact as I am sure /dev/hdd5 /dev/hdb5 and /dev/hda5 are actually 
all ok.

Many Thanks,

Melinda


/*


*/



