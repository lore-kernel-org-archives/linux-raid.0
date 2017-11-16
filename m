From: Larkin Lowrey <llowrey@gmail.com>
Subject: Arrays with journals read-only on boot
Date: Thu, 16 Nov 2017 16:29:17 -0500
Message-ID: <02c58752-6d35-1346-a1f6-587707ae1921@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a system with two arrays that have journals. When booting, the 
arrays assemble in read-only mode because the journal devices can't be 
found. The journal devices are in fact present and activated very early 
in the boot sequence. Since one of the arrays is root I end up at the 
dracut recovery shell. I am able to stop the arrays and assemble them 
successfully via 'mdadm --assemble --scan'.

Is it a bad idea to use md partitions for the journals? I initially used 
LVM volumes but the shutdown procedure didn't like that since it wanted 
to deactivate all LVs before stopping the arrays but couldn't since the 
arrays depended on the LVs. So, I moved the journals to md partitions so 
I didn't need to have multiple raid10 arrays (one per journal).

### journal devices are p3 and p4 below
md0: detected capacity change from 0 to 68652367872
md0: p1 p2 p3 p4

### much later in the boot...

md/raid:md2: journal disk is missing, force array readonly
md/raid:md2: raid level 6 active with 8 out of 8 devices, algorithm 2
md2: detected capacity change from 0 to 6000417177600

md/raid:md3: journal disk is missing, force array readonly
md/raid:md3: raid level 5 active with 9 out of 9 devices, algorithm 2
md3: detected capacity change from 0 to 64009348841472

dracut:/# mdadm --version
mdadm - v4.0-218-gfe05dc4 - 2017-11-09

dracut:/# cat /proc/mdstat
Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
md2 : active (read-only) raid6 sdv1[4] sdy1[7] sdu1[3] sdx1[6] sdw1[5] 
sdt1[2] sds1[1] sdr1[0]
       5859782400 blocks super 1.2 level 6, 128k chunk, algorithm 2 
[8/8] [UUUUUUUU]

md11 : active raid0 sdn1[0] sdi1[1]
       7813772288 blocks super 1.2 512k chunks

md10 : active raid0 sdm1[0] sdh1[1]
       7813772288 blocks super 1.2 512k chunks

md3 : active (read-only) raid5 md10[6] md11[7] sdg1[12] sdf1[11] sdq1[9] 
sdp1[13] sdl1[10] sdj1[8] sdo1[14]
       62509129728 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[9/9] [UUUUUUUUU]

md0 : active raid10 sda1[0] sdd1[3] sdc1[2] sdb1[1]
       67043328 blocks super 1.2 128K chunks 2 far-copies [4/4] [UUUU]

### I can stop and assemble the arrays just fine

dracut:/# mdadm --stop /dev/md2 /dev/md3
md2: detected capacity change from 6000417177600 to 0
md: md2 stopped.
mdadm: stopped /dev/md2
md3: detected capacity change from 64009348841472 to 0
md: md3 stopped.
mdadm: stopped /dev/md3

dracut:/# mdadm --assemble --scan
md: md2 stopped.
md/raid:md2: device sdr1 operational as raid disk 0
md/raid:md2: device sdy1 operational as raid disk 7
md/raid:md2: device sdx1 operational as raid disk 6
md/raid:md2: device sdw1 operational as raid disk 5
md/raid:md2: device sdv1 operational as raid disk 4
md/raid:md2: device sdu1 operational as raid disk 3
md/raid:md2: device sdt1 operational as raid disk 2
md/raid:md2: device sds1 operational as raid disk 1
md/raid:md2: raid level 6 active with 8 out of 8 devices, algorithm 2
md2: detected capacity change from 0 to 6000417177600
mdadm: /dev/md/2 has been started with 8 drives and 1 journal.
md: md3 stopped.
md/raid:md3: device md11 operational as raid disk 0
md/raid:md3: device sdp1 operational as raid disk 8
md/raid:md3: device sdl1 operational as raid disk 7
md/raid:md3: device sdg1 operational as raid disk 6
md/raid:md3: device sdf1 operational as raid disk 5
md/raid:md3: device sdo1 operational as raid disk 4
md/raid:md3: device sdj1 operational as raid disk 3
md/raid:md3: device sdq1 operational as raid disk 2
md/raid:md3: device md10 operational as raid disk 1
md/raid:md3: raid level 5 active with 9 out of 9 devices, algorithm 2
md3: detected capacity change from 0 to 64009348841472
mdadm: /dev/md/3 has been started with 9 drives and 1 journal.

Kernel: 4.13.12-100.fc25.x86_64

--Larkin
