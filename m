From: AndyLiebman@aol.com
Subject: What does "kicking non-fresh partition from array" mean?
Date: Fri, 23 Jan 2004 12:56:51 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4a.26fcff87.2d42ba63@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all, 

Can somebody tell me if some log warnings I'm seeing are worrisome?   Does 
"kicking non-fresh scsi/host4/bus0/target1/lun0/part1 from array!" refer to md4 
or md6? 

As you can see from cat /proc/mdstat, I have a failed removed drive in md6 -- 
which I am about to replace. Does this "kicking out" from the Kernel Warnings 
log refer to md4 or md6? 

FROM KERNEL WARNINGS LOG:
I see this every time I reboot

Jan 20 09:04:50 localhost kernel: md: device name has changed from 
scsi/host2/bus0/target1/lun0/part1 to scsi/host2/bus0/target0/lun0/part1 since last 
import!
Jan 20 09:04:50 localhost kernel:    8regs     :  1828.800 MB/sec
Jan 20 09:04:50 localhost kernel:    32regs    :  1248.000 MB/sec
Jan 20 09:04:50 localhost kernel:    pII_mmx   :  2568.000 MB/sec
Jan 20 09:04:50 localhost kernel:    p5_mmx    :  2561.600 MB/sec
Jan 20 09:04:50 localhost kernel: raid5: using function: pII_mmx (2568.000 
MB/sec)
Jan 20 09:04:50 localhost kernel: raid5: raid level 5 set md4 active with 5 
out of 5 devices, algorithm 2
Jan 20 09:04:50 localhost kernel: RAID5 conf printout:
Jan 20 09:04:50 localhost kernel:  --- rd:5 wd:5 fd:0
Jan 20 09:04:50 localhost kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 
dev:scsi/host1/bus0/target0/lun0/part1
Jan 20 09:04:50 localhost kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 
dev:scsi/host2/bus0/target0/lun0/part1
Jan 20 09:04:50 localhost kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 
dev:scsi/host5/bus0/target0/lun0/part1
Jan 20 09:04:50 localhost kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 
dev:scsi/host3/bus0/target0/lun0/part1
Jan 20 09:04:50 localhost kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 
dev:scsi/host4/bus0/target0/lun0/part1
Jan 20 09:04:50 localhost kernel: RAID5 conf printout:
Jan 20 09:04:50 localhost kernel:  --- rd:5 wd:5 fd:0
Jan 20 09:04:50 localhost kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 
dev:scsi/host1/bus0/target0/lun0/part1
Jan 20 09:04:50 localhost kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 
dev:scsi/host2/bus0/target0/lun0/part1
Jan 20 09:04:50 localhost kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 
dev:scsi/host5/bus0/target0/lun0/part1
Jan 20 09:04:50 localhost kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 
dev:scsi/host3/bus0/target0/lun0/part1
Jan 20 09:04:50 localhost kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 
dev:scsi/host4/bus0/target0/lun0/part1
Jan 20 09:04:51 localhost kernel: md: kicking non-fresh 
scsi/host4/bus0/target1/lun0/part1 from array!
Jan 20 09:04:51 localhost kernel: md: device name has changed from 
scsi/host2/bus0/target0/lun0/part1 to scsi/host2/bus0/target1/lun0/part1 since last 
import!
Jan 20 09:04:51 localhost kernel: RAID5 conf printout:
Jan 20 09:04:51 localhost kernel:  --- rd:5 wd:4 fd:1
Jan 20 09:04:51 localhost kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 
dev:scsi/host1/bus0/target1/lun0/part1
Jan 20 09:04:51 localhost kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 
dev:scsi/host2/bus0/target1/lun0/part1
Jan 20 09:04:51 localhost kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 
dev:scsi/host3/bus0/target1/lun0/part1
Jan 20 09:04:51 localhost kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 
00:00]
Jan 20 09:04:51 localhost kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 
dev:scsi/host5/bus0/target1/lun0/part1
Jan 20 09:04:51 localhost kernel: RAID5 conf printout:
Jan 20 09:04:51 localhost kernel:  --- rd:5 wd:4 fd:1
Jan 20 09:04:51 localhost kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 
dev:scsi/host1/bus0/target1/lun0/part1
Jan 20 09:04:51 localhost kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 
dev:scsi/host2/bus0/target1/lun0/part1
Jan 20 09:04:51 localhost kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 
dev:scsi/host3/bus0/target1/lun0/part1
Jan 20 09:04:51 localhost kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 
00:00]
Jan 20 09:04:51 localhost kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 
dev:scsi/host5/bus0/target1/lun0/part1
