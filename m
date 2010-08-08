From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: md's fail to assemble correctly consistently at system startup -
 mdadm 3.1.2 and Ubuntu 10.04
Date: Sat, 7 Aug 2010 18:27:58 -0700
Message-ID: <AANLkTinQgx1t0eaXuFKLnf+5PBw1AqJpyYfxo-AvZXQf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I am facing a serious issue with md's on my Ubuntu 10.04 64-bit
server. I am using mdadm 3.1.2. The system has 40 drives in it, and
there are 10 md devices, which are a combination of RAID 0, 1, 5, 6,
and 10 levels. The drives are connected via LSI SAS adapters in
external SAS JBODs.

When I boot the system, about 50% of the time, the md's will not come
up correctly. Instead of md0-md9 being active, some or all will be
inactive and there will be new md's like md127, md126, md125, etc.

Here is the output of /proc/mdstat when all md's come up correctly:


Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid6 sdj1[6] sdk1[7] sdf1[2] sdb1[10] sdg1[3] sdl1[8](S)
sdh1[4] sdm1[9] sde1[1] sdi1[12](S) sdc1[11] sdd1[0]
      1146967040 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/10] [UUUUUUUUUU]

md9 : active raid0 sdao1[1] sdan1[0]
      976765440 blocks super 1.2 256k chunks

md8 : active raid0 sdam1[1] sdal1[0]
      976765440 blocks super 1.2 256k chunks

md7 : active raid0 sdak1[1] sdaj1[0]
      976765888 blocks super 1.2 4k chunks

md6 : active raid0 sdai1[1] sdah1[0]
      976765696 blocks super 1.2 128k chunks

md5 : active raid0 sdag1[1] sdaf1[0]
      976765440 blocks super 1.2 256k chunks

md4 : active raid0 sdae1[1] sdad1[0]
      976765888 blocks super 1.2 32k chunks

md3 : active raid1 sdac1[1] sdab1[0]
      195357272 blocks super 1.2 [2/2] [UU]

md2 : active raid0 sdaa1[0] sdz1[1]
      62490672 blocks super 1.2 4k chunks

md1 : active raid5 sdy1[10] sdx1[9] sdw1[8] sdv1[7] sdu1[6] sdt1[5]
sds1[4] sdr1[3] sdq1[2] sdp1[11](S) sdo1[1] sdn1[0]
      2929601120 blocks super 1.2 level 5, 16k chunk, algorithm 2
[11/11] [UUUUUUUUUUU]

unused devices: <none>


--------------------------------------------------------------------------------------------------------------------------


Here are several examples of when they do not come up correctly.
Again, I am not making any configuration changes; I just reboot the
system and check /proc/mdstat several minutes after it is fully
booted.


Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md124 : inactive sdam1[1](S)
      488382944 blocks super 1.2

md125 : inactive sdag1[1](S)
      488382944 blocks super 1.2

md7 : active raid0 sdaj1[0] sdak1[1]
      976765888 blocks super 1.2 4k chunks

md126 : inactive sdw1[8](S) sdn1[0](S) sdo1[1](S) sdu1[6](S)
sdq1[2](S) sdx1[9](S)
      1757761512 blocks super 1.2

md9 : active raid0 sdan1[0] sdao1[1]
      976765440 blocks super 1.2 256k chunks

md6 : inactive sdah1[0](S)
      488382944 blocks super 1.2

md4 : inactive sdae1[1](S)
      488382944 blocks super 1.2

md8 : inactive sdal1[0](S)
      488382944 blocks super 1.2

md127 : inactive sdg1[3](S) sdl1[8](S) sdc1[11](S) sdi1[12](S)
sdf1[2](S) sdb1[10](S)
      860226027 blocks super 1.2

md5 : inactive sdaf1[0](S)
      488382944 blocks super 1.2

md1 : inactive sdr1[3](S) sdp1[11](S) sdt1[5](S) sds1[4](S)
sdy1[10](S) sdv1[7](S)
      1757761512 blocks super 1.2

