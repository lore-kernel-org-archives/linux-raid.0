From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: unbalanced RAID5 / performance issues
Date: Mon, 20 Jun 2016 16:33:17 +1000
Message-ID: <57678E2D.9080705@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have a RAID5 array which consists of 8 x Intel 480GB SSD, single 
partition on each covering 100% of the drive.

md1 : active raid5 sde1[7] sdc1[11] sdd1[10] sdb1[12] sdg1[9] sdh1[5] 
sdf1[8] sda1[6]
       3281935552 blocks super 1.2 level 5, 64k chunk, algorithm 2 [8/8] 
[UUUUUUUU]

/dev/md1:
         Version : 1.2
   Creation Time : Wed Aug 22 00:47:03 2012
      Raid Level : raid5
      Array Size : 3281935552 (3129.90 GiB 3360.70 GB)
   Used Dev Size : 468847936 (447.13 GiB 480.10 GB)
    Raid Devices : 8
   Total Devices : 8
     Persistence : Superblock is persistent

     Update Time : Mon Jun 20 16:02:10 2016
           State : active
  Active Devices : 8
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            Name : san1:1  (local to host san1)
            UUID : 707957c0:b7195438:06da5bc4:485d301c
          Events : 2092476

     Number   Major   Minor   RaidDevice State
        7       8       65        0      active sync   /dev/sde1
        6       8        1        1      active sync   /dev/sda1
        8       8       81        2      active sync   /dev/sdf1
        5       8      113        3      active sync   /dev/sdh1
        9       8       97        4      active sync   /dev/sdg1
       12       8       17        5      active sync   /dev/sdb1
       10       8       49        6      active sync   /dev/sdd1
       11       8       33        7      active sync   /dev/sdc1

I'm finding that the underlying disk utilisation is "uneven" ie, one or 
two disks is used a lot more heavily than the others. This is best seen 
with iostat:
iostat -x -N /dev/sd? 5
This will show 5 second averages... so we should expect the average 
utilisation of all disks to be equal ( I expect, I am probably wrong).
Ignoring the first output, since that is values since the system was 
booted, I've copied three sample from after that.
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s wkB/s avgrq-sz 
avgqu-sz   await r_await w_await  svctm  %util
sdf             128.00   194.00   86.80  141.20   897.70 1289.60    
19.19     0.04    0.18    0.16    0.20   0.13   2.96
sdh             110.80   138.60   83.40  139.20   808.80 1063.20    
16.82     0.08    0.34    0.21    0.42   0.31   6.96
sde             120.80   162.00   90.60  117.80   866.40 1073.60    
18.62     0.09    0.42    0.12    0.65   0.38   7.84
sdb             141.80   184.60  110.60  130.60  1104.30 1219.20    
19.27     0.04    0.15    0.14    0.16   0.11   2.64
sda             126.00   153.80   89.80  120.40   921.00 1048.00    
18.73     0.13    0.61    0.14    0.96   0.57  12.08
sdg             132.20   168.40  113.00  122.80  1037.60 1116.80    
18.27     0.05    0.21    0.28    0.15   0.15   3.60
sdd             122.20   180.80   99.80  135.60   958.40 1219.20    
18.50     0.04    0.16    0.20    0.13   0.10   2.40
sdc             112.80   178.60   87.40  115.20   824.00 1128.80    
19.28     0.17    0.85    0.43    1.17   0.75  15.20

sdf              97.00   147.80  107.40  139.80   911.30 1084.00    
16.14     0.04    0.15    0.14    0.15   0.11   2.72
sdh             104.80   139.20   99.00  133.60   901.60 1024.00    
16.56     0.03    0.13    0.15    0.12   0.10   2.24
sde              97.60   124.00   98.20  109.40   889.60 868.00    
16.93     0.03    0.15    0.08    0.21   0.12   2.48
sdb              91.80   144.60   96.00  117.00   839.80 983.20    
17.12     0.03    0.13    0.15    0.12   0.12   2.48
sda              73.80   106.40   94.80  120.00   762.20 837.60    
14.90     0.12    0.58    0.10    0.95   0.55  11.76
sdg              97.00   143.80  104.80  114.60   894.50 968.80    
16.99     0.06    0.29    0.11    0.45   0.28   6.16
sdd              88.40   140.80   93.00  121.00   770.90 980.00    
16.36     0.09    0.41    0.16    0.61   0.40   8.56
sdc              92.60   137.00   94.40  106.20   830.70 908.00    
17.33     0.21    1.07    0.48    1.59   0.90  18.00

