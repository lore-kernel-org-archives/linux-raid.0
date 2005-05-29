From: "Francisco Zafra" <fzafra@gmail.com>
Subject: Troubles making a raid5 system work.
Date: Sun, 29 May 2005 17:59:09 +0200
Message-ID: <4299e746.607b3ba2.6e4a.ffff9b64@mx.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
 
 This is my first message to the list, first at all, apologize about my
horrible english, I will try to do my best.
 I have 8 200GB new SATA HDs, my distro is  Ubuntu 5.04, mdadm v1.9.0 and
kernel 2.6.11.8.
 I create the array with the following config:
 
    mdadm --create --verbose /dev/md0 --chunk=512 --level=raid5
--raid-devices=8 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
/dev/sdg1 /dev/sdh1

 I also setup the /etc/mdadm/mdadm.conf

	root@Torero-2:/usr/src # cat /etc/mdadm/mdadm.conf 
	DEVICE /dev/sd[abcdefgh]1
	ARRAY /dev/md0 level=raid5 num-devices=8
UUID=f28b2043:a30358af:1c6d9640:49302af7
	
devices=/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sdd1,/dev/sdc1,/dev/sdb
1,/dev/sda1
	   auto=yes
 
This start creating the array that spent severals hour until /proc/mdstat
reports active array and it supposed to be ready to work, but my problem is
the following, after creating the array it began to do "strange things"...
When the create command finish proc/mdstats report the following:

	root@Torero-2:/usr/src # cat /proc/mdstat 
	Personalities : [linear] [raid5] 
	md0 : active raid5 sda1[0] sdh1[8] sdg1[6] sdf1[5] sde1[4] sdd1[3]
sdc1[9](F) sdb1[1]
      	1367507456 blocks level 5, 256k chunk, algorithm 2 [8/6] [UU_UUUU_]
      
	unused devices: <none>

All seems to be right here, bu I saw activity in the hdd led so i did a
mdadm --detail, an obtained this:

root@Torero-2:/usr/src # mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Tue May 24 20:02:28 2005
     Raid Level : raid5
     Array Size : 1367507456 (1304.16 GiB 1400.33 GB)
    Device Size : 195358208 (186.31 GiB 200.05 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun May 29 17:29:45 2005
          State : clean, degraded
 Active Devices : 6
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 256K

           UUID : f28b2043:a30358af:1c6d9640:49302af7
         Events : 0.48957213

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       0        0        -      removed
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       0        0        -      removed

       8       8      113        7      spare rebuilding   /dev/sdh1
       9       8       33        -      faulty   /dev/sdc1

Really strange, also cpu load is high... load average: 1.89, 1.87, 1.82. And
in the system logs I have thousands of messages like this, that not were
generating during the create command:

May 29 17:34:45 localhost kernel: .<6>md: syncing RAID array md0 May 29
17:34:45 localhost kernel: md: minimum _guaranteed_ reconstruction speed:
1000 KB/sec/disc.
May 29 17:34:45 localhost kernel: md: using maximum available idle IO
bandwith (but not more than 200000 KB/sec) for reconstruction.
May 29 17:34:45 localhost kernel: md: using 128k window, over a total of
195358208 blocks.
May 29 17:34:45 localhost kernel: md: md0: sync done.
May 29 17:34:45 localhost kernel: .<6>md: syncing RAID array md0 May 29
17:34:45 localhost kernel: md: minimum _guaranteed_ reconstruction speed:
1000 KB/sec/disc.
May 29 17:34:45 localhost kernel: md: using maximum available idle IO
bandwith (but not more than 200000 KB/sec) for reconstruction.
May 29 17:34:45 localhost kernel: md: using 128k window, over a total of
195358208 blocks.
May 29 17:34:45 localhost kernel: md: md0: sync done.

I really have to stop the array because the log files are really getting
HUGE. So I did a mdadm -S /dev/md0 ,so it stops the array and the generating
of the messages.
If I try to run the array again it have no effect...

root@Torero-2:/usr/src # mdadm -R /dev/md0      
mdadm: failed to run array /dev/md0: Invalid argument root@Torero-2:/usr/src
# mdadm -A /dev/md0
mdadm: /dev/md0 assembled from 6 drives and 1 spare - not enough to start
the array.
root@Torero-2:/usr/src # cat /proc/mdstat       
Personalities : [linear] [raid5]
md0 : inactive sda1[0] sdh1[8] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2]
sdb1[1]
      1562865664 blocks
unused devices: <none>
root@Torero-2:/usr/src # mdadm --detail /dev/md0
mdadm: md device /dev/md0 does not appear to be active.
root@Torero-2:/usr/src # mdadm -R /dev/md0      
mdadm: failed to run array /dev/md0: Invalid argument

I have tried this several times, I have even earsed and checked each drive
with:

	mdadm --zero-superblock /dev/sdd
	dd if=/dev/sdd of=/dev/null bs=1024k
	badblocks -svw /dev/sdd

But all is ok, the hardware (HDs) are fine... But when I tried to setup it
again I have the same problems.So it must be a config problem or a software
problem.

Anyone can help me with this raid? I am a little desperate...

Thanks to all in advance...

Paco Zafra.

PD: I sent this mail previusly from an unathorized mail account, I have wait
some minutes and I didn't saw it in the mail list so I resend it again. I
hope the mail didn't get repeated. 