md0 : inactive sde1[1](S) sdh1[4](S) sdm1[9](S) sdj1[6](S) sdd1[0](S) sdk1[7](S)
      860226027 blocks super 1.2

md3 : inactive sdab1[0](S)
      195357344 blocks super 1.2

md2 : active raid0 sdaa1[0] sdz1[1]
      62490672 blocks super 1.2 4k chunks

unused devices: <none>


---------------------------------------------------------------------------------------------------------------------------


Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md126 : inactive sdaf1[0](S)
      488382944 blocks super 1.2

md127 : inactive sdae1[1](S)
      488382944 blocks super 1.2

md9 : active raid0 sdan1[0] sdao1[1]
      976765440 blocks super 1.2 256k chunks

md7 : active raid0 sdaj1[0] sdak1[1]
      976765888 blocks super 1.2 4k chunks

md4 : inactive sdad1[0](S)
      488382944 blocks super 1.2

md6 : active raid0 sdah1[0] sdai1[1]
      976765696 blocks super 1.2 128k chunks

md8 : active raid0 sdam1[1] sdal1[0]
      976765440 blocks super 1.2 256k chunks

md5 : inactive sdag1[1](S)
      488382944 blocks super 1.2

md0 : active raid6 sdc1[11] sdd1[0] sdh1[4] sdf1[2] sdm1[9] sde1[1]
sdb1[10] sdg1[3] sdl1[8](S) sdj1[6] sdk1[7] sdi1[12](S)
      1146967040 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/10] [UUUUUUUUUU]

md1 : active raid5 sdq1[2] sdy1[10] sdv1[7] sdn1[0] sdt1[5] sdw1[8]
sdp1[11](S) sdr1[3] sdu1[6] sdx1[9] sdo1[1] sds1[4]
      2929601120 blocks super 1.2 level 5, 16k chunk, algorithm 2
[11/11] [UUUUUUUUUUU]

md3 : active raid1 sdac1[1] sdab1[0]
      195357272 blocks super 1.2 [2/2] [UU]

md2 : active raid0 sdz1[1] sdaa1[0]
      62490672 blocks super 1.2 4k chunks

unused devices: <none>


--------------------------------------------------------------------------------------------------------------------------


Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md127 : inactive sdab1[0](S)
      195357344 blocks super 1.2

md4 : active raid0 sdad1[0] sdae1[1]
      976765888 blocks super 1.2 32k chunks

md7 : active raid0 sdak1[1] sdaj1[0]
      976765888 blocks super 1.2 4k chunks

md8 : active raid0 sdam1[1] sdal1[0]
      976765440 blocks super 1.2 256k chunks

md6 : active raid0 sdah1[0] sdai1[1]
      976765696 blocks super 1.2 128k chunks

md9 : active raid0 sdao1[1] sdan1[0]
      976765440 blocks super 1.2 256k chunks

md5 : active raid0 sdaf1[0] sdag1[1]
      976765440 blocks super 1.2 256k chunks

md1 : active raid5 sdy1[10] sdv1[7] sdu1[6] sds1[4] sdq1[2]
sdp1[11](S) sdt1[5] sdo1[1] sdx1[9] sdr1[3] sdw1[8] sdn1[0]
      2929601120 blocks super 1.2 level 5, 16k chunk, algorithm 2
[11/11] [UUUUUUUUUUU]

md0 : active raid6 sdl1[8](S) sdd1[0] sdc1[11] sdg1[3] sdk1[7] sde1[1]
sdm1[9] sdb1[10] sdi1[12](S) sdh1[4] sdf1[2] sdj1[6]
      1146967040 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/10] [UUUUUUUUUU]

md3 : inactive sdac1[1](S)
      195357344 blocks super 1.2

md2 : active raid0 sdz1[1] sdaa1[0]
      62490672 blocks super 1.2 4k chunks

unused devices: <none>



My mdadm.conf file is as follows:


# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays

# This file was auto-generated on Sun, 13 Jul 2008 20:42:57 -0500
# by mkconf $Id$




Any insight would be greatly appreciated. This is a big problem as it
is now. Thank you very much in advance!

Best,
-Tommy