sdf              71.60   138.60   91.60  137.40   813.80 1040.00    
16.19     0.08    0.33    0.12    0.47   0.30   6.96
sdh              87.20   137.20   99.20  124.60   927.10 983.20    
17.07     0.03    0.14    0.21    0.08   0.12   2.64
sde              85.40   126.60   84.20  102.20   830.50 850.40    
18.04     0.02    0.08    0.11    0.05   0.06   1.12
sdb              90.40   153.00   94.40  117.00   907.40 1019.20    
18.23     0.02    0.11    0.13    0.10   0.08   1.68
sda              77.60   134.40   84.40  121.40   813.10 958.40    
17.22     0.13    0.65    0.13    1.01   0.62  12.72
sdg             101.80   140.60  109.20  112.20  1038.30 946.40    
17.93     0.06    0.28    0.22    0.34   0.25   5.44
sdd              90.00   131.20   83.40  111.20   810.60 907.20    
17.65     0.02    0.11    0.12    0.10   0.07   1.36
sdc              85.40   136.00   83.00  101.80   817.70 888.80    
18.47     0.23    1.27    0.61    1.81   1.13  20.80


As you can see, sdc (and sda) has a much higher utilisation compared to 
all the other drives, but we can see the actual reads/writes are similar 
across all drives.

Trying to find/explain the differences in performance, I originally 
assumed one drive was being "targeted" more heavily, perhaps due to a 
bad configuration (eg, chunk size, resulting in all filesystem 
read/write on the same physical disk (plus checksum)).

However, it also seems that one drive is a different model:
sda: Model Family:     Intel 520 Series SSDs
sdb: Model Family:     Intel 520 Series SSDs
sdc: Model Family:     Intel 530 Series SSDs
sdd: Model Family:     Intel 520 Series SSDs
sde: Model Family:     Intel 520 Series SSDs
sdf: Model Family:     Intel 520 Series SSDs
sdg: Model Family:     Intel 520 Series SSDs
sdh: Model Family:     Intel 520 Series SSDs

The disk sector sizes:
512 bytes logical/physical across all disks/drives.

Except we see that sda is the same model as the rest and also seems to 
be affected, though not as much as sdc.

So, should I try to swap sdc with another drive of the same model (520 
series)?
Is there something else I can do to better optimise the array?
Should I migrate to RAID50 with 12 drives, or RAID10 with 16 drives 
(which would also add 480G capacity)?
Would moving to RAID6 help (I doubt it)?
I don't think there is a single threaded CPU issue, since using top and 
watching each individual CPU, I don't see the idle reduce to zero), plus 
rsync is using most CPU not the md1_raid5 thread.
Should I use a smaller chunk size to better "spread" the load across the 
disks? Would a value of 4k be better (the minimum value permitted 
apparently)? Or would it be better to go the other way, and increase the 
chunk size even more (I think this would help with throughput, but not 
so random workload like we are getting).

Some other details that might be relevant:
Linux san1 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4 
(2016-02-29) x86_64 GNU/Linux

free
              total       used       free     shared    buffers cached
Mem:       7902324    3287360    4614964    1203468     196836 2440864
-/+ buffers/cache:     649660    7252664
Swap:      3939324      23436    3915888

vmstat doesn't show anything for si or so, so RAM doesn't seem to be a 
problem

I'm using lvm on top of the md1 device, and each LV is used by DRBD, 
which is then exported with iSCSI to another linux box, and then used as 
the block device for Xen Windows machines.

Any other suggestions on where to look, or additional information I 
should provide?

Regards,
Adam

-- 
Adam Goryachev
Website Managers
P: +61 2 8304 0000                    adam@websitemanagers.com.au
F: +61 2 8304 0001                     www.websitemanagers.com.au

